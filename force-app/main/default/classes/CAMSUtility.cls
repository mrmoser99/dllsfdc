/*********************************************************************************************
*
* CAMS Utility Class - used for cams calls
*
* Change Log:
*
* 9/24/19 - MRM created
* 9/22/2020 - MRM new fields assetType and crossBorder
*
**********************************************************************************************/
global without sharing class CAMSUtility { 
    
    public static Boolean skipApplicationTrigger = false;
    
    /*************************************************************************************************
    * 
    * Data Structure to hold cams results
    *
    *************************************************************************************************/
    //{"code":"200","statusDesc":"Success","caseNumber":"","dueDiligenceComplete":"false","riskRating":""}
    public class results{
       
       public String code;
       public String statusDesc;
       public String caseNumber;
       public String dueDiligenceComplete;
       public String riskRating;
   
    }
    /*************************************************************************************************
    * 
    * Cams Callout
    *
    *************************************************************************************************/
    public static void callCAMS(Map<ID,String> applicationMap){

        ID appId;

        for (ID s:applicationMap.keySet())
            appId = s;

        //call cams here

        genesis__Applications__c a = [select id
                                     ,genesis__Status__c
                                     from genesis__Applications__c
                                     where id = :appId
                                     ];

       
        system.debug('status is: ' + a.genesis__status__c);

       
        List<CAMS_Check__c> ccList = [SELECT Account_Number__c
                                    ,Application__c
                                    ,Application__r.name
                                    ,Confirmed_PEP__c
                                    ,Customer_LE_Type__c
                                    ,Customer_Name__c
                                    ,Product_Risk__c
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
                                    where application__c = :appId
                                    ];

        CAMS_Check__c cc;

        if (ccList.size() == 0){
            cc = CAMSUtility.createCamsCheckRecord(applicationMap,'CAMS CHECK',false);
        }
        else{
            cc = ccList[0];
        }

        
        /*
        if (cc.missing_data__c){
            cc.status__c = 'Held - Data Issue';
            a.genesis__status__c = 'CAMS REFERRED';
            update a;
            update cc;
            return;
        }
        */ 

        HttpRequest reqAPI = new HttpRequest();  
            
        reqAPI.setEndpoint(System.Label.CAMS_Endpoint);
        reqAPI.setMethod('POST');          
        reqAPI.setHeader('Authorization', 'Bearer '+ ICVUtility.getAccessToken());
        reqAPI.setHeader('content-type', 'application/json');
        reqAPI.setTimeout(120000);
            
        JSONGenerator gen = JSON.createGenerator(true);
            
        gen.writeStartObject();
        if (cc.Account_Number__c == null)
            gen.writeNullField('customerID');
        else
            gen.writeStringField('customerID', cc.Account_Number__c);

        if(cc.Geography__c == null)
            gen.writeNullField('geography');
        else
            gen.writeStringField('geography', cc.Geography__c);

        if (cc.Customer_LE_Type__c == null)    
            gen.writeNullField('customerLEType');
        else
            gen.writeStringField('customerLEType', cc.Customer_LE_Type__c);
        
        if (cc.NAICS__c == null)
            gen.writeNullField('NAICScode');
        else
            gen.writeStringField('NAICScode', cc.NAICS__c);

        if (cc.Distribution_Channel__c == null)
            gen.writeNullField('distributionChannel');
        else
            gen.writeStringField('distributionChannel', cc.Distribution_Channel__c);

        if (cc.product_risk__c == null)   
            gen.writeNullField('productRisk');  
        else
            gen.writeStringField('productRisk', cc.product_risk__c);

        if (cc.Confirmed_PEP__c == null)
            gen.writeNullField('confirmedPEP');
        else
            gen.writeStringField('confirmedPEP', string.valueOf(cc.Confirmed_PEP__c));
         
        gen.writeStringField('applicationNumber', cc.Application__r.name);
        gen.writeStringField('sourceSystem', cc.Source_System__c);
        gen.writeStringField('transactionAmount', string.valueOf(cc.Transaction_Amount__c));

        if (cc.Customer_Name__c != null)
            gen.writeStringField('customerName', cc.Customer_Name__c);
    
        if (cc.lease_signer_title__c != null)
            gen.writeStringField('leaseSignerTitle', cc.Lease_Signer_Title__c);
        if (cc.Lease_Signer_First_Name__c != null)
            gen.writeStringField('leaseSignerFirstName', cc.Lease_Signer_First_Name__c);
        if (cc.Lease_Signer_Last_Name__c != null)
            gen.writeStringField('leaseSignerLastName', cc.Lease_Signer_Last_Name__c);

        if (cc.Customer_Type__c == null)
            gen.writeNullField('customerType');
        else
            gen.writeStringField('customerType', cc.Customer_Type__c);
        
        gen.writeStringField('DLLCountry', cc.Dll_Country__c);
        
        //Hi Everyone, here are the NAICS code that will indicate the customer being a trust. So the mid office systems (or back office system scripts for one time load customer extract) can check for this to send the appropriate value for trust indicator. This logic should be used for on going CRR call and to populate the value for this field for the One time load file. 

        //If NAICS code for the customer is one of the below then the Trust indicator will be a Y otherwise N.

        //The final list of trust NAICS codes are as follows:

        //523991 - Trust, Fiduciary, and Custody Activities
        //525920 - Trusts, Estates, and Agency Accounts
        //813211 - Grantmaking Foundations

        if (cc.NAICS__c == '523991' || cc.NAICS__c == '525920' || cc.NAICS__c == '813211' ) 
            cc.Trust__c = true;
        
        gen.writeStringField('trustIndicator', string.valueOf(cc.Trust__c));
        
        
        
        gen.writeStringField('publiclyTradedIndicator', string.valueOf(cc.Publicly_Traded__c));
        gen.writeStringField('publiclyTradedFullSubsidiary', string.valueOf(cc.Publicly_Traded_Full_Subsidiary__c));

        // new fields 9/22/2020
        gen.writeStringField('assetType', 'Other');
        gen.writeStringField('crossBorder', 'No');
        
        gen.writeEndObject();
        
        String jsonS = gen.getAsString();
        system.debug('json:' + jsonS);
        reqAPI.setBody(jsonS);  
        Http http1 = new Http();

        if (test.isRunningTest())
            return;
        HTTPResponse res1 = http1.send(reqAPI); 
        
        
        if (res1.getStatusCode() != 200){
            a.genesis__status__c = 'CAMS FATAL';  
            update a;
            return;
        }
        
        
        CAMSUtility.results res = (CAMSUtility.results) System.JSON.deserialize(res1.getBody(),CAMSUtility.results.class);  
        system.debug('result: ' + res);
        
        if (res.code == '200'){
            cc.Response_Risk_Rating__c = res.riskRating;
            cc.response_case_number__c = res.caseNumber;
            cc.response_diligence__c = boolean.valueOf(res.dueDiligenceComplete);
        }
        else{
            if (res.code.startsWith('4')){
                cc.status__c = 'Held - Data Issue';
                a.genesis__status__c = 'CAMS DEFERRED'; 
                update a;
                update cc;  
                return;
            }
            else{
                a.genesis__status__c = 'CAMS FATAL';  
                update a;
                return;
            }
        }

        cc.Response_Risk_Rating__c = res.riskRating;
        cc.response_case_number__c = res.caseNumber;
        cc.response_diligence__c =  boolean.valueOf(res.dueDiligenceComplete);
        cc.response_code__c = res.code;
        

        /* make the call here */

        if (cc.missing_data__c){
            cc.status__c = 'Held - Data Issue';
            a.genesis__status__c = 'CAMS REFERRED';
        }

        if (cc.response_risk_rating__c == 'H'){
            cc.status__c = 'Held - High';
            a.genesis__status__c = 'CAMS REFERRED';
        }
        else
        if (cc.response_risk_rating__c == 'M'){
             cc.status__c = 'Held - Medium';
             a.genesis__status__c = 'CAMS REFERRED';
        }
        else
        if (cc.response_risk_rating__c == 'L'){
            cc.status__c = 'Auto Cleared';
            a.genesis__status__c = 'CAMS APPROVED';
        }

        if (applicationMap.get(appId) == 'Clear' && cc.Response_Diligence__c == true){   
            cc.status__c = 'Manually Cleared';
            a.genesis__status__c = 'CAMS APPROVED';   
        }

        update a;
        update cc; 
        

        
    }

    /*************************************************************************************************
    * 
    * Cams Update Applciation Status
        *
    *************************************************************************************************/
    
    public static void updateApplicationStatus(Map<String,String> applicationMap){

        String appId;
        skipApplicationTrigger = true;

        for(String s:applicationMap.keySet())
            appId = s;

        genesis__Applications__c a = [select id
                                     ,genesis__Status__c
                                     from genesis__Applications__c
                                     where id = :appId
                                     ];
        a.genesis__Status__c = applicationMap.get(appId);

        update a;
    }



    /*************************************************************************************************
    * 
    * Cams Check Record 
    *
    *************************************************************************************************/
    public static CAMS_Check__c createCamsCheckRecord(Map<ID,String> applicationMap, String status, Boolean pep){
        String result;
        
        CAMS_Check__c cc;
        String applicationId;
        system.debug('application map is: ' + applicationMap);
        
        for (ID cId:applicationMap.keySet()){
            applicationId = cId;
        }
        
        genesis__Applications__c a = [select genesis__Quick_Quote__c
                                     ,genesis__account__r.naics__c
                                     from genesis__Applications__c
                                     where id = :applicationId
                                     ];

        List<CAMS_Check__c> ccList = [select id 
                            from CAMS_Check__c 
                            where application__c in :applicationMap.keySet()
                            ];
        
        if (ccList.size() != 0)
            cc = ccList[0];
        else{   
            cc = new CAMS_Check__c();
            cc.application__c = applicationId;
            cc.quick_quote__c = a.genesis__Quick_Quote__c;
            cc.geography__c = 'US';
            cc.dll_country__c = 'W';
            cc.customer_type__c = 'Commercial';
            cc.Confirmed_PEP__c = pep;
            cc.naics__c = a.genesis__account__r.naics__c;
        }

        cc.status__c = status.trim();

    

        upsert cc;

        return cc;

        
    }

}