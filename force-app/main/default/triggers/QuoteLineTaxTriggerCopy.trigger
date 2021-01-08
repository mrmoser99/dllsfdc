/**
 * Author: Cloud Lending Solutions
 * Description: Following Trigger helps in calling the Termination Quote Request Vertex call 
 *    incase of any updates to Quote line amounts from Termination Quote Page.
 **/
trigger QuoteLineTaxTriggerCopy on cllease__Termination_Quote_Line__c (After Update) {
   /**  
   * Note:  Currently This trigger handles quote line tax calculation for single quote at a time    
   **/
  Savepoint sp = database.setsavepoint();
  try {
    List<cllease__Termination_Config_Line__c> configLineList = [select id,name,cllease__Termination_Config__c,cllease__Quote_Line__c,cllease__Field_API_Name__c,
                                                                cllease__Bill_Field_API_Name__c,Consider_for_Vertex_Tax__c,cllease__Add_To_Quote_Amount__c,DDL_Quote_Line_Tax_Field_API_Name__c 
                                                                from cllease__Termination_Config_Line__c where cllease__Termination_Config__c='a733u000000bxIV' and Consider_for_Vertex_Tax__c=true];
    List<cllease__Termination_Quote_Line__c> quoteLines = Trigger.new;
    //List<cllease__Termination_Quote_Line__c> oldQuoteLines = oldMap.get(quoteLines.id);
    Boolean skipVertexTaxCall = true;
    for(cllease__Termination_Config_Line__c config : configLineList){
        if(quoteLines.size() == 1 && quoteLines.get(0).cllease__Line_Type__c == config.cllease__Quote_Line__c && config.Consider_for_Vertex_Tax__c==true) {
            skipVertexTaxCall = false;
        }
    }
    
    
    // Skip the taxation incase of Quote Estimation Sales Tax. 
    if(!skipVertexTaxCall) {
      // NOTE: Following code run only during after Update on Quote Line
      // a. Pulling the Termination Quote Header ID from first Quote Line
      String quoteHeaderId = quoteLines.get(0).cllease__Quote_Header__c;

      // b. Create Termination Equipment Quote Objects for new Quote Line Amounts
      CLSTerminationUtilCopy.inititeVertexTerminationQuotation(quoteHeaderId);
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