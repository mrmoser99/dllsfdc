/**
 * Author: Cloud Lending Solutions
 * Description: Following Trigger helps in calling the Termination Quote Request Vertex call 
 *		for the first time when Quote lines created
 **/
trigger QuoteEqpTaxTrigger on cllease__Termination_Quote_Equipment__c (after insert) {
	/**  
	 * Note:  Currently This trigger handles quote line tax calculation for single quote at a time		
	 **/
	Savepoint sp = database.setsavepoint();
	try {
		// NOTE: Following code run only during after insert on Object
		// a. Pulling the Termination Quote Header ID from first Quote Line
		List<cllease__Termination_Quote_Equipment__c> quoteEqps = Trigger.new;
		String quoteHeaderId = quoteEqps.get(0).cllease__Termination_Quote_Header__c;

		// b. Create Termination Equipment Quote Objects for new Quote Line Amounts
		CLSTerminationUtil.inititeVertexTerminationQuotation(quoteHeaderId);
		
	} catch(exception e){           
       	database.rollback(sp);
       	System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
       	System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());      
       	//insert batch process log for exceptions
       	insert new cllease__Batch_Process_Log__c(Name='QuoteEqpTaxTrigger: ', cllease__Date__c=system.today(), 
       	cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
    }

}