/*********************************************************************************************
*	This batch calculates npba for all leases
*    
*   

* ChangeLog:
*
*	7/10/2020 - MRM Created Class
*
************************************************************************************************/
global class BatchNPBACalc implements Database.Batchable<SObject>,Database.Stateful{
    /*********************************************************************************************
  	*	QUERY
  	*
  	*
  	************************************************************************************************/
    static final string QUERY = 'Select id, name  from cllease__Lease_Account__c';
	/*********************************************************************************************
  	*	CONSTRUCTOR 
  	*    
  	*
  	************************************************************************************************/
	global BatchNPBACalc(){   
    	
    }
    /*********************************************************************************************
  	*	START
  	*
  	************************************************************************************************/				
    global Database.QueryLocator start(Database.BatchableContext c) {    
        System.debug('Query is: ' + QUERY);
        return Database.getQueryLocator(QUERY);        
    }
  	/*********************************************************************************************
  	*	EXECUTE
  	*
  	*
  	************************************************************************************************/
    global void execute(Database.BatchableContext c, List<cllease__Lease_Account__c> scope) { 
        
        system.debug('************** execute');
        Set<String> contractIDSet = new Set<String>();
        
        Map<ID,Map<String,Decimal>> nonCashMap = new Map<ID,Map<String,Decimal>>();
        

        for (cllease__Lease_Account__c l : scope)  {
        	contractIdSet.add(l.id);   
        }

        List<cllease__Non_Cash_Account_Balance__c> ncList = new List<cllease__Non_Cash_Account_Balance__c>();
        ncList = [SELECT id
                  from cllease__Non_Cash_Account_Balance__c
                  where cllease__Contract__c in :contractIDSet 
                  and cllease__Balance_Type__c in ('FUTURE LEASE RECEIVABLE','UNEARNED INCOME','RESIDUAL RECEIVABLE','UNEARNED RESIDUAL')
        ];

        for (cllease__Non_Cash_Account_Balance__c nc: ncList){

            Map<String,Decimal> tempNonCashMap = new Map<String,Decimal>();
            
            if (nonCashMap.contains(nc.cllease__Contract__c)){

                tempNonCashMap = nonCashMap.get(nc.cllease__Contract__c);
                tempNonCashMap.put(nc.cllease__Balance_Type__c,cllease__Closing_Balance_Amount__c);
               

            }
            else{
                
                tempNonCashMap.put(nc.cllease__Balance_Type__c,cllease__Closing_Balance_Amount__c);
            }
            nonCashMap.put(nc.cllease__Contract__c,tempNonCashMap);
            
            
        }

        system.debug('Non Cash Map Is: ' +  nonCashMap);

             
    }
     
    /*********************************************************************************************
  	*	FINISH
  	*
  	*
  	************************************************************************************************/
    global void finish(Database.BatchableContext c) {
    }
  
}