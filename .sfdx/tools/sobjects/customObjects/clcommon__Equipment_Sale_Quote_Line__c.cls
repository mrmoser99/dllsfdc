// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Equipment_Sale_Quote_Line__c {
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
    global clcommon__Equipment_Sale_Quote__c clcommon__Equipment_Sale_Quote__r;
    global Id clcommon__Equipment_Sale_Quote__c;
    global clcommon__Due_Details__c clcommon__Bill__r;
    global Id clcommon__Bill__c;
    global clcommon__Collateral__c clcommon__Collateral__r;
    global Id clcommon__Collateral__c;
    global clcommon__Company__c clcommon__Company__r;
    global Id clcommon__Company__c;
    global Decimal clcommon__Equipment_Cost_of_Sale__c;
    global Decimal clcommon__Equipment_NBV__c;
    global Double clcommon__Equipment_Rate_Factor__c;
    global Decimal clcommon__Equipment_Sale_Amount__c;
    global Decimal clcommon__Equipment_Sale_Loss__c;
    global Decimal clcommon__Equipment_Sale_Profit__c;
    global Decimal clcommon__Equipment_Tax_Amount__c;
    global Double clcommon__Equipment_Tax_Rate__c;
    /* This field represents the VAT Code used for the Asset Sale transaction. The VAT Rate is derived based on the VAT Rate Setup.
    */
    global clcommon__VAT_Rate_Setup__c clcommon__VAT_Code__r;
    /* This field represents the VAT Code used for the Asset Sale transaction. The VAT Rate is derived based on the VAT Rate Setup.
    */
    global Id clcommon__VAT_Code__c;
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
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Equipment_Sale_Quote_Line__c () 
    {
    }
}