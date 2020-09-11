@isTest 
public class TestCAMSUtility{
	@isTest
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
		,genesis__account__c = a.id
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

		ICS_Application__c app2 = new ICS_Application__c(
		quick_quote__c = qq.id
		);


		insert app2;
		system.debug('app is: ' + app2);
		Map<ID,String> applicationMap = new Map<ID,String>();
		Map<String,String> applicationMap2 = new Map<String,String>();
		
		String status = 'Auto Cleared';
		Boolean pep = false;

		cllease__Office_Name__c office = new cllease__Office_Name__c(cllease__Office_Short_Name__c='HQ',Name='sample Company',cllease__tax_method__c = 'Exclusive');
		insert office;    
		clcommon__Legal_Entity__c lentity = new clcommon__Legal_Entity__c(name='Corporation');
		insert lentity;    
		Account acc = new Account(name='sample Account',clcommon__Legal_Entity_Type__c=lentity.Id,
								  EIN__c='123456798',Email_Address__c='abc123@gmail.com',
								  Oracle_Vendor_ID__c='Y795');
		insert acc;
		clcommon__Agreement__c agreement = new clcommon__Agreement__c(name='NewCo');
		insert agreement;
	 
		genesis__Applications__c app = new  genesis__Applications__c();
		app.Payment_Method__c='ADVANCE'  ;
		app.genesis__Payment_Frequency__c= 'MONTHLY'   ;
		app.genesis__Expected_Start_Date__c=date.today();
		app.genesis__Product_Type__c='LEASE'  ;
		app.genesis__Product_Sub_Type__c='FINANCE LEASE'  ;
		app.genesis__Term__c = 12;
		app.Dealer_Program__c=agreement.id;
		insert app;  

		applicationMap.put(app.id,null);
		applicationMap2.put(app.id,null);
                                     
                                     
		test.startTest();
		CAMSUtility.createCamsCheckRecord(applicationMap, status, pep);

		CAMSUtility.callCams(applicationMap);

		CAMSUtility.updateApplicationStatus(applicationMap2);

		test.stopTest();
	}
	
}