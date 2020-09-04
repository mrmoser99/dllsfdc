/**
 * Author: Cloud Lending Solutions
 * Description: Following Trigger helps in calling the Termination Quote Request Vertex call 
 *		incase of any updates to Quote line amounts from Termination Quote Page.
 **/
trigger QuoteLineTaxTrigger on cllease__Termination_Quote_Line__c (after update) {
	/**  
	 * Note:  Currently This trigger handles quote line tax calculation for single quote at a time		
	 **/
	Savepoint sp = database.setsavepoint();
	try {
		List<cllease__Termination_Quote_Line__c> quoteLines = Trigger.new;
		Boolean skipVertexTaxCall = false;
		if(quoteLines.size() == 1 && quoteLines.get(0).cllease__Line_Type__c == DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX) {
			skipVertexTaxCall = true;
		}
		
		// Skip the taxation incase of Quote Estimation Sales Tax. 
		if(!skipVertexTaxCall) {
			// NOTE: Following code run only during after Update on Quote Line
			// a. Pulling the Termination Quote Header ID from first Quote Line
			String quoteHeaderId = quoteLines.get(0).cllease__Quote_Header__c;

			// b. Create Termination Equipment Quote Objects for new Quote Line Amounts
			CLSTerminationUtil.inititeVertexTerminationQuotation(quoteHeaderId);
		}
			
	} catch(exception e){           
       	database.rollback(sp);
       	System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
       	System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());      
       	//insert batch process log for exceptions
       	insert new cllease__Batch_Process_Log__c(Name='QuoteEqpTaxTrigger: ', cllease__Date__c=system.today(), 
       	cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
    }
}