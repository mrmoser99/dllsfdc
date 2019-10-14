/*********************************************************************************************
*
* NewCo Utility Class - used for common methods for the org
*
* Change Log:
*
* 2/15/18 - MRM Created
* 9/19/19 - MRM Changed invoice__c to clcommon__Consolidated_Invoice__c
* 9/24/19 - MRM added cams check to process
*
**********************************************************************************************/
global without sharing class NewCoUtility { 
	
	public static Boolean skipApplicationTrigger = false;
    
    /*************************************************************************************************
    *
    * converts date to 1/1/2019 to sf date
    *
    *************************************************************************************************/
    public static date convertDate(String inDate){
    	
    	Date outDate;
    	Integer year, month, day; 
				
    	/*
    		mm/dd/yyyy
    	*/
    	if (inDate == null) 
    		return null;
    		
    	List<String> partsList = new List<String>();
    	partsList = inDate.split('/');
    	system.debug('***** in date list' + partsList);
    	
    	year = integer.valueOf(partsList[2]);
    	system.debug('year' + year);
		month = integer.valueOf(partsList[0]);
		system.debug('month' + month);
		day = integer.valueOf(partsList[1]);
		system.debug('day' + day);
		outDate = Date.newInstance(year,month,day);
		
    	return outDate;
    }
    
    /*************************************************************************************************
    *
    * converts date to yyyymmdd to sf date
    *
    *************************************************************************************************/
    public static date convertDateYYYYMMDD(String inDate){
    	
    	Date outDate;
    	Integer year, month, day;
		 		
    	/*
    		mm/dd/yyyy
    	*/
    	if (inDate == null)
    		return null;
    		
    	
    	year = integer.valueOf(inDate.substring(0,4));
    	month = integer.valueOf(inDate.substring(4,6));
    	day = integer.valueOf(inDate.substring(6,8)); 
		
		outDate = Date.newInstance(year,month,day);
		
    	return outDate;
    }
    
    /*************************************************************************************************
    *
    * future delete ofac records
    *
    *************************************************************************************************/
    @future
    public static void deleteOfac(Map<ID,String> ofacMap){
    	
    	List <Int_OFAC__c> deleteList = new List<Int_OFAC__c>(0);
    	
    	deletelist = [select id from Int_OFAC__c where id in : ofacMap.keySet()];
    	
    	if (!deleteList.isEmpty())
    		delete deleteList;
    		
    		
    }
    
    /*************************************************************************************************
    * 
    * future delete ofac fincen
    *
    *************************************************************************************************/
    @future
    public static void deleteOfacFINCEN(Map<ID,String> ofacMap){
    	
    	List <Int_OFAC_FINCEN__c> deleteList = new List<Int_OFAC_FINCEN__c>(0);
    	
    	deletelist = [select id from Int_OFAC_FINCEN__c where id in : ofacMap.keySet()];
    	
    	if (!deleteList.isEmpty())
    		delete deleteList;
    		
    		
    }
    
    /*************************************************************************************************
    * 
    * future mark billing committted
    *
    *************************************************************************************************/
    
    public static void markBillingCommitted(){
    	
    	List <Int_PX_Billing__c> uList = new List<Int_PX_Billing__c>();
    	
    	ulist = [select id from Int_PX_Billing__c where committed__c = false];
    	
    	for (Int_PX_Billing__c b:uList)
    		b.committed__c = true;
    		
    	if (!uList.isEmpty())
    		update uList;
    		
    		
    }
    
    /*************************************************************************************************
    * 
    * SendWelcome Packet
    *
    *************************************************************************************************/
   	
    public static void sendWelcomePacket(Map<ID,String> leaseMap){
    	
    
      	cllease__Lease_Account__c lease = new cllease__Lease_Account__c();
      	
      	lease = [	Select c.cllease__Account__r.Id, c.cllease__Account__c 
      				From cllease__Lease_Account__c c
      				where id in :leaseMap.keySet() 
      			];
      
      	List<Address__c> addrList = [select  id
								, email_address__c
								from Address__c 
								where account__c = :lease.cllease__Account__r.id
								and bill_to_usage__c = true
								limit 1];
		
		if (addrList.size() != 0){
			Contact c = new Contact(firstname='test', lastname='conga',email=addrList[0].email_address__c);
			insert c;
			Map<ID,String> contactMap = new Map<ID,String>();
			contactMap.put(c.id,userinfo.getSessionId());
			
			if (addrList.size() != 0){
	  			NewCoUtility.congaWelcomePacket(leaseMap,contactMap);
	  		
    		}
    		else{
    			NewCoUtility.deleteContact(contactMap);
    		}
		}
		
    }  
    /****************************************************************************************
    *
    * CONGA WELCOME PACKET
    *
    ****************************************************************************************/
    @future(callout=true)
    public static void congaWelcomePacket(Map<ID,String> leaseMap, Map<ID,String> contactMap){
    	
    	List<clcommon__Category_Attachment_Association__c> aList = new List<clcommon__Category_Attachment_Association__c>();
    	
    	
    	
    	cllease__Lease_Account__c lease = new cllease__Lease_Account__c();
      	
      	
      	lease = [	Select c.cllease__Account__r.Id
      				, c.cllease__Account__c
      				, c.dealer_name__c
      				, c.Contract_Signer__c 
      				, c.application__c
      				, c.cllease__application_number__c
      				From cllease__Lease_Account__c c
      				where id in :leaseMap.keySet() 
      			];
    	system.debug('app nbr: ' + lease.cllease__application_number__c);
    	 
    	genesis__Applications__c app = [select id 
    									from genesis__Applications__c 
    									where name = :lease.cllease__application_number__c];
    									
    									
    	clcommon__Document_Definition__c dc = new clcommon__Document_Definition__c();
    	
    	dc = [	select id 
    		  	from clcommon__Document_Definition__c
    		  	where name = '08 Execution' 
    			]; 
    	
    	system.debug('lease app: ' + lease.application__c);  
    	aList = [
    				Select c.clcommon__Document_Category__r.genesis__Application__c
    					, c.clcommon__Document_Category__r.clcommon__Status__c
    					, c.clcommon__Document_Category__c
    					, c.clcommon__Attachment_Id__c
    					, c.Name, c.Id
    				From clcommon__Category_Attachment_Association__c c
					where clcommon__Document_Category__r.genesis__Application__c = :app.id
					//and	clcommon__Document_Category__c = :dc.id
					and clcommon__Document_Category__r.clcommon__Document_Definition__c = :dc.id
    			]; 
    	Set<ID> aSet = new Set<ID>();
    	
    	for (clcommon__Category_Attachment_Association__c a:aList)
    		aSet.add(a.clcommon__Attachment_id__c);
    			
    	
    		
    	Contact c = [select id,email from Contact where id in :contactMap.keySet()];
    	
    	System.debug('here');
    	
    	String version = '/services/Soap/u/39.0/';
 		String partnerUrl = Url.getSalesforceBaseUrl().toExternalForm()+version+UserInfo.getOrganizationId();  
 		String congaUrl = '';
 		
      	String parms = '&id=' + lease.Id +
		'&templateId=' + system.label.welcome_template + 
		'&queryId=' + system.label.welcome_query1 + '?pv0='+ lease.cllease__Account__r.id +  
		'&queryId=' + system.label.welcome_query2 + '?pv0=' + lease.Id + 
		'&DefaultPDF=1' +
		'&LG3=2&APIMode=1&OFN=Welcome';		
		
		
		String myURL = 'https://composer.congamerge.com/composer8/index.html';
       	congaUrl=myURL+'?sessionId='+
       	 		contactMap.get(c.id)+
        		'&serverUrl='+
        		partnerUrl
       		 	+parms;
	
       	// Instantiate a new http object
    	Http h = new Http();
    	HttpRequest req = new HttpRequest();
    	req.setEndpoint(congaUrl);
    	req.setMethod('GET');
    	req.setTimeout(60000);
    	HttpResponse res = h.send(req);
    	
    	
    	system.debug(res.getBody());
    	aSet.add(res.getBody());
    	
    	List<Attachment> attList = new List<Attachment>();
    	attList = [select id, Name, Body, BodyLength  from Attachment where id in :aSet];
    	/* email the welcome letter */
    	System.debug('after call');
    	
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   
		List<String> toAddresses = new List<String>();
		if (system.label.environment == 'PROD')
			toAddresses.add(c.email);
		else{
			c.email = 'mark.moser@dllgroup.com';
			toAddresses.add(c.email);
		}
			
		mail.setToAddresses(toAddresses);
		
		mail.setOrgWideEmailAddressId(system.label.welcome_email);
		
		String signer = lease.contract_signer__c ;
		if (signer == null)
			signer = '';
		
		String dealer = lease.dealer_name__c;
		if (dealer == null)
			dealer = '';
			
		mail.setSubject(signer + ' - ' + dealer + ' Executed Lease & Welcome Package');
    	
    	List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
		for (Attachment a : attList){
   			Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
			efa.setFileName(a.Name);
  			efa.setBody(a.Body);
  			fileAttachments.add(efa);
		}
		
		Document d = [Select name
					,Body
					, BodyLength
					, contenttype
					From Document d 
					where id = :system.label.welcome_ins_doc
					];
		
		Messaging.Emailfileattachment efa2 = new Messaging.Emailfileattachment();
		efa2.setFileName(d.Name + '.pdf');
  		efa2.setBody(d.Body);
  		fileAttachments.add(efa2);
		
		mail.setHTMLBody(system.label.welcome_html_body);
		
		mail.setFileAttachments(fileAttachments);
		
    	NewCoUtility.deleteContact(contactMap);
    	
    	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	
    	System.debug('after email');
    }
    
    /*************************************************************************************************
    * 
    * future delete contact
    *
    *************************************************************************************************/
  
    public static void deleteContact(Map<ID,String> contactMap){
    	
    	Contact c = [select id from Contact where id in :contactMap.keySet()];
    	
    	delete c;
    		
    		
    }
    
    
    /*************************************************************************************************
    * 
    * future update invoice
    *
    *************************************************************************************************/
  	
    public static void updateInvoice(Map<ID,String> invoiceMap){
    
    	 
    	system.debug(invoiceMap);
    	List<clcommon__Consolidated_Invoice__c> invoiceList = new List<clcommon__Consolidated_Invoice__c>();
    	invoiceList = [select id from clcommon__Consolidated_Invoice__c where id in :invoiceMap.keySet()];
    	List<clcommon__Consolidated_Invoice__c> uInvoiceList = new list<clcommon__Consolidated_Invoice__c>();
    	
    	for (clcommon__Consolidated_Invoice__c i:invoiceList){
    		i.conga_url__c = invoiceMap.get(i.id);
    		
    		uInvoiceList.add(i); 
    	}
    	
       
    	if (!uInvoiceList.isEmpty()){
    		newCoUtility2.setAlreadyUpdated();
    		update uInvoiceList;	
    	}
    		
    }
    
    /*************************************************************************************************
    * 
    * Bridger Check 
    *
    *************************************************************************************************/
    @future(callout=true)
    public static void bridgerCheck(Map<ID,String> applicationMap){
    	
    	genesis__Applications__c app = new genesis__applications__c(); 
    	Bridger.bridgerInput input1 = new Bridger.bridgerInput();
    	Bridger.bridgerInput input2 = new Bridger.bridgerInput();
    	Boolean businessHit = false;
    	Boolean individualHit = false;
    	bridger.bridgerResult businessResult = new Bridger.bridgerResult();
    	bridger.bridgerResult IndividualResult = new Bridger.bridgerResult();
    	
    	try{
    	
    		app = [select genesis__account__r.name
    					,billing_address1__r.address_line_1__c
    					,billing_address1__r.address_line_2__c
    					,billing_address1__r.city__c
    					,billing_address1__r.county__c
    					,billing_address1__r.country__c
    					,billing_address1__r.zip_code__c
    					,billing_address1__r.state__c
    					,genesis__account__r.EIN__c
    					,contract_signer__c
    					,contract_signer_last_name__c
    					,contract_signer_title__c
    				from genesis__applications__c
    				where id in :applicationMap.keySet()
    				limit 1	
    		];
    		/* business */
    		input1.requestType = 'Business'; 
    		input1.street1 = app.billing_address1__r.address_line_1__c;
    		input1.street2 = app.billing_address1__r.address_line_2__c;
    		input1.city = app.billing_address1__r.city__c;
    		input1.stateprovincedistrict = app.billing_address1__r.state__c;
    		input1.postalcode = app.billing_address1__r.zip_code__c;
    		input1.addresstype = 'Current';
    		input1.county = app.billing_address1__r.county__c;
    		input1.fullname = app.genesis__account__r.name;
    		input1.ein = app.genesis__account__r.ein__c;  
    		 
    		system.debug('************ input1: ' + input1);
    		/* individual */
    		input2.requestType = 'Individual';
    		input2.title = app.Contract_Signer_Title__c;
    		input2.last = app.contract_signer_last_name__c;
    		input2.first = app.contract_signer__c;
    		system.debug('************ input2: ' + input2);
    		
    		
    		businessResult = bridger.bridgerSearch(input1,false);//business
    		individualResult = bridger.bridgerSearch(input2,false);//individual
    		
			NewCoUtility.skipApplicationTrigger = true;

    		if (businessResult.hit || individualResult.hit){
	   			app.genesis__Status__c = 'OFAC DECLINED';
    		}
    		else{
    			app.genesis__Status__c = 'OFAC APPROVED';
							
    		}
    	
    		update app;

    		
    	}
    	catch (Exception e){
    		system.debug('***** Exception: ' + e);
    		ofac_log__c o1 = new ofac_log__c();
    		o1.result__c = string.valueOf(e);
    		o1.application__c = app.id;
			insert o1;
			
			app.genesis__Status__c = 'OFAC FATAL';
    		NewCoUtility.skipApplicationTrigger = true;
    		update app;
			    		
    	}	
    	finally {
    		system.debug(app.billing_address1__r.address_line_1__c);
			List<OFAC_Log__c> oList = new List<OFAC_Log__c>();
			
			system.debug(input1);
			ofac_log__c o1 = new ofac_log__c();
    		o1.input__c = string.valueOf(input1);
    		o1.application__c = app.id;
    		o1.result__c =  businessResult.result;
    		olist.add(o1);
			
			system.debug(input2);
			ofac_log__c o2 = new ofac_log__c();
    		o2.input__c = string.valueOf(input2);
    		o2.result__c = individualResult.result;
    		o2.application__c = app.id;
    		oList.add(o2);
    		
			if (!olist.isEmpty())
				insert oList;
    	} 
    	
    }
  
	/*@future
	public static void updateContact(Map<String,String> contactTokenMap){

		Contact c = [select id from contact where id in :contactTokenMap.keyset()];

		c.pm_oauth_token__c = contactTokenMap.get(c.id);
        c.pm_oauth_token_expiration_date__c = date.today().adddays(6);

        update c;

	}
	*/
	
	@future
	public static void updateOauthToken(Map<String,String> tokenMap){

		List<PM_Oauth_Token__c> oaList = new List<PM_Oauth_Token__c>();
        oaList = [  select  pm_oauth_token__c
                        ,pm_oauth_token_expiration_date__c
                    from PM_Oauth_Token__c
                    where user__c in :tokenMap.keySet() 
                    ]; 

		if (oaList.size() == 0){
			PM_Oauth_Token__c o = new PM_Oauth_Token__c();
			o.pm_oauth_token__c = tokenMap.get(userInfo.getUserId());
        	o.pm_oauth_token_expiration_date__c = date.today().adddays(6);
			o.user__c = userInfo.getUserId();
			insert o;
		}
		else{
			PM_Oauth_Token__c o = oaList[0];
			o.pm_oauth_token__c = tokenMap.get(userInfo.getUserId());
        	o.pm_oauth_token_expiration_date__c = date.today().adddays(6);
			update o;
		}
		
	}
}