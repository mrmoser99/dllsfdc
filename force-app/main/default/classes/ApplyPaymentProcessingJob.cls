/**
 * Owner: Cloud Lending Solutions
 * Description: Following job helps in Apply the Payments which created 
 *              during PNCInvoicePaymentProcessing job.
 * 
 **/
global with sharing class ApplyPaymentProcessingJob extends clcommon.DynamicJob {
    
    private static String query;
    private static final String JOB_NAME = 'Apply Payments Processing Job';
    public Map<String, Id> commonPaymentModesMap;
    String onAccountPaymentMode = 'ON ACCOUNT';

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
        doInitialize();
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
        Set<Id> craIds = new Set<Id>();
        Set<Id> pmtIds = new Set<Id>();
        Set<Id> crIds = new Set<Id>();
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
                                cllease__Bill__c,
                                cllease__Cash_Application__c 
                            FROM cllease__Lease_Payment_Transaction__c
                            WHERE Id IN :pmtIds
                            order by cllease__Transaction_Date__c]; 
        
        // 3. Calling CL Lease Global API to Apply Payments
        Savepoint sp = database.setsavepoint();
        try{
            cllease.BulkLeasePaymentAction dAction = new cllease.BulkLeasePaymentAction(paymentTransactionList);
            dAction.postPayments();
        } catch(Exception e){
            database.rollback(sp);   
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());
            throw e;
        }
        
        // 4. After payment processing we need to move the applied amount to zero in the cash recipt as we are moving the over applied 
        // amount to onAccount
        for(cllease__Lease_Payment_Transaction__c lpt : paymentTransactionList){
            craIds.add(lpt.cllease__Cash_Application__c);
        }
        
        Map<Id, clcommon__Cash_Receipt_Application__c> crApplications = new Map<Id, clcommon__Cash_Receipt_Application__c>([SELECT ID, 
                                                                                    clcommon__Cash_Receipt__c,
                                                                                    clcommon__Allocated_Amount__c,
                                                                                    clcommon__Unused_Amount__c,
                                                                                    clcommon__Receipt_Application_Status__c 
                                                                                FROM clcommon__Cash_Receipt_Application__c
                                                                                WHERE Id IN : craIds
                                                                                AND clcommon__Unused_Amount__c > 0]);
        System.debug(LoggingLevel.ERROR, '^^^^ crApplications : ' + crApplications);
       
        if(crApplications.keySet().size() > 0){
            for(clcommon__Cash_Receipt_Application__c cra : crApplications.values()){
                crIds.add(cra.clcommon__Cash_Receipt__c);
            }
            
            Map<Id, clcommon__Cash_Receipt__c> crMap = new Map<Id, clcommon__Cash_Receipt__c>([SELECT ID,
                                                                                                        clcommon__Account__c,
                                                                                                        clcommon__Receipt_Date__c,
                                                                                                        clcommon__Unused_Amount__c
                                                                                                    FROM clcommon__Cash_Receipt__c
                                                                                                    WHERE Id IN : crIds]);
            List<clcommon__Cash_Receipt_Application__c> craToUpdate = new List<clcommon__Cash_Receipt_Application__c>();
            List<clcommon__Cash_Receipt__c> crToUpdate = new List<clcommon__Cash_Receipt__c>();
            List<clcommon__Cash_Receipt__c> newCr = new List<clcommon__Cash_Receipt__c>();
            for(cllease__Lease_Payment_Transaction__c lpt : paymentTransactionList){
                if(crApplications.containsKey(lpt.cllease__Cash_Application__c)){
                    clcommon__Cash_Receipt_Application__c crApplication = crApplications.get(lpt.cllease__Cash_Application__c);
                    System.debug(LoggingLevel.ERROR, '^^^^ crApplication : ' + crApplication);
                    if(crApplication.clcommon__Unused_Amount__c != null && crApplication.clcommon__Unused_Amount__c > 0){
                        clcommon__Cash_Receipt__c cr = crMap.get(crApplication.clcommon__Cash_Receipt__c);
                        if(cr.clcommon__Unused_Amount__c == crApplication.clcommon__Unused_Amount__c){
                            clcommon__Cash_Receipt__c cashReceipt = new clcommon__Cash_Receipt__c();
                            cashReceipt.clcommon__Account__c = cr.clcommon__Account__c;
                            cashReceipt.clcommon__Payment_Mode__c = commonPaymentModesMap.get(onAccountPaymentMode);
                            cashReceipt.clcommon__Receipt_Date__c = lpt.cllease__Transaction_Date__c;
                            cashReceipt.clcommon__Receipt_Amount__c = cr.clcommon__Unused_Amount__c;
                            cashReceipt.clcommon__Creation_Date__c  = lpt.cllease__Transaction_Date__c;
                            cashReceipt.clcommon__Unused_Amount__c =  cr.clcommon__Unused_Amount__c;
                            cashReceipt.clcommon__Receipt_Status__c = 'CREATED';
                            cashReceipt.Payment_Transaction__c = lpt.Id;
                            newCr.add(cashReceipt);
                            cr.clcommon__Unused_Amount__c = 0;
                            cr.clcommon__Receipt_Status__c = 'APPLIED';
                            crToUpdate.add(cr);
                        }
                        crApplication.clcommon__Unused_Amount__c = 0;
                        craToUpdate.add(crApplication);
                    }
            	}
            }
            // Committing all records
            if(craToUpdate.size()>0)
            	Update craToUpdate;
            if(crToUpdate.size()>0)
            	Update crToUpdate;
            if(newCr.size()>0)
            	Insert newCr;
        }
    }

    public override void doInitialize() { 
        // Common payment mode for cash receipt
        List<clcommon__Payment_Mode__c > commonPaymentModes = [SELECT Id, Name 
                                                            FROM clcommon__Payment_Mode__c 
                                                            LIMIT 100];
        
        commonPaymentModesMap = new Map<String, Id>();                                                    
        for(clcommon__Payment_Mode__c paymentMode : commonPaymentModes) {
            commonPaymentModesMap.put(paymentMode.Name, paymentMode.Id);
        }
        System.debug(LoggingLevel.ERROR, '^^^^ commonPaymentModesMap : ' + commonPaymentModesMap);
    }
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