/*********************************************************************************************
*	This trigger is used to populate the account record with the naics code from ics
		id batchinstanceid = database.executeBatch(new BatchSAIGeneration(),100); 
*
1* ChangeLog:
*
*	10/2/19 - MRM Created  
*
************************************************************************************************/
trigger ICSExternalLEFields on ICS_External_LE_Fields__c (after insert) {

    
    List<ICS_External_LE_Fields__c> extList = new LIst<ICS_External_LE_Fields__c>();
    
    extList = [select  ICS_External_Legal_Entity__r.ICS_Application_Request__r.quick_quote__r.genesis__account__c
               from ICS_External_LE_Fields__c
               where id in :trigger.newMap.keySet()
              ];

    Map<ID,ICS_External_LE_Fields__c> eMap = new Map<ID,ICS_External_LE_Fields__c>();
    Set<ID> acctSet = new Set<ID>();
    Map<ID,Account> acctMap = new Map<ID,Account>();

    for (ICS_External_LE_Fields__c e:extList){
        acctSet.add(e.ICS_External_Legal_Entity__r.ICS_Application_Request__r.quick_quote__r.genesis__account__c);

        eMap.put(e.id,e);
    }

    List<Account> aList = new List<Account>();
    List<Account> aUpdateList = new List<Account>();
    aList = [select id 
            from Account
            where id in :acctSet];
    for (Account a:aList)
        acctMap.put(a.id,a);

    for (ICS_External_LE_Fields__c e:trigger.new){
        if (e.name__c == 'CMCL.EXTL.GENL.GlobalIndustryCode'){   //this is the naics code
            ICS_External_LE_Fields__c eTemp = eMap.get(e.id);

            Account aTemp = acctMap.get(eTemp.ICS_External_Legal_Entity__r.ICS_Application_Request__r.quick_quote__r.genesis__account__c);
            aTemp.naics__c = e.value__c;
            aUpdateList.add(aTemp);

        }
    }
    if (!aUpdateList.isEmpty())
        update aUpdateList;

}