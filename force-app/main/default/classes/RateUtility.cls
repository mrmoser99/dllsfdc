/*********************************************************************************************
*
* NewCo Rate Utility - used to get rate cards from mosaic   
*
* Change Log:
*
* 9/4/2020 - MRM Created
**********************************************************************************************/
global without sharing class RateUtility { 
    
     

    /*************************************************************************************************
    * 
    * getProgram  - using an oracle vendor id you can get a program which contains rate cards
	*	
	*************************************************************************************************/
    public static void getProgram( String oracleVendorId){    	
	  								
		try{ 
			string accessToken = getAccessToken();
			
			system.debug('at:' + accessToken);
			
			HttpRequest reqAPI = new HttpRequest();  
			
            //https://apiacc.dllgroup.com/vf/us/v1/partner-insight/Details/447843-0001
            
            string endpoint = 'https://apiacc.dllgroup.com/vf/us/v1/partner-insight/Details/447843-0001';

            system.debug('endpoint is: ' + endpoint);
        	//reqAPI.setEndpoint('https://' + System.Label.ICVDomain + '.dllgroup.com/vf/us/v1/partner-insight/Details/447843-0001');
        	reqAPI.setEndpoint(endpoint); 
            reqAPI.setMethod('GET');   
            reqAPI.setHeader('originatorId', 'MOSAIC');    
            reqAPI.setHeader('messageId', '11115');   
            reqAPI.setHeader('Accept', 'application/json');
            reqAPI.setHeader('Charset', 'UTF-8');
            reqAPI.setHeader('Content-Type', 'application/json');
            reqAPI.setHeader('Authorization', 'Bearer '+ accessToken);
        	reqAPI.setTimeout(120000);
        	
			Http http1 = new Http();
	    	HTTPResponse res1 = http1.send(reqAPI); 
            
            if (test.isRunningTest()){
                String tempResults = '{"olmVendorSiteId":"447843-0001","salesRep": [{"firstName":"Joe","lastName":"Dickinson","IsSecondary":null,"atsUserCode":"10666","phone":"6103865000","olmFndID":"925964","isPrimary":true,"networkUserName":"DICKINSONJ","email":"fmdllqatestevent@dllgroup.com"},{"firstName":"Jay","lastName":"Decker","IsSecondary":true,"atsUserCode":"10607","phone":"6103865808","olmFndID":"905079","isPrimary":null,"networkUserName":"DECKERJ","email":"fmdllqatestevent@dllgroup.com"}],"isTelephoneVerificationRequired":false,"usage": [{"identifiers": [{"sourceSystem":"LOANPATH","identifierValue":"3797-1-BILL_TO","identifierType":"LP_PARTY_SITE_USE_ID"},{"sourceSystem":"ORACLE","identifierValue":"55550699","identifierType":"TCA_PARTY_SITE_USE_ID"},{"sourceSystem":"ORACLE","identifierValue":"8210058","identifierType":"TCA_CUST_ACCT_SITE_USE_ID"},{"sourceSystem":"ORACLE","identifierValue":"47306205","identifierType":"TCA_PARTY_SITE_ID"},{"sourceSystem":"LOANPATH","identifierValue":"3797-1-BILL_TO","identifierType":"LP_CUST_ACCT_SITE_USE_ID"}],"name":"BILL_TO","description":"Bill To"},{"identifiers": [{"sourceSystem":"LOANPATH","identifierValue":"3797-1-PAY_TO","identifierType":"LP_PARTY_SITE_USE_ID"},{"sourceSystem":"LOANPATH","identifierValue":"3797-1-PAY_TO","identifierType":"LP_CUST_ACCT_SITE_USE_ID"}],"name":"PAY_TO","description":"Pay To"}],"ouKey":"DLL","program": [{"overrideSoftCosts":false,"sbuKey":"2","privateLabel": [{"isDefaultInvoice":true,"isDefault":true,"documents":true,"name":"DE LAGE LANDEN FINANCIAL SERVICES, INC.","isDefaultDocument":true,"ID":"1004","invoice":true}],"softCostList": [],"name":"OE_VENDOR","overridePromotions":false,"rateCardId":"1000","ID":"1000","overridePrivateLabel":true}],"isActive":true,"PhoneCountryCode":"","salesSupportRep": [{"firstName":"Justin","lastName":"Conrad","atsUserCode":"C70","phone":"6103865000","olmFndID":"276345","isPrimary":null,"networkUserName":"CONRADJ","email":"fmdllqatestevent@dllgroup.com"}],"legacyId":"","ID":"3797-1","isPassThroughEligible":false,"email":"","isPrimarySite":true,"funding":{"paymentMethodCode":"2","preferredFundingSite":{"funding":{"paymentMethodCode":"","deliveryMethod":""},"address":{"country":"","salesTaxAreaId":"","city":"","postalCode":"","county":"","stateProvince":"","line2":"","line1":""},"partner":{"dba": [{"name":"Verizon Basking Ridge"}],"name":"Verizon Basking Ridge"},"phone":"","identifiers": [{"sourceSystem":"ORACLE","identifierValue":"","identifierType":"VENDOR_SITE_CODE"}],"name":"","ID":""},"maximumPoints":60.000,"deliveryMethod":"1","defaultPoints":0.000,"cpcUsageEligible":false},"address":{"country":"US","salesTaxAreaId":"310350266","city":"BASKING RIDGE","postalCode":"07920-1025","county":"SOMERSET","stateProvince":"NJ","line2":"","line1":"1 VERIZON WAY"},"identifiers": [{"sourceSystem":"ORACLE","identifierValue":"790909","identifierType":"AP_VENDOR_SITE_ID"},{"sourceSystem":"LOANPATH","identifierValue":"3797-1","identifierType":"LP_PARTY_SITE_ID"},{"sourceSystem":"LOANPATH","identifierValue":"3797-1","identifierType":"LP_VENDOR_SITE_ID"},{"sourceSystem":"ORACLE","identifierValue":"60094572","identifierType":"TCA_LOCATION_ID"},{"sourceSystem":"ORACLE","identifierValue":"47306205","identifierType":"TCA_PARTY_SITE_ID"},{"sourceSystem":"ORACLE","identifierValue":"3984608","identifierType":"TCA_CUST_ACCT_SITE_ID"},{"sourceSystem":"LOANPATH","identifierValue":"3797-1","identifierType":"LP_CUST_ACCT_SITE_ID"},{"sourceSystem":"ORACLE","identifierValue":"447843-0001","identifierType":"VENDOR_SITE_CODE"}],"timeStamp":"2020-09-11 01:28:21","isDisqualified":false,"partner":{"preferredCustomerInvoiceDueDate":null,"dba": [{"name":"Verizon Basking Ridge"}],"priorityRating":"","isTelephoneVerificationRequired":false,"isAPHold":false,"identifiers": [{"sourceSystem":"ORACLE","identifierValue":"17204120","identifierType":"AP_VENDOR_ID"},{"sourceSystem":"ICV","identifierValue":"1597355824409275","identifierType":"ICV_PARTY_ID"},{"sourceSystem":"LOANPATH","identifierValue":"3797","identifierType":"LP_PARTY_ID"},{"sourceSystem":"LOANPATH","identifierValue":"3797","identifierType":"LP_VENDOR_ID"},{"sourceSystem":"ORACLE","identifierValue":"44604243","identifierType":"TCA_PARTY_ID"},{"sourceSystem":"LOANPATH","identifierValue":"3797","identifierType":"LP_CUST_ACCT_ID"},{"sourceSystem":"ORACLE","identifierValue":"38622120","identifierType":"TCA_CUST_ACCT_ID"},{"sourceSystem":"ORACLE","identifierValue":"447843","identifierType":"VENDOR_CODE"}],"isSingleApp":false,"isActive":true,"classification": [{"name":"1","description":"Originating Partner"}],"name":"Verizon Basking Ridge","isBookingHold":false,"ID":"3797","isWatchList":false,"olmVendorId":"447843"},"phone":"9802517035","name":"Verizon Basking Ridge","correspondent": [{"firstName":"Joe","lastName":"Dickinson","isAutoSend":true,"correspondenceType": [{"description":"Approval Package","ID":"1"},{"description":"Decline Package","ID":"2"},{"description":"Additional Information Package","ID":"4"}],"email":"fmdllqatestevent@dllgroup.com"},{"firstName":"Jay","lastName":"Decker","isAutoSend":true,"correspondenceType": [{"description":"Approval Package","ID":"1"},{"description":"Decline Package","ID":"2"},{"description":"Additional Information Package","ID":"4"}],"email":"fmdllqatestevent@dllgroup.com"},{"firstName":"Justin","lastName":"Conrad","isAutoSend":true,"correspondenceType": [],"email":"fmdllqatestevent@dllgroup.com"}],"isWatchList":false,"IsUsageEligible":false}';
                processResults(res1);
            }
            else{
                Account a = [select id, name from Account where Oracle_Vendor_ID__c = :oracleVendorId];
                List<String> sList = processResults(res1);
                system.debug('List of rate card ids is: ' + sList );
                getRateCard(sList,a);
            }
        }
 		catch (exception e){
 			system.debug(e);
 		}
    }

    /*************************************************************************************************
    * 
    * getRateCards - get all rate cards for program
	*************************************************************************************************/
    public static void getRateCard(List<String> rateCards, Account a){    	
	  								
		try{ 
			string accessToken = getAccessToken();
			
			system.debug('at:' + accessToken);
			
			HttpRequest reqAPI = new HttpRequest();  
			
            string endpoint = 'https://apiacc.dllgroup.com/vf/us/v1/ratecards/1080/ratefactors';

            system.debug('endpoint is: ' + endpoint);
        	 
        	reqAPI.setEndpoint(endpoint); 
            reqAPI.setMethod('POST');   
            reqAPI.setHeader('originatorId', 'MOSAIC');    
            reqAPI.setHeader('messageId', '11115');   
            reqAPI.setHeader('Accept', 'application/json');
            reqAPI.setHeader('Charset', 'UTF-8');
            reqAPI.setHeader('Content-Type', 'application/json');
            reqAPI.setHeader('Authorization', 'Bearer '+ accessToken);
            reqAPI.setBody('{"data": {"effDate": "2018-08-01","excludeExpired": false,"includeRateFactorDetails": true,"includeType": "REGULAR","paymentFrequency": "M","paymentTiming": "ADVANCE","rateType": "PRICING","softCostAllowancePct": 0}}');
        	reqAPI.setTimeout(120000);
        	
			Http http1 = new Http();
	    	HTTPResponse res1 = http1.send(reqAPI); 
           
            system.debug('Rate Card Detail: ' + res1.getBody());

            RateCardDetailsJSON2Apex result = RateCardDetailsJSON2Apex.parse(string.valueOf(res1.getBody()));
            
            populateRateCards(result,a);

            for (RateCardDetailsJSON2Apex.Data d:result.data){
                system.debug('=================================>');
                system.debug('Rate Card Id: ' + d.id + ' Rate Card Name: ' + d.name);
                system.debug('Rate Card Details....' + d);
                system.debug('*****************************************************************\n');
                List<RateCardDetailsJSON2Apex.RateFactors> rateFactorList = d.rateFactors;
                for (RateCardDetailsJSON2Apex.RateFactors f: rateFactorList){
                    system.debug('id: ' + f.id + ' term: ' + f.term + ' min: ' + f.minAmount + ' max: ' + f.maxAmount + ' actual factor: ' + f.rateFactorAmount);
                   
                }
                system.debug('*****************************************************************\n');
            }
    
           
           
        }
 		catch (exception e){
 			system.debug(e);
 		}
    }


    /*************************************************************************************************
    * 
    * Process GetProgram Results
 	*	
    *************************************************************************************************/
    public static List<String> processResults(HTTPResponse res1){     

        List<String> results = new List<String>();

        RateCardAccountJSON2Apex result = RateCardAccountJSON2Apex.parse(string.valueOf(res1.getBody()));
        
        system.debug(result.program);
        for (RateCardAccountJSON2Apex.program p:result.program){
            results.add(p.rateCardId); 
        }

        return results;

    }
    
    /*************************************************************************************************
    * 
    * Ratecard Get Access Token - these are different than icv.
	*	
    *************************************************************************************************/
    public static string getAccessToken(){     
    	
    	system.debug('******** getting access token');
    	if (Test.isRunningTest())
    		return string.valueOf(system.now());
    		
    	String client = System.Label.Ratecard_Client;  
    	String secret = System.Label.Ratecard_Client_Secret;  
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
    * Populate Rate Cards
 	*	
    *************************************************************************************************/
    public static void populateRateCards( RateCardDetailsJSON2Apex result, Account a){  
    
        genesis__Company__c c = [select id from genesis__Company__c where name = 'DeLage Landen'];

        List<genesis__Rate_Card_Setup_Header__c> hList = new List<genesis__Rate_Card_Setup_Header__c>();
        List<genesis__Rate_Card_Setup_Detail__c> insertRdList = new List<genesis__Rate_Card_Setup_Detail__c>();

        for (RateCardDetailsJSON2Apex.Data d:result.data){

            system.debug('=================================>');
            system.debug('Rate Card Id: ' + d.id + ' Rate Card Name: ' + d.name);
            system.debug('Rate Card Details....' + d);
            system.debug('*****************************************************************\n');
            /*
             softCostAllowancePct;
	        */
            genesis__Rate_Card_Setup_Header__c h = new genesis__Rate_Card_Setup_Header__c();
            h.name = d.name;
            h.genesis__Product_Type__c = 'LEASE';
            h.genesis__Company__c = c.id;
            h.genesis__Description__c = d.description;
            h.genesis__Enabled_Flag__c = true;
            h.Rate_Card_Id__c = d.rateCardId;
            h.Rate_Id__c = d.id;
            h.Rate_Card_Name__c = d.rateCardName;
            h.Subsidy_Id__c = d.subsidyId;
            h.Promotion_Id__c = d.promotionId;
            h.Payment_Frequency__c = d.paymentFrequency;
            h.Payment_Timing__c = d.paymentTiming;
            h.purchase_option__c = d.purchaseOption;
            h.No_Advance_Payments__c = d.noAdvancePayments;
            h.No_Deferred_Payments__c = d.noDeferredPayments;
            h.Rate_type__c = d.rateType;
            h.Soft_Cost_Allowance_Pct__c = d.softCostAllowancePct;
            h.no_security_deposits__c = d.noSecurityDeposits;
            h.fee_included__c = d.feeIncluded;
            h.grandfather_date__c = d.grandFatherDate;
            h.genesis__Start_Date__c = date.valueOf(d.effDate);
            h.genesis__End_Date__c = date.valueOf('2021-10-31');//date.valueOf(d.expDate);
            h.genesis__Transaction_Date__c = date.today();

            insert h;
            /*
	    
		    public String id; xxx
		    public String name; xxx
		    public String description; xxx
		    public String rateCardId;    yyyy
		    public String rateCardName;  yyy
		    public String subsidyId;    yyy 
		    public String promotionId;
		    public String paymentFrequency;  yyy
		    public String paymentTiming;   yyyy
		    public String purchaseOption;   yyyy
		    public String noAdvancePayments;   yyyy
		    public String noDeferredPayments;    yyy
		    public String rateType; yyy
		    public String softCostAllowancePct;  yyy
		    public String noSecurityDeposits;   yyy
		    public String feeIncluded;  yyy 
		    public String effDate;   xxx
		    public String expDate;    xxx
		    public String grandFatherDate; yyy
		    public List<RateFactors> rateFactors;  xxx
            */


            clcommon__CL_Product__c pr = new clcommon__CL_Product__c();
            pr.rate_card_id__c = d.rateCardId;
            pr.dealer__c = a.id;
            pr.clcommon__Product_Name__c = a.name + ' (' + d.rateCardId + ')';
            pr.clcommon__Asset_Class__c = [select id from clcommon__asset_class__c where name = 'Office Equipment'].id;
            pr.clcommon__Class__c = 'Commercial';
        
            insert pr;

            genesis__Product_Rate_Card_Association__c rca = new genesis__Product_Rate_Card_Association__c();
            rca.genesis__CL_Product__c = pr.id;
            rca.genesis__Rate_Card_Setup__c = h.id;

            insert rca;

            List<RateCardDetailsJSON2Apex.RateFactors> rateFactorList = d.rateFactors;
            for (RateCardDetailsJSON2Apex.RateFactors f: rateFactorList){
                system.debug('id: ' + f.id + ' term: ' + f.term + ' min: ' + f.minAmount + ' max: ' + f.maxAmount + ' actual factor: ' + f.rateFactorAmount);
                /*
                    public class RateFactors {
		            public String id; xxx
		            public String groupId;      
		            public String term; xxx
		            public String minAmount; xxx
		            public String maxAmount; xxx
		            public String rateFactorAmount; xxx
		        */
                genesis__Rate_Card_Setup_Detail__c rd = new genesis__Rate_Card_Setup_Detail__c();
                rd.rate_id__c = f.id;
                rd.genesis__Rate_Card_Setup_Header__c = h.id;
                rd.genesis__Days_Convention__c = '30/360'; //????
                rd.genesis__Maximum_Financed_Amount__c = decimal.valueOf(f.maxAmount);
                rd.genesis__Minimum_Financed_Amount__c = decimal.valueOf(f.minAmount);
                rd.genesis__Enabled_Flag__c = true;
                rd.genesis__Rate_Factor__c = decimal.valueOf(f.rateFactorAmount);
                rd.genesis__Term__c = decimal.valueOf(f.term);
                rd.group_id__c = f.groupId;
                rd.genesis__Residual_Type__c = 'FAIR MARKET VALUE';
                if (d.paymentFrequency == 'M')
                    rd.genesis__Payment_Frequency__c = 'MONTHLY';
                else
                if (d.paymentFrequency == 'Q')
                    rd.genesis__Payment_Frequency__c = 'QUARTERLY';
                else
                if (d.paymentFrequency == 'A')
                    rd.genesis__Payment_Frequency__c = 'ANNUALLY';
                
                insertRdList.add(rd);
  
            }
        }

        if (!insertRdList.isEmpty())
            insert insertRdList;
    }   
    
    
}