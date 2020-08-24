// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__EquipmentDetail__c {
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
    global ints__Blackbook_Result__c ints__Blackbook_Result__r;
    global Id ints__Blackbook_Result__c;
    global String ints__Class_Code__c;
    global String ints__Class_Name__c;
    global String ints__Engine_Displacement__c;
    global String ints__Features__c;
    global String ints__Make__c;
    global String ints__Manufacturer__c;
    global String ints__Mileage_Cat__c;
    global String ints__Model_Year__c;
    global String ints__Model__c;
    global String ints__Publish_Date__c;
    global String ints__Style__c;
    global String ints__Transmission__c;
    global Decimal ints__adjusted_finadv__c;
    global Decimal ints__adjusted_retail_avg__c;
    global Decimal ints__adjusted_whole_avg__c;
    global Decimal ints__adjusted_whole_rough__c;
    global Decimal ints__base_finadv__c;
    global String ints__base_hp__c;
    global Decimal ints__base_retail_avg__c;
    global Decimal ints__base_whole_avg__c;
    global Decimal ints__base_whole_rough__c;
    global String ints__cylinders__c;
    global String ints__gcw__c;
    global String ints__gvw__c;
    global Decimal ints__mileage_finadv__c;
    global Decimal ints__mileage_retail_avg__c;
    global Decimal ints__mileage_whole_avg__c;
    global Decimal ints__mileage_whole_rough__c;
    global String ints__model_number__c;
    global Decimal ints__msrp__c;
    global String ints__uvc__c;
    global String ints__vin__c;
    global Boolean genesis__Selected__c;
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
    global List<ints__Add_Deduct_Options__c> ints__Equipment_Add_Deduct_Options__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global ints__EquipmentDetail__c () 
    {
    }
}