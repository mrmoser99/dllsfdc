// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Approval_Authority__c {
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
    global clcommon__Approval_Definition__c clcommon__Approval_Definition__r;
    global Id clcommon__Approval_Definition__c;
    global Boolean clcommon__Active__c;
    /* Maximum value that the user has authority to combine with other user’s approval authority to approve
    */
    global String clcommon__Max_Combined_Limit__c;
    /* Maximum value that the user has authority to independently approve.
    */
    global String clcommon__Max_Individual_Limit__c;
    /* Minimum value that the user has authority to combine with other user’s approval authority to approve
    */
    global String clcommon__Min_Combined_Limit__c;
    /* Minimum value that the user has authority to independently approve.
    */
    global String clcommon__Min_Individual_Limit__c;
    /* Record number
    */
    global Double clcommon__Serial_Number__c;
    global User clcommon__User__r;
    global Id clcommon__User__c;
    global String clcommon__External_ID__c;
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
    global List<clcommon__Reviewer__c> clcommon__Reviewer__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Approval_Authority__c () 
    {
    }
}