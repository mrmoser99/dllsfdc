// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Action_Queue__c {
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
    /* Field stores user given name of an action.
    */
    global String clcommon__Action_Name__c;
    /* Field represents type of action configured in this rule.
    */
    global String clcommon__Action_Type__c;
    /* Field stores JSON representation of additional field those should be passed to class which is being executed.
    */
    global String clcommon__Additional_Parameters__c;
    /* Field stores name of the apex class that should be executed.
    */
    global String clcommon__ApexClass_Name__c;
    /* Field stores type of Apex Class. For ex: Apex,REST,Batch etc. Currently, only Apex is supported.
    */
    global String clcommon__Apexclass_Type__c;
    /* Field stores Async Apex Job Id. If empty and status is 'Open', that means this action is not executed yet. Field is updated by system once action is enqueued for execution.
    */
    global String clcommon__AsycnJobId__c;
    /* Field stores Id of record on which this action is being executed.
    */
    global String clcommon__Input_Id__c;
    /* Field stores success/failure message for action execution
    */
    global String clcommon__Message__c;
    /* Field represents execution priority of this action. Actions are executed in ascending priority.
    */
    global Double clcommon__Priority__c;
    global clcommon__Rule__c clcommon__Rule__r;
    global Id clcommon__Rule__c;
    /* Field represents execution status of an action.
    */
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
    global List<clcommon__Action_Queue__History> Histories;
    global List<clcommon__Action_Queue__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Action_Queue__c () 
    {
    }
}