@isTest
public class FMZ_ApplicationSummaryControllerTest {

    @TestSetup
    static void setupApp() {

        cllease__Office_Name__c office = new cllease__Office_Name__c (
            cllease__Office_Short_Name__c = 'HQ',
            cllease__tax_method__c = 'Exclusive',
            Name = 'sample Company'
        );
        insert office;

        clcommon__Legal_Entity__c lentity = new clcommon__Legal_Entity__c( Name = 'Corporation' );
        insert lentity;

        Account acc = new Account(
            Name = 'sample Account',
            clcommon__Legal_Entity_Type__c = lentity.Id,
            EIN__c = '12-1234567',
            Email_Address__c = 'abc123@gmail.com',
            Oracle_Vendor_ID__c = 'Y795'
        );
        insert acc;

		Address__c installAddress = new Address__c (
			Account__c = acc.Id,
			Install_At__c = true
		);
		insert installAddress;

		clcommon__Agreement__c agreement = new clcommon__Agreement__c( Name = 'NewCo' );
        insert agreement;

        genesis__Applications__c app = new  genesis__Applications__c (
            Payment_Method__c = 'ADVANCE',
            genesis__Payment_Frequency__c = 'MONTHLY',
            genesis__Expected_Start_Date__c = Date.today(),
            genesis__Product_Type__c = 'LEASE',
            genesis__Product_Sub_Type__c = 'FINANCE LEASE',
            genesis__Term__c = 12,
            Dealer_Program__c = agreement.Id,
            genesis__Account__c = acc.Id
        );
        insert app;

    }

    static testMethod void app_getInfo_returned() {

        genesis__Applications__c app = [SELECT Id, genesis__Payment_Frequency__c FROM genesis__Applications__c];

        Test.startTest();

        genesis__Applications__c app2 = FMZ_ApplicationSummaryController.getApplicationInfo(app.Id);

        System.assertEquals(app.Id, app2.Id);
        System.assertEquals(app.genesis__Payment_Frequency__c, app2.genesis__Payment_Frequency__c);

        Test.stopTest();

    }

    static testMethod void app_getInstallLocations_returned() {

        genesis__Applications__c app = [SELECT Id, genesis__Account__c FROM genesis__Applications__c];

		Address__c address = [SELECT Id FROM Address__c];

        List<genesis__Equipment_Master__c> equipment = new List<genesis__Equipment_Master__c>{
            new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'Printer', MSRP__c = 999.99)
        };
        insert equipment;

        List<genesis__Application_Equipment__c> appEquipment = new List<genesis__Application_Equipment__c>{
            new genesis__Application_Equipment__c(genesis__Application__c = app.Id, genesis__Equipment__c = equipment[0].Id,
                Install_Account__c = app.genesis__Account__c, Install_Address1__c = address.Id)
        };
        insert appEquipment;

		Test.startTest();

		List<Address__c> addresses = FMZ_ApplicationSummaryController.getInstallLocations(app.Id);

		System.assertEquals(1, addresses.size());

		Test.stopTest();

    }
    
    static testMethod void app_getBillingAddress() {

        genesis__Applications__c app = [SELECT Id, genesis__Account__c FROM genesis__Applications__c];
		
		Address__c address = [SELECT Id FROM Address__c];
        
        app.Billing_Address1__c = address.Id;

		Test.startTest();

		Address__c billAddress = FMZ_ApplicationSummaryController.getBillingAddress(app.Id);

		System.assertNotEquals(null, billAddress);

		Test.stopTest();

    }

}