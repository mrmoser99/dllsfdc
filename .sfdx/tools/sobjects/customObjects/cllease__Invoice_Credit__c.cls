// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Invoice_Credit__c {
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
    global Date LastActivityDate;
    /* The customer for whom the Invoice Credit is created
    */
    global Account cllease__Account__r;
    /* The customer for whom the Invoice Credit is created
    */
    global Id cllease__Account__c;
    /* User entered comments.
    */
    global String cllease__Comments__c;
    /* Contract for which the Invoice Credit is created
    */
    global cllease__Lease_Account__c cllease__Contract__r;
    /* Contract for which the Invoice Credit is created
    */
    global Id cllease__Contract__c;
    /* Balance available for application towards charges or rent or for refund
    */
    global Decimal cllease__Credit_Balance__c;
    /* The credit amount that is set when an Invoice Credit is created.
    */
    global Decimal cllease__Original_Credit_Amount__c;
    global String cllease__Status__c;
    global cllease__Lease_Payment_Transaction__c Payment_Transaction__r;
    global Id Payment_Transaction__c;
    /* This field differentiate Credit Invoice created for "On Account" or "Auto Rollover"
    */
    global Boolean Is_Auto_Rollover__c;
    global clcommon__Cash_Receipt__c cllease__Credit_Invoice__r;
    global Id cllease__Credit_Invoice__c;
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Event> Events;
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
    global List<cllease__GL_Transaction_Detail__c> GL_Accounting_Entries__r;
    global List<cllease__Invoice_Credit__Share> Shares;
    global List<cllease__Lease_Payment_Transaction__c> cllease__Payment_Transactions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global cllease__Invoice_Credit__c () 
    {
    }
}