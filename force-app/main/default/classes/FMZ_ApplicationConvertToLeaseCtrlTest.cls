@IsTest
public class FMZ_ApplicationConvertToLeaseCtrlTest {

	static testMethod void app_convert_converted() {

		RecordType dealerRT = [SELECT Id FROM RecordType WHERE Name = 'Dealer' AND SobjectType = 'Account'];
		Account dealer = new Account ( Name = 'Dealer', RecordTypeId = dealerRT.Id/*, OwnerId = portalAccountOwner1.Id*/);
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

		// can't setup all the conversion records needed to actually convert app to lease
		System.runAs(users[0]){

		genesis__Company__c company = new genesis__Company__c (
			Name = 'DeLage Landen',
			genesis__Short_Name__c = 'HQ',
			genesis__Default__c = true,
			genesis__Enabled_Flag__c = true
		);
		insert company;

		cllease.TestHelper.createVATRateSetup();
	

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



		User dUser = [SELECT Id, AccountId FROM User WHERE Id =: users[0].Id];
		System.assert(dUser.AccountId != null);

		Account acc = new Account (
			Name = 'sample Account',
			clcommon__Legal_Entity_Type__c = lentity.Id,
			EIN__c = '12-1234567',
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

		genesis__Application_Equipment__c appEquipment = new genesis__Application_Equipment__c (
			genesis__Application__c = application.Id,
			genesis__Equipment__c = equipment.Id,
			Install_Account__c = acc.Id,
			genesis__Estimated_Selling_Price__c = 750,
			Install_Address1__c = address.Id,
			Installation_Date__c = Date.today().addDays(15)
		);
		insert appEquipment;


			String result1 = FMZ_ApplicationConvertToLeaseController.convert(application.Id);
			System.assertNotEquals(null, result1);

			genesis__Applications__c app2 = FMZ_ApplicationConvertToLeaseController.getApplication(application.Id);
			System.assertEquals(app2.Id, application.Id);
		}

		Test.stopTest();

	}

	static testMethod void app_convert_not_converted() {

		RecordType dealerRT = [SELECT Id FROM RecordType WHERE Name = 'Dealer' AND SobjectType = 'Account'];
		Account dealer = new Account ( Name = 'Dealer', RecordTypeId = dealerRT.Id/*, OwnerId = portalAccountOwner1.Id*/);
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

		// can't setup all the conversion records needed to actually convert app to lease
		System.runAs(users[0]){

			genesis__Company__c company = new genesis__Company__c (
					Name = 'DeLage Landen',
					genesis__Short_Name__c = 'HQ',
					genesis__Default__c = true,
					genesis__Enabled_Flag__c = true
			);
			insert company;

			cllease.TestHelper.createVATRateSetup();

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



			User dUser = [SELECT Id, AccountId FROM User WHERE Id =: users[0].Id];
			System.assert(dUser.AccountId != null);

			Account acc = new Account (
					Name = 'sample Account',
					clcommon__Legal_Entity_Type__c = lentity.Id,
					EIN__c = '12-1234567',
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

//			genesis__Application_Equipment__c appEquipment = new genesis__Application_Equipment__c (
//					genesis__Application__c = application.Id,
//					genesis__Equipment__c = equipment.Id,
//					Install_Account__c = acc.Id,
//					genesis__Estimated_Selling_Price__c = 750,
//					Install_Address1__c = address.Id,
//					Installation_Date__c = Date.today().addDays(15)
//			);
//			insert appEquipment;


			String result1 = FMZ_ApplicationConvertToLeaseController.convert(application.Id);
			//System.assertEquals('Conversion Mapping is not present', result1);

		}

		Test.stopTest();

	}

	static testMethod void handleSuccessfulConvert() {

		RecordType dealerRT = [SELECT Id FROM RecordType WHERE Name = 'Dealer' AND SobjectType = 'Account'];
		Account dealer = new Account ( Name = 'Dealer', RecordTypeId = dealerRT.Id/*, OwnerId = portalAccountOwner1.Id*/);
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

		// can't setup all the conversion records needed to actually convert app to lease
		System.runAs(users[0]){

			genesis__Company__c company = new genesis__Company__c (
					Name = 'DeLage Landen',
					genesis__Short_Name__c = 'HQ',
					genesis__Default__c = true,
					genesis__Enabled_Flag__c = true
			);
			insert company;

			cllease.TestHelper.createVATRateSetup();

			Date currentSystemDate = Date.newInstance(2018, 03, 31);
			cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office', true);
			dummyOffice.cllease__Current_System_Date__c = currentSystemDate;
			dummyOffice.Dll_Seg1_Company__c         = '00101';
			dummyOffice.Dll_Seg2_Business_Unit__c   = '02';
			dummyOffice.Dll_Seg3_Department__c      = '3030';
			dummyOffice.Dll_Seg6__c                 = '00000';
			dummyOffice.Dll_Seg7__c                 = '0000';
			update  dummyOffice;

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



			User dUser = [SELECT Id, AccountId FROM User WHERE Id =: users[0].Id];
			System.assert(dUser.AccountId != null);

			Account acc = new Account (
					Name = 'sample Account',
					clcommon__Legal_Entity_Type__c = lentity.Id,
					EIN__c = '12-1234567',
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

//			genesis__Application_Equipment__c appEquipment = new genesis__Application_Equipment__c (
//					genesis__Application__c = application.Id,
//					genesis__Equipment__c = equipment.Id,
//					Install_Account__c = acc.Id,
//					genesis__Estimated_Selling_Price__c = 750,
//					Install_Address1__c = address.Id,
//					Installation_Date__c = Date.today().addDays(15)
//			);
//			insert appEquipment;


			FMZ_ApplicationConvertToLeaseController.handleSuccessfulConvert(application);
			application = [SELECT Id, genesis__Status__c FROM genesis__Applications__c WHERE Id =: application.Id];
			System.assertEquals('APPROVED - CONVERTED TO CONTRACT', application.genesis__Status__c);

		}

		Test.stopTest();
	}

	@isTest
	public static void getResultExceptionTest(){
		String result = FMZ_ApplicationConvertToLeaseController.getResultException('Test1 EXCEPTION, Test2: [Test3]');
		System.assertEquals('Test2', result);
	}

	private static List<User> getPortalDealerUsers(List<Contact> contacts){
		Id p = [select id from profile where name='NewCo Dealer Portal User'].id;
		//Id urId = [SELECT Id, Name FROM UserRole WHERE PortalType='Partner' LIMIT 1].Id;
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