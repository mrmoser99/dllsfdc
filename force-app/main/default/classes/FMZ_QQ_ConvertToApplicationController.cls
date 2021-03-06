global without sharing class FMZ_QQ_ConvertToApplicationController {

    @AuraEnabled
    public static String convertToApplication(Id quoteId) {
        genesis__Quick_Quotes__c qq = [
                SELECT Id, genesis__Status__c, Email_Address__c, genesis__Account__c, genesis__Account__r.Email_Address__c
                FROM genesis__Quick_Quotes__c
                WHERE Id =: quoteId
        ];
        Map<String, String> response = new Map<String, String>();
        if(String.isBlank(qq.Email_Address__c) && String.isBlank(qq.genesis__Account__r.Email_Address__c)){
            response.put(RESPONSE_KEYWORD_STATUS, STATUS_ERROR);
            response.put(RESPONSE_KEYWORD_MESSAGE, 'Email is required to Convert to Application');
            return makeJSONString(response);
        }else{
            Account acc = new Account(Id = qq.genesis__Account__c);
            if(String.isBlank(qq.Email_Address__c)){
                qq.Email_Address__c = qq.genesis__Account__r.Email_Address__c;
            }else{
                acc.Email_Address__c = qq.Email_Address__c;
            }
            List<Address__c> addresses = [
                    SELECT Id, Email_Address__c, Bill_To_Usage__c, Validation_Status__c, Validation_Time_Stamp__c
                    FROM Address__c
                    WHERE Account__c =: acc.Id
                    ORDER BY LastModifiedDate
            ];
            if(addresses.size() > 0){
                Address__c billing;

                //Gets most recent Billing Address
                for(Address__c a : addresses){
                    if(a.Bill_To_Usage__c){
                        billing = a;
                    }
                }

                if(billing == null){
                    billing = addresses.get(addresses.size() - 1);
                    billing.Bill_To_Usage__c = true;
                    if(String.isBlank(billing.Email_Address__c)){
                        billing.Email_Address__c = qq.Email_Address__c;
                    }
                    acc.Billing_Address_Validation_Status__c = billing.Validation_Status__c;
                    acc.Billing_Address_Validation_Timestamp__c = billing.Validation_Time_Stamp__c;
                    update billing;
                }

            }else{
                response.put(RESPONSE_KEYWORD_STATUS, STATUS_ERROR);
                response.put(RESPONSE_KEYWORD_MESSAGE, 'The Associated Account Requires an Address');
                return makeJSONString(response);
            }
            update acc;
        }
        if(qq.genesis__Status__c == 'CONVERTED TO APPLICATION'){
            response.put(RESPONSE_KEYWORD_STATUS, STATUS_ERROR);
            response.put(RESPONSE_KEYWORD_MESSAGE, 'This Credit Approval has already been Converted');
            return makeJSONString(response);
        }else if(qq.genesis__Status__c == 'CREDIT APPROVED'){
            return createApplication(quoteId, true);
        }
        response.put(RESPONSE_KEYWORD_STATUS, STATUS_ERROR);
        response.put(RESPONSE_KEYWORD_MESSAGE, 'This Credit Approval has NOT been Approved');
        return makeJSONString(response);
    }

    @AuraEnabled
    public static void defaultAppValues(String appId){
        genesis__Applications__c app = [
                SELECT Id, genesis__Account__c, Dealer__c, Billing_Address1__c, genesis__Expected_First_Payment_Date__c
                FROM genesis__Applications__c
                WHERE Id =: appId
                LIMIT 1
        ];

        Id feeDefId = [SELECT Id FROM clcommon__Fee_Definition__c WHERE Name = 'Origination Fees' LIMIT 1].Id;
        Application_Fee__c fee = new Application_Fee__c(
                Fee__c = feeDefId,
                Number_of_Payments__c = 1,
                Frequency__c = 'ONE TIME',
                Application__c = app.Id,
                Start_Date__c = app.genesis__Expected_First_Payment_Date__c,
                Amount__c = 75.00
        );
        insert fee;

        if(String.isBlank(app.Billing_Address1__c)){
            Address__c address = [
                    SELECT Id
                    FROM Address__c
                    WHERE Account__c =: app.genesis__Account__c AND Bill_To_Usage__c = true
                    LIMIT 1
            ];
            app.Billing_Address1__c = address.Id;
            update app;
        }



        List<clcommon__Party__c> parties = new List<clcommon__Party__c>();

        Id ptId = [SELECT Id FROM clcommon__Party_Type__c WHERE Name = 'DEALER' LIMIT 1].Id;

        parties.add(new clcommon__Party__c(clcommon__Type__c = ptId, clcommon__Account__c = app.Dealer__c, genesis__Application__c = app.Id)
        );
//        parties.add(new genesis__Application_Parties__c(
//                genesis__Application__c = app.Id,
//                genesis__Party_Account_Name__c = app.Dealer__c,
//                genesis__Party_Type__c = 'DEALER'
//        ));

        insert parties;
    }

    public static final String RESPONSE_KEYWORD_STATUS = 'Status';
    public static final String RESPONSE_KEYWORD_MESSAGE = 'Message';
    public static final String STATUS_ERROR = 'ERROR';
    public static final String STATUS_SUCCESS = 'SUCCESS';
    public static final String DUPLICATE_RECORD_ID = 'DuplicateId';

    // key = account field , value = quick quote field
    public static Map<String,String> accountFieldByQuickQuoteField = new Map<String,String>();
    // key = address field , value = quick quote field
    public static Map<String,String> addressFieldByQuickQuoteField = new Map<String,String>();



    private static genesis__Quick_Quotes__c queryQuickQuote(String quickQuoteId){
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache quickQuoteOC = ec.createObject('QuickQuoteOC','genesis__Quick_Quotes__c');
        quickQuoteOC.addFields('Name, Id');
        quickQuoteOC.addFields(accountFieldByQuickQuoteField.values());
        quickQuoteOC.addFields(addressFieldByQuickQuoteField.values());
        quickQuoteOC.addNamedParameter('quickQuoteId', quickQuoteId);
        quickQuoteOC.setWhereClause('Id = :quickQuoteId');
        quickQuoteOC.buildQuery();
        return (genesis__Quick_Quotes__c) quickQuoteOC.executeQuery().getRecords()[0];
    }

//    private static Account getAccountWithDefaultValues(){
//        Account newRecord = new Account();
//        RecordType lessee = [SELECT ID
//        FROM RecordType
//        WHERE DeveloperName = 'Lessee'
//        AND SobjectType = 'Account'
//        AND IsActive = true limit 1];
//        clcommon__Legal_Entity__c corp = [SELECT ID
//        FROM clcommon__Legal_Entity__c
//        WHERE Name = 'Corporation' limit 1];
//        newRecord.clcommon__Legal_Entity_Type__c = corp.Id;
//        newRecord.RecordTypeId = lessee.Id;
//        return newRecord;
//    }
//
//    private static Address__c getAddressWithDefaultValues(){
//        RecordType lessee = [SELECT ID
//        FROM RecordType
//        WHERE DeveloperName = 'Lessee'
//        AND SobjectType = 'Address__c'
//        AND IsActive = true limit 1];
//        Address__c address = new Address__c();
//        address.RecordTypeId = lessee.Id;
//        address.Country__c = 'USA';
//        address.Bill_To_Usage__c = true;
//        address.Install_At__c = true;
//        return address;
//    }

//    private static List<sObject> getDuplicateRecords(Database.DuplicateError duplicateError){
//        List<sObject> duplicateRecords = new List<sObject>();
//        if (duplicateError != NULL){
//            Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
//            Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
//            Datacloud.MatchResult matchResult = matchResults[0];
//            Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
//            for (Datacloud.MatchRecord matchRecord : matchRecords) {
//                duplicateRecords.add(matchRecord.getRecord());
//            }
//        }
//        return duplicateRecords;
//    }

    webservice static string createApplication(String quickQuoteId,
            Boolean mapDuplicateAccount){

        return processAccountAndAddress(quickQuoteId, mapDuplicateAccount);
    }

    private static String processAccountAndAddress(String quickQuoteId, Boolean mapDuplicateAccount){

        Map<String, String> response = new Map<String, String>();
        Map<String,genesis__Quick_Quote_Application_Account__c> quickQuoteToAccountFieldMappings =
                genesis__Quick_Quote_Application_Account__c.getAll();
        if (quickQuoteToAccountFieldMappings != NULL){
            for (genesis__Quick_Quote_Application_Account__c mapping : quickQuoteToAccountFieldMappings.values()){
                if (String.isNotBlank(mapping.genesis__Quick_Quote_Field_Name__c)
                        && String.isNotBlank(mapping.genesis__App_Account_Field_Name__c)){
                    // add field mapping to map
                    accountFieldByQuickQuoteField.put(mapping.genesis__App_Account_Field_Name__c,
                            mapping.genesis__Quick_Quote_Field_Name__c);
                }
            }

            List<Quick_Quote_to_Address_Mapping__mdt> addressMapping = [SELECT Address_Field__c,
                    Quick_Quote_Field__c
            FROM Quick_Quote_to_Address_Mapping__mdt];
            for(Quick_Quote_to_Address_Mapping__mdt mapping : addressMapping){
                addressFieldByQuickQuoteField.put(mapping.Address_Field__c,
                        mapping.Quick_Quote_Field__c);
            }

        }

        try{
            genesis__Quick_Quotes__c quickQuote = queryQuickQuote(quickQuoteId);
//            Account accRecord = getAccountWithDefaultValues();
//            for (String accountField : accountFieldByQuickQuoteField.keySet()){
//                String qqField = accountFieldByQuickQuoteField.get(accountField);
//                accRecord.put(accountField, quickQuote.get(qqField));
//            }
//
//            Database.SaveResult saveResult = Database.insert(accRecord, false);
//            if (!saveResult.isSuccess()) {
//                for (Database.Error error : saveResult.getErrors()) {
//                    if (error instanceof Database.DuplicateError) {
//                        List<sObject> duplicates = getDuplicateRecords((Database.DuplicateError)error);
//                        accRecord = (Account) duplicates[0];
//                        if(mapDuplicateAccount == false){
//                            response.put(RESPONSE_KEYWORD_STATUS, STATUS_ERROR);
//                            response.put(RESPONSE_KEYWORD_MESSAGE, 'An account already exists in the system');
//                            response.put(DUPLICATE_RECORD_ID, accRecord.Id);
//                            return makeJSONString(response);
//                        }
//                    } else {
//                        response.put(RESPONSE_KEYWORD_STATUS, STATUS_ERROR);
//                        response.put(RESPONSE_KEYWORD_MESSAGE, error.getMessage());
//                        return makeJSONString(response);
//                    }
//                }
//            }
//
//            // map address
//            Address__c address = getAddressWithDefaultValues();
//            for (String addressField : addressFieldByQuickQuoteField.keySet()){
//                String qqField = addressFieldByQuickQuoteField.get(addressField);
//                address.put(addressField, quickQuote.get(qqField));
//            }
//            address.Account__c = accRecord.Id;
//            saveResult = Database.insert(address, false);
//            if (!saveResult.isSuccess()) {
//                for (Database.Error error : saveResult.getErrors()) {
//                    if (error instanceof Database.DuplicateError) {
//                        List<sObject> duplicates = getDuplicateRecords((Database.DuplicateError)error);
//                        if(duplicates.size() == 1){
//                            address = (Address__c) duplicates[0];
//                        }
//                    }
//                }
//            }
//
//
//            quickQuote.genesis__Account__c = accRecord.Id;
//            quickQuote.Billing_Address__c = address.Id;
//            update quickQuote;

            String qqResponse =  genesis.QuickQuoteController.convertQuickQuoteToApplication(quickQuote);
            if(qqResponse.contains('"status":"ERROR"')){
                return qqResponse;
            }
            else{
                String appId = [SELECT Id, genesis__Application__c FROM genesis__Quick_Quotes__c WHERE Id =: quickQuoteId].genesis__Application__c;
                defaultAppValues(appId);
                response.put(RESPONSE_KEYWORD_STATUS, appId);
            }
        } catch(Exception error){
            response.put(RESPONSE_KEYWORD_STATUS, STATUS_ERROR);
            response.put(RESPONSE_KEYWORD_MESSAGE, error.getMessage());
        }
        return makeJSONString(response);
    }

    private static String makeJSONString(Map<String, String> base){
        List<String> parts = new List<String>();

        for(String key : base.keySet()) {
            String part =('"'+key + '" : ' + '"' + base.get(key) + '"');
            parts.add(part);
        }

        return '{' + String.join(parts, ' , ') + '}';
    }
}