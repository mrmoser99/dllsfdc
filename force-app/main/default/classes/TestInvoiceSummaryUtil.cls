/**
 * Author: Cloud Lending Solutions
 * Description: Following class is test class for InvoiceSummaryUtil  

 9/19/19 - MRM changed ref to invoiced int to consolidated_invoice
 **/
@isTest
public class TestInvoiceSummaryUtil {
    static TestMethod void InvoiceSummaryUtil() {
        
        cllease__Lease_Account__c LSContract = TestHelper.createContract();
         set<id> setinv = new set<id>();
         clcommon__Consolidated_Invoice__c inv = new clcommon__Consolidated_Invoice__c();
          inv.LS_Contract__c = LSContract.id;
          setinv.add(inv.id);
         
           insert inv;
           system.debug('Invoice ID::::'+inv.id);
          cllease__Lease_Account_Due_Details__c bill = new cllease__Lease_Account_Due_Details__c();
		
        	 bill.cllease__Due_Date__c 			                        = Date.parse('09/1/2016');
             //bill.cllease__Account__ccllease__Late_Charge_Applied__c 	= false;
	         bill.cllease__Lease_Account__c			                    = LSContract.Id;
			 bill.cllease__Total_Paid_Amount__c 	                    = 49.00;
			 bill.cllease__Total_Due_Amount__c 		                    = 100.00;
			 bill.cllease__Status__c 				                    = 'In Process';	
        	 bill.cllease__Consolidated_Invoice__c                      =  inv.Id;
												  
		     insert bill;
        
        	clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
     		upsert dummyFee;
        	cllease__Charge__c charge1 = cllease.TestHelper.createUnpaidCharge(LSContract,dummyFee,100);
             charge1.cllease__Tax_Processed__c     ='Tax Not Calculated';
             charge1.cllease__Original_Amount__c   = 200.00;
             charge1.Tax_Processed__c              = false;
             charge1.Tax_Component__c              = '';
             charge1.cllease__Consolidated_Invoice__c  = inv.id;
    
     		 upsert charge1;
        	
        
        
    }
    
    static TestMethod void InvoiceSummaryUtil1() {
        
       
        
        cllease__Lease_Account__c LSContract = TestHelper.createContract();
         set<id> setinv = new set<id>();
         clcommon__Consolidated_Invoice__c inv = new clcommon__Consolidated_Invoice__c();
          inv.LS_Contract__c = LSContract.id;
          inv.Billed_Amount__c = 3.4544; 
          setinv.add(inv.id);
        	
           insert inv;
       
           system.debug('Invoice ID::::'+inv.id);
          cllease__Lease_Account_Due_Details__c bill = new cllease__Lease_Account_Due_Details__c();
		
        	 bill.cllease__Due_Date__c 			                        = Date.parse('09/1/2016');
             //bill.cllease__Account__ccllease__Late_Charge_Applied__c 	= false;
	         bill.cllease__Lease_Account__c			                    = LSContract.Id;
			 bill.cllease__Total_Paid_Amount__c 	                    = 49.00;
			 bill.cllease__Total_Due_Amount__c 		                    = 100.00;
			 bill.cllease__Status__c 				                    = 'In Process';	
        	 bill.cllease__Consolidated_Invoice__c                                        =  inv.Id;
												  
		     //insert bill;
        
        	clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
     		//upsert dummyFee;
        	cllease__Charge__c charge1 = cllease.TestHelper.createUnpaidCharge(LSContract,dummyFee,100);
             charge1.cllease__Tax_Processed__c     ='Tax Not Calculated';
             charge1.cllease__Original_Amount__c   = 200.00;
             charge1.Tax_Processed__c              = false;
             charge1.Tax_Component__c              = '';
             charge1.cllease__Consolidated_Invoice__c                = inv.id;
    
     		 //upsert charge1;
        
        	InvoiceSummaryUtil.InvoiceSummary(setinv);
             
        
    }


}