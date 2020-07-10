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
	
		for (Contact c:trigger.new){
			if (c.firstName == 'System' && c.lastname == 'BillTo'){
				Account temp = aMap.get(c.accountId);
				temp.bill_to_contact_id__c = c.id;
				uAList.add(temp);
			}
		} 
	
		if (!uAList.isEmpty())
			update uAlist;
 			
	}		
}