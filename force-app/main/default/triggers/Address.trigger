/****************************************************************************
* Address Trigger
*
* Log:
*
* 	5/4/18 - MRM Created
*   7/21/2020 - MRM create return for scramble class
*   08/18/2020 - MRM remove email requirement
*   09/30/2020 - MRM add searchable street, city, state, zip for account
*
* This trigger udpates the email to contact and billing contact on the account
* Also, a system contact is maintained so that conga has a contact to send invoices to
*
******************************************************************************/
trigger Address on Address__c (before insert, before update) {
	
	if (Scramble3.isRunning == true)
		return; 

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
	Map<ID,Account> accountMap = new Map<ID,Account>();
	Map<ID,Contact> contactMap = new Map<ID,Contact>();

   	for (Address__c a:trigger.new){
		accountMap.put(a.account__c,aMap.get(a.account__c));
		if (a.Primary_Address__c == true){
			Account temp = accountMap.get(a.account__c);
			temp.primary_street__c = a.address_line_1__c; 
			temp.primary_city__c  = a.city__c;
			temp.primary_state__c = a.state__c;
			temp.Primary_zip_code__c = a.zip_code__c;
			accountMap.put(a.account__c,temp);
		}
		 
     	if (a.bill_to_usage__c == true){
			if (Test.isRunningTest())
     			a.email_address__c = 'test@test.com';
			 
			Account temp = accountMap.get(a.account__c);
     		temp.Billing_Email__c = a.Email_Address__c;
			accountMap.put(a.account__c,temp);
				
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
				contactMap.put(c.id,c);
			}
     	}
		 
		
     }
	 
	for (ID i:accountMap.keySet())
	 	uList.add(accountMap.get(i));
	 
	for (ID i:contactMap.keySet())
		 uCList.add(contactMap.get(i));
		 
	 if (!uList.isEmpty())
		 update uList;

	if (!uCList.isEmpty())
     	update uCList;
     	
     if (!iCList.isEmpty())
     	insert iCList;
      
}