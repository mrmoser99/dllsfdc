@isTest
private class TestBatchNPBACalc{

	@testSetup static void setup(){

		Cllease__non_cash_account_balance__c clleasenoncashaccountbalancecObj = new Cllease__non_cash_account_balance__c (
			cllease__Balance_Type__c ='FUTURE LEASE RECEIVABLE'
		);
		insert clleasenoncashaccountbalancecObj;
		 
	}

	@isTest static void testMethod1() {
		// code_block	
	}

	@isTest static void testMethod2() {
		// code_block	
	}
}