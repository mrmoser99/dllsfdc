/*********************************************************************************************
*	This executes the npba calculation
*
* ChangeLog:
*
*	7/13/2020 - MRM Created Class
*
************************************************************************************************/
global class ExecuteNPBACalc implements Schedulable{ 

	global void execute(SchedulableContext SC){
		id batchinstanceid = database.executeBatch(new BatchNPBACalc(),100); 
	}
  
}