@isTest
public class CLLeaseTerminationQuoteServicesTest {
    @isTest  
    static void CreateTerminationQuote() {
                //Create Contract data
                cllease__Lease_Account__c leaseAccount=CLLeaseTerminationQuoteServicesTest.createContract();            
                
                List<cllease__Lease_Account__c> LeaseList=[select id,name,cllease__Lease_Product_Name__c,Unbilled_Receivable__c,Bill_Residual_Amount__c,Bill_Not_Paid_Service_Pass_Through__c,Quote_Discount__c,
                                                                Zero_Value__c,Unbilled_Estimated_Property_Tax__c,cllease__Security_Deposit_Amount__c,Bill_Not_Paid_Late_Fees__c,Bill_Not_Paid_Estimated_Property_Tax__c,
                                                                Bill_Not_Paid_Rent__c,Bill_Not_Paid_Insurance_Fees__c,Bill_not_Paid_Finance_Fees__c,Bill_Not_Paid_Origination_Fees__c,
                                                                Net_Trade_Up_Amount__c from cllease__Lease_Account__c];
                 System.AssertEquals(LeaseList.Size(), 1, 'Verify that 1 Lease Accounts created');
        
                //Select contract Equipment data
                List<cllease__Contract_Equipment__c> equipmentList=[select id,name,cllease__Equipment_Serial_Number__c,cllease__Make__c,cllease__Model__c,Install_Date__c,Install_Address__r.name,
                                                                    Install_Address__r.Address_Line_1__c, Install_Address__r.City__c,Install_Address__r.State__c,Install_Address__r.Zip_Code__c
                                                                    from cllease__Contract_Equipment__c];
                System.AssertEquals(equipmentList.Size(), 1, 'Verify that 1 Lease Contract Equipment created');
                System.debug('equipmentList='+equipmentList);
               
       
                // Create Termination Configuration
                List<cllease__Termination_Config__c> configList = new List<cllease__Termination_Config__c>();
                cllease__Termination_Config__c config = new cllease__Termination_Config__c();
                config.cllease__Lease_Product__c    = LeaseList[0].cllease__Lease_Product_Name__c;
                config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
                config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
                config.cllease__Enable__c           = true;
                configList.add(config);
                
                cllease__Termination_Config__c config1 = new cllease__Termination_Config__c();
                config1.cllease__Lease_Product__c    = LeaseList[0].cllease__Lease_Product_Name__c;
                config1.cllease__Quote_Reason__c     = 'ROLL-OVER';  
                config1.cllease__Quote_Type__c       = 'TERMINATION WITHOUT PURCHASE';
                config1.cllease__Enable__c           = true;
                configList.add(config1);               
                insert configList;
                
                //Create lease termination config line
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
                
                //Create lease termination quote header
                List<cllease__Termination_Quote_Header__c> quoteHeaderList = new List<cllease__Termination_Quote_Header__c>();
                cllease__Termination_Quote_Header__c quoteHeader = new cllease__Termination_Quote_Header__c();
                quoteHeader.cllease__Quote_Reason__c                = 'ROLL-OVER';
                quoteHeader.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
                quoteHeader.cllease__Is_Equipment_Termination__c    = true;
                quoteHeader.cllease__Status__c                      = 'ACCEPTED';
                quoteHeader.cllease__Contract__c                    = LeaseList[0].Id;
                quoteHeader.cllease__Requested_Termination_Date__c  = System.today();
                quoteHeader.cllease__Termination_Date__c            = System.today();
                quoteHeader.cllease__Effective_From__c              = System.today();
                quoteHeader.cllease__Effective_To__c                = System.today().addDays(30);
                quoteHeaderList.add(quoteHeader);
                
                cllease__Termination_Quote_Header__c quoteHeader1 = new cllease__Termination_Quote_Header__c();
                quoteHeader1.cllease__Quote_Reason__c                = 'ROLL-OVER';
                quoteHeader1.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
                quoteHeader1.cllease__Is_Equipment_Termination__c    = true;
                quoteHeader1.cllease__Status__c                      = 'ACCEPTED';
                quoteHeader1.cllease__Contract__c                    = LeaseList[0].Id;  
                quoteHeader1.cllease__Requested_Termination_Date__c  = System.today();
                quoteHeader1.cllease__Termination_Date__c            = System.today();
                quoteHeader1.cllease__Effective_From__c              = System.today();
                quoteHeader1.cllease__Effective_To__c                = System.today().addDays(30);
                quoteHeaderList.add(quoteHeader1);               
                insert quoteHeaderList; 
                 
                //Create lease termination quote equipment
                List<cllease__Termination_Quote_Equipment__c> trimiQutequipList=new List<cllease__Termination_Quote_Equipment__c>();
                for(cllease__Contract_Equipment__c equip:equipmentList){
                    trimiQutequipList.add(new cllease__Termination_Quote_Equipment__c(cllease__Contract_Equipment__c=equip.id,cllease__Termination_Quote_Header__c=quoteHeaderList[0].id));
                }
               insert trimiQutequipList; 
               
               Test.startTest();
               CLLeaseTerminationQuoteServices.CreateTerminationQuotes(LeaseList[0].id);
               Test.stopTest();
                
               
    }
    @isTest  
    static void CreateTerminationQuoteCatchPart() {
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
                
                //Create office
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
         
                //Create account data
                Account dummyAccount = new Account(Name = 'Sample Account', clcommon__Generate_Invoice_Letter__c = true);
                insert dummyAccount;
                
            
                // 2. Creating Sample Product with rental and Dep Streams enabled
                cllease__Lease_Product__c dummyLP    = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
                dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
                dummyLP.cllease__Use_Open_Acct_Period__c = true;
                update dummyLP;
       
                //Create address data
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
        
                // Creating Contract
                Date currentDate = currentSystemDate;
                cllease__Lease_Account__c leaseAccount      = new cllease__Lease_Account__c();
                leaseaccount.cllease__Account__c            = dummyAccount.Id;
                leaseAccount.cllease__Lease_Product_Name__c = dummyLP.Id;
                leaseAccount.cllease__Contract_Date__c      = currentDate;
                leaseaccount.cllease__Financed_Amount__c    = 10000;
                leaseAccount.cllease__Term__c               = 12;
                
                // Adding Equipments to Contract
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
                                                                            cllease__Model__c='WC8473'));
              
                //Adding Payment Schedules to Contract
                List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
                paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 1, cllease__Number_Of_Payments__c = 12,
                                   cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                   cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = currentDate,
                                   cllease__Total_Payment__c = 1200));
        
                
                system.debug('******************** leaseAccount: ' + leaseAccount) ;
                //Calling ContractBuilder for Contract Creation
                cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
                builder.addChildObjects(contractEquipments);
                system.debug('equipment: ' + contractEquipments);
                builder.addChildObjects(paymentDetails);
                system.debug('payment:' + paymentDetails);
                
                String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
                System.debug(LoggingLevel.ERROR, ' Response from Contract Creation: '+response);
                // Validating Contract Activation
                System.assert(response.containsIgnoreCase('Contract Creation Successful'));         
                
                List<cllease__Lease_Account__c> LeaseList=[select id,name,cllease__Lease_Product_Name__c,Unbilled_Receivable__c,Bill_Residual_Amount__c,Bill_Not_Paid_Service_Pass_Through__c,Quote_Discount__c,
                                                                Zero_Value__c,Unbilled_Estimated_Property_Tax__c,cllease__Security_Deposit_Amount__c,Bill_Not_Paid_Late_Fees__c,Bill_Not_Paid_Estimated_Property_Tax__c,
                                                                Bill_Not_Paid_Rent__c,Bill_Not_Paid_Insurance_Fees__c,Bill_not_Paid_Finance_Fees__c,Bill_Not_Paid_Origination_Fees__c,
                                                                Net_Trade_Up_Amount__c from cllease__Lease_Account__c];
                System.AssertEquals(LeaseList.Size(), 1, 'Verify that 1 Lease Accounts created');
        
                List<cllease__Contract_Equipment__c> equipmentList=[select id,name,cllease__Equipment_Serial_Number__c,cllease__Make__c,cllease__Model__c,Install_Address__r.name,
                                                                    Install_Address__r.Address_Line_1__c, Install_Address__r.City__c,Install_Address__r.State__c,Install_Address__r.Zip_Code__c
                                                                    from cllease__Contract_Equipment__c];
                System.AssertEquals(equipmentList.Size(), 1, 'Verify that 1 Lease Contract Equipment created');
                System.debug('equipmentList='+equipmentList);
               
                     
                Test.startTest();
                CLLeaseTerminationQuoteServices.CreateTerminationQuotes(LeaseList[0].id);
                Test.stopTest();
                
               
    }
    
    @isTest
    Static void UpdateTerminationQuoteTest(){
                //Create contract data
                cllease__Lease_Account__c leaseAccount=CLLeaseTerminationQuoteServicesTest.createContract();   
        
                List<cllease__Lease_Account__c> LeaseList=[select id,name,cllease__Lease_Product_Name__c,Unbilled_Receivable__c,Bill_Residual_Amount__c,Bill_Not_Paid_Service_Pass_Through__c,Quote_Discount__c,
                                                                Zero_Value__c,Unbilled_Estimated_Property_Tax__c,cllease__Security_Deposit_Amount__c,Bill_Not_Paid_Late_Fees__c,Bill_Not_Paid_Estimated_Property_Tax__c,
                                                                Bill_Not_Paid_Rent__c,Bill_Not_Paid_Insurance_Fees__c,Bill_not_Paid_Finance_Fees__c,Bill_Not_Paid_Origination_Fees__c,
                                                                Net_Trade_Up_Amount__c from cllease__Lease_Account__c];
                System.AssertEquals(LeaseList.Size(), 1, 'Verify that 1 Lease Accounts created');
        
                //Select lease contract equipment
                List<cllease__Contract_Equipment__c> equipmentList=[select id,name,cllease__Equipment_Serial_Number__c,cllease__Make__c,cllease__Model__c,Install_Date__c,Install_Address__r.name,
                                                                    Install_Address__r.Address_Line_1__c, Install_Address__r.City__c,Install_Address__r.State__c,Install_Address__r.Zip_Code__c
                                                                    from cllease__Contract_Equipment__c];
                System.AssertEquals(equipmentList.Size(), 1, 'Verify that 1 Lease Contract Equipment created');
                System.debug('equipmentList='+equipmentList);
               
       
                // Create Termination Configuration
                List<cllease__Termination_Config__c> configList = new List<cllease__Termination_Config__c>();
                cllease__Termination_Config__c config = new cllease__Termination_Config__c();
                config.cllease__Lease_Product__c    = LeaseList[0].cllease__Lease_Product_Name__c;
                config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
                config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
                config.cllease__Enable__c           = true;
                configList.add(config);
                
                cllease__Termination_Config__c config1 = new cllease__Termination_Config__c();
                config1.cllease__Lease_Product__c    = LeaseList[0].cllease__Lease_Product_Name__c;
                config1.cllease__Quote_Reason__c     = 'ROLL-OVER';  
                config1.cllease__Quote_Type__c       = 'TERMINATION WITHOUT PURCHASE';
                config1.cllease__Enable__c           = true;
                configList.add(config1);               
                insert configList;
                
                //Create termination config line
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
                
                //Create termination quote header
                List<cllease__Termination_Quote_Header__c> quoteHeaderList = new List<cllease__Termination_Quote_Header__c>();
                cllease__Termination_Quote_Header__c quoteHeader = new cllease__Termination_Quote_Header__c();
                quoteHeader.cllease__Quote_Reason__c                = 'ROLL-OVER';
                quoteHeader.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
                quoteHeader.cllease__Is_Equipment_Termination__c    = true;
                quoteHeader.cllease__Status__c                      = 'GENERATED';
                quoteHeader.cllease__Contract__c                    = LeaseList[0].Id;
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
                quoteHeader1.cllease__Contract__c                    = LeaseList[0].Id;  
                quoteHeader1.cllease__Requested_Termination_Date__c  = System.today();
                quoteHeader1.cllease__Termination_Date__c            = System.today();
                quoteHeader1.cllease__Effective_From__c              = System.today();
                quoteHeader1.cllease__Effective_To__c                = System.today().addDays(30); 
                quoteHeaderList.add(quoteHeader1);               
                insert quoteHeaderList; 
                 
                //Create lease termination quote equipment
                List<cllease__Termination_Quote_Equipment__c> trimiQutequipList=new List<cllease__Termination_Quote_Equipment__c>();
                for(cllease__Contract_Equipment__c equip:equipmentList){
                    trimiQutequipList.add(new cllease__Termination_Quote_Equipment__c(cllease__Contract_Equipment__c=equip.id,cllease__Termination_Quote_Header__c=quoteHeaderList[0].id));
                }
               insert trimiQutequipList; 
               
               //Create lease termination quote line
               cllease__Termination_Quote_Line__c termiQuoteLine=new cllease__Termination_Quote_Line__c();
               termiQuoteLine.cllease__Amount__c=1200;
               termiQuoteLine.cllease__Line_Type__c='QUOTE PURCHASE AMOUNT';
               termiQuoteLine.cllease__Quote_Header__c=quoteHeaderList[0].id;
               insert termiQuoteLine;
        
               List<cllease__Termination_Quote_Line__c> termiQuotLineList=[Select id,name,cllease__Line_Type__c,cllease__Quote_Header__c,cllease__Amount__c from cllease__Termination_Quote_Line__c
                                                                          where id=:termiQuoteLine.id];
               Map<String,Decimal> quoteLineMap=new Map<String,Decimal>();
               for(cllease__Termination_Quote_Line__c quoteLine:termiQuotLineList){
                   quoteLineMap.put(quoteLine.cllease__Line_Type__c,quoteLine.cllease__Amount__c);
                }
               
               // Select lease termination quote header
               List<cllease__Termination_Quote_Header__c> quoteHeaderList1=[select id,name,cllease__Contract__r.Name,Equipment_Price__c,cllease__Quote_Reason__c,cllease__Quote_Type__c,cllease__Termination_Date__c,
                                                                   cllease__Status__c,cllease__Effective_From__c,cllease__Quote_Amount__c from cllease__Termination_Quote_Header__c
                                                                   where id=:quoteHeader.id];
               
               Test.startTest();
               CLLeaseTerminationQuoteServices.updateTerminationQuote(quoteHeaderList[0].id,quoteLineMap);
               Test.stopTest();
    }
    
    @isTest
    Static void UpdateTerminationQuoteCatchPart(){
                // Create contract data
                cllease__Lease_Account__c leaseAccount=CLLeaseTerminationQuoteServicesTest.createContract();   
        
                List<cllease__Lease_Account__c> LeaseList=[select id,name,cllease__Lease_Product_Name__c,Unbilled_Receivable__c,Bill_Residual_Amount__c,Bill_Not_Paid_Service_Pass_Through__c,Quote_Discount__c,
                                                                Zero_Value__c,Unbilled_Estimated_Property_Tax__c,cllease__Security_Deposit_Amount__c,Bill_Not_Paid_Late_Fees__c,Bill_Not_Paid_Estimated_Property_Tax__c,
                                                                Bill_Not_Paid_Rent__c,Bill_Not_Paid_Insurance_Fees__c,Bill_not_Paid_Finance_Fees__c,Bill_Not_Paid_Origination_Fees__c,
                                                                Net_Trade_Up_Amount__c from cllease__Lease_Account__c];
                System.AssertEquals(LeaseList.Size(), 1, 'Verify that 1 Lease Accounts created');
        
                // Create contarct equipment 
                List<cllease__Contract_Equipment__c> equipmentList=[select id,name,cllease__Equipment_Serial_Number__c,cllease__Make__c,cllease__Model__c,Install_Date__c,Install_Address__r.name,
                                                                    Install_Address__r.Address_Line_1__c, Install_Address__r.City__c,Install_Address__r.State__c,Install_Address__r.Zip_Code__c
                                                                    from cllease__Contract_Equipment__c];
                System.AssertEquals(equipmentList.Size(), 1, 'Verify that 1 Lease Contract Equipment created');      
                System.debug('equipmentList='+equipmentList);               
       
                // Create Termination Configuration
                List<cllease__Termination_Config__c> configList = new List<cllease__Termination_Config__c>();
                cllease__Termination_Config__c config = new cllease__Termination_Config__c();
                config.cllease__Lease_Product__c    = LeaseList[0].cllease__Lease_Product_Name__c;
                config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
                config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
                config.cllease__Enable__c           = true;
                configList.add(config);
                
                cllease__Termination_Config__c config1 = new cllease__Termination_Config__c();
                config1.cllease__Lease_Product__c    = LeaseList[0].cllease__Lease_Product_Name__c;
                config1.cllease__Quote_Reason__c     = 'ROLL-OVER';  
                config1.cllease__Quote_Type__c       = 'TERMINATION WITHOUT PURCHASE';
                config1.cllease__Enable__c           = true;
                configList.add(config1);               
                insert configList;
                
                // Create termination config line
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
                
                // Create lease termination quote header
                List<cllease__Termination_Quote_Header__c> quoteHeaderList = new List<cllease__Termination_Quote_Header__c>();
                cllease__Termination_Quote_Header__c quoteHeader = new cllease__Termination_Quote_Header__c();
                quoteHeader.cllease__Quote_Reason__c                = 'ROLL-OVER';
                quoteHeader.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
                quoteHeader.cllease__Is_Equipment_Termination__c    = true;
                quoteHeader.cllease__Status__c                      = 'ACCEPTED';
                quoteHeader.cllease__Contract__c                    = LeaseList[0].Id;
                quoteHeader.cllease__Requested_Termination_Date__c  = System.today();
                quoteHeader.cllease__Termination_Date__c            = System.today();
                quoteHeader.cllease__Effective_From__c              = System.today();
                quoteHeader.cllease__Effective_To__c                = System.today().addDays(30);
                quoteHeaderList.add(quoteHeader);
                
                cllease__Termination_Quote_Header__c quoteHeader1 = new cllease__Termination_Quote_Header__c();
                quoteHeader1.cllease__Quote_Reason__c                = 'ROLL-OVER';
                quoteHeader1.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
                quoteHeader1.cllease__Is_Equipment_Termination__c    = true;
                quoteHeader1.cllease__Status__c                      = 'ACCEPTED';
                quoteHeader1.cllease__Contract__c                    = LeaseList[0].Id;  
                quoteHeader1.cllease__Requested_Termination_Date__c  = System.today();
                quoteHeader1.cllease__Termination_Date__c            = System.today();
                quoteHeader1.cllease__Effective_From__c              = System.today();
                quoteHeader1.cllease__Effective_To__c                = System.today().addDays(30);
                quoteHeaderList.add(quoteHeader1);              
                insert quoteHeaderList; 
        
                // Create termination quote equipment
                List<cllease__Termination_Quote_Equipment__c> trimiQutequipList=new List<cllease__Termination_Quote_Equipment__c>();
                for(cllease__Contract_Equipment__c equip:equipmentList){
                    trimiQutequipList.add(new cllease__Termination_Quote_Equipment__c(cllease__Contract_Equipment__c=equip.id,cllease__Termination_Quote_Header__c=quoteHeaderList[0].id));
                }
                
               insert trimiQutequipList; 
               
               // Create termination quote line
               cllease__Termination_Quote_Line__c termiQuoteLine=new cllease__Termination_Quote_Line__c();
               termiQuoteLine.cllease__Amount__c=1200;
               termiQuoteLine.cllease__Line_Type__c='QUOTE PURCHASE AMOUNT';
               termiQuoteLine.cllease__Quote_Header__c=quoteHeaderList[0].id;
               insert termiQuoteLine;
               
               
        
               List<cllease__Termination_Quote_Line__c> termiQuotLineList=[Select id,name,cllease__Line_Type__c,cllease__Quote_Header__c,cllease__Amount__c from cllease__Termination_Quote_Line__c];
               Map<String,Decimal> quoteLineMap=new Map<String,Decimal>();
               for(cllease__Termination_Quote_Line__c quoteLine:termiQuotLineList){
                   quoteLineMap.put(quoteLine.cllease__Line_Type__c,quoteLine.cllease__Amount__c);
                }
        
               // Select lease termination quote header 
               List<cllease__Termination_Quote_Header__c> quoteHeaderList1=[select id,name,cllease__Contract__r.Name,Equipment_Price__c,cllease__Quote_Reason__c,cllease__Quote_Type__c,cllease__Termination_Date__c,
                                                                   cllease__Status__c,cllease__Effective_From__c,cllease__Quote_Amount__c from cllease__Termination_Quote_Header__c
                                                                   where id=:quoteHeader.id];
        
               Test.startTest();
               CLLeaseTerminationQuoteServices.updateTerminationQuote(quoteHeaderList[0].id,quoteLineMap);
               Test.stopTest();
    }
    
    @isTest
    Static void processTerminationQuote(){
                // Create contract data
                cllease__Lease_Account__c leaseAccount=CLLeaseTerminationQuoteServicesTest.createContract();   
                
                List<cllease__Lease_Account__c> LeaseList=[select id,name,cllease__Lease_Product_Name__c,Unbilled_Receivable__c,Bill_Residual_Amount__c,Bill_Not_Paid_Service_Pass_Through__c,Quote_Discount__c,
                                                                Zero_Value__c,Unbilled_Estimated_Property_Tax__c,cllease__Security_Deposit_Amount__c,Bill_Not_Paid_Late_Fees__c,Bill_Not_Paid_Estimated_Property_Tax__c,
                                                                Bill_Not_Paid_Rent__c,Bill_Not_Paid_Insurance_Fees__c,Bill_not_Paid_Finance_Fees__c,Bill_Not_Paid_Origination_Fees__c,
                                                                Net_Trade_Up_Amount__c from cllease__Lease_Account__c];
                System.AssertEquals(LeaseList.Size(), 1, 'Verify that 1 Lease Accounts created');

                // Create lease contract data
                List<cllease__Contract_Equipment__c> equipmentList=[select id,name,cllease__Equipment_Serial_Number__c,cllease__Make__c,cllease__Model__c,Install_Date__c,Install_Address__r.name,
                                                                    Install_Address__r.Address_Line_1__c, Install_Address__r.City__c,Install_Address__r.State__c,Install_Address__r.Zip_Code__c
                                                                    from cllease__Contract_Equipment__c];
                System.AssertEquals(equipmentList.Size(), 1, 'Verify that 1 Lease Contract Equipment created');
                System.debug('equipmentList='+equipmentList);
               
       
                // Create Termination Configuration
                List<cllease__Termination_Config__c> configList = new List<cllease__Termination_Config__c>();
                cllease__Termination_Config__c config = new cllease__Termination_Config__c();
                config.cllease__Lease_Product__c    = LeaseList[0].cllease__Lease_Product_Name__c;
                config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
                config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
                config.cllease__Enable__c           = true;
                configList.add(config);
                
                cllease__Termination_Config__c config1 = new cllease__Termination_Config__c();
                config1.cllease__Lease_Product__c    = LeaseList[0].cllease__Lease_Product_Name__c;
                config1.cllease__Quote_Reason__c     = 'ROLL-OVER';  
                config1.cllease__Quote_Type__c       = 'TERMINATION WITHOUT PURCHASE';
                config1.cllease__Enable__c           = true;
                configList.add(config1);              
                insert configList;
                
                //Create lease termination config line
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
                
                // Create termination quote header
                List<cllease__Termination_Quote_Header__c> quoteHeaderList = new List<cllease__Termination_Quote_Header__c>();
                cllease__Termination_Quote_Header__c quoteHeader = new cllease__Termination_Quote_Header__c();
                quoteHeader.cllease__Quote_Reason__c                = 'ROLL-OVER';
                quoteHeader.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
                quoteHeader.cllease__Is_Equipment_Termination__c    = true;
                quoteHeader.cllease__Status__c                      = 'ACCEPTED';
                quoteHeader.cllease__Contract__c                    = LeaseList[0].Id;
                quoteHeader.cllease__Requested_Termination_Date__c  = System.today();
                quoteHeader.cllease__Termination_Date__c            = System.today();
                quoteHeader.cllease__Effective_From__c              = System.today();
                quoteHeader.cllease__Effective_To__c                = System.today().addDays(30);
                quoteHeaderList.add(quoteHeader);
                
                cllease__Termination_Quote_Header__c quoteHeader1 = new cllease__Termination_Quote_Header__c();
                quoteHeader1.cllease__Quote_Reason__c                = 'ROLL-OVER';
                quoteHeader1.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
                quoteHeader1.cllease__Is_Equipment_Termination__c    = true;
                quoteHeader1.cllease__Status__c                      = 'ACCEPTED';
                quoteHeader1.cllease__Contract__c                    = LeaseList[0].Id;  
                quoteHeader1.cllease__Requested_Termination_Date__c  = System.today();
                quoteHeader1.cllease__Termination_Date__c            = System.today();
                quoteHeader1.cllease__Effective_From__c              = System.today();
                quoteHeader1.cllease__Effective_To__c                = System.today().addDays(30);
                quoteHeaderList.add(quoteHeader1);                
                insert quoteHeaderList; 
                
                cllease__Other_Transaction__c othertrax=new cllease__Other_Transaction__c();
                othertrax.Equipment_Cost_Rate__c=1;
                othertrax.cllease__Lease_Account__c=LeaseList[0].id;
                othertrax.Residual_Rate__c=1;
                othertrax.Subsidy_Rate__c=1;
                othertrax.Subvention_Rate__c =1;
                othertrax.Termination_Bill_Unpaid__c=5060;
                othertrax.Termination_Future_Rent__c=6001.25;
                othertrax.Termination_IDC_Expense__c=0;
                othertrax.Termination_Residual_Income__c=133.39;
                othertrax.Termination_Subsidy_Income__c=0;
                othertrax.Termination_Subvention_Income__c=0;
                othertrax.Termination_Unearned_Income__c=399.39;
                othertrax.cllease__Txn_Date__c=System.today();
                othertrax.Termination_Quote__c=quoteHeader.id;
                othertrax.Termination_Fee_Unpaid__c=799.71;
                insert othertrax;
                
                Termination_Detail__c termiDetail=new Termination_Detail__c();
                termiDetail.Equipment_Cost_Rate__c=1;
                termiDetail.Residual_Rate__c=1;
                termiDetail.Subsidy_Rate__c=1;
                termiDetail.Subvention_Rate__c =1;
                termiDetail.Termination_Bill_Unpaid__c=5060;
                termiDetail.Termination_Future_Rent__c=6001.25;
                termiDetail.Termination_IDC_Expense__c=0;
                termiDetail.Termination_Quote__c=quoteHeader.id;
                termiDetail.Termination_Residual_Income__c=133.39;
                termiDetail.Termination_Subsidy_Income__c=0;
                termiDetail.Termination_Subvention_Income__c=0;
                termiDetail.Termination_Unearned_Income__c=399.39;
                termiDetail.Termination_Fee_Unpaid__c=799.71;
                insert termiDetail;

        
                //Create lease termination quote equipment
                List<cllease__Termination_Quote_Equipment__c> trimiQutequipList=new List<cllease__Termination_Quote_Equipment__c>();
                for(cllease__Contract_Equipment__c equip:equipmentList){
                    trimiQutequipList.add(new cllease__Termination_Quote_Equipment__c(cllease__Contract_Equipment__c=equip.id,cllease__Termination_Quote_Header__c=quoteHeaderList[0].id));
                }
                insert trimiQutequipList; 
        
                List<cllease__Termination_Quote_Header__c> quoteHeaderList1=[select id,name,cllease__Contract__r.Name,Equipment_Price__c,cllease__Quote_Reason__c,cllease__Quote_Type__c,cllease__Termination_Date__c,
                                                                   cllease__Status__c,cllease__Effective_From__c,cllease__Quote_Amount__c from cllease__Termination_Quote_Header__c
                                                                   where id=:quoteHeader.id];
               
                Test.startTest();
                CLLeaseTerminationQuoteServices.processTerminationQuote(quoteHeaderList1[0].id);
        		
                Test.stopTest();
    }
    
    
    //Method create the Sample Data needed  for contract creation and also creates contract.        
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
                leaseAccount.cllease__Lease_Product_Name__c = dummyLP.Id;
                leaseAccount.cllease__Contract_Date__c      = currentDate;
                leaseaccount.cllease__Financed_Amount__c    = 10000;
                //leaseaccount.cllease__Residual_Amount__c    = 1000;
                leaseAccount.cllease__Term__c               = 12;
                //leaseaccount.Dealer_Program__c              = dealerProgram.Id;
        
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
                cllease__Lease_Account__c lease=[select id,name from cllease__Lease_Account__c];
                System.debug('lease name='+lease.name);
                return builder.getContract();
    }
}