/*********************************************************************************************
*	This batch calculates npba for all leases
*    
*   

* ChangeLog:
*
*	7/10/2020 - MRM Created Class

to execute:  

Id batchJobId= Database.executeBatch(new MarksBatchIterable(), 1); //Btch size=1
*
************************************************************************************************/
global class MarksBatchIterable implements Database.Batchable<Integer>,Database.Stateful{
    /*********************************************************************************************
  	*	T
  	*
  	*
  	************************************************************************************************/
   
	
    /*********************************************************************************************
  	*	START
  	*
  	************************************************************************************************/				
    global Iterable<Integer> start(Database.BatchableContext c) {    
        List<Integer> iLIst = new List<Integer>();
        iList.add(1);
        iList.add(2);
        iList.add(3);

        return iList;
    }
  	/*********************************************************************************************
  	*	EXECUTE
  	*
  	*
  	************************************************************************************************/
    global void execute(Database.BatchableContext c, List<integer> scope) { 
        
        system.debug('************** scope is' + scope);
        
    }
     
    /*********************************************************************************************
  	*	FINISH
  	*
  	*
  	************************************************************************************************/
    global void finish(Database.BatchableContext c) {
    }
  
}