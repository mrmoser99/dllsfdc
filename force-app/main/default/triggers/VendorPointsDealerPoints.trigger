trigger VendorPointsDealerPoints on clcommon__Points__c (before update, After update) {

   clcommon__Points__c point = Trigger.new[0];
   clcommon__Points__c oldPoint = Trigger.oldMap.get(point.id);
    try{
        Decimal totalPointAmount = 0.00;
        List<genesis__Applications__c>  appList = [select id,name,Total_Equipment_Selling_Price__c from genesis__Applications__c
                                                    where id=:point.genesis__Application__c];
                                                                            
        List<Application_Fee__c> appFeeList = [select id,name,Frequency__c,Equipment__c,Application__c,Amount__c,Fee__c,Fee__r.name from Application_Fee__c where Application__c=:point.genesis__Application__c
                                               and Fee__r.name='Vendor Points'];
        if(Trigger.isBefore){
            if(appList.size()>0){
                if(point.clcommon__Points__c != oldPoint.clcommon__Points__c){
                    point.clcommon__Points_Amount__c =appList[0].Total_Equipment_Selling_Price__c * point.clcommon__Points__c/100;
                    System.debug('point.clcommon__Points_Amount__c =' +point.clcommon__Points__c);
                }
            }
        }
        if(Trigger.isAfter){
            List<clcommon__Points__c> pointList = [select id,name,genesis__Application__c,clcommon__Points_Amount__c,clcommon__Points__c from
                                                clcommon__Points__c where genesis__Application__c=:point.genesis__Application__c]; 
                                                
            for(integer i=0;i<pointList.size();i++){
                totalPointAmount = totalPointAmount + pointList[i].clcommon__Points_Amount__c; 
            }
                    
            System.debug('totalPointAmount = ' + totalPointAmount);
            if(appFeeList.size()>0){
                for(Integer i=0;i<appFeeList.size();i++){           
                    appFeeList[i].Amount__c = totalPointAmount;
                }
            }
            Update appFeeList;
            
        }
    }catch(Exception ex){
       point.addError('Exception :'+ ex.getMessage() + ' LineNumber :' +ex.getLineNumber());
    }
    
}