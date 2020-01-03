@isTest(seealldata=true)

public with sharing class TestSAI {
 		
	static testmethod void test1(){
		
		id batchinstanceid = database.executeBatch(new BatchSAIGeneration(),100); 
		
 	}
}