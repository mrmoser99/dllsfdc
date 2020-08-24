// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Portal_Status__c {
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
    /* This filed stores the channel via which the record is updated/ created.
    */
    global String clcommon__Channel__c;
    /* This field store the completion status of the state.
    */
    global Boolean clcommon__Completed__c;
    /* This field stores the end date time of the state.
    */
    global Datetime clcommon__End_Date_Time__c;
    /* This field stores the application Id to which this state belongs to.
    */
    global String clcommon__External_Id__c;
    /* This field stores the navigation structure Id of the dashboard  to which  this state belongs to.
    */
    global String clcommon__Portal_Id__c;
    /* Specify the order of execution of the UI state.
    */
    global String clcommon__Sequence__c;
    /* This field stores the start date time of the state.
    */
    global Datetime clcommon__Start_Date_Time__c;
    /* This field is the lookup to the Portal State Configuration to store sub state.
    */
    global clcommon__Portal_State_Configuration__c clcommon__Sub_State__r;
    /* This field is the lookup to the Portal State Configuration to store sub state.
    */
    global Id clcommon__Sub_State__c;
    /* This field sores the Id of the user who modified the record.
    */
    global String clcommon__User_Information__c;
    /* This field stores Portal variables.
    */
    global String clcommon__Variables__c;
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
    global List<clcommon__Portal_Status__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Portal_Status__c () 
    {
    }
}