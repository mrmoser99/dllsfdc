@isTest
public class TestPNCReversalAndNSF {

    @testSetup
    public static void testDataSetUp(){
        cllease__Lease_Account__c contract1 = TestHelper.createContract();
        //cllease__Lease_Account__c contract2 = TestHelper.createContract();
        cllease__Lease_Product__c product = [SELECT Id, Name From cllease__Lease_Product__c Limit 1];
        cllease__Office_Name__c company = [SELECT Id, Name From cllease__Office_Name__c Where Name = 'Test Office'];
        
        clcommon__Fee_Definition__c  nsfFee = new clcommon__Fee_Definition__c (Name = 'NSF Fees',
                                    clcommon__Active__c = true,
                                    clcommon__Calculation_Method__c = 'FIXED',
                                    clcommon__Amount__c = 100,
                                    clcommon__Amortization_Method__c = null,
                                    clcommon__Amortization_Period__c = null,
                                    clcommon__Class__c = 'Income',
                                    clcommon__Type__c = 'NONE',
                                    clcommon__Maximum_Amount__c = 1000.0,
                                    clcommon__Minimum_Amount__c = 0);
        insert nsfFee;
        
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
        
        // Creating 'ON ACCOUNT PAYMENT MODE' 
        clcommon__Payment_Mode__c onAccPmtMode = new clcommon__Payment_Mode__c(Name = 'ACH');
        insert onAccPmtMode;
    }
    
    public static clcommon__Consolidated_Invoice__c createInvoice(Id contractId){
        clcommon__Consolidated_Invoice__c  invoice = new clcommon__Consolidated_Invoice__c(LS_Contract__c = contractId);
        insert invoice;
        return invoice;
    }
    
    public static Int_PX_NSF__c createNSFRecord(String invoiceName){
        Int_PX_NSF__c pxNsf = new Int_PX_NSF__c(Committed__c = false,
                                                    Date__c = Date.newInstance(2019, 01, 01),
                                                    Invoice_Amount_Paid__c = 100,
                                                    Invoice_Number__c = invoiceName,
                                                    Line_Data__c = 'test',
                                                    NSF_Amount__c = 100,
                                                    Payment_Batch_Date__c = Date.newInstance(2019, 01, 01),
                                                    Payment_Batch_Total_Amount__c = 100,
                                                    Record_Number__c = 1,
                                                    Remark__c = 'test',
                                                    Transaction_Amount__c = 100,
                                                    Transaction_Type__c = 'test',
                                                    Trans_Source__c = 'PX',
                                                    Trans_UID__c = '123456');
        insert pxNsf;
        return pxNsf;
    }
    
    @isTest
    public static void testOnAccountCreationOnExcessPayment(){
        // Common payment mode for cash receipt
        List<clcommon__Payment_Mode__c > commonPaymentModes = [SELECT Id, Name 
                                                            FROM clcommon__Payment_Mode__c 
                                                            LIMIT 100];
        Map<String, Id> commonPaymentModesMap = new Map<String, Id>();                                                    
        for(clcommon__Payment_Mode__c paymentMode : commonPaymentModes) {
            commonPaymentModesMap.put(paymentMode.Name, paymentMode.Id);
        }
        List<clcommon__Fee_Definition__c> fees = [SELECT Id, Name FROM clcommon__Fee_Definition__c];
        System.debug(LoggingLevel.ERROR, '^^^^ fees : ' + fees);
        List<cllease__GL_Account__c> glAccounts = [SELECT Id FROM cllease__GL_Account__c WHERE NAME IN ('OnAccount', 'Cash') ORDER BY NAME];
        cllease__Lease_Account__c contract = [SELECT Id, cllease__Contract_Date__c, cllease__Account__c from Cllease__Lease_Account__c limit 1];
        clcommon__Consolidated_Invoice__c invoice = createInvoice(contract.Id);
        invoice.clcommon__Account__c = contract.cllease__Account__c;
        update invoice;
        invoice = [Select Id, Name, clcommon__Account__c from clcommon__Consolidated_Invoice__c where Id =: invoice.Id];
        List<cllease__Lease_Payment_Transaction__c> lpt = new List<cllease__Lease_Payment_Transaction__c>();
        lpt.add(new cllease__Lease_Payment_Transaction__c(cllease__Contract__c = contract.Id,
                                                          cllease__Transaction_Date__c = contract.cllease__Contract_Date__c ,
                                                          cllease__Transaction_Amount__c = 100,
                                                          cllease__Payment_Mode__c = cllease.GlobalContext.INSTANCE.getPaymentModeByName('Cash').Id,
                                                          Pmt_For_Invoice__c = invoice.Id));
        Insert lpt;
        
        // Creation of cash receipt
        clcommon__Cash_Receipt__c cashReceipt = new clcommon__Cash_Receipt__c();
        cashReceipt.clcommon__Account__c = invoice.clcommon__Account__c;
        cashReceipt.clcommon__Payment_Mode__c = commonPaymentModesMap.get('ACH');
        cashReceipt.clcommon__Receipt_Date__c = contract.cllease__Contract_Date__c;
        cashReceipt.clcommon__Receipt_Amount__c = 100;
        cashReceipt.clcommon__Creation_Date__c  = contract.cllease__Contract_Date__c;
        cashReceipt.clcommon__Unused_Amount__c =  100;
        cashReceipt.clcommon__Receipt_Status__c = 'CREATED';
        insert cashReceipt;
        
        clcommon__Cash_Receipt_Application__c cashApplication = new clcommon__Cash_Receipt_Application__c();
        cashApplication.clcommon__Cash_Receipt__c = cashReceipt.Id;
        cashApplication.clcommon__Creation_Date__c = contract.cllease__Contract_Date__c;
        cashApplication.clcommon__Allocated_Amount__c  = 100;
        cashApplication.clcommon__Receipt_Application_Status__c   = 'CREATED';
        cashApplication.clcommon__Unused_Amount__c  = 100;
        insert cashApplication;
        
        lpt[0].cllease__Cash_Application__c = cashApplication.Id;
        update lpt;
        
        // Clear lpt
        cllease.BulkLeasePaymentAction leasePayment = new cllease.BulkLeasePaymentAction(lpt);
        leasePayment.postPayments();
        List<cllease__Lease_Payment_Transaction__c> pmt = [SELECT cllease__Excess__c, Invoice_Credit_Amount__c FROM cllease__Lease_Payment_Transaction__c WHERE Id=:lpt[0].Id];
        System.assertEquals(lpt[0].cllease__Transaction_Amount__c, pmt[0].Invoice_Credit_Amount__c, 'Mismatch in on Account Amount');
        System.assertEquals(0, pmt[0].cllease__Excess__c, 'Excess amount should be zero');
        
        // Creating PNC return record
        Int_PX_NSF__c pxNsf = createNSFRecord(invoice.Name);
        pxNsf = [Select Id, Name from Int_PX_NSF__c where Id = :pxNsf.Id];
        
        // Run PNC reversal Job
        test.startTest();
        List<String> pxNSFRecords = new List<String>{pxNsf.Name};
        PNCLptReversalAndNSFChargeCreatorJob job = new PNCLptReversalAndNSFChargeCreatorJob(pxNSFRecords);
        Database.executeBatch(job);
        test.stopTest();
        
        lpt = [Select Id, Name, cllease__Reversed__c from cllease__Lease_Payment_Transaction__c where cllease__contract__c =: contract.Id];
        System.debug(LoggingLevel.ERROR, '^^^^ lpt : ' + lpt);
        System.assertEquals(true, lpt[0].cllease__Reversed__c);
        List<Cllease__Charge__c> charges = [Select Id, Name, cllease__Fee_Definition__r.Name from Cllease__Charge__c where cllease__Lease_Account__c = :contract.Id];
        System.assertEquals('NSF Fees', charges[0].cllease__Fee_Definition__r.Name);
        System.debug(LoggingLevel.ERROR, '^^^^ charges : ' + charges[0].cllease__Fee_Definition__r.Name);
    }
}