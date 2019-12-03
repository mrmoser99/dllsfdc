@isTest (SeeAllData=true)
public class TestSupertrump {
    
	  public static testMethod void test1() {
	 	
        cllease__lease_account__c l = [ select id from cllease__lease_account__c
		 where 	cllease__Lease_Status__c in ('ACTIVE - GOOD STANDING') and  cllease__application_number__c != null
		limit 1];

	 	Map<ID,String> leaseMap = new Map<ID,String>();
        leasemap.put(l.id,'hello');
        supertrumputil.sendRequest(leaseMap);

	 }
	 
	   
}