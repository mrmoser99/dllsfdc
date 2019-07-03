trigger InvoiceCreditAccountGenerationTrigger on Cllease__Invoice_Credit__c (after insert, before update, before insert) {   
    InvoiceCreditHandler handler = new InvoiceCreditHandler(trigger.new, trigger.oldMap);

    if (trigger.isBefore) {
        if (trigger.isUpdate) {
            handler.beforeUpdateHandler();
        }
        
        if (trigger.isInsert){
            handler.beforeInsertHandler();
        }
    }

    if(trigger.isAfter){
        if (trigger.isInsert) {
            handler.afterInsertHandler();
        }
    }
}