/*******************************************************************************************************************
*   PM CALLOUT UTILITY
*
* 
*	Change Log: 
*	5/14/19 - Created
*
*   Implements callouts for tradeups,false,false) ;
 
* 
********************************************************************************************************************/
public with sharing class PMCalloutUtility {

   	/********************************************************************************************
   	* Send Request to ICS
   	* 
   	********************************************************************************************/
   	public static  PMUtility.ServiceContractData searchPortfolio(String customerName
                                    , String customerNumber
                                    , String assetSerialNumber
                                    , Integer size
                                    , String sortOrder
                                    , Boolean assetDetail
                                    , Integer page){
        
        PMUtility.ServiceContractData myResponse = new PMUtility.ServiceContractData();

        System.HttpResponse response;
        System.HttpRequest request = new System.HttpRequest();
        
        request.setTimeout(120000);
    	
  
        String requestParms = '?assetDetail=TRUE';
        
        if (customerName != null)
            requestParms +='&customerName=' + customerName;
        
        
        if (customerNumber != null)
            requestParms +='&customerNumber=' + customerNumber;                  
        

        if (assetSerialNumber != null)
            requestParms +='&assetSerialNumber=' + assetSerialNumber;     
        
        
        if (sortOrder !=null)
            requestParms += '&sort=' + sortOrder;

        if (page != null)
            requestParms += '&page=' + page;

        if (size != null)
            requestParms += '&size=' + size;

        request.setEndpoint(System.Label.PM_Endpoint + '/americas/v1/partnerportfolio' + requestParms);
    	request.setHeader('Content-Type', 'application/json'); 
        request.setHeader('Authorization', 'Bearer '+ PMUtility.getAccessToken());
    	request.setMethod('GET');
    	
    	response = new System.Http().send(request); 
    
        if (response.getStatusCode() == 200){ 

            myResponse = (PMUtility.ServiceContractData) System.JSON.deserialize(response.getBody(),PMUtility.ServiceContractData.class);

        }   
       
	    system.debug(System.Label.PM_Endpoint + '/americas/v1/partnerportfolio' + requestParms);
        return myResponse;
   	}
}