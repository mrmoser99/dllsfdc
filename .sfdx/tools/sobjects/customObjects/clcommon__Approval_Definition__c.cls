// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Approval_Definition__c {
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
    /* Represents if the approval definition is active or not
    */
    global Boolean clcommon__Active__c;
    /* The approval expression for the conditional approval or approvals that require some combinations of reviewers.
    */
    global String clcommon__Approval_Expression__c;
    /* Represents the expression against which reviewers are filtered
    */
    global String clcommon__Authority_Evaluation_Expression__c;
    /* Drives the process by which approval will be routed and executed
    */
    global String clcommon__Cadence__c;
    /* The entry criteria for the approval to be trigger.
    */
    global clcommon__Rule__c clcommon__Entry_Criteria__r;
    /* The entry criteria for the approval to be trigger.
    */
    global Id clcommon__Entry_Criteria__c;
    /* The number of approvers required to approve
    */
    global Double clcommon__Number_Of_Approvers__c;
    /* Represents the SObject name for which approval is defined
    */
    global String clcommon__Primary_Object__c;
    /* Represents how the reviewers will be selected on the approval
    */
    global String clcommon__Select_Reviewer__c;
    /* Defines how the reviewer groups will be generated for the approval
    */
    global String clcommon__Type__c;
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
    global List<clcommon__Approval_Authority__c> clcommon__Approval_Authority__r;
    global List<clcommon__Approval_Definition__Share> Shares;
    global List<clcommon__Approval_Instance__c> clcommon__Approval_Instances__r;
    global List<clcommon__Execution_Criteria__c> clcommon__Approval_Authority_Criteria__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Approval_Definition__c () 
    {
    }
}