@isTest
public class TestPaymentDLLChangesEndToEnd {
    @testSetup
    public static void testDataSetUp(){
        cllease__Lease_Account__c contract = TestHelper.createContract();
        cllease__Lease_Product__c product = [SELECT Id, Name From cllease__Lease_Product__c Limit 1];
        cllease__Office_Name__c company = [SELECT Id, Name From cllease__Office_Name__c Where Name = 'Test Office'];
        
        // Accounting setup for onAccount
        // 1. Creating Gl Accounts
        List<cllease__GL_Account__c> glAccounts = new List<cllease__GL_Account__c>();
        glAccounts.add(new cllease__GL_Account__c (cllease__Account_Code__c  = '12345', Name = 'OnAccount'));
        glAccounts.add(new cllease__GL_Account__c (cllease__Account_Code__c  = '54321', Name = 'Cash'));
        Insert glAccounts;
        
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
            cllease__Credit_GL_Account__c = glAccounts[0].id,
            cllease__Debit_GL_Account__c = glAccounts[1].id, 
            cllease__Transaction_Sub_Type__c = transactionSubTypes.id, 
            cllease__Enabled__c = true);
        Insert accountingLine;
    }
    
    @isTest
    public static void testOnAccountCreationOnExcessPayment(){
        List<cllease__GL_Account__c> glAccounts = [SELECT Id FROM cllease__GL_Account__c WHERE NAME IN ('OnAccount', 'Cash') ORDER BY NAME];
        cllease__Lease_Account__c contract = [SELECT Id, cllease__Contract_Date__c from Cllease__Lease_Account__c limit 1];
        List<cllease__Lease_Payment_Transaction__c> lpt = new List<cllease__Lease_Payment_Transaction__c>();
        lpt.add(new cllease__Lease_Payment_Transaction__c(cllease__Contract__c = contract.Id,
                                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c ,
                                                          cllease__Transaction_Amount__c = 100,
                                                          cllease__Payment_Mode__c = cllease.GlobalContext.INSTANCE.getPaymentModeByName('Cash').Id));
        Insert lpt;
        cllease.BulkLeasePaymentAction leasePayment = new cllease.BulkLeasePaymentAction(lpt);
        leasePayment.postPayments();
        List<cllease__Lease_Payment_Transaction__c> pmt = [SELECT cllease__Excess__c, Invoice_Credit_Amount__c FROM cllease__Lease_Payment_Transaction__c WHERE Id=:lpt[0].Id];
        System.assertEquals(lpt[0].cllease__Transaction_Amount__c, pmt[0].Invoice_Credit_Amount__c, 'Mismatch in on Account Amount');
        System.assertEquals(0, pmt[0].cllease__Excess__c, 'Excess amount should be zero');
        List<cllease__Lease_Payment_Detail__c> pmtDetails = [SELECT ID FROM cllease__Lease_Payment_Detail__c WHERE cllease__Payment_Transaction__c =: lpt[0].Id];
        System.assertEquals(0, pmtDetails.size(), 'No LPD should be there as we stopped creating excess lpd and there are no outstanding in the contract');
        List<cllease__Invoice_Credit__c> invoiceList = [SELECT ID,
                                                        Name,
                                                        cllease__Original_Credit_Amount__c,
                                                        cllease__Credit_Balance__c,
                                                        cllease__Contract__c,
                                                        Payment_Transaction__c,
                                                        cllease__Status__c
                                                        FROM cllease__Invoice_Credit__c
                                                        WHERE cllease__Contract__c =: contract.Id];
        System.assertEquals(1, invoiceList.Size(), 'Issue seen in invoice creation for an excess lpd');
        System.assertEquals(lpt[0].Id, invoiceList[0].Payment_Transaction__c, 'Invoice not mapped to the current contract');
        System.assertEquals(lpt[0].cllease__Transaction_Amount__c, invoiceList[0].cllease__Original_Credit_Amount__c, 'Invoice amount is not equal to lpt transaction amount');
        System.assertEquals('Unapplied', invoiceList[0].cllease__Status__c, 'Invoice amount is not equal to lpt transaction amount');
    }
    
    @isTest
    public static void testOnAccountCreationOnExcessPaymentReversal(){
        List<cllease__GL_Account__c> glAccounts = [SELECT Id FROM cllease__GL_Account__c WHERE NAME IN ('OnAccount', 'Cash') ORDER BY NAME];
        cllease__Lease_Account__c contract = [SELECT Id, cllease__Contract_Date__c from Cllease__Lease_Account__c limit 1];
        List<cllease__Lease_Payment_Transaction__c> lpt = new List<cllease__Lease_Payment_Transaction__c>();
        lpt.add(new cllease__Lease_Payment_Transaction__c(cllease__Contract__c = contract.Id,
                                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c ,
                                                          cllease__Transaction_Amount__c = 100,
                                                          cllease__Payment_Mode__c = cllease.GlobalContext.INSTANCE.getPaymentModeByName('Cash').Id));
        Insert lpt;
        cllease.BulkLeasePaymentAction leasePayment = new cllease.BulkLeasePaymentAction(lpt);
        leasePayment.postPayments();
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
        List<cllease__Invoice_Credit__c> invoiceList = [SELECT ID,
                                                        Name,
                                                        cllease__Original_Credit_Amount__c,
                                                        cllease__Credit_Balance__c,
                                                        cllease__Contract__c,
                                                        Payment_Transaction__c,
                                                        cllease__Status__c
                                                        FROM cllease__Invoice_Credit__c
                                                        WHERE cllease__Contract__c =: contract.Id];
        System.assertEquals('Cancelled', invoiceList[0].cllease__Status__c, 'Invoice should be cancelled as the payment is reversed');
        List<cllease__Lease_Payment_Transaction__c> pmt = [SELECT cllease__Excess__c, Invoice_Credit_Amount__c, cllease__Reversed__c FROM cllease__Lease_Payment_Transaction__c WHERE Id=:lpt[0].Id];
        System.assertEquals(true, pmt[0].cllease__Reversed__c, 'Payment should be reversed');
    }
    
    @isTest
    public static void testOnAccountCreationManual(){
        List<cllease__GL_Account__c> glAccounts = [SELECT Id FROM cllease__GL_Account__c WHERE NAME IN ('OnAccount', 'Cash') ORDER BY NAME];
        cllease__Lease_Account__c contract = [SELECT Id, cllease__Contract_Date__c from Cllease__Lease_Account__c limit 1];
        List<cllease__Lease_Payment_Transaction__c> lpt = new List<cllease__Lease_Payment_Transaction__c>();
        lpt.add(new cllease__Lease_Payment_Transaction__c(cllease__Contract__c = contract.Id,
                                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c ,
                                                          cllease__Transaction_Amount__c = 100,
                                                          cllease__Payment_Mode__c = cllease.GlobalContext.INSTANCE.getPaymentModeByName('Cash').Id));
        Insert lpt;
        cllease.BulkLeasePaymentAction leasePayment = new cllease.BulkLeasePaymentAction(lpt);
        leasePayment.postPayments();
        lpt = [Select Id, Name from cllease__Lease_Payment_Transaction__c where id =: lpt[0].id];
        cllease__Invoice_Credit__c invoiceList = new cllease__Invoice_Credit__c(
                                                        cllease__Original_Credit_Amount__c = 100,
                                                        cllease__Contract__c = contract.Id,
                                                        cllease__Status__c = 'Unapplied',
                                                        cllease__Comments__c = lpt[0].Name);
        Insert invoiceList;
        List<cllease__Invoice_Credit__c> invoices = [SELECT ID,
                                                       Name,
                                                       cllease__Original_Credit_Amount__c,
                                                       cllease__Credit_Balance__c,
                                                       cllease__Contract__c,
                                                       Payment_Transaction__c,
                                                       cllease__Status__c
                                                       FROM cllease__Invoice_Credit__c
                                                       WHERE cllease__Contract__c =: contract.Id];
        System.assertEquals(lpt[0].Id, invoices[0].Payment_Transaction__c, 'LPT Id should have populated in the OnAccount');
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
}