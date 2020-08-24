// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class staging__Interface_Repayment_Schedule__c {
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
    /* Principal Balance
    */
    global Double staging__Balance__c;
    global String staging__Contract_External_ID__c;
    global Double staging__Due_Amount__c;
    /* The date on which the loan payment is due.
    */
    global Date staging__Due_Date__c;
    /* Due Interest
    */
    global Double staging__Due_Interest__c;
    /* Due Principal
    */
    global Double staging__Due_Principal__c;
    global String staging__External_ID__c;
    global Boolean staging__Is_Billed__c;
    /* Checked if the scheduled payment is/was completely paid
    */
    global Boolean staging__Is_Paid__c;
    /* Indicates if this scheduled installment is only partially paid.
    */
    global Boolean staging__Is_Partially_Paid__c;
    global String staging__Source_ID__c;
    global String staging__Source_Name__c;
    global Boolean staging__Sync_Processed__c;
    /* This represents the amount paid by the borrower towards this repayment schedule.
    */
    global Double staging__Transaction_Amount__c;
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
    global List<staging__Interface_Repayment_Schedule__History> Histories;
    global List<staging__Interface_Repayment_Schedule__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global staging__Interface_Repayment_Schedule__c () 
    {
    }
}