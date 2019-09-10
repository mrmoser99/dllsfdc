/*********************************************************************************************
*	This executes the sai extraction 
*
* ChangeLog:
*
*	9/9/19 - MRM Created Class
*
************************************************************************************************/
global class ExecuteSAI implements Schedulable{ 

	global void execute(SchedulableContext SC){
		id batchinstanceid = database.executeBatch(new BatchSAIGeneration(),100); 
	}
  
}