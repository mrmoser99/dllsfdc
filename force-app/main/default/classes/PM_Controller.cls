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
     
   
    @AuraEnabled
    public static String searchResults {get;set;} 
    /********************************************************************************************
   	* Search  
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static PMUtility.ServiceContractData searchPortfolio(String customerName
                                    , String customerNumber
                                    , String assetSerialNumber
                                    , Integer size
                                    , String sortOrder
                                    , Boolean assetDetail
                                    , Integer page){   
        
        return PMCalloutUtility.searchPortfolio(customerName
                                        ,customerNumber
                                        ,assetSerialNumber
                                        ,size
                                        ,sortOrder
                                        ,assetDetail
                                        ,page);
        
    }

    /********************************************************************************************
   	* Lease details for a single lease
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static String getLeaseDetails(String leaseNumber){   
         
        return PMUtility.getLeaseDetails(leaseNumber);
    } 

    /********************************************************************************************
   	* Quote List - high level info about generated quotes.  Returns message.
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static PMUtility.TerminationQuoteResponse generateQuotes(String leaseNumber){   
        
        return PMUtility.generateQuotes(leaseNumber);
        
         
    } 
    /********************************************************************************************
   	* Quote List - high level info about generated quotes except list of quotes returned instead
    *       of message
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static List<Lease_OLM_Quote__c> generateQuotesSOQL(String leaseNumber){   
        
        return PMUtility.generateQuotesSOQL(leaseNumber);
        
         
    } 

    /********************************************************************************************
   	* Quote Detail - detail inquiry information for a single quote
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static Lease_OLM_Quote__c getQuoteDetail(String quoteNumber){   
        
        return PMUtility.getQuoteDetail(quoteNumber);
    } 

    /********************************************************************************************
   	* Book Lease - calls the olm book lease process
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static boolean processOLMBooking(String leaseNumber, String quoteNumber, Decimal amount) {   
        
        return PMUtility.processOLMBooking(leaseNumber,quoteNumber,amount);
         
    } 

    
}