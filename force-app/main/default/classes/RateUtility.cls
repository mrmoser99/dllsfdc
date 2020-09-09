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
			string accessToken = ICVUtility.getAccessToken();
			
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
    
    
}