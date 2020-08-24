// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class APXT_BPM__Scheduled_Conductor_History__c {
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
    global APXT_BPM__Conductor__c APXT_BPM__Conga_Conductor__r;
    global Id APXT_BPM__Conga_Conductor__c;
    global String APXT_BPM__Dashboard_Link__c;
    global Datetime APXT_BPM__Date__c;
    global String APXT_BPM__Description__c;
    global Double APXT_BPM__Number_of_Failures__c;
    global Double APXT_BPM__Number_of_Service_Events__c;
    global Double APXT_BPM__Number_of_Successes__c;
    global String APXT_BPM__Output_File_Link__c;
    global User APXT_BPM__Ran_as__r;
    global Id APXT_BPM__Ran_as__c;
    global Double APXT_BPM__Total_Number_of_Records__c;
    global List<APXT_BPM__Scheduled_Conductor_History__Share> Shares;
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
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global APXT_BPM__Scheduled_Conductor_History__c () 
    {
    }
}