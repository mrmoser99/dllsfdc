@isTest
public  class TestIC {
    static TestMethod void Test1() {

        cllease__Lease_Account__c l = TestHelper.createContract();
        Lease_Claims__c claim = new Lease_Claims__c();
        String notes='Hello';
        List<String> eList = new List<String>();

        Lease_Claims__c c = new Lease_Claims__c();
        
        c.lease__c = l.id;
        c.Account__c = l.cllease__account__c;
        c.Claim_Status__c = 'New';
        c.Customer_Rep_Phone_Number__c = '9005551212';
        
        List<cllease__Contract_Equipment__c> eList2 = new List<cllease__Contract_Equipment__c>();
        eList2 = [select id from cllease__Contract_Equipment__c where cllease__Contract__c = :l.id];
        for (cllease__Contract_Equipment__c e:eList2)
            eList.add(e.id);
    
        ICNewClaim.createClaim(l.id, c, eList, notes);

        ICNewClaim.getLease(l.id);

        ICNewClaim.save(l.id,eList);
    }
    

    static TestMethod void Test2() {

        cllease__Lease_Account__c l = TestHelper.createContract();
        Lease_Claims__c claim = new Lease_Claims__c();
        String notes='Hello';
        List<String> eList = new List<String>();

        Lease_Claims__c c = new Lease_Claims__c();
        
        c.lease__c = l.id;
        c.Account__c = l.cllease__account__c;
        c.Claim_Status__c = 'New';
        c.Customer_Rep_Phone_Number__c = '9005551212';
        insert c;


    
        

        ICNewEquipment.getLease(c.id);

        ICNewEquipment.save(c.id,eList);

        ICNewEquipment.getEquipment(c.id);
    }

    static TestMethod void Test3() {

        cllease__Lease_Account__c l = TestHelper.createContract();
        Lease_Claims__c claim = new Lease_Claims__c();
        String notes='Hello';
        List<String> eList = new List<String>();

        Lease_Claims__c c = new Lease_Claims__c();
        
        c.lease__c = l.id;
        c.Account__c = l.cllease__account__c;
        c.Claim_Status__c = 'New';
        c.Customer_Rep_Phone_Number__c = '9005551212';
        insert c;


    
        

        IC_ClaimNotesController.getDocuments(l.id);

        IC_ClaimNotesController.uploadAttachment(l.id, 'test.txt', 'contentType','base64Body');
		
    }
}