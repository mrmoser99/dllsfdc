@isTest (seealldata=true)
public  class TestBatchUtility2 {

   

    static TestMethod void Test2() {
 
        //BatchUtility.runJob();

        id batchinstanceid = database.executeBatch(new BatchSAIGeneration(),1); 
    
    }  



}