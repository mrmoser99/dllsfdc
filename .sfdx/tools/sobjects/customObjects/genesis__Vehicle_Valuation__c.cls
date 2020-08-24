// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Vehicle_Valuation__c {
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
    global String genesis__Asset_Type__c;
    global Boolean genesis__Enabled_Flag__c;
    /* Vehicle Identification Number.
    */
    global String genesis__Identification_number__c;
    /* This is the manufacturer or the trade name of the vehicle.
    */
    global String genesis__Make__c;
    global Double genesis__Mileage__c;
    global String genesis__Model__c;
    global Decimal genesis__Retail_Average_Adjusted__c;
    global Decimal genesis__Retail_Average_Base_Price__c;
    global Decimal genesis__Retail_Average_Mileage_Adjustment__c;
    global String genesis__Style__c;
    /* Valuation Date of Vehicle
    */
    global Date genesis__Valuation_Date__c;
    /* Source from where the asset valuation is done.
    */
    global String genesis__Valuation_Source__c;
    global Decimal genesis__Wholesale_Average_Adjusted__c;
    global Decimal genesis__Wholesale_Average_Base_Price__c;
    global Decimal genesis__Wholesale_Average_Mileage_Adjustment__c;
    global Decimal genesis__Wholesale_Rough_Adjusted__c;
    global Decimal genesis__Wholesale_Rough_Base_Price__c;
    global Decimal genesis__Wholesale_Rough_Mileage_Adjustment__c;
    /* Year of vehicle.
    */
    global Double genesis__Year__c;
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
    global List<genesis__Application_Equipment__c> genesis__Equipments__r;
    global List<genesis__Vehicle_Valuation__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Vehicle_Valuation__c () 
    {
    }
}