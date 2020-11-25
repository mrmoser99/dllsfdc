@isTest(seealldata=true)
public class TestBatchGardUpdate{

	
	static testmethod void testMethod1() {
		id batchinstanceid = database.executeBatch(new BatchGardUpdate(),1); 
	}

}