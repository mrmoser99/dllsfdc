/************************************************************************************
 * 
 * 
 * Change log:
 *  
 *  MRM - Added logic to capture dealer email adress for credit notifications
 **************************************************************************************/
trigger QuickQuotes on genesis__Quick_Quotes__c (before insert, before update) {
	
	Set<ID> dealerSet = new set<ID>();
	for (genesis__Quick_Quotes__c q: trigger.new)
		dealerSet.add(q.dealer__c);

	List<Account> dList = [Select Primary_Address__r.Email_Address__c from Account where id in :dealerSet];

	Map<ID,String> accountMap = new Map<ID,String>();

	for (Account d:dList)
		accountMap.put(d.id, d.primary_address__r.email_address__c);

    if (system.label.ICS_AutoApproval == 'AUTO') {
   	 	integer i =0;
    	for (genesis__Quick_Quotes__c q:trigger.new){
        	if (trigger.new[i].genesis__status__c == 'CREDIT SUBMITTED' || trigger.new[i].genesis__status__c == 'CREDIT REFERRED' || trigger.new[i].genesis__status__c == 'CREDIT DECLINED'){  
           	 	trigger.new[i].genesis__status__c = 'CREDIT APPROVED';
        		trigger.new[i].approved_credit_amount__c = decimal.valueOf(trigger.new[i].estimated_financed_amount__c);
        		trigger.new[i].credit_approval_date__c = date.today();
    
        	}
       		i++;
    	}
	}
	
	for (genesis__Quick_Quotes__c q:trigger.new)
		q.credit_notification_email__c = accountMap.get(q.dealer__c);
    
}