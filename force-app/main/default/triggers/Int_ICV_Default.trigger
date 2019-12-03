trigger Int_ICV_Default on Int_ICV_Default__c (before insert, after insert) {
  
  	
  	if (trigger.isbefore){
  		for (int_icv_default__c d:trigger.new)
  			d.committed__c = true;
  	}
	 
	if (trigger.isafter){
		Set<String> aSet = new Set<String>();
		for (Int_ICV_Default__c d:trigger.new){
			aSet.add(d.party_source_system_key_value__c);
		} 
	
		Map<String,Account> aMap = new Map<String,Account>();
	
		List<Account> uList = new List<Account>();
		List<Account> aList = new List<Account>();	

		aList = [select id, account_number__c from Account where account_number__c in :aSet];
		for (Account a:aList)
			aMap.put(a.account_number__c,a);
		
		for (Int_ICV_Default__c d:trigger.new){
			if (aMap.get(d.Party_Source_System_Key_Value__c) == null)
				continue;
			else{
				Decimal pd = 0;
				if (d.probability_of_default__c == null)
					pd = 0;
				else
					pd = d.probability_of_default__c;
			
				system.debug('account:' + d.Party_Source_System_Key_Value__c);	
				Account temp = aMap.get(d.Party_Source_System_Key_Value__c);
				if (pd == 1	|| d.LE_accrual_flag__c == 'Y'){
					temp.npa_status__c = 'NON ACCRUAL';
					uList.add(temp);
					system.debug('default');
				}
				else{
					temp.npa_status__c = 'ACCRUAL';
					uList.add(temp);
					system.debug('no default');
				}
			}		
		}
		
		if (!uList.isEmpty())
			update aList;
	}
}