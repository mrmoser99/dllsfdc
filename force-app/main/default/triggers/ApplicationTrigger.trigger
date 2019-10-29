/**************************************************************************************************************
*
*  
*
*  log:
*
* 	6/25/18 - MRM Added bridger call
*   9/25/19 - MRM Changed bridger call to queable call - OFACCall
*
****************************************************************************************************************/

trigger ApplicationTrigger on genesis__Applications__c (before insert,before update) {
    
	if (NewCoUtility.skipApplicationTrigger == true || CAMSUtility.skipApplicationTrigger == true) return; 
    
    system.debug('running trigger');
    
    ApplicationTriggerHandler handler = new ApplicationTriggerHandler();
    handler.setValues(Trigger.new);
    
    if (system.label.ofac_checking.equalsIgnoreCase('true') && trigger.isUpdate && trigger.new.size() == 1){
    	system.debug('check for ofac');
	    integer i = 0;
	    for (genesis__Applications__c a:trigger.new){
	    	if ((trigger.new[i].genesis__Status__c == 'APPROVED - DOCUMENT CHECK' && trigger.old[i].genesis__Status__c !=  'APPROVED - DOCUMENT CHECK') ||
			   (trigger.new[i].genesis__Status__c == 'CREDIT APPROVED' && trigger.old[i].genesis__Status__c !=  'CREDIT APPROVED'))	
			{
	    		system.debug('*************** checking bridger ******************');
	    		Map<ID,String> inputMap = new Map<ID,String>();
	    		inputMap.put(trigger.new[i].id,'Check Bridger');
	    		OFACCall job = new OFACCall(inputMap);
        		System.enqueueJob(job);	   
			   
    		}
	    	i++;
	    }
    }
           
}