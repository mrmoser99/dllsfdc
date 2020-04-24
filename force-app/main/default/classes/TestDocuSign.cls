@isTest(seealldata=true)
public class TestDocuSign{
    
    static TestMethod void Test1() {
        
        dsfs__DocuSign_Recipient_Status__c  d = [SELECT  dsfs__Parent_Status_Record__r.dsfs__DocuSign_Envelope_ID__c, dsfs__DocuSign_Recipient_Id__c FROM dsfs__DocuSign_Recipient_Status__c limit 1 ];
        DocusignUtil.removeRecipient(d.dsfs__Parent_Status_Record__r.dsfs__DocuSign_Envelope_ID__c, d.dsfs__DocuSign_Recipient_Id__c);
        
        
    }
    
     

}