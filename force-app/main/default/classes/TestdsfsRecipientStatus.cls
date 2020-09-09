@isTest
private class TestdsfsRecipientStatus{

	@testSetup static void setup(){

		RecordType r = [SELECT ID 
		FROM RecordType 
		WHERE DeveloperName = 'Dealer'AND SobjectType = 'Account'
		AND IsActive = true limit 1];                                   

		Account a = new Account(name='Talentica');
		a.RecordTypeId=r.id;
		insert a;

		genesis__Quick_Quotes__c qq = new genesis__Quick_Quotes__c(
		Dealer__c=a.id
		,genesis__Business_Name__c='test business name'
		,genesis__Address_Line_1__c='85 milford road'
		,genesis__City__c='Downingtown'
		,genesis__State__c='PA'
		,genesis__Postal_Code__c='19335'
		,Estimated_Financed_Amount__c='10000'
		,genesis__Status__c='NEW');

		insert qq;

		Address__c addr = new Address__c(
			address_line_1__c=qq.genesis__Address_Line_1__c
		 	,city__c=qq.genesis__City__c
		 	,state__c=qq.genesis__State__c
		 	,zip_code__c=qq.genesis__Postal_Code__c
		 	,account__c = a.id
		 );
		insert addr;		   

		ICS_Application__c app = new ICS_Application__c(
		quick_quote__c = qq.id
		);

		insert app;
		
	}

	@isTest static void testMethod1() {
		// code_block	
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

		RecordType dealerRT = [SELECT Id FROM RecordType WHERE Name = 'Dealer' AND SobjectType = 'Account'];
		Account dealer = new Account ( Name = 'Dealer', RecordTypeId = dealerRT.Id );
		insert dealer;

		Account acc = new Account (
			Name = 'sample Account',
			clcommon__Legal_Entity_Type__c = lentity.Id,
			EIN__c='12-1234567',
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
			genesis__Payment_Amount__c = 10
		);
		insert application;

		
		clcommon__Party__c dealerParty = new clcommon__Party__c(
			clcommon__Party_Type__c = dealerType.Id,
			genesis__Application__c = application.Id,
			clcommon__Account__c = dealer.Id
		);
		insert dealerParty;

		docusign_auth__c a = new docusign_auth__c(name = 'Newco', private_key__c = 'MIIEogIBAAKCAQEAmbOxOXWj+Zfv9lVLiZ2vRLUroeDtvpO5cr1akQ+DMC93iDSc' +
		'WK0Z0u27Z7m7AjKcG/73V1QD4zVzB8AbqspxVUkolJWgPiyaGiMqNLHfmY2+rLyB' +
		'j7zukYleixhQCaUfcH8MRRhrGtqhqRyFf/2tD8rI4H5o4qjBs2XdurNKdryZy59c' +
		'AZTT4hxaLHzgIrxLrNmrXKDd5NeNMCOiXzzbFFva2e3C0lNG0/kn5TZVecC2Vi6d' +
		'1xIb1lq2qPM5B4hFG2YyszJwCCr+RBQ/XdsIcLICJuPJwt7Vt2axb4wnaJv/+mzf' +
		'vTkYCqwO3EbNAH3eeFdudkRp6Ok+E1IhszO/DQIDAQABAoIBAAXhebDsntsAZLaE' +
		'mfDIfzm+Qs6dSAtoJIrO0uXE9ayEzGqCNM8xxFCtNuPnl8+kNxPdJAKL3OA3HdEY' +
		'mRZmS4LLW0mgFfL7CuRgHw/IFHmQElESn1RsEqav3lWtFvbfgf3wZnxITGTJI7FQ' +
		'PY1hm9sEU74/J+0wLsUZ6ytnC7zSOEGKXg0094H3P7UWPoVRRwxHCxysqer2hn02' +
		'5x+wdXIgBmL/YUF6ZYccpSiyTIlGuJt0EwRum0xNdHAPpsEUzbvALl9EkCDzBKYw' +
		'Q3zb6Ou1FgQvfqRzu9pR4u2mVX2tsGDCmLFRKA9hZSU312qXL4u+vjOyyHvfpTo0' +
		'xGRJSfECgYEA2tY3Wfwos5DkuaYjd1Y1neklx7zhh9RLiqVpbpIYMSRWcKVjfH/p' +
		'6kHAmitX0WRJmTmbLkMlzi2UXR9Ic3CER5yjxCOwfSw0A2tYMvOpyM2M3AgBaGsa' +
		'K4IHB/gVSZim+cDz/p7d8WhsZq9kaRn3kAcRsUqfgDhnRhtgIAU9+eUCgYEAs83I' +
		'BIPQAMb0yf3a2mxFtbjfFgk7rUpwmkecnJdU1phTXLoAHbP/Y0HoE3woaHW2oL5g' +
		'PSSTw71sR0/5m2bFOLQ223Lgf3349ezODM+H5chonCoP+4+TOGtoaqziNCGdHakD' +
		'HnxZRlSCRTwmEIxDa80tpnXrPJ/nfZLFYbF2vgkCgYBfig54VsJeQu/YrVPmkdiu' +
		'rE82OJwt9N1WFolFILs3GSoz28DnZeD1yOcRZ8LbQ/Ft19yMAfzLWtLfJP04iPL3' +
		'YMeOphYzT80VgRPsiryhUjwhA825jKjMPeRb8k845lBf0YG0tB8pefF5kzE/QXr3' +
		'gl6TDIU+MWHFFcaNtDwukQKBgDeGHnQ2eC8lQUZ3G/RDZyt80Xculr0mtasO3jAF' +
		'E2/JTkTeM1b41K7EFXSe7KOFZkYxQ+rdtrvFbQCAk+YHUHP4QtB1oxn7vrvCysZt' +
		'99tfjd5bpt/aMG5FzNLUXG4YyznzjUEGyVLMmgXjUyXdCpzpmWVEGMZ54rSGdGl8' +
		'sdxxAoGAZFEEikbEGppB1DXOcg+b9PoaZTaguh1M1NCnY1sEv8p66m59Ia9XQTDq' +
		'YMmuBAWk/h9UEF8Aq6naavRq6cSsIkCyGHpkQ0rM+rfotxjeap3fXLsqMZHbJCts' +
		'6DNvE0SlCqo9yuBL3sbNFC8dm7QA4jtn5TYsGWAfGo8y65gfrTg=');
		insert a;

		dsfs__DocuSign_Status__c d = new dsfs__DocuSign_Status__c( Application__c = application.id);
		insert d;
		dsfs__DocuSign_Recipient_Status__c rs = new dsfs__DocuSign_Recipient_Status__c(dsfs__Parent_Status_Record__c = d.id, dsfs__DocuSign_Recipient_Id__c = '100'
		,dsfs__DocuSign_Routing_Order__c = 3);
		insert rs;

		rs.release_equipment_signature__c = true;
		update rs;

		rs.dsfs__Recipient_Status__c = 'Completed';
		update rs;

		docusignUtil.dummyTests();

		JWTBearerFlow.dummyTests();
	}



}