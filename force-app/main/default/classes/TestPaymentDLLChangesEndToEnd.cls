@isTest
public class TestPaymentDLLChangesEndToEnd {
    @testSetup
    public static void testDataSetUp(){
        cllease__Lease_Account__c contract = TestHelper.createContract();
        cllease__Lease_Product__c product = [SELECT Id, Name From cllease__Lease_Product__c Limit 1];
        cllease__Office_Name__c company = [SELECT Id, Name From cllease__Office_Name__c Where Name = 'Test Office'];

        TestData.doPreSetup();
        TestData.createAccountingTemplateSetup(product.Id, company.Id);
        
        // Accounting setup for onAccount
        // 1. Creating Gl Accounts
        List<cllease__GL_Account__c> glAccounts = new List<cllease__GL_Account__c>();
        glAccounts.add(new cllease__GL_Account__c (cllease__Account_Code__c  = '12345', Name = 'test'));
        glAccounts.add(new cllease__GL_Account__c (cllease__Account_Code__c  = '54321', Name = 'Cash'));
        Insert glAccounts;
        
        cllease__GL_Account__c glOnAccount = [SELECT Id FROM cllease__GL_Account__c WHERE Name = 'On Account' Limit 1];
        
        // 2. Transaction sub type for onAccount
        cllease__Transaction_Sub_Type__c transactionSubTypes = new cllease__Transaction_Sub_Type__c(Name = 'Invoice Credit');
        Insert transactionSubTypes;
        
        // 3. Creating accounting amount object for onAccount
        //Payment Transaction
        cllease__Amount_Object__c  amtObjHeader = new cllease__Amount_Object__c(Name = 'Invoice Credit', cllease__API_Name__c = 'Test', cllease__Active__c = true);
        Insert amtObjHeader;
        cllease__Amount_Columns__c  amtObjColumn = new cllease__Amount_Columns__c(cllease__Amount_Object__c = amtObjHeader.Id, Name = 'Credit Amount', cllease__Column_API_Name__c = 'cllease__Original_Credit_Amount__c');
        Insert amtObjColumn;
        
        // 4. Create Template Header and Template Lines for onAccount accounting
        cllease__Accounting_Template_Header__c accountingHeader = new cllease__Accounting_Template_Header__c(
                                                                    Name = 'Invoice Credit',
                                                                    cllease__Transaction_Type__c  = 'INVOICE CREDIT',
                                                                    cllease__Account_Status__c = 'REGULAR', 
                                                                    cllease__Company__c = company.id, 
                                                                    cllease__Branch__c = company.id, 
                                                                    cllease__Enabled__c = true,
                                                                    cllease__Product__c = product.id);
        Insert accountingHeader;
        cllease__Accounting_Template_Line__c  accountingLine = new cllease__Accounting_Template_Line__c(
            Name = 'Credit Amount' , 
            cllease__Accounting_Template_Header__c = accountingHeader.id, 
            cllease__Amount_Object__c = 'Invoice Credit', 
            cllease__Amount_Object_Column__c  = 'Credit Amount', 
            cllease__Credit_GL_Account__c = glOnAccount.id,
            cllease__Debit_GL_Account__c = glAccounts[1].id, 
            cllease__Transaction_Sub_Type__c = transactionSubTypes.id, 
            cllease__Enabled__c = true);
        Insert accountingLine;
        
        // 5. Insert payment mode
        clcommon__Payment_Mode__c  paymentMode = new clcommon__Payment_Mode__c (Name = 'CASH');
        insert paymentMode;
    }
    
    @isTest
    public static void testOnAccountCreationOnExcessPayment(){
        List<cllease__GL_Account__c> glAccounts = [SELECT Id FROM cllease__GL_Account__c WHERE NAME IN ('On Account', 'Cash') ORDER BY NAME];
        cllease__Lease_Account__c contract = [SELECT Id, cllease__Contract_Date__c, cllease__Account__c from Cllease__Lease_Account__c limit 1];
        // Create Cash Receipt
        List<clcommon__Payment_Mode__c > paymentMode = [SELECT ID, NAME FROM clcommon__Payment_Mode__c Limit 1];
        clcommon__Cash_Receipt__c cashReceipt = new clcommon__Cash_Receipt__c();
        cashReceipt.clcommon__Account__c = contract.cllease__Account__c;
        cashReceipt.clcommon__Payment_Mode__c = paymentMode[0].Id;
        cashReceipt.clcommon__Receipt_Date__c = contract.cllease__Contract_Date__c;
        cashReceipt.clcommon__Receipt_Amount__c = 100;
        cashReceipt.clcommon__Creation_Date__c  = contract.cllease__Contract_Date__c;
        cashReceipt.clcommon__Unused_Amount__c =  100;
        cashReceipt.clcommon__Receipt_Status__c = 'CREATED';
        insert cashReceipt;
        
        // Create Cash receipt application
        clcommon__Cash_Receipt_Application__c cashApplication = new clcommon__Cash_Receipt_Application__c();
        cashApplication.clcommon__Cash_Receipt__c = cashReceipt.Id;
        cashApplication.clcommon__Creation_Date__c = contract.cllease__Contract_Date__c;
        cashApplication.clcommon__Allocated_Amount__c = 100;
        cashApplication.clcommon__Receipt_Application_Status__c   = 'CREATED';
        cashApplication.clcommon__Unused_Amount__c  = 100;
        insert cashApplication;
        
        List<cllease__Lease_Payment_Transaction__c> lpt = new List<cllease__Lease_Payment_Transaction__c>();
        lpt.add(new cllease__Lease_Payment_Transaction__c(cllease__Contract__c = contract.Id,
                                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c ,
                                                          cllease__Transaction_Amount__c = 100,
                                                          cllease__Cash_Application__c = cashApplication.Id,
                                                          cllease__Payment_Mode__c = cllease.GlobalContext.INSTANCE.getPaymentModeByName('Cash').Id));
        Insert lpt;
        cllease.BulkLeasePaymentAction leasePayment = new cllease.BulkLeasePaymentAction(lpt);
        leasePayment.postPayments();
        List<cllease__Lease_Payment_Transaction__c> pmt = [SELECT cllease__Excess__c, Invoice_Credit_Amount__c FROM cllease__Lease_Payment_Transaction__c WHERE Id=:lpt[0].Id];
        System.debug(LoggingLevel.ERROR, '^^^^ pmt : ' + pmt);
        System.assertEquals(lpt[0].cllease__Transaction_Amount__c, pmt[0].Invoice_Credit_Amount__c, 'Mismatch in on Account Amount');
        System.assertEquals(0, pmt[0].cllease__Excess__c, 'Excess amount should be zero');
        List<cllease__Lease_Payment_Detail__c> pmtDetails = [SELECT ID, cllease__Transaction_Sub_Type__r.Name FROM cllease__Lease_Payment_Detail__c WHERE cllease__Payment_Transaction__c =: lpt[0].Id];
        System.assertEquals(1, pmtDetails.size(), 'One LPD should be there with transaction subtype as on account');
        System.assertEquals('ON ACCOUNT', pmtDetails[0].cllease__Transaction_Sub_Type__r.Name, 'One LPD should be there with transaction subtype as on account');
        test.startTest();
        	cllease.GLTransactionGeneratorJob job = new cllease.GLTransactionGeneratorJob();
        	Database.executeBatch(job);
        test.stopTest();
    }
    
    @isTest
    public static void testOnAccountCreationOnExcessPaymentReversal(){
        List<cllease__GL_Account__c> glAccounts = [SELECT Id FROM cllease__GL_Account__c WHERE NAME IN ('On Account', 'Cash') ORDER BY NAME];
        cllease__Lease_Account__c contract = [SELECT Id, Name, cllease__Branch__c, cllease__Contract_Date__c, cllease__Account__c from Cllease__Lease_Account__c limit 1];
        // Create Cash Receipt
        List<clcommon__Payment_Mode__c > paymentMode = [SELECT ID, NAME FROM clcommon__Payment_Mode__c Limit 1];
        clcommon__Cash_Receipt__c cashReceipt = new clcommon__Cash_Receipt__c();
        cashReceipt.clcommon__Account__c = contract.cllease__Account__c;
        cashReceipt.clcommon__Payment_Mode__c = paymentMode[0].Id;
        cashReceipt.clcommon__Receipt_Date__c = contract.cllease__Contract_Date__c;
        cashReceipt.clcommon__Receipt_Amount__c = 100;
        cashReceipt.clcommon__Creation_Date__c  = contract.cllease__Contract_Date__c;
        cashReceipt.clcommon__Unused_Amount__c =  100;
        cashReceipt.clcommon__Receipt_Status__c = 'CREATED';
        insert cashReceipt;
        
        // Create Cash receipt application
        clcommon__Cash_Receipt_Application__c cashApplication = new clcommon__Cash_Receipt_Application__c();
        cashApplication.clcommon__Cash_Receipt__c = cashReceipt.Id;
        cashApplication.clcommon__Creation_Date__c = contract.cllease__Contract_Date__c;
        cashApplication.clcommon__Allocated_Amount__c = 100;
        cashApplication.clcommon__Receipt_Application_Status__c   = 'CREATED';
        cashApplication.clcommon__Unused_Amount__c  = 100;
        insert cashApplication;
        
        List<cllease__Lease_Payment_Transaction__c> lpt = new List<cllease__Lease_Payment_Transaction__c>();
        lpt.add(new cllease__Lease_Payment_Transaction__c(cllease__Contract__c = contract.Id,
                                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c ,
                                                          cllease__Transaction_Amount__c = 100,
                                                          cllease__Cash_Application__c = cashApplication.Id,
                                                          cllease__Payment_Mode__c = cllease.GlobalContext.INSTANCE.getPaymentModeByName('Cash').Id));
        Insert lpt;
        test.startTest();
            List<String> contractName = new List<String>();
            contractName.add(contract.Name);
            ApplyPaymentProcessingJob job = new ApplyPaymentProcessingJob(contractName);
            Database.executeBatch(job);
        test.stopTest();
        
        List<cllease__Repayment_Transaction_Adjustment__c> reversalList = new List<cllease__Repayment_Transaction_Adjustment__c>();
        cllease__Repayment_Transaction_Adjustment__c reversalTransaction = new cllease__Repayment_Transaction_Adjustment__c(
                                                                                cllease__Lease_Payment_Transaction__c = lpt[0].Id,
                                                                                cllease__LS_Contract__c = contract.Id,
                                                                                cllease__Adjusted_Amount__c = lpt[0].cllease__Transaction_Amount__c,
                                                                                cllease__Adjustment_Txn_Date__c  = lpt[0].cllease__Transaction_Date__c,
                                                                                cllease__Reason_Code__c = 'NSF');
        Insert reversalTransaction;
        reversalList.add(reversalTransaction);
        cllease.IBulkPaymentReversalAction dAction = new cllease.BulkRepaymentAdjustmentAction(reversalList);
        dAction.postRepaymentsAdjusment();
        List<clcommon__Cash_Receipt__c> onAccountCR = [SELECT ID,
                                                        Name,
                                                        Payment_Transaction__c,
                                                        clcommon__Receipt_Status__c 
                                                        FROM clcommon__Cash_Receipt__c 
                                                        WHERE Payment_Transaction__c =: lpt[0].Id];
        System.assertEquals('CANCELLED', onAccountCR[0].clcommon__Receipt_Status__c, 'ON Account CR should be cancelled as the payment is reversed');
        List<cllease__Lease_Payment_Transaction__c> pmt = [SELECT cllease__Excess__c, Invoice_Credit_Amount__c, cllease__Reversed__c FROM cllease__Lease_Payment_Transaction__c WHERE Id=:lpt[0].Id];
        System.assertEquals(true, pmt[0].cllease__Reversed__c, 'Payment should be reversed');
    }
    
    @isTest
    public static void testOnAccountCreationOnExcessPaymentReversalReApply(){
        List<cllease__GL_Account__c> glAccounts = [SELECT Id FROM cllease__GL_Account__c WHERE NAME IN ('On Account', 'Cash') ORDER BY NAME];
        cllease__Lease_Account__c contract = [SELECT Id, Name, cllease__Branch__c, cllease__Contract_Date__c, cllease__Account__c from Cllease__Lease_Account__c limit 1];
        // Creating bill for contract
        cllease__Lease_account_Due_Details__c bill = new cllease__Lease_account_Due_Details__c(cllease__Lease_Account__c = contract.Id,
                                                                                              cllease__Due_Date__c = contract.cllease__Contract_Date__c,
                                                                                              cllease__Due_Type_Description__c = 'BILL / DUE DATE',
                                                                                              cllease__Rental_Due_Amount__c = 70,
                                                                                              cllease__Tax_Due_Amount__c = 0,
                                                                                              cllease__Total_Due_Amount__c = 70,
                                                                                              cllease__Status__c = 'Tax Calculated',
                                                                                              cllease__Transaction_Date__c = contract.cllease__Contract_Date__c);
        insert bill;
        // Create Cash Receipt
        List<clcommon__Payment_Mode__c > paymentMode = [SELECT ID, NAME FROM clcommon__Payment_Mode__c Limit 1];
        clcommon__Cash_Receipt__c cashReceipt = new clcommon__Cash_Receipt__c();
        cashReceipt.clcommon__Account__c = contract.cllease__Account__c;
        cashReceipt.clcommon__Payment_Mode__c = paymentMode[0].Id;
        cashReceipt.clcommon__Receipt_Date__c = contract.cllease__Contract_Date__c;
        cashReceipt.clcommon__Receipt_Amount__c = 100;
        cashReceipt.clcommon__Creation_Date__c  = contract.cllease__Contract_Date__c;
        cashReceipt.clcommon__Unused_Amount__c =  100;
        cashReceipt.clcommon__Receipt_Status__c = 'CREATED';
        insert cashReceipt;
        
        // Create Cash receipt application
        clcommon__Cash_Receipt_Application__c cashApplication = new clcommon__Cash_Receipt_Application__c();
        cashApplication.clcommon__Cash_Receipt__c = cashReceipt.Id;
        cashApplication.clcommon__Creation_Date__c = contract.cllease__Contract_Date__c;
        cashApplication.clcommon__Allocated_Amount__c = 100;
        cashApplication.clcommon__Receipt_Application_Status__c   = 'CREATED';
        cashApplication.clcommon__Unused_Amount__c  = 100;
        insert cashApplication;
        
        List<cllease__Lease_Payment_Transaction__c> lpt = new List<cllease__Lease_Payment_Transaction__c>();
        lpt.add(new cllease__Lease_Payment_Transaction__c(cllease__Contract__c = contract.Id,
                                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c ,
                                                          cllease__Transaction_Amount__c = 100,
                                                          cllease__Cash_Application__c = cashApplication.Id,
                                                          cllease__Payment_Mode__c = cllease.GlobalContext.INSTANCE.getPaymentModeByName('Cash').Id));
        Insert lpt;
        test.startTest();
            List<String> contractName = new List<String>();
            contractName.add(contract.Name);
            ApplyPaymentProcessingJob job = new ApplyPaymentProcessingJob(contractName);
            Database.executeBatch(job);
        test.stopTest();
        
        // Generating GL for LPD
        List<cllease__Lease_Payment_Detail__c> pmtDetails = [SELECT ID, 
                                                                cllease__Transaction_Sub_Type__r.Name 
                                                             FROM cllease__Lease_Payment_Detail__c 
                                                             WHERE cllease__Payment_Transaction__c =: lpt[0].Id
                                                            AND cllease__Transaction_Sub_Type__r.Name != 'ON ACCOUNT'];
        System.debug(LoggingLevel.ERROR, '^^^^ pmtDetails : ' + pmtDetails);
        System.debug(LoggingLevel.ERROR, '^^^^ pmtDetails : ' + pmtDetails[0].cllease__Transaction_Sub_Type__r.Name);
        cllease__GL_Account__c account = [SELECT ID FROM cllease__GL_Account__c LIMIT 1];
        cllease__GL_Transaction_Detail__c new_txn = new cllease__GL_Transaction_Detail__c();
        new_txn.cllease__Credit_Amount__c = 70;
        new_txn.cllease__Debit_Amount__c = 70;
        new_txn.cllease__Credit_GL_Account__c = account.Id;
        new_txn.cllease__Debit_GL_Account__c = account.Id;
        new_txn.cllease__GL_Date__c = cllease.SystemDateUtil.getCurrentSystemDate();
        new_txn.cllease__Generation_Scheme__c = 'SYSTEM';
        new_txn.cllease__Lease_Payment_Detail__c = pmtDetails[0].Id;
        new_txn.cllease__Contract__c = contract.Id;
        new_txn.Movement_Code_Dr__c = '06';
        new_txn.Movement_Code_Cr__c = '03';
        new_txn.cllease__Company__c = contract.cllease__Branch__c;
        insert new_txn;
        
        List<cllease__Repayment_Transaction_Adjustment__c> reversalList = new List<cllease__Repayment_Transaction_Adjustment__c>();
        cllease__Repayment_Transaction_Adjustment__c reversalTransaction = new cllease__Repayment_Transaction_Adjustment__c(
                                                                                cllease__Lease_Payment_Transaction__c = lpt[0].Id,
                                                                                cllease__LS_Contract__c = contract.Id,
                                                                                cllease__Adjusted_Amount__c = lpt[0].cllease__Transaction_Amount__c,
                                                                                cllease__Adjustment_Txn_Date__c  = lpt[0].cllease__Transaction_Date__c,
                                                                                cllease__Reason_Code__c = 'ReApply');
        Insert reversalTransaction;
        reversalList.add(reversalTransaction);
        cllease.IBulkPaymentReversalAction dAction = new cllease.BulkRepaymentAdjustmentAction(reversalList);
        dAction.postRepaymentsAdjusment();
        reversalList[0].cllease__Cleared__c = false;
        update reversalList;
        
        List<clcommon__Cash_Receipt__c> onAccountCR = [SELECT ID,
                                                        Name,
                                                        Payment_Transaction__c,
                                                        clcommon__Receipt_Status__c,
                                                        clcommon__Receipt_Amount__c
                                                        FROM clcommon__Cash_Receipt__c 
                                                        WHERE Payment_Transaction__c =: lpt[0].Id
                                                        ORDER BY createdDate];
        System.assertEquals(70.00, onAccountCR[1].clcommon__Receipt_Amount__c, 'New cash receipt with 70.00$ should get created');
        List<cllease__Lease_Payment_Transaction__c> pmt = [SELECT cllease__Excess__c, Invoice_Credit_Amount__c, cllease__Reversed__c FROM cllease__Lease_Payment_Transaction__c WHERE Id=:lpt[0].Id];
        System.assertEquals(true, pmt[0].cllease__Reversed__c, 'Payment should be reversed');
    }
    
    // Below test cases are written for code coverage for a page ctrl class.
    
    @isTest
    public static void invoiceCreditPage(){
        cllease__Lease_Account__c contract = [SELECT Id, cllease__Contract_Date__c from Cllease__Lease_Account__c limit 1];
        cllease__Invoice_Credit__c invoice = new cllease__Invoice_Credit__c(
                                                cllease__Original_Credit_Amount__c = 100,
                                                cllease__Contract__c = contract.Id,
                                                cllease__Status__c = 'Unapplied',
                                                cllease__Comments__c = 'Test');
        Insert invoice;
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(invoice);
        InvoiceCreditViewCtrl invoiceCtrl = new InvoiceCreditViewCtrl(stdCtrl);
        invoiceCtrl.validate();
        invoiceCtrl.save();
        invoiceCtrl.cancel();
        
        invoice = new cllease__Invoice_Credit__c(
                        cllease__Original_Credit_Amount__c = 100,
                        cllease__Comments__c = 'Test');
        PageReference myVfPage = Page.OnAccount;
        Test.setCurrentPage(myVfPage);
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('leaseId',contract.Id);
        stdCtrl = new ApexPages.StandardController(invoice);
        invoiceCtrl = new InvoiceCreditViewCtrl(stdCtrl);
        try{
            invoiceCtrl.save();
        } catch(Exception e){
            System.debug(Logginglevel.ERROR, '^^^ Exception checking');
        }
    }
    
    @isTest
    public static void testInvoiceConsolidation(){
        List<cllease__GL_Account__c> glAccounts = [SELECT Id FROM cllease__GL_Account__c WHERE NAME IN ('On Account', 'Cash') ORDER BY NAME];
        cllease__Lease_Account__c contract = [SELECT Id, Name, cllease__Branch__c, cllease__Contract_Date__c, cllease__Account__c from Cllease__Lease_Account__c limit 1];
        List<clcommon__Fee_Definition__c> fee = [SELECT Id FROM clcommon__Fee_Definition__c];
        // Creating bill for contract
        List<cllease__Lease_account_Due_Details__c> bills = new List<cllease__Lease_account_Due_Details__c>();
        bills.add(new cllease__Lease_account_Due_Details__c(cllease__Lease_Account__c = contract.Id,
                                                            cllease__Due_Date__c = contract.cllease__Contract_Date__c,
                                                            cllease__Due_Type_Description__c = 'BILL / DUE DATE',
                                                            cllease__Rental_Due_Amount__c = 70,
                                                            cllease__Tax_Due_Amount__c = 0,
                                                            cllease__Total_Due_Amount__c = 70,
                                                            cllease__Status__c = 'Tax Calculated',
                                                            cllease__Transaction_Date__c = contract.cllease__Contract_Date__c));
        bills.add(new cllease__Lease_account_Due_Details__c(cllease__Lease_Account__c = contract.Id,
                                                            cllease__Due_Date__c = contract.cllease__Contract_Date__c,
                                                            cllease__Due_Type_Description__c = 'BILL / DUE DATE',
                                                            cllease__Rental_Due_Amount__c = 100,
                                                            cllease__Tax_Due_Amount__c = 0,
                                                            cllease__Total_Due_Amount__c = 100,
                                                            cllease__Status__c = 'Tax Calculated',
                                                            cllease__Transaction_Date__c = contract.cllease__Contract_Date__c));
        insert bills;
        
        // creating charge for contrat
        List<cllease__Charge__c> charges = new List<cllease__Charge__c>();
        charges.add(new cllease__Charge__c(cllease__Lease_Account__c = contract.Id,
                                          cllease__Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Original_Amount__c = 50,
                                          cllease__Principal_Due__c = 50,
                                          cllease__Tax_Due__c = 0,
                                          cllease__Fee_Definition__c = fee[0].Id,
                                          cllease__Tax_Processed__c = 'Tax Calculated'));
        charges.add(new cllease__Charge__c(cllease__Lease_Account__c = contract.Id,
                                          cllease__Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Original_Amount__c = 50,
                                          cllease__Principal_Due__c = 50,
                                          cllease__Tax_Due__c = 0,
                                          cllease__Fee_Definition__c = fee[0].Id,
                                          cllease__Tax_Processed__c = 'Tax Calculated'));
        insert charges;
        
        List<clcommon__Consolidated_Invoice__c> invoices = new List<clcommon__Consolidated_Invoice__c>();
        invoices.add(new clcommon__Consolidated_Invoice__c(clcommon__Account__c = contract.cllease__Account__c));
        invoices.add(new clcommon__Consolidated_Invoice__c(clcommon__Account__c = contract.cllease__Account__c));
        insert invoices;
        bills[0].cllease__Consolidated_Invoice__c = invoices[0].Id;
        bills[1].cllease__Consolidated_Invoice__c = invoices[0].Id;
        update bills;
        charges[0].cllease__Consolidated_Invoice__c  = invoices[0].Id;
        charges[1].cllease__Consolidated_Invoice__c  = invoices[0].Id;
        update charges;
        
        bills[1].cllease__Consolidated_Invoice__c = invoices[1].Id;
        update bills;
        
        charges[1].cllease__Consolidated_Invoice__c  = invoices[1].Id;
        update charges;
        
        bills[1].cllease__Consolidated_Invoice__c = null;
        update bills;
        
        List<clcommon__Consolidated_Invoice__c> invoicesList = [SELECT Id, Name, LS_Contract__c, clcommon__Account__c, Balance_Invoice_Amount__c, Rent_Billed_Total__c,
                                                                Fee_Billed_Total_Amount__c ,
                                                (SELECT Id, Name, cllease__Total_Due_Amount__c, cllease__Consolidated_Invoice__c 
                                                    FROM cllease__Bills__r
                                                    WHERE cllease__Payment_Satisfied__c = false),
                                                (SELECT Id, Name,cllease__Total_Due_Amount__c,cllease__Consolidated_Invoice__c 
                                                    FROM cllease__Charges__r
                                                    WHERE cllease__Paid__c = false) 
                                            FROM clcommon__Consolidated_Invoice__c ];
        
        System.assertEquals(70, invoicesList[0].Rent_Billed_Total__c, 'Invoice 0 list should contain only 70$ bill');
        System.assertEquals(50, invoicesList[0].Fee_Billed_Total_Amount__c, 'Invoice 0 list should contain only 50$ charge');
        System.assertEquals(0, invoicesList[1].Rent_Billed_Total__c, 'Invoice 1 list should contain only 0$ bill');
        System.assertEquals(50, invoicesList[1].Fee_Billed_Total_Amount__c, 'Invoice 1 list should contain only 50$ bill');
    }
    
    @isTest
    public static void testInvoiceMigration(){
        List<cllease__GL_Account__c> glAccounts = [SELECT Id FROM cllease__GL_Account__c WHERE NAME IN ('OnAccount', 'Cash') ORDER BY NAME];
        cllease__Lease_Account__c contract = [SELECT Id, Name, cllease__Branch__c, cllease__Contract_Date__c, cllease__Account__c from Cllease__Lease_Account__c limit 1];
        List<clcommon__Fee_Definition__c> fee = [SELECT Id FROM clcommon__Fee_Definition__c];
        // Creating bill for contract
        List<cllease__Lease_account_Due_Details__c> bills = new List<cllease__Lease_account_Due_Details__c>();
        bills.add(new cllease__Lease_account_Due_Details__c(cllease__Lease_Account__c = contract.Id,
                                                            cllease__Due_Date__c = contract.cllease__Contract_Date__c,
                                                            cllease__Due_Type_Description__c = 'BILL / DUE DATE',
                                                            cllease__Rental_Due_Amount__c = 70,
                                                            cllease__Tax_Due_Amount__c = 0,
                                                            cllease__Total_Due_Amount__c = 70,
                                                            cllease__Status__c = 'Tax Calculated',
                                                            cllease__Transaction_Date__c = contract.cllease__Contract_Date__c));
        bills.add(new cllease__Lease_account_Due_Details__c(cllease__Lease_Account__c = contract.Id,
                                                            cllease__Due_Date__c = contract.cllease__Contract_Date__c,
                                                            cllease__Due_Type_Description__c = 'BILL / DUE DATE',
                                                            cllease__Rental_Due_Amount__c = 100,
                                                            cllease__Tax_Due_Amount__c = 0,
                                                            cllease__Total_Due_Amount__c = 100,
                                                            cllease__Status__c = 'Tax Calculated',
                                                            cllease__Transaction_Date__c = contract.cllease__Contract_Date__c));
        insert bills;
        
        // creating charge for contrat
        List<cllease__Charge__c> charges = new List<cllease__Charge__c>();
        charges.add(new cllease__Charge__c(cllease__Lease_Account__c = contract.Id,
                                          cllease__Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Original_Amount__c = 50,
                                          cllease__Principal_Due__c = 50,
                                          cllease__Tax_Due__c = 0,
                                          cllease__Fee_Definition__c = fee[0].Id,
                                          cllease__Tax_Processed__c = 'Tax Calculated'));
        charges.add(new cllease__Charge__c(cllease__Lease_Account__c = contract.Id,
                                          cllease__Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Original_Amount__c = 50,
                                          cllease__Principal_Due__c = 50,
                                          cllease__Tax_Due__c = 0,
                                          cllease__Fee_Definition__c = fee[0].Id,
                                          cllease__Tax_Processed__c = 'Tax Calculated'));
        insert charges;
        
        List<Invoice__c> invoices = new List<Invoice__c>();
        invoices.add(new Invoice__c(LS_Contract__c  = contract.Id));
        insert invoices;
        
        bills[0].Invoiced_In__c = invoices[0].Id;
        bills[1].Invoiced_In__c = invoices[0].Id;
        update bills;
        charges[0].Invoiced_In__c = invoices[0].Id;
        charges[1].Invoiced_In__c = invoices[0].Id;
        update charges;
        
        Test.startTest();
        	InvoiceMigration job = new InvoiceMigration();
			Database.executeBatch(job, 1);
        Test.stopTest();
        
        List<clcommon__Consolidated_Invoice__c> invoicesList = [SELECT Id, Name, LS_Contract__c, clcommon__Account__c, Balance_Invoice_Amount__c, Rent_Billed_Total__c,
                                                                Fee_Billed_Total_Amount__c ,
                                                (SELECT Id, Name, cllease__Total_Due_Amount__c, cllease__Consolidated_Invoice__c 
                                                    FROM cllease__Bills__r
                                                    WHERE cllease__Payment_Satisfied__c = false),
                                                (SELECT Id, Name,cllease__Total_Due_Amount__c,cllease__Consolidated_Invoice__c 
                                                    FROM cllease__Charges__r
                                                    WHERE cllease__Paid__c = false) 
                                            FROM clcommon__Consolidated_Invoice__c ];

        System.assertEquals(2, invoicesList[0].cllease__Bills__r.size(), 'Invoice 0 list should contain only 2 bills');
        System.assertEquals(2, invoicesList[0].cllease__Charges__r.size(), 'Invoice 0 list should contain only 2 charges');
    }
    
    @isTest
    public static void testPNCPaymentCreationJob(){
        List<cllease__GL_Account__c> glAccounts = [SELECT Id FROM cllease__GL_Account__c WHERE NAME IN ('OnAccount', 'Cash') ORDER BY NAME];
        cllease__Lease_Account__c contract = [SELECT Id, Name, cllease__Branch__c, cllease__Contract_Date__c, cllease__Account__c from Cllease__Lease_Account__c limit 1];
        List<clcommon__Fee_Definition__c> fee = [SELECT Id FROM clcommon__Fee_Definition__c];
        // Creating bill for contract
        List<cllease__Lease_account_Due_Details__c> bills = new List<cllease__Lease_account_Due_Details__c>();
        bills.add(new cllease__Lease_account_Due_Details__c(cllease__Lease_Account__c = contract.Id,
                                                            cllease__Due_Date__c = contract.cllease__Contract_Date__c,
                                                            cllease__Due_Type_Description__c = 'BILL / DUE DATE',
                                                            cllease__Rental_Due_Amount__c = 70,
                                                            cllease__Tax_Due_Amount__c = 0,
                                                            cllease__Total_Due_Amount__c = 70,
                                                            cllease__Status__c = 'Tax Calculated',
                                                            cllease__Transaction_Date__c = contract.cllease__Contract_Date__c));
        bills.add(new cllease__Lease_account_Due_Details__c(cllease__Lease_Account__c = contract.Id,
                                                            cllease__Due_Date__c = contract.cllease__Contract_Date__c,
                                                            cllease__Due_Type_Description__c = 'BILL / DUE DATE',
                                                            cllease__Rental_Due_Amount__c = 100,
                                                            cllease__Tax_Due_Amount__c = 0,
                                                            cllease__Total_Due_Amount__c = 100,
                                                            cllease__Status__c = 'Tax Calculated',
                                                            cllease__Transaction_Date__c = contract.cllease__Contract_Date__c));
        insert bills;
        
        // creating charge for contrat
        List<cllease__Charge__c> charges = new List<cllease__Charge__c>();
        charges.add(new cllease__Charge__c(cllease__Lease_Account__c = contract.Id,
                                          cllease__Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Original_Amount__c = 50,
                                          cllease__Principal_Due__c = 50,
                                          cllease__Tax_Due__c = 0,
                                          cllease__Fee_Definition__c = fee[0].Id,
                                          cllease__Tax_Processed__c = 'Tax Calculated'));
        charges.add(new cllease__Charge__c(cllease__Lease_Account__c = contract.Id,
                                          cllease__Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Original_Amount__c = 50,
                                          cllease__Principal_Due__c = 50,
                                          cllease__Tax_Due__c = 0,
                                          cllease__Fee_Definition__c = fee[0].Id,
                                          cllease__Tax_Processed__c = 'Tax Calculated'));
        insert charges;
        
        List<clcommon__Consolidated_Invoice__c> invoices = new List<clcommon__Consolidated_Invoice__c>();
        invoices.add(new clcommon__Consolidated_Invoice__c(LS_Contract__c  = contract.Id));
        insert invoices;
        
        bills[0].cllease__Consolidated_Invoice__c = invoices[0].Id;
        bills[1].cllease__Consolidated_Invoice__c = invoices[0].Id;
        update bills;
        charges[0].cllease__Consolidated_Invoice__c = invoices[0].Id;
        charges[1].cllease__Consolidated_Invoice__c = invoices[0].Id;
        update charges;
        
        invoices = [SELECT ID, name FROM clcommon__Consolidated_Invoice__c WHERE id =: invoices[0].Id];
        
        Int_PX_Remit__c	remit = new Int_PX_Remit__c(Committed__c = false,
                                                   	Invoice_Number__c = invoices[0].Name,
                                                   	Account_Num__c = '0123456789',
                                                   	Check_Number__c = 'Test',
                                                   	Date__c = contract.cllease__Contract_Date__c,
                                                    Invoice_Amount__c = 270,
                                                   	Invoice_Amount_Paid__c = 270,
                                                    Line_Data__c = '0123|0123|0123|01123|20190101|PX|270|123|270',
                                                    Record_Number__c = 1,
                                                    Transaction_Amount__c = 270,
                                                    Trans_Source__c = 'PX',
                                                    Transaction_Type__c = 'TEST',
                                                    Remark__c = 'Test');
        insert remit;
        
        remit.Invoice_Number__c = invoices[0].Name;
        remit.Account_Num__c = '0123456789';
        remit.Check_Number__c = 'Test';
        remit.Date__c = contract.cllease__Contract_Date__c;
        remit.Invoice_Amount__c = 270;
        remit.Invoice_Amount_Paid__c = 270;
        remit.Line_Data__c = '0123';
        remit.Record_Number__c = 1;
        remit.Transaction_Amount__c = 270;
        remit.Trans_Source__c = 'PX';
        remit.Transaction_Type__c = 'TEST';
        remit.Remark__c = 'Test';
        
        update remit;
        
        test.startTest();
        	PNCInvoicePaymentProcessing job = new PNCInvoicePaymentProcessing();
			Database.executeBatch(job,200);
        test.stopTest();
    }
    
    @isTest
    public static void testPNCFileCreationJob(){
        List<cllease__GL_Account__c> glAccounts = [SELECT Id FROM cllease__GL_Account__c WHERE NAME IN ('OnAccount', 'Cash') ORDER BY NAME];
        cllease__Lease_Account__c contract = [SELECT Id, Name, cllease__Branch__c, cllease__Contract_Date__c, cllease__Account__c from Cllease__Lease_Account__c limit 1];
        Address__c address = new Address__c(Account__c = contract.cllease__Account__c,
                                             	Address_Line_1__c = 'test', 
                                            	Address_Line_2__c = 'test', 
             									Address_Line_3__c = 'test', 
                                            	Address_Line_4__c = 'test', 
                                           		City__c = 'mm',
                                           		Country__c = 'USA',
                                           		County__c = 'mm',
                                           		Email_Address__c = 'test@sf.com',
                                           		Install_At__c = true,
                                           		Zip_Code__c = '560037',
                                           		Primary_Address__c = true);
        insert address;
        contract.Billing_Address__c = address.Id;
        List<clcommon__Fee_Definition__c> fee = [SELECT Id FROM clcommon__Fee_Definition__c];
        // Creating bill for contract
        List<cllease__Lease_account_Due_Details__c> bills = new List<cllease__Lease_account_Due_Details__c>();
        bills.add(new cllease__Lease_account_Due_Details__c(cllease__Lease_Account__c = contract.Id,
                                                            cllease__Due_Date__c = contract.cllease__Contract_Date__c,
                                                            cllease__Due_Type_Description__c = 'BILL / DUE DATE',
                                                            cllease__Rental_Due_Amount__c = 70,
                                                            cllease__Tax_Due_Amount__c = 0,
                                                            cllease__Total_Due_Amount__c = 70,
                                                            cllease__Status__c = 'Tax Calculated',
                                                            cllease__Transaction_Date__c = contract.cllease__Contract_Date__c));
        bills.add(new cllease__Lease_account_Due_Details__c(cllease__Lease_Account__c = contract.Id,
                                                            cllease__Due_Date__c = contract.cllease__Contract_Date__c,
                                                            cllease__Due_Type_Description__c = 'BILL / DUE DATE',
                                                            cllease__Rental_Due_Amount__c = 100,
                                                            cllease__Tax_Due_Amount__c = 0,
                                                            cllease__Total_Due_Amount__c = 100,
                                                            cllease__Status__c = 'Tax Calculated',
                                                            cllease__Transaction_Date__c = contract.cllease__Contract_Date__c));
        insert bills;
        
        // creating charge for contrat
        List<cllease__Charge__c> charges = new List<cllease__Charge__c>();
        charges.add(new cllease__Charge__c(cllease__Lease_Account__c = contract.Id,
                                          cllease__Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Original_Amount__c = 50,
                                          cllease__Principal_Due__c = 50,
                                          cllease__Tax_Due__c = 0,
                                          cllease__Fee_Definition__c = fee[0].Id,
                                          cllease__Tax_Processed__c = 'Tax Calculated'));
        charges.add(new cllease__Charge__c(cllease__Lease_Account__c = contract.Id,
                                          cllease__Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c,
                                          cllease__Original_Amount__c = 50,
                                          cllease__Principal_Due__c = 50,
                                          cllease__Tax_Due__c = 0,
                                          cllease__Fee_Definition__c = fee[0].Id,
                                          cllease__Tax_Processed__c = 'Tax Calculated'));
        insert charges;
        
        List<clcommon__Consolidated_Invoice__c> invoices = new List<clcommon__Consolidated_Invoice__c>();
        invoices.add(new clcommon__Consolidated_Invoice__c(LS_Contract__c  = contract.Id, 
                                                           File_Generated__c = 'No', 
                                                           Adjustment_Status__c = 'Approved', 
                                                           void_in_pnc__c = false,
                                                           Invoice_Period_End_Date__c = contract.cllease__Contract_Date__c.addMonths(1),
                                                           sent_to_pnc_amount__c = 200,
                                                           clcommon__Due_Date__c = contract.cllease__Contract_Date__c));
        insert invoices;
        bills[0].cllease__Consolidated_Invoice__c = invoices[0].Id;
        bills[1].cllease__Consolidated_Invoice__c = invoices[0].Id;
        update bills;
        charges[0].cllease__Consolidated_Invoice__c = invoices[0].Id;
        charges[1].cllease__Consolidated_Invoice__c = invoices[0].Id;
        update charges;
        
        test.StartTest();
        	PNCFileCreationJob job = new PNCFileCreationJob();
        	Database.executeBatch(job);
        test.StopTest();
    }
    
    @isTest
    public static void testUpdateInvoiceOnOLT(){
        cllease__Lease_Account__c contract = [SELECT Id, Name, cllease__Branch__c, cllease__Contract_Date__c, cllease__Account__c from Cllease__Lease_Account__c limit 1];
        List<cllease__Contract_Equipment__c> equip = [SELECT ID FROM cllease__Contract_Equipment__c WHERE cllease__Contract__c  =: contract.Id];
        
        Account dealer = new Account(Name= 'dealer', Oracle_Vendor_ID__c = '1234567');
        insert dealer;

        cllease__Transaction_Sub_Type__c txnSubType1 = [Select Id, Name From cllease__Transaction_Sub_Type__c 
                                                        Where Name = 'DEALER PAYABLE FUNDING' order by createdDate LIMIT 1];
        
        // 1. Create Dealer Funding Transaction
        clcommon__Disbursement_Transaction__c dealerFundtxn = new clcommon__Disbursement_Transaction__c();
        dealerFundtxn.cllease__Contract__c  = contract.Id;
        dealerFundtxn.Invoice_Number__c         = 'INV110';
        dealerFundtxn.Invoice_Date__c           = contract.cllease__Contract_Date__c;
        dealerFundtxn.clcommon__Transaction_Date__c       = contract.cllease__Contract_Date__c;
        dealerFundtxn.clcommon__Amount__c        = 1000;
        dealerFundtxn.clcommon__GL_Process_Date__c	   = contract.cllease__Contract_Date__c;
        dealerFundtxn.clcommon__Account__c        = dealer.Id;
        dealerFundtxn.clcommon__Transaction_Type__c   = 'DEALER FUNDING';
        dealerFundtxn.AP_Processing_Status__c       = 'New';
        dealerFundtxn.clcommon__GL_Transaction_Flag__c      = true;
        dealerFundtxn.clcommon__Dealer_Payable_Amount__c      = 1000;
        dealerFundtxn.cllease__Transaction_Sub_Type__c = txnSubType1.Id;
        insert dealerFundtxn;
        
        // Insert party
        cllease__Contract_Parties__c party = new cllease__Contract_Parties__c(cllease__Party_Type__c = 'Dealer', 
                                                                              cllease__Party_Account_Name__c = dealer.Id,
                                                                              cllease__Contract__c = contract.Id);
        insert party;
        
        cllease__Dealer_Funding_Detail__c df = new cllease__Dealer_Funding_Detail__c(cllease__Contract__c = contract.Id,
                                                                                    cllease__Contract_Equipment__c = equip[0].Id,
                                                                                    cllease__Dealer__c = party.Id,
                                                                                    cllease__Dealer_Charges__c = 1000,
                                                                                    cllease__dealer_funded__c = true,
                                                                                    cllease__Disbursement_Txn__c = dealerFundtxn.Id);
        insert df;
        update df;
    }
}