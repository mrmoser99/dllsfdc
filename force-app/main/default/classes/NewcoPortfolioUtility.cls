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
                ,Name
                ,cllease__Account__r.Name
                ,Total_Monthly_Payment__c
                ,cllease__Term__c
                ,Remaining_Payments__c
                ,Equipment_Count__c
                ,Billing_Address_Line_1__c
                ,City__c
                ,State__c
                ,Zip_Code__c
                From cllease__Lease_Account__c
                order by Remaining_Payments__c asc, cllease__Maturity_Date__c asc
                ];

            
        return lList;
    }

}