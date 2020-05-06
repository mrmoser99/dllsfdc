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


	System.debug('********************************* trigger docusign **********************');
	if (trigger.new.size() == 1 && trigger.isUpdate){
		if (trigger.new[0].equipment_install_date__c != trigger.old[0].equipment_install_date__c){
			List<dsfs__DocuSign_Status__c> sList = [select id from dsfs__DocuSign_Status__c where application__c = :trigger.new[0].id 
										and dsfs__Envelope_Status__c != 'Completed'];
			Set<ID> dSet = new Set<ID>();

			for (dsfs__DocuSign_Status__c d:sList)
				dSet.add(d.id);

			 List<dsfs__DocuSign_Recipient_Status__c> rlist = [select id from dsfs__DocuSign_Recipient_Status__c 
							 where dsfs__Parent_Status_Record__c in :dSet 
							 and (dsfs__Recipient_Status__c = 'Sent'  or dsfs__Recipient_Status__c = 'Created')
							 and name = 'Docusign Equipment Hold'];

			for (dsfs__DocuSign_Recipient_Status__c r:rList)
				r.release_equipment_signature_date__c = trigger.new[0].equipment_Install_date__c;
			update rList;


		}
	

	}	

	 
	
	
           
}