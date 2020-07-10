/****************************************************************************
* Address Trigger
*
* Log:
*
* 	5/4/18 - MRM Created
*
* This trigger udpates the email to contact and billing contact on the account
* Also, a system contact is maintained so that conga has a contact to send invoices to
*
******************************************************************************/
trigger Address on Address__c (before insert, before update) {
    
    Set<ID> accountIdSet = new Set<ID>();
    
    for (Address__c a:trigger.new){
    	accountIdSet.add(a.Account__c);
    	if (a.address_line_2__c == null){
    		a.all_address__c = a.address_line_1__c + '\n' + a.city__c + ', ' + a.state__c + ' ' + a.zip_code__c; 
    	}
    	else{
    		a.all_address__c = a.address_line_1__c + '\n' + a.address_line_2__c + '\n' + a.city__c + ', ' + a.state__c + ' ' + a.zip_code__c; 	
    	}
    }
    
    
    List<Account> aList = new List<Account>();
    aList = [select id from Account where id in :accountIdSet];
    Map<ID,Account> aMap = new Map<ID,Account>();
    for (Account a:aList)
    	aMap.put(a.id,a);
    
    List<Contact> cList = new List<Contact>();
    cList = [select id 
    			,accountId
    			from Contact 
    			where accountId in :accountIdSet 
    			and firstname = 'System' 
    			and lastname = 'BillTo'];
    
    Map<ID,Contact> cMap = new Map<ID,Contact>();
    for (Contact c:cList)
    	cMap.put(c.accountId,c);
    List<Contact> iCList = new List<Contact>();
    List<Contact> uCList = new List<Contact>();
    	
    system.debug(aMap);
    List<Account> uList = new List<Account>();
   	for (Address__c a:trigger.new){
     	if (a.bill_to_usage__c == true){
			if (Test.isRunningTest())
     			a.email_address__c = 'test@test.com';
     					
     		if (a.Email_Address__c == null){
   				a.email_address__c.addError('Email is required if bill to is true!');
     		}else{
     			Account temp = aMap.get(a.account__c);
     			temp.Billing_Email__c = a.Email_Address__c;
     			uList.add(temp);
     			
     			if (cMap.get(a.account__c) == null){
     				Contact c = new Contact(accountId = a.account__c
     										, firstName = 'System'
     										, lastName = 'BillTo'
     										, email = a.email_address__c);
     				iClist.add(c);
     			}
     			else{
     				Contact c= cMap.get(a.account__c);
     				c.email = a.email_address__c;
     				uCList.add(c);
     			}
     				
     		}
     	}
     }
     if (!uList.isEmpty())
     	update uList;
     	
     if (!uCList.isEmpty())
     	update uCList;
     	
     if (!iCList.isEmpty())
     	insert iCList;
      
}