global class  ExecuteBatchStatsReport  implements Schedulable{
    global void execute(SchedulableContext SC){
		id batchinstanceid = database.executeBatch(new BatchStatsReport(),1); 
	}
  
}