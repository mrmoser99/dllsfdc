@isTest private class TestWelcomePacket
{ 
     
     
    static testMethod void testSave() 
    { 

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
			genesis__Account__c = acc.Id,
			Contract_Signer__c = 'Joe',
			Contract_Signer_Last_Name__c = 'Test',
			Contract_Signer_Title__c = 'CEO',
			Dealer_Invoice_Number__c = '12345',
			Dealer_Invoice_Date__c = Date.today()
		);
		insert app;

        Attachment ppa = new Attachment (
			ParentId = app.Id,
			Name = 'test.doc',
			Body = Blob.valueOf('test')
		);
        insert ppa;

        clcommon__Document_Definition__c cdd = new clcommon__Document_Definition__c();
        cdd.name = '01 Lease Agreement';
        insert cdd;

        clcommon__Document_Category__c category = new clcommon__Document_Category__c (
            clcommon__Document_Definition__c = cdd.id ,
			clcommon__Category_Name__c = '01 Lease Agreement',
			genesis__Application__c = app.Id
		);
        insert category;
        
        
        Attachment att = [SELECT Id, Name, ParentId FROM Attachment WHERE Id =: ppa.id];
		clcommon__Document_Category__c dcategory = [
				SELECT Id
				FROM clcommon__Document_Category__c
				WHERE
				clcommon__Category_Name__c =: '01 Lease Agreement'
				AND genesis__Application__c =: ppa.ParentId
				LIMIT 1
		];

		clcommon__Category_Attachment_Association__c association = new clcommon__Category_Attachment_Association__c(
				clcommon__Attachment_Id__c = ppa.Id,
				Name = ppa.Name,
				clcommon__Document_Category__c = dcategory.Id
		);
		system.debug(association);
		insert association;

        
         
    }
 
 }