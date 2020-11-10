global class CLLeaseTerminationQuoteProcessCtrlCopy {
	  webService static String fullTermination(String appId){ 
        Savepoint sp = Database.setSavepoint();
        List<cllease__Termination_Quote_Header__c> quoteHeaderList;
        String JOB_NAME = 'CLLeaseTerminationQuoteProcessCtrl';
        try{
           List<genesis__Applications__c> appList=[select id,name,Oracle_Trade_up_Quote_Number__c from genesis__Applications__c where id=:appId]; 
            system.debug('appList[0].Oracle_Trade_up_Quote_Number__c=' +appList[0].Oracle_Trade_up_Quote_Number__c);
            if(appList[0].Oracle_Trade_up_Quote_Number__c!=null){
               quoteHeaderList=[select id,name,cllease__Contract__r.Name,cllease__Quote_Reason__c,cllease__Quote_Type__c,cllease__Termination_Date__c,
                                                                       cllease__Status__c,cllease__Effective_From__c,cllease__Quote_Amount__c from cllease__Termination_Quote_Header__c
                                                                       where name=:appList[0].Oracle_Trade_up_Quote_Number__c and cllease__Status__c='ACCEPTED'];
              
                
                  System.debug('Status : ' +quoteHeaderList[0].cllease__Status__c);
                  system.debug('Termination Id =' + quoteHeaderList[0].name);
                  cllease.TerminationQuoteAPI  termQuoteAPI = new cllease.TerminationQuoteAPI(quoteHeaderList[0].id);  
                  termQuoteAPI.processQuote(); 
                  system.debug('Termination Id =' + quoteHeaderList[0].name);
                  return 'Termination Processed Sucessfully'; 
                          
                   
            }
            /*else{
                 system.debug('TradeUpQuoteNumber should not be null');
                 return 'TradeUpQuoteNumber should not be null !!';
            }*/
            
            return '';
           
            
        }catch(ListException ls){
            Exception_Log__c log = new Exception_Log__c();
            log.Name = JOB_NAME;
            log.Date__c = System.now();
            log.Message__c = 'Termination Quote is not in ACCEPTED status !!';
            log.Line_Number__c = String.valueOf(ls.getLineNumber());
            log.Stack_Trace__c = ls.getStackTraceString();
            log.Type_Name__c = ls.getTypeName();
                
            insert log;
            return 'Termination Quote is not in ACCEPTED status !!';
            
        }catch(Exception ex){
            Database.rollback(sp);
            Exception_Log__c log = new Exception_Log__c();
            log.Name = JOB_NAME;
            log.Date__c = System.now();
            log.Message__c = 'Exception : ' + ex.getMessage();
            log.Line_Number__c = String.valueOf(ex.getLineNumber());
            log.Stack_Trace__c = ex.getStackTraceString();
            log.Type_Name__c = ex.getTypeName();
                
            insert log;
            return 'Exception : ' + ex.getMessage();
                
            
        }
 
    }
}