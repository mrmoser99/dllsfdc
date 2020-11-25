/*********************************************************************************************
*	Batch Rate Updater
*   Maintains rate cards in newco from mosaic    
*
*   ChangeLog:
*
*	10/5/2020 - MRM Created Class
*
************************************************************************************************/
global class BatchRateUpdater implements Database.Batchable<SObject>,Database.Stateful, Database.AllowsCallouts{
    /*********************************************************************************************
  	*	QUERY
  	* 
  	*
  	************************************************************************************************/
    static final string QUERY = 'Select name,mosaic_primary_id__c from Account where recordtype.name = ' + '\'' + 'Dealer' + 
        '\' ' + ' and oracle_vendor_id__c != null and mosaic_rate_return_code__c = ' +  '\'' + 'XX' + '\'';
	
	
    /*********************************************************************************************
  	*	START
  	* Database.QueryLocator
  	************************************************************************************************/				
      global Database.QueryLocator start(Database.BatchableContext c) {  
        
        
        return Database.getQueryLocator(QUERY);        
    }
  	/*********************************************************************************************
  	*	EXECUTE
  	*
  	* 
  	************************************************************************************************/
    global void execute(Database.BatchableContext c, List<Account> scope) { 
        
        

        for (Account a:scope){
            
            //RateUtility.getProgram(a.mosaic_primary_id__c);
            
        }
        
        
       
    }
     
    /*********************************************************************************************
  	*	FINISH
  	*
  	*
  	************************************************************************************************/
    global void finish(Database.BatchableContext c) {

    }
  
}