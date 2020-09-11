@isTest
public class TestCreateFinanceChargesBatch {

    static testmethod void test_func(){
        // A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // Creating Late Fees Charges
        Date dueDate = Date.newInstance(2018, 02, 15); // Charge Due Date
        // Bill Creation
        cllease__Lease_Account_Due_Details__c bill = new cllease__Lease_Account_Due_Details__c();
        bill.cllease__Due_Type_Description__c = 'BILL / DUE DATE';
        bill.cllease__Due_Date__c           = dueDate.addDays(-1);
        bill.cllease__Lease_Account__c      = contract.Id;
        bill.cllease__Rental_Due_Amount__c  = 90.00;
        bill.cllease__Tax_Due_Amount__c     = 10.00;
        bill.cllease__Total_Due_Amount__c   = 100.00;
        bill.cllease__Total_Paid_Amount__c  = 0.00;
        bill.cllease__Status__c             = 'Tax Calculated';
        bill.cllease__Transaction_Date__c   = dueDate;
        insert bill;
        
        clcommon__Fee_Definition__c  finFeeDef   = cllease.Testhelper.createLeaseFee();
        finFeeDef.Name = DLLNewCoConstants.FEE_FINANCE_FEE;
        update finFeeDef;

        clcommon__Fee_Definition__c  lateFeeDef   = cllease.Testhelper.createLeaseFee();
        lateFeeDef.Name = DLLNewCoConstants.FEE_LATE_FEE;
        update lateFeeDef;

        cllease__Charge__c charge = cllease.TestHelper.createUnpaidCharge(contract, lateFeeDef, 100);
        charge.cllease__Tax_Processed__c    = 'Tax Calculated';
        charge.cllease__Date__c             = dueDate;
        charge.cllease__Paid__c             = false;   
        charge.Finance_Fee_created__c       = false; 
        charge.cllease__Dues_Details__c     = bill.Id;
        // Added by CLS on 9/9/2020 to address test failure
        charge.cllease__Lease_Account__c = contract.Id;
        charge.cllease__Fee_Definition__c = lateFeeDef.Id;
        upsert charge;

        // Creating and runnning the Batch jobs for Invoice Consolidation and PNC File Generation
        System.Test.startTest();
            List<String> contractNames = new List<String>{contract.Name};
            CreateFinanceChargesBatch job = new CreateFinanceChargesBatch(contractNames);
            Database.executeBatch(job);
        System.Test.stopTest();

        cllease__Charge__c financeCharge = [Select Id, cllease__Original_Amount__c, cllease__Total_Due_Amount__c
                                                From cllease__Charge__c
                                                Where cllease__Fee_Definition__r.Name =: DLLNewCoConstants.FEE_LATE_FEE];
        //System.assertEquals(200.00, financeCharge.cllease__Total_Due_Amount__c , 'Mismatch in Finance Charge Amount Generation.');
    }

    static testmethod void test_func2(){
        // A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // Creating Late Fees Charges
        Date dueDate = Date.newInstance(2018, 02, 15); // Charge Due Date

        clcommon__Fee_Definition__c  lateFeeDef   = cllease.Testhelper.createLeaseFee();
        lateFeeDef.Name = DLLNewCoConstants.FEE_LATE_FEE;
        update lateFeeDef;

        cllease__Charge__c charge = cllease.TestHelper.createUnpaidCharge(contract, lateFeeDef, 100);
        charge.cllease__Tax_Processed__c    = 'Tax Calculated';
        charge.cllease__Date__c             = dueDate;
        charge.cllease__Paid__c             = false;
        charge.Finance_Fee_created__c       = false; 
        // Added by CLS on 9/9/2020 to address test failure
        charge.cllease__Lease_Account__c = contract.Id;
        upsert charge;

        // Creating and runnning the Batch jobs for Invoice Consolidation and PNC File Generation
        System.Test.startTest();
            CreateFinanceChargesBatch job = new CreateFinanceChargesBatch();
            Database.executeBatch(job);
        System.Test.stopTest();
    }
}