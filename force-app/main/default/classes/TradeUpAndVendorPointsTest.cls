@isTest
public class TradeUpAndVendorPointsTest {

    @testSetup
    public static void testSetup(){
        //Creating LS Contract 
        cllease__Lease_Account__c leaseContract=TradeUpAndVendorPointsTest.createContract();    
        
        cllease__Lease_Account__c leaseContract1 = [select id,name,cllease__Dealer__c,cllease__Account__c from cllease__Lease_Account__c where id=:leaseContract.id];
        
        //Creating CL Product
        clcommon__CL_Product__c product = new clcommon__CL_Product__c();
        product.clcommon__Product_Name__c = 'Finance Lease';
        product.clcommon__Class__c = 'Commercial';
        product.Active__c = true;
        insert product;
        
        //Creating Legal Entity
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c();
        legal.clcommon__Legal_Entity_Type_Code__c = '1234';
        legal.Name = 'Corporation'; 
        insert legal;
        
        
        // 1. Creating Account
        Account acc = new Account();
        acc.Name = 'Patriot Group LTD';
        //acc.RecordType = 'Dealer';
        acc.clcommon__Legal_Entity_Type__c =legal.id;
        acc.Phone = '98767 678987';
        acc.BillingPostalCode = 'BD1 1HA';
        acc.BillingCity = 'NewYork';
        acc.ShippingPostalCode = 'BD1 1HA';
        acc.ShippingCity = 'NewYork';
        insert acc;
        
        // 2. Creating Address
        Address__c address = new Address__c();
        address.Country__c = 'USA';
        address.Account__c = acc.Id;
        address.Bill_To_Usage__c = true;
        address.Install_At__c = true;
        address.Validation_Status__c = DLLNewCoConstants.EXPERIAN_VALIDATION_STATUS;
        address.Primary_Address__c = true;
        insert address;
        
        clcommon__Agreement__c dealerProgram = new clcommon__Agreement__c();
        dealerProgram.Name='NewCo';
        dealerProgram.clcommon__Payment_Frequency__c   = 'Monthly';
        insert dealerProgram;
        
        clcommon__Calculation_Set__c calculationSet = new clcommon__Calculation_Set__c();
        calculationSet.name='Fixed';
        insert calculationSet;
        
        //Creating Point Setup
        clcommon__Points_Setup__c pointSetup = new clcommon__Points_Setup__c();
        pointSetup.clcommon__Calculation_Basis__c = calculationSet.id;
        pointSetup.clcommon__Enabled__c = true;
        pointSetup.clcommon__Points__c = 9;
        pointSetup.clcommon__Points_Type__c = 'Vendor';
        pointSetup.clcommon__Start_Date__c = System.today();
        insert pointSetup;
        
        
        //Creating Program
        List<clcommon__Program__c> programList = new List<clcommon__Program__c>();
        clcommon__Program__c program = new clcommon__Program__c();
        program.Name = 'TestCKBProgram';
        programList.add(program);
        
        clcommon__Program__c program1 = new clcommon__Program__c();
        program1.Name = 'TestCKBProgram1';
        programList.add(program1);
        insert programList;
        
        //Creating Vendor Program Association
        List<clcommon__Vendor_Program_Association__c> vendorProgList = new List<clcommon__Vendor_Program_Association__c>();
        clcommon__Vendor_Program_Association__c vendorProg = new clcommon__Vendor_Program_Association__c();
        vendorProg.Default_Program__c = true;
        vendorProg.clcommon__Program__c = programList[0].id;
        vendorProg.clcommon__Vendor__c = acc.id;
        vendorProgList.add(vendorProg);
        
        clcommon__Vendor_Program_Association__c vendorProg1 = new clcommon__Vendor_Program_Association__c();
        vendorProg1.Default_Program__c = false;
        vendorProg1.clcommon__Program__c = programList[1].id;
        vendorProg1.clcommon__Vendor__c = acc.id;
        vendorProgList.add(vendorProg1);
        
        insert vendorProgList;
        
        //Creating Program Or Product Points Association
        List<clcommon__Program_Or_Product_Points_Association__c> progProductAssList = new List<clcommon__Program_Or_Product_Points_Association__c>();
        clcommon__Program_Or_Product_Points_Association__c progProductAss = new clcommon__Program_Or_Product_Points_Association__c();
        progProductAss.clcommon__Accounts_Payable__c = leaseContract1.cllease__Dealer__c;
        progProductAss.clcommon__Points_Setup__c = pointSetup.id;
        progProductAss.name = '9% Vendor Points CKB';
        progProductAss.clcommon__CL_Product__c = product.id;
        progProductAss.Default_Vendor_Point__c = true;
        progProductAss.clcommon__Program__c = programList[0].id;
        progProductAssList.add(progProductAss);
        
        clcommon__Program_Or_Product_Points_Association__c progProductAss1 = new clcommon__Program_Or_Product_Points_Association__c();
        progProductAss1.clcommon__Accounts_Payable__c = leaseContract1.cllease__Dealer__c;
        progProductAss1.clcommon__Points_Setup__c = pointSetup.id;
        progProductAss1.name = '9% Vendor Points CKB';
        progProductAss1.clcommon__CL_Product__c = product.id;
        progProductAss1.Default_Vendor_Point__c = true;
        progProductAss1.clcommon__Program__c = programList[1].id;
        progProductAssList.add(progProductAss1);
        
        insert progProductAssList;
        
        //Creating Fee Defination
        clcommon__Fee_Definition__c  VendorFees = new clcommon__Fee_Definition__c();
        VendorFees.Name = 'Vendor Points';
        VendorFees.clcommon__Amount__c=10.00; 
        VendorFees.clcommon__Class__c= 'Expense';
        VendorFees.clcommon__Active__c = true;
        VendorFees.clcommon__Calculation_Method__c = 'Fixed';
        insert VendorFees;
        
        //creating QuickQuote
        genesis__Quick_Quotes__c quickQuote = new genesis__Quick_Quotes__c();
        quickQuote.Dealer__c = acc.id;
        quickQuote.genesis__Account__c =leaseContract1.cllease__Account__c;
        quickQuote.genesis__CL_Product__c = product.id;
        quickQuote.Dealer_Name__c = 'Patriot Group LTD';
        quickQuote.genesis__Business_Name__c = 'TestCKB28127';
        quickQuote.genesis__Address_Line_1__c ='207 John F Kennedy Blvd';
        quickQuote.genesis__City__c = 'Lawnside';
        quickQuote.County__c = 'Camden';
        quickQuote.genesis__State__c = 'NJ';
        quickQuote.genesis__Postal_Code__c = '08045-1035';
        quickQuote.Trade_Up_From__c = '';
        quickQuote.Primary_Phone_number__c = '1234554321';
        quickQuote.Email_Address__c = 'test@test.com';
        quickQuote.Estimated_Financed_Amount__c = '50000';
        quickQuote.Approved_Credit_Amount__c = 50000.00;
        insert quickQuote;
    }
    
    @isTest
    public static void testCLSTradeUpPopulateFields(){
        //Creating LS Contract 
        cllease__Lease_Account__c leaseContract=TradeUpAndVendorPointsTest.createContract();    
        
         
        // Create Termination Configuration
        cllease__Termination_Config__c config = new cllease__Termination_Config__c();
        config.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
        insert config;

        List<cllease__Termination_Config_Line__c> configLines = new List<cllease__Termination_Config_Line__c>();
        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE UNBILLED RECEIVABLES',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE UNBILLED RECEIVABLE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Receivable__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Unbilled_Receivable__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Unbilled_Receivable_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Service_and_Maintenance__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Service_and_Maintainence__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Service_and_Maintenance_TAX__c',
                                                                Do_Passthrough__c               = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Rollover_Incentive__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Rollover_Incentive_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Field_API_Name__c      = 'Booked_Residual__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Purchase_Amount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Purchase_Amount_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE FEE',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE FEE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Fee__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Fee_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Add_To_Quote_Amount__c = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Estimated_Property_Tax__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Estimated_Property_Tax__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Estimated_Property_Tax_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE DISCOUNT',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE DISCOUNT',
                                                                cllease__Field_API_Name__c      = 'Quote_Discount_Roll_over__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Discount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Discount_TAX__c'
                                                                ));
        insert configLines;
        
        cllease__Lease_Account__c leaseContract1 = [select id,name,cllease__Dealer__c,cllease__Account__c from cllease__Lease_Account__c where id=:leaseContract.id];
       
        
        // Create Termination Quote manually: Termination Quote Header , Termination QUote Lines, Termination Quote Equipments
        List<cllease__Contract_Equipment__c> eqpList = [Select Id, Install_Address__c
                                                            From cllease__Contract_Equipment__c
                                                            Where cllease__Contract__c = :leaseContract.Id LIMIT 1];

        
        List<cllease__Termination_Quote_Header__c> quoteHeaderList = new List<cllease__Termination_Quote_Header__c>();
        cllease__Termination_Quote_Header__c quoteHeader = new cllease__Termination_Quote_Header__c();
        quoteHeader.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
        quoteHeader.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader.cllease__Status__c                      = 'GENERATED';
        quoteHeader.cllease__Contract__c                    = leaseContract.Id;
        quoteHeader.cllease__Requested_Termination_Date__c  = System.today();
        quoteHeader.cllease__Termination_Date__c            = System.today();
        quoteHeader.cllease__Effective_From__c              = System.today();
        quoteHeader.cllease__Effective_To__c                = System.today().addDays(30);
        quoteHeaderList.add(quoteHeader);
        
        cllease__Termination_Quote_Header__c quoteHeader1 = new cllease__Termination_Quote_Header__c();
        quoteHeader1.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader1.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
        quoteHeader1.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader1.cllease__Status__c                      = 'GENERATED';
        quoteHeader1.cllease__Contract__c                    = leaseContract.Id;
        quoteHeader1.cllease__Requested_Termination_Date__c  = System.today();
        quoteHeader1.cllease__Termination_Date__c            = System.today();
        quoteHeader1.cllease__Effective_From__c              = System.today();
        quoteHeader1.cllease__Effective_To__c                = System.today().addDays(30);
        quoteHeaderList.add(quoteHeader1);
        
        insert quoteHeaderList;
        

        // Creating Termination Quote Lines
        List<cllease__Termination_Quote_Line__c> quoteLines = new List<cllease__Termination_Quote_Line__c>();
        for(cllease__Termination_Config_Line__c configLine : configLines) {
            quoteLines.add(new cllease__Termination_Quote_Line__c(cllease__Amount__c                    = 100, 
                                                                     cllease__Line_Type__c               = configLine.cllease__Quote_Line__c,
                                                                     cllease__Amount_Type__c             = 'LINE',
                                                                     cllease__Billable__c                = true,
                                                                     cllease__Account_Balance_Type__c    = configLine.cllease__Account_Balance_Type__c,
                                                                     cllease__Is_Account_Balancable__c   = false,
                                                                     cllease__Add_To_Quote_Amount__c     = true,
                                                                     cllease__Bill_Field_API_Name__c     = configLine.cllease__Bill_Field_API_Name__c,
                                                                     cllease__Quote_Header__c            = quoteHeaderList[0].Id));
            
            quoteLines.add(new cllease__Termination_Quote_Line__c(cllease__Amount__c                    = 100, 
                                                                     cllease__Line_Type__c               = configLine.cllease__Quote_Line__c,
                                                                     cllease__Amount_Type__c             = 'LINE',
                                                                     cllease__Billable__c                = true,
                                                                     cllease__Account_Balance_Type__c    = configLine.cllease__Account_Balance_Type__c,
                                                                     cllease__Is_Account_Balancable__c   = false,
                                                                     cllease__Add_To_Quote_Amount__c     = true,
                                                                     cllease__Bill_Field_API_Name__c     = configLine.cllease__Bill_Field_API_Name__c,
                                                                     cllease__Quote_Header__c            = quoteHeaderList[1].Id));
        }
        insert quoteLines;

        // Creatign Termination QUote Equipment
        List<cllease__Termination_Quote_Equipment__c> termQuoteEqpList = new List<cllease__Termination_Quote_Equipment__c>();
        for(cllease__Contract_Equipment__c eqp : eqpList) {
            termQuoteEqpList.add(new cllease__Termination_Quote_Equipment__c(cllease__Contract_Equipment__c = eqp.Id, cllease__Termination_Quote_Header__c = quoteHeader.Id));
        }
        insert termQuoteEqpList;

        // Edit Termination Quote Line for Taxation
        if(quoteLines.size()>0){
            for(integer i=0;i<quoteLines.size();i++){
                quoteLines[i].cllease__Amount__c = 200;
            }
            update quoteLines;
        }
        
        

        // Termination quote Acceptance
        if(quoteHeaderList.size()>0){
            for(integer i=0;i<quoteHeaderList.size();i++){
                quoteHeaderList[i].cllease__Status__c = 'ACCEPTED';
                //quoteHeaderList[1].cllease__Status__c = 'ACCEPTED';
            }
           try{
             update quoteHeaderList;
           }catch(Exception ex){
               System.debug('Exception :' +ex);
           }
           
        }
        
        
        //Creating Legal Entity
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c();
        legal.clcommon__Legal_Entity_Type_Code__c = '1234';
        legal.Name = 'Corporation'; 
        insert legal;
        
        
        //Creating dealer Account
        Account acc = new Account();
        //acc.RecordType = 'Dealer';
        acc.Name = 'Patriot Group LTD';
        acc.Phone = '8005210001';
        acc.clcommon__Legal_Entity_Type__c =legal.id;
        insert acc;
        
        //Creating CL Product
        clcommon__CL_Product__c product = new clcommon__CL_Product__c();
        product.clcommon__Product_Name__c = 'Finance Lease';
        product.clcommon__Class__c = 'Commercial';
        product.Active__c = true;
        insert product;
        
        
        // Insert Quick Quote
        List<genesis__Quick_Quotes__c> quickQuoteList= new List<genesis__Quick_Quotes__c>();
        genesis__Quick_Quotes__c quickQuote = new genesis__Quick_Quotes__c();
        quickQuote.Dealer__c = leaseContract1.cllease__Dealer__c;
        quickQuote.genesis__Account__c = leaseContract1.cllease__Account__c;
        quickQuote.genesis__CL_Product__c = product.id;
        quickQuote.Dealer_Name__c = 'Patriot Group LTD';
        quickQuote.genesis__Business_Name__c = 'TestCKB28127';
        quickQuote.genesis__Address_Line_1__c ='207 John F Kennedy Blvd';
        quickQuote.genesis__City__c = 'Lawnside';
        quickQuote.County__c = 'Camden';
        quickQuote.genesis__State__c = 'NJ';
        quickQuote.genesis__Postal_Code__c = '08045-1035';
        quickQuote.Trade_Up_From__c = 'CL Lease';
        quickQuote.CLS_Trade_Up_Quote_Number__c = quoteHeaderList[0].id;
        quickQuote.Primary_Phone_number__c = '1234554321';
        quickQuote.Email_Address__c = 'test@test.com';
        quickQuote.Estimated_Financed_Amount__c = '50000';
        quickQuote.Approved_Credit_Amount__c = 50000.00;
        quickQuoteList.add(quickQuote);
        
        genesis__Quick_Quotes__c quickQuote1 = new genesis__Quick_Quotes__c();
        quickQuote1.Dealer__c = leaseContract1.cllease__Dealer__c;
        quickQuote1.genesis__Account__c = leaseContract1.cllease__Account__c;
        quickQuote1.genesis__CL_Product__c = product.id;
        quickQuote1.Dealer_Name__c = 'Patriot Group LTD';
        quickQuote1.genesis__Business_Name__c = 'TestCKB28127';
        quickQuote1.genesis__Address_Line_1__c ='207 John F Kennedy Blvd';
        quickQuote1.genesis__City__c = 'Lawnside';
        quickQuote1.County__c = 'Camden';
        quickQuote1.genesis__State__c = 'NJ';
        quickQuote1.genesis__Postal_Code__c = '08045-1035';
        quickQuote1.Trade_Up_From__c = 'CL Lease';
        quickQuote1.CLS_Trade_Up_Quote_Number__c = quoteHeaderList[0].id;
        quickQuote1.Primary_Phone_number__c = '1234554321';
        quickQuote1.Email_Address__c = 'test@test.com';
        quickQuote1.Estimated_Financed_Amount__c = '50000';
        quickQuote1.Approved_Credit_Amount__c = 50000.00;
        quickQuoteList.add(quickQuote1);
        
        
        insert quickQuoteList;
        
        if(quickQuoteList.size()>0){
            quickQuoteList[0].CLS_Trade_Up_Quote_Number__c = quoteHeaderList[1].id;
            update quickQuoteList[0];
        }
        
        if(quickQuoteList.size()>0){
            quickQuoteList[1].CLS_Trade_Up_Quote_Number__c = null;
            update quickQuoteList[1];
        }
        
        
    }
    @isTest
    public static void testCLSTradeUpPopulateFields1(){
         //Creating LS Contract 
        cllease__Lease_Account__c leaseContract=TradeUpAndVendorPointsTest.createContract();    
        
        cllease__Lease_Account__c leaseContract1 = [select id,name,cllease__Dealer__c,cllease__Account__c from cllease__Lease_Account__c where id=:leaseContract.id];
        
        // Create Termination Configuration
        cllease__Termination_Config__c config = new cllease__Termination_Config__c();
        config.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
        insert config;

        List<cllease__Termination_Config_Line__c> configLines = new List<cllease__Termination_Config_Line__c>();
        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE UNBILLED RECEIVABLES',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE UNBILLED RECEIVABLE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Receivable__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Unbilled_Receivable__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Unbilled_Receivable_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Service_and_Maintenance__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Service_and_Maintainence__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Service_and_Maintenance_TAX__c',
                                                                Do_Passthrough__c               = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Rollover_Incentive__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Rollover_Incentive_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Field_API_Name__c      = 'Booked_Residual__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Purchase_Amount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Purchase_Amount_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE FEE',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE FEE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Fee__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Fee_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Add_To_Quote_Amount__c = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Estimated_Property_Tax__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Estimated_Property_Tax__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Estimated_Property_Tax_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE DISCOUNT',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE DISCOUNT',
                                                                cllease__Field_API_Name__c      = 'Quote_Discount_Roll_over__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Discount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Discount_TAX__c'
                                                                ));
        insert configLines;
        
        // Create Termination Quote manually: Termination Quote Header , Termination QUote Lines, Termination Quote Equipments
        List<cllease__Contract_Equipment__c> eqpList = [Select Id, Install_Address__c
                                                            From cllease__Contract_Equipment__c
                                                            Where cllease__Contract__c = :leaseContract.Id LIMIT 1];

        
        List<cllease__Termination_Quote_Header__c> quoteHeaderList = new List<cllease__Termination_Quote_Header__c>();
        cllease__Termination_Quote_Header__c quoteHeader = new cllease__Termination_Quote_Header__c();
        quoteHeader.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
        quoteHeader.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader.cllease__Status__c                      = 'GENERATED';
        quoteHeader.cllease__Contract__c                    = leaseContract.Id;
        quoteHeader.cllease__Requested_Termination_Date__c  = System.today();
        quoteHeader.cllease__Termination_Date__c            = System.today();
        quoteHeader.cllease__Effective_From__c              = System.today();
        quoteHeader.cllease__Effective_To__c                = System.today().addDays(30);
        quoteHeaderList.add(quoteHeader);
        
        insert quoteHeaderList;
        
        // Creating Termination Quote Lines
        List<cllease__Termination_Quote_Line__c> quoteLines = new List<cllease__Termination_Quote_Line__c>();
        for(cllease__Termination_Config_Line__c configLine : configLines) {
            quoteLines.add(new cllease__Termination_Quote_Line__c(cllease__Amount__c                    = 100, 
                                                                     cllease__Line_Type__c               = configLine.cllease__Quote_Line__c,
                                                                     cllease__Amount_Type__c             = 'LINE',
                                                                     cllease__Billable__c                = true,
                                                                     cllease__Account_Balance_Type__c    = configLine.cllease__Account_Balance_Type__c,
                                                                     cllease__Is_Account_Balancable__c   = false,
                                                                     cllease__Add_To_Quote_Amount__c     = true,
                                                                     cllease__Bill_Field_API_Name__c     = configLine.cllease__Bill_Field_API_Name__c,
                                                                     cllease__Quote_Header__c            = quoteHeaderList[0].Id));
            
            
        }
        insert quoteLines;

        // Creatign Termination QUote Equipment
        List<cllease__Termination_Quote_Equipment__c> termQuoteEqpList = new List<cllease__Termination_Quote_Equipment__c>();
        for(cllease__Contract_Equipment__c eqp : eqpList) {
            termQuoteEqpList.add(new cllease__Termination_Quote_Equipment__c(cllease__Contract_Equipment__c = eqp.Id, cllease__Termination_Quote_Header__c = quoteHeader.Id));
        }
        insert termQuoteEqpList;

        // Edit Termination Quote Line for Taxation
        quoteLines[0].cllease__Amount__c = 200;
        update quoteLines[0];

        // Validate Termination Quote Taxation

        // Termination quote Acceptance
        if(quoteHeaderList.size()>0){
            //for(integer i=0;i<quoteHeaderList.size();i++){
                quoteHeaderList[0].cllease__Status__c = 'ACCEPTED';
            //}
           update quoteHeaderList[0];
        }
        
        
        //Creating Legal Entity
        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c();
        legal.clcommon__Legal_Entity_Type_Code__c = '1234';
        legal.Name = 'Corporation'; 
        insert legal;
        
        
        //Creating dealer Account
        Account acc = new Account();
        //acc.RecordType = 'Dealer';
        acc.Name = 'Patriot Group LTD';
        acc.Phone = '8005210001';
        acc.clcommon__Legal_Entity_Type__c =legal.id;
        insert acc;
        
        //Creating CL Product
        clcommon__CL_Product__c product = new clcommon__CL_Product__c();
        product.clcommon__Product_Name__c = 'Finance Lease';
        product.clcommon__Class__c = 'Commercial';
        product.Active__c = true;
        insert product;
        
        
        // Insert Quick Quote
        List<genesis__Quick_Quotes__c> quickQuoteList= new List<genesis__Quick_Quotes__c>();
        genesis__Quick_Quotes__c quickQuote1 = new genesis__Quick_Quotes__c();
        quickQuote1.Dealer__c = leaseContract1.cllease__Dealer__c;
        quickQuote1.genesis__Account__c = leaseContract1.cllease__Account__c;
        quickQuote1.genesis__CL_Product__c = product.id;
        quickQuote1.Dealer_Name__c = 'Patriot Group LTD';
        quickQuote1.genesis__Business_Name__c = 'TestCKB28127';
        quickQuote1.genesis__Address_Line_1__c ='207 John F Kennedy Blvd';
        quickQuote1.genesis__City__c = 'Lawnside';
        quickQuote1.County__c = 'Camden';
        quickQuote1.genesis__State__c = 'NJ';
        quickQuote1.genesis__Postal_Code__c = '08045-1035';
        quickQuote1.Trade_Up_From__c = 'CL Lease';
        quickQuote1.CLS_Trade_Up_Quote_Number__c =null;
        quickQuote1.Primary_Phone_number__c = '1234554321';
        quickQuote1.Email_Address__c = 'test@test.com';
        quickQuote1.Estimated_Financed_Amount__c = '50000';
        quickQuote1.Approved_Credit_Amount__c = 50000.00;
        quickQuoteList.add(quickQuote1);
        
        insert quickQuoteList;
    }
    
    @isTest
    public static void testVendorPointsUpdateApplicationWithCLSTradeUp(){
        
        Account acc = [select id,name from Account limit 1];
        genesis__Quick_Quotes__c quickQuote = [select id,name,Dealer__c from genesis__Quick_Quotes__c limit 1];
        clcommon__Program__c program = [select id,name from clcommon__Program__c limit 1];
        clcommon__Agreement__c dealerProgram = [select id,name from clcommon__Agreement__c limit 1];
        clcommon__Fee_Definition__c VendorFees =[select id,name from clcommon__Fee_Definition__c limit 1];
        Address__c address = [select id,name from Address__c limit 1];
        clcommon__Points_Setup__c pointSetup = [select id,name from clcommon__Points_Setup__c limit 1];
        
        
        // Creating Application
        genesis__Applications__c application = new genesis__Applications__c();
        application.genesis__Account__c=acc.id;
        application.Trade_Up_From__c = 'Oracle';
        application.genesis__Quick_Quote__c = quickQuote.id;
        application.genesis__Vendor__c = quickQuote.Dealer__c; 
        application.genesis__Program__c = program.id;
        application.Dealer_Invoice_Number__c='123456';
        application.Dealer_Invoice_Date__c= Date.today();
        application.genesis__Term__c=36;
        application.dealer_program__c = dealerProgram.id;
        application.genesis__Tax_Amount__c = 0;
        application.genesis__Payment_Frequency__c = 'MONTHLY';
        application.genesis__Expected_Start_Date__c = Date.ValueOf(System.now());
        application.genesis__Financed_Amount__c=20000.00;
        application.genesis__Expected_First_Payment_Date__c=system.today()+30;
        application.Purchase_Option__c = 'Fair Market Value';
        
        insert application;
        
        // Creating Application Fees
        Application_Fee__c appFee = new Application_Fee__c();
        appFee.Application__c = application.id;
        appFee.Fee__c=VendorFees.id;
        appFee.Amount__c = 250;
        appFee.Number_of_Payments__c=1;
        appFee.Frequency__c = 'ONE TIME';
        appFee.Start_Date__c = application.genesis__Expected_Start_Date__c;
        try{
            insert appFee;
        }catch(Exception ex){
           System.debug('Exception :::' + ex + ' Line Number:::' + ex.getLineNumber());
        }
        
        //creating Equipment Master
        genesis__Equipment_Master__c em = new genesis__Equipment_Master__c();
        em.Asset_Type_ID__c='2222';
        em.Master_Asset_Type_ID__c='1111';
        em.genesis__Equipment_Serial_Number__c='123';
        insert em;
        
        genesis__Application_Equipment__c ae = new genesis__Application_Equipment__c();
        ae.genesis__Application__c=application.id;
        ae.genesis__Equipment__c=em.id;
        ae.Install_Account__c=acc.id;
        ae.Install_Address1__c=address.id;
        ae.genesis__Estimated_Selling_Price__c = 25000.00;
        insert ae;
        
        CLVendorPoint.isDefaultProgram =true;
        ae.genesis__Estimated_Selling_Price__c = 27000.00;
        try{
            update ae;
        }catch(Exception ex){
            System.debug(ex);
        }

        //creating Points
        List<clcommon__Points__c> pointList = new List<clcommon__Points__c>();
        clcommon__Points__c point = new clcommon__Points__c();
        point.clcommon__Points_Type__c ='Vendor';
        point.genesis__Points_Setup__c =pointSetup.id;
        point.genesis__Application__c = application.id;
        point.clcommon__Points__c = 9;
        point.clcommon__Points_Amount__c = 2250.00;
        pointList.add(point);
        
        clcommon__Points__c point1 = new clcommon__Points__c();
        point1.clcommon__Points_Type__c ='Vendor';
        point1.genesis__Points_Setup__c =pointSetup.id;
        point1.genesis__Application__c = application.id;
        point1.clcommon__Points__c = 8;
        point1.clcommon__Points_Amount__c = 2000.00;
        pointList.add(point1);
        
        System.debug('pointList=====' +pointList);
        
        try{
          insert pointList;
        }catch(Exception ex){
          System.debug('Exception :' + ex);
        }
        
    }
    @isTest
    public static void testVendorPointsAccumulatedPointsAmount(){
    
    }
    @isTest
    public static void testVendorPointsDealerPoints(){
    
    }
    @isTest
    public static void testVendorPointsPricingDetail(){
    
    }
    @isTest
    public static void testVendorPointsUpdateDefaultProgram(){
    
    }
    
    @isTest
    public static void testVendorPointsPayTo(){
    
    }
    
    @isTest
    public static void testCLVendorPoint(){
    
    }
    
    @isTest
    public static void testApplicationCustomTriggerHandler(){
    
    }
    
    /*public static genesis__Applications__c setupApplication() {
        
        //return application;
    }*/
    
    //Method create the Sample Data needed for LS Contract creation.        
    public static cllease__Lease_Account__c createContract() {
        system.debug('creating seed data');
        cllease.TestHelper.createSeedDataForTesting();
        
        // Setting Current System Date in Test Context
        Date currentSystemDate = Date.newInstance(2018, 03, 31);
                
        // 1. Pre-Setup
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        dummyFee.clcommon__Amount__c            = 100;
        dummyFee.clcommon__Amortization_Method__c  = 'Income Basis';
        update dummyFee;
        clcommon__Fee_Set__c  dummyFeeSet       = cllease.Testhelper.createLeaseFeeSet();
        insert new clcommon__Fee_Junction__c( clcommon__Fee__c = dummyFee.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);
        
        clcommon__Fee_Definition__c  dummyFee2   = cllease.Testhelper.createLeaseFee();
        dummyFee2.clcommon__Type__c              = 'NSF Fees';
        dummyFee2.clcommon__Amount__c            = 100;
        dummyFee2.clcommon__Amortization_Method__c  = 'Income Basis';
        update dummyFee2;
               
        insert new clcommon__Fee_Junction__c(clcommon__Fee__c = dummyFee2.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);
        insert new cllease__Transaction_Sub_Type__c(Name = 'NSF Fees');
        
        clcommon__Fee_Definition__c  latefee   = cllease.Testhelper.createLeaseFee();
        latefee.clcommon__Type__c              = 'Late Fees';
        latefee.clcommon__Calculation_Method__c= 'AMOUNT CALCULATED AS % OF RENT DUE';
        latefee.clcommon__Amount__c            = 25;
        update latefee;
        
        insert new clcommon__Fee_Junction__c(clcommon__Fee__c = latefee.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);
        insert new cllease__Transaction_Sub_Type__c(Name = 'Late Fees');
        
        cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office', true);
        dummyOffice.cllease__Current_System_Date__c = currentSystemDate;
        dummyOffice.Dll_Seg1_Company__c         = '00101';
        dummyOffice.Dll_Seg2_Business_Unit__c   = '02';
        dummyOffice.Dll_Seg3_Department__c      = '3030';
        dummyOffice.Dll_Seg6__c                 = '00000';
        dummyOffice.Dll_Seg7__c                 = '0000';
        dummyOffice.cllease__tax_method__c = 'Exclusive';
        dummyOffice.cllease__Vat_Rate__c = 0;
        dummyOffice.cllease__Currency_Precision__c = 2;
        dummyOffice.cllease__Mark_Suspended_After_Days__c  = 180;
        dummyOffice.cllease__Prior_Period_Income_Reversal_Days__c = 0;
        update dummyOffice;        
         
        Account dummyAccount = new Account(Name = 'Sample Account', clcommon__Generate_Invoice_Letter__c = true);
        insert dummyAccount;

        // 2. Creating Sample Product with rental and Dep Streams enabled
        cllease__Lease_Product__c dummyLP    = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        dummyLP.cllease__Use_Open_Acct_Period__c = true;
        update dummyLP;

        Address__c address = new Address__c (
            Address_Line_1__c   = '123 Main Street',
            City__c             = 'Morristown',
            State__c            = 'NJ',
            County__c           = 'Morris',
            Country__c          = 'USA',
            Account__c          = dummyAccount.Id,
            Bill_To_Usage__c    = true,
            Install_At__c       = true,
            Validation_Status__c = DLLNewCoConstants.EXPERIAN_VALIDATION_STATUS,
            Zip_Code__c         = '95307-7506'
            );
        insert address;
        
        // 3.Creating Contract
        Date currentDate = currentSystemDate;
        cllease__Lease_Account__c leaseAccount      = new cllease__Lease_Account__c();
        leaseaccount.cllease__Account__c            = dummyAccount.Id;
        leaseaccount.cllease__Dealer__c             = dummyAccount.Id;
        leaseAccount.cllease__Lease_Product_Name__c = dummyLP.Id;
        leaseAccount.cllease__Contract_Date__c      = currentDate;
        leaseaccount.cllease__Financed_Amount__c    = 10000;
        leaseAccount.cllease__Term__c               = 12;
                
        // 3.a Adding Equipments to Contract
        List<cllease__Contract_Equipment__c> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c   = 10000,
                                                                    cllease__Status__c                  = 'LEASED',
                                                                    Install_Address__c                  = address.Id,
                                                                    Install_Account__c                  = dummyAccount.Id,
                                                                    Serial_Number__c                    ='test123',
                                                                    cllease__Equipment_Type__c='TRUCK',
                                                                    cllease__Equipment_Serial_Number__c='SFKLJADK',
                                                                    cllease__Equipment_Description__c='',
                                                                    cllease__Equipment_Cost__c=10000,
                                                                    cllease__Model__c='WC8473',
                                                                    Install_Date__c=System.today()));
              
        // 3.b Adding Payment Schedules to Contract
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 1, cllease__Number_Of_Payments__c = 12,
                            cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                            cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = currentDate,
                            cllease__Total_Payment__c = 1200));
        
                
        system.debug('******************** leaseAccount: ' + leaseAccount) ;
        // 4. Calling ContractBuilder for Contract Creation
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        system.debug('equipment: ' + contractEquipments);
        builder.addChildObjects(paymentDetails);
        system.debug('payment:' + paymentDetails);
                
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        System.debug(LoggingLevel.ERROR, ' Response from Contract Creation: '+response);
        // Validating Contract Activation
        System.assert(response.containsIgnoreCase('Contract Creation Successful'));
        cllease__Lease_Account__c lease=[select id,name,cllease__Dealer__c,cllease__Account__c from cllease__Lease_Account__c];
        System.debug('lease ===='+lease);
        return builder.getContract();
    }
}