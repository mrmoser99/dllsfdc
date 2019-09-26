/**
 * Owner: CLS-Q2
 * Date : 09/24/2019
 * Moving the excess back to cash receipt and making it to 0.
 **/
trigger LPTTrigger on cllease__Lease_Payment_Transaction__c (before update) {
    if(trigger.isBefore && trigger.isUpdate){
        LPTTriggerHandler handler = new LPTTriggerHandler(trigger.new);
        handler.process();
    }
}