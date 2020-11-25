/***********************************************************************************************************************
*
* change log:
*
* 11/24/2020 - MRM Created Class
* 
*
*
*
*************************************************************************************************************************/
global with sharing class FMZ_SubmitQuoteNewcoController {
	public static final String RESPONSE_KEYWORD_STATUS = 'Status';
    public static final String RESPONSE_KEYWORD_MESSAGE = 'Message';
    public static final String STATUS_ERROR = 'ERROR';
    public static final String STATUS_SUCCESS = 'SUCCESS';
    
    @AuraEnabled
    /*********************************************************************************************************
    *
    * This is the code to populated rates for an account
    *
    **********************************************************************************************************/
    public static String test(Id accountId) {
        
        Boolean error = false;

        Account a = [select mosaic_primary_id__c from Account where id = :accountId];

        Map<String,String> response = new Map<String,String>();


		if (a.mosaic_primary_id__c  == null){
			response.put(RESPONSE_KEYWORD_MESSAGE,'A mosaic primary id is required to update rates!');
    		error=true;
        }

        if (error){
            if (!test.isRunningTest())
               return JSON.serialize(response);
        }
       
        
        String callOutCode = RateUtility.getProgram(a.mosaic_primary_id__c);
           
        if (!callOutCode.contains('OK')){
            response.put(RESPONSE_KEYWORD_MESSAGE,'FATAL ERROR ' + callOutCode);
    		error=true;
        }

        if (error){
            if (!test.isRunningTest())
               return JSON.serialize(response);
        }
        
        return JSON.serialize(response);
    }

	
}