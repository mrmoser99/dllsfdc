@isTest
public with sharing class TestTerminationFunctionality {
    @isTest
    public static void testTerminationCase1(){
        cllease.TestHelper.createSeedDataForTesting();
        cllease.TestHelper.systemDate = Date.newInstance(2020, 01, 01);
        Date sysDate = Date.newInstance(2020, 01, 01);
            
        cllease.TestHelper.createSeedDataForTesting();
        clcommon__Fee_Definition__c  dummyFee = new clcommon__Fee_Definition__c (Name = 'XXXFeeForTest',
                                     clcommon__Active__c = true,
                                     clcommon__Calculation_Method__c = 'FIXED',
                                     clcommon__Amount__c = 10,
                                     clcommon__Amortization_Method__c = 'STRAIGHT LINE',
                                     clcommon__Amortization_Period__c = 'CONTRACT TERM',
                                     clcommon__Type__c = 'AMORTIZED FEES',
                                     clcommon__Class__c = 'Income');
        insert dummyFee;
        clcommon__Fee_Set__c dummyFeeSet = new clcommon__Fee_Set__c(Name = 'XXXFeeSetForTest');
        insert dummyFeeSet;
        clcommon__Fee_Junction__c dummyFeeJunction = new clcommon__Fee_Junction__c(clcommon__Fee__c = dummyFee.id, clcommon__Fee_Set__c = dummyFeeSet.id);
        insert dummyFeeJunction;
            
        cllease__payment_mode__c tdsPaymentMode = new cllease__payment_mode__c(Name = 'TDS');
        insert tdsPaymentMode;

        clcommon__Legal_Entity__c legal = new clcommon__Legal_Entity__c(name='ZX');
        insert legal;
        Account lessee = new Account(name='test account');
        lessee.clcommon__Legal_Entity_Type__c = legal.id;
        insert lessee;
    
        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice('Test Office', true);
        dummyOffice.cllease__Current_System_Date__c = Date.newInstance(2018, 1, 1);
        update dummyOffice;
  
        cllease__Lease_Product__c dummyLP               = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
        dummyLp.cllease__Product_Sub_Type__c            = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        dummyLP.cllease__Streams_to_Accrue__c           = 'Fee; IDC; Income; Residual; Subsidy; Subvention;';
        dummyLP.cllease__Track_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_CASHBAL_TAX + ';' +cllease.LendingConstants.LEASE_CASHBAL_LEASE_RECEIVABLE;
        dummyLP.cllease__Track_Non_Cash_Account_Balances__c = cllease.LendingConstants.LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE;
        update dummyLP;

        // Creating Termination Quote Configuration
        cllease__Termination_Config__c terminationHeader = new cllease__Termination_Config__c(Name  = 'TermConfigDummy1', 
                                                                            cllease__Enable__c          = True,
                                                                            cllease__Lease_Product__c   = dummyLP.Id,
                                                                            cllease__Default__c         = true,
                                                                            cllease__Quote_Reason__c    = 'ROLL-OVER',
                                                                            cllease__Quote_Type__c      = 'TERMINATION WITHOUT PURCHASE');
        insert terminationHeader;

        List<cllease__Termination_Config_Line__c> terminationConfigLineList = new List<cllease__Termination_Config_Line__c>();
        terminationConfigLineList.add(new cllease__Termination_Config_Line__c(Name              = 'Unbilled Bill Rent',
                                                                cllease__Termination_Config__c     = terminationHeader.Id,
                                                                cllease__Quote_Line__c             = 'QUOTE UNBILLED RECEIVABLE',
                                                                cllease__Is_Billable__c            = True,
                                                                cllease__Bill_Field_API_Name__c    = 'Rental_Due_Amount__c',
                                                                cllease__Add_To_Quote_Amount__c    = True,
                                                                cllease__Is_Account_Balancable__c  = True));
    
        terminationConfigLineList.add(new cllease__Termination_Config_Line__c(Name              = 'Unbilled Bill Tax',
                                                                cllease__Termination_Config__c     = terminationHeader.Id,
                                                                cllease__Quote_Line__c             = 'QUOTE UNBILLED RECEIVABLE',
                                                                cllease__Is_Billable__c            = True,
                                                                cllease__Bill_Field_API_Name__c    = 'Tax_Due_Amount__c',
                                                                cllease__Add_To_Quote_Amount__c    = True,
                                                                cllease__Is_Account_Balancable__c  = True));
    
        terminationConfigLineList.add(new cllease__Termination_Config_Line__c(Name              = 'Billed Not Paid Rent',
                                                                cllease__Termination_Config__c     = terminationHeader.Id,
                                                                cllease__Quote_Line__c             = 'BILLED NOT PAID RENT',
                                                                cllease__Is_Billable__c            = False,
                                                                cllease__Add_To_Quote_Amount__c    = False,
                                                                cllease__Is_Account_Balancable__c  = False));

        Insert terminationConfigLineList;

        
        cllease__Lease_Account__c leaseAccount = new cllease__Lease_Account__c();
        leaseAccount.cllease__Account__c            = lessee.ID;
        leaseAccount.cllease__Lease_Product_Name__c = dummyLP.ID;
        leaseAccount.cllease__Contract_Date__c      = sysDate;
        leaseAccount.cllease__Term__c               = 12;
        leaseAccount.cllease__Financed_Amount__c    = 10000;
        leaseAccount.cllease__Residual_Amount__c    = 1000;
        leaseAccount.cllease__First_Payment_Date__c = sysDate;
        leaseAccount.cllease__Subsidy1__c           = 100;
        leaseAccount.cllease__Initial_Direct_Cost_Amount1__c    = 500;
        leaseAccount.cllease__Pre_Bill_Days__c                  = 7;
        leaseAccount.cllease__Income_Accrual_Frequency__c       = 'END OF MONTH';
        leaseAccount.cllease__Grace_Period_for_Repayments__c    = 1;
        leaseAccount.cllease__Fee_Set1__c           = dummyFeeSet.Id;
        
        /*            
        * Creating Contract Equipments
        */
        List < cllease__Contract_Equipment__C > contractEquipments = new List < cllease__Contract_Equipment__c > ();
        contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c = 10000,
                                                                    cllease__Residual_Amount__c = 1000,
                                                                    cllease__Life_In_Months__c = 12,
                                                                    cllease__Status__c  = 'LEASED',
                                                                    cllease__Subsidy__c = 100));
        /*contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c = 10000,
                                                                    cllease__Life_In_Months__c = 12));*/
            
        /**
        * Creating Payment Schedule
        */
        List < cllease__Payment_Schedule__c > paymentDetails = new List < cllease__Payment_Schedule__c > ();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 1, cllease__Number_Of_Payments__c = 12,
                                                            cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                            cllease__Payment_Amount__c = 1000, cllease__Total_Payment__c = 1000,
                                                            cllease__Payment_Date__c = sysDate));


        List<cllease__Contract_Fees__c> feeSchedule = new List<cllease__Contract_Fees__c>();
        feeSchedule.add(new cllease__Contract_Fees__c( cllease__VAT__c = 0.00, 
                            cllease__Total_Payment_Amount__c = 100,
                            cllease__Fee_Definition__c      = dummyFee.Id, 
                            cllease__Fee_Type__c            = 'OTHER FEES', 
                            cllease__Number_of_Periods__c   = 3, 
                            cllease__Frequency__c           = 'MONTHLY',
                            cllease__Amount__c              = 99.99, 
                            cllease__start_date__c          = leaseAccount.cllease__Contract_Date__c));
            
        /**
        * Calling ContractBuilder for Contract Creation
        */
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        builder.addChildObjects(feeSchedule);
        // Creating the contract
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        System.debug('Activate Contract Response: '+response);
        //System.assert(response.Lease_Status__c == LendingConstants.STATUS_ACTIVE_GOOD_STANDING); 
        System.assert(response.containsIgnoreCase('Contract Creation Successful'));        
   
        cllease.TestHelper.systemDate = Date.newInstance(2018, 02, 01);
        Date currentSystemDate = cllease.TestHelper.systemDate;

        // Calling Global API for partial termination
        
        cllease__Termination_Quote_Header__c quoteHeader = new cllease__Termination_Quote_Header__c();
        quoteHeader.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader.cllease__Quote_Type__c                  = 'TERMINATION WITHOUT PURCHASE';
        quoteHeader.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader.cllease__Status__c                      = 'GENERATED';
        quoteHeader.cllease__Contract__c                    = leaseAccount.Id;
        quoteHeader.cllease__Requested_Termination_Date__c  = currentSystemDate;
        quoteHeader.cllease__Termination_Date__c            = currentSystemDate;
        quoteHeader.cllease__Effective_From__c              = currentSystemDate;
        quoteHeader.cllease__Effective_To__c                = currentSystemDate.addDays(30);
        insert quoteHeader;

        // Creating Termination Quote Lines
        List<cllease__Termination_Quote_Line__c> quoteLines = new List<cllease__Termination_Quote_Line__c>();
        for(cllease__Termination_Config_Line__c configLine : terminationConfigLineList) {
            quoteLines.add(new cllease__Termination_Quote_Line__c(cllease__Amount__c                    = 100, 
                                                                     cllease__Line_Type__c               = configLine.cllease__Quote_Line__c,
                                                                     cllease__Amount_Type__c             = 'LINE',
                                                                     cllease__Billable__c                = true,
                                                                     cllease__Account_Balance_Type__c    = configLine.cllease__Account_Balance_Type__c,
                                                                     cllease__Is_Account_Balancable__c   = false,
                                                                     cllease__Add_To_Quote_Amount__c     = true,
                                                                     cllease__Bill_Field_API_Name__c     = configLine.cllease__Bill_Field_API_Name__c,
                                                                     cllease__Quote_Header__c            = quoteHeader.Id));
        }
        insert quoteLines;

        // Creatign Termination QUote Equipment
        List<cllease__Termination_Quote_Equipment__c> termQuoteEqpList = new List<cllease__Termination_Quote_Equipment__c>();
        for(cllease__Contract_Equipment__c eqp : contractEquipments) {
            termQuoteEqpList.add(new cllease__Termination_Quote_Equipment__c(cllease__Contract_Equipment__c = eqp.Id, cllease__Termination_Quote_Header__c = quoteHeader.Id));
        }
        insert termQuoteEqpList;

        // updating the contract Equipment's status to Leased for code coverage
        for(cllease__Contract_Equipment__c eqp: contractEquipments) {
            eqp.cllease__Status__c  = 'LEASED';
        }
        update contractEquipments;

        // Query back the Termination Quote and update the status as Accepted for details validation
        cllease__Termination_Quote_Header__c quoteHeader1 = [Select Id, Name, cllease__Status__c From cllease__Termination_Quote_Header__c Limit 1];
        quoteHeader1.cllease__Status__c = 'ACCEPTED';
        update quoteHeader1;

        // Query back the Termination Quote and update the status as Termination Processed for details validation
        cllease__Termination_Quote_Header__c quoteHeader2 = [Select Id, Name, cllease__Status__c From cllease__Termination_Quote_Header__c Limit 1];
        quoteHeader2.cllease__Status__c = 'TERMINATION PROCESSED';
        update quoteHeader2;
        
        leaseAccount.cllease__Lease_Status__c = 'TERMINATED';
        update leaseAccount;
    }
    
}