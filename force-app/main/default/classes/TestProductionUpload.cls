@isTest
public class TestProductionUpload {
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
        
        // 5. Insert payment mode
        clcommon__Payment_Mode__c  paymentMode = new clcommon__Payment_Mode__c (Name = 'CASH');
        insert paymentMode;
    }
}