public without sharing class FMZ_ApplicationController {

	@AuraEnabled
	public static void clearPricing(Id applicationId) {

		try {

			// clear the pricing information
			genesis__Applications__c application = new genesis__Applications__c (
				Id = applicationId,
				genesis__Payment_Amount__c = 0
			);
			update application;

			List<genesis__Application_Pricing_Detail__c> pricing = [
				SELECT Id
				FROM genesis__Application_Pricing_Detail__c
				WHERE genesis__Application__c = :applicationId
			];
			delete pricing;

			List<Application_Fee__c> ept = [
				SELECT Id
				FROM Application_Fee__c
				WHERE Fee__r.Name IN ('Estimated Property Tax', 'Insurance Fees')
				AND Frequency__c <> 'ONE TIME'
				AND Application__c = :applicationId
			];
			delete ept;

		} catch (Exception e) {
			System.debug(e.getStackTraceString());
			throw new AuraHandledException(e.getMessage());
		}

	}

    @AuraEnabled
    public static String generatePricing(Id applicationId) {

		try {
			String result;

			// make sure the number of months in the term are set
			genesis__Applications__c application = [
				SELECT Id, genesis__Term__c, Customer_Provided_Insurance__c, Trade_Up_Quote__c, genesis__Other_Financed_fees__c,
					(SELECT Id FROM genesis__Application_Equipments__r LIMIT 1)
				FROM genesis__Applications__c
				WHERE Id =: applicationId
			];

			if (application.genesis__Term__c == null) {
				return 'Term is required to calculate pricing';
			}

			if (application.genesis__Application_Equipments__r.isEmpty()) {
				return 'No equipment selected';
			}

			///// GENERATE PRICING BUTTON /////

			// NOTE: inside vertex pricing this causes error in portal if user doesn't have
			// access to cllease__Office_Name__c
			//DateTime currentSystemDate  =   cllease.SystemDateUtil.getCurrentSystemDate();

			// 1 - Pre-Upfront Property Tax Calculation
//			result = VertexUpfrontTaxCalculation.VertexGetUpfrontTax(new List<Id>{
//				applicationId
//			});
//			if (result == 'false') {
//				return 'Tax Calculation not Processed because some Equipment has No Installation Address.';
//			}

			// clear property tax for tax exempt
//			List<genesis__Application_Equipment__c> equipment =
//				[SELECT Id, Tax_Exempt__c/*, Upfront_Tax_Amount__c*/
//				FROM genesis__Application_Equipment__c
//				WHERE genesis__Application__c = :applicationId
//				AND Tax_Exempt__c = true];

//			if (!equipment.isEmpty()) {
//				for (genesis__Application_Equipment__c e : equipment) {
//					e.Upfront_Tax_Amount__c = 0;
//				}
//				update equipment;
//			}

// UPDATING PRICING GENERATION PER Q2s GENERATE PRICING FLOW

			result = UpdateEquipmentDetails.updateEquipmentDetail(applicationId);
			if (result != 'SUCCESS') {
				return result;
			}

			

			// 2 - Generate Pricing
			result = genesis.SkuidPricingCtrl.generatePricing(applicationId);
			if (result != 'Pricing Generated...') {
				return result;
			}

			// 4 - Calculate Estimated Property Tax
			result = calculateEstPropertyTax.func_calcEPT(applicationId);
			if (result != 'SUCCESS') {
				return 'Estimated Property Tax Calculation Failed.';
			}

			if (!application.Customer_Provided_Insurance__c) {
				// 3 - Calculate Insurance
				result = CalculateInsurance.GetInsuranceAmount(applicationId);
				if (result != 'SUCCESS') {
					return 'Insurance Calculation Failed.';
				}
			}

			///// SELECT PRICING BUTTON //////

			List<genesis__Application_Pricing_Detail__c> pricing = [
				SELECT Id, genesis__Selected__c/*, Payment_Amount__c*/,
						genesis__Rate_Factor__c, genesis__Residual_Percent__c
				FROM genesis__Application_Pricing_Detail__c
				WHERE genesis__Application__c = :applicationId
				LIMIT 1
			]; // should only be one if term chosen

			if (pricing.isEmpty()) {
				return 'No pricing found.';
			}else{
				// Calculate Residual Amounts
				List<genesis__Application_Equipment__c> equipment =
				[SELECT Id, genesis__Residual_Value__c
				FROM genesis__Application_Equipment__c
				WHERE genesis__Application__c = :applicationId];

				if(equipment.size() > 0){
					for(genesis__Application_Equipment__c eq : equipment){
						eq.genesis__Residual_Value__c = pricing[0].genesis__Residual_Percent__c;
					}
					update equipment;
				}
			}

			List<Application_Fee__c> ept = [
					SELECT Id, Application__c
					FROM Application_Fee__c
					WHERE Application__c = :applicationId
			];
			UpdateServiceFeeHandler.func_USF(ept,'Update');

			result = genesis.SelectPricingOnApplication.selectPricingOption(pricing[0].Id);


			//TODO: zero out upfront tax for tax exempt properties

			// application = [
			// 	SELECT Id, Oracle_Trade_Up_Amount__c, Trade_Up_Quote__c, genesis__Other_Financed_fees__c FROM genesis__Applications__c
			// 	WHERE Id =: applicationId
			// ];
			//
			// if(application.Trade_Up_Quote__c){
			// 		application.genesis__Other_Financed_fees__c = application.Oracle_Trade_Up_Amount__c;
			// 		update application;
			// }


			return result;

		} catch (Exception e) {
			System.debug(e.getStackTraceString());
			throw new AuraHandledException(e.getMessage());
		}

	}
	
	@AuraEnabled
    public static void calcUpfrontTax(String applicationId) {
    
        genesis__Applications__c a = [select name FROM genesis__Applications__c where id = :applicationId];

        VertexUpfrontTaxCalculation.VertexGetUpfrontTax(a.name);
        
    }


    @AuraEnabled
	public static Boolean[] checkCompletion(Id applicationId,  String[] sections) {

		genesis__Applications__c app =
			[SELECT Id, genesis__Term__c, genesis__Account__c,
				Contract_Signer__c, Contract_Signer_Last_Name__c, Contract_Signer_Title__c,
				genesis__Account__r.Email_Address__c, genesis__Account__r.Phone,
				genesis__Account__r.EIN__c, Dealer_Invoice_Date__c, Dealer_Invoice_Number__c,
				(SELECT Id
				FROM genesis__Application_Parties__r
				WHERE genesis__Party_Type__c != NULL
				LIMIT 1),
				(SELECT Id, Serial_Number__c, genesis__Estimated_Selling_Price__c,
						Install_Address1__c, Installation_Date__c
				FROM genesis__Application_Equipments__r
				WHERE Serial_Number__c <> NULL
				AND genesis__Estimated_Selling_Price__c <> NULL
				AND Install_Address1__c <> NULL
				AND Installation_Date__c <> NULL
				LIMIT 1),
				(SELECT Id
				FROM Application_Fees__r
				LIMIT 1),
				(SELECT Id
				FROM Attachments)
			FROM genesis__Applications__c
			WHERE Id = :applicationId];

		List<Address__c> installLocations =
			[SELECT Id
			FROM Address__c
			WHERE Account__c = :app.genesis__Account__c
			AND Install_At__c = TRUE
			LIMIT 1];

		Boolean[] result = new Boolean[sections.size()];

		for (Integer i = 0; i < sections.size(); i++) {
			switch on sections[i] {
				when 'parties' {
					result[i] = String.isNotBlank(app.genesis__Account__r.Email_Address__c)
						&& String.isNotBlank(app.genesis__Account__r.Phone)
							&& String.isNotBlank(app.genesis__Account__r.EIN__c);
				} when 'terms' {
					result[i] = app.genesis__Term__c != null;
				} when 'locations' {
					result[i] = !installLocations.isEmpty();
				} when 'equipment' {
					result[i] = !app.genesis__Application_Equipments__r.isEmpty();
				} when 'services' {
					result[i] = !app.Application_Fees__r.isEmpty();
				} when 'documents' {
					result[i] = String.isNotBlank(app.Contract_Signer__c)
						&& String.isNotBlank(app.Contract_Signer_Last_Name__c)
						&& String.isNotBlank(app.Contract_Signer_Title__c)
						&& String.isNotBlank(app.Dealer_Invoice_Number__c)
						&& app.Dealer_Invoice_Date__c != null
						&& !app.Attachments.isEmpty();
				} when else {
					result[i] = false;
				}
			}
		}

		return result;

	}

	@AuraEnabled
	public static void moveToOFACCheck(String appId){
		update new genesis__Applications__c(Id = appId, genesis__Status__c = 'APPROVED - DOCUMENT CHECK');
	}

	@AuraEnabled
	public static genesis__Applications__c getApplication(Id applicationId){
		return [
				SELECT Id, Name, Lease_Number__c, genesis__Status__c
				FROM genesis__Applications__c
				WHERE Id =: applicationId
				LIMIT 1
		];
	}

}