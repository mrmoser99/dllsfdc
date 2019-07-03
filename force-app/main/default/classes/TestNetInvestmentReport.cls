@isTest
public with sharing class TestNetInvestmentReport {
	public static testMethod void testNetInvestmentReport1() {

        // Note: Need residual amount to contract for Net Investment Report,
        // So creating contract directly in test class without TestHelper
		// A. Creating Contract Using TestHelper
        cllease.TestHelper.createSeedDataForTesting();
        // Setting Current System Date in Test Context
        Date currentSystemDate = Date.newInstance(2018, 03, 31);
        // 1. Pre-Setup
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet       = cllease.Testhelper.createLeaseFeeSet();
        insert new clcommon__Fee_Junction__c( clcommon__Fee__c = dummyFee.ID, 
                                              clcommon__Fee_Set__c  = dummyFeeSet.ID);

        cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office', true);
        dummyOffice.cllease__Current_System_Date__c = currentSystemDate;
        dummyOffice.Dll_Seg1_Company__c         = '00101';
        dummyOffice.Dll_Seg2_Business_Unit__c   = '02';
        dummyOffice.Dll_Seg3_Department__c      = '3030';
        dummyOffice.Dll_Seg6__c                 = '00000';
        dummyOffice.Dll_Seg7__c                 = '0000';
        update dummyOffice;

        TestData.createPeriodsFor2018(dummyOffice.cllease__Calendar__c);

        Account dummyAccount = new Account(Name = 'Sample Account');
        insert dummyAccount;

        // 2. Creating Sample Product with rental and Dep Streams enabled
        cllease__Lease_Product__c dummyLP    = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        dummyLP.cllease__Use_Open_Acct_Period__c = true;
        update dummyLP;

        clcommon__Agreement__c dealerProgram =new clcommon__Agreement__c(Name='NewCo');
        insert dealerProgram;

        // 3.Creating Contract
        Date currentDate = Date.newInstance(2018, 01, 01);
        cllease__Lease_Account__c leaseAccount      = new cllease__Lease_Account__c();
        leaseaccount.cllease__Account__c            = dummyAccount.ID;
        leaseAccount.cllease__Lease_Product_Name__c = dummyLP.ID;
        leaseAccount.cllease__Contract_Date__c      = currentDate;
        leaseaccount.cllease__Financed_Amount__c    = 10000;
        leaseaccount.cllease__Residual_Amount__c    = 1000;
        leaseAccount.cllease__Term__c               = 12;
        leaseaccount.Dealer_Program__c              = dealerProgram.Id;

        // 3.a Adding Equipments to Contract
        List<cllease__Contract_Equipment__c> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c = 10000, cllease__Residual_Amount__c = 1000));
      
        // 3.b Adding Payment Schedules to Contract
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 1, cllease__Number_Of_Payments__c = 12,
                           cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                           cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = currentDate,
                           cllease__Total_Payment__c = 1200));

        // 4. Calling ContractBuilder for Contract Creation
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);

        cllease__Lease_Account__c contract = builder.getContract();
        // Validating Contract Activation
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // B. Adding accounting configuration to Product and Creating other setup
        cllease__Lease_Product__c product = [SELECT Id, Name From cllease__Lease_Product__c Limit 1];
        cllease__Office_Name__c company = [SELECT Id, Name From cllease__Office_Name__c Where Name = 'Test Office'];

        TestData.doPreSetup();
        TestData.createAccountingTemplateSetup(product.Id, company.Id);
        // Creating and runnning the Batch jobs for General Entries Creation.
        System.Test.startTest();
            // Creating DAG
            String dagName = 'CLLease-BatchTestDAG';
            List<String> listOfJobs = new List<String>{ 'cllease.BillGeneratorJob',  'cllease.BillDetailGeneratorJob',
                                        'GLTxnGeneratorJob', 'NetInvestmentReportGeneratorJob', 'CloseAccountingPeriodsJob'};
            TestHelper.createDAGSpecificJobs(listOfJobs, dagName);
            // Running DAG
            TestHelper.runDAG(dagName);
        System.Test.stopTest();

        List<Int_OLMN_Net_Investment__c> netInvReport = [Select Id, Name,
                                                            ACCOUNTING_YIELD__C,
                                                            BILLED_UNPAID_REC__C,
                                                            BOOKED_RESIDUAL__C ,
                                                            CAP_BROKER_FEE_AMOUNT__C,
                                                            CAP_OTHER_FEE_AMOUNT__C,
                                                            CAP_ROLLOVER_FEE_AMOUNT__c,
                                                            CONTRACT_END_DATE__C,
                                                            CONTRACT_NUMBER__C,
                                                            CONTRACT_START_DATE__C,
                                                            CONTRACT_STATUS__C,
                                                            CONTRACT_TERM__C,
                                                            EQUIPMENT_COST_CORP__C,
                                                            EQUIPMENT_COST_FED__C,
                                                            FIN_PRODUCT__C,
                                                            FROZEN_LEASE_INCOME__C,
                                                            FROZEN_RESIDUAL_INCOME__C,
                                                            GROSS_RECEIVABLES__C,
                                                            HARD_COST__C,
                                                            LEASE_TYPE__C,
                                                            LESSEE_NAME__C,
                                                            LESSEE_NUMBER__C,
                                                            MONEY_ON_ACCOUNT__C,
                                                            MTD_LEASE_INCOME__C,
                                                            MTD_RESIDUAL_INCOME__C,
                                                            PARTIAL_TERMINATION_YN__C,
                                                            PAYMENT_FREQUENCY__C,
                                                            PERIOD_DATE__C,
                                                            PRIVATE_LABEL__C, 
                                                            REBOOKED_YN__C,
                                                            REMAINING_PAYMENTS__C,
                                                            REPORTING_ENTITY__C,
                                                            SBU__C,
                                                            SOFT_COST__C,
                                                            TOT_UNEARNED_LEASE_INCOME__C,
                                                            TOT_UNEARNED_RESIDUAL_INCOME__C,
                                                            UNBILLED_RECEIVABLE__C,
                                                            UNEARNED_LEASE_INCOME__C,
                                                            UNEARNED_RESIDUAL_INCOME__C,
                                                            UPFRONT_TAX_AMOUNT__C,
                                                            VENDOR_NUMBER__C,
                                                            VENDOR_PROGRAM__C, 
                                                            YTD_LEASE_INCOME__C,
                                                            YTD_RESIDUAL_INCOME__C
                                                            From Int_OLMN_Net_Investment__c
                                                            Order by Name];

        System.debug(LoggingLevel.ERROR, ' Net investment report: '+netInvReport);
	}

	public static testMethod void testNetInvestmentReportNegative() {
		// A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // Deleting all periods to catch exception
        delete [SELECT Id, Name, cllease__Status__c FROM cllease__Period_Status__c]; 

        // Creating and runnning the Batch jobs for General Entries Creation.
        System.Test.startTest();
        	List<String> contractNames = new List<String>{contract.Name};
            NetInvestmentReportGeneratorJob job = new NetInvestmentReportGeneratorJob(contractNames, null);
			Database.executeBatch(job);
        System.Test.stopTest();

        // Following api call just to coverage code.
        CLSCustomUtil.getStringsFromList(new List<String>{contract.Name});

        cllease__Batch_Process_Log__c log = [Select Id, cllease__message__c From cllease__Batch_Process_Log__c Limit 1];
        System.debug(LoggingLevel.ERROR, ' actual error message: '+ log);
        String expectedMessage = 'Error is No Open Period available';
        System.assert(log.cllease__message__c.contains(expectedMessage), 'Mismatch in thrown Exception.');
	}
}