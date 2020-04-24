/*******************************************************************************************************************


*
********************************************************************************************************************/
global class DocuSign {
	 
	/* Define the structure to hold the response from ICS */
	 
	
    global class Results {
        
    	webservice String access_token;
	}
	    
   	
	/*******************************************************************************************************************
	*	SUBMIT ICS RESPONSE   
	*	This is the main call. Results of the ICS Response are stored in the database 
	*   The quick quote credit status will be updated as a result of this call.
	********************************************************************************************************************/
   	webService static string DocuSignResponse(Results results){
		
        system.debug('******************* results: ' + results);
        
        return null;
    }
    
}