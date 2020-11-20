trigger VendorPointsPricingDetail on genesis__Application_Pricing_Detail__c (before update) {
     
    genesis__Application_Pricing_Detail__c appPricingDeatils = trigger.new[0];
    try{
        genesis__Applications__c app = [select id,name,genesis__Payment_Amount__c,genesis__Financed_Amount__c,Pricing_Details__c,genesis__Estimated_Selling_Price__c from genesis__Applications__c where id=:appPricingDeatils.genesis__Application__c];
        System.debug('app =' +app);
        List<clcommon__Points__c> points = [select id,name,genesis__Application__c,clcommon__Points__c,genesis__Points_Setup__c
                                            from clcommon__Points__c where genesis__Application__c=:app.id];
        System.debug('points =' +points);
        List<clcommon__Points_Setup__c> pointSetUpList = [select id,name,clcommon__Points__c from clcommon__Points_Setup__c where id=:points[0].genesis__Points_Setup__c];
        //System.debug('app =' +app);
        
        List<genesis__Payment_Stream__c> pmtStreamList = [select id,name,genesis__Application__c,genesis__Payment_Amount__c from genesis__Payment_Stream__c
                                                            where genesis__Application__c=:app.id];
        
        System.debug('pointSetUpList =' +pointSetUpList);
        if(trigger.isUpdate){
           if(appPricingDeatils.genesis__Selected__c==true){
               appPricingDeatils.Pre_Rate_Factor__c = appPricingDeatils.genesis__Rate_Factor__c;
               appPricingDeatils.Pre_Payment_Amount__c = appPricingDeatils.genesis__Payment_Amount_Derived__c;
               appPricingDeatils.genesis__Rate_Factor__c = (appPricingDeatils.genesis__Rate_Factor__c * (1+pointSetUpList[0].clcommon__Points__c/100));
               appPricingDeatils.genesis__Payment_Amount_Derived__c = app.genesis__Estimated_Selling_Price__c * appPricingDeatils.genesis__Rate_Factor__c;
               app.genesis__Payment_Amount__c = appPricingDeatils.genesis__Payment_Amount_Derived__c;
               
               for(Integer i=0;i<pmtStreamList.size();i++){
                  pmtStreamList[i].genesis__Payment_Amount__c = appPricingDeatils.genesis__Payment_Amount_Derived__c;
               }
            } 
            Update app; 
            //Update pmtStreamList;
        }
        
    }catch(Exception ex){
        System.debug('Exception :'+ ex.getMessage());
        appPricingDeatils.addError('Exception :'+ ex.getMessage() + ' LineNumber :' +ex.getLineNumber());
    }
    
}