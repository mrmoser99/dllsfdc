/****************************************************************************
* Contact Trigger
*
* Log:
*
* 	5/4/18 - MRM Created
*
* Updates the account bill to contact id and prevents deletion of system contact records
*
******************************************************************************/
trigger Contact on Contact (after insert, before update, before delete) {
 
	Static Boolean skipAddressTrigger = true;

 	if (trigger.isDelete){
 		for (Contact c:trigger.old){
 			if (c.firstname == 'System' && c.lastname == 'BillTo')
 				c.addError('Cannot delete a system billing contact (they are used by the system for invoicing)!');
 		}
 	}
 	else{
 
		Set<ID> aSet = new Set<ID>();
		for (Contact c:trigger.new){
			if (c.firstName == 'System' && c.lastname == 'BillTo')
				aSet.add(c.accountId);
			
		}    
	
		List<Account> aList = [select id from Account where id in:aSet];
		Map<ID,Account> aMap = new Map<ID,Account>();
		for (Account a:alist)
			aMap.put(a.id,a);
		
	
		List<Account> uAList = new List<Account>();
		List<Address__c> addrList = new List<Address__c>();
		List<Address__c> updateAddrList = new List<Address__c>();
		addrList = [select email_address__c, account__c from Address__c where account__c in : aSet and bill_to_usage__c = true];

		for (Contact c:trigger.new){
			if (c.firstName == 'System' && c.lastname == 'BillTo'){
				Account temp = aMap.get(c.accountId);
				temp.bill_to_contact_id__c = c.id;
				uAList.add(temp);
				
				/*
				for (Address__c a:addrList){
					if (a.account__c == c.accountId) {
						a.email_address__c = c.email;
						updateAddrList.add(a);
					}
				}
				*/
			}
		} 
	
		if (!updateAddrList.isEmpty())
			update updateAddrList;

		if (!uAList.isEmpty())
			update uAlist;
 			
	}		
}