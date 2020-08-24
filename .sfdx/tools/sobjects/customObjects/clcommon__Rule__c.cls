// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Rule__c {
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
    global Boolean clcommon__Enabled__c;
    global String clcommon__Object_Type__c;
    global String clcommon__Rule_Json__c;
    global clcommon__Rule_Set__c clcommon__Rule_Set__r;
    global Id clcommon__Rule_Set__c;
    global clcommon__Document_Definition__c clcommon__Document_Definition__r;
    global Id clcommon__Document_Definition__c;
    /* This field used for Rule API to store Parent Record Id
    */
    global String clcommon__Parent_Record_Id__c;
    /* This field is a self lookup on Rule object to differentiate between parent rules and child rules.
    */
    global clcommon__Rule__c clcommon__Parent_Rule__r;
    /* This field is a self lookup on Rule object to differentiate between parent rules and child rules.
    */
    global Id clcommon__Parent_Rule__c;
    /* This field indicates the rules' priority and the order in which rules are executed with 1 being the highest priority and is executed first.
    */
    global Double clcommon__Rule_Priority__c;
    global String clcommon__External_ID__c;
    /* This field refers to the Points Setup object
    */
    global clcommon__Points_Setup__c clcommon__Points_Setup__r;
    /* This field refers to the Points Setup object
    */
    global Id clcommon__Points_Setup__c;
    /* This field refers to Department Members object.
    */
    global genesis__Departments_Members__c genesis__Department_Members__r;
    /* This field refers to Department Members object.
    */
    global Id genesis__Department_Members__c;
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
    global List<clcommon__Action_Queue__c> clcommon__Action_Queue__r;
    global List<clcommon__Approval_Definition__c> clcommon__Approval_Definition__r;
    global List<clcommon__Rule__Share> Shares;
    global List<clcommon__Rule__c> clcommon__Rule__r;
    global List<genesis__Account_Scorecard_Result__c> genesis__Account_Scorecard_Result__r;
    global List<genesis__Application_s_Scorecard__c> genesis__Application_Scorecard_Result__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Rule__c () 
    {
    }
}