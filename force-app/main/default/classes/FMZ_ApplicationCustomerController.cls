public without sharing class FMZ_ApplicationCustomerController {

	@AuraEnabled
	public static Account getAccount(Id applicationId) {
		genesis__Applications__c app =
			[SELECT
					EIN_Number__c,
					genesis__Account__r.Id,
					genesis__Account__r.Name,
					genesis__Account__r.Phone,
					genesis__Account__r.Email_Address__c,
					genesis__Account__r.EIN__c
			FROM genesis__Applications__c
			WHERE Id =: applicationId];
		Account acct = new Account(
				Id = app.genesis__Account__r.Id,
				Name = app.genesis__Account__r.Name,
				Phone = app.genesis__Account__r.Phone,
				Email_Address__c = app.genesis__Account__r.Email_Address__c,
				EIN__c = app.genesis__Account__r.EIN__c
		);

		
		if(acct.EIN__c != app.EIN_Number__c){
			app.EIN_Number__c = acct.EIN__c;
			update app;
		}
		return acct;
	}

	@AuraEnabled
	public static void updateAccount(Account acct, String applicationId) {
		genesis__Applications__c app = new genesis__Applications__c(Id = applicationId, EIN_Number__c = acct.EIN__c);
		
		

		Contact c = [select id from contact where accountId = :acct.id and firstname = 'System' and lastname = 'BillTo'];
		c.email = acct.Email_Address__c;

		List<Address__c> aList = [select id from Address__c where account__C = :acct.id];
		for (Address__c a:aList)
			a.Email_Address__c = acct.email_address__c;

		acct.clcommon__Email__c = acct.email_address__c;

		update acct;
		update c;
		update aList;
		update app;

	}

}