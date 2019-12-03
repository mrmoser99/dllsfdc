@isTest(seealldata=true)
public with sharing class TestICVDefault{
 		
	
     
	  static testmethod void test11(){
		
	 	Account a = new Account(name= 'test hog');
		insert a;
		a = [select 	Account_Number__c from account where id = :a.id];

		Int_ICV_Default__c n = new INT_ICV_Default__c(

			Committed__c = false
			,Le_Accrual_Flag__c = 'Y'
			,LE_Source_System__c	= 'ICV'
			,LE_Source_System_Key_Name__c	= 'LE_ID'
			,Le_Source_System_Key_Value__c	= '1571143491386371'
			,Party_Source_System_Key_Name__c	= 'PARTY_ID'
			,Party_Source_System_Key_Value__c	= a.account_number__c
			,Party_Source_System_Name__c = 'CLND'	
			,Probability_of_Default__c = 0.0124006
		);

		insert n;

	 }
     

       static testmethod void test12(){
	
		CAMS_Check__c c = new CAMS_Check__c(status__c = 'Held - High');
        insert c;
        update c;
        CAMS_Check__c c1 = new CAMS_Check__c(status__c = 'Auto Cleared');
        insert c1;
        update c1;



	 }
}