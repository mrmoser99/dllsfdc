/**
 * Owner: Cloud Lending Solutions
 * Description: Following job helps in creating the NSF charges on receiving the PNC NSF Charges
 *  manual Script:
    List<String> pxNSFRecords = new List<String>{'NSF-00000153'};
    PNCLptReversalAndNSFChargeCreatorJob job = new PNCLptReversalAndNSFChargeCreatorJob(pxNSFRecords);
    Database.executeBatch(job, 1);
 *     
 **/
global with sharing class PNCLptReversalAndNSFChargeCreatorJob extends clcommon.DynamicJob {
    
    private static String query;
    private static final String JOB_NAME = 'PNC NSF Charges Creation Job';
    private clcommon__Fee_Definition__c nsfFeeDefinition; 
    
    public class MyException extends Exception{}

    global PNCLptReversalAndNSFChargeCreatorJob() {
        super(JOB_NAME, initialize(null));
        doInitialize();
    }
    
    global PNCLptReversalAndNSFChargeCreatorJob(List<String> pncNSFChargeRecordNames) {
        super(JOB_NAME, initialize(pncNSFChargeRecordNames));
        doInitialize();
    }
    
    global virtual override String getRuntimeQuery() {
        System.debug(LoggingLevel.ERROR, 'PNCLptReversalAndNSFChargeCreatorJob query in getRuntimeQuery : ' + query);
        return query; 
    }

    public static String initialize(List<String> pncNSFChargeRecordNames) {

        // 3. Querying PNC Response Object : Int_PX_NSF__c for payments creation
        // Following query skips the first record of PNC Payment which is for BATCH HEADER
        query = ' SELECT Id, Name,            '+
                '   Account_Num__c,           '+
                '   Committed__c,             '+
                '   Date__c,                  '+
                '   Invoice_Number__c,        '+
                '   Line_Data__c,             '+
                '   NSF_Amount__c,            '+
                '   Remark__c                 '+
                ' FROM Int_PX_NSF__c          '+
                ' WHERE Committed__c = false  ';


        if(pncNSFChargeRecordNames!=null && pncNSFChargeRecordNames.size() > 0) {
            String pncNSFReturnRecordNamesStr = '';
            for (String pncReturnRecordName : pncNSFChargeRecordNames) {
              pncNSFReturnRecordNamesStr = pncNSFReturnRecordNamesStr + '\'' + String.escapeSingleQuotes(pncReturnRecordName) + '\'' + ',';
            }
            pncNSFReturnRecordNamesStr = pncNSFReturnRecordNamesStr.substring(0, pncNSFReturnRecordNamesStr.length() - 1);
            query += ' AND Name IN ('+ pncNSFReturnRecordNamesStr + ')';
        }

        query += ' ORDER BY Date__c ';
        
        System.debug(LoggingLevel.ERROR, 'PNCNSFChargeCreatorJob query in getRuntimeQuery : ' + query);
        return query;
    }
    
    /**
     * Following execute method helps in creating NSF Charge  Transactions For PNC NSF Record and mark committed = true
     *      a. Creating NSF Charge for Each Invoice number from PNC NSF Record in Contract
     *      b. Update PNC NSF Return record as commited with reason.
     **/
    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {
         
        Map<string, List<Int_PX_NSF__c>> multPxNSFMap   = new Map<string, List<Int_PX_NSF__c>>();
        List<Int_PX_NSF__c> updatepxNSFRecList          = new List<Int_PX_NSF__c>();
        List<cllease__Charge__c> nsfChargesToInsert     = new List<cllease__Charge__c>();
        // To create reversal for all lease payment transaction in order to do it we need to collect all lpt's which has 
        // invoice id that can be taken form list of NSF transaction taken for processing.
        List<cllease__Repayment_Transaction_Adjustment__c> newReversalTxns = new List< cllease__Repayment_Transaction_Adjustment__c>();
        Set<Id> invoiceIds = new Set<Id>();

        Savepoint sp = database.setsavepoint();
        try {

            List<Int_PX_NSF__c> pxNSFRecordList = (List<Int_PX_NSF__c>)scope;
            
            // A. Looping all PNC return records to consolidate all related PNC Return records with total amount
            for(Int_PX_NSF__c pxNSFRec: pxNSFRecordList) {
                // Validations
                // 1. NSF Remit file cannot process if Invoice Number null.
                if(pxNSFRec.Invoice_Number__c == null) {
                    pxNSFRec.Remark__c = ' PX NSF Record doesnot have invoice Number to process...';
                    updatepxNSFRecList.add(pxNSFRec);
                    continue; 
                }   
                if(pxNSFRec.NSF_Amount__c <= 0) {
                    pxNSFRec.Remark__c = ' PX NSF Record NSF Amount should be more than zero amount to process...';
                    updatepxNSFRecList.add(pxNSFRec);
                    continue; 
                }
                // a. Consolidating all PNC Return records per Invoice Number
                List<Int_PX_NSF__c> pxNSFTempList = multPxNSFMap.get(pxNSFRec.Invoice_Number__c);
                if(pxNSFTempList == null) {
                    pxNSFTempList = new List<Int_PX_NSF__c>();
                }
                pxNSFTempList.add(pxNSFRec);
                multPxNSFMap.put(pxNSFRec.Invoice_Number__c, pxNSFTempList);
            }
            
            System.debug(LoggingLevel.ERROR, 'multPxNSFMap.keyset() : ' + multPxNSFMap.keyset());

            // B. Querying all invoices with charges where invoices with Bills and Charges
            List<Invoice__c> invoicesList = [SELECT Id, Name, LS_Contract__c, LS_Contract__r.cllease__Next_Due_Date__c 
                                                FROM Invoice__c 
                                                WHERE Name IN :multPxNSFMap.keyset()
                                                AND LS_Contract__c != Null];
            for(Invoice__c invoice : invoicesList){
                invoiceIds.add(invoice.Id);
            }
            
            // C. Collecting all lpt created for invoices which are to be reversed
            List<cllease__Lease_Payment_Transaction__c> lpts = [SELECT ID, 
                                                                    NAME, 
                                                                    cllease__Contract__c,
                                                                    cllease__Transaction_Amount__c 
                                                                    FROM cllease__Lease_Payment_Transaction__c
                                                                    WHERE For_Invoice__c IN : invoiceIds
                                                                    AND cllease__Reversed__c = False];
            System.debug(LoggingLevel.ERROR, 'lpts : ' + lpts);
            
            // D. Creating payment reversal of all scope invoices lpts
            for(cllease__Lease_Payment_Transaction__c lpt:lpts){
                cllease__Repayment_Transaction_Adjustment__c reversalTxn = new cllease__Repayment_Transaction_Adjustment__c(
                                                                                cllease__Lease_Payment_Transaction__c = lpt.Id,
                                                                                cllease__LS_Contract__c = lpt.cllease__Contract__c,
                                                                                cllease__Adjusted_Amount__c = lpt.cllease__Transaction_Amount__c,
                                                                                cllease__Adjustment_Txn_Date__c  = cllease.SystemDateUtil.getCurrentSystemDate(),
                                                                                cllease__Reason_Code__c = 'NSF');
                newReversalTxns.add(reversalTxn);
            }
            
            // E. Insert all the reversal txn
            if(newReversalTxns.size()>0){
                insert newReversalTxns;
            }
            System.debug(LoggingLevel.ERROR, '^^^^ newReversalTxns : ' + newReversalTxns);
            // Process all reversals.
            cllease.IBulkPaymentReversalAction dAction = new cllease.BulkRepaymentAdjustmentAction(newReversalTxns);
            dAction.postRepaymentsAdjusment();

            // F. Looping through all Invoices for Creating Payment Transactions in System
            for(Invoice__c invoice : invoicesList) {
                // Looping all PNC Return files per Invoices to apply payments
                for(Int_PX_NSF__c pxNSFRec : multPxNSFMap.get(invoice.Name)) {
                    // 1. Create charge for PNCNSF Record
                    cllease__Charge__c nsfCharge            = new cllease__Charge__c();
                    nsfCharge.cllease__Fee_Definition__c    = nsfFeeDefinition.id;
                    nsfCharge.cllease__Date__c              = invoice.LS_Contract__r.cllease__Next_Due_Date__c;
                    nsfCharge.cllease__Lease_Account__c     = invoice.LS_Contract__c;
                    nsfCharge.cllease__Original_Amount__c   = pxNSFRec.NSF_Amount__c;
                   // nsfCharge.PX_NSF_Record__c                = pxNSFRec.Id;
                    nsfCharge.cllease__GL_Transaction_Flag__c = true;
                    nsfCharge.cllease__Tax_Processed__c     = 'Tax Not Calculated';
                    
                    nsfChargesToInsert.add(nsfCharge);

                    // 2. PX NSF Records update
                    pxNSFRec.Committed__c   = true;
                    pxNSFRec.Remark__c      = 'NSF Charge Created Successfully';
                    updatepxNSFRecList.add(pxNSFRec);
                }
            }
        
            System.debug(LoggingLevel.ERROR,'NSF Charges Created:'+nsfChargesToInsert);
        
            // G. DML Operations on New Payments
            if(nsfChargesToInsert.size() > 0) {
                insert nsfChargesToInsert;
            }

            // H. Updating PNC Return records for processing "Committed__c = true"
            if(updatepxNSFRecList.size()>0) {
                update updatepxNSFRecList;
            }
            //throw new MyException('Test');
        } catch(Exception e) {
            database.rollback(sp);   
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());      
            //insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name='PNCNSFChargeCreatorJob ', cllease__Date__c = system.today(), 
            cllease__Message__c='Error is '+e.getMessage() + ' in line number: '+ e.getLineNumber());
        }
    }
    
    public override void doInitialize() { }

    public override void doStart(Database.BatchableContext bc) { 
        // Retrieving NSF Fee Definition from System
        List<clcommon__Fee_Definition__c> feeDefinitions = [SELECT Id, Name FROM clcommon__Fee_Definition__c WHERE name = :DLLNewCoConstants.FEE_NSF LIMIT 1];
        System.debug(LoggingLevel.ERROR, '^^^^ feeDefinitions : ' + feeDefinitions);
        if(feeDefinitions.size() == 0) {
            throw new CLSCustomException('No NSF Fees Definition not available in CL Lease System. Please Verify...');
        } else if(feeDefinitions.size() > 1){
            throw new CLSCustomException('There are more than one  NSF Fees Definition available in CL Lease System. Please Verify...');
        } 

        // assinging NSF Fee defintions
        nsfFeeDefinition = feeDefinitions.get(0);
        
    }   

    public override void doFinish(Database.BatchableContext bc) { }

}