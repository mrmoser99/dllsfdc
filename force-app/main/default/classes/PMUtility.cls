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
*
********************************************************************************************************************/
public without sharing class PMUtility {
    
    //wrapper classs or search results

    
    public class ServiceContractData{

        @AuraEnabled public Links links;
        @AuraEnabled public Meta meta;
        @AuraEnabled public List<Data> data;
        
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

        @AuraEnabled public String dllContractNumber;
        @AuraEnabled public String contractEndDate;
        @AuraEnabled public String customerLegalName;
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

        @AuraEnabled public String dllContractNumber;
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
        @AuraEnabled public String Citytax; //m-17 missing
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

        @AuraEnabled public Receivable receivable;

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
        @AuraEnabled public String Install_County; //missing
        @AuraEnabled public String Install_Date;  //m-31
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

    public class Receivable  {

        @AuraEnabled public String PastAmountDue;
        @AuraEnabled public String CurrentAmountDue;
        @AuraEnabled public String TotalAmountDue;
        @AuraEnabled public List<ReceivableDetail> receivables;
    }    
    public class ReceivableDetail {
        
        /* receivables */

        @AuraEnabled public String Assetnumber;
        @AuraEnabled public String Receivabletype; //m-32
        @AuraEnabled public String Arconsolidatedinvoicenumber;  //m-35
        @AuraEnabled public String Duedate;  //m-34
        @AuraEnabled public String Amountdue;  //m-33
        @AuraEnabled public String Amountreceived;
        @AuraEnabled public String Latechargesdue;
        @AuraEnabled public String Latechargesreceived;
        @AuraEnabled public String Financechargesdue;
        @AuraEnabled public String Financechargesreceived;
        @AuraEnabled public String Balancedue;
        @AuraEnabled public String Adjustment;

        
    }

    

    /************************************************************************************************************************************************************
    *
    *   Calls to return data from api's 
    *
    *    size
    *        Specifies the maximum number of items to be returned in the result collection. Default if not specified: 20
    *    sortOrder
    *        Specifies the sorting order of the asset-level collection. 
    *        Standard sorting prefix "-" indicates descending order. Multiple fields may be specified as a comma-delimited list. Valid field names: customerName, contractNumber, numberOfRemainingPayments, customerZipCode. Default sort order is: customerName, contractNumber
    *    assetDetail
    *       A boolean that specifies whether Asset Detail is to be included in the response for each returned contract.   
    *
    *    Customer Name Search Examples
    *    ABC* matches value that begins with ABC
    *    *ABC matches value that ends with ABC
    *    *ABC* matches value that contains ABC
    *    *ABC*DEF* Matches value containing ABC anywhere in the value followed by DEF anywhere in the value
    *    ABC*DEF Matches value ABC\*DEF exactly
    *
    *
    *************************************************************************************************************************************************************/
        
    public static ServiceContractData searchPortfolio(String customerName
                                    , String customerNumber
                                    , String assetSerialNumber
                                    , Integer size
                                    , String sortOrder
                                    , Boolean assetDetail
                                    , Integer page){
        
        Integer offset = page * size;

        String searchCustomerName = '%' + customerName + '%';
        String searchCustomerNumber = '%' + customerNumber + '%';
        
        List<Portfolio_Equipment__c> eList = new List<Portfolio_Equipment__c>();
        List<Portfolio_Contract__c> clist = new  List<Portfolio_Contract__c>();
        
        Map<ID,List<Portfolio_Equipment__c>> eMap = new Map<ID,List<Portfolio_Equipment__c>>();
        Set<ID> contractSet = new Set<ID>();

        if (assetSerialNumber != ''){
            
            eList = [select  Portfolio_Contract__c
                            ,assetDescription__c
                            ,assetMake__c
                            ,assetManufacturer__c
                            ,assetModel__c
                            ,assetPayment__c
                            ,assetSequenceNumber__c
                            ,assetSerialNumber__c
                            ,assetState__c
                            ,assetZipCode__c
                            ,assetAddressLine1__c
                            ,assetAddressLine2__c
                            ,assetCity__c

                    from Portfolio_Equipment__c
                    where assetSerialNumber__c = :assetSerialNumber
                    ];
            
            if (!elist.isEmpty()){
                eMap.put(eList[0].portfolio_contract__c,eList);

                clist = [SELECT billingAddressLine1__c
                                            ,billingAddressLine2__c,billingCity__c,billingState__c,billingZipCode__c,businessSegment__c,contractAverageDaysToPay__c              ,contractExpireDate__c
                                            ,contractNumber__c,contractOriginalCost__c,contractPayment__c,contractPeriodicity__c,contractProgramId__c,contractProgramName__c
                                            ,contractPurchaseOption__c,contractSignerTitle__c,contractSigner__c,contractStartDate__c,contractTerm__c                            ,contractType__c
                                            ,CreatedById,CreatedDate,customerAddressLine1__c,customerAddressline2__c,customerCity__c,customerName__c,customerNumber__c
                                            ,customerState__c,customerZipCode__c,lastPaymentReceivedDate__c,leaseSignerTitle__c,Name,nbrOfAssets__c,numberOfRemainingPayments__c
                                            ,phone__c,subBusinessSegment__c,vendorAddressLine1__c,vendorAddressLine2__c,vendorCity__c,vendorName__c,vendorNumber1__c
                                            ,vendorNumber2__c,vendorNumber3__c,vendorSiteCode__c,vendorState__c,vendorZipCode__c                                             FROM Portfolio_Contract__c  
                                            where id in :emap.keySet()
                                            limit 50
                                            ];  
            }      
        }
        else{
        if (customerName != '' || customerNumber != ''){
             clist = [SELECT billingAddressLine1__c
                                             ,billingAddressLine2__c,billingCity__c,billingState__c,billingZipCode__c,businessSegment__c,contractAverageDaysToPay__c              ,contractExpireDate__c
                                            ,contractNumber__c,contractOriginalCost__c,contractPayment__c,contractPeriodicity__c,contractProgramId__c,contractProgramName__c
                                            ,contractPurchaseOption__c,contractSignerTitle__c,contractSigner__c,contractStartDate__c,contractTerm__c                            ,contractType__c
                                            ,CreatedById,CreatedDate,customerAddressLine1__c,customerAddressline2__c,customerCity__c,customerName__c,customerNumber__c
                                            ,customerState__c,customerZipCode__c,lastPaymentReceivedDate__c,leaseSignerTitle__c,Name,nbrOfAssets__c,numberOfRemainingPayments__c
                                            ,phone__c,subBusinessSegment__c,vendorAddressLine1__c,vendorAddressLine2__c,vendorCity__c,vendorName__c,vendorNumber1__c
                                            ,vendorNumber2__c,vendorNumber3__c,vendorSiteCode__c,vendorState__c,vendorZipCode__c    
                                            FROM Portfolio_Contract__c  
                                            where customerName__c like :searchCustomerName
                                            and
                                            customerNumber__c like: searchCustomerNumber
                                            limit 50
                                            ];           
        
        }
        else{
            clist = [SELECT billingAddressLine1__c
                                             ,billingAddressLine2__c,billingCity__c,billingState__c,billingZipCode__c,businessSegment__c,contractAverageDaysToPay__c              ,contractExpireDate__c
                                            ,contractNumber__c,contractOriginalCost__c,contractPayment__c,contractPeriodicity__c,contractProgramId__c,contractProgramName__c
                                            ,contractPurchaseOption__c,contractSignerTitle__c,contractSigner__c,contractStartDate__c,contractTerm__c                            ,contractType__c
                                            ,CreatedById,CreatedDate,customerAddressLine1__c,customerAddressline2__c,customerCity__c,customerName__c,customerNumber__c
                                            ,customerState__c,customerZipCode__c,lastPaymentReceivedDate__c,leaseSignerTitle__c,Name,nbrOfAssets__c,numberOfRemainingPayments__c
                                            ,phone__c,subBusinessSegment__c,vendorAddressLine1__c,vendorAddressLine2__c,vendorCity__c,vendorName__c,vendorNumber1__c
                                            ,vendorNumber2__c,vendorNumber3__c,vendorSiteCode__c,vendorState__c,vendorZipCode__c    
                                            FROM Portfolio_Contract__c  
                                            limit :size OFFSET : integer.valueOf(offset)
                                            ];           
        
            }
            for (Portfolio_Contract__c  c:cList)
                contractSet.add(c.id);


            eList = [select Portfolio_Contract__c
                            ,assetDescription__c
                            ,assetMake__c
                            ,assetManufacturer__c
                            ,assetModel__c
                            ,assetPayment__c
                            ,assetSequenceNumber__c
                            ,assetSerialNumber__c
                            ,assetState__c
                            ,assetZipCode__c
                            ,assetAddressLine1__c
                            ,assetAddressLine2__c
                            ,assetCity__c
                    from Portfolio_Equipment__c
                    where Portfolio_Contract__c in :contractSet
                    order by assetSequenceNumber__c
            ];
            
            for (Portfolio_Equipment__c e:eList){
                List<Portfolio_Equipment__c> temp = new List<Portfolio_Equipment__c>();

                if (eMap.get(e.portfolio_contract__c) == null){
                    temp.add(e);
                }
                else{
                    temp = eMap.get(e.portfolio_contract__c);
                    temp.add(e);
                }
                eMap.put(e.portfolio_contract__c,temp);
            }


        } //end else
        
        
        List<Data> dList = new List<Data>();
        ServiceContractData response = new ServiceContractData();

        Meta m = new Meta();
        m.itemTotal = '50';
        m.size = '50';
        m.page = string.valueOf(page);
        m.pageTotal = '0';
        m.sortableFields = null;

        response.meta = m;

        for (Portfolio_Contract__c c:cList){

            Data d = new Data();
            d.contractNumber = c.contractNumber__c;
            d.customerName = c.customerName__c;
            d.customerZipCode = c.billingZipCode__c;
            d.contractStartDate = c.contractStartDate__c;
            d.contractTerm = c.contractTerm__c;
            d.numberOfRemainingPayments = c.numberOfRemainingPayments__c;
            d.equipmentDescription = '?';
            d.contractOriginalCost = c.contractOriginalCost__c;
            d.contractPayment = c.contractPayment__c;
            d.contractType = c.contractType__c;
            d.newcoReady = 'true';
            d.nbrOfAssets = string.valueOf(c.nbrOfAssets__c);
            d.equipmentDescription = 'Equipment Count: ' + c.nbrOfAssets__c;


            List<assetDetail> aList = new List<assetDetail>();
            
            List<Portfolio_Equipment__c> contractEquipmentList = eMap.get(c.id);
            if (!contractEquipmentList.isEmpty()){

                assetDetail a = new assetDetail();
                for (Portfolio_Equipment__c e: eMap.get(c.id)){
                    a = new assetDetail();
                    a.assetSequenceNumber = e.assetSequenceNumber__c;
                    a.assetDescription = e.assetDescription__c;
                    a.assetManufacturer = e.assetManufacturer__c;
                    a.assetMake = e.assetMake__c;
                    a.assetModel = e.assetModel__c;
                    a.assetSerialNumber = e.assetSerialNumber__c;
                    a.assetAddressLine1 = e.assetAddressLine1__c;
                    a.assetAddressLine2 = e.assetAddressLine2__c;
                    a.assetCity = e.assetCity__c;
                    a.assetState = e.assetState__c;
                    a.assetZipCode = e.assetZipCode__c;
                    a.assetPayment = '121.12';
                   
                    aList.add(a);
                }
                
            }

            d.assetDetail = aList;

            /* general contract info data pop */
            d.Financialproduct = 'DLL_US_DFL_NON_TAX';  
            d.Purchaseoption = 'Fair Market Value';      
            d.Numberofassets= '25';
            d.Statetax = '254.92';
            d.Countytax = '5.44';
            d.Citytax = '71.74';
            d.Districttax = '4.41';
            d.Totalassetpayment = '4079';
            d.Paymentfrequency = 'M';
            d.Dayspastdue = '258';
            
           
            d.receivable = new receivable();
            d.receivable.PastAmountDue = '3956.85';
            d.receivable.CurrentAmountDue = '454.83';
            d.receivable.TotalAmountDue = '4411.68';

            d.receivable.receivables = new List<ReceivableDetail>();
            ReceivableDetail r = new ReceivableDetail();

             
            r.Assetnumber = '25479814_1';
            r.Receivabletype = 'RENT';
            r.Arconsolidatedinvoicenumber = '62182621';
            r.Duedate = '2019-03-15T00:00:00';
            r.Amountdue = '315.01';
            r.Amountreceived = '0';
            r.Latechargesdue = '0';
            r.Latechargesreceived = '0';
            r.Financechargesdue = '0';
            r.Financechargesreceived = '0';
            r.Balancedue = '315.01';
            r.Adjustment = '0';
            d.receivable.receivables.add(r);

            r.Assetnumber = '25479814_1';
            r.Receivabletype = 'PASS THROUGH MAINTENANCE - BUNDLED';
            r.Arconsolidatedinvoicenumber = '62182621';
            r.Duedate = '2019-03-15T00:00:00';
            r.Amountdue = '96.34';
            r.Amountreceived = '0';
            r.Latechargesdue = '0';
            r.Latechargesreceived = '0';
            r.Financechargesdue = '0';
            r.Financechargesreceived = '0';
            r.Balancedue = '96.34';
            r.Adjustment = '0';
            d.receivable.receivables.add(r);

            r.Assetnumber = '';
            r.Receivabletype = 'LATE FEE';
            r.Arconsolidatedinvoicenumber = '62182621';
            r.Duedate = '2019-03-15T00:00:00';
            r.Amountdue = '20.57';
            r.Amountreceived = '0';
            r.Latechargesdue = '0';
            r.Latechargesreceived = '0';
            r.Financechargesdue = '0';
            r.Financechargesreceived = '0';
            r.Balancedue = '20.57';
            r.Adjustment = '0';
            d.receivable.receivables.add(r);

             r.Assetnumber = '';
            r.Receivabletype = 'INSURANCE';
            r.Arconsolidatedinvoicenumber = '62182621';
            r.Duedate = '2019-03-15T00:00:00';
            r.Amountdue = '22.91';
            r.Amountreceived = '0';
            r.Latechargesdue = '0';
            r.Latechargesreceived = '0';
            r.Financechargesdue = '0';
            r.Financechargesreceived = '0';
            r.Balancedue = '22.91';
            r.Adjustment = '0';
            d.receivable.receivables.add(r);

            /* next receivable */

            r.Assetnumber = '25479814_1';
            r.Receivabletype = 'RENT';
            r.Arconsolidatedinvoicenumber = '61809793';
            r.Duedate = '2019-03-15T00:00:00';
            r.Amountdue = '315.01';
            r.Amountreceived = '0';
            r.Latechargesdue = '0';
            r.Latechargesreceived = '0';
            r.Financechargesdue = '0';
            r.Financechargesreceived = '0';
            r.Balancedue = '315.01';
            r.Adjustment = '0';
            d.receivable.receivables.add(r);

            r.Assetnumber = '25479814_1';
            r.Receivabletype = 'PASS THROUGH MAINTENANCE - BUNDLED';
            r.Arconsolidatedinvoicenumber = '61809793';
            r.Duedate = '2019-03-15T00:00:00';
            r.Amountdue = '96.34';
            r.Amountreceived = '0';
            r.Latechargesdue = '0';
            r.Latechargesreceived = '0';
            r.Financechargesdue = '0';
            r.Financechargesreceived = '0';
            r.Balancedue = '96.34';
            r.Adjustment = '0';
            d.receivable.receivables.add(r);

            r.Assetnumber = '';
            r.Receivabletype = 'LATE FEE';
            r.Arconsolidatedinvoicenumber = '61809793';
            r.Duedate = '2019-03-15T00:00:00';
            r.Amountdue = '20.57';
            r.Amountreceived = '0';
            r.Latechargesdue = '0';
            r.Latechargesreceived = '0';
            r.Financechargesdue = '0';
            r.Financechargesreceived = '0';
            r.Balancedue = '20.57';
            r.Adjustment = '0';
            d.receivable.receivables.add(r);

             r.Assetnumber = '';
            r.Receivabletype = 'INSURANCE';
            r.Arconsolidatedinvoicenumber = '61809793';
            r.Duedate = '2019-03-15T00:00:00';
            r.Amountdue = '22.91';
            r.Amountreceived = '0';
            r.Latechargesdue = '0';
            r.Latechargesreceived = '0';
            r.Financechargesdue = '0';
            r.Financechargesreceived = '0';
            r.Balancedue = '22.91';
            r.Adjustment = '0';
            d.receivable.receivables.add(r);

            dList.add(d);

        }
        
      
        response.data = dList;
        
        return response;

        
    }

    /************************************************************************************************************************************************************
    *   getLeaseDetails
    *************************************************************************************************************************************************************/

    public static String getLeaseDetails(String leaseNumber){
        
        String response;

        return JSON.serialize(response); 

    }
    /************************************************************************************************************************************************************
    *   generateQuotes - message format
    *************************************************************************************************************************************************************/
    public static TerminationQuoteResponse generateQuotes(String leaseNumber){
        
        TerminationQuoteResponse response = new TerminationQuoteResponse(); 
       
        List<Lease_OLM_Quote__c> newQuotes = new List<Lease_OLM_Quote__c>();

        List<Quote> qList = new List<Quote>();

        response.partnerTransactionReference = string.valueOf(system.now());
        response.contractNumber = leaseNumber;
        
        Quote q = new Quote();
        q.quoteCalculationDescription = 'Trade-up Quote';
        Integer randomNumber = Integer.valueof((Math.random() * 10000000));
        q.quoteNumber = 'QT-' + randomNumber;
        q.terminationQuoteType = 'MRMType2';
        q.quoteValidityDate = '2019-10-31';
        q.quoteMessage = 'Hello2';
        q.remainingRentalPayments = '9';
        q.discount = '0.00';
        q.equipmentPrice = '564.88';
        q.salesTax = '50.01';
        q.propertyTax = '5.00';
        q.leaseCharges = '13003.11';
        q.securityDeposit = '100.00';
        q.amount = string.valueOf(randomNumber * .76);
        qList.add(q);

        Lease_OLM_Quote__c lq = new Lease_OLM_Quote__c();
        lq.quote_calculation_description__c = q.quoteCalculationDescription;
        lq.name = q.quoteNumber;
        lq.termination_quote_type__c = q.terminationQuoteType;
        lq.quote_validity_date__c = date.valueOf(q.quoteValidityDate);
        lq.quote_message__c = q.quoteMessage;
        lq.remaining_rental_payments__c = decimal.valueOf(q.remainingRentalPayments);
        lq.discount__c = decimal.valueOf(q.discount);
        lq.equipment_price__c = decimal.valueOf(q.equipmentPrice);
        lq.sales_tax__c = decimal.valueOf(q.salesTax);
        lq.property_tax__c = decimal.valueOf(q.propertyTax);      
        lq.lease_charges__c = decimal.valueOf(q.leaseCharges);
        lq.security_deposit__c = decimal.valueOf(q.securityDeposit);
        lq.amount__c = decimal.valueOf(q.amount);
        lq.contract_number__c = response.contractNumber;
        newQuotes.add(lq);

        q = new Quote();
        q.quoteCalculationDescription = 'Trade-up with Return Quote';
        randomNumber = Integer.valueof((Math.random() * 10000000));
        q.quoteNumber = 'QT-' + randomNumber;
        q.terminationQuoteType = 'MRMType3';
        q.quoteValidityDate = '2019-10-31';
        q.quoteMessage = 'Hello 3';
        q.remainingRentalPayments = '9';
        q.discount = '0.00';
        q.equipmentPrice = '64.88';
        q.salesTax = '5.01';
        q.propertyTax = '1.00';
        q.leaseCharges = '133.11';
        q.securityDeposit = '10.00';
        q.amount = string.valueOf(randomNumber * .56);
        qList.add(q);

        
        lq = new Lease_OLM_Quote__c();
        lq.quote_calculation_description__c = q.quoteCalculationDescription;
        lq.name = q.quoteNumber;
        lq.termination_quote_type__c = q.terminationQuoteType;
        lq.quote_validity_date__c = date.valueOf(q.quoteValidityDate);
        lq.quote_message__c = q.quoteMessage;
        lq.remaining_rental_payments__c = decimal.valueOf(q.remainingRentalPayments);
        lq.discount__c = decimal.valueOf(q.discount);
        lq.equipment_price__c = decimal.valueOf(q.equipmentPrice);
        lq.sales_tax__c = decimal.valueOf(q.salesTax);
        lq.property_tax__c = decimal.valueOf(q.propertyTax);      
        lq.lease_charges__c = decimal.valueOf(q.leaseCharges);
        lq.security_deposit__c = decimal.valueOf(q.securityDeposit);
        lq.amount__c = decimal.valueOf(q.amount);
        lq.contract_number__c = response.contractNumber;
        newQuotes.add(lq);
 
        insert newQuotes;

        response.quotes = qList;
        
        return response;  

    }

    /************************************************************************************************************************************************************
    *   generateQuotes - message format
    *************************************************************************************************************************************************************/
    public static List<Lease_OLM_Quote__c> generateQuotesSOQL(String leaseNumber){
        
        TerminationQuoteResponse response = new TerminationQuoteResponse(); 
       
        List<Lease_OLM_Quote__c> newQuotes = new List<Lease_OLM_Quote__c>();
        List<Lease_OLM_Quote__c> newQuoteResponse = new List<Lease_OLM_Quote__c>();

        List<Quote> qList = new List<Quote>();

        response.partnerTransactionReference = string.valueOf(system.now());
        response.contractNumber = leaseNumber;
        
        Quote q = new Quote();
        q.quoteCalculationDescription = 'Trade-up Quote';
        Integer randomNumber = Integer.valueof((Math.random() * 10000000));
        q.quoteNumber = 'QT-' + randomNumber;
        q.terminationQuoteType = 'MRMType2';
        q.quoteValidityDate = '2019-10-31';
        q.quoteMessage = 'Hello2';
        q.remainingRentalPayments = '9';
        q.discount = '0.00';
        q.equipmentPrice = '564.88';
        q.salesTax = '50.01';
        q.propertyTax = '5.00';
        q.leaseCharges = '13003.11';
        q.securityDeposit = '100.00';
        q.amount = string.valueOf(randomNumber * .76);
        qList.add(q);

        Lease_OLM_Quote__c lq = new Lease_OLM_Quote__c();
        lq.quote_calculation_description__c = q.quoteCalculationDescription;
        lq.name = q.quoteNumber;
        lq.termination_quote_type__c = q.terminationQuoteType;
        lq.quote_validity_date__c = date.valueOf(q.quoteValidityDate);
        lq.quote_message__c = q.quoteMessage;
        lq.remaining_rental_payments__c = decimal.valueOf(q.remainingRentalPayments);
        lq.discount__c = decimal.valueOf(q.discount);
        lq.equipment_price__c = decimal.valueOf(q.equipmentPrice);
        lq.sales_tax__c = decimal.valueOf(q.salesTax);
        lq.property_tax__c = decimal.valueOf(q.propertyTax);      
        lq.lease_charges__c = decimal.valueOf(q.leaseCharges);
        lq.security_deposit__c = decimal.valueOf(q.securityDeposit);
        lq.amount__c = decimal.valueOf(q.amount);
        lq.contract_number__c = response.contractNumber;
        newQuotes.add(lq);

        q = new Quote();
        q.quoteCalculationDescription = 'Trade-up with Return Quote';
        randomNumber = Integer.valueof((Math.random() * 10000000));
        q.quoteNumber = 'QT-' + randomNumber;
        q.terminationQuoteType = 'MRMType3';
        q.quoteValidityDate = '2019-10-31';
        q.quoteMessage = 'Hello 3';
        q.remainingRentalPayments = '9';
        q.discount = '0.00';
        q.equipmentPrice = '64.88';
        q.salesTax = '5.01';
        q.propertyTax = '1.00';
        q.leaseCharges = '133.11';
        q.securityDeposit = '10.00'; 
        q.amount = string.valueOf(randomNumber * .56);
        qList.add(q);

        
        lq = new Lease_OLM_Quote__c();
        lq.quote_calculation_description__c = q.quoteCalculationDescription;
        lq.name = q.quoteNumber;
        lq.termination_quote_type__c = q.terminationQuoteType;
        lq.quote_validity_date__c = date.valueOf(q.quoteValidityDate);
        lq.quote_message__c = q.quoteMessage;
        lq.remaining_rental_payments__c = decimal.valueOf(q.remainingRentalPayments);
        lq.discount__c = decimal.valueOf(q.discount);
        lq.equipment_price__c = decimal.valueOf(q.equipmentPrice);
        lq.sales_tax__c = decimal.valueOf(q.salesTax);
        lq.property_tax__c = decimal.valueOf(q.propertyTax);      
        lq.lease_charges__c = decimal.valueOf(q.leaseCharges);
        lq.security_deposit__c = decimal.valueOf(q.securityDeposit);
        lq.amount__c = decimal.valueOf(q.amount);
        lq.contract_number__c = response.contractNumber;
        newQuotes.add(lq);
 
        insert newQuotes;
        Set<ID> newQuoteSet = new Set<ID>();

        for (Lease_OLM_Quote__c l:newQuotes){
            newQuoteSet.add(l.id);
        }

        response.quotes = qList;
        
        newQuoteResponse = [SELECT Amount__c
                            ,Contract_Number__c
                            ,Discount__c
                            ,Equipment_Price__c
                            ,Id
                            ,Lease_Charges__c
                            ,LS_Contract__c
                            ,Name,OwnerId
                            ,Past_Due_Service__c
                            ,Property_Tax__c
                            ,Quote_Calculation_Description__c
                            ,Quote_Message__c
                            ,Quote_Validity_Date__c
                            ,Remaining_Rental_Payments__c
                            ,Sales_Tax__c
                            ,Security_Deposit__c
                            ,SystemModstamp
                            ,Termination_Quote_Type__c 
                            FROM Lease_OLM_Quote__c
                            where id in :newQuoteSet
        ];

        return newQuoteResponse;  

    }
    
    
    /************************************************************************************************************************************************************
    *   getQuotes
    *************************************************************************************************************************************************************/

    public static Lease_OLM_Quote__c getQuoteDetail(String quoteNumber){
        
        Lease_OLM_Quote__c q = [SELECT 
                                 Amount__c
                                ,Contract_Number__c
                                ,CreatedById
                                ,CreatedDate
                                ,Discount__c
                                ,Equipment_Price__c
                                ,Id
                                ,IsDeleted
                                ,LastActivityDate
                                ,LastModifiedById
                                ,LastModifiedDate
                                ,LastReferencedDate
                                ,LastViewedDate
                                ,Lease_Charges__c
                                ,LS_Contract__c
                                ,Name
                                ,OwnerId
                                ,Past_Due_Service__c
                                ,Property_Tax__c
                                ,Quote_Calculation_Description__c
                                ,Quote_Message__c
                                ,Quote_Validity_Date__c
                                ,Remaining_Rental_Payments__c
                                ,Sales_Tax__c
                                ,Security_Deposit__c
                                ,SystemModstamp
                                ,Termination_Quote_Type__c 
                                FROM Lease_OLM_Quote__c
                                where name = :quoteNumber
                                ];

        return q;  

    }

    /************************************************************************************************************************************************************
    *   processOLMBooking
    *************************************************************************************************************************************************************/

    public static boolean processOLMBooking(String leaseNumber, String quoteNumber, Decimal amount){
        
       return true;

    }

    /*************************************************************************************************
    * 
    * PM Get access token
	*	
    *************************************************************************************************/
    public static string getAccessToken(){     
    	
    	if (Test.isRunningTest())
    		return string.valueOf(system.now());
    		
        User u = [select contactId
                  from User
                  where id = :userInfo.getUserId()
                 ];

        /* default for testing; this is south west office */

        String client = 'b5dfbf6f-06a7-46c0-aa70-3b3eea4f4052';
    	String secret = 'd1ae6328-159e-43af-9bec-fe213cf9bda0';

        if (u.contactId != null){
            Contact c = [select  id
                                ,account.client__c
                                ,account.secret__c
                         from Contact 
                         where id = :u.contactId];

            if (c.account.client__c == null || c.account.secret__c == null){
                Integer i=0;  //use default
            }
            else{
                client = c.account.client__c;
                secret = c.account.secret__c;
            }
        }

    	HttpRequest req_token = new HttpRequest();        
		
		String tokenEndpoint = System.Label.ICV_tokenendpoint;  
		req_token.setEndpoint(tokenEndpoint);
        req_token.setMethod('POST');        
        req_token.setHeader('content-type', 'application/x-www-form-urlencoded');
        req_token.setHeader('cache-control', 'no-cache');        
        req_token.setBody('client_id='+client+'&client_secret='+secret+'&grant_type=client_credentials');
      
        Http http = new Http(); 
        HTTPResponse res = http.send(req_token);
        
		String access_token;

		JSONParser parser = JSON.createParser(res.getBody());
            
        while (parser.nextToken() != null) {
        	if (parser.getCurrentName() == 'access_token') {
            	access_token = parser.getText();
            }
        }
        
       	return access_token;
         
    }
}