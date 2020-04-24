/**
 * Author: Cloud Lending Solutions
 * Description: Following Trigger helps in calling the Termination Quote Request Vertex call 
 *		incase of any updates to Quote line amounts from Termination Quote Page.
 **/
trigger QuoteLineTaxTrigger on cllease__Termination_Quote_Line__c (after update) {
	/**  
	 * Note:  Currently This trigger handles quote line tax calculation for single quote at a time		
	 **/
	String infoMessage = '';
	Savepoint sp = database.setsavepoint();
	try {
		if(Trigger.isAfter && Trigger.isUpdate) {
			// a. Pulling the Termination Quote Header ID from first Quote Line
			List<cllease__Termination_Quote_Line__c> quoteLines = Trigger.new;
			String quoteHeaderId = quoteLines.get(0).cllease__Quote_Header__c;

			// b. Checking Vertex Call is done or not by checking flag @Termination Quote Object
			/*Boolean vertexCallDone = TerminationUtil.getQuoteVertexFlag(quoteHeaderId);

			System.debug(LoggingLevel.ERROR, ' Vertex Flag update in QuoteLineTaxTrigger: '+vertexCallDone);

			// c. Incase Vertex Tax Completed arleady in Transaction, skip the call or set the flag and continue Vertex Tax Call
			if(vertexCallDone) {
				return; // if vertex call already done, just return 
			} else {
				TerminationUtil.updateQuoteVertexFlag(quoteHeaderId, true);
			}*/

			// d. Create Termination Equipment Quote Objects for new Quote Line Amounts
			TerminationUtil.createTerminationEqpQuoteObjects(quoteHeaderId);

			// e. Vertex Call for Termination Quote Lines
			TerminationUtil.updateVertexTax(quoteHeaderId);

			// f. Updating the INFO message to refresh the Page for vertex values
			infoMessage = 'Please refresh the page for Vertex Tax Value ...';
			
		}
	} catch(exception e){           
       	database.rollback(sp);   
       	infoMessage = 'Error :' + e.getmessage();
       	System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
       	System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());      
       	//insert batch process log for exceptions
       	insert new cllease__Batch_Process_Log__c(Name='QuoteLineTaxTrigger: ', cllease__Date__c=system.today(), 
       	cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
    }

    // f. Updating the INFO message to refresh the Page for vertex values			
    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.INFO , infoMessage);
	ApexPages.addMessage(msg);

}