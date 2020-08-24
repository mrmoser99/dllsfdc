// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Invoice__c {
    global Id Id;
    global Boolean IsDeleted;
    global String Name;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global Date LastActivityDate;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global cllease__Lease_Account__c LS_Contract__r;
    global Id LS_Contract__c;
    global Decimal Balance_Amount__c;
    global Decimal Balance_Due_Amount__c;
    /* Total of Bill Lines Including Taxes
    */
    global Decimal Billed_Amount__c;
    /* Total of Charge Lines Including Taxes
    */
    global Decimal Charged_Amount__c;
    global String Customer_Name__c;
    global Date File_Generated_On__c;
    global String File_Generated__c;
    global Date Invoice_Due_Date__c;
    global Date Invoice_Period_End_Date__c;
    global Date Invoice_Period_Start_Date__c;
    global Double Number_of_Charges__c;
    global Decimal Paid_Invoice_Amount__c;
    /* Rent + Tax Billed
    */
    global Decimal Payment_Amount_Total__c;
    /* Rent + Service + Estimated Property Tax
    */
    global Decimal Payment_Amount__c;
    /* Rent Tax + Service Tax + Estimated Property Tax Tax
    */
    global Decimal Payment_Sales_Tax__c;
    global Decimal Previous_Balance_Due__c;
    /* Billed_Amount__c + Charged_Amount__c + Previous_Balance_Due__c
    */
    global Decimal Total_Amount_Due__c;
    global Decimal Total_Invoiced_Amount_Due__c;
    /* Total Bill Lines + Total Charge Lines Including Taxes - Total of Charge Waived Including Taxes
    */
    global Decimal Total_Invoiced_Amount__c;
    global String Bill_To_Account__c;
    global String Conga_URL__c;
    global Boolean Invoice_Emailed__c;
    global Decimal Sent_To_PNC_Amount__c;
    global Datetime Sent_To_PNC_Date_Time__c;
    global Boolean Sent_To_PNC__c;
    global String Adjustment_Status__c;
    global Datetime Voided_In_PNC_Date_Time__c;
    global Boolean Voided_In_PNC__c;
    global Datetime Adjusted_in_PNC_Date_Time__c;
    global Boolean Adjusted_in_PNC__c;
    /* If this is true, then the pnc invoice process will expire the invoice in pnc.
    */
    global Boolean Void_In_PNC__c;
    /* Field stores total charge waived amount and it will be subtracted from the total invoice value.
    */
    global Decimal Total_of_Charge_Waived__c;
    /* Internal field used for migration
    */
    global Boolean Migrated__c;
    global List<ActivityHistory> ActivityHistories;
    global List<Adjustment__c> Adjustments__r;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<Bill_Monitor__c> Bill_Monitor__r;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Event> Events;
    global List<Int_PX_Remit__c> Int_PX_Remit__r;
    global List<Invoice__History> Histories;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OpenActivity> OpenActivities;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<clcommon__Consolidated_Invoice__c> Invoices__r;
    global List<cllease__Charge__c> Invoice_Charges__r;
    global List<cllease__Due_Detail_Lines__c> Due_Detail_Lines__r;
    global List<cllease__Lease_Payment_Transaction__c> Invoice_Payments__r;
    global List<cllease__Lease_account_Due_Details__c> Invoice_Bills__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global Invoice__c () 
    {
    }
}