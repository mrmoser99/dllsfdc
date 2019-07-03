/********************************************************************************************
* 
*
*  PM_Controller Class - interface for fortimize to call tradup apis
* 
*  Change Log:
*
*  3/21/19 - MRM Created
*  4/25/19 - MRM Status Update
    searchResults - ready
    generateQuotes - ready with message returned
    generateQuotesSOQL - ready with list of lease_olm_quote__c returned
    getQuoteDetail - ready with a return type of lease_olm_quote__c
    getLeaseDetails - working on it

*
*
* 
********************************************************************************************/

public without sharing class PM_Controller {
     
   
    /********************************************************************************************
   	* Search  
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static PMUtility.ServiceContractData searchPortfolio(String customerName
                                    , String contractNumber
                                    , String assetSerialNumber
                                    , Integer size
                                    , String sortOrder
                                    , Boolean assetDetail
                                    , Integer page
                                    , Boolean disableLogging){   
        
        system.debug('contract number is: ' + contractNumber);
        
        return PMCalloutUtility.searchPortfolio(customerName
                                        ,contractNumber
                                        ,assetSerialNumber
                                        ,size
                                        ,sortOrder
                                        ,assetDetail
                                        ,page
                                        ,disableLogging);
        
    }

    /********************************************************************************************
   	* Lease details for a single lease
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static String getLeaseDetailsLeaseFirst(String leaseInfo){   
        
        
        return PMCalloutUtility.getLeaseDetailsLeaseFirst(leaseInfo);
    } 

    /********************************************************************************************
   	* Lease details for a single lease
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static String getLeaseDetails(String leaseInfo){   
        
        
        return PMCalloutUtility.getLeaseDetails(leaseInfo);
    } 

    /********************************************************************************************
   	* Quote List - high level info about generated quotes.  Returns message.
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static PMUtility.TerminationQuoteResponse generateQuotes(String leaseNumber){   
         
        return PMCallOutUtility.generateQuotes(leaseNumber);
        
         
    } 
    

   
}