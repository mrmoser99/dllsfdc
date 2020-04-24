/**
 * Author: Cloud Lending Solutions
 * Description: Following  Test Class helps to cover code for VertexUpfrontTaxCalculation
**/

@isTest
public class TestVertexUpfrontTaxCalculation {
    
    @isTest
    public static void testVertexOnUpfront()
    {
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
        
        genesis__Applications__c application = new genesis__Applications__c();
        application.genesis__Account__c=a.id;
        application.Dealer_Invoice_Number__c='123456';
        application.Dealer_Invoice_Date__c= Date.today();
        application.genesis__Term__c=12;
        application.dealer_program__c = dealerProgram.id;
        //application.genesis__Payment_Frequency__c = 'ANNUAL';
        application.genesis__Expected_Start_Date__c = Date.ValueOf(System.now());
        insert application;
     	
        genesis__Equipment_Master__c em = new genesis__Equipment_Master__c();
        em.Asset_Type_ID__c='2222';
        em.Master_Asset_Type_ID__c='1111';
        em.genesis__Equipment_Serial_Number__c='123';
        insert em;
        
        genesis__Application_Equipment__c ae = new genesis__Application_Equipment__c();
        ae.genesis__Application__c=application.id;
        ae.genesis__Equipment__c=em.id;
        ae.Install_Account__c=a.id;
        ae.Install_Address1__c=address.id;
        insert ae;
        
        System.debug('******application expected Start date******'+application.genesis__Expected_Start_Date__c);
        String JSONMsg = '{"application id" : "'+application.Id +'","Amount":"123400.00"}';
        /*List<string> appId = new List<string>();
        appId.add(application.id);*/
        genesis__Applications__c app =  [select id,name,genesis__Expected_Start_Date__c,
                                                        genesis__Account__c,
                                                        Dealer_Invoice_Number__c,
                                                        Dealer_Invoice_Date__c,
                                                        genesis__Term__c,
                                                        dealer_program__c,
                                                        genesis__Payment_Frequency__c 
                                                  From genesis__Applications__c 
                                                  WHERE ID =: application.Id Limit 1];
        
        System.debug('*****app*****'+app);
        String appId = app.Id;
        System.Test.startTest();
           VertexUpfrontTaxCalculation.VertexGetUpfrontTax(app.Name) ;
        System.Test.stopTest();
    }

    @isTest
    public static void testVertexOnUpfront2()
    {
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
        
        genesis__Applications__c application = new genesis__Applications__c();
        application.genesis__Account__c=a.id;
        application.Dealer_Invoice_Number__c='123456';
        application.Dealer_Invoice_Date__c= Date.today();
        application.genesis__Term__c=12;
        application.dealer_program__c = dealerProgram.id;
        //application.genesis__Payment_Frequency__c = 'ANNUAL';
        application.genesis__Expected_Start_Date__c = Date.ValueOf(System.now());
        insert application;
     	
        genesis__Equipment_Master__c em = new genesis__Equipment_Master__c();
        em.Asset_Type_ID__c='2222';
        em.Master_Asset_Type_ID__c='1111';
        em.genesis__Equipment_Serial_Number__c='123';
        insert em;
        
        genesis__Application_Equipment__c ae = new genesis__Application_Equipment__c();
        ae.genesis__Application__c=application.id;
        ae.genesis__Equipment__c=em.id;
        ae.Install_Account__c=a.id;
        ae.Install_Address1__c=address.id;
        insert ae;
        genesis__Application_Equipment__c ae2 = new genesis__Application_Equipment__c();
        ae2.genesis__Application__c=application.id;
        ae2.genesis__Equipment__c=em.id;
        ae2.Install_Account__c=a.id;
        ae2.Install_Address1__c=address.id;
        insert ae2;
        genesis__Application_Equipment__c ae3 = new genesis__Application_Equipment__c();
        ae3.genesis__Application__c=application.id;
        ae3.genesis__Equipment__c=em.id;
        ae3.Install_Account__c=a.id;
        ae3.Install_Address1__c=address.id;
        insert ae3;
        
        System.debug('******application expected Start date******'+application.genesis__Expected_Start_Date__c);
        String JSONMsg = '{"application id" : "'+application.Id +'","Amount":"123400.00"}';
        /*List<string> appId = new List<string>();
        appId.add(application.id);*/
        genesis__Applications__c app =  [select id,name,genesis__Expected_Start_Date__c,
                                                        genesis__Account__c,
                                                        Dealer_Invoice_Number__c,
                                                        Dealer_Invoice_Date__c,
                                                        genesis__Term__c,
                                                        dealer_program__c,
                                                        genesis__Payment_Frequency__c 
                                                  From genesis__Applications__c 
                                                  WHERE ID =: application.Id Limit 1];
        
        System.debug('*****app*****'+app);
        String appId = app.Id;
        System.Test.startTest();
            try {
                VertexUpfrontTaxCalculation.VertexGetUpfrontTax(app.Name) ;
            } catch(Exception e) {
                // ignore exception
            }
        System.Test.stopTest();
    }

}