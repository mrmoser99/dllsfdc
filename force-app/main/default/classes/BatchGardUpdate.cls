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
        ModelsJSON2Apex parsedResult;
       //Make a callout to get response meta data
        if (!Test.isRunningTest()){
           response=AssetUtility.makeCallout(urlPostfix);
           parsedResult=ModelsJSON2Apex.parse(String.valueOf( response.getBody()));
        }
        else{
            parsedResult=ModelsJSON2Apex.parse ('{"meta":{"page":1,"size":20,"sort":"name:a","itemCount":4714},"data":[{"id":9152,"code":31009977,"name":"100mm Master Macro","isActive":true,"titling":false,"serialized":false,"referencePrice":40190.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9166,"code":31009991,"name":"100mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":35690.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9149,"code":31009974,"name":"100mm Master Prime Anamorphic","isActive":true,"titling":false,"serialized":false,"referencePrice":52755.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9181,"code":31010006,"name":"100mm R Ultra Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":21415.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9153,"code":31009978,"name":"12mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":47945.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9170,"code":31009995,"name":"12mm R Ultra Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":32430.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9167,"code":31009992,"name":"135mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":39570.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9150,"code":31009975,"name":"135mm Master Prime Anamorphic","isActive":true,"titling":false,"serialized":false,"referencePrice":60515.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9182,"code":31010007,"name":"135mm R Ultra Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":25450.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9154,"code":31009979,"name":"14mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":38635.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9171,"code":31009996,"name":"14mm R Ultra Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":26845.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":8352,"code":31009180,"name":"1501X Auto folder","isActive":true,"titling":false,"serialized":true,"referencePrice":1555.0,"brandCode":30002005,"masterAssetTypeCode":107,"assetTypeCode":40000910,"programCode":53},{"id":9168,"code":31009993,"name":"150mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":44845.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9155,"code":31009980,"name":"16mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":34605.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9172,"code":31009997,"name":"16mm R Ultra Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":21415.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":3232,"code":31004110,"name":"1711","isActive":true,"titling":false,"serialized":true,"referencePrice":3970.0,"brandCode":30002005,"masterAssetTypeCode":107,"assetTypeCode":40000686,"programCode":53},{"id":9151,"code":31009976,"name":"180mm Master Prime Anamorphic","isActive":true,"titling":false,"serialized":false,"referencePrice":66720.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9183,"code":31010008,"name":"180mm R Ultra Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":27775.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":11931,"code":31012864,"name":"1812","isActive":true,"titling":false,"serialized":true,"referencePrice":2527.0,"brandCode":30002005,"masterAssetTypeCode":107,"assetTypeCode":40000686,"programCode":53},{"id":9156,"code":31009981,"name":"18mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":32585.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53}],"links":{"self":"http://assetstst1.waynemo.dll.corp:10400/api/v1/programs/53/models?page=1"}}');
        }
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