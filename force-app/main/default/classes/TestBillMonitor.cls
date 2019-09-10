@isTest(seealldata=true)
public with sharing class TestBillMonitor {
 		
	static testmethod void test1(){
        id batchinstanceid = database.executeBatch(new BatchGenWatchBilling());
        System.abortJob(batchinstanceid);
 	}
}