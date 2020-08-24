// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__Transaction__c {
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
    global ints__Microbilt_Information__c ints__Microbilt_Information__r;
    global Id ints__Microbilt_Information__c;
    global Double ints__BONUS_AMOUNT__c;
    /* CATEGORY_NAME
    */
    global String ints__CATEGORY_NAME__c;
    /* COMMISSION_AMOUNT
    */
    global Double ints__COMMISSION_AMOUNT__c;
    /* CONFIRMATION_NO
    */
    global String ints__CONFIRMATION_NO__c;
    /* CREATED_DATE
    */
    global Datetime ints__CREATED_DATE__c;
    /* CURRENCY_SYMBOL
    */
    global String ints__CURRENCY_SYMBOL__c;
    /* CUSIP_NO
    */
    global String ints__CUSIP_NO__c;
    /* DESCRIPTION
    */
    global String ints__DESCRIPTION__c;
    /* ESCROW_AMOUNT
    */
    global Double ints__ESCROW_AMOUNT__c;
    /* FEE_AMOUNT
    */
    global Double ints__FEE_AMOUNT__c;
    global Double ints__INTEREST_AMOUNT__c;
    global String ints__MEMO__c;
    global String ints__NORMALIZED_DESCRIPTION__c;
    global String ints__OFX_CATEGORY_NAME__c;
    global Datetime ints__POSTED_DATE__c;
    global Double ints__PRINCIPAL_AMOUNT__c;
    global String ints__REFERENCE_NO__c;
    global Double ints__RUNNING_BALANCE_AMOUNT__c;
    global String ints__SIC_CODE__c;
    global String ints__STATUS__c;
    global String ints__SYMBOL__c;
    global Datetime ints__TRANSACTION_DATE__c;
    global String ints__TRANSACTION_TYPE__c;
    global String ints__UNIT_ACTION__c;
    global Double ints__UNIT_QUANTITY__c;
    global String ints__UNIT_TYPE__c;
    global Double ints__UNIT_VALUE__c;
    global Double ints__VALUE_AMOUNT__c;
    global String ints__VALUE_TYPE__c;
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
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global ints__Transaction__c () 
    {
    }
}