// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Portfolio_Contract__c {
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
    global String billingAddressLine1__c;
    global String billingAddressLine2__c;
    global String billingCity__c;
    global String billingState__c;
    global String billingZipCode__c;
    global String businessSegment__c;
    global String contractAverageDaysToPay__c;
    global String contractExpireDate__c;
    global String contractNumber__c;
    global String contractOriginalCost__c;
    global String contractPayment__c;
    global String contractPeriodicity__c;
    global String contractProgramId__c;
    global String contractProgramName__c;
    global String contractPurchaseOption__c;
    global String contractSignerTitle__c;
    global String contractSigner__c;
    global String contractStartDate__c;
    global String contractTerm__c;
    global String contractType__c;
    global String customerAddressLine1__c;
    global String customerAddressline2__c;
    global String customerCity__c;
    global String customerName__c;
    global String customerNumber__c;
    global String customerState__c;
    global String customerZipCode__c;
    global String lastPaymentReceivedDate__c;
    global String leaseSignerTitle__c;
    global String numberOfRemainingPayments__c;
    global String phone__c;
    global String subBusinessSegment__c;
    global String vendorAddressLine1__c;
    global String vendorAddressLine2__c;
    global String vendorCity__c;
    global String vendorName__c;
    global String vendorNumber1__c;
    global String vendorNumber2__c;
    global String vendorNumber3__c;
    global String vendorSiteCode__c;
    global String vendorState__c;
    global String vendorZipCode__c;
    global Double nbrOfAssets__c;
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
    global List<Portfolio_Contract__Share> Shares;
    global List<Portfolio_Equipment__c> Portfolio_Equipment__r;
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

    global Portfolio_Contract__c () 
    {
    }
}