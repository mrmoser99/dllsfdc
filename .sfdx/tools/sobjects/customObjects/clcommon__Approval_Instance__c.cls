// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Approval_Instance__c {
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
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    /* Represents the group that does the review
    */
    global clcommon__Approval_Review_Group__c clcommon__Approval_Review_Group__r;
    /* Represents the group that does the review
    */
    global Id clcommon__Approval_Review_Group__c;
    /* Drives the process by which approval instance is routed and executed
    */
    global String clcommon__Cadence__c;
    /* The date and time of the approval process completion.
    */
    global Datetime clcommon__Completed_Date__c;
    global String clcommon__Entry_Criteria_Result__c;
    global String clcommon__Name__c;
    /* Represents the SObject name for which approval instance created
    */
    global String clcommon__Primary_Object__c;
    /* Defines how the reviewers in a review group will be selected
    */
    global String clcommon__Select_Reviewer__c;
    /* The date and time when the approval review started, that is, when the approval review group is selected for the first time.
    */
    global Datetime clcommon__Start_Date__c;
    global String clcommon__Status__c;
    /* Represents how reviewer groups are generated for the approval instance
    */
    global String clcommon__Type__c;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
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
    global List<clcommon__Approval_Review_Group__c> clcommon__Reviewer_Group__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Approval_Instance__c () 
    {
    }
}