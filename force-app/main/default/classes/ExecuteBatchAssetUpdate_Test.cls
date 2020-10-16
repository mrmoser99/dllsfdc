@isTest private  class ExecuteBatchAssetUpdate_Test {
    @IsTest
    static void testExecute(){
        
        Test.startTest();
            String jobId=  ExecuteBatchAssetUpdate.ScheduleExecuteBatchAssetUpdate();
        Test.stopTest();

       System.assertNotEquals(null, jobId);
        
    }
}