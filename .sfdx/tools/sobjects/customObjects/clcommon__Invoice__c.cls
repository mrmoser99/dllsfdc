// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Invoice__c {
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
    /* This field represents the bill group of receivables associated with invoices and will be populated by the system
    */
    global clcommon__Bill_Group__c clcommon__Bill_Group__r;
    /* This field represents the bill group of receivables associated with invoices and will be populated by the system
    */
    global Id clcommon__Bill_Group__c;
    /* Address on which invoice to be sent
    */
    global clcommon__Address__c clcommon__Billing_Address__r;
    /* Address on which invoice to be sent
    */
    global Id clcommon__Billing_Address__c;
    /* Type of Currency
    */
    global String clcommon__Currency_Code__c;
    /* Invoice to be paid prior to this date
    */
    global Date clcommon__Due_Date__c;
    global Decimal clcommon__Original_Amount__c;
    global String clcommon__Reason_For_Cancellation__c;
    global String clcommon__Receivables__c;
    global String clcommon__Status__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<clcommon__Invoice_History__c> clcommon__Invoice_Histories__r;
    global List<clcommon__Sample_Contract__c> clcommon__Receivables__r;
    global List<cllease__Charge__c> cllease__Charges__r;
    global List<cllease__Lease_account_Due_Details__c> cllease__Bills__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Invoice__c () 
    {
    }
}