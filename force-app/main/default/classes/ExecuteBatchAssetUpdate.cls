global with sharing class ExecuteBatchAssetUpdate implements Schedulable {

       
        global void execute(SchedulableContext sc) {
           Id batchJobId= Database.executeBatch(new BacthAssetUpdate(), 100); //Btch size= 100
        }
        
}