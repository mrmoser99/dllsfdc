// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Quick_Quote_Equipment__c {
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
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global genesis__Quick_Quotes__c genesis__Quick_Quote__r;
    global Id genesis__Quick_Quote__c;
    global Decimal genesis__Equipment_Cost__c;
    global Decimal genesis__Equipment_Sale_Price__c;
    global String genesis__Equipment_Serial_Number__c;
    global genesis__Equipment_Master__c genesis__Equipment__r;
    global Id genesis__Equipment__c;
    global Decimal genesis__Fees_Amount__c;
    /* This is the  manufacturer or the trade name of the vehicle
    */
    global String genesis__Make__c;
    /* Mileage of the equipment.
    */
    global Double genesis__Mileage__c;
    /* Model of the equipment.
    */
    global String genesis__Model__c;
    global Decimal genesis__Other_Financed_Fees__c;
    /* Stock number of the equipment.
    */
    global String genesis__Stock_Number__c;
    global String genesis__Style__c;
    global Decimal genesis__Tax_Amount__c;
    global Decimal genesis__Total_Dealer_Charges__c;
    global String genesis__VIN_Identification__c;
    global Decimal genesis__Warranty_Amount__c;
    global String genesis__Year_Of_Manufacture__c;
    global clcommon__Collateral__c genesis__Collateral__r;
    global Id genesis__Collateral__c;
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

    global genesis__Quick_Quote_Equipment__c () 
    {
    }
}