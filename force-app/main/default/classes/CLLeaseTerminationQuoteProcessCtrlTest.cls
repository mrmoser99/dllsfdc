@isTest
public class CLLeaseTerminationQuoteProcessCtrlTest {
    
    @isTest
    public static void quoteProcessCtrl(){
        //1.Create CL Application
        
        List<genesis__Applications__c> app = setupApplication();  
        System.assertEquals(1, [Select Count() from genesis__Applications__c where id=:app[0].id]); 
        
        List<genesis__Applications__c> appList=[select id,name,Oracle_Trade_up_Quote_Number__c from genesis__Applications__c where id=:app[0].id]; 
        system.debug('appList=' +appList);
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
        
        List<cllease__Termination_Quote_Header__c> quoteHeaderList = new List<cllease__Termination_Quote_Header__c>();
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
        
        test.startTest();
        String data = CLLeaseTerminationQuoteProcessCtrl.fullTermination(app[0].id);
        String data1 = CLLeaseTerminationQuoteProcessCtrl.fullTermination(app[1].id); 
        system.debug('Data =' +data);
        test.stopTest();
        
    }
       
    public static List<genesis__Applications__c> setupApplication() {

        Testhelper.getVertexCustomSettings();
        
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
        
        List<genesis__Applications__c> applicationList = new List<genesis__Applications__c>();
        genesis__Applications__c application = new genesis__Applications__c();
        application.genesis__Account__c=a.id;
        application.Dealer_Invoice_Number__c='123456';
        application.Dealer_Invoice_Date__c= Date.today();
        application.genesis__Term__c=12;
        application.dealer_program__c = dealerProgram.id;
        application.genesis__Tax_Amount__c = 0;
        application.genesis__Payment_Frequency__c = 'MONTHLY';
        application.Oracle_Trade_up_Quote_Number__c = 'QTE-0000000122';
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
        application1.Oracle_Trade_up_Quote_Number__c = null;
        application1.genesis__Expected_Start_Date__c = Date.ValueOf(System.now());
        applicationList.add(application1);
        
        insert applicationList;

        return applicationList;
    }


}