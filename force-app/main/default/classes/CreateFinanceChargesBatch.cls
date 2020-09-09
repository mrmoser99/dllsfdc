/**
 * Author: Cloud Lending Solutions
 * Usage: Following job helps in Creating Finance Charges
 * Script to Run Job:
 *      
 **/
global class CreateFinanceChargesBatch extends clcommon.DynamicJob {  
 
    private static String query;
    private static final String JOB_NAME = 'Financed Charge Generation Job';

    global CreateFinanceChargesBatch() {
        super(JOB_NAME, initialize(null));
    }

    global CreateFinanceChargesBatch(List<String> contractNames) {
        super(JOB_NAME, initialize(contractNames));
    }
 
    public virtual override String getRuntimeQuery() {
        System.debug(LoggingLevel.ERROR, 'CreateFinanceChargesBatch query in getRuntimeQuery : ' + query);
        return query; 
    }

    public static String initialize(List<String> contractNames) {
        query = ' SELECT Id, Name,                                                                '+
                '   cllease__Total_Due_Amount__c,                                                 '+
                '   cllease__Date__c,                                                             '+
                '   cllease__Lease_Account__c,                                                    '+
                '   cllease__Dues_Details__c,                                                     '+
                '   cllease__Dues_Details__r.cllease__Balance_Amount__c,                          '+
                '   cllease__Dues_Details__r.cllease__Due_Date__c,                                '+
                '   cllease__Lease_Account__r.AutoCaluclate_Finance_Charge_Grace_Days__c,         '+
                '   CreatedDate                                                                   '+
                ' FROM cllease__Charge__c                                                         '+
                ' WHERE cllease__Fee_Definition__r.Name= \''+ DLLNewCoConstants.FEE_LATE_FEE +'\' '+
                '   AND cllease__Paid__c = false                                                  '+
                '   AND Overdue__c = true                                                         '+
                '   AND Finance_Fee_created__c=false                                              '+
                '   AND cllease__Total_Due_Amount__c > 0                                          ';

        if(contractNames!=null && contractNames.size() > 0) {
            String contractNamesStr = '';
            for (String contractName : contractNames) {
              contractNamesStr = contractNamesStr + '\'' + String.escapeSingleQuotes(contractName) + '\'' + ',';
            }
            contractNamesStr = contractNamesStr.substring(0, contractNamesStr.length() - 1);
            query += ' AND cllease__Lease_Account__r.Name in ('+ contractNamesStr + ')';
        }

        query += ' ORDER BY Name ';
        return query;
    }
      
    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {
    	System.debug(LoggingLevel.ERROR, '^^^^ scope : ' + scope);
        List<cllease__Charge__c> chargesList        = (List<cllease__Charge__c>)scope;
        List<cllease__Charge__c> chargesToCreate    = new List<cllease__Charge__c>();
        List<cllease__Charge__c> chargesToUpdate     = new List<cllease__Charge__c>();
        Map<String, cllease__Charge__c> contractBillKeyChargeMap = new Map<String, cllease__Charge__c>();
        
        Savepoint sp = database.setsavepoint();        
        try {
            // Querying the Finance Fee type
            List<clcommon__Fee_Definition__c> financeFeeList = [SELECT Id, Name, RateFactor__c FROM clcommon__Fee_Definition__c 
                                                                    WHERE Name= :DLLNewCoConstants.FEE_FINANCE_FEE
                                                                    ORDER BY Id];
            if(financeFeeList.size() == 0) {
                throw new CLSCustomException('Fee Definition: FINANCE FEE is missing from Fee Configuration, Please create it before Processing again...');
            }

            clcommon__Fee_Definition__c financeFeeDef = financeFeeList.get(0);

            // To avoid null pointer exceptions
            financeFeeDef.RateFactor__c = (financeFeeDef.RateFactor__c != null ? financeFeeDef.RateFactor__c: 0.00);

            // Extracting Current System Date
            Date currentSystemDate = cllease.SystemDateUtil.getCurrentSystemDate();

            // Looping through the all late charges for Finance Charge creation
            for(cllease__Charge__c charge : chargesList){ 
                // Checking for Finance Charge grace days for charge generation
                Integer graceDays = ((charge.cllease__Lease_Account__c != null && charge.cllease__Lease_Account__r.AutoCaluclate_Finance_Charge_Grace_Days__c != null) ? 
                                        charge.cllease__Lease_Account__r.AutoCaluclate_Finance_Charge_Grace_Days__c.intValue() : 0);

                Date dueDate = charge.cllease__Date__c.addDays(graceDays);
                Integer diff = currentSystemDate.daysBetween(dueDate);

                if(diff < 0) {
                    if(charge.cllease__Dues_Details__c !=null){
                        cllease__Charge__c newFinCharge = new cllease__Charge__c();
                        newFinCharge.cllease__Fee_Definition__c = financeFeeDef.id;
                        newFinCharge.cllease__Date__c = date.today();
                        newFinCharge.cllease__GL_Transaction_Flag__c = true;
                        newFinCharge.cllease__Lease_Account__c = charge.cllease__Lease_Account__c;
                        newFinCharge.cllease__Dues_Details__c = charge.cllease__Dues_Details__c;
                        newFinCharge.cllease__Original_Amount__c = 
                                ( charge.cllease__Dues_Details__r.cllease__Balance_Amount__c * financeFeeDef.RateFactor__c/360) 
                                * (charge.cllease__Dues_Details__r.cllease__Due_Date__c.daysBetween(currentSystemDate)) ;
                        chargesToCreate.add(newFinCharge);

                        String contractBillKey = charge.cllease__Lease_Account__c +':'+charge.cllease__Dues_Details__c;
                        contractBillKeyChargeMap.put(contractBillKey, charge);
                    }
                }
                            
            }
            System.debug(LoggingLEVEL.ERROR, 'chargesToCreate: '+ chargesToCreate);

            //insert Finance Fees charges
            if(chargesToCreate.size() > 0) {
                Database.SaveResult[] srList = Database.insert(chargesToCreate, false);
                // Iterate through each returned result
                Set<Id> successfulFeeChargesIds = new Set<Id>();
                for (Database.SaveResult sr : srList) {                 
                    if (sr.isSuccess()) {
                        successfulFeeChargesIds.add(sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Charge fields that affected this error: ' + err.getFields());
                        }
                    }
                }

                // Looping through New charges to update late charges status's to financed fee generated true
                for(cllease__Charge__c charge : [SELECT Id, cllease__Lease_Account__c, cllease__Dues_Details__c 
                                                    FROM cllease__Charge__c WHERE Id IN :successfulFeeChargesIds]){
                    String contractBillKey = charge.cllease__Lease_Account__c +':'+ charge.cllease__Dues_Details__c;
                    if(contractBillKeyChargeMap.containsKey(contractBillKey)) {
                        cllease__Charge__c lateCharge = contractBillKeyChargeMap.get(contractBillKey);
                        lateCharge.Finance_Fee_Created__c = true;
                        chargesToUpdate.add(lateCharge);
                    }
                }

                if(chargesToUpdate.size() > 0) {
                    update chargesToUpdate;
                }
            }

        } catch(exception e){           
            database.rollback(sp);  
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());           
            //insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(name='CreateFinanceChargesBatch: ',cllease__Date__c=system.today(),
            cllease__Message__c='Error is '+e.getmessage()+' in line number: '+ e.getlinenumber());
        }        
    }
    
    public override void doInitialize() { }
    public override void doStart(Database.BatchableContext bc) { }   
    public override void doFinish(Database.BatchableContext bc) { }
}