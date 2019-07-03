@isTest
public with sharing class TestAPIntegration {
	public static testMethod void testAPOutbound() {
		// A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // B. Adding accounting configuration to Product and Creating other setup
        cllease__Lease_Product__c product = [SELECT Id, Name From cllease__Lease_Product__c Limit 1];
        cllease__Office_Name__c company = [SELECT Id, Name From cllease__Office_Name__c Where Name = 'Test Office'];

        TestData.doPreSetup();
        TestData.createAccountingTemplateSetup(product.Id, company.Id);

        Date currentSystemDate = Date.newInstance(2018, 03, 15);
        Account dealer = new Account(Name= 'dealer', Oracle_Vendor_ID__c = '1234567');
        insert dealer;

        cllease__Transaction_Sub_Type__c txnSubType = [Select Id From cllease__Transaction_Sub_Type__c 
        												Where Name = 'Service Fees - Passthrough'];
        // 1. Create Dealer Funding Transaction
        cllease__Other_Transaction__c dealerFundtxn = new cllease__Other_Transaction__c();
        dealerFundtxn.cllease__Lease_Account__c = contract.Id;
        dealerFundtxn.Invoice_Number__c 		= 'INV110';
        dealerFundtxn.Invoice_Date__c   		= currentSystemDate;
        dealerFundtxn.cllease__Txn_Date__c 		= currentSystemDate;
        dealerFundtxn.cllease__Txn_Amt__c  		= 1000;
        dealerFundtxn.cllease__GL_Process_Date__c 	= currentSystemDate;
        dealerFundtxn.cllease__Dealer_Name__c 		= dealer.Id;
        dealerFundtxn.cllease__Transaction_Type__c	= 'DEALER FUNDING';
        dealerFundtxn.AP_Processing_Status__c 		= 'New';
        dealerFundtxn.cllease__GL_Transaction_Flag__c 		= true;
        dealerFundtxn.cllease__Dealer_Payable_Amount__c 	= 1000;
        insert dealerFundtxn;

        // 2. Create Disbursement Transcation
        cllease__Disbursement_Transaction__c disbTxn = new cllease__Disbursement_Transaction__c();
        disbTxn.AP_Processing_Status__c 	 = 'New';
        disbTxn.cllease__Transaction_Type__c = 'DISBURSEMENT';
        disbTxn.cllease__Transaction_Date__c = currentSystemDate;
        disbTxn.cllease__GL_Process_Date__c  = currentSystemDate;
        disbTxn.Fee_Amount_To_Dealer__c 	 = 1000;
        disbTxn.cllease__Amount__c 	 = 1000;
        disbTxn.cllease__Account__c 		 = dealer.Id;
        disbTxn.cllease__Transaction_Sub_Type__c = txnSubType.Id;
        disbTxn.cllease__Contract__c 		 = contract.Id;
        disbTxn.cllease__GL_Transaction_Flag__c 		 = true;
        insert disbTxn;
                                        
        // Creating and runnning the Batch jobs for General Entries Creation.
        System.Test.startTest();
            // Creating DAG
            String dagName = 'CLLease-BatchTestDAG';
            List<String> listOfJobs = new List<String>{ 'GLTxnGeneratorJob', 'APInterfaceRecordsGeneratorJob' };
            TestHelper.createDAGSpecificJobs(listOfJobs, dagName);
            // Running DAG
            TestHelper.runDAG(dagName);
        System.Test.stopTest();

        System.debug(LoggingLevel.ERROR, ' Dealer Funding Transactions: '+[Select Id, Name, cllease__Description__c, cllease__GL_Processing_Message__c From cllease__Other_Transaction__c]);
        System.debug(LoggingLevel.ERROR, ' Disbursement Transactions: '+[Select Id, Name, Remark__c,cllease__GL_Processing_Message__c From cllease__Disbursement_Transaction__c]);

        List<Int_OLMN_AP__c> apInterfaceRecs = [Select Vendor_Code__c    
											,Invoice_Type_Lookup_Code__c
											,Invoice_Number__c 
											,Invoice_Date__c   
											,Invoice_Amount__c 
											,Invoice_Currency_Code__c  
											,Invoice_Description__c    
											,Funding_Type__c           
											,FUNDING_SOURCE__c         
											,Term_Name__c              
											,Terms_Date__c             
											,Payment_Method__c         
											,GL_Date__c                
											,Line_Number__c            
											,Line_Type_Lookup_Code__c
											,Line_Amount__c                                 
											,Accounting_Date__c        
											,Dist_Code_Combination__c  
											,Accts_Pay_Code_Combination__c
       									From Int_OLMN_AP__c
       									Order by Funding_Type__c];
		System.debug(LoggingLevel.ERROR, '^^^^ apInterfaceRecs : ' + apInterfaceRecs);
        
       	List<List<String>> apInterfaceRecsExpected = new List<List<String>>();
		apInterfaceRecsExpected.add(new List<String>{'1234567', 'STANDARD', 'INV110', '20180315', '1000', 'USD', 'ASSET', 'NEWCO', 'Immediate', '20180315', 'EFT', '20180315', '1', 'ITEM', 'LES-0000001380', '1000.00', '20180324', '00101.02.3030.342020.00.00000.0000', '00101.02.3030.340021.00.00000.0000'});
		apInterfaceRecsExpected.add(new List<String>{'1234567', 'STANDARD', 'DSB-0000000099', '20180315', '1000', 'USD','PASSTHROUGH', 'NEWCO', 'Immediate', '20180315', 'EFT', '20180315', '1', 'ITEM', 'LES-0000001380', '1000.00', '20180324', '00101.02.3030.153020.00.00000.0000', '00101.02.3030.340025.00.00000.0000'});
        
        System.assertEquals(apInterfaceRecsExpected.size(), apInterfaceRecs.size(), 'Mismatch in No Of Generated AP Interface Records...');

        for(Integer i=0; i<apInterfaceRecs.size(); i++) {
        	System.assertEquals(apInterfaceRecsExpected[i][0], apInterfaceRecs[i].Vendor_Code__c, 'Mismatch in Vendor_Code__c at row: '+i);
        	System.assertEquals(apInterfaceRecsExpected[i][1], apInterfaceRecs[i].Invoice_Type_Lookup_Code__c, 'Mismatch in Invoice_Type_Lookup_Code__c at row: '+i);
        	//System.assertEquals(apInterfaceRecsExpected[i][2], apInterfaceRecs[i].Invoice_Number__c, 'Mismatch in Invoice_Number__c at row: '+i);
        	System.assertEquals(apInterfaceRecsExpected[i][3], apInterfaceRecs[i].Invoice_Date__c, 'Mismatch in Invoice_Date__c at row: '+i);
        	System.assertEquals(Decimal.valueOf(apInterfaceRecsExpected[i][4]), ((Decimal)apInterfaceRecs[i].Invoice_Amount__c).setScale(2), 'Mismatch in Invoice_Amount__c at row: '+i);
        	System.assertEquals(apInterfaceRecsExpected[i][5], apInterfaceRecs[i].Invoice_Currency_Code__c, 'Mismatch in Invoice_Currency_Code__c at row: '+i);
        	System.assertEquals(apInterfaceRecsExpected[i][6], apInterfaceRecs[i].Funding_Type__c, 'Mismatch in Funding_Type__c at row: '+i);
        	System.assertEquals(apInterfaceRecsExpected[i][7], apInterfaceRecs[i].FUNDING_SOURCE__c, 'Mismatch in FUNDING_SOURCE__c at row: '+i);
        	System.assertEquals(apInterfaceRecsExpected[i][8], apInterfaceRecs[i].Term_Name__c, 'Mismatch in Term_Name__c at row: '+i);
        	System.assertEquals(apInterfaceRecsExpected[i][9], apInterfaceRecs[i].Terms_Date__c, 'Mismatch in Terms_Date__c at row: '+i);
        	System.assertEquals(apInterfaceRecsExpected[i][10], apInterfaceRecs[i].Payment_Method__c, 'Mismatch in Payment_Method__c at row: '+i);
        	System.assertEquals(apInterfaceRecsExpected[i][11], apInterfaceRecs[i].GL_Date__c, 'Mismatch in GL_Date__c at row: '+i);
        	System.assertEquals(Decimal.valueOf(apInterfaceRecsExpected[i][12]), ((Decimal)apInterfaceRecs[i].Line_Number__c).setScale(2), 'Mismatch in Line_Number__c at row: '+i);
        	System.assertEquals(apInterfaceRecsExpected[i][13], apInterfaceRecs[i].Line_Type_Lookup_Code__c, 'Mismatch in Line_Type_Lookup_Code__c at row: '+i);
        	System.assertEquals(Decimal.valueOf(apInterfaceRecsExpected[i][15]), ((Decimal)apInterfaceRecs[i].Line_Amount__c).setScale(2), 'Mismatch in Line_Amount__c at row: '+i);
        	//System.assertEquals(apInterfaceRecsExpected[i][16], apInterfaceRecs[i].Accounting_Date__c, 'Mismatch in Accounting_Date__c at row: '+i);
        	System.assertEquals(apInterfaceRecsExpected[i][17], apInterfaceRecs[i].Dist_Code_Combination__c, 'Mismatch in Dist_Code_Combination__c at row: '+i);
        	System.assertEquals(apInterfaceRecsExpected[i][18], apInterfaceRecs[i].Accts_Pay_Code_Combination__c, 'Mismatch in Accts_Pay_Code_Combination__c at row: '+i);
        }
	}

	public static testMethod void testAPOutboundNegative() {
		// A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // B. Adding accounting configuration to Product and Creating other setup
        cllease__Lease_Product__c product = [SELECT Id, Name From cllease__Lease_Product__c Limit 1];
        cllease__Office_Name__c company = [SELECT Id, Name From cllease__Office_Name__c Where Name = 'Test Office'];

        TestData.doPreSetup();
        TestData.createAccountingTemplateSetup(product.Id, company.Id);

        Date currentSystemDate = Date.newInstance(2018, 03, 15);
        Account dealer = new Account(Name= 'dealer', Oracle_Vendor_ID__c = '1234567');
        insert dealer;

        cllease__Transaction_Sub_Type__c txnSubType = [Select Id From cllease__Transaction_Sub_Type__c 
        												Where Name = 'Service Fees - Passthrough'];
        // 1. Create Dealer Funding Transaction
        cllease__Other_Transaction__c dealerFundtxn = new cllease__Other_Transaction__c();
        dealerFundtxn.cllease__Lease_Account__c = contract.Id;
        dealerFundtxn.Invoice_Number__c 		= 'INV110';
        dealerFundtxn.Invoice_Date__c   		= currentSystemDate;
        dealerFundtxn.cllease__Txn_Date__c 		= currentSystemDate;
        dealerFundtxn.cllease__Txn_Amt__c  		= 1000;
        dealerFundtxn.cllease__GL_Process_Date__c 	= currentSystemDate;
        dealerFundtxn.cllease__Dealer_Name__c 		= dealer.Id;
        dealerFundtxn.cllease__Transaction_Type__c	= 'DEALER FUNDING';
        dealerFundtxn.AP_Processing_Status__c 		= 'New';
        dealerFundtxn.cllease__GL_Transaction_Flag__c 		= true;
        dealerFundtxn.cllease__Dealer_Payable_Amount__c 	= 1000;
        insert dealerFundtxn;

        // 2. Create Disbursement Transcation
        cllease__Disbursement_Transaction__c disbTxn = new cllease__Disbursement_Transaction__c();
        disbTxn.AP_Processing_Status__c 	 = 'New';
        disbTxn.cllease__Transaction_Type__c = 'DISBURSEMENT';
        disbTxn.cllease__Transaction_Date__c = currentSystemDate;
        disbTxn.cllease__GL_Process_Date__c  = currentSystemDate;
        disbTxn.Fee_Amount_To_Dealer__c 	 = 1000;
        disbTxn.cllease__Account__c 		 = dealer.Id;
        disbTxn.cllease__Transaction_Sub_Type__c = txnSubType.Id;
        disbTxn.cllease__Contract__c 		 = contract.Id;
        disbTxn.cllease__GL_Transaction_Flag__c 		 = true;
        insert disbTxn;
                                        
        // Creating and runnning the Batch jobs for General Entries Creation.
        System.Test.startTest();
            APInterfaceRecordsGeneratorJob job = new APInterfaceRecordsGeneratorJob(new List<String>{contract.Name});
			Database.executeBatch(job);
        System.Test.stopTest();
	}

	public static testMethod void testAPInbound() {
		// A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // B. Adding accounting configuration to Product and Creating other setup
        cllease__Lease_Product__c product = [SELECT Id, Name From cllease__Lease_Product__c Limit 1];
        cllease__Office_Name__c company = [SELECT Id, Name From cllease__Office_Name__c Where Name = 'Test Office'];

        TestData.doPreSetup();
        TestData.createAccountingTemplateSetup(product.Id, company.Id);

        Date currentSystemDate = Date.newInstance(2018, 03, 15);
        Account dealer = new Account(Name= 'dealer', Oracle_Vendor_ID__c = '1234567');
        insert dealer;

        cllease__Transaction_Sub_Type__c txnSubType = [Select Id From cllease__Transaction_Sub_Type__c 
        												Where Name = 'Service Fees - Passthrough'];
        // 1. Create Dealer Funding Transaction
        cllease__Other_Transaction__c dealerFundtxn = new cllease__Other_Transaction__c();
        dealerFundtxn.cllease__Lease_Account__c = contract.Id;
        dealerFundtxn.Invoice_Number__c 		= 'INV110';
        dealerFundtxn.Invoice_Date__c   		= currentSystemDate;
        dealerFundtxn.cllease__Txn_Date__c 		= currentSystemDate;
        dealerFundtxn.cllease__Txn_Amt__c  		= 1000;
        dealerFundtxn.cllease__GL_Process_Date__c 	= currentSystemDate;
        dealerFundtxn.cllease__Dealer_Name__c 		= dealer.Id;
        dealerFundtxn.cllease__Transaction_Type__c	= 'DEALER FUNDING';
        dealerFundtxn.AP_Processing_Status__c 		= 'New';
        dealerFundtxn.cllease__GL_Transaction_Flag__c 		= true;
        dealerFundtxn.cllease__Dealer_Payable_Amount__c 	= 1000;
        insert dealerFundtxn;

        // 2. Create Disbursement Transcation
        cllease__Disbursement_Transaction__c disbTxn = new cllease__Disbursement_Transaction__c();
        disbTxn.AP_Processing_Status__c 	 = 'New';
        disbTxn.cllease__Transaction_Type__c = 'DISBURSEMENT';
        disbTxn.cllease__Transaction_Date__c = currentSystemDate;
        disbTxn.cllease__GL_Process_Date__c  = currentSystemDate;
        disbTxn.Fee_Amount_To_Dealer__c 	 = 1000;
        disbTxn.cllease__Account__c 		 = dealer.Id;
        disbTxn.cllease__Transaction_Sub_Type__c = txnSubType.Id;
        disbTxn.cllease__Contract__c 		 = contract.Id;
        disbTxn.cllease__GL_Transaction_Flag__c = true;
        insert disbTxn;

        cllease__Disbursement_Transaction__c disbTxnRetrieve = [Select Id, Name From cllease__Disbursement_Transaction__c Where Id =:disbTxn.Id];

        Date paymentDate = Date.newInstance(2018, 03, 15);
        // Creating AP Confirmation Records
        List<Int_OLMN_Payment_Confirmation__c> pmtConfmRecords = new List<Int_OLMN_Payment_Confirmation__c>();
        pmtConfmRecords.add(new Int_OLMN_Payment_Confirmation__c(
        								Contract_Number__c 		= contract.Name,
        								Invoice_Number__c  		= dealerFundtxn.Invoice_Number__c,
        								Payment_Reference__c 	= '2797686',
        								Payment_Date__c			= paymentDate));
        pmtConfmRecords.add(new Int_OLMN_Payment_Confirmation__c(
        								Contract_Number__c 		= contract.Name,
        								Invoice_Number__c  		= disbTxnRetrieve.Name,
        								Payment_Reference__c 	= '2797686',
        								Payment_Date__c			= paymentDate));
        insert pmtConfmRecords;

        // Creating and runnning the Batch jobs for General Entries Creation.
        System.Test.startTest();
            // Creating DAG
            String dagName = 'CLLease-BatchTestDAG';
            List<String> listOfJobs = new List<String>{ 'ReadAPinterface' };
            TestHelper.createDAGSpecificJobs(listOfJobs, dagName);
            // Running DAG
            TestHelper.runDAG(dagName);
        System.Test.stopTest();

        // Validate Int_OLMN_Payment_Confirmation__c for commit field update
        List<Int_OLMN_Payment_Confirmation__c> pmtConfmRecordsUpdated = [Select Id, Committed__c From Int_OLMN_Payment_Confirmation__c];
        for(Int_OLMN_Payment_Confirmation__c pmtConfmRecord : pmtConfmRecordsUpdated) {
        	System.assertEquals(true, pmtConfmRecord.Committed__c, 'Mismatch in Committed__c in AP Payment Confirmation Record... ');
        }

        // validate Payment Reference and Payment Date Update in Dealer Funding and Disbursement Transactions
        List<cllease__Disbursement_Transaction__c> disbTxnsUpdated = [Select Id, Payment_Reference__c, 
        																	Payment_Date__c, AP_Processing_Status__c
        																From cllease__Disbursement_Transaction__c];
        System.assertEquals(1, disbTxnsUpdated.size(), 'Mismatch in No of Disbursement Records Generated');
        System.assertEquals('2797686', disbTxnsUpdated.get(0).Payment_Reference__c, 'Mismatch in Payment_Reference__c Updated...');
        System.assertEquals(paymentDate, disbTxnsUpdated.get(0).Payment_Date__c, 'Mismatch in No of Disbursement Records Generated');
        System.assertEquals('Funded', disbTxnsUpdated.get(0).AP_Processing_Status__c, 'Mismatch in No of Disbursement Records Generated');

       	List<cllease__Other_Transaction__c> dealerFundTxnUpdated = [Select Id, Payment_Reference__c, Payment_Date__c, AP_Processing_Status__c
       																	From cllease__Other_Transaction__c
       																	Where cllease__Transaction_Type__c	= 'DEALER FUNDING'];
       	System.assertEquals(1, dealerFundTxnUpdated.size(), 'Mismatch in No of Disbursement Records Generated');
        System.assertEquals('2797686', dealerFundTxnUpdated.get(0).Payment_Reference__c, 'Mismatch in Payment_Reference__c Updated...');
        System.assertEquals(paymentDate, dealerFundTxnUpdated.get(0).Payment_Date__c, 'Mismatch in No of Disbursement Records Generated');
        System.assertEquals('Funded', dealerFundTxnUpdated.get(0).AP_Processing_Status__c, 'Mismatch in No of Disbursement Records Generated');
	}

	public static testMethod void testAPInboundNegative() {
		// A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // B. Adding accounting configuration to Product and Creating other setup
        cllease__Lease_Product__c product = [SELECT Id, Name From cllease__Lease_Product__c Limit 1];
        cllease__Office_Name__c company = [SELECT Id, Name From cllease__Office_Name__c Where Name = 'Test Office'];

        TestData.doPreSetup();
        TestData.createAccountingTemplateSetup(product.Id, company.Id);

        Date currentSystemDate = Date.newInstance(2018, 03, 15);
        Account dealer = new Account(Name= 'dealer', Oracle_Vendor_ID__c = '1234567');
        insert dealer;

        cllease__Transaction_Sub_Type__c txnSubType = [Select Id From cllease__Transaction_Sub_Type__c 
        												Where Name = 'Service Fees - Passthrough'];
        // 1. Create Dealer Funding Transaction
        cllease__Other_Transaction__c dealerFundtxn = new cllease__Other_Transaction__c();
        dealerFundtxn.cllease__Lease_Account__c = contract.Id;
        dealerFundtxn.Invoice_Number__c 		= 'INV110';
        dealerFundtxn.Invoice_Date__c   		= currentSystemDate;
        dealerFundtxn.cllease__Txn_Date__c 		= currentSystemDate;
        dealerFundtxn.cllease__Txn_Amt__c  		= 1000;
        dealerFundtxn.cllease__GL_Process_Date__c 	= currentSystemDate;
        dealerFundtxn.cllease__Dealer_Name__c 		= dealer.Id;
        dealerFundtxn.cllease__Transaction_Type__c	= 'DEALER FUNDING';
        dealerFundtxn.AP_Processing_Status__c 		= 'New';
        dealerFundtxn.cllease__GL_Transaction_Flag__c 		= true;
        dealerFundtxn.cllease__Dealer_Payable_Amount__c 	= 1000;
        insert dealerFundtxn;

        // 2. Create Disbursement Transcation
        cllease__Disbursement_Transaction__c disbTxn = new cllease__Disbursement_Transaction__c();
        disbTxn.AP_Processing_Status__c 	 = 'New';
        disbTxn.cllease__Transaction_Type__c = 'DISBURSEMENT';
        disbTxn.cllease__Transaction_Date__c = currentSystemDate;
        disbTxn.cllease__GL_Process_Date__c  = currentSystemDate;
        disbTxn.Fee_Amount_To_Dealer__c 	 = 1000;
        disbTxn.cllease__Account__c 		 = dealer.Id;
        disbTxn.cllease__Transaction_Sub_Type__c = txnSubType.Id;
        disbTxn.cllease__Contract__c 		 = contract.Id;
        disbTxn.cllease__GL_Transaction_Flag__c = true;
        insert disbTxn;

        cllease__Disbursement_Transaction__c disbTxnRetrieve = [Select Id, Name From cllease__Disbursement_Transaction__c Where Id =:disbTxn.Id];

        Date paymentDate = Date.newInstance(2018, 03, 15);
        // Creating AP Confirmation Records
        List<Int_OLMN_Payment_Confirmation__c> pmtConfmRecords = new List<Int_OLMN_Payment_Confirmation__c>();
        pmtConfmRecords.add(new Int_OLMN_Payment_Confirmation__c(
        								Contract_Number__c 		= contract.Name,
        								Payment_Reference__c 	= '2797686',
        								Payment_Date__c			= paymentDate));
        pmtConfmRecords.add(new Int_OLMN_Payment_Confirmation__c(
        								Contract_Number__c 		= contract.Name,
        								Payment_Reference__c 	= '2797686',
        								Payment_Date__c			= paymentDate));
        insert pmtConfmRecords;

        // Creating and runnning the Batch jobs for General Entries Creation.
        System.Test.startTest();
            List<Int_OLMN_Payment_Confirmation__c> apPmtRecords = [Select Id, Name From Int_OLMN_Payment_Confirmation__c];
            ReadAPInterface job = new ReadAPInterface(new List<String> {apPmtRecords.get(0).Name});
            Database.executeBatch(job);
        System.Test.stopTest();
	}

    public static testMethod void testInvokeAPConfirm() {
        try {
            insert new Int_Batch_Status__c(Name = 'AP Confirm', Status__c = 'Ready', Completed__c = false);
        } catch(Exception e) {}
        
    }
    
}