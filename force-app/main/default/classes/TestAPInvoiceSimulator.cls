
@isTest 
public  class TestAPInvoiceSimulator {

   
    static TestMethod void Test1() {

        cllease__Lease_Account__c LSContract = TestHelper.createContract();
        
        
        
        Invoice__c inv = new invoice__c();
        inv.LS_Contract__c = LSContract.id;
        inv.Billed_Amount__c 	 = 100.00;
        inv.paid_invoice_amount__c = 0.00;
        insert inv;
        
        cllease__Lease_Account_Due_Details__c bill = new cllease__Lease_Account_Due_Details__c();
		
        bill.cllease__Due_Date__c 			                        = Date.parse('09/1/2016');
        //bill.cllease__Account__ccllease__Late_Charge_Applied__c 	= false;
	    bill.cllease__Lease_Account__c			                    = LSContract.Id;
		bill.cllease__Total_Paid_Amount__c 	                    = 0;
		bill.cllease__Total_Due_Amount__c 		                    = 100.00;
		bill.cllease__Status__c 				                    = 'In Process';	
        bill.Invoiced_In__c                                        =  inv.Id;
												  
		insert bill;
        
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
     	upsert dummyFee;

        cllease__Charge__c charge1 = cllease.TestHelper.createUnpaidCharge(LSContract,dummyFee,100);
        charge1.cllease__Tax_Processed__c     ='Tax Not Calculated';
        charge1.cllease__Original_Amount__c   = 100.00;
        charge1.Tax_Processed__c              = false;
        charge1.Tax_Component__c              = '';
        charge1.Invoiced_In__c                = inv.id;
    
     	upsert charge1;

        adjustment__c  adj = new adjustment__c();
        adj.adjustment_type__c = 'test';
        adj.credit__c = 100.00;
        adj.charge__c = charge1.id;
       // adj.Due_Detail_Line__c = bill.id;
        adj.tax_amount__c = 1.00; 
        adj.equipment__c =null;
        adj.invoice__c = inv.id;

        insert adj;

        List<cllease__Contract_Equipment__c> cEList= new List<cllease__Contract_Equipment__c>();

        cEList = [select id from cllease__Contract_Equipment__c where  cllease__Contract__c =  :LSContract.id ];

        cllease__Due_Detail_Lines__c due = new cllease__Due_Detail_Lines__c();
        due.cllease__bill__c = bill.id;
        due.cllease__Contract_Equipment__c = cEList[0].id;

        due.cllease__Tax_Due_Amount__c = 10.00;
        due.cllease__Rental_Due_Amount__c = 20.00;
        due.cllease__total_due_amount__c = 30.00;
        insert due;
        	
        AP_InvoiceSimulator.getCharges(inv.id);
        AP_InvoiceSimulator.getNewBillsAndCharges(inv.id);
        AP_InvoiceSimulator.getAdjustments(inv.id);
    
    }  

    static TestMethod void Test2() {

        cllease__Lease_Account__c LSContract = TestHelper.createContract();
        
        
        
        Invoice__c inv = new invoice__c();
        inv.LS_Contract__c = LSContract.id;
        inv.Billed_Amount__c 	 = 100.00;
        inv.charged_amount__c = 0.00;
        inv.paid_invoice_amount__c = 0.00;
        insert inv;

        system.debug('***************** ' + inv.balance_due_amount__c);
        
        cllease__Lease_Account_Due_Details__c bill = new cllease__Lease_Account_Due_Details__c();
		
        bill.cllease__Due_Date__c 			                        = Date.parse('09/1/2016');
        //bill.cllease__Account__ccllease__Late_Charge_Applied__c 	= false;
	    bill.cllease__Lease_Account__c			                    = LSContract.Id;
		bill.cllease__Total_Paid_Amount__c 	                    = 0.00;
		bill.cllease__Total_Due_Amount__c 		                    = 100.00;
		bill.cllease__Status__c 				                    = 'In Process';	
        bill.Invoiced_In__c                                        =  inv.Id;
												  
		insert bill;
        
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
     	upsert dummyFee;

        cllease__Charge__c charge1 = cllease.TestHelper.createUnpaidCharge(LSContract,dummyFee,100);
        charge1.cllease__Tax_Processed__c     ='Tax Not Calculated';
        charge1.cllease__Original_Amount__c   = 200.00;
        charge1.Tax_Processed__c              = false;
        charge1.Tax_Component__c              = '';
        charge1.Invoiced_In__c                = inv.id;
    
     	upsert charge1;

        adjustment__c  adj = new adjustment__c();
        adj.adjustment_type__c = 'test';
        adj.credit__c = 100.00;
        adj.charge__c = charge1.id;
       // adj.Due_Detail_Line__c = bill.id;
        adj.tax_amount__c = 1.00; 
        adj.equipment__c =null;
        adj.invoice__c = inv.id;

        insert adj;

        List<cllease__Contract_Equipment__c> cEList= new List<cllease__Contract_Equipment__c>();

        cEList = [select id from cllease__Contract_Equipment__c where  cllease__Contract__c =  :LSContract.id ];

        cllease__Due_Detail_Lines__c due = new cllease__Due_Detail_Lines__c();
        due.cllease__bill__c = bill.id;
        due.cllease__Contract_Equipment__c = cEList[0].id;

        due.cllease__Tax_Due_Amount__c = 10.00;
        due.cllease__Rental_Due_Amount__c = 90.00;
        due.cllease__total_due_amount__c = 100.00;
        insert due;
        	
       
        //addAdjustment(String recordId, String aType,  Decimal credit, String chargeId, String dueId){
        
        Int_PX_Remit__c r = new Int_PX_Remit__c();
 
        r.account_num__c = inv.LS_Contract__r.cllease__Account__r.account_number__c;
        r.check__c = 'CHK100';
        r.committed__c = false;
        r.date__c = date.today();
        r.invoice__c = inv.id;
        r.invoice_number__c = inv.name;
        r.invoice_amount_paid__c = 100.00;
        r.invoice_amount__c = 100.00;
        r.payment_batch_date__c = date.today();
        r.payment_Batch_total_amount__c = 100.00;
        r.record_number__c = 1;
        r.transaction_amount__c = 100.00;
        r.transaction_type__C = 'CHK100';
        r.trans_source__c = 'PX';
        r.remark__c = 'Manual Payment Recorded';
        r.trans_UID__c ='dog1';

        AP_ManualPayment.manualPayment = true;

        insert r;


         AP_ManualPayment.addPayment(string.valueOf(inv.id),'check100',100.00,date.today());


        //addAdjustment(String recordId, String aType,  Decimal credit, String chargeId, String dueId){
        AP_ManualPayment.addAdjustment(string.valueOf(inv.id),'Test',100.00,charge1.id,null);

        PNCUtility.reverseInvoice(inv.id);
    
    }  
      static TestMethod void Test3() {

        cllease__Lease_Account__c LSContract = TestHelper.createContract();
        
        
        
        Invoice__c inv = new invoice__c();
        inv.LS_Contract__c = LSContract.id;
        inv.Billed_Amount__c 	 = 100.00;
        inv.charged_amount__c = 0.00;
        inv.paid_invoice_amount__c = 0.00;
        insert inv;

        system.debug('***************** ' + inv.balance_due_amount__c);
        
        cllease__Lease_Account_Due_Details__c bill = new cllease__Lease_Account_Due_Details__c();
		
        bill.cllease__Due_Date__c 			                        = Date.parse('09/1/2016');
        //bill.cllease__Account__ccllease__Late_Charge_Applied__c 	= false;
	    bill.cllease__Lease_Account__c			                    = LSContract.Id;
		bill.cllease__Total_Paid_Amount__c 	                    = 0.00;
		bill.cllease__Total_Due_Amount__c 		                    = 100.00;
		bill.cllease__Status__c 				                    = 'In Process';	
        bill.Invoiced_In__c                                        =  inv.Id;
												  
		insert bill;
        
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
     	upsert dummyFee;

        cllease__Charge__c charge1 = cllease.TestHelper.createUnpaidCharge(LSContract,dummyFee,100);
        charge1.cllease__Tax_Processed__c     ='Tax Not Calculated';
        charge1.cllease__Original_Amount__c   = 200.00;
        charge1.Tax_Processed__c              = false;
        charge1.Tax_Component__c              = '';
        charge1.Invoiced_In__c                = inv.id;
    
     	upsert charge1;

        adjustment__c  adj = new adjustment__c();
        adj.adjustment_type__c = 'test';
        adj.credit__c = 100.00;
        adj.charge__c = charge1.id;
       // adj.Due_Detail_Line__c = bill.id;
        adj.tax_amount__c = 1.00; 
        adj.equipment__c =null;
        adj.invoice__c = inv.id;

        insert adj;

        List<cllease__Contract_Equipment__c> cEList= new List<cllease__Contract_Equipment__c>();

        cEList = [select id from cllease__Contract_Equipment__c where  cllease__Contract__c =  :LSContract.id ];

        cllease__Due_Detail_Lines__c due = new cllease__Due_Detail_Lines__c();
        due.cllease__bill__c = bill.id;
        due.cllease__Contract_Equipment__c = cEList[0].id;

        due.cllease__Tax_Due_Amount__c = 10.00;
        due.cllease__Rental_Due_Amount__c = 90.00;
        due.cllease__total_due_amount__c = 100.00;
        insert due;
        	
       
        //addAdjustment(String recordId, String aType,  Decimal credit, String chargeId, String dueId){
        
        Int_PX_Remit__c r = new Int_PX_Remit__c();
 
        r.account_num__c = inv.LS_Contract__r.cllease__Account__r.account_number__c;
        r.check__c = 'CHK100';
        r.committed__c = false;
        r.date__c = date.today();
        r.invoice__c = inv.id;
        r.invoice_number__c = inv.name;
        r.invoice_amount_paid__c = 100.00;
        r.invoice_amount__c = 100.00;
        r.payment_batch_date__c = date.today();
        r.payment_Batch_total_amount__c = 100.00;
        r.record_number__c = 1;
        r.transaction_amount__c = 100.00;
        r.transaction_type__C = 'CHK100';
        r.trans_source__c = 'PX';
        r.remark__c = 'Manual Payment Recorded';
        r.trans_UID__c ='dog1';

        AP_ManualPayment.manualPayment = true;

        insert r;

        AP_VoidInvoice.void(inv.id);
        AP_VoidInvoice.getCharges(inv.id,0);
        List<adjustment__c> aList = AP_VoidInvoice.getAdjustments(inv.id,0);
        AP_VoidInvoice.approve(inv.id);
        AP_VoidInvoice.getInvoice(inv.id);
         AP_VoidInvoice.deleteAdj(aList[0]);



       
    }  

}
