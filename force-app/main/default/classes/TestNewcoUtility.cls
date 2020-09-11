@isTest 
public class TestNewcoUtility{
	@isTest
	public static void testMethod1() {
       NewcoUtility.convertdate('10/22/1963');
       NewcoUtility.convertdateYYYYMMDD('19631022');

       Int_OFAC__c o = new Int_OFAC__c();
       insert o;
       Map<ID,String> mapO = new Map<ID,String>();
       mapO.put(o.id,'test');
       NewcoUtility.deleteOfac(mapO);

       Int_OFAC_FINCEN__c fi = new INt_OFAC_FINCEN__c();
       insert fi;
       mapO = new Map<ID,String>();
       mapO.put(fi.id,'test');
       NewcoUtility.deleteOfacFincen(mapO);

       Int_PX_Billing__c b = new Int_PX_Billing__c(line_data__c = '6|0000000446|0000000446|04/05/2019|02/08/2019|INV-0000000148||||American Cornerstone|12106 Centennial Sta||Warminster|PA|18974-5488||||||418.70|smclachlan@leasedirect.com||CC;DEBIT;CREDIT|||||||||||||||||||||LES-0000000327');
       insert b;
       NewCoUtility.markBillingCommitted();

       Contact c = new Contact(firstname='Mark', lastName='Test');
       insert c;
       mapO = new Map<ID,String>();
       mapO.put(c.id,'dog');
       NewcoUtility.deleteContact(mapO);

       Account a = new Account(Name='test');
       insert a;
       Account a2 = new Account(Name='test2',parentid = a.id);
       insert a2;

       Set<ID> aset = new Set<ID>();
       aset.add(a.id);

       //NewcoUtility.deletelonewolf(aset);

    }
}