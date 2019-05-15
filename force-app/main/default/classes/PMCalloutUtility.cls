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
        
        customerName = customerName.trim();
        customerNumber = customerNumber.trim();
        assetSerialNumber = assetSerialNumber.trim();
        sortOrder = sortOrder.trim();

        if (customerName != null && customerName != ''){
            customerName = '*' + customerName + '*';
            customerName = customerName.replace(' ','*');
            requestParms +=  '&customerName=' +  customerName;
        }
        
        if (customerNumber != null && customerNumber != '')
            requestParms +='&customerNumber=' + customerNumber;                  
        

        if (assetSerialNumber != null && assetSerialNumber != '')
            requestParms +='&assetSerialNumber=' + assetSerialNumber;     
        
         
        if (sortOrder !=null && sortOrder != '')
            requestParms += '&sort=' + sortOrder;
        else {
            requestParms += '&sort=' + 'numberOfRemainingPayments,customerName';
        }

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
            
            for (PMUtility.Data d:myResponse.data){
                d.newCoReady = 'true';

                if (d.assetDetail.size() == 1)
                    d.equipmentDescription = d.assetDetail.size() + ' Line of Equipment';
                else
                    d.equipmentDescription = d.assetDetail.size() + ' Lines of Equipment';
            }
        }   
       
	    system.debug(System.Label.PM_Endpoint + '/americas/v1/partnerportfolio' + requestParms);
        return myResponse;
   	}
}