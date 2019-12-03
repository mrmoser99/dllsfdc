/*********************************************************************************************
*   Charges Trigger
*           
*
* ChangeLog:
*
*   unknown date - CLS Created this class
*
************************************************************************************************/
trigger ChargesInvoiceTrigger on cllease__Charge__c (before insert, before update , after update) {

    public class myException extends Exception{}
    
    
    Date currentCLLeaseSystemDate = cllease.SystemDateUtil.getCurrentSystemDate();

    // 0. Creating Transaction SubType ID, Name Map
    Map<Id, String> txnSubTypeMap = new Map<Id, String>();
    for(cllease__Transaction_Sub_Type__c txnSubType : [SELECT Id, Name FROM cllease__Transaction_Sub_Type__c LIMIT 1000]) {
        txnSubTypeMap.put(txnSubType.Id, txnSubType.Name);
    }
    

    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
        
        for(cllease__Charge__c charge : trigger.new) {

            if(charge.cllease__Transaction_Sub_Type__c != null) {
                charge.Transaction_SubType_Name__c = txnSubTypeMap.get(charge.cllease__Transaction_Sub_Type__c);
            }
            System.debug('cllease__Tax_Processed = ' + charge.cllease__Tax_Processed__c);
            if(String.isBlank(charge.cllease__Tax_Processed__c) == true) {
                charge.cllease__Tax_Processed__c = 'Tax Not Calculated'; //this may not be needed if product changes this. 
            }
            // Incase of Late Fee, field cllease__Fee_Due__c not updating from product. So updating it here same as original amount.
            if(trigger.isInsert) {
                // rounding off the charge amount to 2 digits 
                charge.cllease__Original_Amount__c = cllease.ValueUtil.round(charge.cllease__Original_Amount__c); // default roundOff: , 2, 'Nearest'
                charge.cllease__Principal_Due__c   = cllease.ValueUtil.round(charge.cllease__Principal_Due__c);    // default roundOff: , 2, 'Nearest'
                charge.cllease__Fee_Due__c = charge.cllease__Original_Amount__c;
            }

            // Fix: For Late Fees and charges Creating from UI , cllease__Transaction_Date__c is coming as null
            if(charge.cllease__Transaction_Date__c == null) {
                charge.cllease__Transaction_Date__c = currentCLLeaseSystemDate;
            }
        }
        
        /**
         * Owner: CLS-Q2
         * Date : 10/10/2019
         * Description: To move late fee date to next due generation date so that it can be part of next invoice.
         **/
         if(trigger.isInsert){
             ChargeTriggerHandler chargeHandler = new ChargeTriggerHandler(trigger.new);
             chargeHandler.process();
         }
         
        /**
         * Owner: CLS-Q2
         * Date : 09/12/2019
         * Description: Trigger to update custom fields required by DLL on product invoice object.
         * Fee Amount Billed, Fee Tax Amount Billed, Fee Billed Total Amount, -Total of Charge Waived
         * Total Fee Paid, Total Fee Tax Paid, Total Charge Paid Amount
         **/
        if(trigger.isUpdate) {
            InvoiceDetailHandler handler = new InvoiceDetailHandler(trigger.new, trigger.old);
            handler.updateInvoiceHandlerForCharges();
        }
    }

    // 2. Follwoing after update code for updating the Invoice paid amount in Invoice
    if(trigger.isAfter && trigger.isUpdate) {
        Set<Id> invIds = new Set<Id>();
        for (cllease__Charge__c childObj : Trigger.new) {
            if(childObj.cllease__Consolidated_Invoice__c != null) {
                invIds.add(childObj.cllease__Consolidated_Invoice__c);
            }
        }
      
        if(invIds.size()>0){
            InvoiceSummaryUtil.InvoiceSummary(invIds);
        }
    }
    
}