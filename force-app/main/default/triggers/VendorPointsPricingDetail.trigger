trigger VendorPointsPricingDetail on genesis__Application_Pricing_Detail__c (After Insert) {
   
    Savepoint sp = database.setsavepoint();
    genesis__Application_Pricing_Detail__c appPricingDeatils = new genesis__Application_Pricing_Detail__c();
    appPricingDeatils.id=trigger.new[0].id;
    appPricingDeatils.genesis__Rate_Factor__c = trigger.new[0].genesis__Rate_Factor__c;
    appPricingDeatils.genesis__Payment_Amount_Derived__c = trigger.new[0].genesis__Payment_Amount_Derived__c;
   
   
    if(CLVendorPoint.isDefaultProgram1){
        
        CLVendorPoint.isDefaultProgram1 = false;
        
        try{
            
            Decimal totalPoints=0.00;
            genesis__Applications__c app =new genesis__Applications__c();
            app.id = trigger.new[0].genesis__Application__c;
            if(trigger.isInsert){
                List<clcommon__Points__c> pointsList = [select id,name,genesis__Application__r.genesis__Financed_Amount__c,clcommon__Points_Type__c,clcommon__Points_Amount__c,genesis__Application__c,clcommon__Points__c,genesis__Points_Setup__c
                                                    from clcommon__Points__c where genesis__Application__c=:app.id];
                appPricingDeatils.Pre_Rate_Factor__c = appPricingDeatils.genesis__Rate_Factor__c;
                appPricingDeatils.Pre_Payment_Amount__c = appPricingDeatils.genesis__Payment_Amount_Derived__c;
                
                if(pointsList.size()>0){ 
                    for(integer i=0;i<pointsList.size();i++){
                        if(pointsList[i].clcommon__Points_Type__c=='Vendor'){
                            totalPoints = totalPoints + pointsList[i].clcommon__Points__c;
                        }
                            
                    }
                }
                System.debug('appPricingDeatils=' +appPricingDeatils);
                appPricingDeatils.genesis__Rate_Factor__c = (appPricingDeatils.genesis__Rate_Factor__c * (1+totalPoints/100));
                appPricingDeatils.genesis__Payment_Amount_Derived__c = pointsList[0].genesis__Application__r.genesis__Financed_Amount__c  * appPricingDeatils.genesis__Rate_Factor__c;
                app.genesis__Payment_Amount__c = appPricingDeatils.genesis__Payment_Amount_Derived__c;

                Update appPricingDeatils;
                
                Update app;

            }

        }catch(Exception ex){
            database.rollback(sp);
            System.debug('Exception : ' + ex + ' Error Message  :' +ex.getMessage() + ' LineNumber :' +ex.getLineNumber());
            appPricingDeatils.addError('Exception :'+ ex.getMessage() + ' LineNumber :' +ex.getLineNumber());
        }
    }
    
    

}