/***********************************************************************************************************************
*
* change log:
*
* 9/26/19- MRM - Created
  10/11/19 - MRM - added pep clear 
*
*
*
*************************************************************************************************************************/
global with sharing class CD_CAMSController {
	public static final String RESPONSE_KEYWORD_STATUS = 'Status';
    public static final String RESPONSE_KEYWORD_MESSAGE = 'Message';
    public static final String STATUS_ERROR = 'ERROR';
    public static final String STATUS_SUCCESS = 'SUCCESS';
    
 
     @AuraEnabled
     /******************************************************************************************
    * CLEAR
    *******************************************************************************************/
    public static String clear(Id camsCheckId){
    	
    	Map<String,String> response = new Map<String,String>();
    	
        CAMS_Check__c cc = [SELECT Account_Number__c
                                    ,Application__c
                                    ,Confirmed_PEP__c
                                    ,Customer_LE_Type__c
                                    ,Customer_Name__c
                                    ,Customer_Type__c
                                    ,Distribution_Channel__c
                                    ,Dll_Country__c
                                    ,Geography__c
                                    ,Lease_Signer_First_Name__c
                                    ,Lease_Signer_Last_Name__c
                                    ,Lease_Signer_Title__c
                                    ,LS_Contract__c
                                    ,NAICS__c
                                    ,Name
                                    ,OwnerId
                                    ,Publicly_Traded_Full_Subsidiary__c
                                    ,Publicly_Traded__c
                                    ,Quick_Quote__c
                                    ,Response_Case_Number__c
                                    ,Response_Diligence__c
                                    ,Response_Risk_Rating__c
                                    ,Source_System__c
                                    ,Status__c
                                    ,Transaction_Amount__c
                                    ,Trust__c 
                                    ,missing_data__c
                                    FROM CAMS_Check__c
                     		        where id = :camsCheckId
							        ];

        if (!cc.status__c.contains('Held - High') && !cc.status__c.contains('Held - Medium') ){
    		response.put(RESPONSE_KEYWORD_MESSAGE,'The status must be held H/M to perform a clear!');
            return JSON.serialize(response);
        }

        
    	
        Map<ID,String> applicationMap = new Map<ID,String>();
        applicationMap.put(cc.Application__c,'Clear');

    	CAMSUtility.callCAMS(applicationMap);
		
    	return JSON.serialize(response);
    }

    @AuraEnabled
     /******************************************************************************************
    * RESUBMIT
    *******************************************************************************************/
    public static String resubmit(Id camsCheckId){
    	
    	Map<String,String> response = new Map<String,String>();
    	
        CAMS_Check__c cc = [SELECT Account_Number__c
                                    ,Application__c
                                    ,Confirmed_PEP__c
                                    ,Customer_LE_Type__c
                                    ,Customer_Name__c
                                    ,Customer_Type__c
                                    ,Distribution_Channel__c
                                    ,Dll_Country__c
                                    ,Geography__c
                                    ,Lease_Signer_First_Name__c
                                    ,Lease_Signer_Last_Name__c
                                    ,Lease_Signer_Title__c
                                    ,LS_Contract__c
                                    ,NAICS__c
                                    ,Name
                                    ,OwnerId
                                    ,Publicly_Traded_Full_Subsidiary__c
                                    ,Publicly_Traded__c
                                    ,Quick_Quote__c
                                    ,Response_Case_Number__c
                                    ,Response_Diligence__c
                                    ,Response_Risk_Rating__c
                                    ,Source_System__c
                                    ,Status__c
                                    ,Transaction_Amount__c
                                    ,Trust__c 
                                    ,missing_data__c
                                    FROM CAMS_Check__c
                     		        where id = :camsCheckId
							        ];

        if (!cc.status__c.contains('Held - Data Issue')){
    		response.put(RESPONSE_KEYWORD_MESSAGE,'The status must be Held - Data Issue to resubmit!');
            return JSON.serialize(response);
        }

        if (cc.missing_data__c == true){
    		response.put(RESPONSE_KEYWORD_MESSAGE,'To resubmit, all fields must be filled in!');
            return JSON.serialize(response);
        }
    	
        Map<ID,String> applicationMap = new Map<ID,String>();
        applicationMap.put(cc.Application__c,'Resubmit');

    	CAMSUtility.callCAMS(applicationMap);
		
    	return JSON.serialize(response);
    }
    
    @AuraEnabled
     /******************************************************************************************
    * PEP CLEAR
    *******************************************************************************************/
    public static String pepClear(Id camsCheckId, Cams_check__c cams){
    	
        Map<String,String> response = new Map<String,String>();
    	
        CAMS_Check__c cc = [SELECT Account_Number__c
                                    ,Application__c
                                    ,Confirmed_PEP__c
                                    ,Customer_LE_Type__c
                                    ,Customer_Name__c
                                    ,Customer_Type__c
                                    ,Distribution_Channel__c
                                    ,Dll_Country__c
                                    ,Geography__c
                                    ,Lease_Signer_First_Name__c
                                    ,Lease_Signer_Last_Name__c
                                    ,Lease_Signer_Title__c
                                    ,LS_Contract__c
                                    ,NAICS__c
                                    ,Name
                                    ,OwnerId
                                    ,Publicly_Traded_Full_Subsidiary__c
                                    ,Publicly_Traded__c
                                    ,Quick_Quote__c
                                    ,CAMS_PEP_Indicator__c
                                    ,Response_Case_Number__c
                                    ,Response_Diligence__c
                                    ,Response_Risk_Rating__c
                                    ,Source_System__c
                                    ,Status__c
                                    ,Transaction_Amount__c
                                    ,Trust__c 
                                    ,missing_data__c
                                    FROM CAMS_Check__c
                     		        where id = :camsCheckId
							        ];

        if (!cc.status__c.contains('Held - PEP Hit')){
    		response.put(RESPONSE_KEYWORD_MESSAGE,'The status must be Held - PEP Hit to clear pep hit!');
            return JSON.serialize(response);
        }

        if (cc.missing_data__c == true){
    		response.put(RESPONSE_KEYWORD_MESSAGE,'To clear pep, all fields must be filled in!');
            return JSON.serialize(response);
        }
    	
        if (cams.CAMS_PEP_Indicator__c == 'True'|| cams.CAMS_PEP_Indicator__c == 'False' )
            integer doNothing;
        else{
    		response.put(RESPONSE_KEYWORD_MESSAGE,'A pep choice is required!');
            return JSON.serialize(response);
        }

        genesis__Applications__c a = [select id 
                                    from genesis__Applications__c 
                                    where id = :cc.Application__c
        ];

        a.genesis__status__c = 'CREDIT APPROVED';
        if (cams.CAMS_PEP_Indicator__c == 'True')
            cc.confirmed_pep__c = true;
        else {
            cc.confirmed_pep__c = false;
        }
        
        cc.cams_pep_indicator__c = null;
        
        cc.status__c = 'Manually Cleared OFAC PEP';

        update a;
        update cc;        

    	return JSON.serialize(response);
    }

    @AuraEnabled
    /******************************************************************************************
    * RETURN LIST VIEW ID FOR CAMS CHECK
    *******************************************************************************************/
    public static List<ListView> getListViews() {
        
        List<ListView> listviews =
            [SELECT Id, Name FROM ListView WHERE SobjectType = 'CAMS_Check__c'];

        return listviews;
    }
}
