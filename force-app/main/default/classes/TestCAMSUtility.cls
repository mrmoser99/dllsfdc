@isTest 
public class TestCAMSUtility{

	public static void testMethod1() {
		// code_block	
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

		Map<ID,String> applicationMap;
		applicationMap.put(app.id,null);
		String status = 'test';
		Boolean pep = false;

		CAMSUtility.createCamsCheckRecord(applicationMap, status, pep);
	}
	
}