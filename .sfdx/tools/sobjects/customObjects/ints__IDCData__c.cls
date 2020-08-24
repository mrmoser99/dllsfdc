// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__IDCData__c {
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
    global String ints__AccountNumber__c;
    global String ints__Address1__c;
    global String ints__Address2__c;
    global String ints__Address__c;
    global String ints__BillingDate__c;
    global String ints__Country__c;
    global String ints__DateOfBirth__c;
    global String ints__DateOfExpiry__c;
    global String ints__DateOfIssue__c;
    global String ints__DocumentNumber__c;
    global String ints__Gender__c;
    global String ints__Givenname__c;
    global String ints__LivePhoto__c;
    global String ints__Mrz1__c;
    global String ints__Mrz2__c;
    global String ints__Mrz3__c;
    global String ints__Name__c;
    global String ints__NationalIdentificationNumber__c;
    global String ints__PassPhoto__c;
    global String ints__PlaceOfBirth__c;
    global String ints__Postcode__c;
    global String ints__Residence__c;
    global String ints__SignDate__c;
    global String ints__State__c;
    global String ints__Surname__c;
    global String ints__ValidFromDate__c;
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
    global List<ints__IDCClassificationResult__c> ints__IDCClassificationResults__r;
    global List<ints__IDCData__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global ints__IDCData__c () 
    {
    }
}