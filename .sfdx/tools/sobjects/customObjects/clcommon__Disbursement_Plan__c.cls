// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Disbursement_Plan__c {
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
    /* This field will indicate the disbursement amount.
    */
    global Double clcommon__Amount__c;
    /* Every contractual type DP will have a child "current" DP.All the calculations will happen on latest un-archived current DP.
    */
    global clcommon__Disbursement_Plan__c clcommon__Disbursement_Plan__r;
    /* Every contractual type DP will have a child "current" DP.All the calculations will happen on latest un-archived current DP.
    */
    global Id clcommon__Disbursement_Plan__c;
    /* This field will indicate the due day .
    */
    global Double clcommon__Due_Day__c;
    /* This field will indicate the frequency If same disbursement needs to  happen at certain frequency.
    */
    global String clcommon__Frequency__c;
    /* This field will indicate whether the record is archived.
    */
    global Boolean clcommon__Is_Archived__c;
    /* The Date on which disbursement will happen.
    */
    global Date clcommon__Start_Date__c;
    /* This field will indicate the term If same disbursement needs to happen for certain terms.
    */
    global Double clcommon__Terms__c;
    /* This field will represent the disbursement type whether record is created at the time of disbursement or modified later.
    */
    global String clcommon__Type__c;
    global String clcommon__External_Id__c;
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
    global List<clcommon__Disbursement_Plan__Share> Shares;
    global List<clcommon__Disbursement_Plan__c> clcommon__Disbursement_Plans__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Disbursement_Plan__c () 
    {
    }
}