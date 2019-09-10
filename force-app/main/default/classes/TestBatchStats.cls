@isTest(seealldata=true)

public with sharing class TestBatchStats {
 		
	static testmethod void test1(){
		
		id batchinstanceid = database.executeBatch(new BatchStatsReport(),100); 
		
 	}
}