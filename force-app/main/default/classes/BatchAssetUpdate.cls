global class BatchAssetUpdate implements Database.Batchable<Integer>,Database.Stateful, Database.AllowsCallouts{
    
    
    Static private List<Integer> pageNumberSet = new List<Integer>();
    Private static integer totalPageNumber;
/*
       public BatchAssetUpdate() {
            
      ////  BatchAssetUpdate.totalPageNumber = BatchAssetUpdate.getTotalPageNumber('models');

            //call modellist servic to get number page 
      ////      For(Integer i=1; i<= totalPageNumber; i++){
      ////          pageNumberSet.add(i);                
       ////     }
       CustomIterable cTerable= new CustomIterable();
       pageNumberSet= cTerable.intItems.clone();

        }*/

    /*********************************************************************************************
    *  START
    *
    ************************************************************************************************/ 
        global List<Integer> start(Database.BatchableContext c) {  
         List<integer> iList= new List<Integer>();
        /*  iList.add(1);
         iList.add(2);
         iList.add(3);
         iList.add(4);
         iList.add(5);*/
        
        Integer iPages= BatchAssetUpdate.getTotalPageNumber('models'); 
         System.debug('Start Pages'+iPages);
         for(Integer i=0; i<=iPages; i++) {
            iList.add(i);
         }

         return iList;
               
        }
    /*********************************************************************************************
    *  EXECUTE
    *
    *
    ************************************************************************************************/
        global void execute(Database.BatchableContext c, List<Integer> scope) { 
            system.debug('************** scope is' + scope);
            for(Integer p:scope) {                 
                AssetUtility.getModels(p);  
            }
        }
    /*********************************************************************************************
    *  finish
    *
    *
    ************************************************************************************************/
        global void finish(Database.BatchableContext c) {
            //Todo

        }
    /*********************************************************************************************
    *  getTotalPageNumber
    *
    *
    ************************************************************************************************/
        public static Integer getTotalPageNumber(String urlPostfix){
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