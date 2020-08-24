// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Property__c {
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
    global String genesis__Address_1__c;
    global String genesis__Address_2__c;
    global String genesis__Address__c;
    global Date genesis__Analysis_End_Date__c;
    global Date genesis__Analysis_Start_Date__c;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global Double genesis__Area_Sq_Ft__c;
    global String genesis__City__c;
    global String genesis__Country__c;
    global String genesis__Name__c;
    global Boolean genesis__Primary__c;
    global String genesis__Property_Type__c;
    global Double genesis__Purchase_Price__c;
    global String genesis__State__c;
    global Double genesis__Vacancy_Expense__c;
    global String genesis__Zipcode__c;
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
    global List<genesis__Cash_Flow_Summary__c> genesis__Cash_Flow_Summary__r;
    global List<genesis__Collateral_Occupancy__c> genesis__Collateral_Occupancy__r;
    global List<genesis__Property_Expense__c> genesis__Property_Expenses__r;
    global List<genesis__Property_Income__c> genesis__Property_Incomes__r;
    global List<genesis__Property__Share> Shares;
    global List<genesis__Tenant__c> genesis__Tenants__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Property__c () 
    {
    }
}