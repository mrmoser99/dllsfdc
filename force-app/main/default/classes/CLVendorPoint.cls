public class CLVendorPoint {
    public static void updateEquipment(){
        
    }
    
    public static String updatePricingDetail(String appPricingId){
      try{
           
            List<genesis__Application_Pricing_Detail__c> appPricingList = [select id,name,genesis__Application__c,genesis__Application__r.genesis__Estimated_Selling_Price__c,Pre_Rate_Factor__c,Pre_Payment_Amount__c,
                                                                          genesis__Payment_Amount_Derived__c,genesis__Rate_Factor__c from genesis__Application_Pricing_Detail__c
                                                                          where id=:appPricingId];
            /*List<clcommon__Points__c> pointsList = [select id,name,genesis__Application__c,clcommon__Points__c,clcommon__Points_Amount__c,
                                                         genesis__Points_Setup__c,clcommon__Points_Type__c from clcommon__Points__c 
                                                   where genesis__Application__c=:appPricingList[0].genesis__Application__c];*/
            List<clcommon__Points_Setup__c> pointsList = [select id,name,clcommon__Points__c from clcommon__Points_Setup__c where id='aDn5C000000012gSAA'];
            System.debug('pointsList=' +pointsList);
            System.debug('appPricingList=' +appPricingList);
            if(appPricingList.size()>0){
               for(genesis__Application_Pricing_Detail__c pricing : appPricingList){
                    appPricingList[0].Pre_Rate_Factor__c =  pricing.genesis__Rate_Factor__c;
                    appPricingList[0].Pre_Payment_Amount__c = pricing.genesis__Payment_Amount_Derived__c;
                    appPricingList[0].genesis__Rate_Factor__c = (appPricingList[0].genesis__Rate_Factor__c * (1+pointsList[0].clcommon__Points__c/100));
                    appPricingList[0].genesis__Payment_Amount_Derived__c = appPricingList[0].genesis__Application__r.genesis__Estimated_Selling_Price__c * appPricingList[0].genesis__Rate_Factor__c;
               }
                /*for(clcommon__Points__c point : pointsList){
                    appPricingList[0].genesis__Rate_Factor__c = (appPricingList[0].genesis__Rate_Factor__c * (1+point.clcommon__Points__c/100));
                    appPricingList[0].genesis__Payment_Amount_Derived__c = appPricingList[0].genesis__Application__r.genesis__Estimated_Selling_Price__c * appPricingList[0].genesis__Rate_Factor__c;
                }*/
                
                update appPricingList;
            }
          return 'Pricing update susuccessfully';
      }catch(Exception ex){
          System.debug('Exception :' +ex);
          return 'Exception : ' + ex.getMessage() + ' , LineNumber : ' + ex.getLineNumber();
      }
         
    }

}