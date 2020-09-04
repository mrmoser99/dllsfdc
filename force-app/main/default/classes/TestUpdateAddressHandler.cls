@isTest
public class TestUpdateAddressHandler {
    public static TestMethod void updateAddress(){
        System.Test.startTest();
        cllease__Lease_Account__c leaseContract= TestHelper.createContract();
        system.debug('a idddd'+leaseContract.id);
        Address__c add = new Address__c(City__c='Dallas',State__c='TX',Zip_Code__c='75219-7601',Account__c=leaseContract.cllease__Account__c);
        Insert add;
     
        cllease__Contract_Equipment__c contractEquipment= [ Select Id,name,City_InstallAddress__c,State_Code__c,Zip_Code_InstallAddress__c 
                                            From cllease__Contract_Equipment__c
                                            Where cllease__Contract__c = :leaseContract.Id];
       List<id> ids = new List<id>(); 
       genesis__Quick_Quotes__c quotes=new genesis__Quick_Quotes__c(Dealer__c=leaseContract.cllease__Account__c);
       insert quotes;
       ids.add(quotes.Id);
       UpdateAddressHandler.UpdateAddressHandler_func(ids) ;
       System.Test.stopTest();
    }

}