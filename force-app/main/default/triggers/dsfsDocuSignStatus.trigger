/****************************************************************************************************
 * 
 * Change Log:
 * 
 * 4/2/2020 - MRM Created - make the owner the owner of the app
 * 
 ***************************************************************************************************/

trigger dsfsDocuSignStatus on dsfs__DocuSign_Status__c (before insert) {
       Map<ID,ID> appOwnerMap = new Map<ID,ID>();

        for (dsfs__DocuSign_Status__c d:trigger.new)
            appOwnerMap.put(d.application__c,null);

        List<genesis__Applications__c> aList = new List<genesis__Applications__c>();
        aLIst = [select ownerId from genesis__Applications__c where id in :appOwnerMap.keySet()];

        for (genesis__Applications__c a:aList)
            appOwnerMap.put(a.id,a.ownerId);
        
        for (dsfs__DocuSign_Status__c d:trigger.new)
            d.ownerid = appOwnerMap.get(d.application__c);
}