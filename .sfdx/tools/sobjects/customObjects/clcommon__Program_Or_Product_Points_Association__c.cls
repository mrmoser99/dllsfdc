// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Program_Or_Product_Points_Association__c {
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
    /* This field points to Accounts of type 'Vendor, Manufacturer, Broker'.
    */
    global Account clcommon__Accounts_Payable__r;
    /* This field points to Accounts of type 'Vendor, Manufacturer, Broker'.
    */
    global Id clcommon__Accounts_Payable__c;
    /* This field points to the CL Product.
    */
    global clcommon__CL_Product__c clcommon__CL_Product__r;
    /* This field points to the CL Product.
    */
    global Id clcommon__CL_Product__c;
    /* This field points to the Points Setup.
    */
    global clcommon__Points_Setup__c clcommon__Points_Setup__r;
    /* This field points to the Points Setup.
    */
    global Id clcommon__Points_Setup__c;
    /* This field points to the Vendor Program.
    */
    global clcommon__Program__c clcommon__Program__r;
    /* This field points to the Vendor Program.
    */
    global Id clcommon__Program__c;
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
    global List<clcommon__Program_Or_Product_Points_Association__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Program_Or_Product_Points_Association__c () 
    {
    }
}