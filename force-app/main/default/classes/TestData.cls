/**
 * Author: Cloud Lending Solutions
 * Description: Following class helps in creating test data for testing the functionality 
 **/
public with sharing class TestData {

	/**
	 * Following method helps in creating presetup for Accounting Headers.
	 **/
	public static void doPreSetup() {
		// Creating Transaction Sub Types
		createTxnSubTypes();
		// Creating GL Accounts
		createGLAccounts();
		// Creating Movement Codes
		createMovementCodes();
		// Creating Amount objects and Amount Columns
		createAmountObjectColumnData();
	}

	/**
	 * Following method helps in creating the accounting setup which is similar to Client's usage
	 **/
	public static void createAccountingTemplateSetup(String productId, String companyId) {

		Map<AccountingTemplateHeader, List<AccountingTemplateLines>> headerLinesMap = new Map<AccountingTemplateHeader, List<AccountingTemplateLines>>();

		AccountingTemplateHeader header;
		List<AccountingTemplateLines> lines;

		header = new AccountingTemplateHeader('Accrual', 'ACCRUAL');
		lines = new List<AccountingTemplateLines>();
		lines.add(new AccountingTemplateLines('Accrual', 'Lease Income Accrual', 'Accrual Transaction', 'Accrual Amount', 'RESIDUAL INCOME ACCRUAL', 	'Amortized Residual Income - CLS', 'Unearned Residual Income - CLS'));
		lines.add(new AccountingTemplateLines('Accrual', 'Lease Income Accrual', 'Accrual Transaction', 'Accrual Amount', 'LEASE INCOME ACCRUAL', 		'Amortized Lease Income - CLS', 	'Unearned Lease Income - Finance Lease - CLS'));
		headerLinesMap.put(header, lines);

		header = new AccountingTemplateHeader('Billing - Fees', 'CHARGES');
		lines = new List<AccountingTemplateLines>();
		lines.add(new AccountingTemplateLines('Billing - Fees', 'Sales Tax on Finance Fee', 'Charge Transaction', 'Tax Due', 'Finance Fees', 'Sales Tax Payable - CLS', 'Fee Receivable Sales Tax - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Fees', 'Sales Tax on Estimated Property Tax', 'Charge Transaction', 'Tax Due', 'Estimated Property Tax', 'Sales Tax Payable - CLS', 'Fee Receivable Sales Tax - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Fees', 'Sales Tax on Documentation Fee', 'Charge Transaction', 'Tax Due', 'Origination Fees', 'Sales Tax Payable - CLS', 'Fee Receivable Sales Tax - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Fees', 'Sales Tax on Insurance', 'Charge Transaction', 'Tax Due', 'Insurance Fees', 'Sales Tax Payable - CLS', 'Fee Receivable Sales Tax - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Fees', 'Sales Tax on Late Fee', 'Charge Transaction', 'Tax Due', 'Late Fee', 'Sales Tax Payable - CLS', 'Fee Receivable Sales Tax - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Fees', 'Sales Tax on Pass Through Service', 'Charge Transaction', 'Tax Due', 'Service Fees', 'Sales Tax Payable - CLS', 'Pass Through Service Sales Tax - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Fees', 'Documentation Fee', 'Charge Transaction', 'Charge Amount', 'Origination Fees', 'Documentation Fees - CLS', 'Fee Receivable - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Fees', 'Late Fee', 'Charge Transaction', 'Charge Amount', 'Late Fee', 'Late Charge Fees - CLS', 'Fee Receivable - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Fees', 'Pass Through Service', 'Charge Transaction', 'Charge Amount', 'Service Fees', 'Pass Through Service Clearing - CLS', 'Pass Through Service Receivable - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Fees', 'Insurance', 'Charge Transaction', 'Charge Amount', 'Insurance Fees', 'Insurance Fees - CLS', 'Fee Receivable - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Fees', 'Estimated Property Tax', 'Charge Transaction', 'Charge Amount', 'Estimated Property Tax', 'Monthly Property Tax - CLS', 'Property Tax Receivable - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Fees', 'Finance Charge', 'Charge Transaction', 'Charge Amount', 'Finance Fees', 'Finance Charges - CLS', 'Fee Receivable - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Fees', 'TERMINATION QUOTE FEES', 'Charge Transaction', 'Charge Amount', 'TERMINATION QUOTE FEES', 'Fee Income', 'Fee Receivable - CLS'));
		headerLinesMap.put(header, lines);

		header = new AccountingTemplateHeader('Billing - Rent', 'BILLING');
		lines = new List<AccountingTemplateLines>();
		lines.add(new AccountingTemplateLines('Billing - Rent', 'Sales Invoice', 'Billing Transaction', 'Periodic Rent Due', 'PERIODIC RENT', 'Gross Receivables - CLS', 'Lease Receivables - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Rent', 'Sales Invoice - Tax', 'Billing Transaction', 'Tax on Stream Due', 'TAX BILLING', 'Sales Tax Payable - CLS', 'Lease Receivables Sales Tax - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Rent', 'Unbilled Receivable', 'Billing Transaction', 'Unbilled Receivable', 'Unbilled Receivable', 'Gross Receivables - CLS', 'Lease Receivables - CLS'));
		//lines.add(new AccountingTemplateLines('Billing - Rent', 'Unbilled Service and Maintenance', 'Billing Transaction', 'Unbilled Service and Maintenance', 'Unbilled Service and Maintenance', 'Accounts Payable - Vendor CLS', 'Fee Receivable - CLS'));
		lines.add(new AccountingTemplateLines('Billing - Rent', 'Purchase Amount', 'Billing Transaction', 'Purchase Amount', 'Purchase Amount', 'Residual Value - CLS', 'Lease Receivables - CLS'));
		headerLinesMap.put(header, lines);

		header = new AccountingTemplateHeader('Booking - Finance Lease', 'BOOKING');
		lines = new List<AccountingTemplateLines>();
		lines.add(new AccountingTemplateLines('Booking - Finance Lease', 'Unearned Residual Income', 	'Booking Transaction', 'Unearned Residual Income', 'UNEARNED RESIDUAL INCOME', 'Unearned Residual Income - CLS', 'Lease Payable Clearing - CLS'));
		lines.add(new AccountingTemplateLines('Booking - Finance Lease', 'Gross Receivables', 			'Booking Transaction', 'Gross Rent Amount', 'GROSS RENT', 'Lease Payable Clearing - CLS', 'Gross Receivables - CLS'));
		lines.add(new AccountingTemplateLines('Booking - Finance Lease', 'Residual Value', 				'Booking Transaction', 'Residual Receivable', 'RESIDUAL RECEIVABLE', 'Lease Payable Clearing - CLS', 'Residual Value - CLS'));
		lines.add(new AccountingTemplateLines('Booking - Finance Lease', 'Unearned Lease Income', 		'Booking Transaction', 'Unearned Lease Income', 'UNEARNED LEASE INCOME', 'Unearned Lease Income - Finance Lease - CLS', 'Lease Payable Clearing - CLS'));
		headerLinesMap.put(header, lines);

		header = new AccountingTemplateHeader('Disbursement', 'DISBURSEMENT');
		lines = new List<AccountingTemplateLines>();
		lines.add(new AccountingTemplateLines('Disbursement', 'Partner Pass Through - Service', 'Disbursement Transaction', 'Disbursement Amount', 'DEALER PAYABLE', 'Accounts Payable - Service - CLS', 'Pass Through Service Clearing - CLS'));
        lines.add(new AccountingTemplateLines('Disbursement', 'Partner Pass Through - Service', 'Disbursement Transaction', 'Disbursement Amount', 'Service Fees - Passthrough', 'Accounts Payable - Service - CLS', 'Pass Through Service Clearing - CLS'));
		headerLinesMap.put(header, lines);

		header = new AccountingTemplateHeader('Funding via Oracle AP', 'DEALER FUNDING');
		lines = new List<AccountingTemplateLines>();
		lines.add(new AccountingTemplateLines('Funding via Oracle AP', 'Vendor Funding', 'Funding Transaction', 'Dealer Payable Amount', 'DEALER PAYABLE FUNDING', 'Accounts Payable - Vendor CLS', 'Lease Payable Clearing - CLS'));
		headerLinesMap.put(header, lines);

		header = new AccountingTemplateHeader('Payment', 'PAYMENT');
		lines = new List<AccountingTemplateLines>();
		lines.add(new AccountingTemplateLines('Payment', 'Payment Service Fees - Sales Tax', 'Payment Transaction', 'Rent Billed', 'Service Fees - Tax', 'Pass Through Service Sales Tax - CLS', 'PNC - Newco - CLS'));
		lines.add(new AccountingTemplateLines('Payment', 'Payment Insurance Fees - Sales Tax', 'Payment Transaction', 'Rent Billed', 'Insurance Fees - Tax', 'Fee Receivable Sales Tax - CLS', 'PNC - Newco - CLS'));
		lines.add(new AccountingTemplateLines('Payment', 'Payment Est Property Tax Fees - Sales Tax', 'Payment Transaction', 'Rent Billed', 'Estimated Property Tax - Tax', 'Fee Receivable Sales Tax - CLS', 'PNC - Newco - CLS'));
		lines.add(new AccountingTemplateLines('Payment', 'Payment Finance Charge Fees - Sales Tax', 'Payment Transaction', 'Rent Billed', 'Finance Fees - Tax', 'Fee Receivable Sales Tax - CLS', 'PNC - Newco - CLS'));
		lines.add(new AccountingTemplateLines('Payment', 'Payment Late Fees - Sales Tax', 'Payment Transaction', 'Rent Billed', 'Late Fees - Tax', 'Fee Receivable Sales Tax - CLS', 'PNC - Newco - CLS'));
		lines.add(new AccountingTemplateLines('Payment', 'Payment Late Fees', 'Payment Transaction', 'Rent Billed', 'Late Fee', 'Fee Receivable - CLS', 'PNC - Newco - CLS'));
		lines.add(new AccountingTemplateLines('Payment', 'Payment Tax', 'Payment Transaction', 'Rent Billed', 'PAYMENT - TAX', 'Lease Receivables Sales Tax - CLS', 'PNC - Newco - CLS'));
		lines.add(new AccountingTemplateLines('Payment', 'Payment Finance Charge Fees', 'Payment Transaction', 'Rent Billed', 'Finance Fees', 'Fee Receivable - CLS', 'PNC - Newco - CLS'));
		lines.add(new AccountingTemplateLines('Payment', 'Payment Service Fees', 'Payment Transaction', 'Rent Billed', 'Service Fees', 'Pass Through Service Receivable - CLS', 'PNC - Newco - CLS'));
		lines.add(new AccountingTemplateLines('Payment', 'Payment Est Property Tax Fees', 'Payment Transaction', 'Rent Billed', 'Estimated Property Tax', 'Property Tax Receivable - CLS', 'PNC - Newco - CLS'));
		lines.add(new AccountingTemplateLines('Payment', 'Payment Rent', 'Payment Transaction', 'Rent Billed', 'PAYMENT - RENT', 'Lease Receivables - CLS', 'PNC - Newco - CLS'));
		lines.add(new AccountingTemplateLines('Payment', 'Payment Insurance Fees', 'Payment Transaction', 'Rent Billed', 'Insurance Fees', 'Fee Receivable - CLS', 'PNC - Newco - CLS'));
		headerLinesMap.put(header, lines);

		header = new AccountingTemplateHeader('Restructure', 'RESTRUCTURE');
		lines = new List<AccountingTemplateLines>();
		lines.add(new AccountingTemplateLines('Restructure', 'Income Adjustment', 'Restructure Transaction', 'Income Adjustment', 'Income Adjustment', 'Unearned Lease Income - Finance Lease - CLS', 'Lease Payable Clearing - CLS'));
		lines.add(new AccountingTemplateLines('Restructure', 'Gross Receivable Adjustment', 'Restructure Transaction', 'Gross Receivable Adjustment', 'Gross Receivable Adjustment', 'Lease Payable Clearing - CLS', 'Gross Receivables - CLS'));
		lines.add(new AccountingTemplateLines('Restructure', 'Residual Adjustment', 'Restructure Transaction', 'Residual Adjustment Decrease', 'Residual Adjustment Decrease', 'Lease Payable Clearing - CLS', 'Residual Value - CLS'));
		headerLinesMap.put(header, lines);

		// Creating Transacation SubType Map
        Map<String, Id> txnSubTypeMap = new Map<String, Id>();
        for(cllease__Transaction_Sub_Type__c txnSubType : [SELECT Id, Name FROM cllease__Transaction_Sub_Type__c order by createdDate LIMIT 1000]) {
            if(!txnSubTypeMap.containsKey(txnSubType.Name))
            	txnSubTypeMap.put(txnSubType.Name, txnSubType.Id);
        }

		// Creating GL Account Map
		Map<String, Id> glAccountMap = new Map<String, Id>();
		for(cllease__GL_Account__c glAccount : [SELECT Id, Name FROM cllease__GL_Account__c LIMIT 1000]) {
            glAccountMap.put(glAccount.Name, glAccount.Id);
        }


		// Inserting the data
		cllease__Accounting_Template_Header__c accHeader;
        List<cllease__Accounting_Template_Line__c> accLines;
        List<ParentChildrenWrapper> wrappers = new List<ParentChildrenWrapper>();
        try {
        	for(AccountingTemplateHeader accHeaderTemp : headerLinesMap.keySet()) {
	            accHeader = new cllease__Accounting_Template_Header__c(
	            		Name = accHeaderTemp.name, 
	            		cllease__Account_Status__c = 'REGULAR',
	            		cllease__Branch__c = companyId,
	            		cllease__Company__c = companyId,
	            		cllease__Enabled__c = true,
	            		cllease__Product__c = productId,
	            		cllease__Transaction_Type__c =  accHeaderTemp.txnType);

	            accLines = new List<cllease__Accounting_Template_Line__c>();

	            for(AccountingTemplateLines accLineTemp : headerLinesMap.get(accHeaderTemp)) {
	                accLines.add(new cllease__Accounting_Template_Line__c(
	                				Name 							= accLineTemp.name,
									cllease__Amount_Object__c 		= accLineTemp.amountObjectName,
									cllease__Amount_Object_Column__c= accLineTemp.amountObjectColumn,
									cllease__Transaction_Sub_Type__c= txnSubTypeMap.get(accLineTemp.txnTypeName),
									cllease__Credit_GL_Account__c   = glAccountMap.get(accLineTemp.debitGLAccountName),
									cllease__Debit_GL_Account__c	= glAccountMap.get(accLineTemp.creditGLAccountName),
									cllease__Enabled__c 			= true ));
	            }
	            wrappers.add(new ParentChildrenWrapper(accHeader, new Map<List<sobject>, String>{accLines => 'cllease__Accounting_Template_Header__c'}));
	        }
	        // inserting all amount objects and columns
	        ParentChildrenWrapper.upsertWrappers(wrappers);

        } catch(Exception e) {
        	System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());
            throw new CLSCustomException(' Exception while creating Accounting Setup: '+e.getMessage());
        }
	}
	
	public static void createAmountObjectColumnData() {
		Map<AmountObject, List<AmountColumn>> objectColumnsMap = new Map<AmountObject, List<AmountColumn>>();
		//Accrual Transaction
		AmountObject amtObj = new AmountObject('Accrual Transaction', 'cllease__Lease_trx_lines__c');
		List<AmountColumn> amtColList = new List<AmountColumn>();
		amtColList.add(new AmountColumn('Accrual Amount', 'cllease__Amount__c'));
		objectColumnsMap.put(amtObj, amtColList);

		//Asset Sale Transaction
		amtObj = new AmountObject('Asset Sale Transaction', 'cllease__Other_Transaction__c');
		amtColList = new List<AmountColumn>();
		amtColList.add(new AmountColumn('Residual Amount', 'cllease__Residual_Amount_New__c'));
		objectColumnsMap.put(amtObj, amtColList);

		//Billing Transaction
		amtObj = new AmountObject('Billing Transaction', 'cllease__Other_Transaction__c');
		amtColList = new List<AmountColumn>();
		amtColList.add(new AmountColumn('Periodic Rent Due', 				'cllease__Rental_Due_Amount__c'));
		amtColList.add(new AmountColumn('Tax on Stream Due', 				'cllease__Tax_Due_Amount__c'));
		amtColList.add(new AmountColumn('Subsidy Amount Billing', 			'cllease__Other_Due_Amount__c'));
		amtColList.add(new AmountColumn('Unbilled Receivable', 				'cllease__Unbilled_Receivable__c'));
		amtColList.add(new AmountColumn('Purchase Amount', 					'cllease__Purchase_Amount__c'));
		amtColList.add(new AmountColumn('Unbilled Service and Maintenance', 'cllease__Unbilled_Service_and_Maintenance__c'));
		objectColumnsMap.put(amtObj, amtColList);
		
		
		//Booking Transaction
		amtObj = new AmountObject('Booking Transaction', 'cllease__Other_Transaction__c');
		amtColList = new List<AmountColumn>();
		amtColList.add(new AmountColumn('Dealer Payable Amount', 		'cllease__Dealer_Payable_Amount__c'));
		amtColList.add(new AmountColumn('Initial Direct Cost Amount', 	'cllease__Initial_Direct_Cost_Amount__c'));
		amtColList.add(new AmountColumn('Gross Rent Amount', 			'cllease__Gross_Rent_Amount__c'));
		amtColList.add(new AmountColumn('Referral Fee Payable Amount', 	'cllease__Referral_Fee_Payable_Amount__c'));
		amtColList.add(new AmountColumn('Unearned Lease Income', 		'cllease__Unearned_Lease_Income_Amount__c'));
		amtColList.add(new AmountColumn('Unearned Residual Income', 	'cllease__Unearned_Income_Residual_Amount__c'));
		amtColList.add(new AmountColumn('Documentation Fees', 			'cllease__Documentation_Fee_Amount__c'));
		amtColList.add(new AmountColumn('Cash Received', 				'cllease__Cash_Received_Amount__c'));
		amtColList.add(new AmountColumn('Residual Receivable', 			'cllease__Lease_Residual_Receivable_Amount__c'));
		amtColList.add(new AmountColumn('Tax Upfront Amount', 			'cllease__Bill_Tax_Upfront_Amount__c'));
		amtColList.add(new AmountColumn('Equipment Cost', 				'cllease__equipment_cost__c'));
		amtColList.add(new AmountColumn('Net Book Value Residual', 		'cllease__Net_Book_Value_Residual__c'));
		amtColList.add(new AmountColumn('Net Book Value Lease', 		'cllease__Net_Book_Value_Lease__c'));
		objectColumnsMap.put(amtObj, amtColList);
		
		
		//Charge Transaction
		amtObj = new AmountObject('Charge Transaction', 'cllease__Other_Transaction__c');
		amtColList = new List<AmountColumn>();
		amtColList.add(new AmountColumn('Charge Amount', 	'cllease__Original_Amount__c'));
		amtColList.add(new AmountColumn('Tax Due', 			'cllease__Tax_Due__c'));
		objectColumnsMap.put(amtObj, amtColList);
		
		
		//Disbursement Transaction
		amtObj = new AmountObject('Disbursement Transaction', 'clcommon__Disbursement_Transaction__c');
		amtColList = new List<AmountColumn>();
		amtColList.add(new AmountColumn('Disbursement Amount', 'Fee_Amount_To_Dealer__c'));
		objectColumnsMap.put(amtObj, amtColList);
		
		
		//Funding Transaction
		amtObj = new AmountObject('Funding Transaction', 'clcommon__Disbursement_Transaction__c');
		amtColList = new List<AmountColumn>();
		amtColList.add(new AmountColumn('Dealer Payable Amount', 'clcommon__Dealer_Payable_Amount__c'));
		objectColumnsMap.put(amtObj, amtColList);
		
		
		//Payment Transaction
		amtObj = new AmountObject('Payment Transaction', 'cllease__Other_Transaction__c');
		amtColList = new List<AmountColumn>();
		amtColList.add(new AmountColumn('Rent Billed', 			'cllease__Amount__c'));
		amtColList.add(new AmountColumn('Receivable Billed', 	'cllease__Receivable_Billed__c'));
		objectColumnsMap.put(amtObj, amtColList);
		
		
		//Restructure Transaction
		amtObj = new AmountObject('Restructure Transaction', 'cllease__Other_Transaction__c');
		amtColList = new List<AmountColumn>();
		amtColList.add(new AmountColumn('Income Adjustment', 			'cllease__Income_Adjustment__c'));
		amtColList.add(new AmountColumn('Gross Receivable Adjustment', 	'cllease__Gross_Receivable_Adjustment__c'));
		amtColList.add(new AmountColumn('Residual Adjustment Decrease', 'cllease__Residual_Adjustment_Decrease__c'));
		objectColumnsMap.put(amtObj, amtColList);
		
		// Inserting the data
		cllease__Amount_Object__c transactionObject;
        List<cllease__Amount_Columns__c> amountColumns;
        List<ParentChildrenWrapper> wrappers = new List<ParentChildrenWrapper>();
        try {
        	for(AmountObject amountObject : objectColumnsMap.keySet()) {
	            transactionObject = new cllease__Amount_Object__c( Name = amountObject.txnName, cllease__Api_Name__c = amountObject.objAPIName);
	            amountColumns = new List<cllease__Amount_Columns__c>();
	            for(AmountColumn amountColumn : objectColumnsMap.get(amountObject)) {
	                amountColumns.add(new cllease__Amount_Columns__c(Name =  amountColumn.fieldName, cllease__Column_Api_Name__c = amountColumn.fieldAPIName));
	            }
	            wrappers.add(new ParentChildrenWrapper(transactionObject, new Map<List<sobject>, String>{amountColumns => 'cllease__Amount_Object__c'}));
	        }
	        // inserting all amount objects and columns
	        ParentChildrenWrapper.upsertWrappers(wrappers);

        } catch(Exception e) {
        	System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());
            throw new CLSCustomException(' Exception while creating Amount Object and Columns: '+e.getMessage());
        }
	}

	public static void createPeriodsFor2018(String calenderId) {

		List<cllease__Period_Status__c> periodsToInsert = new List<cllease__Period_Status__c>();
        Date startDate = Date.newInstance(2018, 01, 01);
        Date endDate = startDate.addMonths(1).addDays(-1);
        for (Integer i = 1; i <= 12; ++i) {
            cllease__Period_Status__c temp = new cllease__Period_Status__c(
            		Name = i + '-2018',
                    cllease__Calendar_Name__c 	= calenderID,
                    cllease__Start_Date__c 		= startDate,
                    cllease__End_Date__c 		= endDate,
                    cllease__Period_Month__c 	= i,
                    cllease__Period_Number__c 	= i,
                    cllease__Period_Year__c 	= 2018,
                    cllease__Quarter__c 		= Math.mod(i, 4),
                    cllease__Status__c 			= 'Open'
            );
            startDate 	= endDate.addDays(1);
            endDate 	= startDate.addMonths(1).addDays(-1);
            periodsToInsert.add(temp);
        }

        insert periodsToInsert;
	}

	public static void createTxnSubTypes() {
		List<cllease__Transaction_Sub_Type__c> transactionSubTypes = new List<cllease__Transaction_Sub_Type__c>();
		List<String> txnSubTypes = new List<String>{ 'Actual Property Tax','Actual Property Tax - Evergreen','Actual Property Tax - Tax',
		'ADVANCE PAYMENTS RECEIVED','Asset Repair,Fee','Asset Repair Fee - Evergreen','Asset Repair Fee - Passthrough','Asset Repair Fee - Tax',
		'Asset Return Fee type','Asset Return Fee type - Evergreen','Asset Return Fee type - Tax','ASSET SALE','ASSET SALE - Evergreen',
		'ASSET SALE - Tax','Capitalize Fees','CASH RECEIVED','DEALER PAYABLE','DEALER PAYABLE FUNDING','DEPRECIATION ACCRUAL','Doc Fees',
		'Documentation Fee','DOCUMENTATION FEES','Early Termination Fee','Early Termination Fee - Evergreen','Early Termination,Fee - Tax',
		'EQUIPMENT COST','Estimated Property Tax','Estimated Property Tax - Evergreen','Estimated Property Tax,- Tax','EVERGREEN RENT','EVERGREEN TAX',
		'Finance Fees','Finance Fees - Evergreen','Finance Fees - Tax','Gross Receivable,Adjustment','GROSS RENT','IDC COST','IDC EXPENSE ACCRUAL',
		'Income Adjustment','Insurance Fees','Insurance Fees -,Evergreen','Insurance Fees - Tax','Interim Rent','Interim Rent - Evergreen',
		'Interim Rent - Tax','Late Fee','Late Fees','Late Fees - Evergreen','Late Fees - Tax','LEASE INCOME ACCRUAL','NBV LEASE','NBV RESIDUAL',
		'NSF Fee','Origination Fee','Origination Fees','Origination Fees - Evergreen','Origination Fees - Tax','PAYMENT - CONTRACT SALE',
		'PAYMENT - EXCESS','PAYMENT - FEES','PAYMENT - RENT','PAYMENT - SUBSIDY','PAYMENT - TAX','PAYMENT - ADVANCE RENT','PAYMENT - REVERSAL',
		'PERIODIC RENT','PERIODIC RENT BILLING','Purchase Amount','Receivable Billed','REFERRAL FEE','REFERRAL FEE FUNDING','Referral Payment',
		'RENTAL ACCRUAL','Residual Adjustment Decrease','RESIDUAL INCOME ACCRUAL','RESIDUAL RECEIVABLE','Security Deposit','Service Fees',
		'Service Fees - Evergreen','Service Fees - Passthrough','Service Fees - Tax','Service Pass Through','Service Pass Through - Evergreen',
		'SUBSIDY ACCRUAL','SUBSIDY BILLING','TAX BILLING','TAX UPFRONT','TERM RESIDUAL','TERMINATION QUOTE FEES','TERMINATION QUOTE FEES - Evergreen',
		'TERMINATION QUOTE FEES - Tax','TERMINATION RENT','TERMINATION TAX','Test Fee','Test Fee - Evergreen','Unbilled Receivable',
		'Unbilled Service and Maintenance','UNEARNED,LEASE INCOME','UNEARNED RESIDUAL INCOME','Upfront Tax Fees','Upfront Tax Fees - Evergreen',
		'Upfront Tax,Fees - Tax', 'Estimated Property Tax - Tax', 'Gross Receivable Adjustment'};

		for(String txnSubType : txnSubTypes) {
			transactionSubTypes.add(new cllease__Transaction_Sub_Type__c(cllease__NPA_Flag__c = false, Name = txnSubType));
		}
		try {
			insert transactionSubTypes;
		} catch(Exception e) {
        	System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());
            throw new CLSCustomException(' Exception while creating Transaction Sub Types: '+e.getMessage());
        }	
	}

	public static void createGLAccounts() {
		List<GLAccount> glAccounts = new List<GLAccount>();
		// GL Account Code, Is Movement Code Eligible? , GL Account Name
		glAccounts.add(new GLAccount('340025', false, 'Accounts Payable - Service - CLS'));
		glAccounts.add(new GLAccount('340021', false, 'Accounts Payable - Vendor CLS'));
		glAccounts.add(new GLAccount('611021', false, 'Amortized Lease Income - CLS'));
		glAccounts.add(new GLAccount('611002', false, 'Amortized Residual Income - CLS'));
		glAccounts.add(new GLAccount('1011',   false, 'Cash'));
		glAccounts.add(new GLAccount('664020', false, 'Documentation Fees - CLS'));
		glAccounts.add(new GLAccount('147000', false, 'Fee Income'));
		glAccounts.add(new GLAccount('146020', false, 'Fee Receivable - CLS'));
		glAccounts.add(new GLAccount('146022', true,  'Fee Receivable Sales Tax - CLS'));
		glAccounts.add(new GLAccount('611025', false, 'Finance Charges - CLS'));
		glAccounts.add(new GLAccount('161020', true,  'Gross Receivables - CLS'));
		glAccounts.add(new GLAccount('662020', false, 'Insurance Fees - CLS'));
		glAccounts.add(new GLAccount('661020', false, 'Late Charge Fees - CLS'));
		glAccounts.add(new GLAccount('342020', false, 'Lease Payable Clearing - CLS'));
		glAccounts.add(new GLAccount('142020', true,  'Lease Receivables - CLS'));
		glAccounts.add(new GLAccount('142022', true,  'Lease Receivables Sales Tax - CLS'));
		glAccounts.add(new GLAccount('407021', false, 'Monthly Property Tax - CLS'));
		glAccounts.add(new GLAccount('153020', false, 'Pass Through Service Clearing - CLS'));
		glAccounts.add(new GLAccount('148020', false, 'Pass Through Service Receivable - CLS'));
		glAccounts.add(new GLAccount('148022', true,  'Pass Through Service Sales Tax - CLS'));
		glAccounts.add(new GLAccount('101020', false, 'PNC - Newco - CLS'));
		glAccounts.add(new GLAccount('150020', false, 'Property Tax Receivable - CLS'));
		glAccounts.add(new GLAccount('162200', false, 'Residual Recovery'));
		glAccounts.add(new GLAccount('162020', true,  'Residual Value - CLS'));
		glAccounts.add(new GLAccount('346021', true,  'Sales Tax Payable - CLS'));
		glAccounts.add(new GLAccount('163020', true,  'Unearned Lease Income - Finance Lease - CLS'));
		glAccounts.add(new GLAccount('164020', true,  'Unearned Residual Income - CLS'));
        glAccounts.add(new GLAccount('12345', true,  'On Account'));

		List<cllease__GL_Account__c> glAccountsToInsert = new List<cllease__GL_Account__c>();
		for(GLAccount glaccount: glAccounts) {
			glAccountsToInsert.add(new cllease__GL_Account__c(
									Name = glaccount.name, 	
									cllease__Account_Code__c = glaccount.code,
									Is_Movement_Code_Eligible__c = glaccount.isMovementCodeApplicable));
		}

		try {
			insert glAccountsToInsert;
		} catch(Exception e) {
        	System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());
            throw new CLSCustomException(' Exception while creating GL Accounts: '+e.getMessage());
        }
	}

	public static void createMovementCodes() {
        cllease__GL_Account__c glOnAccount = [SELECT Id FROM cllease__GL_Account__c WHERE Name = 'On Account' Limit 1];
		List<MovementCode> movementCodes = new List<MovementCode>();
		// Transcation Movement Codes
		movementCodes.add(new MovementCode('ACCRUAL', 	 '',	'02', '163020, 164020', 				'Accruals', 												'', '','',null));
		movementCodes.add(new MovementCode('BILLING', 	 '', 	'06', '142020, 161020', 				'Billing', 													'', '','',null));
		movementCodes.add(new MovementCode('BOOKING', 	 '', 	'01', '161020, 162020, 163020, 164020', 'Booking', 													'', '','',null));
		movementCodes.add(new MovementCode('PAYMENT', 	 '', 	'03', '142020', 			 			'Cash Application, On Account (143000),Cash Un Application','', '','',null));
		movementCodes.add(new MovementCode('RESTRUCTURE','', 	'02', '161020, 162020, 163020, 164020', 'Rebook (Restructure)', 									'', '','',null));
		movementCodes.add(new MovementCode('TERMINATION','', 	'03', '', 								'Termination, Partial Termination, Recovery (203000)', 		'', '','',null));
        movementCodes.add(new MovementCode('PAYMENT', 	 '', 	'03', '142020', 			 			'Cash Application, On Account (143000),Cash Un Application','', '','Credit',glOnAccount.Id));
        movementCodes.add(new MovementCode('PAYMENT', 	 '', 	'03', '142020', 			 			'Cash Application, On Account (143000),Cash Un Application','', '','Debit',glOnAccount.Id));

		// Tax MovementCode Codes
		movementCodes.add(new MovementCode('TAX', 'Alaska',				'AK', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022' ,'',null));
		movementCodes.add(new MovementCode('TAX', 'Alabama',			'AL', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Arkansas',			'AR', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Arizona',			'AZ', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'California',			'CA', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Canada',				'CN', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Colorado',			'CO', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Idaho',				'ID', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Illinois',			'IL', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Indiana',			'IN', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Kansas',				'KS', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Kentucky',			'KY', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Louisiana',			'LA', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Massachusetts',		'MA', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Maryland',			'MD', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Maine',				'ME', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Michigan',			'MI', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Minnesota',			'MN', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Montana',			'MT', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'North Carolina',		'NC', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'North Dakota',		'ND', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Nebraska',			'NE', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'New Hampshire',		'NH', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'New Jersey',			'NJ', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'New Mexico',			'NM', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Missouri',			'MO', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Mississippi',		'MS', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Nevada',				'NV', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'New York',			'NY', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Ohio',				'OH', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Oklahoma',			'OK', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Oregon',				'OR', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Pennsylvania',		'PA', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Puerto Rico',		'PR', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Rhode Island',		'RI', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'South Carolina',		'SC', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'South Dakota',		'SD', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Tennessee',			'TN', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Texas',				'TX', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Utah',				'UT', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Virginia',			'VA', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Virgin Islands',		'VI', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Vermont',			'VT', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Washington',			'WA', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Wisconsin',			'WI', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'West Virginia',		'WV', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Wyoming',			'WY', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Connecticut',		'CT', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'DistrictofColumbia', 'DC', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Delaware',			'DE', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Florida',			'FL', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Georgia',			'GA', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Hawaii',				'HI', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));
		movementCodes.add(new MovementCode('TAX', 'Iowa',				'IA', '', '',	'142022,146022, 148022, 346021', '142022, 146022, 148022','',null));

		List<Movement_Code__c> movementCodesToInsert = new List<Movement_Code__c>();
		for(MovementCode mvCode: movementCodes) {
			movementCodesToInsert.add(new Movement_Code__c(
												CL_Lease_Transaction_Type__c 				= mvCode.transactionType,
												Contract_Install_State_Location__c 			= mvCode.location,
												Movement_Code__c							= mvCode.movementCode,
												Transaction_Eligible_GL_Account_Codes__c	= mvCode.transactionGLAccCodes,
												Transaction_Type_in_OLFM__c					= mvCode.olfmTransactionType,		
												Billing_Tax_Eligible_GL_Account_Codes__c	= mvCode.billTaxGLAccCodes,
												Payment_Tax_Eligible_GL_Account_Codes__c    = mvCode.pmtTaxGLAccCodes,
            									Account_Type__c  = mvcode.accountType,
            									GL_Account__c = mvcode.glAccount));
		}

		try {
			insert movementCodesToInsert;

		} catch(Exception e) {
        	System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());
            throw new CLSCustomException(' Exception while creating MovementCodes: '+e.getMessage());
        }
	}

	

	//Following classes helps in formating data, easy access and correction.
	public class AmountObject {
		String txnName;
		String objAPIName;
		public AmountObject(String txnName, String objAPIName) {
			this.txnName 	= txnName;
			this.objAPIName  	= objAPIName;
		}
	}

	public class AmountColumn {
		String fieldName;
		String fieldAPIName;
		public AmountColumn(String fieldName, String fieldAPIName) {
			this.fieldName 		= fieldName;
			this.fieldAPIName  	= fieldAPIName;
		}
	}

	public class GLAccount {
		String name;
		String code;
		Boolean isMovementCodeApplicable;

		public GLAccount(String code, Boolean isMovementCodeApplicable, String name) {
			this.name = name;
			this.code = code;
			this.isMovementCodeApplicable = isMovementCodeApplicable;  
		}
	}

	public class TxnSubType {
		String name;
		Boolean npaFlag;
		public TxnSubType(String name, Boolean npaFlag) {
			this.name    = name;
			this.npaFlag = npaFlag;
		}
	}

	public class MovementCode {
		String transactionType;
		String location;
		String movementCode;
		String transactionGLAccCodes;
		String olfmTransactionType;		
		String billTaxGLAccCodes;
		String pmtTaxGLAccCodes;
        String accountType;
        Id glAccount;
		public MovementCode(String transactionType, String location, String movementCode, String transactionGLAccCodes, 
				String olfmTransactionType, String billTaxGLAccCodes, String pmtTaxGLAccCodes, String accountType, Id glAccount) {
			this.transactionType  		= transactionType;
			this.location 				= location;
			this.movementCode 			= movementCode;
			this.transactionGLAccCodes 	= transactionGLAccCodes;
			this.olfmTransactionType	= olfmTransactionType;		
			this.billTaxGLAccCodes 		= billTaxGLAccCodes;
			this.pmtTaxGLAccCodes 		= pmtTaxGLAccCodes;
            this.accountType = accountType;
            this.glAccount = glAccount;
		}

	}

	public class AccountingTemplateHeader {
		String name;
		String txnType;
		public AccountingTemplateHeader(String name, String txnType) {
			this.name = name;
			this.txnType = txnType;
		}
	}

	public class AccountingTemplateLines {
		String name;
		String amountObjectName;
		String amountObjectColumn;
		String txnTypeName;
		String debitGLAccountName;
		String creditGLAccountName;
		public AccountingTemplateLines(String name, String transactionName, String amountObjectName, String amountObjectColumn, 
				String txnTypeName, String debitGLAccountName, String creditGLAccountName) {
			this.name 				= name;
			this.amountObjectName 	= amountObjectName;
			this.amountObjectColumn = amountObjectColumn;
			this.txnTypeName 		= txnTypeName;
			this.debitGLAccountName = debitGLAccountName;
			this.creditGLAccountName=creditGLAccountName;
		}
	}
}