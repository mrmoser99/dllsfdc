/*******************************************************************************************************************
*   DOCUSIGN UTILITY CLASS
*
* 
*	Change Log: 
*	2/26/19 - MRM Created
    
********************************************************************************************************************/
public with sharing class DocusignUtil {
	
	/********************************************************************************************
   	* getDocusignAccessToken
   	* 
   	********************************************************************************************/
		public static String getDocusignAccessToken(){ 

			Docusign_Auth__c d = [select private_key__c from Docusign_Auth__c where name = 'Newco']	;

	        JWT j = new JWT('RS256');
        	/* this is the private key from docusign for the Newco application */
        	j.pkcs8 = d.private_key__c;
        	/* integrator key */
			j.iss =  System.Label.Docusign_Integrator_Key;
	    	/* sample user id newcodocusigndev@dllgroup.com */
        	j.sub = System.Label.Docusign_Run_As_User_GUI;
        	/* audience */
			j.aud = System.Label.Docusign_Audience;
	    	/* scope */
        	j.scope = 'signature';

        	return JWTBearerFlow.getAccessToken(System.Label.Docusign_Oauth_Token_URL, j);
			

	   	}  
    /********************************************************************************************
   	* remove recipient
   	* 
   	********************************************************************************************/
	   @future (callout=true) 
	   public static void removeRecipient(String env, String recipient){   

		// sample call
		//	https://demo.docusign.net/restapi/v2/accounts/9816c6c8-e255-4b24-81c7-27bd2c126e57/envelopes/8D0B36E2-6B99-44C6-BCF7-6854564C393C/recipients/3C718B48-A7AF-4EF7-BF7D-8B8FE23EE081
		
		
        String ep= System.Label.Docusign_Rest_API_URL + '/accounts/' + System.Label.Docusign_Account_GUI + '/envelopes/' + env + '/recipients/' + recipient;

		HttpRequest req = new HttpRequest();
		HTTPResponse res;
        req.setMethod('DELETE'); 
		req.setEndpoint(ep);
		req.setHeader('Authorization', 'Bearer '+ DocusignUtil.getDocusignAccessToken());
        req.setHeader('Content-Type','application/json');
        try{
			Http http = new Http();
			res = http.send(req);
			system.debug('response is:' + res);
			system.debug('body:' + res.getBody());
		}
		catch (exception e){
			cllease__Batch_Process_Log__c log = new cllease__Batch_Process_Log__c(
				 name = 'Docusign removeRecipients'
				,cllease__Message__c = 'Error is: ' + res
			);
			insert log;
		}
		 
	
		if (res.getStatus() != 'OK'){
			cllease__Batch_Process_Log__c log = new cllease__Batch_Process_Log__c(
				name = 'Docusign removeRecipients'
			   ,cllease__Message__c = 'Error is: ' + res + ' status: ' + res.getStatusCode()
		   );
		   insert log;

		}
		else{

			System.JSONParser parser = System.JSON.createParser(res.getBody());


			String status;
        	while (parser.nextToken() != null) {
            	if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')) {
					parser.nextToken();
					status = parser.getText();
               	 	system.debug(parser.getText());
                	break;
				}
			
			}
			system.debug('Status is: ' + status);
			if (status != 'deleted'){
				cllease__Batch_Process_Log__c log = new cllease__Batch_Process_Log__c(
					 name = 'Docusign removeRecipients'
			   		,cllease__Message__c = 'Error is: ' + res.getBody()
		   		);
		   		insert log;
			}
		}
			
	}
		
	/*
		ok response:
		{
 		 "signers": [
    		{
      	"creationReason": "sender",
      	"recipientId": "3c718b48-a7af-4ef7-bf7d-8b8fe23ee081",
      	"routingOrder": "0",
     	 "status": "deleted"
    	}
  			],
  		"agents": [],
  		"editors": [],
  		"intermediaries": [],
  		"carbonCopies": [],
  		"certifiedDeliveries": [],
  		"inPersonSigners": [],
  		"seals": [],
  		"witnesses": [],
  		"recipientCount": "1"
			}
	*/
	
	
	/*

		error response:
		{
  		"signers": [
	    {
     	 "creationReason": "sender",
      	"recipientId": "3c718b48-a7af-4ef7-bf7d-8b8fe23ee081",
      	"routingOrder": "",
      	"status": "",
      	"errorDetails": {
        "errorCode": "RECIPIENT_NOT_FOUND_FOR_CORRECTION",
        "message": "The specified User is not a recipient of the specified envelope.  Recipient not found in envelope."
    	  }
    	}
  		],
  		"agents": [],
  	"editors": [],
  	"intermediaries": [],
  	"carbonCopies": [],
  	"certifiedDeliveries": [],
  	"inPersonSigners": [],
  	"seals": [],
  	"witnesses": [],
  	"recipientCount": "1"	
	}	
	*/

}
