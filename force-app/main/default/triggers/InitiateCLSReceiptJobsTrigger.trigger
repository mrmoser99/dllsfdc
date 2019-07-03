/**
 * Author: Cloud Lending Solutions
 * Description: Following trigger helps in invoking the inbound jobs
 * 		AP Payment Confirmation 
 * 		Apply Payment File

 6/27/19 - MRM Added PNC job to class
 **/
trigger InitiateCLSReceiptJobsTrigger on Int_Batch_Status__c (before insert) {
	// trigger Payment Return ()
	// Processing only one record at a time for triggering jobs to avoid
	Int_Batch_Status__c batchStatus = trigger.new.get(0);

	// Invoking the AP Confirmation Job when New records entered
	if(batchStatus.Name == DLLNewCoConstants.BATCH_STATUS_AP_CONFIRMATION 
		&& batchStatus.Status__c == DLLNewCoConstants.BATCH_STATUS_READY) {
		// Apply AP Confirmation DAG 
		String dagName = 'DAG - AP Confirmation';
		clcommon.DynamicJobAPI2 apiHandle = clcommon.APIFactory.getDynamicJobAPI2();
        apiHandle.runOnce(dagName);

	} else if(batchStatus.Name == DLLNewCoConstants.BATCH_STATUS_PNC_PAYMENTS 
		&& batchStatus.Status__c == DLLNewCoConstants.BATCH_STATUS_READY) {
		// Apply Payments From PNC
		String dagName = 'DAG - Apply PNC Payments';
		clcommon.DynamicJobAPI2 apiHandle = clcommon.APIFactory.getDynamicJobAPI2();
        apiHandle.runOnce(dagName);
	
	
	} else if(batchStatus.Name == DLLNewCoConstants.BATCH_STATUS_PNC_NSF 
		&& batchStatus.Status__c == DLLNewCoConstants.BATCH_STATUS_READY) {
		// Apply Payments From PNC
		PNCLptReversalAndNSFChargeCreatorJob job = new PNCLptReversalAndNSFChargeCreatorJob();
		Database.executeBatch(job);
	}
	
}