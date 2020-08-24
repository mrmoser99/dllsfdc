// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Rule__c {
    global Id Id;
    global SObject Owner;
    global Id OwnerId;
    global Boolean IsDeleted;
    global String Name;
    global RecordType RecordType;
    global Id RecordTypeId;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global Boolean genesis__Enabled__c;
    /* This field captures the evaluation expression for  computing logical operations between respective rule criterias
    */
    global String genesis__Evaluation_Expression__c;
    global genesis__Loan_Product__c genesis__Lending_Product__r;
    global Id genesis__Lending_Product__c;
    global String genesis__Message_failure__c;
    global String genesis__Message_success__c;
    global String genesis__Object_Type__c;
    global Double genesis__Total_Actions__c;
    global Double genesis__Total_Criteria__c;
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
    global List<genesis__Application_Rule_Setup__c> genesis__Application_Rule_Setup__r;
    global List<genesis__Checklist__c> genesis__Checklist__r;
    global List<genesis__Product_Rule_Association__c> genesis__Product_Rule_Association__r;
    global List<genesis__Purpose_Rule_Association__c> genesis__Purpose_Rule_Associations__r;
    global List<genesis__RuleAction__c> genesis__Rule_Actions__r;
    global List<genesis__RuleCriteria__c> genesis__Rule_Criteria__r;
    global List<genesis__Rule__History> Histories;
    global List<genesis__Rule__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Rule__c () 
    {
    }
}