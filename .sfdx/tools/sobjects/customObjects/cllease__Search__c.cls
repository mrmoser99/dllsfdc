// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Search__c {
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
    global Account cllease__Account__r;
    global Id cllease__Account__c;
    global cllease__Office_Name__c cllease__Branch__r;
    global Id cllease__Branch__c;
    global Datetime cllease__Date__c;
    global String cllease__Day_Operation__c;
    global String cllease__Document_Number__c;
    global Datetime cllease__End_Date__c;
    global String cllease__Interface_Name__c;
    global String cllease__Interface_batch_size__c;
    global String cllease__LeaseApplicationNumber__c;
    global cllease__Lease_Account__c cllease__Lease_Account__r;
    global Id cllease__Lease_Account__c;
    global cllease__Lease_Product__c cllease__Lease_Product__r;
    global Id cllease__Lease_Product__c;
    global String cllease__Report_Type__c;
    global String cllease__Report__c;
    global Datetime cllease__Start_Date__c;
    global cllease__Transaction_Source__c cllease__Transaction_Source__r;
    global Id cllease__Transaction_Source__c;
    global User cllease__User__r;
    global Id cllease__User__c;
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
    global List<cllease__Search__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Search__c () 
    {
    }
}