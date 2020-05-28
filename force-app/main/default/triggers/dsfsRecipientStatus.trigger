/*************************************************************************************************************
 * 
 * Trigger on dsfs__Recipient_Status - purpose is to remove this recipient from the workflow so equipment signature
 * can proceed.  
 * 
 * Change Log: 
 *      4/17/2020 - MRM Created trigger.
 */

trigger dsfsRecipientStatus on dsfs__DocuSign_Recipient_Status__c (before update, before insert) {

    system.debug('firing recipient trigger');

    if (trigger.new.size() != 1)  //not a bulkified action
        return;

    if (trigger.isUpdate){
        if (trigger.new[0].release_equipment_signature__c == true && trigger.old[0].release_equipment_signature__c == false){
            system.debug('calling remove');
            DocusignUtil.removeRecipient(trigger.new[0].dsfs__Envelope_Id__c,trigger.new[0].dsfs__DocuSign_Recipient_Id__c);
        
        } 

        if (trigger.new[0].dsfs__Recipient_Status__c == 'Completed' && trigger.old[0].dsfs__Recipient_Status__c != 'Completed' && (trigger.new[0].dsfs__DocuSign_Routing_Order__c == 3 || trigger.new[0].dsfs__DocuSign_Routing_Order__c == 4)){
            system.debug('******************** order is: ' + trigger.new[0].dsfs__DocuSign_Routing_Order__c);
            DocusignUtil.attachDocument(trigger.new[0].dsfs__Envelope_Id__c,integer.valueOf(trigger.new[0].dsfs__DocuSign_Routing_Order__c)); 
        }
    }

    if (trigger.isInsert){
        system.debug(trigger.new[0].dsfs__Parent_Status_Record__c);

        dsfs__DocuSign_Status__c s = [select equipment_install_date__c, application__c from dsfs__DocuSign_Status__c where id = :trigger.new[0].dsfs__Parent_Status_Record__c];
        
        trigger.new[0].release_equipment_signature_date__c = s.equipment_install_date__c;

    }
    
     
    
}