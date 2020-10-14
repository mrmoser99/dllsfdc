/*************************************************************************************************** 
*
* NewcoPortfolioUtility

 Change Log:

 10/14/2020 - MRM Created Class to support the newco porfolio list
*
******************************************************************************************************/

public with sharing class NewcoPortfolioUtility {

	
    @AuraEnabled(cacheable = true)
    public static List<cllease__Lease_Account__c> getLeaseList(String refreshExecute) {
                        
         
        List<cllease__Lease_Account__c> lList = new List<cllease__Lease_Account__c>();

        lList = [select id
                ,name
                From cllease__Lease_Account__c
                ];

            
        return lList;
    }

}