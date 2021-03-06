/**
 * Created by samuelmeyers on 11/2/18.
 */

@isTest
public with sharing class FMZ_QQ_ConvertToAppControllerTest {
    public testMethod static void convertToApp_NoEmail_AtFirst(){
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

        List<User> users = getPortalDealerUsers(new List<Contact>{dealerUser});
        insert users;

        System.runAs(users[0]){

        clcommon__Fee_Definition__c feeDef = new clcommon__Fee_Definition__c(
                Name = 'Origination Fees',
                clcommon__Class__c = 'Expense',
                clcommon__Amount__c = 75.00);
        insert feeDef;
        clcommon__Party_Type__c pType = new clcommon__Party_Type__c( Name = 'DEALER' );
        insert pType;
        clcommon__Legal_Entity__c legEnt = new clcommon__Legal_Entity__c(Name = 'Corporation');
        insert legEnt;

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
                genesis__Business_Name__c = 'Test Lessee',
                Primary_Phone_number__c = '8005551212',
                genesis__Address_Line_1__c = '123 Maple St',
                genesis__City__c = 'New York',
                genesis__State__c = 'NY',
                County__c = 'New York',
                genesis__Postal_Code__c = '10019',
                Estimated_Financed_Amount__c = '10000',
                genesis__Status__c = 'NEW'
        );


            FMZ_QQ_NewQuickQuoteController.CreateResponse response = FMZ_QQ_NewQuickQuoteController.createRecords(qq, false);
            System.assertEquals('SUCCESS', response.status);
            System.assertNotEquals(null, response.message);
            Id qqId = response.message;

            genesis__Quick_Quotes__c updatedQQ = new genesis__Quick_Quotes__c(Id = qqId, Email_Address__c='Test@Test.com', genesis__Status__c = 'CREDIT APPROVED');
            update updatedQQ;

            System.debug('!!!Converting');
            String convertResp = FMZ_QQ_ConvertToApplicationController.convertToApplication(qqId);
            System.debug('!!!'+convertResp);

            Integer statusIdx = convertResp.indexOf('"status" :');
        }
    }

    public testMethod static void convertToApp_NotApproved(){
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

        List<User> users = getPortalDealerUsers(new List<Contact>{dealerUser});
        insert users;

        System.runAs(users[0]){

        clcommon__Fee_Definition__c feeDef = new clcommon__Fee_Definition__c(
                Name = 'Origination Fees',
                clcommon__Class__c = 'Expense',
                clcommon__Amount__c = 75.00);
        insert feeDef;
        clcommon__Party_Type__c pType = new clcommon__Party_Type__c( Name = 'DEALER' );
        insert pType;
        clcommon__Legal_Entity__c legEnt = new clcommon__Legal_Entity__c(Name = 'Corporation');
        insert legEnt;



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
                genesis__Business_Name__c = 'Test Lessee',
                Primary_Phone_number__c = '8005551212',
                genesis__Address_Line_1__c = '123 Maple St',
                genesis__City__c = 'New York',
                genesis__State__c = 'NY',
                County__c = 'New York',
                genesis__Postal_Code__c = '10019',
                Estimated_Financed_Amount__c = '10000',
                genesis__Status__c = 'NEW'
        );


            FMZ_QQ_NewQuickQuoteController.CreateResponse response = FMZ_QQ_NewQuickQuoteController.createRecords(qq, false);
            System.assertEquals('SUCCESS', response.status);
            System.assertNotEquals(null, response.message);
            Id qqId = response.message;

            genesis__Quick_Quotes__c updatedQQ = new genesis__Quick_Quotes__c(Id = qqId, Email_Address__c='Test@Test.com');
            update updatedQQ;

            System.debug('!!!Converting');
            String convertResp = FMZ_QQ_ConvertToApplicationController.convertToApplication(qqId);
            System.debug('!!!'+convertResp);

            Integer statusIdx = convertResp.indexOf('"status" :');
        }
    }

    public testMethod static void convertToApp_NoEmail(){
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

        List<User> users = getPortalDealerUsers(new List<Contact>{dealerUser});
        insert users;
        System.runAs(users[0]){

        clcommon__Fee_Definition__c feeDef = new clcommon__Fee_Definition__c(
                Name = 'Origination Fees',
                clcommon__Class__c = 'Expense',
                clcommon__Amount__c = 75.00);
        insert feeDef;
        clcommon__Party_Type__c pType = new clcommon__Party_Type__c( Name = 'DEALER' );
        insert pType;
        clcommon__Legal_Entity__c legEnt = new clcommon__Legal_Entity__c(Name = 'Corporation');
        insert legEnt;


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
                genesis__Business_Name__c = 'Test Lessee',
                Primary_Phone_number__c = '8005551212',
                genesis__Address_Line_1__c = '123 Maple St',
                genesis__City__c = 'New York',
                genesis__State__c = 'NY',
                County__c = 'New York',
                genesis__Postal_Code__c = '10019',
                Estimated_Financed_Amount__c = '10000',
                genesis__Status__c = 'NEW'
        );


            FMZ_QQ_NewQuickQuoteController.CreateResponse response = FMZ_QQ_NewQuickQuoteController.createRecords(qq, false);
            System.assertEquals('SUCCESS', response.status);
            System.assertNotEquals(null, response.message);
            Id qqId = response.message;

            genesis__Quick_Quotes__c updatedQQ = new genesis__Quick_Quotes__c(Id = qqId,  genesis__Status__c = 'CREDIT APPROVED');
            update updatedQQ;

            System.debug('!!!Converting');
            String convertResp = FMZ_QQ_ConvertToApplicationController.convertToApplication(qqId);
            System.debug('!!!'+convertResp);

            Integer statusIdx = convertResp.indexOf('"status" :');
        }
    }

    public testMethod static void convertToApp_AlreadyConverted(){
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

        List<User> users = getPortalDealerUsers(new List<Contact>{dealerUser});
        insert users;

        System.runAs(users[0]){

        clcommon__Fee_Definition__c feeDef = new clcommon__Fee_Definition__c(
                Name = 'Origination Fees',
                clcommon__Class__c = 'Expense',
                clcommon__Amount__c = 75.00);
        insert feeDef;
        clcommon__Party_Type__c pType = new clcommon__Party_Type__c( Name = 'DEALER' );
        insert pType;
        clcommon__Legal_Entity__c legEnt = new clcommon__Legal_Entity__c(Name = 'Corporation');
        insert legEnt;


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
                genesis__Postal_Code__c = '10019',
                Estimated_Financed_Amount__c = '10000',
                genesis__Status__c = 'NEW'
        );


            FMZ_QQ_NewQuickQuoteController.CreateResponse response = FMZ_QQ_NewQuickQuoteController.createRecords(qq, false);
            System.assertEquals('SUCCESS', response.status);
            System.assertNotEquals(null, response.message);
            Id qqId = response.message;

            genesis__Quick_Quotes__c updatedQQ = new genesis__Quick_Quotes__c(Id = qqId, genesis__Status__c = 'CONVERTED TO APPLICATION');
            update updatedQQ;

            System.debug('!!!Converting');
            String convertResp = FMZ_QQ_ConvertToApplicationController.convertToApplication(qqId);
            System.debug('!!!'+convertResp);

            Integer statusIdx = convertResp.indexOf('"status" :');
        }
    }

    public testMethod static void defaultAppValues(){
        RecordType dealerRT = [SELECT Id FROM RecordType WHERE Name = 'Dealer' AND SobjectType = 'Account'];
        Account dealer = new Account ( Name = 'Dealer', RecordTypeId = dealerRT.Id );
        insert dealer;

        Contact dealerUser = new Contact(
                FirstName = 'TFirst',
                LastName='TestDealer',
                Email='TestDealerDLL@TestNewCo123.com',
                AccountId=dealer.Id
        );
        insert dealerUser;

        List<User> users = getPortalDealerUsers(new List<Contact>{dealerUser});
        insert users;

        System.runAs(users[0]){

        clcommon__Fee_Definition__c feeDef = new clcommon__Fee_Definition__c(
                Name = 'Origination Fees',
                clcommon__Class__c = 'Expense',
                clcommon__Amount__c = 75.00);
        insert feeDef;
        clcommon__Party_Type__c pType = new clcommon__Party_Type__c( Name = 'DEALER' );
        insert pType;

        genesis__Company__c company = new genesis__Company__c (
                Name = 'DeLage Landen',
                genesis__Short_Name__c = 'HQ',
                genesis__Default__c = true,
                genesis__Enabled_Flag__c = true
        );
        insert company;

        Date currentSystemDate = Date.newInstance(2018, 03, 31);
        cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office', true);
        dummyOffice.cllease__Current_System_Date__c = currentSystemDate;
        dummyOffice.Dll_Seg1_Company__c         = '00101';
        dummyOffice.Dll_Seg2_Business_Unit__c   = '02';
        dummyOffice.Dll_Seg3_Department__c      = '3030';
        dummyOffice.Dll_Seg6__c                 = '00000';
        dummyOffice.Dll_Seg7__c                 = '0000';
        update dummyOffice;

        genesis__Quick_Quote_Option__c qqOption = new genesis__Quick_Quote_Option__c(
                genesis__Documentation_Fees_Originated_Dealer__c = 0,
                genesis__Maximum_Financed_Percent_Dealer__c = 100,
                genesis__Minimum_Cash_Percent_Customer__c = 0,
                genesis__Debt_to_Income__c = 0,
                genesis__Start_Date__c = Date.newInstance(2001, 1, 1),
                genesis__Enabled_Flag__c = true,
                genesis__Documentation_Fees_Originated_Direct__c = 0,
                genesis__Maximum_Financed_Percent_Direct__c = 100,
                genesis__Term_Extension_Fees__c = 0,
                genesis__Assumed_Interest_Rate__c = 0,
                genesis__End_Date__c = Date.newInstance(3000, 12, 31)
        );
        insert qqOption;

        clcommon__CL_Product__c product = new clcommon__CL_Product__c (
                clcommon__Product_Name__c = 'FINANCE LEASE'
        );
        insert product;

        genesis__Rate_Card_Setup_Header__c rateCard = new genesis__Rate_Card_Setup_Header__c (
                Name = 'Fair Market Value',
                genesis__Product_Type__c = 'LEASE',
                genesis__Company__c = company.Id,
                genesis__Start_Date__c = Date.today().addYears(-1),
                genesis__End_Date__c = Date.today().addYears(2),
                genesis__Transaction_Date__c = Date.today().addMonths(-1),
                genesis__Enabled_Flag__c = true
        );
        insert rateCard;

        genesis__Rate_Card_Setup_Detail__c rateCardDetail = new genesis__Rate_Card_Setup_Detail__c (
                genesis__Rate_Card_Setup_Header__c = rateCard.Id,
                genesis__Enabled_Flag__c = true,
                genesis__Residual_Type__c = 'FAIR MARKET VALUE',
                genesis__Residual_Term__c = 0,
                genesis__Minimum_Financed_Amount__c = 500,
                genesis__Term__c = 12,
                genesis__Arrears__c = true,
                genesis__Residual_Percent__c = 0.17,
                genesis__Maximum_Financed_Amount__c = 50000,
                genesis__Payment_Frequency__c = 'MONTHLY',
                genesis__Days_Convention__c = '30/360',
                genesis__Rate_Factor__c = 0.075050000000,
                genesis__Rate_Factor_Based_On_Amount__c = 1000
        );
        insert rateCardDetail;

        genesis__Product_Rate_Card_Association__c productRateCard = new genesis__Product_Rate_Card_Association__c(
                genesis__CL_Product__c = product.Id,
                genesis__Rate_Card_Setup__c = rateCard.Id
        );
        insert productRateCard;

        clcommon__Fee_Definition__c fee = new clcommon__Fee_Definition__c(
                Name = 'Estimated Property Tax',
                clcommon__Class__c = 'Income',
                clcommon__Amount__c = 100
        );
        insert fee;

        Property_Tax_Rate_Factors__c taxRate = new Property_Tax_Rate_Factors__c (
                State__c = 'NJ',
                Rate_Factor__c = 0,
                Term__c = '12'
        );
        insert taxRate;

        TestHelper.getVertexCustomSettings();

        clcommon__Legal_Entity__c lentity = new clcommon__Legal_Entity__c( Name = 'Corporation' );
        insert lentity;



        Account acc = new Account (
                Name = 'sample Account',
                clcommon__Legal_Entity_Type__c = lentity.Id,
                EIN__c='123456798',
                Email_Address__c='abc123@gmail.com',
                Oracle_Vendor_ID__c='Y795'
        );
        insert acc;

        Address__c address = new Address__c (
                Address_Line_1__c = '123 Main Street',
                City__c = 'Morristown',
                State__c = 'NJ',
                County__c = 'Morris',
                Country__c = 'USA',
                Account__c = acc.Id,
                Bill_To_Usage__c = true,
                Install_At__c = true,
                Validation_Status__c = DLLNewCoConstants.EXPERIAN_VALIDATION_STATUS
        );
        insert address;

        clcommon__Agreement__c dealerProgram = new clcommon__Agreement__c (
                Name = 'NewCo',
                CL_Product__c = product.Id,
                Rate_Card__c = rateCard.Id
        );
        insert dealerProgram;

        genesis__Equipment_Master__c equipment = new genesis__Equipment_Master__c (
                Manufacturer__c = 'TestCo',
                Product_Type__c = 'Printer',
                MSRP__c = 999.99
        );
        insert equipment;

        clcommon__Party_Type__c dealerType = new clcommon__Party_Type__c(
                Name = 'DEALER'
        );
        insert dealerType;

        genesis__Applications__c application = new genesis__Applications__c (
                genesis__CL_Product__c = product.Id,
                Dealer__c = dealer.Id,
                genesis__Account__c = acc.Id,
                Dealer_Invoice_Number__c = '123456',
                Dealer_Invoice_Date__c = Date.today(),
                //genesis__Term__c = 12,
                Dealer_Program__c = dealerProgram.Id,
                genesis__Expected_Start_Date__c = Date.today().addMonths(1),
                genesis__Expected_Close_Date__c = Date.today().addMonths(12),
                genesis__Product_Type__c = 'LEASE',
                genesis__Product_Sub_Type__c = 'FINANCE LEASE',
                genesis__Company__c = company.Id,
                Purchase_Option__c = 'Fair Market Value',
                genesis__Financed_Amount__c = 999.99,
                genesis__Payment_Amount__c = 10,
                genesis__Status__c = 'CREDIT APPROVED'
        );
        insert application;


            FMZ_QQ_ConvertToApplicationController.defaultAppValues(application.Id);
        }
    }

    public testMethod static void convertToApp(){
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

        List<User> users = getPortalDealerUsers(new List<Contact>{dealerUser});
        insert users;

        System.runAs(users[0]){

        clcommon__Fee_Definition__c feeDef = new clcommon__Fee_Definition__c(
                Name = 'Origination Fees',
                clcommon__Class__c = 'Expense',
                clcommon__Amount__c = 75.00);
        insert feeDef;
        clcommon__Party_Type__c pType = new clcommon__Party_Type__c( Name = 'DEALER' );
        insert pType;
        clcommon__Legal_Entity__c legEnt = new clcommon__Legal_Entity__c(Name = 'Corporation');
        insert legEnt;

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
                genesis__Postal_Code__c = '10019',
                Estimated_Financed_Amount__c = '10000',
                genesis__Status__c = 'NEW'
        );


            FMZ_QQ_NewQuickQuoteController.CreateResponse response = FMZ_QQ_NewQuickQuoteController.createRecords(qq, false);
            System.assertEquals('SUCCESS', response.status);
            System.assertNotEquals(null, response.message);
            Id qqId = response.message;

            genesis__Quick_Quotes__c updatedQQ = new genesis__Quick_Quotes__c(Id = qqId, genesis__Status__c = 'CREDIT APPROVED');
            update updatedQQ;

            System.debug('!!!Converting');
            String convertResp = FMZ_QQ_ConvertToApplicationController.convertToApplication(qqId);
            System.debug('!!!'+convertResp);

            Integer statusIdx = convertResp.indexOf('"status" :');
        }
    }

    private static List<User> getPortalDealerUsers(List<Contact> contacts){
        Id p = [select id from profile where name='NewCo Dealer Portal User'].id;
        Id urId = [SELECT Id, Name FROM UserRole WHERE Name = 'Dealer User'].Id;
        List<User> users = new List<User>();
        for(Contact con : contacts){
            users.add(new User(alias=con.FirstName, email=con.Email, UserRoleId = urId,
                    emailencodingkey='UTF-8', lastname=con.LastName, languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p, country='United States', IsActive =true,
                    ContactId = con.Id, timezonesidkey='America/Los_Angeles', username=con.Email));
        }
        return users;
    }
}