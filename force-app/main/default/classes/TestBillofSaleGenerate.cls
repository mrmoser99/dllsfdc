@isTest
public class TestBillofSaleGenerate {
    
   static TestMethod void CongaBillofSaleGenerate() {
        CongaURL_Settings__c cong = new CongaURL_Settings__c();
        cong.BillofSale__c='a2e0v0000001ih5';
        cong.BillofSaleTemplate__c='a2m0v0000001usk';
        insert cong;
        
             Testhelper.getVertexCustomSettings();
          // Creating Contract using TestHelper     
        cllease__Lease_Account__c leaseContract = TestHelper.createContract();
        system.debug('a idddd'+leaseContract.id);

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
                                                        Where Id =: leaseContract.Id];
        retrievedContract.Billing_Address__c = address.Id;
        update retrievedContract;
     
        // Retrieving Attached Equipment for Charge Creation
        cllease__Contract_Equipment__c contractEquipment = [Select Id, Install_Address__c
                                                            From cllease__Contract_Equipment__c
                                                            Where cllease__Contract__c = :leaseContract.Id
                                                            LIMIT 1];
        contractEquipment.Install_Address__c = address.Id;
        contractEquipment.Install_Account__c = dummyAccount.Id;
        update contractEquipment;
        
        cllease__Asset_workbench__c aw= new cllease__Asset_workbench__c();
        aw.cllease__Contract__c=leaseContract.id;
        aw.cllease__Contract_Equipment__c=contractEquipment.id;
        aw.Sold_To__c=dummyAccount.id;
        aw.cllease__Serial_Number__c='64537892';
       // aw.Contract_Equipment_Return_Status__c='SOLD';
        Insert aw;
        
        System.Test.StartTest();
         System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        try{
         BillofSaleGenerate.generateBillofSaleDocument(contractEquipment.Id);}
        catch(Exception e){}
         System.Test.stopTest(); 

        
            
            
            
            }

}