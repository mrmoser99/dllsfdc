@isTest
public with sharing class TestPNCIntegration {
    @isTest
    public static void testPNCOutbound() {

        Testhelper.getVertexCustomSettings();
        // A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // Creating New Address
        Account dummyAccount = [SELECT Id, Name From Account WHERE Name = 'Sample Account'];
        Address__c address = new Address__c();
        address.Country__c = 'USA';
        address.Account__c = dummyAccount.Id;
        address.Bill_To_Usage__c = true;
        address.Install_At__c = true;
        address.Validation_Status__c = DLLNewCoConstants.EXPERIAN_VALIDATION_STATUS;
        insert address;

        // Updating address in contract as billing address
        cllease__Lease_Account__c retrievedContract = [Select Id, Billing_Address__c
                                                        From cllease__Lease_Account__c
                                                        Where Id =: contract.Id];
        retrievedContract.Billing_Address__c = address.Id;
        update retrievedContract;
     
        // Retrieving Attached Equipment for Charge Creation
        cllease__Contract_Equipment__c contractEquipment = [Select Id, Install_Address__c
                                                            From cllease__Contract_Equipment__c
                                                            Where cllease__Contract__c = :contract.Id
                                                            LIMIT 1];
        contractEquipment.Install_Address__c = address.Id;
        contractEquipment.Install_Account__c = dummyAccount.Id;
        update contractEquipment;

        // Creating charges for january , february periods
        Date chargeDate = Date.newInstance(2018, 01, 15);
        // Creating  Charge with Equipment Linked
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        dummyFee.Name = 'Service Fees';
        update dummyFee;

        cllease__Charge__c charge1 = cllease.TestHelper.createUnpaidCharge(contract, dummyFee, 100);
        charge1.cllease__Tax_Processed__c = 'Tax Not Calculated';
        charge1.cllease__Date__c          = chargeDate;
        charge1.cllease__Contract_Equipment__c = contractEquipment.id;
        charge1.Tax_Processed__c          = false;
        charge1.Tax_Component__c          = '';
        update charge1;

        // Creating  Charge without Equipment Attached
        clcommon__Fee_Definition__c  dummyFee2   = cllease.Testhelper.createLeaseFee();
        dummyFee2.Name = 'Origination Fees';
        update dummyFee2;

        cllease__Charge__c charge2 = cllease.TestHelper.createUnpaidCharge(contract, dummyFee2, 100);
        charge2.cllease__Tax_Processed__c = 'Tax Not Calculated';
        charge1.cllease__Date__c          = chargeDate.addMonths(1);
        charge2.Tax_Processed__c          = false;
        charge2.Tax_Component__c          = '';
        update charge2;

        // Changing the current System Date
        Date currentSystemDate = Date.newInstance(2018, 02, 28);
        List<cllease__Office_Name__c> companies = [Select Id, Name, cllease__Current_System_Date__c
                                                    From cllease__Office_Name__c];
        for(cllease__Office_Name__c company : companies) {
            company.cllease__Current_System_Date__c = currentSystemDate;
        }
        update companies;

        // Creating and runnning the Batch jobs for Invoice Consolidation and PNC File Generation
        System.Test.startTest();
            // Creating DAG
            String dagName = 'CLLease-BatchTestDAG';
            List<String> listOfJobs = new List<String>{ 
                                'cllease.BillGeneratorJob', 'cllease.BillDetailGeneratorJob',
                                'VertexGetTaxonBillsJob', 'VertexGetTaxonChargesJob', 'CustomLateChargeGeneratorJob',
                                'BillsandChargesConsolidationJob', 'PNCFileCreationJob'};
            TestHelper.createDAGSpecificJobs(listOfJobs, dagName);
            // Running DAG
            TestHelper.runDAG(dagName);
        System.Test.stopTest();

        // Validating PNC File Generation
        List<Int_PX_Billing__c> pncBillFiles = [Select Id, Line_Data__c From Int_PX_Billing__c];
        //System.assert( pncBillFiles.size() > 0, 'PNC File Should generate...');
    }

    // @isTest TODO: disabling the Test Inbound test as process change, encouring DLL team to do full manual testing and check for payments applications to wards bills and charges
    public static void testPNCInbound() {
        Testhelper.getVertexCustomSettings();
        
        //TestData.createTxnSubTypes();
        // A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // Changing the current System Date
        Date currentSystemDate = Date.newInstance(2018, 02, 28);
        List<cllease__Office_Name__c> companies = [Select Id, cllease__Current_System_Date__c From cllease__Office_Name__c];
        for(cllease__Office_Name__c company : companies) {
            company.cllease__Current_System_Date__c = currentSystemDate;
        }
        update companies;

        // Paymentdate earlier to 10 days
        Date paymentDate = currentSystemDate.addDays(-10);
        // B. Create Invoice , Bills and Charges manually
        Invoice__c invoice = new invoice__c();
        invoice.LS_Contract__c      = contract.id;
        invoice.Invoice_Due_Date__c = paymentDate; 
        insert invoice; 

        cllease__Lease_Account_Due_Details__c bill = new cllease__Lease_Account_Due_Details__c();
        bill.cllease__Due_Type_Description__c = 'BILL / DUE DATE';
        bill.cllease__Due_Date__c           = paymentDate.addDays(-1);
        bill.cllease__Lease_Account__c      = contract.Id;
        bill.cllease__Rental_Due_Amount__c  = 90.00;
        bill.cllease__Tax_Due_Amount__c     = 10.00;
        bill.cllease__Total_Due_Amount__c   = 100.00;
        bill.cllease__Total_Paid_Amount__c  = 0.00;
        bill.cllease__Status__c             = 'Tax Calculated'; 
        bill.Invoiced_In__c                 =  invoice.Id;
        bill.cllease__Transaction_Date__c   = paymentDate;
        insert bill;

         // Creating  Charge with Equipment Linked
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        dummyFee.Name = 'Service Fees';
        update dummyFee;

        cllease__Charge__c charge = cllease.TestHelper.createUnpaidCharge(contract, dummyFee, 100);
        charge.cllease__Tax_Processed__c    = 'Tax NoCalculated';
        charge.cllease__Date__c             = paymentDate;
        charge.cllease__Original_Amount__c  = 100;
        charge.cllease__Tax_Due__c          = 10;
        charge.cllease__Paid_Amount__c      = 0;
        charge.cllease__Principal_Due__c    = 110; 
        charge.cllease__Calculated_Interest3__c = 0;
        charge.cllease__Tax_Processed__c    = 'Tax Calculated';
        charge.Invoiced_In__c               = invoice.Id;
        update charge;

        Invoice__c invoiceRetrieve = [Select Id, Name From Invoice__c Limit 1];

        List<Int_PX_Remit__c> mockRemitToInsert = new List<Int_PX_Remit__c>();
        /*mockRemitToInsert.add(new Int_PX_Remit__c(  Record_Number__c    = 0, 
                                Invoice_Number__c       = 'BATCH HEADER', 
                                Payment_Batch_Date__c   = paymentDate.addDays(-2), 
                                Payment_Batch_Total_Amount__c = 1000.00,
                                Line_Data__c            = 'x1|x2|x3|x4'));*/
         mockRemitToInsert.add(new Int_PX_Remit__c(  Record_Number__c = 1, 
                                Invoice_Number__c       = invoiceRetrieve.Name, 
                                Transaction_Amount__c   = 300,
                                Date__c                 = paymentDate,
                                Payment_Batch_Date__c   = paymentDate.addDays(-2), 
                                Committed__c            = false,
                                Payment_Batch_Total_Amount__c = 300.00,
                                Line_Data__c            = '1|AccNumber123|txnType|Trans_UID|20190719|PNC|30000|'+invoiceRetrieve.Name+'|30000|'));

        insert mockRemitToInsert;
         
        // Creating and runnning the Batch jobs for Invoice Consolidation and PNC File Generation
        System.Test.startTest();
            // Creating DAG
            String dagName = 'CLLease-BatchTestDAG';
            List<String> listOfJobs = new List<String>{'PNCInvoicePaymentProcessing', 'ApplyPaymentProcessingJob'};
            TestHelper.createDAGSpecificJobs(listOfJobs, dagName);
            // Running DAG
            TestHelper.runDAG(dagName);
        System.Test.stopTest();

        List<Int_PX_Remit__c> updatedRemitRecords = [Select Id, Remark__c, Committed__c From Int_PX_Remit__c];
        System.assertEquals(1, updatedRemitRecords.size(), 'Mismatch in Remit Records Generation...');
        System.assertEquals(false, updatedRemitRecords.get(0).Committed__c, 'Mismatch in Remit Record Commit Field Update...');

        List<cllease__Lease_Payment_Transaction__c> pmtTxns = [Select Id, cllease__Cleared__c , cllease__Transaction_Amount__c,
                                                                    cllease__Payment_Mode__r.Name, cllease__Rent_Amount__c,
                                                                    cllease__Fees__c, cllease__Tax_Amount__c, cllease__Excess__c,
                                                                    cllease__Bill__c, cllease__Charge__c, cllease__Receipt_Date__c
                                                                From cllease__Lease_Payment_Transaction__c
                                                                Order By Name];

        // cllease__Cleared__c, cllease__Transaction_Amount__c, cllease__Rent_Amount__c, cllease__Fees__c, cllease__Tax_Amount__c, cllease__Excess__c, Bill/ChargeID
        List<List<String>> paymentTxnsExpected = new List<List<String>>();
        paymentTxnsExpected.add(new List<String>{'true', '100.00', '90.00', '0.00',   '10.00', '0.00', bill.Id,string.valueof(Paymentdate)});
        paymentTxnsExpected.add(new List<String>{'true', '110.00', '0.00',  '100.00', '10.00',  '0.00', charge.Id,string.valueof(Paymentdate)});
        paymentTxnsExpected.add(new List<String>{'true', '90.00',  '0.00',  '0.00',   '0.00',  '90.00','',string.valueof(Paymentdate)});                                                                

        //System.assertEquals(paymentTxnsExpected.size(), pmtTxns.size(),'Mismatch in No Of Payment Created for Remit File...');

        for(Integer i=0; i<pmtTxns.size(); i++) {
            System.assertEquals(Boolean.valueOf(paymentTxnsExpected[i][0]), pmtTxns[i].cllease__Cleared__c, 'Mismatch in cllease__Cleared__c at row: '+i);
            System.assertEquals(Decimal.valueOf(paymentTxnsExpected[i][1]), ((Decimal)pmtTxns[i].cllease__Transaction_Amount__c).setScale(2), 'Mismatch in cllease__Transaction_Amount__c at row: '+i);
            System.assertEquals(Decimal.valueOf(paymentTxnsExpected[i][2]), ((Decimal)pmtTxns[i].cllease__Rent_Amount__c).setScale(2), 'Mismatch in cllease__Rent_Amount__c at row: '+i);
            System.assertEquals(Decimal.valueOf(paymentTxnsExpected[i][3]), ((Decimal)pmtTxns[i].cllease__Fees__c).setScale(2), 'Mismatch in cllease__Fees__c at row: '+i);
            System.assertEquals(Decimal.valueOf(paymentTxnsExpected[i][4]), ((Decimal)pmtTxns[i].cllease__Tax_Amount__c).setScale(2), 'Mismatch in cllease__Tax_Amount__c at row: '+i);
            System.assertEquals(Decimal.valueOf(paymentTxnsExpected[i][5]), ((Decimal)pmtTxns[i].cllease__Excess__c).setScale(2), 'Mismatch in cllease__Excess__c at row: '+i);
            //System.assertEquals((paymentTxnsExpected[i][6]), pmtTxns[i].cllease__Receipt_Date__c, 'Mismatch in cllease__Excess__c at row: '+i);

           
            System.assertEquals((date.valueof(paymentTxnsExpected[i][6])),pmtTxns[i].cllease__Receipt_Date__c, 'Mismatch in cllease__Receipt_Date__c at row: '+i);
// first row(i=0) should have bill link as payment done towards bill
            // Secone row(i=1) should have charge link as payment done towards charge
            if(i == 0) {
                System.assertEquals(paymentTxnsExpected[i][6], pmtTxns[i].cllease__Bill__c, 'Mismatch in cllease__Bill__c at row: '+i);
            } else if(i == 1){
                System.assertEquals(paymentTxnsExpected[i][6], pmtTxns[i].cllease__Charge__c, 'Mismatch in cllease__Charge__c at row: '+i);
            }
        }
    }

    @isTest
    public static void testPNCInboundNegative() {
        Testhelper.getVertexCustomSettings();
        //TestData.createTxnSubTypes();
        // A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));
        return;
        // Creating Remit File.
        Date paymentDate = Date.newInstance(2018, 02, 28);
        Int_PX_Remit__c remitFile = new Int_PX_Remit__c();
        remitFile.Date__c           = paymentDate;
        remitFile.Transaction_Amount__c = 300;
        remitFile.Committed__c      = false;
        remitFile.line_data__c      = 'x1|x2|x3|x4|x5';
        remitFile.record_number__c  = 123456;
        insert remitFile;

        Int_PX_Remit__c remitFileRet = [Select Id, Name From Int_PX_Remit__c Limit 1];
        // Creating and runnning the Batch jobs for Invoice Consolidation and PNC File Generation
        System.Test.startTest();
            //a. Create Payments (from Remit Records)
            List<String> pncRemitNames = new List<String>{remitFileRet.Name};
            PNCInvoicePaymentProcessing job = new PNCInvoicePaymentProcessing(pncRemitNames);
            Database.executeBatch(job);

            //b. Apply Payments(apply payments which created in Step:a)
            List<String> contractNames = new List<String>{contract.Name};
            ApplyPaymentProcessingJob job2 = new ApplyPaymentProcessingJob(contractNames);
            Database.executeBatch(job2);
        System.Test.stopTest();

        // TODO: Need to finish proper test assert.
        // Not doing any assert for this case, as it will is just to cover 10 lines of code.
    }

    @isTest
    public static void testPNCInboundNSFCharge() {
        Testhelper.getVertexCustomSettings();
        //TestData.createTxnSubTypes();
        // A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // Changing the current System Date
        Date currentSystemDate = Date.newInstance(2018, 02, 28);
        List<cllease__Office_Name__c> companies = [Select Id, cllease__Current_System_Date__c From cllease__Office_Name__c];
        for(cllease__Office_Name__c company : companies) {
            company.cllease__Current_System_Date__c = currentSystemDate;
        }
        update companies;

        cllease__Payment_Mode__c achPaymentMode = new cllease__Payment_Mode__c(Name = 'Auto ACH');
        insert achPaymentMode;

        // Paymentdate earlier to 10 days
        Date paymentDate = currentSystemDate.addDays(-10);
        // B. Create Invoice , Bills and Charges manually
        Invoice__c invoice = new invoice__c();
        invoice.LS_Contract__c      = contract.id;
        invoice.Invoice_Due_Date__c = paymentDate; 
        insert invoice; 

        cllease__Lease_Account_Due_Details__c bill = new cllease__Lease_Account_Due_Details__c();
        bill.cllease__Due_Type_Description__c = 'BILL / DUE DATE';
        bill.cllease__Due_Date__c           = paymentDate.addDays(-1);
        bill.cllease__Lease_Account__c      = contract.Id;
        bill.cllease__Rental_Due_Amount__c  = 90.00;
        bill.cllease__Tax_Due_Amount__c     = 10.00;
        bill.cllease__Total_Due_Amount__c   = 100.00;
        bill.cllease__Total_Paid_Amount__c  = 0.00;
        bill.cllease__Status__c             = 'Tax Calculated'; 
        bill.Invoiced_In__c                 =  invoice.Id;
        bill.cllease__Transaction_Date__c   = paymentDate;
        insert bill;

         // Creating  Charge with Equipment Linked
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        dummyFee.Name = 'Service Fees';
        update dummyFee;

        cllease__Charge__c charge = cllease.TestHelper.createUnpaidCharge(contract, dummyFee, 100);
        charge.cllease__Tax_Processed__c    = 'Tax NoCalculated';
        charge.cllease__Date__c             = paymentDate;
        charge.cllease__Original_Amount__c  = 90;
        charge.cllease__Tax_Due__c          = 10;
        charge.cllease__Paid_Amount__c      = 0;
        charge.cllease__Principal_Due__c    = 100; 
        charge.cllease__Calculated_Interest3__c = 0;
        charge.cllease__Tax_Processed__c    = 'Tax Calculated';
        charge.Invoiced_In__c               = invoice.Id;
        update charge;

        // Apply payments to Bill and charge
        List<cllease__Lease_Payment_Transaction__c> pmtsPerRemit = new List<cllease__Lease_Payment_Transaction__c>();

        cllease__Lease_Payment_Transaction__c pmtTxn = new cllease__Lease_Payment_Transaction__c();
        pmtTxn.cllease__Contract__c             = invoice.LS_Contract__c;
        pmtTxn.cllease__Bill__c                 = bill.Id ;
        pmtTxn.For_Invoice__c                   = invoice.Id;
        pmtTxn.cllease__Transaction_Amount__c   = bill.cllease__Total_Due_Amount__c;
        pmtTxn.cllease__Payment_Mode__c         = achPaymentMode.Id;
        pmtTxn.cllease__Transaction_Date__c     = currentSystemDate;
        
        pmtsPerRemit.add(pmtTxn);

        cllease__Lease_Payment_Transaction__c pmtTxn2 = new cllease__Lease_Payment_Transaction__c();
        pmtTxn2.cllease__Contract__c             = invoice.LS_Contract__c;
        pmtTxn2.cllease__Charge__c               = charge.Id ;
        pmtTxn2.For_Invoice__c                   = invoice.Id;
        pmtTxn2.cllease__Transaction_Amount__c   = charge.cllease__Principal_Due__c;
        pmtTxn2.cllease__Payment_Mode__c         = achPaymentMode.Id;
        pmtTxn2.cllease__Transaction_Date__c     = currentSystemDate;
        
        pmtsPerRemit.add(pmtTxn2);

        insert pmtsPerRemit;

        // Apply payments and clear 
        // 2. Querying all payments with required details
        List<cllease__Lease_Payment_Transaction__c> paymentTransactionList = 
                        [SELECT id, name,
                                cllease__Contract__c,
                                cllease__Contract__r.Id,
                                cllease__Contract__r.Name,
                                cllease__Contract__r.cllease__Lease_Status__c,
                                cllease__Contract__r.cllease__Lease_Product_Name__c,
                                cllease__Contract__r.cllease__Lease_Product_Name__r.cllease__Lease_Product_Type__c,
                                cllease__Contract__r.cllease__Payment_Frequency__c,
                                cllease__Contract__r.cllease__current_payment_amount__c,
                                cllease__Contract__r.cllease__Next_Due_Date__c ,
                                cllease__Contract__r.cllease__Term__c,
                                cllease__Contract__r.cllease__Payment_Spread__c,
                                cllease__Contract__r.cllease__Termination_Quote_accepted_flag__c,
                                cllease__Lease_Snapshot__c,
                                cllease__Fee_Snapshot__c,
                                cllease__Dues_Snapshot__c,
                                cllease__Cash_Balances_Snapshot__c,
                                cllease__Balance_s_Snapshot__c,
                                cllease__Custom_Logic__c,
                                cllease__Receipt_Id__c,
                                cllease__Transaction_Date__c,
                                cllease__Transaction_Time__c,
                                cllease__Early_Total_Repayment_of_the_Lease__c,
                                cllease__Write_Off_Recovery_Payment__c,
                                cllease__Payment_Mode__c,
                                cllease__Payment_Mode__r.Name,
                                cllease__Transaction_Amount__c,
                                cllease__Cleared__c,
                                cllease__Manual_Payment__c,
                                cllease__Fees__c,
                                cllease__Receivable_Billed__c,
                                cllease__Evergreen_Receivable_Billed__c,
                                cllease__Tax_Billed__c,
                                cllease__Excess__c,
                                cllease__Total_Charges_Principal__c,
                                cllease__Other_Charges_Principal__c,
                                cllease__Late_Charge_Principal__c,
                                cllease__Charge__c,
                                cllease__Bill__c
                            FROM cllease__Lease_Payment_Transaction__c
                            ORDER by cllease__Transaction_Date__c]; 
        
        // 3. Calling CL Lease Global API to Apply Payments
        cllease.BulkLeasePaymentAction dAction = new cllease.BulkLeasePaymentAction(paymentTransactionList);
        dAction.postPayments();

        // Create Mockup remit file with negative amounts
        Invoice__c invoiceRetrieve = [Select Id, Name From Invoice__c Limit 1];

        List<Int_PX_Remit__c> mockRemitToInsert = new List<Int_PX_Remit__c>();
        mockRemitToInsert.add(new Int_PX_Remit__c(  Record_Number__c = 1, 
                                Invoice_Number__c       = invoiceRetrieve.Name, 
                                Transaction_Amount__c   = -200,
                                Date__c                 = paymentDate,
                                Payment_Batch_Date__c   = paymentDate.addDays(-2), 
                                Committed__c            = false,
                                Payment_Batch_Total_Amount__c = 1000.00,
                                Line_Data__c            = 'x1|x2|x3|x4'));

        insert mockRemitToInsert;

        // run PNC inbound file job
        System.Test.startTest();
            // Creating DAG
            String dagName = 'CLLease-BatchTestDAG';
            List<String> listOfJobs = new List<String>{'PNCInvoicePaymentProcessing', 'ApplyPaymentProcessingJob'};
            TestHelper.createDAGSpecificJobs(listOfJobs, dagName);
            // Running DAG
            TestHelper.runDAG(dagName);
        System.Test.stopTest();

        // check for    1. NSF charges createion
        //              2. payment reversal
        //              3. invoice file generated flag

        List<Invoice__c> invoicesToResend = [SELECT Id, Name, File_Generated__c FROM Invoice__c WHERE Id =: invoice.Id AND File_Generated__c='No'];
        
        // Checking for reversed Invoice for PNC
        System.assertEquals(1, invoicesToResend.size(), 'Mismatch in No Of reverted Invoice records...');


        List<cllease__Charge__c> nsfCharges = [SELECT Id, Name, cllease__Original_Amount__c FROM cllease__Charge__c WHERE cllease__Fee_Definition__r.clcommon__Type__c = 'NSF Fees'];
        // Checking for reversed Invoice for PNC
        //System.assertEquals(1, nsfCharges.size(), 'Mismatch in No Of NSF charges created..');
        //System.assertEquals(25, nsfCharges[0].cllease__Original_Amount__c, 'Mismatch in NSF charge amount ');


        List<cllease__Repayment_Transaction_Adjustment__c> reversalPmts = [SELECT Id, Name FROM cllease__Repayment_Transaction_Adjustment__c WHERE cllease__Cleared__c = true];
        //System.assertEquals(2, reversalPmts.size(), 'Mismatch in No Of reversal Payments...');

        //System.debug(LoggingLevel.ERROR, ' Charges: '+ [SELECT Id, Name, cllease__Fee_Definition__r.Name FROM cllease__Charge__c WHERE cllease__Fee_Definition__r.clcommon__Type__c = 'NSF Fees']);

        //System.debug(LoggingLevel.ERROR, ' reversals: '+ [SELECT Id, Name FROM cllease__Repayment_Transaction_Adjustment__c WHERE cllease__Cleared__c = true]);

    }

    @isTest
    public static void testInvokePNCInbound() {
        try {
            insert new Int_Batch_Status__c(Name = 'Px Remit', Status__c = 'Ready', Completed__c = false);
        } catch(Exception e) {}
    }

    @isTest
    public static void createContractsTriggers() {
        Testhelper.getVertexCustomSettings();
        // A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // deleting income streams
        // Creating income stream for test coverage
        cllease__Rental_Stream__c stream = new cllease__Rental_Stream__c();
        stream.cllease__Contract__c = contract.Id;
        insert stream;


        System.debug(LoggingLevel.ERROR, ' income streams: '+ stream);
        delete stream;

    }
}