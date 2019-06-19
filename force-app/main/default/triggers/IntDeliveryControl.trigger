trigger IntDeliveryControl on Int_Delivery_Control__c (before insert) {


    cllease__Office_Name__c o = [SELECT cllease__Current_System_Date__c FROM cllease__Office_Name__c];
    dateTime now = date.valueOf(o.cllease__Current_System_Date__c);
    now = now.addHours(12);
    String dayOfWeek = now.format('EEEE');
  
    for (Int_Delivery_Control__c d:trigger.new){
       if (dayOfWeek == 'Saturday'){
            d.end_of_week_indicator__c = '1';
       }    
       
       if (o.cllease__Current_System_Date__c.day() == 1){
            d.end_of_month_indicator__c = '1';
            d.end_of_day_indicator__c='0';
      
       }
       else{
             d.end_of_month_indicator__c = '0';
       }
      
     }
 }