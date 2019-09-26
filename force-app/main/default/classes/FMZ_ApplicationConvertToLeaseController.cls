/***************************************************************************************************************
 * 
 *
 * Change Log:
 *
 * 9/26/19 - Changed status from CREDIT APPROVED TO CAMS APPROVED for cams

 ********************************************************************************************************************/

public without sharing class FMZ_ApplicationConvertToLeaseController {

	@AuraEnabled
	public static genesis__Applications__c getApplication(Id applicationId) {

		genesis__Applications__c result =
			[SELECT Id, genesis__Status__c, Lease_Number__c, Lease_Number__r.cllease__Lease_Status__c
			FROM genesis__Applications__c
			WHERE Id = :applicationId];

		return result;

	}

	@AuraEnabled
	public static String convert(Id applicationId) {

		try {

			genesis__Applications__c app =
				[SELECT Id, genesis__Status__c, Lease_Number__c
				FROM genesis__Applications__c
				WHERE Id = :applicationId];

			if (app.Lease_Number__c != null) {
				return 'A funding request has already been created for this application';
			}

			// CREDIT APPROVED is API value for OFAC APROVED;
			/* mrm 9/236 changed from CREDIT APPROVED to CAMS APPROVED */
			if (app.genesis__Status__c != 'CAMS APPROVED') {
				return 'The application must be completed and approved before it can be funded';
			}

			List<Equipment_Funding_Detail__c> funding =
				[SELECT Id, Party__c
				FROM Equipment_Funding_Detail__c
				WHERE Application__c = :applicationId
				AND Party__c = NULL];
			if (!funding.isEmpty()) {
				fixDealerParty(applicationId, funding);
			}

			String result = genesis.ConvertApplicationCtrl.convertApplicationToContract(applicationId);
			System.debug('!!! Result from Convert to Contract: '+result);
			if (String.isNotBlank(result) && result.contains('EXCEPTION, ')) {
				result = getResultException(result);
			}else if(result == 'Application is converted to contract successfully'){
				handleSuccessfulConvert(app);
			}

			return result;

		} catch(Exception e) {
			System.debug(e.getStackTraceString());
			throw new AuraHandledException(e.getMessage());
		}

	}

	@TestVisible
	private static void handleSuccessfulConvert(genesis__Applications__c app){
		app.genesis__Status__c = 'APPROVED - CONVERTED TO CONTRACT';
		update app;

		app = [SELECT Id, Lease_Number__c, Oracle_Trade_Up_Amount__c, Oracle_Trade_up_Lease_Number__c, Oracle_Trade_up_Quote_Number__c, Oracle_Trade_up_Quote_Expiration_Date__c
					FROM genesis__Applications__c WHERE Id =: app.Id];

		List<cllease__Lease_Account__c> lease = [SELECT Id FROM cllease__Lease_Account__c WHERE Id =: app.Lease_Number__c];
		if(lease.size() > 0){
			lease[0].Oracle_Trade_up_Lease_Number__c = app.Oracle_Trade_up_Lease_Number__c;
			lease[0].Oracle_Trade_Up_Quote_Amount__c = app.Oracle_Trade_Up_Amount__c;
			lease[0].Oracle_Trade_up_Quote_Number__c = app.Oracle_Trade_up_Quote_Number__c;
			lease[0].Oracle_Trade_up_Quote_Expiration_Date__c = app.Oracle_Trade_up_Quote_Expiration_Date__c;
			update lease;
		}

		List<Lease_OLM_Quote__c> quote = [SELECT Id FROM Lease_OLM_Quote__c WHERE Name =: app.Oracle_Trade_up_Quote_Number__c LIMIT 1];
		if(quote.size() > 0 && lease.size() > 0){
			quote[0].LS_Contract__c = lease[0].Id;
			update quote;
		}
	}

	@TestVisible
	private static String getResultException(String result){
		String outputResult;
		String[] splitResult = result.split('EXCEPTION, ');
		if (splitResult.size() > 1) {
			outputResult = splitResult[1];
			if (outputResult.contains(': [')) {
				splitResult = outputResult.split(': \\[');
				outputResult = splitResult[0];
			}
		}
		return outputResult;
	}

	// add the dealer party if they aren't added already
	// set the dealer on the equipment funding record
	private static void fixDealerParty(Id applicationId, List<Equipment_Funding_Detail__c> funding) {

		List<clcommon__Party__c>  dealerParty =
			[SELECT Id
			FROM clcommon__Party__c
			WHERE genesis__Application__c = :applicationId
			AND clcommon__Type__r.Name = 'DEALER'
			LIMIT 1];

		if (dealerParty.isEmpty()) {

			List<clcommon__Party_Type__c> dealerType =
				[SELECT Id
				FROM clcommon__Party_Type__c
				WHERE Name = 'DEALER'];

			if (dealerType.isEmpty()) {
				return;
			}

			List<User> u =
				[SELECT Id, AccountId
				FROM User
				WHERE Id = :UserInfo.getUserId()];

			if (u.isEmpty() || u[0].AccountId == null) {
				return;
			}

			dealerParty = new List<clcommon__Party__c>{
				new clcommon__Party__c (
					genesis__Application__c = applicationId,
					clcommon__Type__c = dealerType[0].Id,
					clcommon__Account__c = u[0].AccountId
				)
			};
			insert dealerParty;

		}

		for (Equipment_Funding_Detail__c efd : funding) {
			efd.Party__c = dealerParty[0].Id;
		}
		update funding;

	}

}