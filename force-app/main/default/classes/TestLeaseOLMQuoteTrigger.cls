@isTest(seealldata=true)
public class TestLeaseOLMQuoteTrigger {
    	
     static TestMethod void  test1() {
    
         user u = [select id from User where profile.name = 'NewCo Dealer Portal Manager' and isActive = true limit 1];

          System.runAs(u) {

             Lease_OLM_Quote__c q =  new lease_olm_quote__c(Contract_Number__c = 'test');
             insert q;

          }
     }
}