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

        lList = [select Id
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

    @AuraEnabled(cacheable = true)
    public static List<cllease__Lease_Account__c> filterLeaseList( String searchCustomer, String searchLease, String searchSerial) {
    
        Set<ID> leaseSet = new Set<ID>();
        system.debug('cust: ' + searchCustomer + '-' + 'lease: ' + searchLease + '-' + 'searial: ' + searchSerial);
        if (searchSerial != null){
            List<cllease__Contract_Equipment__c> eList =    [select cllease__Contract__c
                                                             from cllease__Contract_Equipment__c
                                                             where Serial_Number__c = :searchSerial
                                                            ];                                              
            for (cllease__Contract_Equipment__c e:eList)                                               
                leaseSet.add(e.cllease__Contract__c);
        }

        String searchQuery = '';

        searchQuery = 'select Id ' + 
                ',Name ' +
                ',cllease__Account__r.Name ' +
                ',Total_Monthly_Payment__c ' +
                ',cllease__Term__c ' +
                ',Remaining_Payments__c ' +
                ',Equipment_Count__c ' +
                ',Billing_Address_Line_1__c ' +
                ',City__c ' +
                ',State__c ' +
                ',Zip_Code__c ' +
                'From cllease__Lease_Account__c '; 
                 
                
        
        if (leaseSet.size() > 0){
            searchQuery += ' where id in ';
            String leaseSetString = ' (';
            Integer j=0;
            for (Id i:leaseSet){
                j++;
                leaseSetString += '\'' +  i + '\'';
                if (j != leaseSet.size())
                    leaseSetString += ' , ';
            }  
       
            leaseSetString += ')';
        
            searchQuery += leaseSetString;
        }
        else{
            searchQuery += ' where name = ' + '\'' + 'nowayman' + ' \'';
        }

        if (searchCustomer != null && searchCustomer != '') 
            searchQuery +=  ' or  cllease__Account__r.Name like ' + '\'' + '%' + searchCustomer + '%' + '\'';
        
            
        if (searchLease != null && searchLease != '')
            searchQuery += ' or  Name like ' + '\'' + '%' + searchLease + '%' + '\'';
             
        searchQuery +=  'order by Remaining_Payments__c asc, cllease__Maturity_Date__c asc ';
        
        List<cllease__Lease_Account__c> rLIst = new List<cllease__Lease_Account__c>();
        
        system.debug('Search query is:' + searchQuery);

        rList = Database.query(searchQuery);

        return rList;
    }

    @AuraEnabled(cacheable = true)
    public static void getQuotes(String leaseId) {

        
    }

}