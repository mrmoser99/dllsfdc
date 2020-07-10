/* 9/19/19 - MRM Changed reference to invoiced_in__c */
@isTest
public class CongaGenerateInvoiceTest {
    

    static TestMethod void CongaGenerateInvoice() {
          CongaURL_Settings__c cong = new CongaURL_Settings__c();
          cong.States_Prior_to_Maturity_120__c    = 'WI,NY';
          cong.States_Prior_to_Maturity_RI_120__c = 'RI';
          cong.Days_Prior_to_Maturity_120__c      = 120;
          cong.Days_Prior_to_Maturity_60__c       = 60;
          cong.InvoiceEverGreenTempID__c          = 'a2m0v0000001uH8';
          insert cong;
          System.debug('*****CongaURL_Settings__c******'+CongaURL_Settings__c.getInstance().InvoiceEverGreenTempID__c);
          cllease__Lease_Account__c LSContract = TestHelper.createContract();
        
          system.debug('Contact ID::::'+LSContract.id);
           // Creating New Address
          Account dummyAccount = [SELECT Id, Name From Account WHERE Name = 'Sample Account'];
          Address__c address = new Address__c();
          address.Country__c = 'USA';
          address.Account__c = dummyAccount.Id;
          address.state__c   = 'RI'; 
          address.Bill_To_Usage__c = true;
          address.Install_At__c = true;
          address.Validation_Status__c = DLLNewCoConstants.EXPERIAN_VALIDATION_STATUS;
          insert address;

          Date currentDate = Date.newInstance(2018, 01, 01);
         
          cllease__Lease_Account__c ls = [select id,name,cllease__Account__r.id from cllease__Lease_Account__c where id=:LSContract.id];
          system.debug('Accout ID::::'+ls.cllease__Account__r.id);
          cllease__Lease_Account__c leac = new cllease__Lease_Account__c();
          leac.cllease__contract_date__c = currentDate;
          leac.cllease__Dealer_Payment_Date__c =  leac.cllease__contract_date__c.addDays(30);
          leac.id = LSContract.id;
          leac.cllease__Maturity_Date__c = leac.cllease__contract_date__c.addDays(1460);
          leac.cllease__Lease_Status__c = 'Active - Good Standing';
          Update leac;
          cllease__Lease_Account__c retrievedContract = [Select Id,Billing_Address__c
                                                        From cllease__Lease_Account__c
                                                        Where Id =: LSContract.id];
        retrievedContract.Billing_Address__c = address.Id;
        update retrievedContract;
     
        
        
          clcommon__Consolidated_Invoice__c inv = new clcommon__Consolidated_Invoice__c();
          inv.LS_Contract__c = LSContract.id;
          
          insert inv;
           system.debug('Invoice ID::::'+inv.id);
          Account ac = new Account();
          ac.id = ls.cllease__Account__r.id;
          ac.BillingState = 'PA';
          update ac;

          cllease__Lease_Account_Due_Details__c bill = new cllease__Lease_Account_Due_Details__c();
		
        	bill.cllease__Due_Date__c 			                        = Date.parse('09/1/2016');
             //bill.cllease__Account__ccllease__Late_Charge_Applied__c 	= false;
	        bill.cllease__Lease_Account__c			                    = LSContract.Id;
			     bill.cllease__Total_Paid_Amount__c 	                    = 49.00;
			    bill.cllease__Total_Due_Amount__c 		                    = 100.00;
			    bill.cllease__Status__c 				                    = 'In Process';	
        	 bill.cllease__Consolidated_Invoice__c                                        =  inv.Id;
												  
		     insert bill;
        
         
        
         System.Test.startTest();         
         System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        try{
         CongaGenerateInvoice.generateInvoiceDocument(inv.id);}
        catch(Exception e){}
         System.Test.stopTest(); 
        
        
        
    }
    static TestMethod void CongaGenerateInvoice1() {
          CongaURL_Settings__c cong = new CongaURL_Settings__c();
          cong.States_Prior_to_Maturity_120__c    = 'WI,NY';
          cong.States_Prior_to_Maturity_RI_120__c = 'RI';
          cong.Days_Prior_to_Maturity_120__c      = 120;
          cong.Days_Prior_to_Maturity_60__c       = 60;
          cong.InvoiceEverGreenTempID__c          = 'a2m0v0000001uH8';
          insert cong;
          System.debug('*****CongaURL_Settings__c******'+CongaURL_Settings__c.getInstance().InvoiceEverGreenTempID__c);
          cllease__Lease_Account__c LSContract = TestHelper.createContract();
        
          system.debug('Contact ID::::'+LSContract.id);
          Account dummyAccount = [SELECT Id, Name From Account WHERE Name = 'Sample Account'];
          Address__c address = new Address__c();
          address.Country__c = 'USA';
          address.Account__c = dummyAccount.Id;
          address.state__c   = 'WI'; 
          address.Bill_To_Usage__c = true;
          address.Install_At__c = true;
          address.Validation_Status__c = DLLNewCoConstants.EXPERIAN_VALIDATION_STATUS;
          cllease__Lease_Account__c ls = [select id,name,cllease__Account__r.id from cllease__Lease_Account__c where id=:LSContract.id];
          system.debug('Accout ID::::'+ls.cllease__Account__r.id);
          cllease__Lease_Account__c leac = new cllease__Lease_Account__c();
          leac.id = LSContract.id;
          leac.cllease__Maturity_Date__c = Date.newInstance(2018, 05, 01);
          leac.cllease__Lease_Status__c = 'EVERGREEN';
          Update leac;
          cllease__Lease_Account__c retrievedContract = [Select Id,Billing_Address__c
                                                        From cllease__Lease_Account__c
                                                        Where Id =: LSContract.id];
          retrievedContract.Billing_Address__c = address.Id;
          update retrievedContract;
        
          clcommon__Consolidated_Invoice__c inv = new clcommon__Consolidated_Invoice__c();
          inv.LS_Contract__c = LSContract.id;
          
          insert inv;
           system.debug('Invoice ID::::'+inv.id);
          Account ac = new Account();
          ac.id = ls.cllease__Account__r.id;
          ac.BillingState = 'WI';
          update ac;

          cllease__Lease_Account_Due_Details__c bill = new cllease__Lease_Account_Due_Details__c();
    
           bill.cllease__Due_Date__c                              = Date.parse('09/1/2016');
             //bill.cllease__Account__ccllease__Late_Charge_Applied__c  = false;
           bill.cllease__Lease_Account__c                         = LSContract.Id;
       bill.cllease__Total_Paid_Amount__c                       = 49.00;
       bill.cllease__Total_Due_Amount__c                        = 100.00;
       bill.cllease__Status__c                            = 'In Process'; 
           bill.cllease__Consolidated_Invoice__c                                        =  inv.Id;
                          
         insert bill;
        
         
        
         System.Test.startTest();         
         System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        try{
         CongaGenerateInvoice.generateInvoiceDocument(inv.id);}
        catch(Exception e){}
         System.Test.stopTest(); 
        
        
        
    }

}