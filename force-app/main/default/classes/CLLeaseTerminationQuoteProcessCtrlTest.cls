@isTest
public class CLLeaseTerminationQuoteProcessCtrlTest {
    
    public static List<cllease__Termination_Quote_Header__c> quoteHeaderList = new List<cllease__Termination_Quote_Header__c>();
    
    @isTest
    public static void quoteProcessCtrl(){
        //1.Create CL Application
        
        cllease__Lease_Account__c leaseContract = CLLeaseTerminationQuoteServicesTest.createContract(); 
        
        // Create Termination Configuration
        List<cllease__Termination_Config__c> configList = new List<cllease__Termination_Config__c>();
        cllease__Termination_Config__c config = new cllease__Termination_Config__c();
        config.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
        config.cllease__Enable__c           = true;
        configList.add(config);
        
        cllease__Termination_Config__c config1 = new cllease__Termination_Config__c();
        config1.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config1.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config1.cllease__Quote_Type__c       = 'TERMINATION WITHOUT PURCHASE';
        config1.cllease__Enable__c           = true;
        configList.add(config1);
        
        insert configList;
        
        List<cllease__Termination_Config_Line__c> configLines = new List<cllease__Termination_Config_Line__c>();
        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE UNBILLED RECEIVABLES',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE UNBILLED RECEIVABLE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Receivable__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Unbilled_Receivable__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Unbilled_Receivable_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Service_and_Maintenance__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Service_and_Maintainence__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Service_and_Maintenance_TAX__c',
                                                                Do_Passthrough__c               = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Rollover_Incentive__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Rollover_Incentive_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Field_API_Name__c      = 'Booked_Residual__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Purchase_Amount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Purchase_Amount_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE FEE',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE FEE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Fee__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Fee_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Add_To_Quote_Amount__c = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Estimated_Property_Tax__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Estimated_Property_Tax__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Estimated_Property_Tax_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE DISCOUNT',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE DISCOUNT',
                                                                cllease__Field_API_Name__c      = 'Quote_Discount_Roll_over__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Discount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Discount_TAX__c'
                                                                ));
        insert configLines;
        
        
        cllease__Termination_Quote_Header__c quoteHeader = new cllease__Termination_Quote_Header__c();
        quoteHeader.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
        quoteHeader.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader.cllease__Status__c                      = 'ACCEPTED';
        quoteHeader.cllease__Contract__c                    = leaseContract.Id;
        quoteHeader.cllease__Requested_Termination_Date__c  = System.today();
        quoteHeader.cllease__Termination_Date__c            = System.today();
        quoteHeader.cllease__Effective_From__c              = System.today();
        quoteHeader.cllease__Effective_To__c                = System.today().addDays(30);
        quoteHeader.cllease__Quote_Amount__c                = 1230.50;
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
        quoteHeader1.cllease__Quote_Amount__c                = 1230.50;
        quoteHeaderList.add(quoteHeader1);
        
        
        cllease__Termination_Quote_Header__c quoteHeader2 = new cllease__Termination_Quote_Header__c();
        quoteHeader2.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader2.cllease__Quote_Type__c                  = 'TERMINATION WITHOUT PURCHASE';
        quoteHeader2.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader2.cllease__Status__c                      = 'ACCEPTED';
        quoteHeader2.cllease__Contract__c                    = leaseContract.Id;  
        quoteHeader2.cllease__Requested_Termination_Date__c  = System.today();
        quoteHeader2.cllease__Termination_Date__c            = System.today();
        quoteHeader2.cllease__Effective_From__c              = System.today();
        quoteHeader2.cllease__Effective_To__c                = System.today().addDays(30);
        quoteHeader2.cllease__Quote_Amount__c                = 1260.50;
        quoteHeaderList.add(quoteHeader2);
        
        cllease__Termination_Quote_Header__c quoteHeader3 = new cllease__Termination_Quote_Header__c();
        quoteHeader3.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader3.cllease__Quote_Type__c                  = 'TERMINATION WITHOUT PURCHASE';
        quoteHeader3.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader3.cllease__Status__c                      = 'ACCEPTED';
        quoteHeader3.cllease__Contract__c                    = leaseContract.Id;  
        quoteHeader3.cllease__Requested_Termination_Date__c  = System.today();
        quoteHeader3.cllease__Termination_Date__c            = System.today();
        quoteHeader3.cllease__Effective_From__c              = System.today();
        quoteHeader3.cllease__Effective_To__c                = System.today().addDays(30);
        quoteHeader3.cllease__Quote_Amount__c                = 1260.50;
        quoteHeaderList.add(quoteHeader3); 
        
        insert quoteHeaderList;
         
        
        system.debug('quoteHeaderList==' +quoteHeaderList);
        
        
        List<genesis__Applications__c> app = setupApplication();  
        System.debug('app size =' +app.size());
        System.assertEquals(1, [Select Count() from genesis__Applications__c where id=:app[0].id]); 
        
        List<genesis__Applications__c> appList=[select id,name from genesis__Applications__c]; 
        system.debug('appList=' +appList);
        
        test.startTest();
        
        String data = CLLeaseTerminationQuoteProcessCtrl.fullTermination(app[0].id);
        String data1 = CLLeaseTerminationQuoteProcessCtrl.fullTermination(app[1].id);
        String data2 = CLLeaseTerminationQuoteProcessCtrl.fullTermination(app[2].id);
          

        test.stopTest();
        
    }
    
    @isTest
    public static void toCoverageExceptionBlock(){
        //1.Create CL Application
        
        cllease__Lease_Account__c leaseContract = CLLeaseTerminationQuoteServicesTest.createContract(); 
        
        // Create Termination Configuration
        /*List<cllease__Termination_Config__c> configList = new List<cllease__Termination_Config__c>();
        cllease__Termination_Config__c config = new cllease__Termination_Config__c();
        config.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
        config.cllease__Enable__c           = true;
        configList.add(config);
        
        cllease__Termination_Config__c config1 = new cllease__Termination_Config__c();
        config1.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config1.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config1.cllease__Quote_Type__c       = 'TERMINATION WITHOUT PURCHASE';
        config1.cllease__Enable__c           = true;
        configList.add(config1);
        
        insert configList;
        
        List<cllease__Termination_Config_Line__c> configLines = new List<cllease__Termination_Config_Line__c>();
        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE UNBILLED RECEIVABLES',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE UNBILLED RECEIVABLE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Receivable__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Unbilled_Receivable__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Unbilled_Receivable_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Service_and_Maintenance__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Service_and_Maintainence__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Service_and_Maintenance_TAX__c',
                                                                Do_Passthrough__c               = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Rollover_Incentive__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Rollover_Incentive_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Field_API_Name__c      = 'Booked_Residual__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Purchase_Amount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Purchase_Amount_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE FEE',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE FEE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Fee__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Fee_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Add_To_Quote_Amount__c = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Estimated_Property_Tax__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Estimated_Property_Tax__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Estimated_Property_Tax_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE DISCOUNT',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE DISCOUNT',
                                                                cllease__Field_API_Name__c      = 'Quote_Discount_Roll_over__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Discount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Discount_TAX__c'
                                                                ));
        insert configLines;*/
        
        
        cllease__Termination_Quote_Header__c quoteHeader = new cllease__Termination_Quote_Header__c();
        quoteHeader.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
        quoteHeader.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader.cllease__Status__c                      = 'ACCEPTED';
        quoteHeader.cllease__Contract__c                    = leaseContract.Id;
        quoteHeader.cllease__Requested_Termination_Date__c  = System.today();
        quoteHeader.cllease__Termination_Date__c            = System.today();
        quoteHeader.cllease__Effective_From__c              = System.today();
        quoteHeader.cllease__Effective_To__c                = System.today().addDays(30);
        quoteHeader.cllease__Quote_Amount__c                = 1230.50;
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
        quoteHeader1.cllease__Quote_Amount__c                = 1230.50;
        quoteHeaderList.add(quoteHeader1);
        
        
        cllease__Termination_Quote_Header__c quoteHeader2 = new cllease__Termination_Quote_Header__c();
        quoteHeader2.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader2.cllease__Quote_Type__c                  = 'TERMINATION WITHOUT PURCHASE';
        quoteHeader2.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader2.cllease__Status__c                      = 'ACCEPTED';
        quoteHeader2.cllease__Contract__c                    = leaseContract.Id;  
        quoteHeader2.cllease__Requested_Termination_Date__c  = System.today();
        quoteHeader2.cllease__Termination_Date__c            = System.today();
        quoteHeader2.cllease__Effective_From__c              = System.today();
        quoteHeader2.cllease__Effective_To__c                = System.today().addDays(30);
        quoteHeader2.cllease__Quote_Amount__c                = 1260.50;
        quoteHeaderList.add(quoteHeader2);
        
        cllease__Termination_Quote_Header__c quoteHeader3 = new cllease__Termination_Quote_Header__c();
        quoteHeader3.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader3.cllease__Quote_Type__c                  = 'TERMINATION WITHOUT PURCHASE';
        quoteHeader3.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader3.cllease__Status__c                      = 'ACCEPTED';
        quoteHeader3.cllease__Contract__c                    = leaseContract.Id;  
        quoteHeader3.cllease__Requested_Termination_Date__c  = System.today();
        quoteHeader3.cllease__Termination_Date__c            = System.today();
        quoteHeader3.cllease__Effective_From__c              = System.today();
        quoteHeader3.cllease__Effective_To__c                = System.today().addDays(30);
        quoteHeader3.cllease__Quote_Amount__c                = 1260.50;
        quoteHeaderList.add(quoteHeader3); 
        
        insert quoteHeaderList;
         
        
        system.debug('quoteHeaderList==' +quoteHeaderList);
        
        
        List<genesis__Applications__c> app = setupApplication();  
        System.debug('app size =' +app.size());
        System.assertEquals(1, [Select Count() from genesis__Applications__c where id=:app[0].id]); 
        
        List<genesis__Applications__c> appList=[select id,name from genesis__Applications__c]; 
        system.debug('appList=' +appList);
        
        test.startTest();
        
        String data = CLLeaseTerminationQuoteProcessCtrl.fullTermination(app[0].id);
        //String data1 = CLLeaseTerminationQuoteProcessCtrlCopy.fullTermination(app[1].id);
        //String data2 = CLLeaseTerminationQuoteProcessCtrlCopy.fullTermination(app[2].id);
          

        test.stopTest(); 
        
    }
       
    public static List<genesis__Applications__c> setupApplication() {

        //cllease__Lease_Account__c leaseContract = Testhelper.createContract();
        
       // Creating New Address
        Account a = new Account();
        a.Name = 'TestAccount-DealerCheckList';
        a.Phone = '98767 678987';
        a.BillingPostalCode = 'BD1 1HA';
        a.BillingCity = 'NewYork';
        a.ShippingPostalCode = 'BD1 1HA';
        a.ShippingCity = 'NewYork';
        insert a;
        
        Address__c address = new Address__c();
        address.Country__c = 'USA';
        address.Account__c = a.Id;
        address.Bill_To_Usage__c = true;
        address.Install_At__c = true;
        address.Validation_Status__c = DLLNewCoConstants.EXPERIAN_VALIDATION_STATUS;
        insert address;
        
        clcommon__Agreement__c dealerProgram = new clcommon__Agreement__c();
        dealerProgram.Name='NewCo';
        dealerProgram.clcommon__Payment_Frequency__c   = 'Monthly';
        insert dealerProgram;
        
        
        List<cllease__Termination_Quote_Header__c> quoteHeader=[select id,name from cllease__Termination_Quote_Header__c];
        System.debug('quoteHeader size=' +quoteHeader.size());
        
        List<genesis__Applications__c> applicationList = new List<genesis__Applications__c>();
        genesis__Applications__c application = new genesis__Applications__c();
        application.genesis__Account__c=a.id;
        application.Dealer_Invoice_Number__c='123456';
        application.Dealer_Invoice_Date__c= Date.today();
        application.genesis__Term__c=12;
        application.dealer_program__c = dealerProgram.id;
        application.genesis__Tax_Amount__c = 0;
        application.genesis__Payment_Frequency__c = 'MONTHLY';
        application.Oracle_Trade_up_Quote_Number__c = quoteHeader[0].name;
        application.genesis__Expected_Start_Date__c = Date.ValueOf(System.now());
        applicationList.add(application);
        
        
        genesis__Applications__c application1 = new genesis__Applications__c();
        application1.genesis__Account__c=a.id;
        application1.Dealer_Invoice_Number__c='2341536';
        application1.Dealer_Invoice_Date__c= Date.today();
        application1.genesis__Term__c=36;
        application1.dealer_program__c = dealerProgram.id;
        application1.genesis__Tax_Amount__c = 120;
        application1.genesis__Payment_Frequency__c = 'MONTHLY';
        application1.Oracle_Trade_up_Quote_Number__c = quoteHeader[1].name;
        application1.genesis__Expected_Start_Date__c = Date.ValueOf(System.now());
        applicationList.add(application1);
        
        genesis__Applications__c application2 = new genesis__Applications__c();
        application2.genesis__Account__c=a.id;
        application2.Dealer_Invoice_Number__c='2341539';
        application2.Dealer_Invoice_Date__c= Date.today();
        application2.genesis__Term__c=36;
        application2.dealer_program__c = dealerProgram.id;
        application2.genesis__Tax_Amount__c = 120;
        application2.genesis__Payment_Frequency__c = 'MONTHLY';
        application2.Oracle_Trade_up_Quote_Number__c = null;
        application2.genesis__Expected_Start_Date__c = Date.ValueOf(System.now());
        applicationList.add(application2);
        
        
        insert applicationList;

        return applicationList;
    }


}