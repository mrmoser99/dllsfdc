trigger IntDeliveryControl on Int_Delivery_Control__c (before insert) {
    system.debug('made it into trigger');

    cllease__Office_Name__c o = [SELECT cllease__Current_System_Date__c FROM cllease__Office_Name__c];
    dateTime now = date.valueOf(o.cllease__Current_System_Date__c);
    now = now.addHours(12);

    system.debug('currrent date is: '  + o.cllease__current_system_date__c);

    String dayOfWeek = now.format('EEEE');
    
     system.debug('hello');

     system.debug('trigger new is: ' + trigger.new);

    for (Int_Delivery_Control__c d:trigger.new){
         system.debug('d is: ' + d);

       if (dayOfWeek == 'Saturday')
            d.end_of_week_indicator__c = '1';
         
       
       if (o.cllease__Current_System_Date__c.day() == 1)
            d.end_of_month_indicator__c = '1';

       d.end_of_month_indicator__c= 'J';   
    }
}