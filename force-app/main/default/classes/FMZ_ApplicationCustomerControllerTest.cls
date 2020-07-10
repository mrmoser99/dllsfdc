@isTest
public with sharing class FMZ_ApplicationCustomerControllerTest {

	@TestSetup
	static void setupApp() {

		cllease__Office_Name__c office = new cllease__Office_Name__c (
			cllease__Office_Short_Name__c = 'HQ',
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
			Oracle_Vendor_ID__c = 'Y795',
			Phone = '8005551212'
		);
		insert acc;

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

	static testMethod void account_getAccount_found() {

		genesis__Applications__c app = [SELECT Id FROM genesis__Applications__c];

		Test.startTest();

		Account acct = FMZ_ApplicationCustomerController.getAccount(app.Id);

		Test.stopTest();

		System.assertEquals('sample Account', acct.Name);
		System.assertEquals('abc123@gmail.com', acct.Email_Address__c);
		System.assertEquals('8005551212', acct.Phone);
		System.assertEquals('12-1234567', acct.EIN__c);

	}

	static testMethod void account_updateAccount_updated() {

		genesis__Applications__c app = [SELECT Id FROM genesis__Applications__c];

		Account acct = FMZ_ApplicationCustomerController.getAccount(app.Id);

		Test.startTest();

		acct.Email_Address__c = 'def987@gmail.com';
		acct.Phone = '8881112222';
		acct.EIN__c = '22-1234567';

		

		Contact c = new Contact(accountId = acct.id, firstname = 'System', lastname = 'BillTo');
		insert c;

		FMZ_ApplicationCustomerController.updateAccount(acct, app.Id);

		Test.stopTest();

		System.assertEquals('def987@gmail.com', acct.Email_Address__c);
		System.assertEquals('8881112222', acct.Phone);
		System.assertEquals('22-1234567', acct.EIN__c);

	}

}