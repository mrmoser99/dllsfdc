trigger VendorPointsUpdateApplication on genesis__Applications__c (After update) {
     
    genesis__Applications__c app = Trigger.new[0];
    genesis__Applications__c oldApp = Trigger.oldMap.get(app.id);
    try{ 
    
    Decimal totalPointAmount = 0.00;
    List<clcommon__Points__c> pointList = [select id,name,genesis__Application__c,clcommon__Points_Amount__c,clcommon__Points__c from
                                            clcommon__Points__c where genesis__Application__c=:app.id];
    List<Application_Fee__c> appFeeList = [select id,name,Frequency__c,Equipment__c,Application__c,Amount__c,Fee__c,Fee__r.name from Application_Fee__c where Application__c=:app.id];
    List<genesis__Application_Pricing_Detail__c> pricingList = [select id,name,genesis__Term__c,genesis__Payment_Amount_Derived__c,genesis__Application__c from
                                                               genesis__Application_Pricing_Detail__c where genesis__Application__c=:app.id];
        
    if(Trigger.isUpdate){
        if(app.Total_Equipment_Selling_Price__c != oldApp.Total_Equipment_Selling_Price__c && pointList.size()>0){
            for(integer i=0;i<pointList.size();i++){
               pointList[i].clcommon__Points_Amount__c = app.Total_Equipment_Selling_Price__c * pointList[i].clcommon__Points__c/100;
               totalPointAmount = totalPointAmount + (Decimal)pointList[i].clcommon__Points_Amount__c;
               
            }
            Update pointList;
            
            for(integer i=0;i<appFeeList.size();i++){
                if(appFeeList[i].Fee__r.name =='Vendor Points'){
                   appFeeList[i].Amount__c = totalPointAmount;
                    
                }
               
           }
            
            Update appFeeList;
        }
    }
    
    }catch(Exception ex){
        System.debug('Exception : ' +ex);
        app.addError('Exception : ' +ex + ' LineNumber :' + ex.getLineNumber());
    }
}