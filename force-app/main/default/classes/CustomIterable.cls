global class CustomIterable implements Iterator<Integer>{
    
    Public List<Integer> intItems {get; set;}
    public integer i {get; set;}
    
    public CustomIterable() {
        i=0;
        Integer intTemp=CustomIterable.getTotalPageNumber('models');
        for(Integer j=1;j<=intTemp; j++){
            intItems.add(j);
        }
    
    }

   global boolean hasNext(){
        if(i>= intItems.size()){
               return false;
         }else{
               return true;
        }
    }

    global Integer next(){
        if(i==intItems.size()){
            return null;
        }
         i++;
    return intItems[i-1];
      }

      
    global static Integer getTotalPageNumber(String urlPostfix){
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