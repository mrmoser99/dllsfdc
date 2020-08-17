@isTest(seealldata=true)
public class TestBatchNPBACalc{

	
	static testmethod void testMethod1() {
		id batchinstanceid = database.executeBatch(new BatchNPBACalc(),1); 
	}

}