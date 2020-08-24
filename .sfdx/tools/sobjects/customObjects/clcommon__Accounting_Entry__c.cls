// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Accounting_Entry__c {
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
    global clcommon__Business_Event__c clcommon__Business_Event__r;
    global Id clcommon__Business_Event__c;
    global Double clcommon__Credit_Amount__c;
    /* Chart of Account which will be credited for given credit amount.
    */
    global clcommon__Chart_Of_Account__c clcommon__Credit_GL_Account__r;
    /* Chart of Account which will be credited for given credit amount.
    */
    global Id clcommon__Credit_GL_Account__c;
    global Double clcommon__Debit_Amount__c;
    /* Chart of account which will be debited for debit amount.
    */
    global clcommon__Chart_Of_Account__c clcommon__Debit_GL_Account__r;
    /* Chart of account which will be debited for debit amount.
    */
    global Id clcommon__Debit_GL_Account__c;
    global Date clcommon__Transaction_Creation_Date__c;
    global Date clcommon__Transaction_Date__c;
    global String clcommon__External_Id__c;
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
    global List<clcommon__Accounting_Entry__History> Histories;
    global List<clcommon__Accounting_Entry__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global clcommon__Accounting_Entry__c () 
    {
    }
}