// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Payment_Transaction__c {
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
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global clcommon__Due_Details__c clcommon__Bill__r;
    global Id clcommon__Bill__c;
    global clcommon__Cash_Receipt_Application__c clcommon__Cash_Receipt_Application__r;
    global Id clcommon__Cash_Receipt_Application__c;
    global clcommon__Cash_Receipt__c clcommon__Cash_Receipt__r;
    global Id clcommon__Cash_Receipt__c;
    global clcommon__Company__c clcommon__Company__r;
    global Id clcommon__Company__c;
    global clcommon__Equipment_Sale_Quote__c clcommon__Equipment_Sale_Quote__r;
    global Id clcommon__Equipment_Sale_Quote__c;
    global Date clcommon__Receipt_Date__c;
    global Decimal clcommon__Rent_Amount__c;
    global Decimal clcommon__Tax_Amount__c;
    global Decimal clcommon__Transaction_Amount__c;
    global Date clcommon__Transaction_Date__c;
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
    global List<clcommon__Equipment_Transaction__c> clcommon__Equipment_Transactions__r;
    global List<clcommon__Payment_Transaction__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Payment_Transaction__c () 
    {
    }
}