trigger BillsInvoiceTrigger on cllease__Lease_account_Due_Details__c (after update) {
  	Set<Id> invIds = new Set<Id>();
   	for (cllease__Lease_account_Due_Details__c childObj : Trigger.new) {
   		if(childObj.cllease__Consolidated_Invoice__c != null) {
   			invIds.add(childObj.cllease__Consolidated_Invoice__c);
   		}    	
  	}
  
  	if(invIds.size()>0){
  		InvoiceSummaryUtil.InvoiceSummary(invIds);
  	}
}