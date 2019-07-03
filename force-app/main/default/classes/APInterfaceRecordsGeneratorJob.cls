/**
 *  Owner: Cloud Lending Solutions
 *  Description: Following APInterfaceRecordsGeneratorJob generats the AP Interface Records from
 *                  a. Dealer Funding Transactions (Pay to Dealer for Equipment)
 *                        Grouping Criteria: << Dealer Name , Invoice Number >>
 *                  b. Disbursement Transactions (Pay to Vendor) 
 *   Note:
 *      1. Following are valid for Passthrough for DLLNewCo Usecase
 *          Fee Type = Service Fee (Only fee which valid for Passthrough)
 *          Passthrough Options: (On Partial Payment with 0(zero) withhold amount)            
 *
 **/
global with sharing class APInterfaceRecordsGeneratorJob  extends clcommon.DynamicJob {
       
    private static String query;
    private static final String JOB_NAME = 'AP Interface Records Generator Job';

    global APInterfaceRecordsGeneratorJob() {
        super(JOB_NAME, initialize(null));
    }
    
    global APInterfaceRecordsGeneratorJob(List<String> contractNames) {
        super(JOB_NAME, initialize(contractNames));
    }
    
    global virtual override String getRuntimeQuery() {
        System.debug(LoggingLevel.ERROR, 'APInterfaceRecordsGeneratorJob query in getRuntimeQuery : ' + query);
        return query; 
    }

    public static String initialize(List<String> contractNames) {
        
        query = ' SELECT Id, Name '+
                ' FROM cllease__Lease_Account__c '+
                ' WHERE cllease__Lease_Status__c in (\'ACTIVE - GOOD STANDING\',\'ACTIVE - BAD STANDING\')';

        if(contractNames!=null && contractNames.size() > 0) {
            String contractNamesStr = '';
            for (String contractName : contractNames) {
              contractNamesStr = contractNamesStr + '\'' + String.escapeSingleQuotes(contractName) + '\'' + ',';
            }
            contractNamesStr = contractNamesStr.substring(0, contractNamesStr.length() - 1);
            query += ' AND Name in ('+ contractNamesStr + ')';
        }
        
        System.debug(LoggingLevel.ERROR, 'APInterfaceRecordsGeneratorJob query in initialize : ' + query);
        return query;
    }

    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {

        // Get Contract Ids to create AP Interface Records
        Set<Id> contractIds = new Set<Id>();        
        for(SObject s : scope){
           contractIds.add(s.id);
        }
        System.debug(LoggingLEVEL.ERROR, 'Picked Contrcts:'+ contractIds);
        processDealerFundingTransactions(contractIds);
        processDisbursementTransactions(contractIds);
    }

    private void processDealerFundingTransactions(Set<Id> contractIds) {
        //to store the list of AP interface records to be created
        list<Int_OLMN_AP__c> intsAPObjectsToInsert = new list<Int_OLMN_AP__c>();   
        Map<Id, cllease__Other_Transaction__c> dealerFundTxnsToUpdate = new Map<Id, cllease__Other_Transaction__c>();     
        Savepoint sp = database.setsavepoint();        
        try{
            //query all OLTs which need to be processed and limiting one GL Accounting Entry
            Map<Id, cllease__Other_Transaction__c> dealerFundingTxns = 
                new Map<Id, cllease__Other_Transaction__c>([ SELECT Id, Name,
                                                    cllease__Lease_Account__r.Name,
                                                    Invoice_Number__c, 
                                                    Invoice_Date__c, 
                                                    cllease__Txn_Date__c,
                                                    cllease__Txn_Amt__c,
                                                    cllease__GL_Process_Date__c,
                                                    cllease__Dealer_Name__c,
                                                    cllease__Dealer_Name__r.Oracle_Vendor_ID__c,
                                                    cllease__Description__c,
                                                    Int_OLMN_AP_link__c, 
                                                    (SELECT Id, Name, 
                                                            Movement_Code_DR_Segment__c,
                                                            Movement_Code_CR_Segment__c
                                                        FROM cllease__GL_Transaction_Detail__r
                                                        LIMIT 1)
                                                FROM cllease__Other_Transaction__c 
                                                WHERE cllease__Transaction_Type__c = 'DEALER FUNDING' 
                                                    AND ( AP_Processing_Status__c = 'New' 
                                                            OR AP_Processing_Status__c = null
                                                        )
                                                    AND cllease__Lease_Account__c IN :contractIds
                                                    ORDER BY cllease__Txn_Date__c desc]);

            // just return incase if ther are no records
            if(dealerFundingTxns.size() == 0) {
                return;
            }
        
            String remark = '';
            Int_OLMN_AP__c olmnAP;
            Map<String, List<cllease__Other_Transaction__c>> groupingDealerFundTxnsMap
                = new Map<String, List<cllease__Other_Transaction__c>>();
            Map<String, Decimal> dealerAmountMap = new Map<String, Decimal>();

            System.debug(LoggingLevel.ERROR, '---Total Dealer Funding Transactions: '+dealerFundingTxns.size());
            // grouping DealerFunding Transcations
            for(cllease__Other_Transaction__c dealerFundingTxn : dealerFundingTxns.values()) {
                System.debug(LoggingLevel.ERROR, '---processing Dealer Funding Transaction: '+dealerFundingTxn.Name);
                String dealerCriteria = dealerFundingTxn.cllease__Dealer_Name__c +':'+dealerFundingTxn.Invoice_Number__c;
                List<cllease__Other_Transaction__c> temp = groupingDealerFundTxnsMap.get(dealerCriteria);
                if (temp == null) {
                    temp = new List<cllease__Other_Transaction__c>();
                    dealerAmountMap.put(dealerCriteria, 0);
                }
                temp.add(dealerFundingTxn);
                groupingDealerFundTxnsMap.put(dealerCriteria, temp);
                Decimal dealerFundAmount = dealerFundingTxn.cllease__Txn_Amt__c != null ? dealerFundingTxn.cllease__Txn_Amt__c : 0;
                dealerAmountMap.put(dealerCriteria, dealerFundAmount + dealerAmountMap.get(dealerCriteria));
            }

            Int_OLMN_AP__c debitEntry;

            Datetime currentSystemNow = System.now();
            // Looping through DealerFunding Transactions to create Entries
            for(String dealerGroupTxn : groupingDealerFundTxnsMap.keySet()) {             
                // Taking one Dealer Funding Transction to create Consolidated for DLL
                List<cllease__Other_Transaction__c> groupedTxns = groupingDealerFundTxnsMap.get(dealerGroupTxn);
                if(groupedTxns != null && groupedTxns.size() > 0) {
                    cllease__Other_Transaction__c dealerFundingTxn = groupedTxns.get(0);
                    if(dealerFundingTxn.cllease__GL_Transaction_Detail__r.size() > 0) {
                        cllease__GL_Transaction_Detail__c glEntry = dealerFundingTxn.cllease__GL_Transaction_Detail__r.get(0);
                        // List of validations
                        // a) Validations on fields
                        Boolean validationSuccess = true;
                        if(dealerFundingTxn.cllease__Dealer_Name__c == null
                            || dealerFundingTxn.cllease__Dealer_Name__r.Oracle_Vendor_ID__c == null) {
                            remark = 'Oracle Vendor ID missing';
                            validationSuccess = false;
                        }
                        // b) 
                        if(dealerFundingTxn.cllease__Txn_Date__c == null) {
                            remark = 'Dealer Funding Transaction Date is Missing';
                            validationSuccess = false;
                        }
                        // d)
                        if(dealerFundingTxn.cllease__GL_Process_Date__c == null) {
                            remark = 'GL Trasaction Date is Missing';
                            validationSuccess = false;
                        }

                        if(dealerFundingTxn.Invoice_Number__c == null) {
                            remark = 'Invoice Number is Missing';
                            validationSuccess = false;
                        }

                        if(validationSuccess) {
                            Datetime txnDate    = dealerFundingTxn.cllease__Txn_Date__c;
                            txnDate = txnDate.addHours(currentSystemNow.hour());
                            txnDate = txnDate.addMinutes(currentSystemNow.minute());
                            txnDate = txnDate.addSeconds(currentSystemNow.second());
                            string txnDateStr   = txnDate.format('yyyyMMdd'); 

                            Datetime invoiceDate    = dealerFundingTxn.Invoice_Date__c;
                            invoiceDate = invoiceDate.addHours(currentSystemNow.hour());
                            invoiceDate = invoiceDate.addMinutes(currentSystemNow.minute());
                            invoiceDate = invoiceDate.addSeconds(currentSystemNow.second());
                            string invoiceDateStr   = invoiceDate.format('yyyyMMdd');  

                            Datetime glDate    = dealerFundingTxn.cllease__GL_Process_Date__c;
                            glDate = glDate.addHours(currentSystemNow.hour());
                            glDate = glDate.addMinutes(currentSystemNow.minute());
                            glDate = glDate.addSeconds(currentSystemNow.second());
                            string glDateStr   = glDate.format('yyyyMMdd');

                            // 1. Debit Entry
                            debitEntry = new Int_OLMN_AP__c();
                            debitEntry.Contract_Number__c = dealerFundingTxn.cllease__Lease_Account__r.Name;
                            debitEntry.Vendor_Code__c     = dealerFundingTxn.cllease__Dealer_Name__r.Oracle_Vendor_ID__c;
                            debitEntry.Invoice_Type_Lookup_Code__c= dealerFundingTxn.cllease__Txn_Amt__c > 0 ? 'STANDARD' : 'CREDIT';
                            debitEntry.Invoice_Number__c  = dealerFundingTxn.Invoice_Number__c;     
                            debitEntry.Invoice_Date__c    = invoiceDateStr;   
                            debitEntry.Invoice_Amount__c  = dealerAmountMap.get(dealerGroupTxn);
                            debitEntry.Invoice_Currency_Code__c   = 'USD';
                            debitEntry.Invoice_Description__c     = dealerFundingTxn.cllease__Lease_Account__r.Name;
                            debitEntry.Funding_Type__c            = 'ASSET';
                            debitEntry.FUNDING_SOURCE__c          = 'NEWCO';
                            debitEntry.Term_Name__c               = 'Immediate'; 
                            debitEntry.Terms_Date__c              = invoiceDateStr; 
                            debitEntry.Payment_Method__c          = 'EFT';
                            debitEntry.GL_Date__c                 = txnDateStr;
                            debitEntry.Line_Number__c             = 1;
                            debitEntry.Line_Type_Lookup_Code__c   = 'ITEM';
                            debitEntry.Line_Description__c        = dealerFundingTxn.cllease__Lease_Account__r.Name;
                            debitEntry.Line_Amount__c             = dealerAmountMap.get(dealerGroupTxn);                                        
                            debitEntry.Accounting_Date__c         = glDateStr;
                            debitEntry.Dist_Code_Combination__c   = glEntry.Movement_Code_DR_Segment__c;
                            debitEntry.Accts_Pay_Code_Combination__c = glEntry.Movement_Code_CR_Segment__c;
                            debitEntry.Related_Record_Id__c       = dealerFundingTxn.cllease__Dealer_Name__c;                                                                                               
                            intsAPObjectsToInsert.add(debitEntry);

                            remark = 'Sucessfully Consolidated Account Payable Records for DLL';
                        }
                        
                    } else {
                        remark = 'GL Entries not yet generated';
                    }

                    // Upating Remark in all transactions for validation/Success/failure
                    for(cllease__Other_Transaction__c groupedTxn : groupedTxns) {
                        dealerFundingTxn.cllease__Description__c = remark;
                        dealerFundTxnsToUpdate.put(groupedTxn.Id, groupedTxn);
                    }                    
                }
            }

            //insert AP interface records list
            Database.SaveResult[] srList = Database.insert(intsAPObjectsToInsert, false);
            
            Set<Id> successEntrieIDs = new Set<Id>();
            List<String> groupsSuccess= new List<String>();
            List<String> groupsSuccessId= new List<String>();
             // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    successEntrieIDs.add(sr.getId());
                }
                else {
                    // Log Exception in Dealer Funding Transaction
                }
            }
            
            for(Int_OLMN_AP__c ins_ch : [SELECT Id, Related_record_id__c, Invoice_Number__c  FROM Int_OLMN_AP__c WHERE Id IN :successEntrieIDs]){
                groupsSuccess.add(ins_ch.Related_record_id__c+':'+ins_ch.Invoice_Number__c);
                groupsSuccessId.add(ins_ch.Id);
            }
            
            Integer i =0;
            for(String groupedTxnString : groupsSuccess) {
                for(cllease__Other_Transaction__c ch : groupingDealerFundTxnsMap.get(groupedTxnString)){
                    ch.AP_Processing_Status__c = 'Sent to AP';
                    ch.Int_OLMN_AP_link__c = groupsSuccessId.get(i);
                    dealerFundTxnsToUpdate.put(ch.Id, ch);
                }
                i++;
            }  
            
            //update the OLT records back to mark as Sent to AP
            if(dealerFundTxnsToUpdate.size() > 0) {
                Update dealerFundTxnsToUpdate.values();  
            }             
                
        } catch(exception e){           
           database.rollback(sp);           
           //insert batch process log for exceptions
           System.debug(LoggingLevel.ERROR, '-------Exception: '+e.getMessage());
           cllease__Batch_Process_Log__c bpl = new cllease__Batch_Process_Log__c(name='PopulateAPinterfaceDealerfunding',cllease__Date__c=system.today(),
           cllease__Message__c='Error is '+e.getmessage()+' in line number: '+ e.getlinenumber());
           insert bpl;
       }
    }

    private void processDisbursementTransactions(Set<Id> contractIds) {
        //to store the list of AP interface records to be created
        list<Int_OLMN_AP__c> intsAPObjectsToInsert = new list<Int_OLMN_AP__c>();   
        Map<Id, cllease__Disbursement_Transaction__c> disbTxnsToUpdate = new Map<Id, cllease__Disbursement_Transaction__c>();     
        Savepoint sp = database.setsavepoint();        
        try{
            String disbTxnSubType = 'Service Fees - Passthrough';
            //query all OLTs which need to be processed and limiting one GL Accounting Entry
            Map<Id, cllease__Disbursement_Transaction__c> disbTxns = 
                new Map<Id, cllease__Disbursement_Transaction__c>(
                            [ SELECT Id, Name,
                                cllease__Contract__r.Name,
                                cllease__Transaction_Date__c,
                                cllease__GL_Process_Date__c,
                                cllease__Amount__c,
                                Fee_Amount_To_Dealer__c,
                                cllease__Account__c,
                                Remark__c,
                                Int_OLMN_AP_link__c,
                                cllease__Account__r.Oracle_Vendor_ID__c,
                                cllease__Transaction_Sub_Type__c,
                                cllease__Transaction_Sub_Type__r.Name,
                                cllease__Transaction_Type__c,
                                (SELECT Id, Name, 
                                        Movement_Code_DR_Segment__c,
                                        Movement_Code_CR_Segment__c
                                    FROM cllease__GL_Transaction_Details__r
                                    LIMIT 1)
                            FROM cllease__Disbursement_Transaction__c 
                            WHERE cllease__Transaction_Type__c = 'DISBURSEMENT' 
                                AND ( AP_Processing_Status__c = 'New' 
                                        OR AP_Processing_Status__c = null
                                    )
                                AND cllease__Transaction_Sub_Type__r.Name = :disbTxnSubType  
                                AND cllease__Contract__c IN :contractIds]);
            
            // just return incase if ther are no records
            if(disbTxns.size() == 0) {
                return;
            }

            String remark = '';            
            Int_OLMN_AP__c debitEntry;
            Datetime currentSystemNow = System.now();
            // Description
            //    For each Disbursement Transaction --> AP Interface Record (1-1)
            //    No grouping Criteria
            // Looping through DealerFunding Transactions to create Entries
            for(cllease__Disbursement_Transaction__c disbTxn : disbTxns.values()) {             
                if(disbTxn.cllease__GL_Transaction_Details__r.size() > 0) {
                    cllease__GL_Transaction_Detail__c glEntry = disbTxn.cllease__GL_Transaction_Details__r.get(0);
                    // List of validations
                    // a) Validations on fields
                    Boolean validationSuccess = true;
                    if(disbTxn.cllease__Account__c == null
                        || disbTxn.cllease__Account__r.Oracle_Vendor_ID__c == null) {
                        remark = 'Oracle Vendor ID missing';
                        validationSuccess = false;
                    }

                    if(disbTxn.cllease__Amount__c == null || disbTxn.cllease__Amount__c == 0) {
                        remark = 'Disbursement Amount 0 (zero) skipping to AP file generation.';
                        validationSuccess = false;
                    }
                    // b) 
                    if(disbTxn.cllease__Transaction_Date__c == null) {
                        remark = 'Dealer Funding Transaction Date is Missing';
                        validationSuccess = false;
                    }
                    // c)
                    if(disbTxn.cllease__GL_Process_Date__c == null) {
                        remark = 'GL Trasaction Date is Missing';
                        validationSuccess = false;
                    }

                    if(validationSuccess) {
                        Datetime txnDate    = disbTxn.cllease__Transaction_Date__c;
                        txnDate = txnDate.addHours(currentSystemNow.hour());
                        txnDate = txnDate.addMinutes(currentSystemNow.minute());
                        txnDate = txnDate.addSeconds(currentSystemNow.second());
                        string txnDateStr   = txnDate.format('yyyyMMdd');

                        Datetime glDate    = disbTxn.cllease__GL_Process_Date__c;
                        glDate = glDate.addHours(currentSystemNow.hour());
                        glDate = glDate.addMinutes(currentSystemNow.minute());
                        glDate = glDate.addSeconds(currentSystemNow.second());    
                        string glDateStr   = glDate.format('yyyyMMdd');

                        // 2. Debit Entry
                        debitEntry = new Int_OLMN_AP__c();
                        debitEntry.Contract_Number__c = disbTxn.cllease__Contract__r.Name;
                        debitEntry.Vendor_Code__c     = disbTxn.cllease__Account__r.Oracle_Vendor_ID__c;
                        debitEntry.Invoice_Type_Lookup_Code__c= disbTxn.cllease__Amount__c > 0 ? 'STANDARD' : 'CREDIT';
                        debitEntry.Invoice_Number__c  = disbTxn.Name;     
                        debitEntry.Invoice_Date__c    = txnDateStr;   
                        debitEntry.Invoice_Amount__c  = disbTxn.cllease__Amount__c;
                        debitEntry.Invoice_Currency_Code__c   = 'USD';
                        debitEntry.Invoice_Description__c     = disbTxn.cllease__Contract__r.Name;
                        if( disbTxn.cllease__Transaction_Sub_Type__c != null
                            && disbTxn.cllease__Transaction_Sub_Type__r.Name == DLLNewCoConstants.TXNSUBTYPE_SERVICES_FEE_PASSTHROUGH
                            && disbTxn.cllease__Transaction_Type__c == DLLNewCoConstants.TXN_DISBURSEMENT) {
                            debitEntry.Funding_Type__c        = DLLNewCoConstants.FUNDTYPE_PASSTHROUGH;
                        }
                        
                        debitEntry.FUNDING_SOURCE__c          = 'NEWCO';
                        debitEntry.Term_Name__c               = 'Immediate'; 
                        debitEntry.Terms_Date__c              = txnDateStr; 
                        debitEntry.Payment_Method__c          = 'EFT';
                        debitEntry.GL_Date__c                 = txnDateStr;
                        debitEntry.Line_Number__c             = 1;
                        debitEntry.Line_Type_Lookup_Code__c   = 'ITEM';
                        debitEntry.Line_Description__c        = disbTxn.cllease__Contract__r.Name;
                        debitEntry.Line_Amount__c             = disbTxn.cllease__Amount__c;                                        
                        debitEntry.Accounting_Date__c         = glDateStr;
                        debitEntry.Dist_Code_Combination__c   = glEntry.Movement_Code_DR_Segment__c;
                        debitEntry.Accts_Pay_Code_Combination__c = glEntry.Movement_Code_CR_Segment__c;
                        debitEntry.Related_Record_Id__c       = disbTxn.Id;                                                                                               
                        intsAPObjectsToInsert.add(debitEntry);

                        remark = 'Sucessfully Consolidated Account Payable Records for DLL';
                    }
                        
                } else {
                    remark = 'GL Entries not yet generated';
                }
                // Upating Remark in all transactions for validation/Success/failure
                disbTxn.Remark__c = remark;
                disbTxnsToUpdate.put(disbTxn.Id, disbTxn);                
            }

            //insert AP interface records list
            Database.SaveResult[] srList = Database.insert(intsAPObjectsToInsert, false);            
            Set<Id> successEntrieIDs        = new Set<Id>();
            Map<Id, Id> groupsSuccessMap   = new Map<Id, Id>();
             // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    successEntrieIDs.add(sr.getId());
                }
            }
            
            for(Int_OLMN_AP__c ins_ch : [SELECT Id, Related_Record_Id__c  FROM Int_OLMN_AP__c WHERE Id IN :successEntrieIDs]){
                groupsSuccessMap.put(ins_ch.Related_Record_Id__c, ins_ch.Id);
            }
            
            for(Id disbTxnID : groupsSuccessMap.keySet()) {
                cllease__Disbursement_Transaction__c ch  =  disbTxnsToUpdate.get(disbTxnID);
                ch.AP_Processing_Status__c  = 'Sent to AP';
                ch.Int_OLMN_AP_link__c      = groupsSuccessMap.get(disbTxnID);
                disbTxnsToUpdate.put(ch.Id, ch);
            }  
            
            //update the OLT records back to mark as Sent to AP
            if(disbTxnsToUpdate.size() > 0) {
                Update disbTxnsToUpdate.values();  
            }             
                
        } catch(exception e){           
           database.rollback(sp);  
           System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
           System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());           
           //insert batch process log for exceptions
           insert new cllease__Batch_Process_Log__c(name='APInterfaceRecordsGeneratorJob: ',cllease__Date__c=system.today(),
           cllease__Message__c='Error is '+e.getmessage()+' in line number: '+ e.getlinenumber());
       }
    }
    
    public override void doInitialize() { }
    public override void doStart(Database.BatchableContext bc) {
        //0. Checking for unfinished transactions in interface table.
        //   Incase of any unfinished transactions, job should not run till all txns commited to DLL
        //Throw exception and skip the job run in case of any unfinished transactions
        //    uncommittedInterfaceRecordsExist = true for all interface records not processed
        //                               = false for all interface records  processed 
        Boolean uncommittedInterfaceRecordsExist = InterfaceTablesUnfinishedTxnsCheck.checkUnfinishedTxnsForAPIntegration();
        System.debug(LoggingLevel.ERROR, '-----uncommittedInterfaceRecordsExist: '+uncommittedInterfaceRecordsExist);
        if(uncommittedInterfaceRecordsExist) {
            throw new CLSCustomException('AP Integration Interface table(Int_OLMN_AP__c) has unfinished transactions. '+
                'Please commit all transactions from Interface table andInte run Job again...');
        } 
    }   
    public override void doFinish(Database.BatchableContext bc) { }
    
}