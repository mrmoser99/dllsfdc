// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Equipment_Master__c {
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
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global Boolean genesis__Available_To_Lease_Flag__c;
    global Boolean genesis__Enabled__c;
    global String genesis__Equipment_Serial_Number__c;
    global String genesis__Equipment_Sub_Type_Picklist__c;
    global String genesis__Equipment_Sub_Type__c;
    global String genesis__Equipment_Type__c;
    global String genesis__License_Plate_Number__c;
    global String genesis__Make__c;
    global Double genesis__Mileage__c;
    global String genesis__Model__c;
    global String genesis__Status__c;
    global String genesis__Stock_Number__c;
    global String genesis__Style__c;
    global String genesis__VIN_Identification__c;
    global String genesis__Year_Of_Manufacture__c;
    global String Asset_Type_ID__c;
    global String Asset_Type_Name__c;
    global String Color_Type__c;
    global String Country__c;
    global Decimal MSRP__c;
    global String Major_Asset_Type__c;
    global String Manufacturer__c;
    global String Master_Asset_Type_ID__c;
    global String Master_Asset_Type__c;
    global String Object_Category_ID__c;
    global String Object_Category_Name__c;
    global String Product_Type__c;
    global Double Economic_Life__c;
    global clcommon__Collateral_Category__c genesis__Collateral_Category__r;
    global Id genesis__Collateral_Category__c;
    global clcommon__Collateral_Type__c genesis__Collateral_Type__r;
    global Id genesis__Collateral_Type__c;
    global String genesis__External_ID__c;
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
    global List<clcommon__Collateral__c> genesis__Collaterals__r;
    global List<genesis__Application_Equipment__c> genesis__Application_Equipments__r;
    global List<genesis__Equipment_Fee_Definition__c> genesis__Equipment_Fee_Definitions__r;
    global List<genesis__Equipment_Master__Share> Shares;
    global List<genesis__Program_Equipment_Master_Association__c> genesis__Program_Equipment_Master_Association__r;
    global List<genesis__Quick_Quote_Equipment__c> genesis__Quick_Quote_Equipments__r;
    global List<ints__Blackbook_Result__c> genesis__Blackbook_Result__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Equipment_Master__c () 
    {
    }
}