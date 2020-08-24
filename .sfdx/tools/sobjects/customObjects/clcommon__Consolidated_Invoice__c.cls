// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Consolidated_Invoice__c {
    global Id Id;
    global SObject Owner;
    global Id OwnerId;
    global Boolean IsDeleted;
    global String Name;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    /* Customer for which invoice is generated
    */
    global Account clcommon__Account__r;
    /* Customer for which invoice is generated
    */
    global Id clcommon__Account__c;
    /* Due amount for invoice
    */
    global Decimal clcommon__Balance_Amount__c;
    /* Address for the Invoice
    */
    global String clcommon__Billing_Address__c;
    /* This field represents the bill group of receivables associated with invoices and will be populated by the system
    */
    global clcommon__Billing_Group__c clcommon__Billing_Group__r;
    /* This field represents the bill group of receivables associated with invoices and will be populated by the system
    */
    global Id clcommon__Billing_Group__c;
    /* Customer for which invoice is generated
    */
    global Contact clcommon__Contact__r;
    /* Customer for which invoice is generated
    */
    global Id clcommon__Contact__c;
    /* Type of Currency
    */
    global String clcommon__Currency_Code__c;
    /* Invoice to be paid prior to this date
    */
    global Date clcommon__Due_Date__c;
    /* Total amount to be paid
    */
    global Decimal clcommon__Original_Amount__c;
    global String clcommon__Reason_For_Cancellation__c;
    global String clcommon__Status__c;
    global Datetime Adjusted_in_PNC_Date_Time__c;
    global Boolean Adjusted_in_PNC__c;
    global String Adjustment_Status__c;
    global Decimal Balance_Due_Amount__c;
    global Decimal Balance_Invoice_Amount__c;
    global Decimal Billed_Amount__c;
    global Decimal Charged_Amount__c;
    global String Conga_URL__c;
    global String Customer_Name__c;
    global Decimal Fee_Amount_Billed__c;
    global Decimal Fee_Billed_Total_Amount__c;
    global Decimal Fee_Tax_Amount_Billed__c;
    global Date File_Generated_On__c;
    global String File_Generated__c;
    /* Internal used for migration mapping will be deleted later after migration
    */
    global Invoice__c InvoiceOLD__r;
    /* Internal used for migration mapping will be deleted later after migration
    */
    global Id InvoiceOLD__c;
    global Date Invoice_Due_Date__c;
    global Boolean Invoice_Emailed__c;
    global Date Invoice_Period_End_Date__c;
    global Date Invoice_Period_Start_Date__c;
    global cllease__Lease_Account__c LS_Contract__r;
    global Id LS_Contract__c;
    global Double Number_of_Charges__c;
    global Decimal Paid_Invoice_Amount__c;
    /* Rent Amount Billed + Rent Tax Amount Billed
    */
    global Decimal Payment_Amount_Total__c;
    /* Rent Total + Service Fee Total
    */
    global Decimal Payment_Amount__c;
    /* Rent Tax Total + Service Fee Tax Total
    */
    global Decimal Payment_Sales_Tax__c;
    global Decimal Previous_Balance_Due__c;
    global Decimal Rent_Billed_Total__c;
    global Decimal Rent_Billed__c;
    global Decimal Rent_Tax_Billed__c;
    global Decimal Sent_To_PNC_Amount__c;
    global Datetime Sent_To_PNC_Date_Time__c;
    global Boolean Sent_To_PNC__c;
    global Decimal Service_Fee_Billed__c;
    global Decimal Service_Tax_Billed__c;
    global Decimal Total_Amount_Due__c;
    global Decimal Total_Bill_Paid_Amount__c;
    global Decimal Total_Charge_Paid_Amount__c;
    global Decimal Total_Fee_Paid__c;
    global Decimal Total_Fee_Tax_Paid__c;
    global Decimal Total_Invoiced_Amount_Due__c;
    global Decimal Total_Invoiced_Amount__c;
    global Decimal Total_Rent_Paid__c;
    global Decimal Total_Rent_Tax_Paid__c;
    global Decimal Total_of_Charge_Waived__c;
    global Boolean Update_Bill_Balance__c;
    global Boolean Update_Charge_Balance__c;
    /* If this is true, then the pnc invoice process will expire the invoice in pnc.
    */
    global Boolean Void_In_PNC__c;
    global Datetime Voided_In_PNC_Date_Time__c;
    global Boolean Voided_In_PNC__c;
    global String BillToContactId__c;
    global Boolean Dummy_Field__c;
    global List<Adjustment__c> Adjustments__r;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Int_PX_Remit__c> Int_PX_Remit__r;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<clcommon__Consolidated_Invoice_History__c> clcommon__Consolidated_Invoice_Histories__r;
    global List<clcommon__Consolidated_Invoice__History> Histories;
    global List<clcommon__Consolidated_Invoice__Share> Shares;
    global List<clcommon__Sample_Contract__c> clcommon__Receivables__r;
    global List<cllease__Charge__c> cllease__Charges__r;
    global List<cllease__Due_Detail_Lines__c> Due_Detail_Lines__r;
    global List<cllease__Lease_Payment_Transaction__c> Payment_Transactions__r;
    global List<cllease__Lease_account_Due_Details__c> cllease__Bills__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Consolidated_Invoice__c () 
    {
    }
}