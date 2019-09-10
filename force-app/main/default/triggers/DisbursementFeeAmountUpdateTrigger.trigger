// Following trigger helps in updating  disbursement with only charge's Fee amount to Disbursement.
trigger DisbursementFeeAmountUpdateTrigger on cllease__Disbursement_Transaction__c (before insert) {
	Savepoint sp = database.setsavepoint();
	try {
		// 1. Retrive all disbursements which has charges link init
		Set<Id> chargeTxnIds = new Set<Id>();
		for(cllease__Disbursement_Transaction__c disbTxn : trigger.new) {
			if(disbTxn.cllease__Charge__c != null) {
				chargeTxnIds.add(disbTxn.cllease__Charge__c);
			}
		}

		System.debug(LoggingLevel.ERROR, ' Charges to Retrive: '+chargeTxnIds);
		// 2. Update Fee_Amount_To_Dealer__c with fee amount paid from charge
		if(chargeTxnIds.size() > 0) {
			Map<Id, cllease__Charge__c> chargesMap = new Map<Id, cllease__Charge__c>(
													[SELECT Id, Name, 
														Current_Fee_Paid__c
													FROM cllease__Charge__c
													WHERE Id IN :chargeTxnIds]);

			//System.debug(LoggingLevel.ERROR, ' Charges to Retrived: '+chargesMap);
			for(cllease__Disbursement_Transaction__c disbTxn : trigger.new) {
				if(disbTxn.cllease__Charge__c != null) {
					cllease__Charge__c charge = chargesMap.get(disbTxn.cllease__Charge__c);
					System.debug(LoggingLevel.ERROR, ' Processing Charge: '+charge);
					disbTxn.Fee_Amount_To_Dealer__c = charge.Current_Fee_Paid__c;
				}
				
			}
		}

	} catch(exception e){           
           	database.rollback(sp);   
           	System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
           	System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());      
           	//insert batch process log for exceptions
           	insert new cllease__Batch_Process_Log__c(Name='DisbursementFeeAmountUpdateTrigger: ',
            cllease__Date__c=system.today(), cllease__Message__c='Error is '+e.getmessage()
            +' in line number: '+ e.getlinenumber());
        }
}