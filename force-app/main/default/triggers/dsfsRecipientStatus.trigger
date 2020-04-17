/*************************************************************************************************************
 * 
 * Trigger on dsfs__Recipient_Status - purpose is to remove this recipient from the workflow so equipment signature
 * can proceed.  
 * 
 * Change Log: 
 *      4/17/2020 - MRM Created trigger.
 */

trigger dsfsRecipientStatus on dsfs__DocuSign_Recipient_Status__c (before update) {

    system.debug('firing recipient trigger');

    if (trigger.new.size() != 1)  //not a bulkified action
        return;

     if (trigger.new[0].release_equipment_signature__c == true && trigger.old[0].release_equipment_signature__c == false){
         DocusignUtil.removeRecipient(trigger.new[0].dsfs__Envelope_Id__c,trigger.new[0].dsfs__DocuSign_Recipient_Id__c);
     }       
}  