/*********************************************************************************************
*	Description     :   This batch class update newco equipment master from gard
*   Name            :   BacthGardUPdate
*   Change Log:
    10/13/2020 - MRM Created
************************************************************************************************/
global class BatchGardUpdate implements Database.Batchable<Integer>,Database.Stateful, Database.AllowsCallouts{
   
    private List<Integer> listPageNumber = new List<Integer>();
    private  integer totalPageNumber;
    public class MyException extends Exception {}
          
    /************************************************************************************************    
    * Description  :   Constructor for BatchGardUpdate Class
    *************************************************************************************************/   
    public BatchGardUpdate() {
       
        //Call the method  getTotalPageNumber to intialize the total page number
        this.totalPageNumber = BatchGardUpdate.getTotalPageNumber('models');
        // Convert the totalPageNumber to the items listPageNumber
        For(Integer i=1; i<= totalPageNumber; i++){
            this.listPageNumber.add(i);                
        }
         
     }
     /************************************************************************************************    
     * Description  :   Start Method to start the Batch
     *************************************************************************************************/       
     global List<Integer> start(Database.BatchableContext bc) {  
        if(Test.isRunningTest()){
            List<Integer> tstList=new List<Integer>{1};
            return tstList;
        }else{
           //return the static member variable listPageNumber
            return this.listPageNumber; 
        }       
     }
     /************************************************************************************************    
     * Description  :   Execute Method to upsert the genesis__Equipment_Master__c records
     *************************************************************************************************/       
     global void execute(Database.BatchableContext bc, List<Integer> scope) { 
         
            List<genesis__Equipment_Master__c> equipmentList =new List<genesis__Equipment_Master__c>();  
           
            Integer intPage;
            for(Integer p:scope) {  
                intPage=p;
                List<genesis__Equipment_Master__c> tmpEquipmentList= new List<genesis__Equipment_Master__c>();
                tmpEquipmentList.addAll(AssetUtility.getModels(p));
                if(tmpEquipmentList.size()>0){
                    equipmentList.addAll(tmpEquipmentList);
                }
            }
             
            if(equipmentList.size() > 0){
                String customErrMsg;
                try{
                    Database.UpsertResult [] upsrtResults=Database.Upsert(equipmentList, genesis__Equipment_Master__c.Composite_Key__c,false);
                    
                    for(Database.UpsertResult rslt: upsrtResults){
                        if(rslt.isSuccess()){
                            continue;
                        }else {
                            for(Database.Error err:rslt.errors){
                                //if the err.getMessage() doesn't cotainins dupplicate throw exception.
                                if(!err.getMessage().contains('DUPLICATE')) {
                                     customErrMsg='Page= '+String.valueOf(intPage)+' '+err.getMessage();
                                    throw new MyException (err.getMessage());
                                }else{
                                    cllease__Batch_Process_Log__c bchLog1 = new cllease__Batch_Process_Log__c();
                                    bchLog1.name = 'BatchGardUpdate';
                                    bchLog1.cllease__Message__c ='Exception : '+'Page= '+String.valueOf(intPage)+': '+err.getMessage();
                                    insert bchLog1;
                                }
                            }
                        }
                    }
                }Catch(Exception ex){
                    cllease__Batch_Process_Log__c bchLog = new cllease__Batch_Process_Log__c();
                    bchLog.name = 'BatchGardUpdate';
                    bchLog.cllease__Message__c ='Exception : '+'Page= '+String.valueOf(intPage)+': '+customErrMsg+'\t'+ ex.getMessage() + '  - ' + ex.getStackTraceString();
                    insert bchLog;
                }
            }
    }
    /************************************************************************************************    
    * Description  :   Finish method to accomplish the post job processing action 
    *************************************************************************************************/       
    global void finish(Database.BatchableContext bc) {
    }
    
    /************************************************************************************************    
    * Description  :   The getTotalPageNumber method calculates the total number of pages for each Models callout  
    *************************************************************************************************/       
    private static Integer getTotalPageNumber(String urlPostfix){
    
        Integer pageCount=1;
        HttpResponse response;
       //Make a callout to get response meta data
        response=AssetUtility.makeCallout(urlPostfix);
        ModelsJSON2Apex parsedResult=ModelsJSON2Apex.parse(String.valueOf( response.getBody()));
        ModelsJSON2Apex.Meta meta= parsedResult.meta;
        Integer msize= integer.valueOf(System.Label.Asset_Page_Size);
        integer mItems= meta.itemCount;
           
        if(mItems > msize){
            pageCount=mItems/msize;
            if(Math.mod(mItems, msize)!= 0){
                pageCount++;
            }
        }  
        return pageCount;
    }
  }