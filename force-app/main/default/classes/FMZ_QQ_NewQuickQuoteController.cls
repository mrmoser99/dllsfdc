public without sharing class FMZ_QQ_NewQuickQuoteController {

    public static final String QUICK_QUOTE_OBJECT = 'genesis__Quick_Quotes__c';

    @AuraEnabled
    public static List<FMZ_EDQ_Address_Callout.Match> getMatches(String addressString){
        return FMZ_EDQ_Address_Callout.getAddressMatches(addressString);
    }

    @AuraEnabled
    public static FMZ_EDQ_Address_Callout.Address getFormat(String formatUrl){
        return FMZ_EDQ_Address_Callout.getAddressFormat(formatUrl);
    }

    @AuraEnabled
    public static List<FMZ_CommunityServices.FieldSetMember> getQQFields(String fieldsetName) {
        return FMZ_CommunityServices.getFieldSetMembers(QUICK_QUOTE_OBJECT, fieldSetName);
    }

    @AuraEnabled
    public static String getQuickQuoteStatus(Id qqId){
        return [SELECT genesis__Status__c FROM genesis__Quick_Quotes__c WHERE Id =: qqId LIMIT 1].genesis__Status__c;
    }

    @AuraEnabled
    public static CreateResponse createRecords(genesis__Quick_Quotes__c qq, Boolean ignoreDuplicates) {
        Savepoint sp = Database.setSavepoint();
        try{
            Account dealer = getDealerInfo();
            qq.Dealer__c = dealer.Id;
            qq.Dealer_Name__c = dealer.Name;
            //qq.Legal_Entity__c = dealer.clcommon__Legal_Entity_Type__c;

            qq.CL_Product__c = [SELECT Id FROM clcommon__CL_Product__c WHERE clcommon__Product_Name__c = 'Finance Lease' LIMIT 1].Id;
            qq.genesis__Company__c = [SELECT Id FROM genesis__Company__c WHERE genesis__Default__c = true LIMIT 1].Id;

            qq.genesis__No_Of_Payments_Required_Upfront__c = 0;
            qq.genesis__Additional_cash_required__c = 0;
            qq.genesis__Cap_Reduction__c = 0;
            qq.genesis__Cash_Collected_By_Dealer__c = 0;
            qq.genesis__Collateral_Value__c = 0;
            qq.genesis__Customer_cash_available__c = 0;
            qq.genesis__Customer_Cash_Used_For__c = 'Down Payment';
            qq.genesis__Fees_Amount__c = 0;
            qq.genesis__Documentation_charges__c = 0;
            qq.genesis__Down_Payment__c = 0;
            qq.genesis__Estimated_Selling_Price__c = 0;
            qq.genesis__Expected_Start_Date__c = Date.today();
            qq.genesis__Financed_Amount__c = 0;
            qq.genesis__Minimum_cash_Required__c = 0;
            qq.genesis__Next_Step__c = 0;
            qq.genesis__Other_Financed_Fees__c = 0;
            qq.genesis__Total_Dealer_Payable__c = 0;
            qq.genesis__Payment_Amount__c = 0;
            qq.genesis__Payment_Frequency__c = 'MONTHLY';
            qq.genesis__Pricing_Method__c = 'RATE CARD';
            qq.genesis__Total_Customer_Cash_Required__c = 0;
            qq.genesis__Source__c = 'DEALER';
            qq.genesis__Tax_Amount__c = 0;
            qq.genesis__Total_Cash_Due_from_Customer__c = 0;
            qq.genesis__Total_Dealer_Price__c = 0;
            qq.genesis__Total_Upfront_Payments__c = 0;
            qq.genesis__Valid_Pricing_Flag__c = false;
            qq.genesis__Warranty_Amount__c = 0;

            System.debug('!!!Inserting QQ: '+qq);
            insert qq;

            genesis__Quick_Quote_Pricing_Options__c pricing = new genesis__Quick_Quote_Pricing_Options__c(genesis__Converted__c = true, genesis__Quick_Quote__c = qq.Id);
            insert pricing;

            qq.genesis__Selected_Pricing_Option_Id__c = pricing.Id;
            update qq;
            System.debug('!!!QQ Inserted');

            if(qq.genesis__Account__c == null ){
                Id lesseeRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lessee').getRecordTypeId();

                Account customer = new Account(
                        Name = qq.genesis__Business_Name__c,
                        Phone = qq.Primary_Phone_number__c,
                        Email_Address__c = qq.Email_Address__c,
                        RecordTypeId = lesseeRecTypeId
                );

                // THE DUPLICATE RULE BLOCKS ALL DUPS
                //======================================================================================================
                //HANDLE ACCOUNT CREATION
                //======================================================================================================
//                if(ignoreDuplicates){
//                    //==================================================================================================
//                    //IGNORE DUPLICATES INSERT
//                    //==================================================================================================
//                    Database.DMLOptions dml = new Database.DMLOptions();
//                    dml.DuplicateRuleHeader.allowSave = true;
//                    Database.SaveResult sr = Database.insert(customer, dml);
//                    if (!sr.isSuccess()) {
//                        for (Database.Error error : sr.getErrors()) {
//                            throw new QQCreationException(error.getMessage());
//                        }
//                    }
//                    //==================================================================================================
//                    //DONE IGNORE DUPS INSERT
//                    //==================================================================================================
//                }else{
                    //==================================================================================================
                    //LOOK FOR DUPES
                    //==================================================================================================
                    System.debug('!!! Inserting Customer');
                    Database.SaveResult saveResult = Database.insert(customer, false);
                    if (!saveResult.isSuccess()) {
                        for (Database.Error error : saveResult.getErrors()) {
                            if (error instanceof Database.DuplicateError) {
                                List<sObject> duplicates = getDuplicateRecords((Database.DuplicateError)error);
                                Set<Id> dupIds = new Set<Id>();
                                for(sObject dup : duplicates){
                                    dupIds.add(dup.Id);
                                }
                                List<Account> dupAccounts = [SELECT Id, Name, EIN__c FROM Account WHERE Id IN: dupIds];
                                List<DuplicateRecord> records = new List<DuplicateRecord>();
                                for(Account dup : dupAccounts){
                                    records.add(new DuplicateRecord(
                                            dup.Id,
                                            dup.Name+ (String.isNotBlank(dup.EIN__c) ? ': '+dup.EIN__c : ''))
                                    );
                                }

                                 return new CreateResponse(
                                        'DUPLICATES',
                                        'Would you like to use one of these Accounts instead?',
                                        records
                                 );
                            } else {
                                throw new QQCreationException(error.getMessage());
                            }
                        }
                    //}
                    System.debug('!!! Customer Inserted');
                    //==================================================================================================
                    //DONE DUPE HANDLING
                    //==================================================================================================
                }
                //======================================================================================================
                //DONE HANDLING ACCOUNT CREATION
                //======================================================================================================

                Address__c address = new Address__c(
                        Account__c = customer.Id,
                        Address_Line_1__c = qq.genesis__Address_Line_1__c,
                        City__c = qq.genesis__City__c,
                        County__c = qq.County__c,
                        State__c = qq.genesis__State__c,
                        Zip_Code__c = qq.genesis__Postal_Code__c,
                        Country__c = qq.genesis__Country__c,
                        Validation_Status__c = qq.Validation_Status__c,
                        Validation_Time_Stamp__c = qq.Validation_Time_Stamp__c,
                        Install_At__c = true,
                        Primary_Address__c = true
                );

                if(customer.Email_Address__c != null && customer.Email_Address__c != ''){
                    address.Email_Address__c = customer.Email_Address__c;
                    address.Bill_To_Usage__c = true;

                    customer.Billing_Address_Validation_Status__c = address.Validation_Status__c;
                    customer.Billing_Address_Validation_Timestamp__c = address.Validation_Time_Stamp__c;
                }
                insert address;
                customer.Primary_Address__c = address.Id;
                update customer;
                qq.genesis__Account__c = customer.Id;
                update qq;
            }
            System.debug('!!!QQId: '+qq.Id);
            return new CreateResponse('SUCCESS',qq.Id,null);
        }catch(exception e){
            Database.rollback(sp);
            System.debug('!!!ERROR: Caught: '+e.getMessage());
            throw e;
        }
    }

    @AuraEnabled
    public static Account getAccountInfo(String accountId) {
        System.debug('!!!AccountId: '+accountId);
        Account a =
            [SELECT Id, Name, Phone, Email_Address__c,
                    Primary_Address__r.Address_Line_1__c, Primary_Address__r.Address_Line_2__c,
                    Primary_Address__r.Address_Line_3__c, Primary_Address__r.Address_Line_4__c,
                    Primary_Address__r.City__c, Primary_Address__r.State__c,
                    Primary_Address__r.County__c, Primary_Address__r.Country__c,
                    Primary_Address__r.Zip_Code__c, Primary_Address__r.Validation_Status__c,
                    Primary_Address__r.Validation_Time_Stamp__c
            FROM Account
            WHERE Id = :accountId];

        return a;

    }

    @AuraEnabled
    public static Id getDealerAccount() {
        User dealer = [SELECT Id, AccountId FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        Id accId;
        if(dealer.AccountId == null){
            accId = [SELECT Id FROM Account WHERE RecordType.DeveloperName LIKE 'Dealer%' LIMIT 1].Id;
        }else{
            accId = dealer.AccountId;
        }

        return accId;

    }

    @AuraEnabled
    public static Account getDealerInfo() {
        User dealer = [SELECT Id, AccountId, Contact.Account.Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        Account acc;
        if(dealer.AccountId == null){
            acc = [SELECT Id, Name FROM Account WHERE RecordType.DeveloperName LIKE 'Dealer%' LIMIT 1];
        }else{
            acc = new Account( Id = dealer.AccountId, Name = dealer.Contact.Account.Name);
        }

        return acc;

    }

    @AuraEnabled
    public static String submitForApproval(Id qqId) {

        genesis__Quick_Quotes__c qq = [
                SELECT Id, estimated_financed_amount__c, genesis__account__c
                FROM genesis__Quick_Quotes__c
                WHERE Id =: qqId LIMIT 1];


        String result = GetCreditApproval.func_getcreditapproval(qq);

        System.debug('!!!RESULT!!!');
        System.debug('!!!'+result);

        return result;

    }

    private static List<sObject> getDuplicateRecords(Database.DuplicateError duplicateError){
        List<sObject> duplicateRecords = new List<sObject>();
        if (duplicateError != NULL){
            Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
            Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
            Datacloud.MatchResult matchResult = matchResults[0];
            Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
            for (Datacloud.MatchRecord matchRecord : matchRecords) {
                duplicateRecords.add(matchRecord.getRecord());
            }
        }
        return duplicateRecords;
    }

    public class CreateResponse {
        @AuraEnabled
        public String status;

        @AuraEnabled
        public String message;

        @AuraEnabled
        public List<DuplicateRecord> duplicates;

        public CreateResponse(String status, String message, List<DuplicateRecord> duplicates){
            this.status = status;
            this.message = message;
            this.duplicates = duplicates;
        }
    }

    public class DuplicateRecord {
        @AuraEnabled
        public String id;

        @AuraEnabled
        public String info;

        public duplicateRecord(String id, String info){
            this.id = id;
            this.info = info;
        }
    }


    public class QQCreationException extends Exception {}

}