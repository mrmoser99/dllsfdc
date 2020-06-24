trigger TerminationAccoutingValuesCreation on cllease__Other_Transaction__c (before insert) {
    class myException extends Exception{}
    List<cllease__Other_Transaction__c> terminationTxns = new List<cllease__Other_Transaction__c>();
    System.debug(LoggingLevel.ERROR, '^^^^ trigger.new : ' + trigger.new);
    for(cllease__Other_Transaction__c txn : trigger.new){
        if(txn.cllease__Transaction_Type__c == 'TERMINATION')
            terminationTxns.add(txn);
    }
    if(terminationTxns.size() > 0){
        System.debug(LoggingLevel.ERROR, '^^^^ terminationTxns : ' + terminationTxns);
        TerminationTriggerHandler handler = new TerminationTriggerHandler(terminationTxns);
        handler.processOLT();
    }
}