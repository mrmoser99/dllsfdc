global class BacthAssetUpdate implements Database.Batchable<Integer>,Database.Stateful, Database.AllowsCallouts{
   //global class BacthAssetUpdate implements Database.Batchable<Integer>, Database.AllowsCallouts{ 

   
   private List<Integer> listPageNumber = new List<Integer>();
   private  integer totalPageNumber;

       public BacthAssetUpdate() {
            
       
       this.totalPageNumber = BacthAssetUpdate.getTotalPageNumber('models');

            //call modellist servic to get number page 
            For(Integer i=1; i<= totalPageNumber; i++){
                this.listPageNumber.add(i);                
            }
            system.debug('CHK 01. Constructor: List of Page Numbers '+this.listPageNumber.size());
        }
        global List<Integer> start(Database.BatchableContext bc) {  
            System.debug('CHK 02. Start '+listPageNumber);
            return this.listPageNumber;        
        }
        global void execute(Database.BatchableContext bc, List<Integer> scope) { 
        
         List<genesis__Equipment_Master__c> equipmentList =new List<genesis__Equipment_Master__c>();  
         System.debug('CHK 03. Execute: Scope size in execute '+scope.size());
          for(Integer p:scope) {                               
            equipmentList.addAll(AssetUtility.getModels(p));
              System.debug('CHK 03a. scope executed Page#: '+p);
           }
           if(equipmentList.size()>0){

    //          upsert CalledEqupments Composite_Key__c;
                System.debug('CHK 03b. equipmentList#: '+equipmentList);
                Database.UpsertResult [] upsrtResults=Database.Upsert(equipmentList, Composite_Key__c,true);
                for(Database.UpsertResult rslt: upsrtResults){
                    if(rslt.isSuccess()){
                        System.debug('Upsert result CHK 03c.'+rslt.getId());
                    }else {
                        for(Database.Error err:rslt.errors){
                            system.debug('Upsert Error Info CHK 03d.'+LoggingLevel.ERROR+'\n  Status code: '+err.getStatusCode()+'\n Msg: '+err.getMessage()+'\n  Fields: '+err.getFields());
                        }
                    }
                }
            }
           
           System.debug('CHK 03e.Saved items: '+equipmentList.size()); 
        }
        global void finish(Database.BatchableContext bc) {
            //Todo

        }
        private static Integer getTotalPageNumber(String urlPostfix){
            Integer pageCount=1;
            HttpResponse response;
            
            response=AssetUtility.makeCallout(urlPostfix);
            
            //get number of pages
          
            ModelsJSON2Apex parsedResult=ModelsJSON2Apex.parse(String.valueOf( response.getBody()));
            ModelsJSON2Apex.Meta meta= parsedResult.meta;
            Integer msize=meta.size;
            integer mItems= meta.itemCount;

            if(mItems > msize){
                pageCount=mItems/msize;
                if(Math.mod(mItems, msize)!= 0){
                        pageCount++;
                }

            }  
            System.debug('Total Page Number: '+pageCount);
            return pageCount;
        }
      /*  global void execute (SchedulableContext sc){
            database.executeBatch(this,1);
        }*/
}