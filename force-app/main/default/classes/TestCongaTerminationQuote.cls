/**
 * Author: Cloud Lending Solutions
 * Description: Following class is test class for CongaTerminationQuote 
 **/
@isTest
public class TestCongaTerminationQuote {
    static TestMethod void CongaTerminationQuote() {
      
         cllease__Lease_Account__c LSContract = TestHelper.createContract();
        
         cllease__Termination_Quote_Header__c tqh = new cllease__Termination_Quote_Header__c();
         tqh.cllease__Contract__c = LSContract.Id;
         tqh.cllease__Requested_Termination_Date__c = date.today();
         tqh.cllease__Termination_Date__c = date.today();
         insert tqh;
       
         apexpages.currentpage().getparameters().put('id', LSContract.Id);
                 
         CongaTerminationQuote.wrapQuote wap = new CongaTerminationQuote.wrapQuote(tqh);
       
         System.Test.startTest();         
         System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         CongaTerminationQuote ct = new CongaTerminationQuote();
         ct.summaryWithPurchase();
         ct.summaryWithOutPurchase();
         ct.detailWithPurchase();
         ct.detailWithOutPurchase();
         ct.renderedTerminationbuttons();
         System.Test.stopTest();
          
    }
    static TestMethod void CongaTerminationQuote1() {
      
         cllease__Lease_Account__c LSContract = TestHelper.createContract();
        
         cllease__Termination_Quote_Header__c tqh = new cllease__Termination_Quote_Header__c();
         tqh.cllease__Contract__c = LSContract.Id;
         tqh.cllease__Requested_Termination_Date__c = date.today();
         tqh.cllease__Termination_Date__c = date.today();
         insert tqh;
       
         apexpages.currentpage().getparameters().put('id', LSContract.Id);
               
         CongaTerminationQuote.wrapQuote wap = new CongaTerminationQuote.wrapQuote(tqh);
       
         System.Test.startTest();         
         System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         CongaTerminationQuote ct = new CongaTerminationQuote();
         for(CongaTerminationQuote.wrapQuote wrp : ct.wrapQuoteList){
            wrp.selected = True; 
         }
         try{
         ct.summaryWithPurchase();
        
         System.Test.stopTest();}
         catch(Exception e){}
          
    }
    static TestMethod void CongaTerminationQuote2() {

            cllease__Lease_Account__c LSContract = TestHelper.createContract();
        
            list<cllease__Termination_Quote_Header__c> litqh = new list<cllease__Termination_Quote_Header__c>();     
            cllease__Termination_Quote_Header__c tqh = new cllease__Termination_Quote_Header__c();
            tqh.cllease__Contract__c = LSContract.Id;
            tqh.cllease__Requested_Termination_Date__c = date.today();
            tqh.cllease__Termination_Date__c = date.today();
         
            insert tqh;
			
            apexpages.currentpage().getparameters().put('id', LSContract.Id);
        
            CongaTerminationQuote.wrapQuote wap = new CongaTerminationQuote.wrapQuote(tqh);
        
			System.Test.startTest();         
			System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
			CongaTerminationQuote ct = new CongaTerminationQuote();
			for(CongaTerminationQuote.wrapQuote wrp : ct.wrapQuoteList){
				wrp.selected = True; 
			}
			try{
			ct.summaryWithOutPurchase();
		   	System.Test.stopTest();}
			catch(Exception e){}
          
    }
	static TestMethod void CongaTerminationQuote3() {

            cllease__Lease_Account__c LSContract = TestHelper.createContract();
        
            list<cllease__Termination_Quote_Header__c> litqh = new list<cllease__Termination_Quote_Header__c>();     
            cllease__Termination_Quote_Header__c tqh = new cllease__Termination_Quote_Header__c();
            tqh.cllease__Contract__c = LSContract.Id;
            tqh.cllease__Requested_Termination_Date__c = date.today();
            tqh.cllease__Termination_Date__c = date.today();
         
            insert tqh;
			
            apexpages.currentpage().getparameters().put('id', LSContract.Id);
        
            CongaTerminationQuote.wrapQuote wap = new CongaTerminationQuote.wrapQuote(tqh);
        
			System.Test.startTest();         
			System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
			CongaTerminationQuote ct = new CongaTerminationQuote();
			for(CongaTerminationQuote.wrapQuote wrp : ct.wrapQuoteList){
				wrp.selected = True; 
			}
			try{
			ct.detailWithPurchase();
		   	System.Test.stopTest();}
			catch(Exception e){}
          
    }
	static TestMethod void CongaTerminationQuote4() {

            cllease__Lease_Account__c LSContract = TestHelper.createContract();
        
            list<cllease__Termination_Quote_Header__c> litqh = new list<cllease__Termination_Quote_Header__c>();     
            cllease__Termination_Quote_Header__c tqh = new cllease__Termination_Quote_Header__c();
            tqh.cllease__Contract__c = LSContract.Id;
            tqh.cllease__Requested_Termination_Date__c = date.today();
            tqh.cllease__Termination_Date__c = date.today();
         
            insert tqh;
			
            apexpages.currentpage().getparameters().put('id', LSContract.Id);
               
            CongaTerminationQuote.wrapQuote wap = new CongaTerminationQuote.wrapQuote(tqh);
        
			System.Test.startTest();         
			System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
			CongaTerminationQuote ct = new CongaTerminationQuote();
			for(CongaTerminationQuote.wrapQuote wrp : ct.wrapQuoteList){
				wrp.selected = True; 
			}
			try{
			ct.detailWithOutPurchase();
		   	System.Test.stopTest();}
			catch(Exception e){}
          
    }
	static TestMethod void CongaTerminationQuote5() {

            cllease__Lease_Account__c LSContract = TestHelper.createContract();
        
            list<cllease__Termination_Quote_Header__c> litqh = new list<cllease__Termination_Quote_Header__c>();     
            cllease__Termination_Quote_Header__c tqh = new cllease__Termination_Quote_Header__c();
            tqh.cllease__Contract__c = LSContract.Id;
            tqh.cllease__Requested_Termination_Date__c = date.today();
            tqh.cllease__Termination_Date__c = date.today();
         
            insert tqh;
			
            apexpages.currentpage().getparameters().put('id', LSContract.Id);
        
            CongaTerminationQuote.wrapQuote wap = new CongaTerminationQuote.wrapQuote(tqh);
        
			System.Test.startTest();         
			System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
			CongaTerminationQuote ct = new CongaTerminationQuote();
			for(CongaTerminationQuote.wrapQuote wrp : ct.wrapQuoteList){
				wrp.selected = True; 
			}
			try{
			ct.renderedTerminationbuttons();
		   	System.Test.stopTest();}
			catch(Exception e){}
          
    }


}