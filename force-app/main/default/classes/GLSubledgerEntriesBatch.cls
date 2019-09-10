/**
 * Owner: Cloud Lending Solutions
 * Usage: Following job helps in Creating the Interface Record for each GL Account Entries
 * Script to Run Job:
 *      
 **/
global with sharing class GLSubledgerEntriesBatch extends clcommon.DynamicJob {
    private String openPeriodEndDate;
    private String currentSystemDateStr;
    private Map<Id, String> txnSubTypeMap;
    private static String query;
    private static final String JOB_NAME = 'GL SubLedger Records Generator Job';
    private static Datetime txnDate;

    global GLSubledgerEntriesBatch() {
        super(JOB_NAME, initialize(null));
        doInitialize();
    }
    
    global GLSubledgerEntriesBatch(List<String> contractNames) {
        super(JOB_NAME, initialize(contractNames));
        doInitialize();
    }
    
    global virtual override String getRuntimeQuery() {
        System.debug(LoggingLevel.ERROR, 'GLSubledgerEntriesBatch query in getRuntimeQuery : ' + query);
        return query; 
    }

    public static String initialize(List<String> contractNames) {

        String excludeTxns =  '\''+DLLNewCoConstants.TXN_DISBURSEMENT +'\', \''+DLLNewCoConstants.TXN_DEALERFUNDING+'\'';
        //'\'DISBURSEMENT\', \'DEALER FUNDING\'';
        String txnDateStr        = String.valueOf(cllease.SystemDateUtil.getCurrentSystemDate());
        
        query = ' SELECT Id, Name,                                '+
                '   cllease__Contract__c,                         '+
                '   cllease__Contract__r.Name,                    '+
                '   cllease__Contract__r.Dealer_Program__c,       '+
                '   cllease__Contract__r.Dealer_Program__r.Name,  '+
                '   cllease__Contract__r.cllease__Lease_Product_Name__c,       '+
                '   cllease__Contract__r.cllease__Lease_Product_Name__r.Name,  '+
                '   cllease__Credit_GL_Account__r.Name,           '+
                '   cllease__Credit_Amount__c,                    '+
                '   cllease__Credit_GL_Account_Code__c,           '+
                '   cllease__Debit_GL_Account__r.name,            '+
                '   cllease__Debit_Amount__c,                     '+
                '   cllease__Debit_GL_Account_Code__c,            '+
                '   CL_Lease_Transaction_Type__c,                 '+
                '   cllease__Transaction_Type__c,                 '+
                '   Transaction_Sub_Type__c,                      '+
                '   GL_SubLedger_Credit_Record_Id__c,             '+
                '   GL_SubLedger_Debit_Record_Id__c,              '+
                '   Movement_Code_CR_Segment__c,                  '+
                '   Movement_Code_DR_Segment__c,                  '+
                '   Journal_Entry_Number__c,                      '+
                '   cllease__Charge__c,                           '+
                '   cllease__Charge__r.cllease__Fee_Definition__c,         '+
                '   cllease__Charge__r.cllease__Fee_Definition__r.Name,    '+
                '   cllease__Charge__r.cllease__Contract_Equipment__c,     '+
                '   cllease__Charge__r.cllease__Contract_Equipment__r.Name,'+
                '   cllease__GL_Date__c                           '+
                ' FROM cllease__GL_Transaction_Detail__c          '+
                ' WHERE ( GL_SubLedger_Credit_Record_Id__c = null '+
                '     OR GL_SubLedger_Debit_Record_Id__c = null ) '+
                '   AND Valid_GL_Entries__c = true '+
                '   AND CL_Lease_Transaction_Type__c not in ( '+excludeTxns+' ) '+
                '   AND cllease__GL_Date__c <= '+ txnDateStr;

        if(contractNames!=null && contractNames.size() > 0) {
            String contractNamesStr = '';
            for (String contractName : contractNames) {
              contractNamesStr = contractNamesStr + '\'' + String.escapeSingleQuotes(contractName) + '\'' + ',';
            }
            contractNamesStr = contractNamesStr.substring(0, contractNamesStr.length() - 1);
            query += ' AND cllease__Contract__r.Name in ('+ contractNamesStr + ')';
        }
        
        System.debug(LoggingLevel.ERROR, 'GLSubledgerEntriesBatch query in initialize : ' + query);
        return query;
    }
 
    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {
   
        List<cllease__GL_Transaction_Detail__c> glEntriesList
            = (List<cllease__GL_Transaction_Detail__c>)scope;
        Map<Id, cllease__GL_Transaction_Detail__c> glEntriesToUpdate 
            = new Map<Id, cllease__GL_Transaction_Detail__c>();
        List<Int_OLMN_Accounting_Entry__c> olmnAccEntryListToInsert 
            = new List<Int_OLMN_Accounting_Entry__c>();

        Savepoint sp = database.setsavepoint();
        try {
            // 1. Looping through all GL Accounting Entries for Credit and  Debit Entries Creation
            for(cllease__GL_Transaction_Detail__c glEntry : glEntriesList) {
                if(glEntry == null) continue; 
                //System.debug(LoggingLevel.ERROR, ' Processing GL Entry in SubLenders:'+glEntry);
                // Validations
                if(glEntry.cllease__Contract__r.Dealer_Program__c == null) {
                    glEntry.Remark__c = 'Vendor Program Not Linked to Contract...';

                } else if(glEntry.cllease__Contract__r.cllease__Lease_Product_Name__c == null) {
                    glEntry.Remark__c = 'Lease Program Not Linked to Contract...';

                } else if(glEntry.GL_SubLedger_Credit_Record_Id__c == null
                            && glEntry.GL_SubLedger_Debit_Record_Id__c == null) {
                    // Creating Credit Entry
                    if(glEntry.GL_SubLedger_Credit_Record_Id__c == null) {
                        olmnAccEntryListToInsert.add(createOLMNAccountingEntry(glEntry, 'Credit'));
                    }
                    // Creating Debit Entry
                    if(glEntry.GL_SubLedger_Debit_Record_Id__c == null) {
                        olmnAccEntryListToInsert.add(createOLMNAccountingEntry(glEntry, 'Debit'));
                    }
                    glEntry.Remark__c = 'Successfully Processed the GL SubLenders on DLL Interface Records...';
                }               
                glEntriesToUpdate.put(glEntry.Id, glEntry);

            }

            // 2. Create Interface Records
            if(olmnAccEntryListToInsert.size() > 0) {

                Database.SaveResult[] srList = Database.insert(olmnAccEntryListToInsert, false);
                Set<Id> successEntrieIDs = new Set<Id>();
                 // Iterate through each returned result
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        successEntrieIDs.add(sr.getId());
                    }
                }
                
                Map<String, Int_OLMN_Accounting_Entry__c> olmnAEMapCredit 
                    = new Map<String, Int_OLMN_Accounting_Entry__c>();
                Map<String, Int_OLMN_Accounting_Entry__c> olmnAEMapDebit 
                    = new Map<String, Int_OLMN_Accounting_Entry__c>();
                for(Int_OLMN_Accounting_Entry__c olmnAE : [SELECT Id, GL_Entry_Id__c, 
                                                                Accounted_Cr__c, 
                                                                Accounted_Dr__c
                                                            FROM Int_OLMN_Accounting_Entry__c 
                                                            WHERE Id IN :successEntrieIDs]){
                    if(olmnAE.Accounted_Cr__c != null) {
                        olmnAEMapCredit.put(olmnAE.GL_Entry_Id__c, olmnAE);
                    } else if(olmnAE.Accounted_Dr__c != null) {
                        olmnAEMapDebit.put(olmnAE.GL_Entry_Id__c, olmnAE);
                    }                    
                }

                for(String glEntryID : olmnAEMapCredit.keySet()) {                    
                    cllease__GL_Transaction_Detail__c glEntry = glEntriesToUpdate.get(glEntryID);
                    Int_OLMN_Accounting_Entry__c olmnAE = olmnAEMapCredit.get(glEntryID);
                    glEntry.GL_SubLedger_Credit_Record_Id__c = olmnAE.Id;
                    glEntry.Remark__c = 'Successfully Created GL SubLender Credit Record...';
                    glEntriesToUpdate.put(glEntry.Id, glEntry);                    
                }

                for(String glEntryID : olmnAEMapDebit.keySet()) {
                    cllease__GL_Transaction_Detail__c glEntry   = glEntriesToUpdate.get(glEntryID);
                    Int_OLMN_Accounting_Entry__c olmnAE         = olmnAEMapDebit.get(glEntryID);
                    glEntry.GL_SubLedger_Debit_Record_Id__c     = olmnAE.Id;
                    glEntry.Remark__c = 'Successfully Created GL SubLender Debit Record...';
                    glEntriesToUpdate.put(glEntry.Id, glEntry);
                }
            }

            // Update GL Entries
            if(glEntriesToUpdate.size() > 0) {
                update glEntriesToUpdate.values();
            }

        } catch(exception e){           
           database.rollback(sp);   
           System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
           System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());      
           //insert batch process log for exceptions
           insert new cllease__Batch_Process_Log__c(Name='GLSubledgerEntriesBatch',
                                                    cllease__Date__c=system.today(),
                                                    cllease__Message__c='Error is '+e.getmessage()
                                                        +' in line number: '+ e.getlinenumber());
       }
    }

    private Int_OLMN_Accounting_Entry__c createOLMNAccountingEntry(cllease__GL_Transaction_Detail__c glEntry, String crditOrDebit) {

        //System.debug(LoggingLevel.ERROR, 'openPeriodEndDate:'+openPeriodEndDate);
        String accountingYear  = openPeriodEndDate.substring(0, 4);
        String accountingMonth = openPeriodEndDate.substring(4, 6);

        //Datetime glDate     = txnDate;
        // adding hour , minutes & Second from System.now for correct format conversion, otherwise format gives 1 day less to gldate on format conversion for datetime variable.
        /*Datetime currentSystemNow = System.now();
        glDate = glDate.addHours(currentSystemNow.hour());
        glDate = glDate.addMinutes(currentSystemNow.minute());
        glDate = glDate.addSeconds(currentSystemNow.second());*/
        string glDateStr = openPeriodEndDate; //glDate.format('yyyyMMdd'); 

        Int_OLMN_Accounting_Entry__c olmnAccEntry = new Int_OLMN_Accounting_Entry__c();
        olmnAccEntry.Contract_Number__c         = glEntry.cllease__Contract__r.Name;
        olmnAccEntry.Journal_Category__c        = glEntry.CL_Lease_Transaction_Type__c;
        olmnAccEntry.Journal_Category_Desc__c   = glEntry.CL_Lease_Transaction_Type__c;
        olmnAccEntry.Journal_Source__c          = 'NEWCO';
        olmnAccEntry.Batch_Name__c              = ''; // TODO: Not Clear what to update
        olmnAccEntry.Batch_Description__c       = glDateStr + '-NEWCO-' + glDateStr;
        olmnAccEntry.Foreign_SubSystem_Id__c    = 'NEWCO';  
        olmnAccEntry.Period_Name__c             = accountingYear + accountingMonth;

        if(crditOrDebit == 'Credit') {
            olmnAccEntry.Accounted_Cr__c            = cllease.ValueUtil.round(glEntry.cllease__Credit_Amount__c, 2, 'Nearest');
            olmnAccEntry.Accounted_Dr__c  = 0.00;
            olmnAccEntry.Concatenated_Segments__c   = glEntry.Movement_Code_CR_Segment__c;
        } else if(crditOrDebit == 'Debit') {
            olmnAccEntry.Accounted_Dr__c            = cllease.ValueUtil.round(glEntry.cllease__Debit_Amount__c, 2, 'Nearest');
            olmnAccEntry.Accounted_Cr__c  = 0.00;
            olmnAccEntry.Concatenated_Segments__c   = glEntry.Movement_Code_DR_Segment__c;
        }       
        
        olmnAccEntry.Accounting_Date__c     = glDateStr;
        olmnAccEntry.Vendor_Program__c      = glEntry.cllease__Contract__r.Dealer_Program__r.Name;
        olmnAccEntry.Transaction_Number__c  = glEntry.Name;
        
        olmnAccEntry.Fin_Product__c         = glEntry.cllease__Contract__r.cllease__Lease_Product_Name__r.Name;
        olmnAccEntry.Posting_Date__c        = glDateStr;
        olmnAccEntry.GL_Entry_Id__c         = glEntry.Id;

        // Updating Transaction Sub Type which is Accounting Template Line's Transaction Sub Type
        if(glEntry.cllease__Transaction_Type__c != null) {
            olmnAccEntry.Transaction_Sub_Type__c = txnSubTypeMap.get(glEntry.cllease__Transaction_Type__c);
        }

        // New Addition hardcoding the Transaction subtype as customr requested
        if(glEntry.CL_Lease_Transaction_Type__c == DLLNewCoConstants.TXN_CHARGE) {
            if(olmnAccEntry.Transaction_Sub_Type__c == DLLNewCoConstants.TXNSUBTYPE_ESTIMATED_PROPERTY_TAX
                && glEntry.cllease__Charge__r.cllease__Contract_Equipment__c != null) {
                olmnAccEntry.Asset_Number__c        = glEntry.cllease__Charge__r.cllease__Contract_Equipment__r.Name;
            }
        }

        // New Addition Journal Entry Number
        olmnAccEntry.Journal_Entry_Number__c = glEntry.Journal_Entry_Number__c;

        return olmnAccEntry;
    }


    public override void doInitialize() {
        // 0. Creating Transaction SubType ID, Name Map
        txnSubTypeMap = new Map<Id, String>();
        for(cllease__Transaction_Sub_Type__c txnSubType : [SELECT Id, Name FROM cllease__Transaction_Sub_Type__c LIMIT 1000]) {
            txnSubTypeMap.put(txnSubType.Id, txnSubType.Name);
        }
        
        // A. Retrieve the Open Periods Records Order by Period Month ASC Order, 
        // Throw exception that No Open Periods
        List<cllease__Period_Status__c> openPeriods = [SELECT Id, Name, cllease__End_Date__c, cllease__Period_Year__c
                                                        FROM cllease__Period_Status__c
                                                        WHERE cllease__Status__c = 'Open'
                                                        ORDER BY cllease__End_Date__c DESC];

        if(openPeriods.size() == 0) {
            throw new CLSCustomException('No Period Open from Accounting Periods, Please Open a Period and Continue...');
        }
        
        txnDate = openPeriods[0].cllease__End_Date__c;
        Datetime currentSystemNow = System.now();
        txnDate = txnDate.addHours(currentSystemNow.hour());
        txnDate = txnDate.addMinutes(currentSystemNow.minute());
        txnDate = txnDate.addSeconds(currentSystemNow.second());

        openPeriodEndDate           = txnDate.format('yyyyMMdd'); 
        //currentSystemDateStr        = ((DateTime)cllease.SystemDateUtil.getCurrentSystemDate()).format('yyyyMMdd');
    }
    public override void doStart(Database.BatchableContext bc) { 
        //0. Checking for unfinished transactions in interface table.
        //   Incase of any unfinished transactions, job should not run till all txns commited to DLL
        //Throw exception and skip the job run in case of any unfinished transactions
        //    uncommittedInterfaceRecordsExist = true for all interface records not processed
        //                               = false for all interface records  processed 
        Boolean uncommittedInterfaceRecordsExist 
            = InterfaceTablesUnfinishedTxnsCheck.checkUnfinishedTxnsForGLSubLedgers();
        
        if(uncommittedInterfaceRecordsExist) {
            throw new CLSCustomException('GL SubLenders Interface table(Int_OLMN_Accounting_Entry__c) has unfinished transactions. '+
                    'Please commit all transactions from Interface table and run Job again...');
        }
    }   
    public override void doFinish(Database.BatchableContext bc) { }
}