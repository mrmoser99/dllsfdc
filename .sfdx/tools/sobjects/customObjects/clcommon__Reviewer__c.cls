// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Reviewer__c {
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
    global clcommon__Approval_Review_Group__c clcommon__Approval_Review_Group__r;
    global Id clcommon__Approval_Review_Group__c;
    global clcommon__Approval_Authority__c clcommon__Approval_Authority__r;
    global Id clcommon__Approval_Authority__c;
    /* The completion date and time of the review.
    */
    global Datetime clcommon__Completed_Date__c;
    global String clcommon__Conditional_Approval_Status__c;
    /* Maximum approval limit of the user based on defined approval authority
    */
    global String clcommon__Max_Approval_Limit__c;
    /* Minimum approval limit of the user based on defined approval authority
    */
    global String clcommon__Min_Approval_Limit__c;
    global String clcommon__Review_Comments__c;
    /* User who updated the final review status.
    */
    global User clcommon__Reviewed_By__r;
    /* User who updated the final review status.
    */
    global Id clcommon__Reviewed_By__c;
    /* The serial number defined for the reviewer in approval authority.
    */
    global Double clcommon__Serial_Number__c;
    /* The start date and time of the review.
    */
    global Datetime clcommon__Start_Date__c;
    global String clcommon__Status__c;
    global User clcommon__User__r;
    global Id clcommon__User__c;
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

    global clcommon__Reviewer__c () 
    {
    }
}