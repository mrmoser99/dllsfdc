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
    * getProgram
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
            system.debug(string.valueOf(res1));
			system.debug('result: ' + string.valueOf(res1.getBody()));
	    }
 		catch (exception e){
 			system.debug(e);
 		}
    }

    /*************************************************************************************************
    * 
    * Ratecard Get Access Token
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
    
    
}