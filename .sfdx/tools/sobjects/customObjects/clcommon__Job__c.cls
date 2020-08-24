// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Job__c {
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
    global clcommon__DAG_Schedule__c clcommon__DAG__r;
    global Id clcommon__DAG__c;
    global Double clcommon__Batch_Size__c;
    global String clcommon__Class__c;
    /* Indicates whether this job should be ignored in the flow or not.
    */
    global Boolean clcommon__Disabled__c;
    global String clcommon__Fail_Type__c;
    global String clcommon__Label__c;
    /* Representative example of a query that the job executes. User may copy this into User Query  field and modify.
    */
    global String clcommon__Last_Used_Query__c;
    global Double clcommon__Number_Of_Instances__c;
    global Boolean clcommon__Pipelined__c;
    /* This query can be modified by the user.
    */
    global String clcommon__Query__c;
    /* If this field is checked then multiple instances of the Job will not be executed.
    */
    global Boolean clcommon__Abort_Mutliple_Instances__c;
    /* If custom query class is provided then query from the class will be taken instead of default query. Custom class need to implement the IBatchJobQuery interface.
    */
    global String clcommon__Custom_Query_Class__c;
    global String clcommon__External_Id__c;
    /* When multi threading is enabled in the job then system expect user to provide API in this field to reduce the stress on DAG by taking the responsibility of bucketize the job scope.
    */
    global String clcommon__Thread_Api_Name__c;
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
    global List<clcommon__Job_Dependency__c> clcommon__Job_Dependencies_2__r;
    global List<clcommon__Job_Dependency__c> clcommon__Job_Dependencies__r;
    global List<clcommon__Job_Logging__c> clcommon__Job_Loggings__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Job__c () 
    {
    }
}