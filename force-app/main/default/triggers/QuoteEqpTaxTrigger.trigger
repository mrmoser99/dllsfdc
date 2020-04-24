/**
 * Author: Cloud Lending Solutions
 * Description: Following Trigger helps in calling the Termination Quote Request Vertex call 
 *		for the first time when Quote lines created
 **/
trigger QuoteEqpTaxTrigger on cllease__Termination_Quote_Equipment__c (after insert) {
	/**  
	 * Note:  Currently This trigger handles quote line tax calculation for single quote at a time		
	 **/
	String infoMessage = '';
	Savepoint sp = database.setsavepoint();
	try {
		if(Trigger.isAfter && Trigger.isInsert) {
			// a. Pulling the Termination Quote Header ID from first Quote Line
			List<cllease__Termination_Quote_Equipment__c> quoteEqps = Trigger.new;
			String quoteHeaderId = quoteEqps.get(0).cllease__Termination_Quote_Header__c;

			// b. Update the Vertex Flag in quote header as true to avoid subsequent calls in same transaction
			//TerminationUtil.updateQuoteVertexFlag(quoteHeaderId, true);

			// c. Create Termination Equipment Quote Objects for new Quote Line Amounts
			TerminationUtil.createTerminationEqpQuoteObjects(quoteHeaderId);

			// d. Vertex Call for Termination Quote Lines
			TerminationUtil.updateVertexTax(quoteHeaderId);

			// e. Updating the INFO message to refresh the Page for vertex values
			infoMessage = 'Please refresh the page for Vertex Tax Value ...';
			
		}
	} catch(exception e){           
       	database.rollback(sp);   
       	infoMessage = 'Error :' + e.getmessage();
       	System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
       	System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());      
       	//insert batch process log for exceptions
       	insert new cllease__Batch_Process_Log__c(Name='QuoteEqpTaxTrigger: ', cllease__Date__c=system.today(), 
       	cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
    }

    // f. Updating the INFO message to refresh the Page for vertex values			
    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.INFO , infoMessage);
	ApexPages.addMessage(msg);

}