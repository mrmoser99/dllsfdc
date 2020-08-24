// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cnotify__Configuration__c {
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
    global String cnotify__After_Status__c;
    global String cnotify__Before_Status__c;
    /* This value indicates the number of days (before or after) the notification must be sent.
    */
    global Double cnotify__Day__c;
    global Boolean cnotify__Email_Notification__c;
    /* This is the event for which the notification will be sent.
    */
    global String cnotify__Event__c;
    /* This will not consider Before Status value of status field. Only change on Status field's value will be tracked.
    */
    global Boolean cnotify__Ignore_Before_Status__c;
    global String cnotify__Object__c;
    global String cnotify__Recipient_Field_Name__c;
    global String cnotify__Status_Field_API_Name__c;
    global String cnotify__Text_Message__c;
    global Boolean cnotify__Text_Notification__c;
    global Boolean cnotify__Trigger_Based_Configuration__c;
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
    global List<cnotify__Configuration__Share> Shares;
    global List<cnotify__Notification__c> cnotify__Notifications__r;
    global List<collect__Collection_Activity__c> collect__Collection_Activities__r;
    global List<collect__Collection_Configuration_Actions__c> collect__Collection_Configuration_Actions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cnotify__Configuration__c () 
    {
    }
}