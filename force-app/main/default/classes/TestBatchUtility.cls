@isTest (seealldata=true)
public  class TestBatchUtility {

   
    static TestMethod void Test1() {
 
        //BatchUtility.runJob();

        BatchUtility.getJobDetails('x');
    
    }  

    static TestMethod void Test2() {
 
        //BatchUtility.runJob();

        id batchinstanceid = database.executeBatch(new BatchSAIGeneration(),100); 
    
    }  



}