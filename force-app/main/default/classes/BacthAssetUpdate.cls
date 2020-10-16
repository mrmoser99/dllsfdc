global with sharing class BacthAssetUpdate implements Database.Batchable<Integer>,Database.Stateful, Database.AllowsCallouts{
    
    //private List<genesis__Equipment_Master__c> mstrEquipment;
    Static private List<Integer> pageNumberSet = new List<Integer>();
    Private static integer totalPageNumber;

       public BacthAssetUpdate() {
            
        BacthAssetUpdate.totalPageNumber = BacthAssetUpdate.getTotalPageNumber('models');

            //call modellist servic to get number page 
            For(Integer i=1; i<= totalPageNumber; i++){
                pageNumberSet.add(i);
            }
        }
        global List<Integer> start(Database.BatchableContext c) {  
            
            return BacthAssetUpdate.pageNumberSet;        
        }
        global void execute(Database.BatchableContext c, List<Integer> scope) { 
        
           Integer pageNumber; //ItemCount
           //for (genesis__Equipment_Master__c a:scope){
            for(Integer p:scope) {                 
            AssetUtility.getModels(p);  
         }
        }
        global void finish(Database.BatchableContext c) {
            //Todo

        }
        private static Integer getTotalPageNumber(String urlPostfix){
            Integer pageCount=1;
            HttpResponse response;
            /**  Don't use part until endpoint is exposed
             response=AssetUtility.makeCallout(urlPostfix);
            //get number of pages
          
            ModelsListJSON2Apex parsedResult=ModelsListJSON2Apex.parse(String.valueOf( response.getBody()));
            ModelsListJSON2Apex.Meta meta= parsedResult.meta;
            Integer msize=meta.size;
            integer mItems= meta.itemCount;
            */

            integer mItems=2162; //use this to fke meta.itemCount
            Integer msize=200; //use this to fke meta.size

            if(mItems > msize){
                pageCount=mItems/msize;
                if(Math.mod(mItems, msize)!= 0){
                        pageCount++;
                }

            }  
            System.debug('Total Page size: '+pageCount);
            return pageCount;
        }
}