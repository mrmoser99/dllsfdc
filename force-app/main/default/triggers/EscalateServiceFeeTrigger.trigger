/**
 *  Following trigger helps in escalate the fee
 *  1. [After Insert] After Service Fee Configuration creation, needs to create Application Fee with escalation split records 
 *  2. [After Update] Incase of any updates in Service Fee Configuration, needs to delete and re-create the Application Fees for new calculations
 *  3. [Before Delete] Incase of Deleting Service Fee Configuration, delete all Application Fee, Application Fee Payments Created before deleting parent record.
 *  4. [Before Insert, Before Update] : do validate Service Fee Configuration and assign defaults
 */
trigger EscalateServiceFeeTrigger on Service_Fee_Escalation_Config__c (before insert, after insert, before update, after update, before delete) {
    
    System.debug('Service Fee Configuration: '+Trigger.new);
    // Don't do anything in case disabled triggers option set in CL Origiate's Org Parameter
    if((!CLSCustomUtil.getCLOriginateOrgParameters().genesis__Disable_Triggers__c)) {
        // Creating handler object for operations to initiate
        if(trigger.isBefore) {
            if(trigger.isInsert || trigger.isUpdate) {
                // call validation util for Service Fee Configuration
                EscalateServiceFeeTriggerHandler handler = new EscalateServiceFeeTriggerHandler(Trigger.new);
                handler.validateServiceEscalationFeeConfig();
            }
            if(trigger.isDelete) {
                // Call delete operation for Application Fee, Application Fee Payments 
                EscalateServiceFeeTriggerHandler handler = new EscalateServiceFeeTriggerHandler(Trigger.old);
                handler.deleteEscalatedFee();
            }
        } else if(trigger.isAfter) {
            if(trigger.isInsert || trigger.isUpdate) {
                EscalateServiceFeeTriggerHandler handler = new EscalateServiceFeeTriggerHandler(Trigger.new);
                // Call delete operation for Application Fee, Application Fee Payments deletion
                handler.deleteEscalatedFee();
                // Create Escalation for Created/Updated Configuration
                handler.escalateServiceFee();
            }
        }
    }
}