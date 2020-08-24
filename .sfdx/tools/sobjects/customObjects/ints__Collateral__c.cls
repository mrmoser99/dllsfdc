// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__Collateral__c {
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
    global String ints__Address_Line1__c;
    global String ints__Address_Line2__c;
    global Double ints__Apartment_Suite_Number__c;
    global String ints__Body__c;
    global String ints__City__c;
    global String ints__Company__c;
    global String ints__Country__c;
    global String ints__County__c;
    global Date ints__Effective_Date__c;
    global Date ints__Expiry_Date__c;
    global Boolean ints__Flood_Zone_Flag__c;
    global Decimal ints__Insured_Amount__c;
    global Double ints__Length__c;
    global String ints__Make__c;
    global String ints__Model__c;
    global String ints__Phone__c;
    global String ints__Policy_Number__c;
    global Decimal ints__Premium_Amount__c;
    global String ints__Purchase_Order_Number__c;
    global String ints__State__c;
    global String ints__VIN__c;
    global Double ints__Weight__c;
    global Double ints__Width__c;
    global Double ints__Zip__c;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global String ints__External_ID__c;
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
    global List<ints__Collateral_Valuation__c> ints__Collateral_Valuation__r;
    global List<ints__Collateral__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global ints__Collateral__c () 
    {
    }
}