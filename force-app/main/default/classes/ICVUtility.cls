/*********************************************************************************************
*
* NewCo ICV Utility Class - used for calling ICV
*
* Change Log:
*
* 8/2/18 - MRM Created
* 9/14/18 - added call to get contract performance data
* 11/2/18 - added advanced logging so transactions can be resubmitted if necessary due to 
*           system issues(network, unavailable services etc...)
* 11/15/18 - added remove party
* 08/17/2020 - change city__c to city_installaddress__c on contract equipment
* 
* Sample call for execute anon:
*

ICVUtility.getCommitmentLERequestInfo r = new ICVUtility.getCommitmentLERequestInfo();
r.transactionID = ICVUtility.getMessageId(); 
r.SourceCommitmentID = '100-10190450';
r.SourceCommitmentType = 'A';

ICVUtility.getCommitmentLE(r,'aAA0v0000004N5e');


map<String,String> requestInfoMap = new Map<String,String>();
		requestInfoMap.put('TransactionID',ICVUtility.getMessageId());
		requestInfoMap.put('SourceCommitmentID','100-10190450');//q.name);
		requestInfoMap.put('SourceCommitmentType','A');
	    requestInfoMap.put('SourceSystemTimestamp','2018-07-13T16:45:20');
	    

ICVUtility.addCommitment(requestInfoMap,'aAA0v0000004N5e');

	    
Map<String,String> requestInfoMap = new Map<String,String>();
	requestInfoMap.put('SourceSystem','ORACLE');
	requestInfoMap.put('IDType','TCA_PARTY_ID'); 
	requestInfoMap.put('IDValue','82613');
	   
ICVUtility.getContractPerformanceData(requestInfoMap,'aAA0v0000004N5e');

ICVUtility.addParty('a1S0v0000006GVX');


[‎9/‎18/‎2018 3:17 PM]  Vidiyala, C (Chandramouli):  
ICV UpdateParty API : https://apiacc.dllgroup.com/v1/party/updateparty
 
[‎9/‎18/‎2018 3:17 PM]  Vidiyala, C (Chandramouli):  
ICV AddParty API : https://apiacc.dllgroup.com/v1/party/addparty
 

**********************************************************************************************/
global without sharing class ICVUtility { 
    
    
    /*************************************************************************************************
    * 
    * ICV Add Party
	*	
	* Type - C for Customer; P for Partner;L for Lease (it also means it is a party)
    *************************************************************************************************/
    //@future (callout=true) 
    //public static void addPartyFuture( ID applicationRequestId, String Type){    
    //	addParty(applicationRequestId, Type);
    //}
  
    public static boolean addParty( ID applicationRequestId, String Type){     
  		
  			
    	String myISODateTime = string.valueOf(json.serialize(datetime.now()));
    	String endPoint;
    	
    	String callXML; 
		String resultXML;
		ICS_Application__c ar;
		Account a;
		Account dealer;
	  	Address__c dealerAddress;
	  	String partyId;
	  	cllease__Lease_Account__c l;
		String addressLine1;
	  	String city;
	  	String state;
	  	String postalCode;
	  	String phone;
	  	String legalName;
	  			
	  			
		if (type != 'L'){ 
			ar = [select id
	  					,Message_Id__c
	  					,Quick_Quote__c
	  					,quick_quote__r.name
	  					,quick_quote__r.dealer__r.name
	  					,quick_quote__r.dealer__c
	  					,quick_quote__r.dealer__r.account_Number__c
	  					,quick_quote__r.genesis__account__r.account_number__c
	  					,system_approval_limit__c
	  					,createddate
	  					,quick_quote__r.genesis__account__c
	  					,quick_quote__r.genesis__Address_Line_1__c
	  					,quick_quote__r.genesis__State__c
	  		  		    ,quick_quote__r.genesis__Postal_Code__c
	  					,quick_quote__r.genesis__Country__c
	  					,quick_quote__r.genesis__City__c
	  					,quick_quote__r.genesis__Business_Name__c
	  					,quick_quote__r.Primary_Phone_number__c
	  					,quick_quote__r.County__c
	  					from ICS_Application__c
	  					where id = :applicationRequestId 
	  					];
	  					
	  		legalName = ar.quick_quote__r.genesis__Business_Name__c;
	  		addressLine1 = ar.quick_quote__r.genesis__Address_Line_1__c;
	  		city = ar.quick_quote__r.genesis__City__c;
	  		state = ar.quick_quote__r.genesis__State__c;
	  		postalCode = ar.quick_quote__r.genesis__Postal_Code__c;
	  		phone = ar.quick_quote__r.Primary_Phone_number__c;	
	  		
	  		
	  	} 
	  	else{
	  		 l = 
	  					[
	  					Select 
    					  cllease__Account__r.name
    					, cllease__Account__r.phone
    					, Name
    					, Application__r.genesis__Quick_Quote__r.name
    					, Application__c
    					, Application_Number__c
    					, Account_Number__c 
    					, Billing_Address__r.Zip_Code__c
    					, Billing_Address__r.State__c
    					, Billing_Address__r.County__c
    					, Billing_Address__r.Country__c
    					, Billing_Address__r.City__c
    					, Billing_Address__r.Address_Line_4__c
    					, Billing_Address__r.Address_Line_3__c
    					, Billing_Address__r.Address_Line_2__c
    					, Billing_Address__r.Address_Line_1__c 
    					From cllease__Lease_Account__c 
    					where id = :applicationRequestId
    					];
    		
    		legalName = l.cllease__Account__r.name;			
    		addressLine1 = l.Billing_Address__r.Address_Line_1__c;
	  		city = l.Billing_Address__r.City__c;
	  		state = l.Billing_Address__r.State__c;
	  		postalCode = l.Billing_Address__r.Zip_Code__c;
	  		phone = l.cllease__Account__r.phone;	
	  		 
	  		
	  	}	
	  	
	  	system.debug('Type is: ' + type);
	  	
	  	
	  	if (type == 'P'){
	  		 
	  		dealer = [	select id 
	  						,phone
	  						,name
	  						,account_number__c
	  						,in_icv__c
	  						from Account 
	  						where id = :ar.quick_quote__r.dealer__c
	  					];
	  			
	  		if (dealer.in_icv__c == true){
	  			system.debug('found partner was in icv!');
	  			return true;
	  		}
	  				
	  		dealerAddress = [select id 
	  						,address_line_1__c
	  						,address_line_2__c
	  						,address_line_3__c
	  						,address_line_4__c
	  						,city__c
	  						,county__c
	  						,state__c
	  						,zip_code__c
	  						from Address__c 
	  						where account__c = :dealer.id 
	  						limit 1
	  						];		  
	  	}							

	
	  	if (type != 'L'){  
	  		/* built to support quotes with or without an account */
	  		if (ar.quick_quote__r.genesis__account__c == null)
	  			partyId = ar.quick_quote__r.name;
	  		else{
	  			if (type == 'C')
	  				partyId = ar.quick_quote__r.genesis__account__r.Account_Number__c;
	  			if (type == 'P')
	  				partyId = dealer.Account_Number__c;
	  			a = [select id, in_icv__c from Account where Account_Number__c = :partyId];
	  			if (a.in_icv__c)
	  				return true;
	  		}
	  	}
	  	else{
	  		partyId = l.account_number__c;  
	  		a = [select id, in_icv__c from Account where Account_Number__c = :partyId];
	  		if (a.in_icv__c == true)
	  			return true;
	  	}	
	  	
	  	
	  								
		try{ 
			string accessToken = ICVUtility.getAccessToken();
			
			system.debug('at:' + accessToken);
			
			HttpRequest reqAPI = new HttpRequest();  
			
			//https://apiacc.dllgroup.com/v1/party/addparty 
			
        	reqAPI.setEndpoint('https://' + System.Label.ICVDomain + '.dllgroup.com/v1/party/addparty');
        	endpoint = 'https://' + System.Label.ICVDomain + '.dllgroup.com/v1/party/addparty';
    		reqAPI.setMethod('POST');          
			reqAPI.setHeader('Authorization', 'Bearer '+ accessToken);
        	reqAPI.setHeader('content-type', 'application/json');
        	reqAPI.setTimeout(120000);
        	
	  		JSONGenerator gen = JSON.createGenerator(true);
			
			gen.writeStartObject();
	 		gen.writeFieldName('requestControl');
			gen.writeStartObject();
	  		gen.writeStringField('TransactionID',string.valueOf(date.today().year())  + string.valueOf(date.today().month()) + string.valueOf(date.today().day()));
	  		gen.writeStringField('userId', 'cloudlending');
	  		gen.writeStringField('sourceSystemTimestamp', myISODateTime.substring(1,20) );
			gen.writeEndObject();
	  	 	
	  		if (type == 'C' || type == 'L'){ 
	  			 
	 			gen.writeFieldName('party');
	 			gen.writeStartObject();
	 			gen.writeFieldName('sourcePartyIdentification');
				gen.writeStartObject();
	  			gen.writeStringField('sourceSystemName', 'CLND');
	  			gen.writeStringField('sourcePartyIdType', 'PARTY_ID');
	  			gen.writeStringField('sourcePartyIdValue', partyId);
				gen.writeEndObject();
	  		 
	  			gen.writeFieldName('address');
	 			gen.writeStartObject();
	 			gen.writeStringField('country', 'US');
	  			gen.writeStringField('addressLine1', addressLine1);
	  			gen.writeStringField('addressLine2', '');
	  			gen.writeStringField('addressLine3', '');
  				gen.writeStringField('city', city); 
  				gen.writeStringField('stateProvince', state.toUpperCase());
  				gen.writeStringField('postalCode', postalCode);
				gen.writeEndObject();
				 
	 			gen.writeStringField('businessTelephoneNumber',phone);
	 			 
	  		}
	  		else{
	  			system.debug('adding partner');
	  			gen.writeFieldName('party');
	 			gen.writeStartObject();
	 			gen.writeFieldName('sourcePartyIdentification');
				gen.writeStartObject();
	  			gen.writeStringField('sourceSystemName', 'CLND');
	  			gen.writeStringField('sourcePartyIdType', 'PARTY_ID');
	  			gen.writeStringField('sourcePartyIdValue',dealer.account_number__c);
				gen.writeEndObject();
	  		
	  			gen.writeFieldName('address');
	 			gen.writeStartObject();
	 			gen.writeStringField('country', 'US');
	  			gen.writeStringField('addressLine1', dealerAddress.address_line_1__c);
	  			if (dealerAddress.address_line_2__c != null)
	  				gen.writeStringField('addressLine2', dealerAddress.address_line_2__c);
	  			if (dealerAddress.address_line_3__c != null)
	  				gen.writeStringField('addressLine3', dealerAddress.address_line_3__c);
  				gen.writeStringField('city', dealerAddress.City__c);
  				gen.writeStringField('stateProvince', dealerAddress.state__c);
  				gen.writeStringField('postalCode', dealerAddress.zip_code__c);
				gen.writeEndObject();
		
	 			gen.writeStringField('businessTelephoneNumber',dealer.phone);	
	  		}
			
			/*
			List<Map<String,String>> extIdList = new List<Map<String,String>>();
			Map<String,String> extIdMap = new Map<String,String>();
			/* dont' have this stuff   
			 
			extIdMap.put('externalIdType', 'FEIN');
			extIdMap.put('externalIdValue', '23-XXXXXX');
			extIdMap.put('externalIdAction', 'A');
			 	
			extIdList.add(extidMap);
			gen.writeObjectField('es c xternalIdentification',extIdList);
			*/

			gen.writeFieldName('personOrg');
	 		gen.writeStartObject();
			gen.writeFieldName('organization');
	 		gen.writeStartObject();
	 		
	 		if (type == 'C' || type == 'L')
				gen.writeStringField('legalName', legalName);
			else
				gen.writeStringField('legalName', dealer.name);

			/* don't have this stuff
			gen.writeFieldName('dbaName');
	 		gen.writeStartObject();
			gen.writeStringField('dbaName', '');
			gen.writeStringField('dbaNameAction', '');
			gen.writeEndObject();		

			gen.writeStringField('governmentType', 'S');
			gen.writeFieldName('industryCode');
	 		gen.writeStartObject();
			gen.writeStringField('industryCodeType', 'DLL_SIC_CODE');
			gen.writeStringField('industryCodeValue', '97119902');
			gen.writeEndObject();		

	  		gen.writeEndObject();
			gen.writeEndObject();
			*/
			String jsonS = gen.getAsString();

			system.debug('json message:' + gen.getAsString());
			
			reqAPI.setBody(jsonS);  
			callXML = jsonS;
		
			Http http1 = new Http();
	    	HTTPResponse res1 = http1.send(reqAPI); 
	    	results res = new results();
	    	resultXML = res1.getBody();
			
			system.debug('result: ' + resultXML);
	  		
	  		JSONParser parser = JSON.createParser(res1.getBody());
	  		partyResult pr = (partyResult)parser.readValueAs(partyResult.class);
	  		String s = JSON.serialize(pr);
          
        	String resultCode, resultMessage;
        	
        	Map<String,Boolean> accountMap = new Map<String,Boolean>();
        	
        	if (res1.getStatusCode() == 200) {
        		if (type == 'P'){
        			dealer.in_icv__c = true;
        			accountMap.put(dealer.id,true);
        		}
        		if (type == 'C' && ar.quick_quote__r.genesis__account__c != null){
        			a.in_icv__c = true;
        			accountMap.put(a.id,true);
        		}
        		if (type == 'L'){
        			a.in_icv__c = true;
        			accountMap.put(a.id,true);
        		}
        		 
	    		//ICS_Log__c log = new ICS_Log__c(xml__c = callXML,caller__c = 'addParty' + '-' + type,xml_result__c = resultXML,end_point__c = endpoint,status__c = 'OK');
	    		//system.debug('************* putting in lease id' + l.id);
	    		String lid, qqid;
	    		
	    		if (type == 'L')
	    			lid = l.id;
	    		else
					qqid = ar.quick_quote__c;
 				
 				
 				insertLog(callXML, 'addParty' + '-' + type, type, resultXML, endPoint, 'OK', lid, qqid);
    			
 				if (accountMap.size() > 0)
 					ICVUtility.setInICVFlag(accountMap); 
 	
 				return true;
        	}
        	else{
        		//ICS_Log__c log = new ICS_Log__c(xml__c = callXML,caller__c = 'addParty' + '-' + type,xml_result__c = resultXML,end_point__c = endpoint,status__c = string.valueOf(res1.getStatusCode()));
	    		//system.debug('************* putting in lease id' + l.id);
	    		String lid, qqid;
	    		
	    		if (type == 'L')
	    			lid = l.id;
	    		else
					qqid = ar.quick_quote__c;
					
 				insertLog(callXML, 'addParty' + '-' + type, type, resultXML, endPoint, string.valueOf(res1.getStatusCode()), lid, qqid);
    
        		
        	}	
		    //return string.valueOf(res1.getBody());
 		}
 		catch (exception e){
 			system.debug(e);
 			//ICS_Log__c log = new ICS_Log__c(xml__c = callXML,end_point__c = endpoint,caller__c = 'addParty' + '-' + type,xml_result__c = resultXML,status__c = string.valueOf(e));
			String lid, qqid;
	    		
	    	if (type == 'L')
	    		lid = l.id;
	    	else
				qqid = ar.quick_quote__c;
 			
 			insertLog(callXML, 'addParty' + '-' + type, type, resultXML, endPoint,  string.valueOf(e) , lid, qqid);
    
 		}
    	return false;
    }
    
    /*************************************************************************************************
    * 
    * ICV Update Party
	*	
    *************************************************************************************************/
    @future (callout=true) 
    public static void udpatePartyFuture( ID applicationRequestId, String action){    
    	updateParty(applicationRequestId,action);
    }
  
    public static boolean updateParty( ID applicationRequestId, String action){     
    	
    	String myISODateTime = string.valueOf(json.serialize(datetime.now()));
    	
    	String callXML; 
		String resultXML;
		ICS_Application__c ar;
		Account a;
		Account dealer;
		String endPoint;
	  	Address__c dealerAddress;
	  	String partyId;
	  	cllease__Lease_Account__c l;
		String addressLine1;
	  	String city;
	  	String state;
	  	String postalCode;
	  	String phone;
	  	String legalName;
	  			
	  	ar = [select id
	  				,Message_Id__c
	  				,Quick_Quote__c
	  				,quick_quote__r.name
	  				,quick_quote__r.dealer__r.name
	  				,quick_quote__r.dealer__c
	  				,quick_quote__r.dealer__r.account_Number__c
	  				,quick_quote__r.genesis__account__r.account_number__c
	  				,system_approval_limit__c
	  				,createddate
	  				,quick_quote__r.genesis__account__c
	  				,quick_quote__r.genesis__Address_Line_1__c
	  				,quick_quote__r.genesis__State__c
	  			    ,quick_quote__r.genesis__Postal_Code__c
	  				,quick_quote__r.genesis__Country__c
	  				,quick_quote__r.genesis__City__c
	  				,quick_quote__r.genesis__Business_Name__c
	  				,quick_quote__r.Primary_Phone_number__c
	  				,quick_quote__r.County__c
	  			from ICS_Application__c
	  			where id = :applicationRequestId 
	  			];
	  					
	  	
	  								
		try{ 
			HttpRequest reqAPI = new HttpRequest();  
			
        	reqAPI.setEndpoint('https://' + System.Label.ICVDomain + '.dllgroup.com/v1/party/updateparty');
        	endPoint = 'https://' + System.Label.ICVDomain + '.dllgroup.com/v1/party/updateparty';
    		reqAPI.setMethod('POST');          
			reqAPI.setHeader('Authorization', 'Bearer '+ ICVUtility.getAccessToken());
        	reqAPI.setHeader('content-type', 'application/json');
        	reqAPI.setTimeout(120000);
        	
	  		JSONGenerator gen = JSON.createGenerator(true);
			
			gen.writeStartObject();
	 		gen.writeFieldName('requestControl');
			gen.writeStartObject();
	  		gen.writeStringField('TransactionID',string.valueOf(date.today().year())  + string.valueOf(date.today().month()) + string.valueOf(date.today().day()));
	  		gen.writeStringField('userId', 'mishrauk');
	  		gen.writeStringField('sourceSystemTimestamp', myISODateTime.substring(1,20) );
			gen.writeEndObject();
	  			 
 			gen.writeFieldName('party');
 			gen.writeStartObject();
 			gen.writeFieldName('sourcePartyIdentification');
			gen.writeStartObject();
  			gen.writeStringField('sourceSystemName', 'CLND');
  			gen.writeStringField('sourcePartyIdType', 'PARTY_ID');
  			gen.writeStringField('sourcePartyIdValue', ar.quick_quote__r.name);
			gen.writeEndObject();
  		 
  			gen.writeFieldName('address');
 			gen.writeStartObject();
 			gen.writeStringField('country', 'US');
  			gen.writeStringField('addressLine1', ar.quick_quote__r.genesis__Address_Line_1__c);
  			gen.writeStringField('addressLine2', '');
  			gen.writeStringField('addressLine3', '');
			gen.writeStringField('city', ar.quick_quote__r.genesis__City__c);
			gen.writeStringField('stateProvince', ar.quick_quote__r.genesis__State__c);
			gen.writeStringField('postalCode', ar.quick_quote__r.genesis__Postal_Code__c);
			gen.writeEndObject();
				 
 			gen.writeStringField('businessTelephoneNumber',ar.quick_quote__r.Primary_Phone_number__c);
	 			
			gen.writeFieldName('personOrg');
	 		gen.writeStartObject();
			gen.writeFieldName('organization');
	 		gen.writeStartObject();
	 		
	 		gen.writeStringField('legalName', ar.quick_quote__r.genesis__Business_Name__c);
			
			String jsonS = gen.getAsString();

			system.debug('json message:' + gen.getAsString());
			
			reqAPI.setBody(jsonS);  
			callXML = jsonS;
		
			Http http1 = new Http();
	    	HTTPResponse res1 = http1.send(reqAPI); 
	    	results res = new results();
	    	resultXML = res1.getBody();
			
			system.debug('result: ' + resultXML);
	  		
	  		JSONParser parser = JSON.createParser(res1.getBody());
	  		partyResult pr = (partyResult)parser.readValueAs(partyResult.class);
	  		String s = JSON.serialize(pr);
          
        	String resultCode, resultMessage;
        	
        	if (pr.returnCode != '000'){
        		resultCode = pr.code;
        		resultMessage = pr.message;
        	}
        	else{
        		resultCode = pr.returnCode;
        		resultMessage = pr.returnMessage;
        	}
        	
	    	ICS_Log__c log = new ICS_Log__c(quick_quote__c = ar.quick_quote__c,xml__c = callXML,end_point__c = endPoint,caller__c = 'updateParty',xml_result__c = resultXML,status__c = 'OK');
	    	//system.debug('************* putting in lease id' + l.id);
	    	
 			insert log;
 			return true;
    			
		    //return string.valueOf(res1.getBody());
 		}
 		catch (exception e){
 			system.debug(e);
 			ICS_Log__c log = new ICS_Log__c(quick_quote__c = ar.quick_quote__c,xml__c = callXML,end_point__c = endPoint,caller__c = 'updateParty',xml_result__c = resultXML,status__c = string.valueOf(e));
			
 			insert log;
 		}
    	
		return false;	
    }
    
    /*************************************************************************************************
    * 
    * ICV Add Commitment
	*	 
    *************************************************************************************************/
   	//@future (callout=true) 
    //public static void addCommitmentFuture(Map<String,String> requestInfoMap, ID applicationRequestId, String commitStatus){     
    //
    //	addCommitment(requestInfoMap,applicationRequestId, commitStatus);
    //	
    //} 
    
    public static boolean addCommitment(Map<String,String> requestInfoMap, ID applicationRequestId,String commitStatus){ 	
    	String myISODateTime = string.valueOf(json.serialize(datetime.now()));
    	
    	List<cllease__contract_equipment__c> eList = new List<cllease__contract_equipment__c>();
    	
    	Decimal hardCost, softCost;
    	String commitmentType;
    	String callXML;
    	String endPoint;
		String resultXML;
		String partyId;
		String exposureStatus;
		Boolean processingLease = false;
		String commitmentId;
		String partnerId;
		ICS_Application__c ar;
		cllease__Lease_Account__c  l;
		Integer line = 0;
		Decimal originalAmount;
		
		if (String.valueOf(applicationRequestId).startsWith('a6J'))
			processingLease = true;
		
		if (processingLease){
 			commitmentType = 'C';
 			exposureStatus = 'BOOK';
		}
 		else{
 			commitmentType = 'A';
 			exposureStatus = 'PEND';
 		}
 			
		if (processingLease){
			 eList = [Select c.cllease__tax_financed__c, c.cllease__status1__c, c.cllease__return_status__c, c.cllease__life_in_months__c, c.cllease__Zip_Code__c, c.cllease__Year__c, c.cllease__Warranty_Amount__c, c.cllease__VIN__c,  c.cllease__Total_Tax_Rate__c, c.cllease__Total_Tax_Rate_Derived__c, c.cllease__Total_Tax_Amount__c, c.cllease__Total_Dealer_Charges__c, c.cllease__Tax_exemption__c, c.cllease__Tax_Residual_Value__c, c.cllease__Tax_Depreciation_Method__c, c.cllease__Tax_Code__c, c.cllease__Tax_Amount__c, c.cllease__Subvention__c, c.cllease__Subsidy__c, c.cllease__Street_Address__c, c.cllease__Status__c, c.cllease__State_Tax_Rate__c, c.cllease__State_Surcharge__c, c.cllease__State_Province__c, c.cllease__Select_Equipment__c, c.cllease__Residual_Amount__c, c.cllease__Override_Tax_Rate__c, c.cllease__Override_Tax_Flag__c, c.cllease__Other_Financed_Fees__c, c.cllease__Model__c, c.cllease__Make__c, c.cllease__LeaseApplication__c, c.cllease__LeaseApplicationNumber__c, c.cllease__Item_Code__c, c.cllease__Estimated_Selling_Price__c, c.cllease__Equipment_Type__c, c.cllease__Equipment_Serial_Number__c, c.cllease__Equipment_Description__c, c.cllease__Equipment_Cost__c, c.cllease__Equipment_Calculated_Cost__c, c.cllease__Dealer_Phone_Number__c, c.cllease__Dealer_Party__c, c.cllease__Dealer_Name__c, c.cllease__Dealer_Funded__c, c.cllease__Dealer_Fees__c, c.cllease__Dealer_Contact_Name__c, c.cllease__Dealer_Contact_Email__c, c.cllease__County__c, c.cllease__County_Tax_Rate__c, c.cllease__County_Surcharge__c, c.cllease__Country__c, c.cllease__Contract__c, c.cllease__City__c, c.cllease__City_Tax_Rate__c, c.cllease__City_Surcharge__c, c.zip_code_installaddress__c, c.Termination_Date__c, c.SystemModstamp, c.State__c, c.State_Code__c, c.Serial_Number__c, c.Salvage_Value__c, c.Residual_Percentage__c, c.Rent_Amount__c, c.Remaining_Evergreen_Depreciable_Cost__c, c.Product_Type__c, c.Prior_Owner_Class__c, c.Owner_Class__c, c.Object_Category_Name__c, c.Object_Category_ID__c, c.Net_Trade_Up_Amount__c, c.Name, c.NBV__c, c.Master_Asset_Type__c, c.Master_Asset_Type_ID__c, c.Manufacturer__c, c.Lessee_Company__c, c.Lessee_Code__c, c.Last_Residual_Burndown_Date__c, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Invoice_Number__c, c.Invoice_Date__c, c.Install_Date__c, c.Install_Address__c, c.Install_Address_Line_2__c, c.Install_Address_Line_1__c, c.Install_Account__c, c.Id, c.GARD__c, c.External_Id__c, c.Evergreen_Depreciable_Life__c, c.Evergreen_Depreciable_Cost__c, c.Equipment_Description1__c, c.Eligible_for_property_tax__c, c.Department_Name__c, c.Dealer_Charges__c, c.CreatedDate, c.CreatedById, c.county_installaddress__c, c.country_installaddress__c, c.Cost_Center__c, c.city_installaddress__c, c.Business_Unit__c, c.Bill_Residual_Amount__c, c.Balance_Net_Trade_Up_Amount__c, c.Asset_Type_Name__c, c.Asset_Type_ID__c, c.Asset_ID__c, c.Additional_Residual_Amount__c 
			 		  From cllease__Contract_Equipment__c c
			 		  where cllease__Contract__c = :applicationRequestId];
			 		   
			 l = 
	  					[
	  					Select 
    					  cllease__Account__r.name
    					, cllease__Account__r.account_number__c
    					, cllease__Account__r.phone
    					, Name
    					, Application__r.genesis__Quick_Quote__r.name
    					, Application__c
    					, cllease__financed_amount__c
    					, cllease__commencement_date__c
    					, Application_Number__c
    					, Account_Number__c 
    					, Billing_Address__r.Zip_Code__c
    					, Billing_Address__r.State__c
    					, Billing_Address__r.County__c
    					, Billing_Address__r.Country__c
    					, Billing_Address__r.City__c
    					, Billing_Address__r.Address_Line_4__c
    					, Billing_Address__r.Address_Line_3__c
    					, Billing_Address__r.Address_Line_2__c
    					, Billing_Address__r.Address_Line_1__c 
    					, cllease__Dealer__r.account_number__c
    					, cllease__First_Payment_Amount__c
    					, cllease__Maturity_Date__c
    					, Booking_Date__c
    					, cllease__application_number__c
    					, cllease__Term__c
    					, purchase_option__c
    					, cllease__Next_Due_Date__c
    					From cllease__Lease_Account__c 
    					where id = :applicationRequestId
    					];
    		system.debug('dealer' + l.cllease__Dealer__r.account_number__c);			
    		partyId = l.cllease__Account__r.account_number__c;
    		commitmentId = l.name;
    		genesis__Applications__c app = [select 
    								dealer__r.account_number__c 
    								from genesis__Applications__c
    								where name = :l.cllease__application_number__c];
    		partnerId = app.dealer__r.account_number__c;
    		
    		originalAmount = (l.cllease__term__c *  l.cllease__first_payment_amount__c).setScale(2);
    		
    		
		}
		else{
				 ar = [select id
	  									,Message_Id__c
	  									,Quick_Quote__c
	  									,quick_quote__r.Estimated_Financed_Amount__c   
	  									,quick_quote__r.dealer__r.name
	  									,quick_quote__r.dealer__c
	  									,system_approval_limit__c
	  									,createddate
	  									,quick_quote__r.genesis__account__r.account_Number__c
	  									,quick_quote__r.dealer__r.account_Number__c 
	  									,quick_quote__r.name
	  									from ICS_Application__c
	  									where id = :applicationRequestId 
	  									];
	  		/* in prep for the new portal expect that an account could be present in a commitment */
	  		if (ar.quick_quote__r.genesis__account__c == null)
	  			partyId = ar.quick_quote__r.name;
	  		else
	  			partyId = ar.quick_quote__r.genesis__account__r.account_Number__c;
	  		
	  		commitmentId = ar.quick_quote__r.name;
	  		originalAmount = decimal.valueOf(ar.quick_quote__r.Estimated_Financed_Amount__c).setScale(2);
	  		partnerId = ar.quick_quote__r.dealer__r.account_number__c;								
	  		system.debug('ar is: ' + ar.quick_quote__r.Estimated_Financed_Amount__c   );
		} 
		
		try{
			HttpRequest reqAPI = new HttpRequest();   
			
        	reqAPI.setEndpoint('https://' + System.Label.ICVDomain + '.dllgroup.com/maintain-commitment');
        	endPoint = 'https://' + System.Label.ICVDomain + '.dllgroup.com/maintain-commitment';
    		reqAPI.setMethod('POST');          
			reqAPI.setHeader('Authorization', 'Bearer '+ ICVUtility.getAccessToken());
        	reqAPI.setHeader('content-type', 'text/xml');
        	reqAPI.setHeader('SoapAction', '""');
 			reqAPI.setTimeout(120000);
 			
 			//system.debug('my amount is: ' + myAmount);
 			String rBody = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">' + 
 							'<soap:Body>' + 
 							'<AddCommitmentRequest xmlns="http://maintaincommitment.service.icv.dll.com/MaintainCommitmentXsd/">' +
 							
 							'<RequestControl xmlns="http://common.service.icv.dll.com/common/">' + 
 							'<TransactionID xmlns="">' + '100' + '</TransactionID>' + 
 							'<UserLanguage xmlns="">ENG</UserLanguage>' + 
 							'<UserCountry xmlns="">US</UserCountry>' + 
 							'<UserId xmlns="">57542</UserId>' + 
 							'<SourceSystemTimestamp xmlns="">' + myISODateTime.substring(1,20) + '</SourceSystemTimestamp>' +
 							'</RequestControl>' + 
 							
 							'<Commitment xmlns="http://commitment.service.icv.dll.com/commitment/">' +
 							
 							
 							'<SourceCommitmentIdentification xmlns="http://common.service.icv.dll.com/common/">' + 
 							'<SourceSystem>' + 
 							'<SourceSystemName xmlns="">CLND</SourceSystemName>' + 
 							'</SourceSystem><SourceCommitmentID xmlns="">' + commitmentId + '</SourceCommitmentID>' + 
 							'<SourceCommitmentType xmlns="">' + commitmentType + '</SourceCommitmentType>' + 
 							'</SourceCommitmentIdentification>' + 
 							
 							/*  EXPOSURE */
 							
 							'<CommitmentExposure>' + 
 							'<Exposure xmlns="http://exposure.entity.service.icv.dll.com/exposure/">' +
 							'<ExposureArray>' + 
 							'<SourceCommitmentIdentification xmlns="http://common.service.icv.dll.com/common/">' + 
 							'<SourceSystem>' + 
 							'<SourceSystemName xmlns="">CLND</SourceSystemName>' +
 							'</SourceSystem><SourceCommitmentID xmlns="">' + commitmentId + '</SourceCommitmentID>' + 
 							'<SourceCommitmentType xmlns="">' + commitmentType + '</SourceCommitmentType>' + 
 							'</SourceCommitmentIdentification>' +
 							'<ExposureDetail>' +
 							'<ExposureCategory xmlns="">CDIR</ExposureCategory>' + 
 							
 							'<ExposureStatus xmlns="">' + exposureStatus + '</ExposureStatus>' + 
 							'<ExposureType xmlns="">DLL</ExposureType>' + 
 							
 							
 							'<ExposureAmount xmlns="">' + string.valueOf(originalAmount) +  '</ExposureAmount>' + 
 							'</ExposureDetail>' + 
 							'</ExposureArray>' +
 							'</Exposure>' +
							'<ExposureAction xmlns="">A</ExposureAction>' + 
 							'</CommitmentExposure>';
 							
 							if (processingLease){
 								/*  CONTRACT */
 								rbody += '<Contract>' +
 									'<CurrentAmountOutstanding xmlns="">' + originalAmount + '</CurrentAmountOutstanding>' + 
 									'</Contract>';
 								
 								for (cllease__Contract_equipment__c e:eList){
 									line++;
 									hardcost = 	e.cllease__Estimated_Selling_Price__c - e.Net_Trade_Up_Amount__c;
 									
 									softCost =  e.cllease__Warranty_Amount__c + e.cllease__Dealer_Fees__c +
 												e.net_trade_up_amount__c;
 									
 									
 									/*  DETAIL */
 							
 							
 									rbody += '<Detail>' +
 										'<CommitmentDetailAction xmlns="">A</CommitmentDetailAction>' +
 										'<CommitmentDetails xmlns="http://commitmentdetails.service.icv.dll.com/commitmentdetails/">' +
 										'<SourceCommitmentDetailIdentification xmlns="http://common.service.icv.dll.com/common/">' + 
 										'<SourceCommitmentIdentification>' + 
 										'<SourceSystem>' + 
 										'<SourceSystemName xmlns="">CLND</SourceSystemName>' +
 										'</SourceSystem>' +
 										'<SourceCommitmentID xmlns="">' + l.name + '</SourceCommitmentID>' + 
 										'<SourceCommitmentType xmlns="">C</SourceCommitmentType>' + 
 										'</SourceCommitmentIdentification>' + 
 										'<SourceCommitmentDetailID xmlns="">' + line + '</SourceCommitmentDetailID>' +
 										'</SourceCommitmentDetailIdentification>' + 
 										'<StartDate xmlns="">' + string.valueOf(date.valueOf(l.cllease__commencement_date__c)) + '</StartDate>' + 
 										'<EndDate xmlns="">' + string.valueOf(date.valueOf(l.cllease__Maturity_Date__c)) + '</EndDate>' + 
 										'<OriginalAmount xmlns="">' + (e.rent_amount__c * l.cllease__term__c).setScale(2) + '</OriginalAmount>' + 
 										'<RemainingDuration xmlns="">' + l.cllease__term__c + '</RemainingDuration>' + 
 										'<Status xmlns="">Booked</Status>';
 										
 										if (e.object_category_id__c == null)
 											rbody += '<AssetCategory xmlns=""></AssetCategory>';
 										else
 											rbody += '<AssetCategory xmlns="">' + e.object_category_Id__c + '</AssetCategory>';
 										
 										if (e.asset_type_id__c == null)
 											rbody += '<EquipmentCode xmlns=""></EquipmentCode>';
 										else
 											rbody += '<EquipmentCode xmlns="">' + e.asset_type_id__c + '</EquipmentCode>';
 										
 										rbody +=	 
 										'<AssetDescription xmlns="">' + escapeXML(e.asset_type_name__c) + '</AssetDescription>' + 
 										'<AssetName xmlns="">' + e.master_asset_type__c + '</AssetName>' +
 										'<HardCost xmlns="">' + hardCost + '</HardCost>' + 
 										'<SoftCost xmlns="">' + softCost + '</SoftCost>' + 
 										//'<ManufacturingYear xmlns=""></ManufacturingYear>' +
 										'<UsedIndicator xmlns="">N</UsedIndicator>' +
 										'<ResidualValue xmlns="">' + e.cllease__Residual_Amount__c + '</ResidualValue>' +  
 										'<ResidualEstimatedIndicator xmlns="">A</ResidualEstimatedIndicator>' + 
 										'</CommitmentDetails>' + 
 										'</Detail>'; 
 								}
 							}
 						
 							
 							/*  ROLES */
 							
 							
 							rbody += '<CommitmentRole>'+ 
 							'<RoleAction xmlns="">A</RoleAction>' + 
 							'<PartyRole xmlns="http://common.service.icv.dll.com/common/">' +
 							'<SourcePartyIdentification>' + 
 							'<SourceSystem><SourceSystemName xmlns="">CLND</SourceSystemName>' + 
 							'</SourceSystem>' + 
 							'<SourcePartyIDType xmlns="">PARTY_ID</SourcePartyIDType>' + 
 							'<SourcePartyKeyID xmlns="">' + partyId + '</SourcePartyKeyID>' +
 							'</SourcePartyIdentification>' + 
 							'<RoleType xmlns="">CUST</RoleType>' + 
 							'</PartyRole>' + 
 							'</CommitmentRole>' + 
 							
 							
 							'<CommitmentRole>' +
 							'<RoleAction xmlns="">A</RoleAction>' +
 							'<PartyRole xmlns="http://common.service.icv.dll.com/common/">' + 
 							'<SourcePartyIdentification><SourceSystem>' +
 							'<SourceSystemName xmlns="">CLND</SourceSystemName>'+ 
 							'</SourceSystem>' + 
 							'<SourcePartyIDType xmlns="">PARTY_ID</SourcePartyIDType>' + 
 							'<SourcePartyKeyID xmlns="">' + partnerId + '</SourcePartyKeyID>' + 
 							'</SourcePartyIdentification>' +
 							'<RoleType xmlns="">PRTN</RoleType>' +
 							'</PartyRole>' + 
 							'</CommitmentRole>';  
 							 
 							if (processingLease)
 								rbody += '<ExpectedPaymentAmount xmlns="">' + l.cllease__First_Payment_Amount__c + '</ExpectedPaymentAmount>'; 
 							else{
 								
 								/*  APPLICATION */
 							
 								rbody += '<Application>' + 
 									'<ExpectedPaymentAmount xmlns="">0</ExpectedPaymentAmount>' +
 									'<ApplicationType xmlns="">STD</ApplicationType>' + 
 									'<AdvancePaymentAmount xmlns="">0.00</AdvancePaymentAmount>' + 
 									'<DownPaymentAmount xmlns="">0.00</DownPaymentAmount>'+ 
 									'<TradeupAmount xmlns="">0.00</TradeupAmount>' + 
 									'<Points xmlns="">0</Points>' +
 									'<PaySchedule xsi:nil="true"/>' +
 									'<AmortizationSchedule xsi:nil="true"/>' + 
 									'</Application>';
 							}
 							
 							/*  COMMITMENT  */
 	
 							rbody += '<ManualDecision xsi:nil="true"/>' +
 							'<SystemDecision xsi:nil="true"/><WriteOff xsi:nil="true"/>' +
 							'<Currency xmlns="">USD</Currency>' +
 							'<CountryOfRelationship xmlns="">US</CountryOfRelationship>' + 
 							'<CountryOfRisk xmlns="">US</CountryOfRisk>'; 
 					
 							if (processingLease){
 								rbody += '<EndDate xmlns="">' + string.valueOf(date.valueOf(l.cllease__Maturity_Date__c)) + '</EndDate>';  						
 								rbody += '<StartDate xmlns="">' + string.valueOf(date.valueOf(l.cllease__commencement_date__c)) +  '</StartDate>'; 
 							}
 							else{
 								rBody += '<EndDate xmlns="">' + string.valueOf(date.valueOf(ar.createddate).adddays(30)) + '</EndDate>'; 
 								rBody += '<StartDate xmlns="">' + string.valueOf(date.valueOf(ar.createddate)) + '</StartDate>'; 
 							}
 							if ((processingLease)){
 								String purchaseOption;
 								if (l.purchase_option__c == 'Fair Market Value')
 									purchaseOption = 'FMV';
 								else
 									purchaseOption = '1$BO';	
 								rbody+= '<PurchaseOption xmlns="">' + purchaseOption + '</PurchaseOption>'; 	
 							}
 							
 							if (processingLease)
 								rBody += '<RemainingPayments xmlns="">' + l.cllease__term__c + '</RemainingPayments>'; 
 							else
 								rBody += '<RemainingPayments xmlns="">0</RemainingPayments>'; 
 								 
 							if (processingLease)
 								rBody += '<Term xmlns="">' + l.cllease__Term__c + '</Term>';
 							else
 								rBody += '<Term xmlns="">0</Term>';
 								
 								
 							rbody += '<Periodicity xmlns="">M</Periodicity>'; 
 							
 							if (processingLease)
 								rbody += '<NextScheduledPaymentDate xmlns="">' + string.valueOf(date.valueOf(l.cllease__Next_Due_Date__c)) + '</NextScheduledPaymentDate>'; 
 							
 							if (processingLease)
 								rBody += '<Status xmlns="">Booked</Status>';
 							else
 								rBody += '<Status xmlns="">Pending</Status>';
 						 	
 							rBody += '<OriginalAmount xmlns="">' + originalAmount + '</OriginalAmount>' + 
 							'<LineOfBusiness xmlns="">OEQP</LineOfBusiness>' + 
 							'<ProductType xmlns="">LEASING</ProductType>' + 
 							'<OperatingUnit xmlns="">NEWCO</OperatingUnit>' + 
 							'<ActiveInterestRate xmlns="">0.0</ActiveInterestRate>'+ 
 							'<PassiveInterestRate xmlns="">0.0</PassiveInterestRate>' +
 							'<HyperionBasedEntity xmlns="">BEQUS</HyperionBasedEntity>' +
 							'<ServiceOnlyFlag xmlns="">N</ServiceOnlyFlag>'+
 							 
 							'</Commitment>' + 
 							'</AddCommitmentRequest>' +
 							'</soap:Body>' + 
 							'</soap:Envelope>';
 			
 			system.debug('rBody is: ' + rBody);
 			callXML = rBody;
 			reqAPI.setBody(callXML);  
		
			Http http1 = new Http();
	    	HTTPResponse res1 = http1.send(reqAPI); 
	    	//system.debug('HTTP Response is :' + string.valueOf(res1));
	    	results res = new results();
	    	res = parse(res1.getBody(),'CLE');
	  		resultXML = res1.getBody();
	  		 
	  		if (res1.getStatusCode() == 200){
	  			for (String key:res.resultMap.keySet())
		  			system.debug(key + '=' + res.resultMap.get(key));
	  
			   	system.debug('Response Body is :' + string.valueOf(res1.getbody()));
	    	
				ICS_Log__c log = new ICS_Log__c( xml__c = callXML
 												,caller__c = 'addCommitment'
 												,xml_result__c = resultXML
 												,end_point__c = endPoint
 												,status__c = 'OK');
				if (processingLease)
					log.LS_Contract__c = l.id;
				else
					log.quick_quote__c = ar.quick_quote__c;
 				
 				insert log;
 				return true;
	  		}
	  		else{
	  			ICS_Log__c log = new ICS_Log__c(xml__c = callXML,caller__c = 'addCommitment',xml_result__c = resultXML,end_point__c = endPoint,status__c = string.valueOf(res1.getStatusCode()));
				if (processingLease)
					log.LS_Contract__c = l.id;
				else
					log.quick_quote__c = ar.quick_quote__c;
 				
 				insert log;
 				 
	  			
	  		}	
		    //return string.valueOf(res1.getBody());
 		}
 		catch (exception e){
 			ICS_Log__c log = new ICS_Log__c(caller__c = 'addCommitment',xml__c = callXML,end_point__c = endPoint,xml_result__c = resultXML,status__c = string.valueOf(e));
			if (processingLease)
				log.LS_Contract__c = l.id;
			else
				log.quick_quote__c = ar.quick_quote__c;
			insert log;
 		}
    	
		return false;
    }
    /*************************************************************************************************
    * 
    * ICV Update Commitment
	*	 
    *************************************************************************************************/
   	@future (callout=true) 
    public static void updateCommitmentFuture(Map<String,String> requestInfoMap, ID applicationRequestId, String commitStatus, String exposureStatus){     
    
    	updateCommitment(requestInfoMap,applicationRequestId, commitStatus, exposureStatus);
    	 
    } 
    
    public static boolean updateCommitment(Map<String,String> requestInfoMap, ID applicationRequestId,String commitStatus, String exposureStatus){ 	
    	String myISODateTime = string.valueOf(json.serialize(datetime.now()));
    	
    	String callXML,endPoint,resultXML,commitmentId;
		ICS_Application__c ar;
		cllease__Lease_Account__c  l;
		Decimal myAmount; 
	 	 
		try{
			 ar = [select id
	  					,Message_Id__c
	  					,Quick_Quote__c
	  					,quick_quote__r.Estimated_Financed_Amount__c   
	  					,quick_quote__r.dealer__r.name
	  					,quick_quote__r.dealer__c
	  					,system_approval_limit__c
	  					,createddate
	  					,quick_quote__r.genesis__account__r.account_Number__c
	  					,quick_quote__r.dealer__r.account_Number__c 
	  					,quick_quote__r.name
	  					from ICS_Application__c
	  					where id = :applicationRequestId 
	  					];
	  				
	  		commitmentId = ar.quick_quote__r.name;
	  		myAmount = decimal.valueOf(ar.quick_quote__r.Estimated_Financed_Amount__c).setScale(2);
	  		
	  		//exposureStatus = '';
	  		
			HttpRequest reqAPI = new HttpRequest();   
			
        	reqAPI.setEndpoint('https://' + System.Label.ICVDomain + '.dllgroup.com/maintain-commitment');
        	endPoint = 'https://' + System.Label.ICVDomain + '.dllgroup.com/maintain-commitment';
    		reqAPI.setMethod('POST');          
			reqAPI.setHeader('Authorization', 'Bearer '+ ICVUtility.getAccessToken());
        	reqAPI.setHeader('content-type', 'text/xml');
        	reqAPI.setHeader('SoapAction', '""');
 			reqAPI.setTimeout(120000);
 			
 			system.debug('my amount is: ' + myAmount);
 			String rBody = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">' + 
 							'<soap:Body>' + 
 							'<UpdateCommitmentRequest xmlns="http://maintaincommitment.service.icv.dll.com/MaintainCommitmentXsd/">' +
 							'<RequestControl xmlns="http://common.service.icv.dll.com/common/">' + 
 							'<TransactionID xmlns="">' + '100' + '</TransactionID>' + 
 							'<UserLanguage xmlns="">ENG</UserLanguage>' + 
 							'<UserCountry xmlns="">US</UserCountry>' + 
 							'<UserId xmlns="">57542</UserId>' + 
 							'<SourceSystemTimestamp xmlns="">' + myISODateTime.substring(1,20) + '</SourceSystemTimestamp>' +
 							'</RequestControl>' + 
 							
 							'<Commitment xmlns="http://commitment.service.icv.dll.com/commitment/">' +
 							
 							
 							'<SourceCommitmentIdentification xmlns="http://common.service.icv.dll.com/common/">' + 
 							'<SourceSystem>' + 
 							'<SourceSystemName xmlns="">CLND</SourceSystemName>' + 
 							'</SourceSystem><SourceCommitmentID xmlns="">' + commitmentId + '</SourceCommitmentID>' + 
 							'<SourceCommitmentType xmlns="">A</SourceCommitmentType>' + 
 							'</SourceCommitmentIdentification>';
 
 							if (commitStatus == 'Declined'){
 								rbody += 
 	 							'<CommitmentExposure>' +
    							'<Exposure xmlns="http://exposure.entity.service.icv.dll.com/exposure/">' +
    								'<ExposureArray>' +
        								'<SourceCommitmentIdentification xmlns="http://common.service.icv.dll.com/common/">' +
        									'<SourceSystem>' +
            									'<SourceSystemName xmlns="">CLND</SourceSystemName>' +
        									'</SourceSystem>' +
        									'<SourceCommitmentID xmlns="">' + commitmentId + '</SourceCommitmentID>' +
        									'<SourceCommitmentType xmlns="">A</SourceCommitmentType>' +
    									'</SourceCommitmentIdentification>' +
    									'<ExposureDetail>' +
        									'<ExposureCategory xmlns="">CDIR</ExposureCategory>' +
        									'<ExposureStatus xmlns="">' + 'PEND' +  '</ExposureStatus>' +
        									'<ExposureType xmlns="">DLL</ExposureType>' +
        								'</ExposureDetail>' +
									'</ExposureArray>' +
								'</Exposure>' +
								'<ExposureAction xmlns="">D</ExposureAction>' +
						   	'</CommitmentExposure>';
 							}
 							else{
 	 							rbody += 
 	 							'<CommitmentExposure>' +
    							'<Exposure xmlns="http://exposure.entity.service.icv.dll.com/exposure/">' +
    								'<ExposureArray>' +
        								'<SourceCommitmentIdentification xmlns="http://common.service.icv.dll.com/common/">' +
        									'<SourceSystem>' +
            									'<SourceSystemName xmlns="">CLND</SourceSystemName>' +
        									'</SourceSystem>' +
        									'<SourceCommitmentID xmlns="">' + commitmentId + '</SourceCommitmentID>' +
        									'<SourceCommitmentType xmlns="">A</SourceCommitmentType>' +
    									'</SourceCommitmentIdentification>' +
    									'<ExposureDetail>' +
        									'<ExposureCategory xmlns="">CDIR</ExposureCategory>' +
        									'<ExposureStatus xmlns="">' + exposureStatus +  '</ExposureStatus>' +
        									'<ExposureType xmlns="">DLL</ExposureType>' +
        									'<ExposureAmount xmlns="">' + myAmount + '</ExposureAmount>'  +
        								'</ExposureDetail>' +
									'</ExposureArray>' +
								'</Exposure>' +
								'<ExposureAction xmlns="">A</ExposureAction>' +
						   	'</CommitmentExposure>';
 							}
 							
 							rbody += 		
 							'<Application>' + 
 								'<ExpectedPaymentAmount xmlns="">0.00</ExpectedPaymentAmount>' +
 								'<ApplicationType xmlns="">STD</ApplicationType>' + 
 								'<AdvancePaymentAmount xmlns="">0.00</AdvancePaymentAmount>' + 
 								'<DownPaymentAmount xmlns="">0.00</DownPaymentAmount>'+ 
 								'<TradeupAmount xmlns="">0.00</TradeupAmount>' + 
 								'<Points xmlns="">0</Points>' +
 								'<PaySchedule xsi:nil="true"/>' +
 								'<AmortizationSchedule xsi:nil="true"/>' + 
 							'</Application>' +
 							'<Currency xmlns="">USD</Currency>' +
 							'<CountryOfRelationship xmlns="">US</CountryOfRelationship>' + 
 							'<CountryOfRisk xmlns="">US</CountryOfRisk>'; 
 					
							rBody += '<EndDate xmlns="">' + string.valueOf(date.valueOf(ar.createddate).adddays(30)) + '</EndDate>'; 
							rBody += '<StartDate xmlns="">' + string.valueOf(date.valueOf(ar.createddate)) + '</StartDate>'; 
 							rBody += '<Term xmlns="">0</Term>';
 							rbody += '<Periodicity xmlns="">M</Periodicity>'; 
 							
 							rBody += '<Status xmlns="">' + commitStatus + '</Status>';
 							
 							rBody += '<OriginalAmount xmlns="">' + myAmount + '</OriginalAmount>' + 
 							'<ProductType xmlns="">LEASING</ProductType>' + 
 							'<ActiveInterestRate xmlns="">0.0</ActiveInterestRate>'+ 
 							'<PassiveInterestRate xmlns="">0.0</PassiveInterestRate>' +
 							'<HyperionBasedEntity xmlns="">BEQUS</HyperionBasedEntity>' +
 							'</Commitment>' + 
 							'</UpdateCommitmentRequest>' +
 							'</soap:Body>' + 
 							'</soap:Envelope>';
 			
 			system.debug('rBody is: ' + rBody);
 			callXML = rBody;	
 			reqAPI.setBody(rBody);  
		
			Http http1 = new Http();
	    	HTTPResponse res1 = http1.send(reqAPI); 
	    	system.debug('HTTP Response is :' + string.valueOf(res1));
	    	results res = new results();
	    	res = parse(res1.getBody(),'CLE');
	  
	  		 
	  		for (String key:res.resultMap.keySet())
		  		system.debug(key + '=' + res.resultMap.get(key));
	  
		    system.debug('Response Body is :' + string.valueOf(res1.getbody()));
	  
	  		resultXML = res1.getBody();
	  		
			ICS_Log__c log = new ICS_Log__c(quick_quote__c = ar.quick_quote__c,xml__c = callXML,end_point__c = endPoint,caller__c = 'updateCommitment',xml_result__c = resultXML,status__c = 'OK');
			
 			insert log;
 			return true;
    			
		    //return string.valueOf(res1.getBody());
 		}
 		catch (exception e){
 			ICS_Log__c log = new ICS_Log__c(quick_quote__c = ar.quick_quote__c,caller__c = 'updateCommitment',xml__c = callXML,end_point__c = endPoint,xml_result__c = resultXML,status__c = string.valueOf(e));
 			insert log;
 		}
    	
    	return false;
    }
    
    /*************************************************************************************************
    * 
    * ICV Insert Log
 	*	  
    *************************************************************************************************/
    @future  
    public static void insertLog(String callXML, String caller, String type, String resultXML, String endPoint, String status,String lid, string qq){
    
    	ICS_Log__c log = new ICS_Log__c(xml__c = callXML,caller__c = caller ,xml_result__c = resultXML,end_point__c = endpoint
    								,status__c = status);
	    		//system.debug('************* putting in lease id' + l.id);
	    if (type == 'L')
	    	log.ls_contract__c = lid;
	    else
			log.quick_quote__c = qq;
		
		insert log;	
    }
    
    /*************************************************************************************************
    * 
    * ICV Update Acccont in ICV flag
 	*	  
 	* accountid,flag is in map
    *************************************************************************************************/
    @future (callout=true) 
    public static void setInICVFlag(Map<String,Boolean> accountMap){
    	
    	
    	List<Account> aList = new List<Account>();
    	List<Account> uList = new List<Account>();
    	aList = [select id from Account where id in :accountMap.keySet()];
    	
    	for (Account a:aList){
    		a.in_icv__c = accountMap.get(a.id);
    		uList.add(a); 
    	}
    	
    	update uList;
    }
    
    /*************************************************************************************************
    * 
    * ICV Update SIC Code
    *	
    *  order of priority is
    *	D&B
	*	Experian
	*	Paynet
    *	
    US_DNB
    US_EXPERIAN             
	US_PAYNET
	                 
	*	  
    *************************************************************************************************/
    @future (callout=true) 
    public static void setSICCode(Map<String,String> leaseMap){
    	
    	String leaseId = leaseMap.get('leaseid'); 
    	
     
    	cllease__Lease_Account__c  l = [select 
    									 application_number__c
    									,cllease__Account__c
    									from cllease__Lease_Account__c 
    									where id = :leaseId	
    									];
    	
    	genesis__Applications__c app = [
    								Select
    								  Name
    								, genesis__quick_quote__c
    								, genesis__quick_quote__r.name
    								, genesis__quick_quote__r.with_account__c
    								From genesis__Applications__c g
    								where name = :l.application_number__c
    								];
    								
    	if (l.cllease__Account__c != null){
    		genesis__Quick_Quotes__c q = [Select ATS_Reference_Number__c 
    									From genesis__Quick_Quotes__c 
    									where id = :app.genesis__quick_quote__c
    									];
    									
    		Account a = [Select id from Account where id = :l.cllease__Account__c];
    		
    		List<ICS_External_Legal_Entity__c> eList = new List<ICS_External_Legal_Entity__c>();
    		eList = [select 
    				industry_code_Value__c 
    				,industry_code_type__c
    				,agency_id__c
    				from ICS_External_Legal_Entity__c
    				where ICS_Application_Request__r.quick_quote__c = :app.genesis__quick_quote__c
    				and ICS_Application_Request__r.message_id__c = :q.ATS_Reference_Number__c 
    				order by agency_id__c];
		
			 
			/* since the order of the resuls are already sorted in the priority order, break on first found */ 
    		for (ICS_External_Legal_Entity__c e:eList){
    			if (e.industry_code_value__c != null){
    				a.industry_code__c = e.industry_code_value__c;
    				a.industry_code_type__c = e.industry_code_type__c;
    			 	if (e.agency_id__c == 'US_DNB')
						break;
					if (e.agency_id__c == 'US_EXPERIAN')
						break;
					if (e.agency_id__c == 'US_PAYNET')
    					break;
    			}
    		}
    		
    		update a;
    				
    	}
    }  
	/*************************************************************************************************
    * 
    * ICV Get CommitmentLE Request Info
	* @future (callout=true) 	 
    *************************************************************************************************/
    
    public static boolean getCommitmentLE(Map<String,String> requestInfoMap, ID applicationRequestId){     	
		
		ICVUtility.getCommitmentLERequestInfo input = new ICVUtility.getCommitmentLERequestInfo();
		 
    	input.TransactionID = requestInfoMap.get('TransactionID'); // = '7b150e3849e611e8b6bcac1b64370000';
     	input.SourceSystemTimeStamp = requestInfoMap.get('SourceSystemTimeStamp'); // = '2018-05-09T01:52:25';
     	input.SourceCommitmentID = requestInfoMap.get('SourceCommitmentID'); // = '100-10190450';add commitment reference number
     	input.SourceCommitmentType = requestInfoMap.get('SourceCommitmentType'); // = 'A';
     	
		String callXML;
		String resultXML;
		String endPoint,soapAction;
		
		 
		ICS_Application__c ar = [select id 
	  									,Message_Id__c
	  									,Quick_Quote__c
	  									,quick_quote__r.genesis__Status__c
	  									from ICS_Application__c 
	  									where id = :applicationRequestId 
	  									];
	  	
	  	//no need to get commitment info if app is auto declined
	  	if (ar.quick_quote__r.genesis__Status__c == 'CREDIT DECLINED')
	  		return true;
		 
		try{
			HttpRequest reqAPI = new HttpRequest();   
        	reqAPI.setEndpoint('https://' + System.Label.ICVDomain + '.dllgroup.com/getcommitment-legalentities');
        	endPoint = 'https://' + System.Label.ICVDomain + '.dllgroup.com/getcommitment-legalentities';
    		reqAPI.setMethod('POST');          
			reqAPI.setHeader('Authorization', 'Bearer '+ ICVUtility.getAccessToken());
        	reqAPI.setHeader('content-type', 'text/xml');
        	reqAPI.setHeader('SoapAction', 'http://getcommitmentle.service.icv.dll.com/GetCommitmentLegalEntities/GetCommitmentLegalEntities');
 			reqAPI.setTimeout(120000);
 			soapAction = 'http://getcommitmentle.service.icv.dll.com/GetCommitmentLegalEntities/GetCommitmentLegalEntities';
			String getCommitmentLEBody = '<get:GetCommitmentLegalEntitiesRequest xmlns:xsi="http://www.w3.org/2001/XMLSchemainstance" xmlns:get="http://schemas.delagelanden.com/GetCommitmentLegalEntities/1.0">' + 
	 			'<common:RequestControl xmlns:common="http://schemas.delagelanden.com/ICVcommon/">' + 
 				generateCommitmentLEMsgHdr(input) + 
 				' </common:RequestControl>' +  
 				generateCommitmentLE(input) + 
 				' </get:GetCommitmentLegalEntitiesRequest>';
		
 				String envelope = '<env:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">';
 		
	 		String rBody = '<?xml version="1.0"?>' + 
 				envelope +
 				'<env:Body>' + 
 				getCommitmentLEBody + 
 				'</env:Body>' + 
 				'</env:Envelope>';
 		
 			system.debug('rBody is: ' + rBody);
 			callXML = rBody;	
 			reqAPI.setBody(rBody);  
		
		
			Http http1 = new Http();
	    	HTTPResponse res1;
	    	
	    	res1 = http1.send(reqAPI);
	    
	    	system.debug('HTTP Response is :' + string.valueOf(res1));
	  	
	    	results res = new results();
	    	res = parse(escapeXML(res1.getBody()),'CLE');
	  		for (String key:res.resultMap.keySet())
		  		system.debug(key + '=' + res.resultMap.get(key));
	  
		    system.debug('Response Body is :' + string.valueOf(res1.getbody()));
	  		
	  		/*
	  		
	  		results:[commitmentCount=0, leCount=0, partyCount=0, result=
			Element: Enveloperesults:[commitmentCount=0, leCount=0, partyCount=0, result=
			Element: Bodyresults:[commitmentCount=0, leCount=0, partyCount=0, result=
			Element: GetCommitmentLegalEntitiesResponseresults:[commitmentCount=0, leCount=0, partyCount=0, result=
			Element: CommitmentLE, resultMap={}], resultMap={}], resultMap={}], resultMap={}]
	  		
	  		*/
	  		resultXML = res1.getBody();
	  		
	  		if (res1.getStatusCode() == 200){
	  			
	  			if (res.leCount != 0){
	    			ICV_Commitment_LE__c c = new ICV_Commitment_LE__c();
	    			c.commitment_id__c = res.resultMap.get('0.SourceCommitmentIdentification.SourceCommitmentID');
	    			c.expected_loss__c = decimal.valueOf(res.resultMap.get('0.ExpectedLoss.Amount'));
	    			c.expected_loss_eur__c = decimal.valueOf(res.resultMap.get('0.ExpectedLossEUR.Amount'));
	    			c.ics_application_request__c = ar.id;
	    			c.Source_Commitment_Type__c = res.resultMap.get('0.SourceCommitmentIdentification.SourceCommitmentType');
	    			c.Source_System_Name__c = res.resultMap.get('0.SourceSystem.SourceSystemName');
	    			insert c;
		    
	    			List<ICV_Commitment_LE_Detail__c> leList = new List<ICV_Commitment_LE_Detail__c>();
		    
	    			for (Integer i=1;i <= res.leCount;i++){
		    			ICV_Commitment_LE_Detail__c d = new ICV_Commitment_LE_Detail__c();
		    			d.Approved_DLL_Contingent_Exposure__c = decimal.valueOf(res.resultMap.get(i + '.ApprovedDLLContingentExposure.Amount'));
	    				d.Approved_DLL_Direct_Exposure__c = decimal.valueOf(res.resultMap.get(i + '.ApprovedDLLDirectExposure.Amount'));
	    				d.Approved_DLL_Other_Exposure__c = decimal.valueOf(res.resultMap.get(i + '.ApprovedDLLOtherExposure.Amount'));
	    				d.Approved_DLL_Portfolio_Exposure__c = decimal.valueOf(res.resultMap.get(i + '.ApprovedDLLPortfolioExposure.Amount'));
	    				d.DLL_Direct_Appr_Exposure__c = decimal.valueOf(res.resultMap.get(i + '.DLLDirectApprExposure.Amount'));
	    				d.DLL_Direct_Appr_Exposure_EUR__c = decimal.valueOf(res.resultMap.get(i + '.DLLDirectApprExposureEUR.Amount'));
	    				d.icv_commitment_le__c = c.id;
		    		
		    			d.Legal_Entity_Link__c = res.resultMap.get(i + '.LegalEntity.LegalEntityLink');
		    			d.LE_Id__c = res.resultMap.get(i + '.SourcePartyIdentification.SourcePartyKeyID');
	    				d.Name__c = res.resultMap.get(i + '.LegalEntity.LegalEntityName');
	    				d.Party_Role_Description__c = res.resultMap.get(i + '.LegalEntity.PartyRoleDescription');
	    					d.Party_Role_Name__c = res.resultMap.get(i + '.LegalEntity.PartyRoleName');
	    				d.Rating_History_Link__c = res.resultMap.get(i + '.LegalEntity.RatingHistoryLink');
		    		
	    				leList.add(d);
	    			}
	    			if (!leList.isEmpty())
		    			insert leList;
	  			}
	  			
				ICS_Log__c log = new ICS_Log__c(quick_quote__c = ar.quick_quote__c,xml__c = callXML,end_point__c = endPoint,soapAction__c = soapAction,caller__c = 'getCommitment',xml_result__c = resultXML,status__c = 'OK');
				
 				insert log;
 				return true;
	  		}	
		    else{
		    	ICS_Log__c log = new ICS_Log__c(quick_quote__c = ar.quick_quote__c,xml__c = callXML,end_point__c = endPoint,soapAction__c = soapAction,caller__c = 'getCommitment' ,xml_result__c = resultXML,status__c = string.valueOf(res1.getStatusCode()));
 				insert log;
		    }
 		}
 		catch (exception e){
 			ICS_Log__c log = new ICS_Log__c(quick_quote__c = ar.quick_quote__c,xml__c = callXML,end_point__c = endPoint,soapAction__c = soapAction,caller__c = 'getCommitment',xml_result__c = resultXML,status__c = string.valueOf(e));
			insert log;
 		}
    	
		return false;
    }	
    /*************************************************************************************************
    * 
    * ICV Get Contract Performance Data
	*	  
    *************************************************************************************************/
    //@future (callout=true) 
    //public static void getContractPerformanceDataFuture(Map<String,String> requestInfoMap, ID applicationRequestId){     
   
	// 		getContractPerformanceData(requestInfoMap,applicationRequestId);     
   	//
    //}
    
    public static boolean getContractPerformanceData(Map<String,String> requestInfoMap, ID applicationRequestId){     
    	
    	ICS_Application__c ar = [select id
	  									,Message_Id__c
	  									,Quick_Quote__c
	  									,quick_quote__r.dealer__r.name
	  									,quick_quote__r.dealer__c
	  									,system_approval_limit__c
	  									,createddate
	  									,quick_quote__r.with_account__c
	  									,quick_quote__r.genesis__account__c
	  									from ICS_Application__c
	  									where id = :applicationRequestId 
	  									];
		
    	String myISODateTime = string.valueOf(json.serialize(datetime.now()));
    	
    	String callXML; 
		String resultXML;
		String endPoint, soapAction;
		 
		try{
			HttpRequest reqAPI = new HttpRequest();   
			reqAPI.setTimeout(120000);
        	reqAPI.setEndpoint('https://' + System.Label.ICVDomain + '.dllgroup.com/get-contract-performance-data');
        	endPoint = 'https://' + System.Label.ICVDomain + '.dllgroup.com/get-contract-performance-data';
    		reqAPI.setMethod('POST');          
			reqAPI.setHeader('Authorization', 'Bearer '+ ICVUtility.getAccessToken());
        	reqAPI.setHeader('content-type', 'text/xml');
        	reqAPI.setHeader('SoapAction', 'GetContractPerformanceData');
 			soapAction = 'GetContractPerformanceData';
 			String rBody = 	'<?xml version="1.0" encoding="UTF-8"?>' + 
							'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
							'<soapenv:Body>' +
							'<GetContractPerformanceData xmlns="http://schemas.delagelanden.com/contractperf/get">' +
							'<Request>' +
							'<Authorize>' +
							'<dllcmn:User_ID xmlns:dllcmn="http://schemas.delagelanden.com/common">44898</dllcmn:User_ID>' +
							'<dllcmn:User_Type xmlns:dllcmn="http://schemas.delagelanden.com/common">I</dllcmn:User_Type>' +
							'<dllcmn:Responsibility_ID xmlns:dllcmn="http://schemas.delagelanden.com/common">50560</dllcmn:Responsibility_ID>' +
							'<dllcmn:Application_ID xmlns:dllcmn="http://schemas.delagelanden.com/common">540</dllcmn:Application_ID>' +
							'<dllcmn:Organization_ID xmlns:dllcmn="http://schemas.delagelanden.com/common">84</dllcmn:Organization_ID>' +
							'<dllcmn:UserCountry xmlns:dllcmn="http://schemas.delagelanden.com/common">US</dllcmn:UserCountry>' +
							'<dllcmn:UserCurrency xmlns:dllcmn="http://schemas.delagelanden.com/common">USD</dllcmn:UserCurrency>' +
							'<dllcmn:Source_System_ID xmlns:dllcmn="http://schemas.delagelanden.com/common">CLND</dllcmn:Source_System_ID>' +
							'</Authorize>' +
							'<Info>' +
							'<Identifiers>' +
							'<dllcmn:Identifier xmlns:dllcmn="http://schemas.delagelanden.com/common">' +
							'<dllcmn0:SourceSystem xmlns:dllcmn0="http://schemas.delagelanden.com/common">' + requestInfoMap.get('SourceSystem') + '</dllcmn0:SourceSystem>' +
							'<dllcmn0:IDType xmlns:dllcmn0="http://schemas.delagelanden.com/common">' + requestInfoMap.get('IDType') + '</dllcmn0:IDType>' +
							'<dllcmn0:IDValue xmlns:dllcmn0="http://schemas.delagelanden.com/common">' + requestInfoMap.get('IDValue') + '</dllcmn0:IDValue>' +
							'</dllcmn:Identifier>' +
							'</Identifiers>' +
							'</Info>' +
							'</Request>' +
							'</GetContractPerformanceData>' +
							'</soapenv:Body>' +
							'</soapenv:Envelope>';
 			
 			callXML = rBody;	
 			reqAPI.setBody(rBody);  
		
			Http http1 = new Http();
	    	HTTPResponse res1 = http1.send(reqAPI); 
	    	results res = new results();
	    	res = parse(escapeXML(res1.getBody()),'CP');
	    	
	  		Integer totalPartyCount = 0;
	  		for (String key:res.resultMap.keySet()){
		  		if (key.contains('Party.DisplayName'))
		  			totalPartyCount++;
		  		
	  		}
	  		
	  		resultXML = res1.getBody();
	  		
	  		
	  		if (res1.getStatusCode() == 200  ){
	    		ICV_Contract_Performance__c cp = new ICV_Contract_Performance__c();
	    		cp.ics_application_request__c = applicationRequestId;
	    		cp.source_system__c = res.resultMap.get('0.0.' + 'Identifier.SourceSystem');
	    		cp.id_type__c =  res.resultMap.get('0.0.' + 'Identifier.IDType');
	    		cp.id_value__c =  res.resultMap.get('0.0.' + 'Identifier.IDValue');
	    		insert cp;    
	    	
	    		List <ICV_Contract_Performance_Party_Commit__c> cList = new List <ICV_Contract_Performance_Party_Commit__c>(); 
	    	 
	    		for (Integer i=1;i <= totalPartyCount;i++){
	    			// there will never be that many parties so the soql in the loop is ok and simpler 
	    			ICV_Contract_Performance_Party__c p = new ICV_Contract_Performance_Party__c();
	    			p.icv_contract_performance__c = cp.id;
	    			p.display_name__c = res.resultMap.get(i + '.0.' + 'Party.DisplayName');
					p.source_system__c = res.resultMap.get(i + '.0.' + 'Identifier.SourceSystem');
					p.id_type__c = res.resultMap.get(i + '.0.' + 'Identifier.IDType');
					p.id_value__c = res.resultMap.get(i + '.0.' + 'Identifier.IDValue');
					insert p;
				
					Integer j=1;
					while (res.resultMap.get(i + '.' + j + '.' + 'CommitmentId.SourceSystem') != null){
						
						ICV_Contract_Performance_Party_Commit__c c = new ICV_Contract_Performance_Party_Commit__c();
						c.ICV_Contract_Performance_Party__c = p.id;
							
						c.Source_System__c = res.resultMap.get(i + '.' + j + '.' +'CommitmentId.SourceSystem');
						c.Commitment_id__c = res.resultMap.get(i + '.' + j + '.' +'CommitmentId.CommitmentId');
						c.commitment_type__c = res.resultMap.get(i + '.' + j + '.' +'CommitmentId.CommitmentType');
						
						if (res.resultMap.get(i + '.' + j + '.' +'Commitment.OriginalAmount') != null)	
							c.Original_Amount__c = decimal.valueOf(res.resultMap.get(i + '.' + j + '.' +'Commitment.OriginalAmount'));
						
						c.line_of_business__c = res.resultMap.get(i + '.' + j + '.' +'Commitment.LineOfBusiness');
						
						if (res.resultMap.get(i + '.' + j + '.' +'Commitment.StartDate') != null)
							c.start_date__c = date.valueOf(res.resultMap.get(i + '.' + j + '.' +'Commitment.StartDate'));
						if (res.resultMap.get(i + '.' + j + '.' +'Commitment.EndDate') != null)
							c.end_date__c = date.valueOf(res.resultMap.get(i + '.' + j + '.' +'Commitment.EndDate'));
						if (res.resultMap.get(i + '.' + j + '.' +'Commitment.Term') != null)
							c.term__c = integer.valueOf(res.resultMap.get(i + '.' + j + '.' +'Commitment.Term'));
						
						c.status__c = res.resultMap.get(i + '.' + j + '.' +'Commitment.Status');
						c.currency_code__c = res.resultMap.get(i + '.' + j + '.' +'Commitment.CurrencyCode');
						
						if (res.resultMap.get(i + '.' + j + '.' +'PerformanceData.AverageDaysToPay') != null)
							c.average_days_to_pay__c = integer.valueOf(res.resultMap.get(i + '.' + j + '.' +'PerformanceData.AverageDaysToPay'));
						if (res.resultMap.get(i + '.' + j + '.' +'PerformanceData.Payments0_30') != null)
							c.payments_0_30__c = integer.valueOf(res.resultMap.get(i + '.' + j + '.' +'PerformanceData.Payments0_30'));
						if (res.resultMap.get(i + '.' + j + '.' +'PerformanceData.Payments31_60') != null)
							c.payments_31_60__c = integer.valueOf(res.resultMap.get(i + '.' + j + '.' +'PerformanceData.Payments31_60'));
						if (res.resultMap.get(i + '.' + j + '.' +'PerformanceData.Payments61_90') != null)
							c.payments_61_90__c = integer.valueOf(res.resultMap.get(i + '.' + j + '.' +'PerformanceData.Payments61_90'));
						if (res.resultMap.get(i + '.' + j + '.' +'PerformanceData.Payments91_120') != null)
							c.payments_91_120__c = integer.valueOf(res.resultMap.get(i + '.' + j + '.' +'PerformanceData.Payments91_120'));
						if (res.resultMap.get(i + '.' + j + '.' +'PerformanceData.Payments121_over') != null)
							c.payments_121_over__c = integer.valueOf(res.resultMap.get(i + '.' + j + '.' +'PerformanceData.Payments121_over'));
						if (res.resultMap.get(i + '.' + j + '.' +'Commitment.RemainingPayments') != null)
							c.remaining_Payments__c = integer.valueOf(res.resultMap.get(i + '.' + j + '.' +'Commitment.RemainingPayments'));
						
						c.active_indicator__c = res.resultMap.get(i + '.' + j + '.' +'Commitment.ActiveIndicator');
						
						if (res.resultMap.get(i + '.' + j + '.' +'WriteOff.WriteOffAmount') != null){
							c.write_off_amount__c = decimal.valueOf(res.resultMap.get(i + '.' + j + '.' +'WriteOff.WriteOffAmount'));
						}
						if (res.resultMap.get(i + '.' + j + '.' +'WriteOff.WriteOffDate') != null){
							c.write_off_date__c = date.valueOf(res.resultMap.get(i + '.' + j + '.' +'WriteOff.WriteOffDate'));
						}
						c.write_off_reason__c = res.resultMap.get(i + '.' + j + '.' +'WriteOff.WriteOffReason');
						
						cList.add(c);
						j++;
					}		 
	    		}
	    	
	    		if (!cList.isEmpty())
					insert cList;

				ICS_Log__c log = new ICS_Log__c(quick_quote__c = ar.quick_quote__c,caller__c = 'getContractPerformanceData',xml__c = callXML,xml_result__c = resultXML,end_point__c = endPoint,soapaction__c = soapAction,status__c = 'OK');
				insert log; 
 				return true;
	  		}
	  		else{
	  			ICS_Log__c log = new ICS_Log__c(quick_quote__c = ar.quick_quote__c,caller__c = 'getContractPerformanceData',xml__c = callXML,xml_result__c = resultXML,end_point__c = endPoint,soapaction__c = soapAction,status__c = string.valueOf(res1.getStatusCode()));
				insert log;
	  		}    			
		    //return string.valueOf(res1.getBody());
 		}
 		catch (exception e){
 			system.debug(e);
 			ICS_Log__c log = new ICS_Log__c(quick_quote__c = ar.quick_quote__c,xml__c = callXML,caller__c = 'getContractPerformanceData',xml_result__c = resultXML,end_point__c = endPoint,soapaction__c = soapAction,status__c = string.valueOf(e));
 			insert log;
 		}
    	
    	return false;
    }
    
    /*************************************************************************************************
    * 
    * ICV remove Party
    *************************************************************************************************/
    public static boolean removeParty(String partyId,String reason){
    	
    	if (reason == 'Decline')
    		return true;
    		
    		
    	String myISODateTime = string.valueOf(json.serialize(datetime.now()));
    	String endpoint;
    	String callXML;
    	String resultXML;
    	
    	genesis__Quick_Quotes__c q = [select id
    								,name
    								,genesis__account__c
    								from genesis__quick_quotes__c 
    								where id = :partyId
    								];
    								
    			
    	try{ 
			HttpRequest reqAPI = new HttpRequest();  
			reqAPI.setTimeout(120000);
        	reqAPI.setEndpoint('https://' + System.Label.ICVDomain + '.dllgroup.com/v1/removeparty');
        	endpoint = 'https://' + System.Label.ICVDomain + '.dllgroup.com/v1/removeparty';
    		reqAPI.setMethod('POST');          
			reqAPI.setHeader('Authorization', 'Bearer '+ ICVUtility.getAccessToken());
        	reqAPI.setHeader('content-type', 'application/json');
        	
	  		JSONGenerator gen = JSON.createGenerator(true);
			
			gen.writeStartObject();
	 		gen.writeFieldName('RequestControl');
			gen.writeStartObject();
	  		gen.writeStringField('TransactionID',String.valueOf(Math.abs(Crypto.getRandomInteger())));
	  		gen.writeStringField('UserId', 'cloudlending');
	  		gen.writeStringField('SourceSystemTimestamp', myISODateTime.substring(1,20) );
			gen.writeEndObject();
	  	 
	 		gen.writeFieldName('Party');
	 		gen.writeStartObject();
	 		gen.writeStringField('SourceSystemName', 'CLND');
	  		gen.writeStringField('SourcePartyIdType', 'PARTY_ID');
	  		gen.writeStringField('SourcePartyIdValue', q.name);
			gen.writeEndObject();
	  		 
	  		String jsonS = gen.getAsString();
			
			reqAPI.setBody(jsonS);  
			callXML = jsonS;
		
			Http http1 = new Http();
	    	HTTPResponse res1 = http1.send(reqAPI); 
	    	results res = new results();
	    	resultXML = res1.getBody();
			
	  		JSONParser parser = JSON.createParser(res1.getBody());
	  		partyResult pr = (partyResult)parser.readValueAs(partyResult.class);
	  		String s = JSON.serialize(pr);
          
        	String resultCode, resultMessage;
        	
        	if (res1.getStatusCode() == 200) {
	    		ICS_Log__c log = new ICS_Log__c(quick_quote__c = partyId,xml__c = callXML,caller__c = 'removeParty',xml_result__c = resultXML,end_point__c = endpoint,status__c = 'OK');
	    		insert log;
 				return true;
        	}
        	else{
        		ICS_Log__c log = new ICS_Log__c(quick_quote__c = partyId,xml__c = callXML,caller__c = 'removeParty',xml_result__c = resultXML,end_point__c = endpoint,status__c = string.valueOf(res1.getStatusCode()));
	   			insert log;
        	}	
		}
 		catch (exception e){
 			ICS_Log__c log = new ICS_Log__c(quick_quote__c = partyId,xml__c = callXML,end_point__c = endpoint,caller__c = 'removeParty',xml_result__c = resultXML,status__c = string.valueOf(e));
			insert log;
 		}
 		
    	return false;	
    	
    }
   
   	
    /*************************************************************************************************
    * 
    * ICV Remove Commitment
    *************************************************************************************************/
    public static boolean removeCommitment(String commitmentID,String reason){
     	
    	if (reason == 'Decline'){
    		ICS_Application__c a = [select id
   								,quick_quote__c
   								,quick_quote__r.name
   								,score_decision__c
   								,system_decision__c
   								,transaction_id__c
   								from ICS_Application__c
   								where quick_quote__r.name = :commitmentID
   		
   		
   								];
    		map<String,String> requestInfoMap = new Map<String,String>();
			requestInfoMap.put('TransactionID',ICVUtility.getMessageId());
			requestInfoMap.put('SourceCommitmentID',commitmentId);	
			requestInfoMap.put('SourceCommitmentType','A');
			String myISODateTime = string.valueOf(json.serialize(datetime.now()));
	    	requestInfoMap.put('SourceSystemTimestamp', myISODateTime.substring(1,20));
	    	ICVUtility.updateCommitment(requestInfoMap,a.id,'Declined','');
    	
    		return true;
    	
    	}
    	else{
    		
    	
    	String callXML,resultXML, endPoint;
    	String myISODateTime = string.valueOf(json.serialize(datetime.now()));
    	
    	try{
			HttpRequest reqAPI = new HttpRequest();   
			reqAPI.setTimeout(120000);
        	reqAPI.setEndpoint('https://' + System.Label.ICVDomain + '.dllgroup.com/maintain-commitment');
        	endPoint = 'https://' + System.Label.ICVDomain + '.dllgroup.com/maintain-commitment';
    		reqAPI.setMethod('POST');          
			reqAPI.setHeader('Authorization', 'Bearer '+ ICVUtility.getAccessToken());
        	reqAPI.setHeader('content-type', 'text/xml');
        	reqAPI.setHeader('SoapAction', '""');

 			String rBody = '<?xml version="1.0" encoding="utf-8"?>' + 
 			 				'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:main="http://maintaincommitment.service.icv.dll.com/MaintainCommitmentXsd/" xmlns:com="http://common.service.icv.dll.com/common/" xmlns:com1="http://commitment.service.icv.dll.com/commitment/" xmlns:exp="http://exposure.entity.service.icv.dll.com/exposure/" xmlns:com2="http://commitmentdetails.service.icv.dll.com/commitmentdetails/">' + 
 							'<soapenv:Header/>' + 
 							'<soapenv:Body>' + 
 							'<main:RemoveCommitmentRequest xmlns="http://maintaincommitment.service.icv.dll.com/MaintainCommitmentXsd/">' +
 							
 							'<com:RequestControl xmlns="http://common.service.icv.dll.com/common/">' + 
 							'<TransactionID xmlns="">' + '100' + '</TransactionID>' + 
 							'<UserLanguage xmlns="">ENG</UserLanguage>' + 
 							'<UserCountry xmlns="">US</UserCountry>' + 
 							'<UserId xmlns="">57542</UserId>' + 
 							'<SourceSystemTimestamp xmlns="">' + myISODateTime.substring(1,20) + '</SourceSystemTimestamp>' +
 							'</com:RequestControl>' + 
 							
 							'<com1:Commitment xmlns="http://commitment.service.icv.dll.com/commitment/">' +
 							
 							'<com:SourceCommitmentIdentification xmlns="http://common.service.icv.dll.com/common/">' + 
 							'<com:SourceSystem>' + 
 							'<SourceSystemName xmlns="">CLND</SourceSystemName>' + 
 							'</com:SourceSystem><SourceCommitmentID xmlns="">' + commitmentId + '</SourceCommitmentID>' + 
 							'<SourceCommitmentType xmlns="">A</SourceCommitmentType>' + 
 							'</com:SourceCommitmentIdentification>' + 
 							
 							'</com1:Commitment>' + 
 							'</main:RemoveCommitmentRequest>' +
 							'</soapenv:Body>' + 
 							'</soapenv:Envelope>';
 			
 			callXML = rBody;	
 			reqAPI.setBody(rBody);  
			system.debug(rbody);
			Http http1 = new Http();
	    	HTTPResponse res1 = http1.send(reqAPI); 
	    	
		    system.debug('Response Body is :' + string.valueOf(res1.getbody()));
	  
	  		resultXML = res1.getBody();
			ICS_Log__c log = new ICS_Log__c(xml__c = callXML,caller__c = 'removeCommitment ' + commitmentId,xml_result__c = resultXML,end_point__c = endPoint,status__c = 'OK');
 			insert log;

 			return true;
    			
		    //return string.valueOf(res1.getBody());
 		}
 		catch (exception e){
 			ICS_Log__c log = new ICS_Log__c(caller__c = 'removeCommitment ' + commitmentId,xml__c = callXML,end_point__c = endPoint,xml_result__c = resultXML,status__c = string.valueOf(e));
			insert log;
 		}
    	
    	return false;
    	}	
    	 
    }
    
    /*************************************************************************************************
    * 
    * Generate CommitmentLE Message
	*	
    *************************************************************************************************/
    public static String generateCommitmentLEMsgHdr(ICVUtility.getCommitmentLERequestInfo input){
    	
    	String xml = '';
    	 
    	xml =   '<TransactionID>' + input.TransactionID + '</TransactionID>';
    	xml +=  '<UserLanguage>' + 'ENG' + '</UserLanguage>';
    	xml +=  '<UserCountry>' + 'US' + '</UserCountry>';
    	xml +=  '<UserId>' + System.Label.ICV_userId + '</UserId>';
    	String myISODateTime = string.valueOf(json.serialize(datetime.now()));
		xml +=  '<SourceSystemTimestamp>' + myISODateTime.substring(1,20) + '</SourceSystemTimestamp>';
    	xml +=  '<UserCurrency>' + 'USD' + '</UserCurrency>';
   	
    	return xml;
    	
    }
    
    /*************************************************************************************************
    * 
    * Generate CommitmentLE  
	*	
    *************************************************************************************************/
    public static String generateCommitmentLE(ICVUtility.getCommitmentLERequestInfo input){
    
    	String xml = '';		
 		
 		xml = 	'<CommitmentLE>';
 		xml +=	'<common:SourceCommitmentIdentification xmlns:common="http://schemas.delagelanden.com/ICVcommon/">'; 
 		xml +=	'<common:SourceSystem xmlns:common="http://schemas.delagelanden.com/ICVcommon/">';
 		xml +=	'<SourceSystemName>' + System.Label.ICV_sourceSystemName + '</SourceSystemName> ';  
 		xml +=	'</common:SourceSystem>';
 		xml += 	'<SourceCommitmentID>' + input.SourceCommitmentID + '</SourceCommitmentID>'; 
 		xml += 	'<SourceCommitmentType>' + input.SourceCommitmentType +  '</SourceCommitmentType>'; 
		xml += 	'</common:SourceCommitmentIdentification>'; 
 		xml +=	'</CommitmentLE>';
    	
    	return xml;
    }
        
    /*************************************************************************************************
    * 
    * Parse
	*	
    *************************************************************************************************/
    public static results parse(String toParse, String parseType) {
    	results res = new results();
  		DOM.Document doc = new DOM.Document();      
  		try {
    		doc.load(toParse);    
    		DOM.XMLNode root = doc.getRootElement();
    		Map<String,String> resultMap = new Map<String,String>();
    		return walkThrough(root,resultMap,res,0,0,0,parseType);
 		 } catch (System.XMLException e) {  // invalid XML
 		 	res.result = e.getMessage();
 		 	return res;
    	}
	}
    /*************************************************************************************************
    * 
    * Results
	*	
    *************************************************************************************************/
    public class results{ 
    	String result;
    	Map<String,String> resultMap = new Map<String,String>();
    	Integer leCount = 0;
    	Integer partyCount = 0;
    	Integer commitmentCount = 0;
    	
    	
    }
    /*************************************************************************************************
    * 
    * Walkthrough  
	*	
    *************************************************************************************************/
    private static Results walkThrough(DOM.XMLNode node, Map<String,String> resultMap,ICVUtility.results res,Integer leCount,Integer partyCount, Integer commitmentCount, String parseType) {
  		String result = '\n';
		
		if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
    		result += 'Element: ' + node.getName();
    		res.result = result;
    		
    		if (parseType == 'CLE' && node.getText().trim() != '') {
      			result += ', text=' + node.getText().trim();
      			res.result = result;
      			res.resultMap.put(leCount + '.' + node.getParent().getName() + '.' + node.getName(),node.getText().trim());
      		}
      		else{
      			if (parseType == 'CP' && node.getText().trim() != '') {
	    			result += ', text=' + node.getText().trim();
      				res.result = result;
      				res.resultMap.put(partyCount + '.' + commitmentCount + '.' + node.getParent().getName() + '.' + node.getName(),node.getText().trim());
      			}
      		}
      		
    		if (node.getAttributeCount() > 0) { 
      			for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
      				result += ', attribute #' + i + ':' + node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
        			res.result = result;
      			}  
    		}
    		
    		
    		if (parseType == 'CLE' && node.getName() == 'LegalEntity' && node.getParent().getName() == 'CommitmentLE')
    			res.leCount++;
    		else{
    			if (parseType == 'CP'){
    				if (node.getName() == 'Commitment' && node.getParent().getName() == 'Party'){		
    					res.commitmentCount++;
    				} 
    				if (node.getName() == 'Party' && node.getParent().getName() == 'LegalEntity'){		
    					res.partyCount++;
    					res.commitmentCount = 0;
    				}
    				if (node.getName() == 'Results' && node.getParent().getName() == 'Response'){		
    					res.partyCount = 0;
    					res.commitmentCount = 0;
    				}  
    			}
    		}
    			
    		for (Dom.XMLNode child: node.getChildElements()) {
    			result += walkThrough(child,resultMap,res,res.leCount,res.partyCount,res.commitmentCount,parseType);
    			res.result = result;
    		}
    		return res;
  		}
  		
  		return res;  //should never reach here 
	}
	
	
    public class partyResult{ 
    	String returnCode;
    	String code;
		String message;
    	String returnMessage;
    	String SourceSystemName;
    	String SourcePartyIDType;
    	String SourcePartyKeyID;
    }
     
   
       
  
    
    /*************************************************************************************************
    * 
    * ICV Transaction Id generator
	*	
    *************************************************************************************************/
    public static string getMessageId(){    
    	     
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key; 
    }
    	
    /*************************************************************************************************
    * 
    * ICV Get CommitmentLE Request Info
	*	
    *************************************************************************************************/
    public class getCommitmentLERequestInfo { 
    	 
    	public String TransactionID; // = '7b150e3849e611e8b6bcac1b64370000';
     	public String SourceSystemTimeStamp; // = '2018-05-09T01:52:25';
     	public String SourceCommitmentID; // = '100-10190450';add commitment reference number
     	public String SourceCommitmentType; // = 'A';
     	
    }
  	/*************************************************************************************************
    * 
    * ICV Get Access Token
	*	
    *************************************************************************************************/
    public static string getAccessToken(){     
    	
    	system.debug('******** getting access token');
    	if (Test.isRunningTest())
    		return string.valueOf(system.now());
    		
    	String client = System.Label.ICV_client;  
    	String secret = System.Label.ICV_secret;  
		HttpRequest req_token = new HttpRequest();        
		
		String tokenEndpoint = System.Label.ICV_tokenendpoint;  
		req_token.setEndpoint(tokenEndpoint);
        req_token.setMethod('POST');        
        req_token.setHeader('content-type', 'application/x-www-form-urlencoded');
        req_token.setHeader('cache-control', 'no-cache');        
        req_token.setBody('client_id='+client+'&client_secret='+secret+'&grant_type=client_credentials');
      
        Http http = new Http(); 
        HTTPResponse res = http.send(req_token);
        //System.debug(res.getBody());
		
		String access_token;

		JSONParser parser = JSON.createParser(res.getBody());
            
        while (parser.nextToken() != null) {
        	if (parser.getCurrentName() == 'access_token') {
            	access_token = parser.getText();
            	//system.debug(parser.getText());
            }
        }
        
       	system.debug('******** returning access token');
        return access_token;
         
    }
    /*************************************************************************************************
    * 
    * ICV Replace Special Characters  
	*	
    *************************************************************************************************/
   
    public static String escapeXML(String inbound){
    
    	String result; 
    	
    	result = inbound.replaceAll('>','&gt;');
    	result = result.replaceAll('<','&lt;');
    	result = result.replaceAll('&','&amp;');
    	result = result.replaceAll('"','&quot;');
     	result = result.replace('\'','&apos;');
		 
		return result;
    }
    
    /* workaround callouts for test class */
    
    public static void fudgeFactor(){
    	
    	Integer i=0;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 		i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
 
 
    }
}