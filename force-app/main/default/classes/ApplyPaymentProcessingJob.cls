/**
 * Owner: Cloud Lending Solutions
 * Description: Following job helps in Apply the Payments which created 
 *              during PNCInvoicePaymentProcessing job.
 * 
 **/
global with sharing class ApplyPaymentProcessingJob extends clcommon.DynamicJob {
	
    private static String query;
    private static final String JOB_NAME = 'Apply Payments Processing Job';

    global ApplyPaymentProcessingJob() {
        super(JOB_NAME, initialize(null));
    }
    
    global ApplyPaymentProcessingJob(List<String> contractNames) {
        super(JOB_NAME, initialize(contractNames));
    }
    
    global virtual override String getRuntimeQuery() {
        System.debug(LoggingLevel.ERROR, 'ApplyPaymentProcessingJob query in getRuntimeQuery : ' + query);
        return query; 
    }

    public static String initialize(List<String> contractNames) {

      query =   ' SELECT Id, Name,                           '+
                '   cllease__Contract__c,                    '+
                '   cllease__Cleared__c                      '+
                ' FROM cllease__Lease_Payment_Transaction__c '+ 
                ' WHERE cllease__Cleared__c = false          '+
                '   AND cllease__Rejected__c = false         '+
                '   AND cllease__Contract__r.cllease__Invalid_Data__c = false ';

        if(contractNames!=null && contractNames.size() > 0) {
            String contractNamesStr = '';
            for (String contractName : contractNames) {
              contractNamesStr = contractNamesStr + '\'' + String.escapeSingleQuotes(contractName) + '\'' + ',';
            }
            contractNamesStr = contractNamesStr.substring(0, contractNamesStr.length() - 1);
            query += ' AND cllease__Contract__r.Name in ('+ contractNamesStr + ')';
        }

        query += ' ORDER BY cllease__Transaction_Date__c ';
        
        System.debug(LoggingLevel.ERROR, 'ApplyPaymentProcessingJob Query: '+query);
        return query;
    }
    
    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {
          
        Savepoint sp = database.setsavepoint();
        try {
            List<cllease__Lease_Payment_Transaction__c> paymentsToApply 
            	= (List<cllease__Lease_Payment_Transaction__c>)scope;
            applyPayments(paymentsToApply);

        } catch(Exception e) {
            database.rollback(sp);   
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());      
            //insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name='ApplyPaymentProcessingJob',
                                                    cllease__Date__c=system.today(),
                                                    cllease__Message__c='Error is '+e.getMessage()
                                                        +' in line number: '+ e.getLineNumber());
        }
    }

    // Apply payments which created during the PNCInvoicePaymentProcessing.
    private void applyPayments(List<cllease__Lease_Payment_Transaction__c> pmtsToApply) {

        Set<Id> pmtIds = new Set<Id>();
        // 1. Looping all payments to get IDs
        for(cllease__Lease_Payment_Transaction__c pmt : pmtsToApply) {
            pmtIds.add(pmt.Id);
        }

        // 2. Querying all payments with required details
        List<cllease__Lease_Payment_Transaction__c> paymentTransactionList = 
                        [SELECT id, name,
                                cllease__Contract__c,
                                cllease__Contract__r.Id,
                                cllease__Contract__r.Name,
                                cllease__Contract__r.cllease__Lease_Status__c,
                                cllease__Contract__r.cllease__Lease_Product_Name__c,
                                cllease__Contract__r.cllease__Lease_Product_Name__r.cllease__Lease_Product_Type__c,
                                cllease__Contract__r.cllease__Payment_Frequency__c,
                                cllease__Contract__r.cllease__current_payment_amount__c,
                                cllease__Contract__r.cllease__Next_Due_Date__c ,
                                cllease__Contract__r.cllease__Term__c,
                                cllease__Contract__r.cllease__Payment_Spread__c,
                                cllease__Contract__r.cllease__Termination_Quote_accepted_flag__c,
                                cllease__Lease_Snapshot__c,
                                cllease__Fee_Snapshot__c,
                                cllease__Dues_Snapshot__c,
                                cllease__Cash_Balances_Snapshot__c,
                                cllease__Balance_s_Snapshot__c,
                                cllease__Custom_Logic__c,
                                cllease__Receipt_Id__c,
                                cllease__Transaction_Date__c,
                                cllease__Transaction_Time__c,
                                cllease__Early_Total_Repayment_of_the_Lease__c,
                                cllease__Write_Off_Recovery_Payment__c,
                                cllease__Payment_Mode__c,
                                cllease__Payment_Mode__r.Name,
                                cllease__Transaction_Amount__c,
                                cllease__Cleared__c,
                                cllease__Manual_Payment__c,
                                cllease__Fees__c,
                                cllease__Receivable_Billed__c,
                                cllease__Evergreen_Receivable_Billed__c,
                                cllease__Tax_Billed__c,
                                cllease__Excess__c,
                                cllease__Total_Charges_Principal__c,
                                cllease__Other_Charges_Principal__c,
                                cllease__Late_Charge_Principal__c,
                                cllease__Charge__c,
                            	cllease__Bill__c
                            FROM cllease__Lease_Payment_Transaction__c
                            WHERE Id IN :pmtIds
                            order by cllease__Transaction_Date__c]; 
        
        // 3. Calling CL Lease Global API to Apply Payments
        cllease.BulkLeasePaymentAction dAction = new cllease.BulkLeasePaymentAction(paymentTransactionList);
        dAction.postPayments();
    }

    public override void doInitialize() { }
    public override void doStart(Database.BatchableContext bc) { }   
    public override void doFinish(Database.BatchableContext bc) { 
        // Query  Int_Batch_Status__c for first "Ready" on "Px Remit"  and update as completed.
        List<Int_Batch_Status__c> remitBatchStatusRecords = [SELECT Id, Name, Status__c, Completed__c
                                                                FROM Int_Batch_Status__c
                                                                WHERE Name = 'Px Remit' 
                                                                    AND Status__c = 'Ready'
                                                                ORDER BY createdDate desc];
        // Should only update first remit record as InitiateCLSReceiptJobsTrigger will trigger for first record.
        if(remitBatchStatusRecords.size() > 0) {
            Int_Batch_Status__c remitBatchStatusRecord = remitBatchStatusRecords.get(0);
            remitBatchStatusRecord.Status__c = DLLNewCoConstants.BATCH_STATUS_COMPLETED;
            remitBatchStatusRecord.Completed__c = true;
            update remitBatchStatusRecord;
        }
        
    }
}