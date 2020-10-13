@isTest
public with sharing class FMZ_QQ_NewQuickQuoteControllerTest {

    public static final String PORTAL_PROFILE = 'NewCo Dealer Portal Manager';
    public static final String QQ_FIELDSET = 'FMZ_NewQuickQuote';
 
    static testMethod void portalUser_getAccount_found() {

        RecordType dealerRT = [SELECT Id FROM RecordType WHERE Name = 'Dealer' AND SobjectType = 'Account'];
        Account dealer = new Account ( Name = 'Test Dealer', RecordTypeId = dealerRT.Id );
        insert dealer;

        Contact dealerUser = new Contact(
                FirstName = 'TFirst',
                LastName='TestDealer',
                Email='TestDealerDLL@TestNewCo123.com',
                AccountId=dealer.Id
        );
        insert dealerUser;

        List<User> users;
        System.runAs(new User(Id = UserInfo.getUserId())){
            users = getPortalDealerUsers(new List<Contact>{dealerUser});
            insert users;
        }

        Test.startTest();

        System.runAs(users[0]){

            System.assertEquals(dealer.Id, FMZ_QQ_NewQuickQuoteController.getDealerAccount());

        }
        Test.stopTest();

    }

    static testMethod void qqFieldSet_getMembers_found() {

        List<FMZ_CommunityServices.FieldSetMember> fields = FMZ_QQ_NewQuickQuoteController.getQQFields(QQ_FIELDSET);

        System.assert(fields.size() > 1);

    }

    static testMethod void quickQuote_getStatus_returned() {

        Account dealer = new Account ( Name = 'Dealer' );
        insert dealer;

        Account lessee = new Account ( Name = 'Lessee' );
        insert lessee;

        genesis__Quick_Quotes__c qq = new genesis__Quick_Quotes__c (
                Dealer__c = dealer.Id,
                genesis__Account__c = lessee.Id,
                genesis__Business_Name__c = 'Lessee',
                Primary_Phone_number__c = '8005551212',
                genesis__Address_Line_1__c = '123 Maple St',
                genesis__City__c = 'New York',
                genesis__State__c = 'NY',
                County__c = 'New York',
                genesis__Postal_Code__c = '10019',
                Estimated_Financed_Amount__c = '10000',
                genesis__Status__c = 'NEW'
        );
        insert qq;

        Test.startTest();

        System.assertEquals('NEW', FMZ_QQ_NewQuickQuoteController.getQuickQuoteStatus(qq.Id));

        Test.stopTest();

    }

    static testMethod void accountWithPrimary_get_returned() {

        Account a = new Account (
            Name = 'Test',
            Phone = '8005551212'
        );
        insert a;

        Address__c address = new Address__c (
            Account__c = a.Id,
            Address_Line_1__c = '123 Maple St',
            City__c = 'New York',
            State__c = 'NY',
            County__c = 'New York',
            Zip_Code__c = '10019',
            Primary_Address__c = true
        );
        insert address;

        a.Primary_Address__c = address.Id;
        update a;

        Test.startTest();

        Account b = FMZ_QQ_NewQuickQuoteController.getAccountInfo(a.Id);

        System.assertEquals('Test', b.Name);
        System.assertEquals('8005551212', b.Phone);
        System.assertEquals('123 Maple St', b.Primary_Address__r.Address_Line_1__c);
        System.assertEquals('New York', b.Primary_Address__r.City__c);
        System.assertEquals('NY', b.Primary_Address__r.State__c);
        System.assertEquals('New York', b.Primary_Address__r.County__c);
        System.assertEquals('10019', b.Primary_Address__r.Zip_Code__c);

        Test.stopTest();

    }

    static testMethod void accountPrimaryNotSet_get_returned() {

        Account a = new Account (
                Name = 'Test',
                Phone = '8005551212'
        );
        insert a;

        Address__c address = new Address__c (
                Account__c = a.Id,
                Address_Line_1__c = '123 Maple St',
                City__c = 'New York',
                State__c = 'NY',
                County__c = 'New York',
                Zip_Code__c = '10019',
                Primary_Address__c = true
        );
        insert address;

        a.Primary_Address__c = address.Id;
        update a;

        Test.startTest();

        Account b = FMZ_QQ_NewQuickQuoteController.getAccountInfo(a.Id);

        System.assertEquals('Test', b.Name);
        System.assertEquals('8005551212', b.Phone);
        System.assertEquals('123 Maple St', b.Primary_Address__r.Address_Line_1__c);
        System.assertEquals('New York', b.Primary_Address__r.City__c);
        System.assertEquals('NY', b.Primary_Address__r.State__c);
        System.assertEquals('New York', b.Primary_Address__r.County__c);
        System.assertEquals('10019', b.Primary_Address__r.Zip_Code__c);

        Test.stopTest();

    }

    static testMethod void leaseAccountWithPrimary_get_returned() {

        Account a = new Account (
                Name = 'Test',
                Phone = '8005551212'
        );
        insert a;

        Address__c address = new Address__c (
                Account__c = a.Id,
                Address_Line_1__c = '123 Maple St',
                City__c = 'New York',
                State__c = 'NY',
                County__c = 'New York',
                Zip_Code__c = '10019',
                Primary_Address__c = true
        );
        insert address;

        a.Primary_Address__c = address.Id;
        update a;

        cllease.TestHelper.createSeedDataForTesting();
        cllease.TestHelper.integrateWithSFCRM();

        clcommon__Fee_Definition__c  dummyFee = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet = cllease.Testhelper.createLeaseFeeSet();
        clcommon__Fee_Junction__c dummyFeeJunction = TestContractProcessor.createLeaseFeeJunction(dummyFee,dummyFeeSet);

        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice();

        cllease__Lease_Product__c dummyLeaseProduct = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);

        cllease__Lease_Account__c lease = new cllease__Lease_Account__c (
            cllease__Account__c = a.Id,
            cllease__Financed_Amount__c = 10000,
            cllease__Product_Type__c = cllease.LeaseConstants.LEASE,
            cllease__Term__c = 12,
            cllease__Contract_Date__c = Date.parse('07/01/2016'),
            cllease__First_Payment_Date__c = Date.parse('07/01/2016'),
            cllease__Maturity_Date__c = Date.parse('06/30/2017')
        );
        insert lease;

        Test.startTest();

        Account b = FMZ_QQ_NewQuickQuoteController.getAccountInfo(a.Id);

        System.assertEquals('Test', b.Name);
        System.assertEquals('8005551212', b.Phone);
        System.assertEquals('123 Maple St', b.Primary_Address__r.Address_Line_1__c);
        System.assertEquals('New York', b.Primary_Address__r.City__c);
        System.assertEquals('NY', b.Primary_Address__r.State__c);
        System.assertEquals('New York', b.Primary_Address__r.County__c);
        System.assertEquals('10019', b.Primary_Address__r.Zip_Code__c);

        Test.stopTest();

    }

    static testMethod void leaseAccountWithPrimaryNotSet_get_returned() {

        Account a = new Account (
                Name = 'Test',
                Phone = '8005551212'
        );
        insert a;

        Address__c address = new Address__c (
                Account__c = a.Id,
                Address_Line_1__c = '123 Maple St',
                City__c = 'New York',
                State__c = 'NY',
                County__c = 'New York',
                Zip_Code__c = '10019',
                Primary_Address__c = true
        );
        insert address;

        a.Primary_Address__c = address.Id;
        update a;

        cllease.TestHelper.createSeedDataForTesting();
        cllease.TestHelper.integrateWithSFCRM();

        clcommon__Fee_Definition__c  dummyFee = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet = cllease.Testhelper.createLeaseFeeSet();
        clcommon__Fee_Junction__c dummyFeeJunction = TestContractProcessor.createLeaseFeeJunction(dummyFee,dummyFeeSet);

        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice();

        cllease__Lease_Product__c dummyLeaseProduct = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);

        cllease__Lease_Account__c lease = new cllease__Lease_Account__c (
                cllease__Account__c = a.Id,
                cllease__Financed_Amount__c = 10000,
                cllease__Product_Type__c = cllease.LeaseConstants.LEASE,
                cllease__Term__c = 12,
                cllease__Contract_Date__c = Date.parse('07/01/2016'),
                cllease__First_Payment_Date__c = Date.parse('07/01/2016'),
                cllease__Maturity_Date__c = Date.parse('06/30/2017')
        );
        insert lease;

        Test.startTest();

        Account b = FMZ_QQ_NewQuickQuoteController.getAccountInfo(a.Id);

        System.assertEquals('Test', b.Name);
        System.assertEquals('8005551212', b.Phone);
        System.assertEquals('123 Maple St', b.Primary_Address__r.Address_Line_1__c);
        System.assertEquals('New York', b.Primary_Address__r.City__c);
        System.assertEquals('NY', b.Primary_Address__r.State__c);
        System.assertEquals('New York', b.Primary_Address__r.County__c);
        System.assertEquals('10019', b.Primary_Address__r.Zip_Code__c);

        Test.stopTest();

    }

    static testMethod void quickQuote_submitForApproval_approved() {

        Account dealer = new Account ( Name = 'Dealer' );
        insert dealer;

        Account lessee = new Account ( Name = 'Lessee' );
        insert lessee;

        genesis__Quick_Quotes__c qq = new genesis__Quick_Quotes__c (
            Dealer__c = dealer.Id,
            genesis__Account__c = lessee.Id,
            genesis__Business_Name__c = 'Lessee',
            Primary_Phone_number__c = '8005551212',
            genesis__Address_Line_1__c = '123 Maple St',
            genesis__City__c = 'New York',
            genesis__State__c = 'NY',
            County__c = 'New York',
            genesis__Postal_Code__c = '10019',
            Estimated_Financed_Amount__c = '10000'
        );
        insert qq;

        ATS_Integration_setup__c cust=new ATS_Integration_setup__c();
        cust.Client_ID__c='dabb702d-c59a-49a3-930f-bf75f895f0b4';
        cust.Client_Secret__c='c341f95c-ec3c-4cf8-9935-8d68a5765ccc';
        cust.Email_service_alias__c='newco-creditDecision-dev@dllgroup.com';
        cust.Endpoint_for_ATS_call__c='https://api.dllgroup.com/americas/v1/application/';
        cust.Endpoint_for_Token__c='https://api.dllgroup.com/oauth/token';
        cust.Sandbox_Name__c='dev';
        cust.Scope_for_token_call__c='create_and_manage_financial_contracts';
        insert cust;

        System.Test.setMock(HttpCalloutMock.class, new TestGetCreditApproval());

        Test.startTest();

        FMZ_QQ_NewQuickQuoteController.submitForApproval(qq.Id);

        Test.stopTest();

        qq = [SELECT Id, genesis__Status__c FROM genesis__Quick_Quotes__c];

        System.assertNotEquals(null, qq.genesis__Status__c);

    }

    public testMethod static void getMatchesTest(){
        Test.setMock(HttpCalloutMock.class, new FMZ_EDQAddressCalloutMock());
        List<FMZ_EDQ_Address_Callout.Match> matches = FMZ_QQ_NewQuickQuoteController.getMatches('10 Main');
        System.assertEquals(2, matches.size());
    }

    public testMethod static void getFormatTest(){
        Test.setMock(HttpCalloutMock.class, new FMZ_EDQAddressCalloutMock());
        FMZ_EDQ_Address_Callout.Address address = FMZ_QQ_NewQuickQuoteController.getFormat('https://api.edq.com/capture/address/v2/format?country=USA&id=b83c0b90-b221-48db-a877-b6cf06f857d9_U40_24_0_0_0%3D10%24QL7%24GEO0');
        System.assertNotEquals(null, address);
    }

    public testMethod static void createRecordsTest_NoDup(){
        RecordType dealerRT = [SELECT Id FROM RecordType WHERE Name = 'Dealer' AND SobjectType = 'Account'];
        Account dealer = new Account ( Name = 'Test Dealer', RecordTypeId = dealerRT.Id );
        insert dealer;

        Contact dealerUser = new Contact(
                FirstName = 'TFirst',
                LastName='TestDealer',
                Email='TestDealerDLL@TestNewCo123.com',
                AccountId=dealer.Id
        );
        insert dealerUser;

        List<User> users;
        System.runAs(new User(Id = UserInfo.getUserId())){
            users = getPortalDealerUsers(new List<Contact>{dealerUser});
            insert users;
        }

        System.runAs(users[0]){
            clcommon__Legal_Entity__c legalEntity = new clcommon__Legal_Entity__c(Name = 'Corporation');
            insert legalEntity;

        clcommon__CL_Product__c product = new clcommon__CL_Product__c(
                clcommon__Product_Name__c = 'Finance Lease'
        );
        insert product;

        genesis__Company__c company = new genesis__Company__c(
                genesis__Short_Name__c = 'comp',
                Name = 'TestCompany',
                genesis__Default__c = true);
        insert company;



        genesis__Quick_Quotes__c qq = new genesis__Quick_Quotes__c(
                Email_Address__c = 'TestEmail@TestEmail.com',
                genesis__Business_Name__c = 'Test Lessee',
                Primary_Phone_number__c = '8005551212',
                genesis__Address_Line_1__c = '123 Maple St',
                genesis__City__c = 'New York',
                genesis__State__c = 'NY',
                dealer__c = dealer.id,
                County__c = 'New York',
                genesis__Postal_Code__c = '10019',
                Estimated_Financed_Amount__c = '10000',
                genesis__Status__c = 'NEW'
        );


            FMZ_QQ_NewQuickQuoteController.CreateResponse response = FMZ_QQ_NewQuickQuoteController.createRecords(JSON.Serialize(qq), false);
            System.assertEquals('SUCCESS', response.status);
            System.assertNotEquals(null, response.message);
        }
    }

    public testMethod static void createRecordsTest_DuplicateFound(){
        RecordType dealerRT = [SELECT Id FROM RecordType WHERE Name = 'Dealer' AND SobjectType = 'Account'];
        Account dealer = new Account ( Name = 'Test Dealer', RecordTypeId = dealerRT.Id );
        insert dealer;

        Contact dealerUser = new Contact(
                FirstName = 'TFirst',
                LastName='TestDealer',
                Email='TestDealerDLL@TestNewCo123.com',
                AccountId=dealer.Id
        );
        insert dealerUser;

        List<User> users;
        System.runAs(new User(Id = UserInfo.getUserId())){
            users = getPortalDealerUsers(new List<Contact>{dealerUser});
            insert users;
        }

        System.runAs(users[0]){

            clcommon__Legal_Entity__c legalEntity = new clcommon__Legal_Entity__c(Name = 'Corporation');
            insert legalEntity;

        clcommon__CL_Product__c product = new clcommon__CL_Product__c(
                clcommon__Product_Name__c = 'Finance Lease'
        );
        insert product;

        genesis__Company__c company = new genesis__Company__c(
                genesis__Short_Name__c = 'comp',
                Name = 'TestCompany',
                genesis__Default__c = true);
        insert company;



        genesis__Quick_Quotes__c qq = new genesis__Quick_Quotes__c(
                Email_Address__c = 'TestEmail@TestEmail.com',
                genesis__Business_Name__c = 'Test Lessee',
                Primary_Phone_number__c = '8005551212',
                genesis__Address_Line_1__c = '123 Maple St',
                genesis__City__c = 'New York',
                genesis__State__c = 'NY',
                County__c = 'New York',
                dealer__c = dealer.id,
                genesis__Postal_Code__c = '10019',
                Estimated_Financed_Amount__c = '10000',
                genesis__Status__c = 'NEW'
        );


            RecordType lesseeRT = [SELECT Id FROM RecordType WHERE Name = 'Lessee' AND SobjectType = 'Account'];
            Account lessee = new Account ( Name = 'Test Lessee', RecordTypeId = lesseeRT.Id );
            insert lessee;

            FMZ_QQ_NewQuickQuoteController.CreateResponse response = FMZ_QQ_NewQuickQuoteController.createRecords(JSON.Serialize(qq), false);
            System.assertEquals('DUPLICATES', response.status);
            System.assertNotEquals(null, response.message);
            System.assertNotEquals(null, response.duplicates);
        }
    }  

    private static List<User> getPortalDealerUsers(List<Contact> contacts){
        Id p = [select id from profile where name='NewCo Dealer Portal User'].id;
        //Id urId = [SELECT Id, Name FROM UserRole WHERE Name = 'Dealer User'].Id;
        List<User> users = new List<User>();
        for(Contact con : contacts){
            users.add(new User(alias=con.FirstName, email=con.Email, /*UserRoleId = urId,*/
                    emailencodingkey='UTF-8', lastname=con.LastName, languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p, country='United States', IsActive =true,
                    ContactId = con.Id, timezonesidkey='America/Los_Angeles', username=con.Email));
        }
        return users;
    }

}