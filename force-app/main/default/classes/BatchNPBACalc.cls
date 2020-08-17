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
    static final string QUERY = 'Select id, name, npba_amount_calculated__c  from cllease__Lease_Account__c order by name ';
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

        if (!Test.isRunningTest())
            return Database.getQueryLocator(QUERY);
        else {
            return Database.getqueryLocator(QUERY + ' Limit 1');
        }     
         
    }
  	/*********************************************************************************************
  	*	EXECUTE
  	*
  	*
  	************************************************************************************************/
    global void execute(Database.BatchableContext c, List<cllease__Lease_Account__c> scope) { 
        
        system.debug('************** execute');
        Set<String> contractIDSet = new Set<String>();
        List<cllease__Lease_Account__c> updateList = new List<cllease__Lease_Account__c>();

        Map<ID,Map<String,Decimal>> nonCashMap = new Map<ID,Map<String,Decimal>>();
        

        for (cllease__Lease_Account__c l : scope)  {
        	contractIdSet.add(l.id);   
        }

        List<cllease__Non_Cash_Account_Balance__c> ncList = new List<cllease__Non_Cash_Account_Balance__c>();
        ncList = [SELECT id
                        ,cllease__Contract__c
                        ,cllease__balance_type__c
                        ,cllease__Closing_Balance_Amount__c
                  from cllease__Non_Cash_Account_Balance__c
                  where cllease__Contract__c in :contractIDSet 
                  and cllease__Balance_Type__c in ('FUTURE LEASE RECEIVABLE','UNEARNED INCOME','RESIDUAL RECEIVABLE','UNEARNED RESIDUAL')
        ];

        for (cllease__Non_Cash_Account_Balance__c nc: ncList){

            Map<String,Decimal> tempNonCashMap = new Map<String,Decimal>();
            
            if (nonCashMap.keyset().contains(nc.cllease__Contract__c)){
 
                tempNonCashMap = nonCashMap.get(nc.cllease__Contract__c);
                tempNonCashMap.put(nc.cllease__Balance_Type__c,nc.cllease__Closing_Balance_Amount__c);
               
            }
            else{
                
                tempNonCashMap.put(nc.cllease__Balance_Type__c,nc.cllease__Closing_Balance_Amount__c);
            }
            nonCashMap.put(nc.cllease__Contract__c,tempNonCashMap);  
        }

        Map<ID,List<cllease__Lease_account_Due_Details__c>> dueMap = new Map<ID,List<cllease__Lease_account_Due_Details__c>>();

        List<cllease__Lease_account_Due_Details__c> dueList = new List<cllease__Lease_account_Due_Details__c>();
        dueList =
            [SELECT  cllease__Due_Date__c
               ,cllease__Rental_Due_Amount__c
               ,cllease__Lease_Account__c
            FROM
            cllease__Lease_account_Due_Details__c
            where cllease__Total_Paid_Amount__c = 0
            and cllease__lease_account__c in : contractIDSet];

        for (cllease__Lease_account_Due_Details__c d:dueList){

          List<cllease__Lease_account_Due_Details__c> tempList = new List<cllease__Lease_account_Due_Details__c>();
          
          if (dueMap.keyset().contains(d.cllease__Lease_Account__c)){
            tempList = dueMap.get(d.cllease__Lease_Account__c);
            tempLIst.add(d);
           
          }
          else{
            tempList.add(d);
          }
          dueMap.put(d.cllease__Lease_Account__c,tempList);

         
        }

        system.debug('Non Cash Map Is: ' +  nonCashMap);
        system.debug('Due Map is: ' + dueMap);


        for (cllease__Lease_Account__c l : scope)  {
          Decimal originalNPBA = l.npba_amount_calculated__c;
          system.debug('Calculating NPBA for Lease: ' + l.name);
     
          l.npba_amount_calculated__c = 0;
          Map<String,Decimal> tempMap = new Map<String,Decimal>();
          
          tempMap = nonCashMap.get(l.id);
          if (tempMap != null){
              if (tempMap.get('FUTURE LEASE RECEIVABLE') != null){
                l.npba_amount_calculated__c = tempMap.get('FUTURE LEASE RECEIVABLE');
                system.debug('NPBA = Future Lease Receivable = ' + l.npba_amount_calculated__c);
              }
            
              if (tempMap.get('UNEARNED INCOME') != null){
                l.npba_amount_calculated__c= l.npba_amount_calculated__c- tempMap.get('UNEARNED INCOME');
                system.debug('NPBA - Unearned Income of ' + tempMap.get('UNEARNED INCOME') + ' = ' +  l.npba_amount_calculated__c);
              }
              
              if (tempMap.get('RESIDUAL RECEIVABLE') != null){
                l.npba_amount_calculated__c= l.npba_amount_calculated__c+ tempMap.get('RESIDUAL RECEIVABLE');
                system.debug('NPBA + Residual Receivable of ' + tempMap.get('RESIDUAL RECEIVABLE') + ' = ' +  l.npba_amount_calculated__c);
              }
              
              if (tempMap.get('UNEARNED RESIDUAL') != null){
                l.npba_amount_calculated__c= l.npba_amount_calculated__c- tempMap.get('UNEARNED RESIDUAL');
                system.debug('NPBA - Unearned Residual of ' + tempMap.get('UNEARNED RESIDUAL') + ' = ' +  l.npba_amount_calculated__c);
              }
          }

          System.debug('NPBA AMOUNT for ' + l.name + ' before rent outstanding is: '  + l.npba_amount_calculated__c);

          List<cllease__Lease_account_Due_Details__c> tempDueList = new List<cllease__Lease_account_Due_Details__c>();
          tempDueList = dueMap.get(l.id);

          Decimal rentOutstanding = 0;
          if (tempDueList != null){
            for (cllease__Lease_account_Due_Details__c d: tempDueList){
              system.debug('due date:' + d.cllease__due_date__c);
              system.debug('today:' + date.today());
              if (date.today() < d.cllease__Due_Date__c ){
                  rentOutstanding =  rentOutstanding + d.cllease__Rental_Due_Amount__c;
                  l.npba_amount_calculated__c = l.npba_amount_calculated__c + d.cllease__Rental_Due_Amount__c;
              }
            }
          }
         
          System.debug('NPBA AMOUNT for ' + l.name + ' after rent outstanding of ' + rentOutstanding + ' is: ' +  l.npba_amount_calculated__c);

          Datetime now = Datetime.now();
          Integer offset = UserInfo.getTimezone().getOffset(now);
          l.npba_amount_calculated_Date_time__c = system.now();
          
          system.debug('NPBA Time: ' +  string.valueOf(l.npba_amount_calculated_Date_time__c) );
          if (originalNPBA != l.npba_amount_calculated__c )
            updateList.add(l);
          else
            system.debug('No update required for ' + l.name);

        } 
        
        if (!updateList.isEmpty())
          update updateList;
    }
     
    /*********************************************************************************************
  	*	FINISH
  	*
  	*
  	************************************************************************************************/
    global void finish(Database.BatchableContext c) {
    }
  
}