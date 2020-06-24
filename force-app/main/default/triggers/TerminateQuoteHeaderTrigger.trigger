trigger TerminateQuoteHeaderTrigger on cllease__Termination_Quote_Header__c (before insert, before update) {
    /* Before update added on 09/21/2019
     * To compute all the accounting required values on the contract during termiantion
     * These values can be later used to populate them on Termination transaction for accounting.
     */
     
    class myException extends Exception{}
    if(trigger.isBefore){
        if(trigger.isInsert) {
            Set<ID> ids = new Set<ID>();
            
            for(cllease__Termination_Quote_Header__c terminate : trigger.new) {
                ids.add(terminate.cllease__Contract__c);
            }
            Map<Id,cllease__lease_account__c> lsContract = new Map<id,cllease__lease_account__c>([Select Id,name,Ending_Net_Investment_last_month__c
                                                          from cllease__lease_account__c
                                                          where id in: ids]);
            
            List<cllease__Termination_Quote_Header__c> quotes = new List<cllease__Termination_Quote_Header__c>();
            for(cllease__Termination_Quote_Header__c terminate : trigger.new) {
                terminate.Ending_Net_Investment__c = lsContract.get(terminate.cllease__Contract__c).Ending_Net_Investment_last_month__c;
                quotes.add(terminate);
            }
        
        }
        if(trigger.isUpdate){
            List<cllease__Termination_Quote_Header__c> acceptedTxns = new List<cllease__Termination_Quote_Header__c>();
            List<cllease__Termination_Quote_Header__c> processedTxns = new List<cllease__Termination_Quote_Header__c>();
            for(cllease__Termination_Quote_Header__c txn : trigger.new){
                System.debug(LoggingLevel.ERROR, '^^^^ status : ' + txn.cllease__Status__c);
                if(txn.cllease__Status__c == 'ACCEPTED')
                    acceptedTxns.add(txn);
                if(txn.cllease__Status__c == 'TERMINATION PROCESSED')
                    processedTxns.add(txn);
            }
            //throw new myException('test');
            if(acceptedTxns.size() > 0){
                TerminationTriggerHandler handler = new TerminationTriggerHandler(acceptedTxns);
                handler.processTerminationAccounting();
            }
            
            if(processedTxns.size() > 0){
                TerminationTriggerHandler handler = new TerminationTriggerHandler(processedTxns);
                handler.populateAccountingValuesOnOLT();
            }
        }
    }
}