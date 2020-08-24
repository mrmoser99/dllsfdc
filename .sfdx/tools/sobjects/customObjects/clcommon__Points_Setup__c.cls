// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Points_Setup__c {
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
    /* Select Calculation Set for the calculation of Points.
    */
    global clcommon__Calculation_Set__c clcommon__Calculation_Basis__r;
    /* Select Calculation Set for the calculation of Points.
    */
    global Id clcommon__Calculation_Basis__c;
    /* Select the disbursement basis value from the drop down.
    */
    global String clcommon__Disbursement_Basis__c;
    /* Select checkbox for enabling Points calculation.
    */
    global Boolean clcommon__Enabled__c;
    /* Select the date up to which the points will be applicable.
    */
    global Date clcommon__End_Date__c;
    /* Select type of Points which needs to be configured.
    */
    global String clcommon__Points_Type__c;
    /* This field is the actual points value that needs to be applied.
    */
    global Double clcommon__Points__c;
    /* Select the start date from when the points will be applicable.
    */
    global Date clcommon__Start_Date__c;
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
    global List<clcommon__Points_Setup__Share> Shares;
    global List<clcommon__Points__c> genesis__Points__r;
    global List<clcommon__Program_Or_Product_Points_Association__c> clcommon__Program_Or_Product_Points_Associations__r;
    global List<clcommon__Rule__c> clcommon__Rules__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Points_Setup__c () 
    {
    }
}