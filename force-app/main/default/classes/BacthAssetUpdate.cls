/*********************************************************************************************
*	Description     :   This batch class will upsert the genesis__Equipment_Master__c records using Composite_Key__c field
*   Name            :   BacthAssetUpdate
*   Author          :   Teshale Zewdie Accenture
*   Created Date    :   10-14-2020  
*   User Story      :   US...
*   Last Modified By : 
*   Last Modified Date : 
*
************************************************************************************************/
global class BacthAssetUpdate implements Database.Batchable<Integer>,Database.Stateful, Database.AllowsCallouts{
   
   private List<Integer> listPageNumber = new List<Integer>();
   private  integer totalPageNumber;
   
   public class MyException extends Exception {

   }
         
    /************************************************************************************************    
    * @Description  :   Constructor for BacthAssetUpdate Class
    * @Parameter    :   none
    * @Return type  :   none
    * @Created By   :   Teshale Zewdie Accenture
    * @Created Date :   10-14-2020  
    * User Story    :   US
    *************************************************************************************************/   
    public BacthAssetUpdate() {
      
       //Call the method  getTotalPageNumber to intialize the total page number
       this.totalPageNumber = BacthAssetUpdate.getTotalPageNumber('models');
        // Convert the totalPageNumber to the items listPageNumber
        For(Integer i=1; i<= totalPageNumber; i++){
                this.listPageNumber.add(i);                
        }
        
        system.debug('BacthAssetUpdate CHK 01. Constructor: List of Page Numbers '+this.listPageNumber.size());
    }
    /************************************************************************************************    
    * @Description  :   Start Method to start the Batch
    * @Parameter    :   Database.BatchableContext
    * @Return type  :   List<Integer>
    * @Created By   :   Teshale Zewdie Accenture
    * @Created Date :   10-14-2020  
    * User Story    :   US..
    *************************************************************************************************/       
    global List<Integer> start(Database.BatchableContext bc) {  
            System.debug('BacthAssetUpdate CHK 02. Start: '+listPageNumber);
            if(Test.isRunningTest()){
                List<Integer> tstList=new List<Integer>{1};
                return tstList;
            }else{
            //return the static member variable listPageNumber
            return this.listPageNumber; 
            }       
    }
    /************************************************************************************************    
    * @Description  :   Execute Method to upsert the genesis__Equipment_Master__c records
    * @Parameter    :   Database.BatchableContext, List<Integer>
    * @Return type  :   void
    * @Created By   :   Teshale Zewdie Accenture
    * @Created Date :   10-14-2020  
    * User Story    :   US..
    *************************************************************************************************/       
    global void execute(Database.BatchableContext bc, List<Integer> scope) { 
        
         List<genesis__Equipment_Master__c> equipmentList =new List<genesis__Equipment_Master__c>();  
         Map<String, genesis__Equipment_Master__c> equipmentMap= new Map<String, genesis__Equipment_Master__c>();
         System.debug('BacthAssetUpdate CHK 03. Execute: Scope size in execute '+scope.size());
         //To get the list of genesis__Equipment_Master__c records, 
         //execute the AssetUtility.getModels with page numbers 
         Integer intPage;
          for(Integer p:scope) {  
            intPage=p;
            List<genesis__Equipment_Master__c> tmpEquipmentList= new List<genesis__Equipment_Master__c>();
            tmpEquipmentList.addAll(AssetUtility.getModels(p));
            if(tmpEquipmentList.size()>0){
                equipmentList.addAll(tmpEquipmentList);
            }
            //equipmentList.addAll(AssetUtility.getModels(p));
            System.debug('BacthAssetUpdate CHK 03a. scope executed Page#: '+p);
           }
            
           if(equipmentList.size()>0){
               for(genesis__Equipment_Master__c equipment: equipmentList){
                    System.debug('BacthAssetUpdate CHK 03b. Composite_Key__c value: '+equipment.Composite_Key__c);
                   
                    equipmentMap.put(equipment.Composite_Key__c,equipment);
                }
                              
               //Upsert the genesis__Equipment_Master__c with Composite_Key__c;
                System.debug('BacthAssetUpdate CHK 03c. Size: '+equipmentList.size()+' equipmentList: '+equipmentList);
                String customErrMsg;
                try{
                //Database.UpsertResult [] upsrtResults=Database.Upsert(equipmentList, genesis__Equipment_Master__c.Composite_Key__c,true);
                Database.UpsertResult [] upsrtResults=Database.Upsert(equipmentList, genesis__Equipment_Master__c.Composite_Key__c,false);
               
                //Database.UpsertResult [] upsrtResults=Database.Upsert(equipmentMap.values(), genesis__Equipment_Master__c.Composite_Key__c,true);
              
               for(Database.UpsertResult rslt: upsrtResults){
                    if(rslt.isSuccess()){
                        System.debug('BacthAssetUpdate Upsert result CHK 03d.'+rslt.getId());
                    }else {
                        for(Database.Error err:rslt.errors){
                            //if the err.getMessage() doesn't cotainins dupplicate throw exception.
                            if(!err.getMessage().contains('DUPLICATE')) {
                                customErrMsg='Page= '+String.valueOf(intPage)+' '+err.getMessage();
                                throw new MyException (err.getMessage());
                            }else{
                                cllease__Batch_Process_Log__c bchLog1 = new cllease__Batch_Process_Log__c();
                                bchLog1.name = 'BatchAssetUpdate';
                                bchLog1.cllease__Message__c ='Exception : '+'Page= '+String.valueOf(intPage)+': '+err.getMessage();
                                insert bchLog1;
                            }

                                
                            system.debug('BacthAssetUpdate Upsert Error Info CHK 03e.'+LoggingLevel.ERROR+'\n  Status code: '+err.getStatusCode()+'\n Msg: '+err.getMessage()+'\n  Fields: '+err.getFields());
                        }
                    }
                }
            }Catch(Exception ex){
                cllease__Batch_Process_Log__c bchLog = new cllease__Batch_Process_Log__c();
                bchLog.name = 'BatchAssetUpdate';
                bchLog.cllease__Message__c ='Exception : '+'Page= '+String.valueOf(intPage)+': '+customErrMsg+'\t'+ ex.getMessage() + '  - ' + ex.getStackTraceString();
                insert bchLog;
                system.debug('Error Messge: '+ex.getMessage() +'\n Stack: '+ex.getStackTraceString());
                //Throw exception with old 
                
            }
            }
           
           System.debug('BacthAssetUpdate CHK 03f.Saved items: '+equipmentList.size()); 
    }
    /************************************************************************************************    
    * @Description  :   Finish method to accomplish the post job processing action 
    * @Parameter    :   Database.BatchableContext
    * @Return type  :   void
    * @Created By   :   Teshale Zewdie Accenture
    * @Created Date :   10-14-2020  
    * User Story    :   US..
    *************************************************************************************************/       
    global void finish(Database.BatchableContext bc) {
        /*        
        if(!Test.isRunningTest())
        Id batchJobId= Database.executeBatch(new BacthAssetUpdate(),1);
         */    

    }
    /************************************************************************************************    
    * @Description  :   The getTotalPageNumber method calculates the total number of pages for each Models callout  
    * @Parameter    :   String
    * @Return type  :   Integer
    * @Created By   :   Teshale Zewdie Accenture
    * @Created Date :   10-14-2020  
    * User Story    :   US..
    *************************************************************************************************/       

    private static Integer getTotalPageNumber(String urlPostfix){
            Integer pageCount=1;
            HttpResponse response;
            //Make a callout to get response meta data
            response=AssetUtility.makeCallout(urlPostfix);
            
            //To the get number of pages
            //Get the parsed value out of the string value of the response body 
            ModelsJSON2Apex parsedResult=ModelsJSON2Apex.parse(String.valueOf( response.getBody()));
            //Get the meta data from parsed result
            ModelsJSON2Apex.Meta meta= parsedResult.meta;
            //Get the size and item count
           // String sizeString=System.Label.Asset_Page_Size;
            Integer msize=90;//meta.size;
            integer mItems= meta.itemCount;
            system.debug('CHK 04. Metada Items= '+mItems);
            if(mItems > msize){
                //Divide the items by size and assign to the pagecount. 
                pageCount=mItems/msize;
                //if the reminder of the devision greater than 0 increment the pagecount 
                if(Math.mod(mItems, msize)!= 0){
                        pageCount++;
                }

            }  
            System.debug('BacthAssetUpdate CHK 4. Total Page Number: '+pageCount);
           /* List<Integer> lstModelCode=new List<Integer>();
            for(ModelsJSON2Apex.Data modelData: parsedResult.data){
                lstModelCode.add(modelData.code);
                
            }
            System.debug('CHK 5. Total Model Codes: '+lstModelCode.size());*/
           return pageCount;
           //return 4;
        }
      /*  global void execute (SchedulableContext sc){
            database.executeBatch(this,1);
        }*/
}