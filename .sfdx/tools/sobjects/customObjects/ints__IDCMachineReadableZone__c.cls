// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__IDCMachineReadableZone__c {
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
    global Boolean ints__CompositeCheckDigitVerified__c;
    global String ints__CompositeCheckDigit__c;
    global String ints__DateOfBirthCheckDigit__c;
    global Boolean ints__DateOfBirthVerified__c;
    global String ints__DateOfBirth__c;
    global String ints__DateOfExpiryCheckDigit__c;
    global Boolean ints__DateOfExpiryVerified__c;
    global String ints__DateOfExpiry__c;
    global String ints__DocumentNumberCheckDigit__c;
    global Boolean ints__DocumentNumberVerified__c;
    global String ints__DocumentNumber__c;
    global String ints__DocumentSubtype__c;
    global String ints__DocumentType__c;
    global String ints__Gender__c;
    global String ints__GivenNames__c;
    global Boolean ints__IsValid__c;
    global Boolean ints__IssuingStateOrOrganizationVerified__c;
    global String ints__IssuingStateOrOrganization__c;
    global String ints__Name__c;
    global String ints__NationalityVerified__c;
    global String ints__Nationality__c;
    global String ints__PersonalNumberCheckDigit__c;
    global Boolean ints__PersonalNumberVerified__c;
    global String ints__PersonalNumber__c;
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
    global List<ints__IDCMachineReadableZone__Share> Shares;
    global List<ints__IDCOcrResult__c> ints__IDCOcrResult__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global ints__IDCMachineReadableZone__c () 
    {
    }
}