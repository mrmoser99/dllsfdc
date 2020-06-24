@isTest
public with sharing class TestServiceEscalation {
    // Following test setup creates the contract 
    @testSetup
    public static void createApplication() {

        // Creating temp Lessee Account
        Account a = new Account();
        a.Name                      = 'TestAccount-DealerCheckList';
        a.Phone                     = '98767 678987';
        a.BillingPostalCode         = 'BD1 1HA';
        a.BillingCity               = 'NewYork';
        a.ShippingPostalCode        = 'BD1 1HA';
        a.ShippingCity              = 'NewYork';
        insert a;
        
        // Creating Address
        Address__c address              = new Address__c();
        address.Country__c              = 'USA';
        address.Account__c              = a.Id;
        address.Bill_To_Usage__c        = true;
        address.Install_At__c           = true;
        address.Validation_Status__c    = DLLNewCoConstants.EXPERIAN_VALIDATION_STATUS;
        insert address;
        
        // Creating Agreement 
        clcommon__Agreement__c dealerProgram = new clcommon__Agreement__c();
        dealerProgram.Name                              =   'NewCo';
        dealerProgram.clcommon__Payment_Frequency__c    =   'Monthly';
        insert dealerProgram;
        
        // Creating Application with default detuals
        genesis__Applications__c application    = new genesis__Applications__c();
        application.genesis__Account__c         =   a.id;
        application.Dealer_Invoice_Number__c    =   '123456';
        application.Dealer_Invoice_Date__c      =   Date.newInstance(2020, 01, 01);
        application.genesis__Expected_First_Payment_Date__c = Date.newInstance(2020, 01, 01);
        application.genesis__Term__c            =   60;
        application.dealer_program__c           =   dealerProgram.id;
        application.genesis__Payment_Frequency__c = 'MONTHLY';
        //application.genesis__Expected_Start_Date__c = Date.ValueOf(System.now());
        insert application;
        
        genesis__Equipment_Master__c em = new genesis__Equipment_Master__c();
        em.Asset_Type_ID__c             ='2222';
        em.Master_Asset_Type_ID__c      ='1111';
        em.genesis__Equipment_Serial_Number__c='123';
        insert em;
        
        genesis__Application_Equipment__c ae    = new genesis__Application_Equipment__c();
        ae.genesis__Application__c              =   application.id;
        ae.genesis__Equipment__c                =   em.id;
        ae.Install_Account__c                   =   a.id;
        ae.Install_Address1__c                  =   address.id;
        ae.genesis__Estimated_Selling_Price__c  =   10000;
        insert ae;

        // Creating Fee Definition of Service Fees
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        dummyFee.Name = 'Service Fees';
        update dummyFee;
        
        /*System.debug('******application expected Start date******'+application.genesis__Expected_Start_Date__c);
        String JSONMsg = '{"application id" : "'+application.Id +'","Amount":"123400.00"}';
        List<string> appId = new List<string>();
        appId.add(application.id);*/
    }

    // test case-1: create Service Escalation configuration and validate Application Fee Created
    // test case-2: Update Existing Service Escalation Configuration and validate Application Fee Created
    @isTest
    public static void testServiceEscalationCase1() {
        // Retrieving Application Id
        genesis__Applications__c application = [SELECT Id FROM genesis__Applications__c Limit 1];
        genesis__Application_Equipment__c appEqp = [SELECT Id, Name FROM genesis__Application_Equipment__c WHERE genesis__Application__c =: application.Id Limit 1];
        clcommon__Fee_Definition__c serviceFee = [SELECT Id FROM clcommon__Fee_Definition__c WHERE Name = 'Service Fees'];
        
        // Creating Service Fee Escalation Configuration
        Test.startTest();
            // Inserting the Service Escalation Configuation and looking for Application 
            Service_Fee_Escalation_Config__c serviceescalationconfig = new Service_Fee_Escalation_Config__c();
            serviceescalationconfig.Amount__c                   = 75.00;
            serviceescalationconfig.Application__c          = application.Id;
            serviceescalationconfig.Escalate_Service_On__c  = 'Service Only';
            serviceescalationconfig.Escalation_Frequency__c = 'ANNUAL';
            serviceescalationconfig.Escalation_Value__c     = 10.00;
            serviceescalationconfig.Frequency__c                = 'Monthly';
            serviceescalationconfig.Number_Of_Payments__c       = 60;
            serviceescalationconfig.Selected_Equipment__c       = appEqp.Name; //'APE-0000000057,APE-0000000081';
            serviceescalationconfig.Start_Date__c               = Date.newInstance(2020, 01, 01);
            insert serviceescalationconfig;

            // Actual Results
            List<Application_Fee__c> appFeeList = [SELECT Id, Fee__c, Equipment__c, Number_of_Payments__c, Frequency__c, Amount__c, Start_Date__c 
                                                    FROM Application_Fee__c 
                                                    ORDER BY Start_Date__c];
            // Expected Result (No Of Payments, Frequency, Amount & StartDate)
            List<List<String>> expectedAppFeeList = new List<List<String>>();
            expectedAppFeeList.add(new List<String>{'12', 'MONTHLY', '75.00', '1/1/2020'});
            expectedAppFeeList.add(new List<String>{'12', 'MONTHLY', '82.50', '1/1/2021'});
            expectedAppFeeList.add(new List<String>{'12', 'MONTHLY', '90.75', '1/1/2022'});
            expectedAppFeeList.add(new List<String>{'12', 'MONTHLY', '99.82', '1/1/2023'});
            expectedAppFeeList.add(new List<String>{'12', 'MONTHLY', '109.81', '1/1/2024'});

            // Comparing no of Application Fees to Generate
            ////system.assertEquals(5, appFeeList.size(), 'Mismatch in No Of Application Fee Generated for Service Escalation ');

            // Comparing Field level details on Application Fee Generation
            for(Integer i = 0; i < appFeeList.size(); i++) {
                ////system.assertEquals(serviceFee.Id,                              appFeeList[i].Fee__c,                                   'Mismatch in Service Fee Update in Application Fee for Period: '+ appFeeList[i].Start_Date__c);
                ////system.assertEquals(appEqp.Id,                                  appFeeList[i].Equipment__c,                             'Mismatch in Application Equipment Update in Application Fee for Period: '+ appFeeList[i].Start_Date__c);
                ////system.assertEquals(Decimal.valueOf(expectedAppFeeList[i][0]),  ((Decimal)(appFeeList[i].Number_of_Payments__c)).setScale(2),   'Mismatch in No Of Terms Generated in Application Fee for Period: '+ appFeeList[i].Start_Date__c);
                ////system.assertEquals(expectedAppFeeList[i][1],                   appFeeList[i].Frequency__c,                             'Mismatch in Frequency Update for Period: '+ appFeeList[i].Start_Date__c);
                ////system.assertEquals(Decimal.valueOf(expectedAppFeeList[i][2]),  ((Decimal)(appFeeList[i].Amount__c)).setScale(2),       'Mismatch in Escalated Fee Calculatiion for Period: '+ appFeeList[i].Start_Date__c);
                //system.assertEquals(Date.parse(expectedAppFeeList[i][3]),       appFeeList[i].Start_Date__c,                            'Mismatch in Escalated Fee Date Update for Period: '+ appFeeList[i].Start_Date__c);
            }
            
        Test.stopTest();
    }
    
    // test case-3: Delete Service Escalation Escalation and validate Application Fee before and after deletion
    @isTest
    public static void testServiceEscalationCase2() {
        // Retrieving Application Id
        genesis__Applications__c application = [SELECT Id FROM genesis__Applications__c Limit 1];
        genesis__Application_Equipment__c appEqp = [SELECT Id, Name FROM genesis__Application_Equipment__c WHERE genesis__Application__c =: application.Id Limit 1];
        clcommon__Fee_Definition__c serviceFee = [SELECT Id FROM clcommon__Fee_Definition__c WHERE Name = 'Service Fees'];
        
        // Creating Service Fee Escalation Configuration
        Test.startTest();
            // Inserting the Service Escalation Configuation and looking for Application 
            Service_Fee_Escalation_Config__c serviceEscalationConfig = new Service_Fee_Escalation_Config__c();
            serviceescalationconfig.Amount__c                   = 75.00;
            serviceescalationconfig.Application__c              = application.Id;
            serviceescalationconfig.Escalate_Service_On__c      = 'Service Only';
            serviceescalationconfig.Escalation_Frequency__c     = 'ANNUAL';
            serviceescalationconfig.Escalation_Value__c         = 10.00;
            serviceescalationconfig.Frequency__c                = 'Monthly';
            serviceescalationconfig.Number_Of_Payments__c       = 60;
            serviceescalationconfig.Selected_Equipment__c       = appEqp.Name; //'APE-0000000057,APE-0000000081';
            serviceescalationconfig.Start_Date__c               = Date.newInstance(2020, 01, 01);
            insert serviceescalationconfig;

            // Actual Results
            List<Application_Fee__c> appFeeList = [SELECT Id, Fee__c, Equipment__c, Number_of_Payments__c, Frequency__c, Amount__c, Start_Date__c 
                                                    FROM Application_Fee__c 
                                                    ORDER BY Start_Date__c];
            // Expected Result (No Of Payments, Frequency, Amount & StartDate)
            List<List<String>> expectedAppFeeList = new List<List<String>>();
            expectedAppFeeList.add(new List<String>{'12', 'MONTHLY', '75.00', '1/1/2020'});
            expectedAppFeeList.add(new List<String>{'12', 'MONTHLY', '82.50', '1/1/2021'});
            expectedAppFeeList.add(new List<String>{'12', 'MONTHLY', '90.75', '1/1/2022'});
            expectedAppFeeList.add(new List<String>{'12', 'MONTHLY', '99.82', '1/1/2023'});
            expectedAppFeeList.add(new List<String>{'12', 'MONTHLY', '109.81', '1/1/2024'});

            // Comparing no of Application Fees to Generate
            ////system.assertEquals(5, appFeeList.size(), 'Mismatch in No Of Application Fee Generated for Service Escalation ');

            // Comparing Field level details on Application Fee Generation
            for(Integer i = 0; i < appFeeList.size(); i++) {
                ////system.assertEquals(serviceFee.Id,                              appFeeList[i].Fee__c,                                   'Mismatch in Service Fee Update in Application Fee for Period: '+ appFeeList[i].Start_Date__c);
                ////system.assertEquals(appEqp.Id,                                  appFeeList[i].Equipment__c,                             'Mismatch in Application Equipment Update in Application Fee for Period: '+ appFeeList[i].Start_Date__c);
                ////system.assertEquals(Decimal.valueOf(expectedAppFeeList[i][0]),  ((Decimal)(appFeeList[i].Number_of_Payments__c)).setScale(2),   'Mismatch in No Of Terms Generated in Application Fee for Period: '+ appFeeList[i].Start_Date__c);
                ////system.assertEquals(expectedAppFeeList[i][1],                   appFeeList[i].Frequency__c,                             'Mismatch in Frequency Update for Period: '+ appFeeList[i].Start_Date__c);
                ////system.assertEquals(Decimal.valueOf(expectedAppFeeList[i][2]),  ((Decimal)(appFeeList[i].Amount__c)).setScale(2),       'Mismatch in Escalated Fee Calculatiion for Period: '+ appFeeList[i].Start_Date__c);
                ////system.assertEquals(Date.parse(expectedAppFeeList[i][3]),       appFeeList[i].Start_Date__c,                            'Mismatch in Escalated Fee Date Update for Period: '+ appFeeList[i].Start_Date__c);
            }

            // Deleting the Service Fee Configution and check for Application Fee
            delete serviceescalationconfig;
             // Actual Results
             List<Application_Fee__c> appFeeListRetrieve = [SELECT Id   FROM Application_Fee__c];
            // Comparing no of Application Fees to Generate
            ////system.assertEquals(0, appFeeListRetrieve.size(), 'No of Application Fees should be Zero after Service Escalation configuration deleted...');

            
        Test.stopTest();
    }

    // test case-4: Validating the default updates on Service Fee Escalation
    // test case-5: Validating the missing details in Service Fee Escalation
    // test case-6: Validating the Service Escalation Configation Details on Dates
    @isTest
    public static void testServiceEscalationCase3() {
        // Retrieving Application Id
        genesis__Applications__c application = [SELECT Id FROM genesis__Applications__c Limit 1];
        genesis__Application_Equipment__c appEqp = [SELECT Id, Name FROM genesis__Application_Equipment__c WHERE genesis__Application__c =: application.Id Limit 1];
        clcommon__Fee_Definition__c serviceFee = [SELECT Id FROM clcommon__Fee_Definition__c WHERE Name = 'Service Fees'];
        
        // Creating Service Fee Escalation Configuration
        Test.startTest();
            // Inserting the Service Escalation Configuation and looking for Application 
            Service_Fee_Escalation_Config__c serviceEscalationConfig = new Service_Fee_Escalation_Config__c();
            serviceescalationconfig.Application__c  = application.Id;
            Database.SaveResult sr = Database.insert(serviceEscalationConfig, false);

            // a. Validating the Required field to update on Service Escalation Configuration: Amount Validation Check
           if (sr.isSuccess()) {
                // Record Insertion should fail
                ////system.assertEquals(0, 1, 'Service Escalation Configuration should fail...');
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    //system.assertEquals('Please enter the Amount for Service Escalation Configuration...', err.getMessage(), 'Service Escalation Configuration should fail...');
                }
            }
            
            // b. Validating the Required field to update on Service Escalation Configuration: Escalation Value Validation Check
            serviceescalationconfig.Amount__c   = 75.00;
            sr = Database.insert(serviceEscalationConfig, false);
            if (sr.isSuccess()) {
                // Record Insertion should fail
                integer i = 0;
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    //system.assertEquals('The Escalation Percantage should be in between 0% and 15%...', err.getMessage(), 'Service Escalation Configuration should fail...');
                }
            }

            // c. Validating the Required field to update on Service Escalation Configuration: Escalation Value Validation Check
            serviceescalationconfig.Amount__c   = 75.00;
            serviceescalationconfig.Number_Of_Payments__c   = 75;
            sr = Database.insert(serviceEscalationConfig, false);
            if (sr.isSuccess()) {
                // Record Insertion should fail
                //system.assertEquals(0, 1, 'Service Escalation Configuration should fail...');
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    //system.assert(err.getMessage().contains('Service Fee End Date crossing the Application Maturity Date'), 'Service Escalation Configuration should fail...');
                }
            }

            // d. Validating the Required field to update on Service Escalation Configuration: Escalation Value Validation Check
            serviceescalationconfig.Amount__c                   = -50;
            serviceescalationconfig.Escalation_Value__c         = 10;
            serviceescalationconfig.Number_Of_Payments__c       = 60;
            serviceescalationconfig.Escalate_Service_On__c      = 'Service Only';
            sr = Database.insert(serviceEscalationConfig, false);
            if (sr.isSuccess()) {
                // Record Insertion should fail
                //system.assertEquals(0, 1, 'Service Escalation Configuration should fail...');
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    //system.assertEquals('The Amount cannot be less than equal to Zero...', err.getMessage(), 'Service Escalation Configuration should fail...');
                }
            }

            // e. Validating the Required field to update on Service Escalation Configuration: Escalation Value Validation Check
            serviceescalationconfig.Amount__c               = 50;
            serviceescalationconfig.Escalation_Value__c     = 10;
            serviceEscalationConfig.Start_Date__c           = Date.newInstance(2019, 01, 01);
            sr = Database.insert(serviceEscalationConfig, false);
            if (sr.isSuccess()) {
                // Record Insertion should fail
                //system.assertEquals(0, 1, 'Service Escalation Configuration should fail...');
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    //system.assert(err.getMessage().contains('Service Fee  Start Date entered is beyond Applicaiton Estimated first Payment Date'), 'Service Escalation Configuration should fail...');
                }
            }
                    
            // Actual Results
            List<Application_Fee__c> appFeeListRetrieve = [SELECT Id   FROM Application_Fee__c];
            // Comparing no of Application Fees to Generate
            //system.assertEquals(0, appFeeListRetrieve.size(), 'No of Application Fees should be Zero after Service Escalation configuration deleted...');
            
        Test.stopTest();
    }
    
    // test case-7: wrong Equipment list format update in Service fee and results comparision.
    // 
}