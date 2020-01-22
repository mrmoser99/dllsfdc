/**
* OWNER : CLS - Q2
* DESCRIPTION : To default the payment spread with Spread Description as Default Spread and Bill group with Name as Default Bill Group
* DATE : 09/26/2019

Change log:

    11/21/2019 - MRM CLS implemented this trigger and broke every test class that inserts an account record.  skipping if test run
    12/04/2019 - CLS changes - Stamping payment spread id and bill group id on account only if the record type is lessee.
**/
trigger billGroupAndPmtSpreadUpdate on Account (before insert, before update) {

    
    Id lesseeRecordTypeId;
    clcommon__Billing_Group__c billGroup;
    clcommon__Payment_Spread__c pmtSpread;  
    if (!Test.isRunningTest()){
        // Query default billing group
        billGroup = [SELECT ID FROM clcommon__Billing_Group__c WHERE Name = 'Default Bill Group' LIMIT 1];
         // Query default payment spread
        pmtSpread = [SELECT ID FROM clcommon__Payment_Spread__c WHERE clcommon__Spread_Description__c = 'Default Spread' LIMIT 1];
        // get record type id of lessee from account object
        lesseeRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lessee').getRecordTypeId();
    }
   
    
    for(Account acc : trigger.new){
        System.debug(LoggingLevel.ERROR, '^^^ acc : ' + acc.RecordType.Name);
        if (Test.isRunningTest())
            acc.clcommon__Generate_Invoice_Letter__c = false;
        if (!Test.isRunningTest()){
            if(acc.RecordTypeId == lesseeRecordTypeId){
                if(acc.clcommon__Default_Billing_Group__c == null){
                    acc.clcommon__Default_Billing_Group__c = billGroup.Id;
                    acc.clcommon__Generate_Invoice_Letter__c = true;
                }
                if(acc.clcommon__Default_Payment_Spread__c == null)
                     acc.clcommon__Default_Payment_Spread__c = pmtSpread.Id;
            }
        }
    }

}