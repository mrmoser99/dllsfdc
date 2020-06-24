/**
 * Owner: Cloud Lending Solutions
 * Usage: Following class is template of DAG framework batch job which helps in more advantages over salesfroce batch processing.
 * Script to Run Job:
 * List<String> contractNames = new List<String> {''};
UpdateContractDetailsJob job = new UpdateContractDetailsJob(contractNames);
Database.executeBatch(job, 1);
 *      
 **/
global with sharing class UpdateContractDetailsJob extends clcommon.DynamicJob {
    
    private static String query;
    private static final String JOB_NAME = 'UpdateContractDetailsJob Job';
    
    global UpdateContractDetailsJob() {
        super(JOB_NAME, initialize(null));
        doInitialize();
    }
    
    global UpdateContractDetailsJob(List<String> contractNames) {
        super(JOB_NAME, initialize(contractNames));
        doInitialize();
    }
    
    global virtual override String getRuntimeQuery() {
        System.debug(LoggingLevel.ERROR, 'UpdateContractDetailsJob query in getRuntimeQuery : ' + query);
        return query; 
    }

	/**
	 * initialize method should create QUERY in string format and return from this method.
	 **/
    public static String initialize(List<String> contractNames) {

        // Query Creation
        query = ' SELECT Id, Name, cllease__Lease_Status__c, Unbilled_Service_and_Maintenance__c, Unbilled_Estimated_Property_Tax__c '+
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

        query += ' ORDER BY Name ';
        
        System.debug(LoggingLevel.ERROR, 'UpdateContractDetailsJob Query: '+query);
        return query;
    }
    
    /** 
	 * Following method will have Processing logic on batch of records which is similar to execute() method from salesforce batch framework
     **/
    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {
        // job has to run with batch size = 1.
        List<cllease__Lease_Account__c> contracts = (List<cllease__Lease_Account__c>)scope;
        cllease__Lease_Account__c contract = contracts[0];
        Savepoint sp = database.setsavepoint();
        try {
            
            // 1. Update the Payment Stream's Service Fee details in Contract.
            AggregateResult[] aggResult = [SELECT sum(cllease__Rental_Amount__c) unbilledServiceFee
                                                                    FROM  cllease__Payment_Stream__c
                                                                    WHERE cllease__Contract__c = :contract.Id
                                                                        AND Service_Fee_Unpaid_Flag__c = true];

            
            Decimal unpaidServiceFeeAmount = 0;
            for (AggregateResult r : aggResult) {
                System.debug('result: '+r);
                if(r.get('unbilledServiceFee') != null) {
                    Decimal amount = (Decimal)r.get('unbilledServiceFee');
                    unpaidServiceFeeAmount  += amount;
                }
            }

            contract.Unbilled_Service_and_Maintenance__c = unpaidServiceFeeAmount;

            // 2. Update the Payment Stream's Unbilled_Estimated_Property_Tax__c
            AggregateResult[] aggResult2 = [SELECT sum(cllease__Rental_Amount__c) unbilledEstimatedPrpTax
                                                                    FROM  cllease__Payment_Stream__c
                                                                    WHERE cllease__Contract__c = :contract.Id
                                                                        AND Estimated_Property_Tax_Unpaid_Flag__c = true];

            Decimal unpaidEstimatedTaxAmount = 0;
            for (AggregateResult r : aggResult2) {
                System.debug('result: '+r);
                if(r.get('unbilledEstimatedPrpTax') != null) {
                    Decimal amount = (Decimal)r.get('unbilledEstimatedPrpTax');
                    unpaidEstimatedTaxAmount  += amount;
                }
            }

            contract.Unbilled_Estimated_Property_Tax__c = unpaidEstimatedTaxAmount;
            update contract;

			
        } catch(exception e){           
			database.rollback(sp);   
			System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
			System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());            
			//insert batch process log for exceptions
			insert new cllease__Batch_Process_Log__c(Name='UpdateContractDetailsJob', cllease__Date__c = System.today(),
            cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
       }

    }

    
    public override void doInitialize() { }
    public override void doStart(Database.BatchableContext bc) { }   
    public override void doFinish(Database.BatchableContext bc) { }
}