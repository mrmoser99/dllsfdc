@isTest
public class TestICSExternalLeExtension {
  
     static TestMethod void  test1() {
    
    	cllease__lease_account__c l = createContract();
	 	
	 	RecordType r = [SELECT ID 
	 						FROM RecordType 
	 						WHERE DeveloperName = 'Dealer'AND SobjectType = 'Account'
	 						AND IsActive = true limit 1];                                   
       
        Account a = new Account(name='Talentica');
        a.RecordTypeId=r.id;
        insert a;
        
        genesis__Quick_Quotes__c qq = new genesis__Quick_Quotes__c(
        			 Dealer__c=a.id
        			,genesis__Business_Name__c='test business name'
        			,genesis__Address_Line_1__c='85 milford road'
        			,genesis__City__c='Downingtown'
        			,genesis__State__c='PA'
        			,genesis__Postal_Code__c='19335'
        			,Estimated_Financed_Amount__c='10000'
        			,genesis__Status__c='NEW'
    				,ats_reference_number__c = 'CLNDMSG1'
               ,genesis__account__c = a.id
    				);
    	insert qq;  
    	
    	Address__c addr = new Address__c(
    						 address_line_1__c=qq.genesis__Address_Line_1__c
	  						,city__c=qq.genesis__City__c
	  						,state__c=qq.genesis__State__c
	  						,zip_code__c=qq.genesis__Postal_Code__c
	  						,account__c = a.id
	  						);
	  	insert addr;		   
    	
    	ICS_Application__c app = new ICS_Application__c(
    		quick_quote__c = qq.id
    		,message_id__c = qq.ats_reference_number__c
    	);
    	
    	insert app;
    	
    	genesis__Applications__c g = new genesis__Applications__c(
    		 genesis__quick_quote__c = qq.id
    	);
    	insert g;
    	
    	g = [select name from genesis__Applications__c where id = :g.id];
    	
    	system.debug('*****G is: ' + g);
    	l.application_number__c = g.name;
    	l.cllease__application_number__c = g.name;
    	l.cllease__account__c = a.id; 
    	update l;
    	
    	system.debug('***** L is: ' + l);
    	
    	ICS_External_Legal_Entity__c le = new ICS_External_Legal_Entity__c(
    		 ics_application_request__c = app.id
    		,agency_id__c = 'US_DNB'
    		,industry_code_value__c = '1234'
    		,industry_code_type__c = 'SIC_1234_US'
    	);
    	insert le;

       //CS_External_Legal_Entity__r.ICS_Application_Request__r.quick_quote__r.genesis__account__c
       ICS_External_LE_Fields__c lef = new ICS_External_LE_Fields__c(
    		 ICS_External_Legal_Entity__c	= le.id
    		,name__c = 'CMCL.EXTL.GENL.GlobalIndustryCode'
    		,value__c = '12345'
    	);
    	insert lef;
    	
    	system.debug(l);
    	
	 	
	 	System.Test.startTest();
        
        
       	ApexPages.StandardController controller = new ApexPages.StandardController(le);
        ICSExternalLEExtension ext = new ICSExternalLEExtension(controller);
        ext.choose();
        
        System.Test.stopTest();
      	
     }	
     
         public static cllease__Lease_Account__c createContract() {
     	
     	cllease.TestHelper.createSeedDataForTesting();
     	
        // Setting Current System Date in Test Context
        Date currentSystemDate = Date.newInstance(2018, 03, 31);
        // 1. Pre-Setup
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet       = cllease.Testhelper.createLeaseFeeSet();
        insert new clcommon__Fee_Junction__c( clcommon__Fee__c = dummyFee.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);

        clcommon__Fee_Definition__c  dummyFee2   = cllease.Testhelper.createLeaseFee();
        dummyFee2.clcommon__Type__c              = 'NSF Fees';
        dummyFee2.clcommon__Amount__c            = 25;
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
        //leaseaccount.cllease__Residual_Amount__c    = 1000;
        leaseAccount.cllease__Term__c               = 12;
        leaseaccount.Dealer_Program__c              = dealerProgram.Id;
 
        // 3.a Adding Equipments to Contract
        List<cllease__Contract_Equipment__c> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c = 10000,
                                        Evergreen_Depreciable_Cost__c = 950,
                                        Remaining_Evergreen_Depreciable_Cost__c = 950,
                                        Salvage_Value__c = 50,
                                        cllease__life_in_months__c = 14,
                                        cllease__Status__c = 'LEASED'));
      
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
        System.debug(LoggingLevel.ERROR, ' Response from Contract Creation: '+response);
        // Validating Contract Activation
        System.assert(response.containsIgnoreCase('Contract Creation Successful'));
        return builder.getContract();
     	
     }	
    
}