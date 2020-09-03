@IsTest
public class FMZ_ApplicationDocumentsControllerTest {

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
			genesis__Account__c = acc.Id,
			Contract_Signer__c = 'Joe',
			Contract_Signer_Last_Name__c = 'Test',
			Contract_Signer_Title__c = 'CEO',
			Dealer_Invoice_Number__c = '12345',
			Dealer_Invoice_Date__c = Date.today()
		);
		insert app;

	}
    
    static testmethod void application_getApp_returned(){

		genesis__Applications__c app = [SELECT Id FROM genesis__Applications__c];

		Test.startTest();

        app = FMZ_ApplicationDocumentsController.getApplication(app.id);

		Test.stopTest();
        
        System.assertEquals('Joe', app.Contract_Signer__c);
		System.assertEquals('Test', app.Contract_Signer_Last_Name__c);
		System.assertEquals('CEO', app.Contract_Signer_Title__c);
		System.assertEquals('12345', app.Dealer_Invoice_Number__c);
		System.assertEquals(Date.today(), app.Dealer_Invoice_Date__c);

    }

	static testMethod void applicationWithDocs_getDocs_gotten() {

		genesis__Applications__c app = [SELECT Id FROM genesis__Applications__c];

		clcommon__Document_Category__c category = new clcommon__Document_Category__c (
			clcommon__Category_Name__c = 'Test Category',
			genesis__Application__c = app.Id
		);
		insert category;

		Attachment doc = new Attachment (
			ParentId = app.Id,
			Name = 'test.doc',
			Body = Blob.valueOf('test')
		);
		insert doc;

		clcommon__Category_Attachment_Association__c docCat = new clcommon__Category_Attachment_Association__c(
			clcommon__Document_Category__c = category.Id,
			clcommon__Attachment_Id__c = doc.Id
		);
		insert docCat;

		Test.startTest();

		List<Attachment> docs = FMZ_ApplicationDocumentsController.getDocuments(app.Id);

		Test.stopTest();

		System.assertEquals(doc.Id, docs[0].Id);
		System.assertEquals(doc.Name, docs[0].Name);
		System.assertEquals(category.clcommon__Category_Name__c, docs[0].Description);

	}
    
    static testmethod void waitTest(){
        FMZ_ApplicationDocumentsController.wait(null);
        FMZ_ApplicationDocumentsController.wait(500);
    }

	static testMethod void appWithData_update_changed() {

		genesis__Applications__c app = [SELECT Id FROM genesis__Applications__c];

		app.Contract_Signer__c = 'Mary';
		app.Contract_Signer_Last_Name__c = 'Jones';
		app.Contract_Signer_Title__c = 'CFO';
		app.Dealer_Invoice_Number__c = null;
		app.Dealer_Invoice_Date__c= null;

		Test.startTest();

		FMZ_ApplicationDocumentsController.updateApplication(app);

		Test.stopTest();

		app =
			[SELECT Id, Contract_Signer__c, Contract_Signer_Last_Name__c, Contract_Signer_Title__c,
					Dealer_Invoice_Number__c, Dealer_Invoice_Date__c
			FROM genesis__Applications__c];

		System.assertEquals('Mary', app.Contract_Signer__c);
		System.assertEquals('Jones', app.Contract_Signer_Last_Name__c);
		System.assertEquals('CFO', app.Contract_Signer_Title__c);
		System.assertEquals(null, app.Dealer_Invoice_Number__c);
		System.assertEquals(null, app.Dealer_Invoice_Date__c);

	}

	static testMethod void app_generateLease_generated() {

		genesis__Applications__c app = [SELECT Id FROM genesis__Applications__c];

		clcommon__Document_Category__c category = new clcommon__Document_Category__c (
			clcommon__Category_Name__c = FMZ_ApplicationDocumentsController.LEASE_AGREEMENT_CATEGORY,
			genesis__Application__c = app.Id
		);
		insert category;

		CongaMock mock = new CongaMock();
		mock.applicationId = app.Id;

		Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();

		String result = FMZ_ApplicationDocumentsController.generateLeaseDocument(app.Id);
		System.assertEquals(FMZ_ApplicationDocumentsController.CONGA_SUCCESS_MESSAGE, result);

		Test.stopTest();

//		clcommon__Category_Attachment_Association__c docCategory =
//			[SELECT Id, Name, clcommon__Document_Category__c, clcommon__Attachment_Id__c
//			FROM clcommon__Category_Attachment_Association__c];
//
//		System.assertEquals('lease.doc', docCategory.Name);
//		System.assertEquals(category.Id, docCategory.clcommon__Document_Category__c);
//		System.assertNotEquals(null, docCategory.clcommon__Attachment_Id__c);
//
//		Attachment doc =
//			[SELECT Name, ParentId
//			FROM Attachment
//			WHERE Id = :docCategory.clcommon__Attachment_Id__c];
//
//		System.assertEquals('lease.doc', doc.Name);
//		System.assertEquals(app.Id, doc.ParentId);

	}

	static testMethod void app_generateLease_error() {

		genesis__Applications__c app = [SELECT Id FROM genesis__Applications__c];

		CongaMock mock = new CongaMock();
		mock.applicationId = app.Id;
		mock.isSuccess = false;

		Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();

		try {
			FMZ_ApplicationDocumentsController.generateLeaseDocument(app.Id);
			//System.assert(false, 'Exception not thrown');
		} catch (AuraHandledException e) {
			System.assertEquals('error: Unknown', e.getMessage());
		}

		Test.stopTest();

	}

	static testMethod void app_uploadAttachment_saved() {

		genesis__Applications__c app = [SELECT Id FROM genesis__Applications__c];

		clcommon__Document_Category__c category = new clcommon__Document_Category__c (
			clcommon__Category_Name__c = FMZ_ApplicationDocumentsController.LEASE_AGREEMENT_CATEGORY,
			genesis__Application__c = app.Id
		);
		insert category;

		Test.startTest();

		String content = 'ABC TEST 123';
		Blob document = Blob.valueOf(content);  

		FMZ_ApplicationDocumentsController.uploadAttachment(app.Id, 'test.pdf', 'application/pdf',
			EncodingUtil.base64Encode(document));

		Test.stopTest();

		Attachment doc =
		[SELECT Name, ParentId, ContentType, Body
		FROM Attachment];

		System.assertEquals('test.pdf', doc.Name);
		System.assertEquals(app.Id, doc.ParentId);
		System.assertEquals('application/pdf', doc.ContentType);
		System.assertEquals(content, doc.Body.toString());

		clcommon__Category_Attachment_Association__c docCategory =
		[SELECT Id, Name, clcommon__Document_Category__c, clcommon__Attachment_Id__c
		FROM clcommon__Category_Attachment_Association__c];

		System.assertEquals('test.pdf', docCategory.Name);
		System.assertEquals(category.Id, docCategory.clcommon__Document_Category__c);
		System.assertNotEquals(null, docCategory.clcommon__Attachment_Id__c);

	}

	public class CongaMock implements HttpCalloutMock {
		public Id applicationId;
		public Boolean isSuccess = true;
		public HttpResponse respond(HttpRequest req) {
			if (isSuccess) {
				Attachment doc = new Attachment (
					ParentId = applicationId,
					Name = 'lease.doc',
					Body = Blob.valueOf('test')
				);
				insert doc;
			}
			HttpResponse resp = new HttpResponse();
			resp.setStatusCode(200);
			resp.setStatus('OK');
			resp.setBody(isSuccess? FMZ_ApplicationDocumentsController.CONGA_SUCCESS_MESSAGE : 'error: Unknown');
			return resp;
		}

	}

}