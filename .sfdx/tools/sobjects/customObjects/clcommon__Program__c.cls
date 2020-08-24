// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Program__c {
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
    /* This field captures end date of the program after which the program is not available for selection
    */
    global Date clcommon__End_Date__c;
    /* This field captures the set of fees which can be charged by Vendors
    */
    global clcommon__Fee_Set__c clcommon__Fee_Set__r;
    /* This field captures the set of fees which can be charged by Vendors
    */
    global Id clcommon__Fee_Set__c;
    /* This field captures payment method that needs to be applied for applications associated with this program
    */
    global String clcommon__Payment_Method__c;
    /* This field captures the start date from when the program is available
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
    global List<clcommon__Program_Or_Product_Points_Association__c> clcommon__Program_Or_Product_Points_Associations__r;
    global List<clcommon__Program__Share> Shares;
    global List<clcommon__Vendor_Program_Association__c> clcommon__Vendor_Program_Association__r;
    global List<genesis__Applications__c> genesis__Applications__r;
    global List<genesis__Program_Equipment_Master_Association__c> genesis__Program_Equipment_Master_Association__r;
    global List<genesis__Program_Vendor_Rate_Card_Association__c> genesis__Program_Vendor_Rate_Card_Associations__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Program__c () 
    {
    }
}