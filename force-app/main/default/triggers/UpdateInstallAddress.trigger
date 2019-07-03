trigger UpdateInstallAddress on genesis__Application_Equipment__c (before insert, before update) {
    
    System.debug(LoggingLevel.ERROR, 'Starting UpdateInstallAddress(Application Equipment) in Trigger');
    Set<Id> appIds = new Set<Id>();
    Set<Id> accountIds = new Set<Id>();
    Map<Id, Id> appAccountMap = new Map<Id, Id>();
    // Retrieving All Application IDs linked to Equipemnts
    for(genesis__Application_Equipment__c appEquip: trigger.new){
        if(appEquip.genesis__Application__c != null) {
            appIds.add(appEquip.genesis__Application__c);
        }
    }

    if(appIds.size() > 0) {
        // Get All Accounts linked to Applications and also create Map for lookup later 
        for(genesis__Applications__c app : [SELECT Id, genesis__Account__c FROM genesis__Applications__c WHERE Id IN :appIds]) {
            if(app.genesis__Account__c != null) {
                accountIds.add(app.genesis__Account__c);
                appAccountMap.put(app.Id, app.genesis__Account__c);
            }           
        }
    }
  
    // Retrieving All Account & Install addresses with Addresses and update in Equipment's Install Address1
    if(accountIds.size() > 0) {
        // Query Account Detials
        System.debug(LoggingLevel.ERROR, 'accountIds: '+accountIds);
        Map<Id, Account> accountInstallAddressMap 
                = new Map<Id, Account>([SELECT Id,
                                            (SELECT Id
                                             FROM Addresses__r
                                             WHERE Install_At__c = true
                                             ORDER by Name )
                                        FROM Account
                                        WHERE Id IN :accountIds]);

        // Updating the Install Address on Equipment only when there is only one install address from linked Account
        for(genesis__Application_Equipment__c appEquip: trigger.new) {
            System.debug(LoggingLevel.ERROR, ' Processing appEquip: '+appEquip);
            //appEquip.genesis__Other_Financed_fees__c = appEquip.Oracle_Trade_Up_Amount__c;
            if(appEquip.genesis__Application__c != null && appEquip.Install_Address1__c == null
                && appAccountMap.containsKey(appEquip.genesis__Application__c)) {
                // Get Install Address and update in Install Address
                Id accountId = appAccountMap.get(appEquip.genesis__Application__c);
                Account acc = accountInstallAddressMap.get(accountId);
                List<Address__c> installAddresses = acc.Addresses__r;
                System.debug(LoggingLevel.ERROR, ' Processing installAddresses: '+installAddresses);
                if(installAddresses.size() >= 1) {
                    appEquip.Install_Address1__c = installAddresses.get(0).Id;
                }
            }
        }
    }


}