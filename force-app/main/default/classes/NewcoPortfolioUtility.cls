/*************************************************************************************************** 
*
* NewcoPortfolioUtility

 Change Log:

 10/14/2020 - MRM Created Class to support the newco porfolio list
 11/18/2020 - MMR Added class to support download of portfolio - leaselistforportfolio
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
    public static List<cllease__Termination_Quote_Header__c> getQuoteList(String refreshExecute) {
                        
         
        List<cllease__Termination_Quote_Header__c> hList = new List<cllease__Termination_Quote_Header__c>();
        
        Map<String,String> appQuote = new Map<String,String>();
        Set<String> appSet= new Set<String>();

    
        hList = [SELECT Id
           , cllease__Contract__r.cllease__Account__r.name
            , cllease__Contract__r.cllease__Lease_Status__c
            , cllease__Effective_To__c
            , cllease__Contract__r.name
            , cllease__Quote_Amount__c
            , cllease__Status__c
            , cllease__Quote_Type__c
            , CreatedDate
            , QUOTE_ESTIMATED_SALES_TAX__c
            , Equipment_Price__c
            , Remaining_Payments__c
            , quick_quote_name__c
            , QUOTE_ESTIMATED_PROPERTY_TAX__c
            , QUOTE_FEE__c
            , QUOTE_SERVICE_AND_MAINTENANCE__c
            , cllease__Contract__r.Application_Number__c 
            , Name 
            FROM cllease__Termination_Quote_Header__c
            order by name desc
            limit 100
        ];

        for (cllease__Termination_Quote_Header__c h: hList)
            appSet.add(h.cllease__Contract__r.Application_Number__c);

        List<genesis__Quick_Quotes__c> qqList = [select name, genesis__application__r.name 
            from genesis__Quick_Quotes__c where genesis__application__r.name  in :appSet];

        for (genesis__Quick_Quotes__c  qq:qqList)
            appQuote.put(qq.genesis__application__r.name,qq.name);

        for (cllease__Termination_Quote_Header__c h:hList){
            h.quick_quote_name__c = appQuote.get(h.cllease__Contract__r.Application_Number__c);
            system.debug('assigning qq - '  + appQuote.get(h.cllease__Contract__r.Application_Number__c) + ' to ' + h.name );
        }

        return hList;
    }

    @AuraEnabled(cacheable = false)
    public static List<cllease__Contract_Equipment__c> getLeaseListForPortfolio(String refreshExecute) {
                        
        /*  needed values
        Customer Name
                Lease Number
                Billing Address Line 1
                Billing City
                Billing State
                Billing Zip Code
                Type
                Term
                Payment Frequency
                Purchase Option
                Start Date
                Contract Maturity Date
                Total Amount Financed
                Base Payment Amount
                Contract Signer
                Signer Title
                Remaining Payments
                Last Payment Received Date
                Address Line 1
                Address Line 2
                City
                ZIP
                State
                Asset Number
                Make
                Model
                Serial Number

        */
        List<cllease__Contract_Equipment__c> lList = new List<cllease__Contract_Equipment__c>();

        lList = [select  id
                        ,Name 
                        ,Serial_Number__c
                        ,Total_Equipment_Cost__c
                        ,Rent_Amount__c
                        ,Manufacturer__c
                        ,cllease__Model__c
                        ,City_InstallAddress__c
                        ,Install_Address_Line_1__c
                        ,Install_Address_Line_2__c
                        ,State__c
                        ,Zip_Code_InstallAddress__c
                        ,cllease__Account__r.Name 
                        ,cllease__Contract__r.Name  
                        ,cllease__Contract__r.cllease__Account__r.Name 
                        ,cllease__Contract__r.cllease__Term__c
                        ,cllease__Contract__r.Total_Monthly_Payment__c
                        ,cllease__Contract__r.Remaining_Payments__c
                        ,cllease__Contract__r.Equipment_Count__c
                        ,cllease__Contract__r.Billing_Address_Line_1__c
                        ,cllease__Contract__r.City__c
                        ,cllease__Contract__r.State__c
                        ,cllease__Contract__r.Zip_Code__c
                        ,cllease__Contract__r.cllease__Residual_Type__c  //FMV
                        ,cllease__Contract__r.cllease__Evergreen_Frequency__c  //Monthly
                        ,cllease__Contract__r.cllease__Commencement_Date__c
                        ,cllease__Contract__r.cllease__Maturity_Date__c
                        ,cllease__Contract__r.cllease__Last_Payment_Date__c
                        ,cllease__Contract__r.Contract_Signer__c
                        ,cllease__Contract__r.Contract_Signer_Last_Name__c
                        ,cllease__Contract__r.Contract_Signer_Title__c
                        
                from cllease__Contract_Equipment__c
        ];

        return lList;
    }
    @AuraEnabled(cacheable = true)
    public static List<cllease__Lease_Account__c> filterLeaseList( String searchCustomer, String searchLease, String searchSerial) {
    
        Set<ID> leaseSet = new Set<ID>();
        system.debug('cust: ' + searchCustomer + '-' + 'lease: ' + searchLease + '-' + 'serial: ' + searchSerial);
        if (searchSerial != null){
            List<cllease__Contract_Equipment__c> eList =    [select cllease__Contract__c
                                                             from cllease__Contract_Equipment__c
                                                             where Serial_Number__c = :searchSerial
                                                            ];                                              
            for (cllease__Contract_Equipment__c e:eList)                                               
                leaseSet.add(e.cllease__Contract__c);
        }

        String searchQuery = '';
        /*
        select Id
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
        */
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
            if ((searchcustomer == null || searchCustomer == '') && (searchLease == null || searchLease == '') && (searchSerial == null || searchSerial == ''))
                searchQuery += ' ';
            else
                searchQuery += ' where name = ' + '\'' + 'nowayman' + '\'';
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