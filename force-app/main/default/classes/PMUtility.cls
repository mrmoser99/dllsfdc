/*******************************************************************************************************************
*   Portfolio Manager Utility
*
* 
*	Change Log: 
*	3/15/19 - MRM Created
*   4/17/19 - Started mapping for all services
*   5/2/19 - matched all message fields with datamappingv1.0 document 
*   5/30/19 - added all services; a few fields remain
*   5/31/19 - added client/secret from account for the user
*   5/31/19 - removed old simulation code; 
*
********************************************************************************************************************/
public without sharing class PMUtility {
    
    //wrapper classs or search results

    
    public class ServiceContractData{

        @AuraEnabled public Links links;
        @AuraEnabled public Meta meta;
        @AuraEnabled public List<Data> data;
        @AuraEnabled public String responseCode;
       
    }

    public class Links{
 
        @AuraEnabled public String self;
        @AuraEnabled public String first;
        @AuraEnabled public String prev;
        @AuraEnabled public String next;
        @AuraEnabled public String last;
    }

    public class Meta{

        @AuraEnabled public String itemTotal;
        @AuraEnabled public String size;
        @AuraEnabled public String page;
        @AuraEnabled public String pageTotal;
        @AuraEnabled public List<String> sortableFields;

    }

    public class asset{
        @AuraEnabled public String manufacturer;
        @AuraEnabled public String model;
        @AuraEnabled public String description;
        @AuraEnabled public String cost;
        @AuraEnabled public String installLocation;
        @AuraEnabled public String installCity;
        @AuraEnabled public String installCounty;
        @AuraEnabled public String installDate;
        @AuraEnabled public String installState;
        @AuraEnabled public String installPostalCode;
        @AuraEnabled public String billingLocation;
        @AuraEnabled public String billingCity;
        @AuraEnabled public String billingState;
        @AuraEnabled public String billingPostalCode;
        @AuraEnabled public String serialNumber;

    }
    public class leaseSigner{
        @AuraEnabled public String leaseSigner;  
        @AuraEnabled public String leaseSignerTitle;     
        @AuraEnabled public String leaseSignerPhone;           
    }
    public class contractDetail{
        @AuraEnabled public String responseCode;
        @AuraEnabled public String dllContractNumber;
        @AuraEnabled public String contractEndDate;
        @AuraEnabled public String customerLegalName;
        @AuraEnabled public String customerAccount;
        @AuraEnabled public String customerAddress;
        @AuraEnabled public String customerCity;
        @AuraEnabled public String customerState;
        @AuraEnabled public String customerPostalCode;
        @AuraEnabled public String customerCounty;
        @AuraEnabled public String contractPaymentMethod;
        @AuraEnabled public List<leaseSigner> leaseSigners;
        @AuraEnabled public String billingAddress;
        @AuraEnabled public String billingCity;
        @AuraEnabled public String billingState;
        @AuraEnabled public String billingPostalCode;
        @AuraEnabled public String billingPhoneNumber;
        @AuraEnabled public List<asset> assets;

    }
    public class contractSummary{
        @AuraEnabled public String responseCode;
        @AuraEnabled public String dllContractNumber;
        @AuraEnabled public String contractService; //6-19 new field
        @AuraEnabled public String contractStatus;
        @AuraEnabled public String customerName;
        @AuraEnabled public String leaseSignerPhone;
        @AuraEnabled public String contractStartDate;
        @AuraEnabled public String contractTerm;
        @AuraEnabled public String originalCost;
        @AuraEnabled public String contractRent;
        @AuraEnabled public String bookedDate;
        @AuraEnabled public String remainingPayments;
        @AuraEnabled public String equipmentDescription;
        @AuraEnabled public String numberOfAssets;
        @AuraEnabled public String financialProduct;
        @AuraEnabled public String purchaseOption;
        @AuraEnabled public String stateTax;
        @AuraEnabled public String countyTax;
        @AuraEnabled public String cityTax;
        @AuraEnabled public String districtTax;
        @AuraEnabled public String paymentFrequency;
        @AuraEnabled public String dateLastPayment;
        @AuraEnabled public String lastPaymentAmount;
        @AuraEnabled public String lastPaymentNumber;
        @AuraEnabled public String daysPastDue;
        @AuraEnabled public String paymentAppliedDate;
        @AuraEnabled public String creditApplicationNumber;
        @AuraEnabled public String currentAmount;
        @AuraEnabled public String pastAmount;
          
    }

    public class Data{
        /* missing */
        @AuraEnabled public String advancedPaymentStructure;  //m-11

        /* portfolio */
        @AuraEnabled public String responseCode;
        @AuraEnabled public String contractNumber; //m-42
        @AuraEnabled public String contractType;  //m-44
        @AuraEnabled public String contractTerm;  //m-41
        @AuraEnabled public String contractPeriodicity;
        @AuraEnabled public String contractPurchaseOption;
        @AuraEnabled public String contractProgramId;
        @AuraEnabled public String contractProgramName;
        @AuraEnabled public String contractStartDate; //m-43
        @AuraEnabled public String contractExpireDate;
        @AuraEnabled public String contractOriginalCost;
        @AuraEnabled public String contractPayment;  //m-14
        @AuraEnabled public String contractAverageDaysToPay;
        @AuraEnabled public String contractSigner; //m-6
        @AuraEnabled public String contractSignerTitle;  //m-7
        @AuraEnabled public String contractService;  // 6/19 new field 
        //@AuraEnabled public String daysPastDue; //dayspastdue
        @AuraEnabled public String equipmentDescription;
        @AuraEnabled public String nbrOfAssets;  //m-13
        @AuraEnabled public String leaseSignerTitle;
        @AuraEnabled public String numberOfRemainingPayments; //m-40
        @AuraEnabled public String lastPaymentReceivedDate;
        @AuraEnabled public String businessSegment;
        @AuraEnabled public String subBusinessSegment;
        @AuraEnabled public String customerName;  //map id 1
        @AuraEnabled public String olmCustomerNumber;  //next sprint  m-8
        @AuraEnabled public String customerNumber;
        @AuraEnabled public String customerAccount; //6/19
        @AuraEnabled public String customerPhoneNumber;  //m-3
        @AuraEnabled public String customerAddressLine1; //m-5
        @AuraEnabled public String customerAddressline2;  //m-5
        @AuraEnabled public String customerCity; //m-5
        @AuraEnabled public String customerState;  //m-5
        @AuraEnabled public String customerZipCode; //m-5
        @AuraEnabled public String billingAddressLine1; //m-4
        @AuraEnabled public String billingAddresslilne2; //m-4
        @AuraEnabled public String billingCity; //m-4
        @AuraEnabled public String billingState; //m-4
        @AuraEnabled public String billingZipCode; //m-4
        @AuraEnabled public String vendorSiteCode;
        @AuraEnabled public String vendorNumber1;
        @AuraEnabled public String vendorNumber2;
        @AuraEnabled public String vendorNumber3;
        @AuraEnabled public String vendorName;
        @AuraEnabled public String vendorAddressLine1;
        @AuraEnabled public String vendorAddressLine2;
        @AuraEnabled public String vendorCity;
        @AuraEnabled public String vendorState;
        @AuraEnabled public String vendorZipCode;
        @AuraEnabled public String newcoReady; //true or false
        
        
        /* XXD_KHR_REC_TYPE Contract Select Inquiry */

        @AuraEnabled public String Arrears;
        @AuraEnabled public String Assignable_Yn;
        @AuraEnabled public String Bank_Account_Num;
        @AuraEnabled public String Billing_Group_Id;
        @AuraEnabled public String Billing_Group_Name;
        @AuraEnabled public String Billing_Group_Number;
        @AuraEnabled public String Code_Sales_Rep;
        @AuraEnabled public String Contract_Number;
        @AuraEnabled public String Contract_Status;  //m-12
        @AuraEnabled public String Contract_Application_Number;  //m-9 credit appliction number
        @AuraEnabled public String x_Currency;
        @AuraEnabled public String Cust_Address;
        @AuraEnabled public String Cust_City;
        @AuraEnabled public String Cust_Country;
        @AuraEnabled public String Cust_County;
        @AuraEnabled public String Cust_First_Name;
        @AuraEnabled public String Cust_Last_Name;
        @AuraEnabled public String Cust_Legal_Name; //m-2
        @AuraEnabled public String Cust_Middle_Name;
        @AuraEnabled public String Cust_Postal_Code;
        @AuraEnabled public String Cust_State;
        @AuraEnabled public String Cust_Title;
        @AuraEnabled public String Customer_Id;
        @AuraEnabled public String Customer_Name;
        @AuraEnabled public String Customer_Number;
        @AuraEnabled public String Description;
        @AuraEnabled public String Discount_Rate;
        @AuraEnabled public String Effective_Date;
        @AuraEnabled public String Email_Address;
        @AuraEnabled public String End_Date;
        @AuraEnabled public String External_Contract_Number;
        @AuraEnabled public String Implicit_Rate;
        @AuraEnabled public String Lp_Program;
        @AuraEnabled public String Maximum_Due_Date;
        @AuraEnabled public String Number_Unbilled_Streams;
        @AuraEnabled public String Olm_Program;
        @AuraEnabled public String Op_Unit;
        @AuraEnabled public String Party_Id;
        @AuraEnabled public String Passive_Rate;
        @AuraEnabled public String Payment_Method;
        @AuraEnabled public String Periodicity;
        @AuraEnabled public String Print_Lead_Days;
        @AuraEnabled public String Product;  //m-10
        @AuraEnabled public String Reference_Lessee;
        @AuraEnabled public String Remaining_Pymnts;
        @AuraEnabled public String Sb_Unit;
        @AuraEnabled public String Start_Date;
        @AuraEnabled public String Syndicated_Flag;
        @AuraEnabled public String Term;
        @AuraEnabled public String Termination_Date;
        @AuraEnabled public String Total_Fin_Amnt;

        /* invfmt:GetGeneralContractInfoResponse */

        @AuraEnabled public String Financialproduct;  //m-10
        @AuraEnabled public String Purchaseoption;    //m-25  
        @AuraEnabled public String Numberofassets;  //m-13   copy this to nbrOfAssets above.
        @AuraEnabled public String Statetax;  //m-15
        @AuraEnabled public String Countytax;  //m-16
        @AuraEnabled public String Citytax; //m-17 6/19 new field
        @AuraEnabled public String Districttax; //m-18
        @AuraEnabled public String Totalassetpayment; //m-19 contract rent
        @AuraEnabled public String Paymentfrequency; //m-20
        @AuraEnabled public String Dayspastdue; //m-24


        /* end contract Extension */

        /* contract search inquiry */
        @AuraEnabled public String PaymentReceivedDate; //m-21 payment applied date
        @AuraEnabled public String PaymentAmountReceived;  //m-22 lastpayment amount
        @AuraEnabled public String PaymentNumber;  //check number  m-23 lastpayment number
 

        /* end contract search */


        @AuraEnabled public List<assetDetail> assetDetail;

       
    }
    
     //wrapper classs for detail of a single asset

    public class assetDetail{
        
        /* Portfolio */

        @AuraEnabled public String assetSequenceNumber;  //m-26
        @AuraEnabled public String assetDescription; //m-29
        @AuraEnabled public String assetManufacturer;
        @AuraEnabled public String assetMake; //m-27
        @AuraEnabled public String assetModel;  //m-28
        @AuraEnabled public String assetSerialNumber; //m-30
        @AuraEnabled public String assetAddressLine1;
        @AuraEnabled public String assetAddressLine2;
        @AuraEnabled public String assetCity;
        @AuraEnabled public String assetState;
        @AuraEnabled public String assetZipCode;
        @AuraEnabled public String assetPayment;
       

        /* XXD_ASSET_TBL_TYPE in Select Inquiry */
        @AuraEnabled public String Asset_Category;
        @AuraEnabled public String Asset_Cndtn;
        @AuraEnabled public String Asset_Number;
        @AuraEnabled public String Asset_Status;
        @AuraEnabled public String Billing_City;
        @AuraEnabled public String Billing_Country;
        @AuraEnabled public String Billing_County;
        @AuraEnabled public String Billing_Group_Id;
        @AuraEnabled public String Billing_Location; //m-38
        @AuraEnabled public String Billing_State;
        @AuraEnabled public String Billing_Zip;
        @AuraEnabled public String Calc_Residual_Amnt;
        @AuraEnabled public String Calc_Residual_Prcnt;
        @AuraEnabled public String Cost_Center; //m-37 missing
        @AuraEnabled public String Description;
        @AuraEnabled public String First_Payment_Date;
        @AuraEnabled public String Guaranteed_Amount;
        @AuraEnabled public String Guarantor_Name;
        @AuraEnabled public String Install_City;
        @AuraEnabled public String Install_Country;
        @AuraEnabled public String Install_County; // 6/19 new field
        @AuraEnabled public String Install_Date;  // 6/19 new field
        @AuraEnabled public String Install_Location; //m-39
        @AuraEnabled public String Install_Site_Id;
        @AuraEnabled public String Install_State;
        @AuraEnabled public String Install_Zip;
        @AuraEnabled public String Inventory_Item_Id;
        @AuraEnabled public String Item;
        @AuraEnabled public String Licence_Number;
        @AuraEnabled public String Manufacturer;
        @AuraEnabled public String Modal;
        @AuraEnabled public String Mtp_Rep_Ven_Site;
        @AuraEnabled public String Mtp_Rep_Vendor;
        @AuraEnabled public String Number_Of_Assets;
        @AuraEnabled public String Organization_Id;
        @AuraEnabled public String Parent_Asset_Num;
        @AuraEnabled public String Payment_Amount;
        @AuraEnabled public String Po_Number;  //m-36 missing
        @AuraEnabled public String Residual_Amnt;
        @AuraEnabled public String Residual_Prcnt;
        @AuraEnabled public String Uba_Flag;
        @AuraEnabled public String Unit_Cost;
        @AuraEnabled public String Units;

        /* end asset extension */

    }

     public class TerminationQuoteResponse{
        @AuraEnabled public String responseCode;
        @AuraEnabled public String partnerTransactionReference;
        @AuraEnabled public String contractNumber;
        @AuraEnabled public String quoteNumber;
        @AuraEnabled public String quoteValidityDate;
        @AuraEnabled public String quoteMessage;
        @AuraEnabled public String terminationQuoteType;
        @AuraEnabled public List<Quote> quotes;
        @AuraEnabled public String partnerOrderId;
    }


    //wrapper classs for detail of a single quote

    public class Quote{

        @AuraEnabled public String terminationQuoteType;
        @AuraEnabled public String quoteValidityDate;
        @AuraEnabled public String quoteMessage;
        @AuraEnabled public String quoteNumber;
        @AuraEnabled public String quoteCalculationDescription;
        @AuraEnabled public String remainingRentalPayments;
        @AuraEnabled public String discount;
        @AuraEnabled public String equipmentPrice;
        @AuraEnabled public String salesTax;
        @AuraEnabled public String propertyTax;
        @AuraEnabled public String leaseCharges;
        @AuraEnabled public String securityDeposit;
        @AuraEnabled public String pastDueService;
        @AuraEnabled public String amount;
       
        
    }

    /*************************************************************************************************
    * 
    * PM Get access token
	*	
    *************************************************************************************************/
    public static string getAccessToken(){     
    	
        String access_token;

    
        User u = [select contactId
                  from User
                  where id = :userInfo.getUserId()
                 ];

        /* default for testing; this is south west office */

        String client; // = 'b5dfbf6f-06a7-46c0-aa70-3b3eea4f4052';
    	String secret; //= 'd1ae6328-159e-43af-9bec-fe213cf9bda0';
        Contact c;

        List<PM_Oauth_Token__c> oaList = new List<PM_Oauth_Token__c>();
        oaList = [  select  pm_oauth_token__c
                        ,pm_oauth_token_expiration_date__c
                    from PM_Oauth_Token__c
                    where user__c = :u.id
                    ];
        
        system.debug(date.today() + '-' + oaList[0].pm_oauth_token_expiration_date__c);
        Boolean tokenRequired = false;
        if (oaList.size() == 0)
            tokenRequired = true;
        else{
            if (date.today() > oaList[0].pm_oauth_token_expiration_date__c || oaList[0].pm_oauth_token_expiration_date__c == null){
                tokenRequired = true;
            }
        }
  
        if (u.contactId != null){
            c = [select   id
                         ,account.client__c
                         ,account.secret__c
                         from Contact 
                         where id = :u.contactId];
            system.debug('client:' + c.account.client__c);
             system.debug('client:' + c.account.secret__c);
            if (c.account.client__c == null || c.account.secret__c == null){
                Integer i=0;  //use default
            }
            else{
                client = c.account.client__c;
                secret = c.account.secret__c;
            }
        }

        if (tokenRequired){
        
    	    HttpRequest req_token = new HttpRequest();        
		
		    String tokenEndpoint = System.Label.ICV_tokenendpoint;  
		    req_token.setEndpoint(tokenEndpoint);
            req_token.setMethod('POST');   
            req_token.setTimeout(120000);     
            req_token.setHeader('content-type', 'application/x-www-form-urlencoded');
            req_token.setHeader('cache-control', 'no-cache');        
            req_token.setBody('client_id='+client+'&client_secret='+secret+'&grant_type=client_credentials');
      
            Http http = new Http(); 

            if (Test.isRunningTest())
    		    return string.valueOf(system.now());
    		
            HTTPResponse res = http.send(req_token);
        
            if (res.getStatusCode()  == 200){
                JSONParser parser = JSON.createParser(res.getBody());
            
                while (parser.nextToken() != null) {
        	     if (parser.getCurrentName() == 'access_token') {
            	        access_token = parser.getText();
                    }
                }
            }
            else{
                return string.valueOf(res.getStatusCode());
            }

            /*
            if (u.contactId != null){
                Map<String,String> contactMap = new Map<String,String>();
                contactMap.put(c.id,access_token);
                NewCoUtility.updateContact(contactMap);
            }
            */

            Map<String,String> tokenMap = new Map<String,String>();
            tokenMap.put(u.id,access_token);
            NewCoUtility.updateOauthToken(tokenMap);
           
        }
        else {
            access_token = oaList[0].pm_oauth_token__c;
            //else
            //    access_token =  c.pm_oauth_token__c;
        }

		
       	return access_token;
         
    }

    
}