// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Int_OLMN_Net_Investment__c {
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
    global Double ACCOUNTING_YIELD__c;
    /* Billed but not paid Rent.
    */
    global Double BILLED_UNPAID_REC__c;
    global Double BOOKED_RESIDUAL__c;
    global Double CAP_BROKER_FEE_AMOUNT__c;
    global Double CAP_OTHER_FEE_AMOUNT__c;
    global String CONTRACT_END_DATE__c;
    global String CONTRACT_NUMBER__c;
    global String CONTRACT_START_DATE__c;
    global String CONTRACT_STATUS__c;
    global Double CONTRACT_TERM__c;
    global Boolean Committed__c;
    global Double EQUIPMENT_COST_CORP__c;
    global Double EQUIPMENT_COST_FED__c;
    global String FIN_PRODUCT__c;
    global Double FROZEN_LEASE_INCOME__c;
    /* Total Receivable amount
    */
    global Double FROZEN_RESIDUAL_INCOME__c;
    global Decimal GROSS_RECEIVABLES__c;
    global Double HARD_COST__c;
    global String LEASE_TYPE__c;
    global String LESSEE_NAME__c;
    global String LESSEE_NUMBER__c;
    /* On Account Cash.
    */
    global Double MONEY_ON_ACCOUNT__c;
    /* Value for the current period
    */
    global Double MTD_LEASE_INCOME__c;
    global Double MTD_RESIDUAL_INCOME__c;
    global String PARTIAL_TERMINATION_YN__c;
    /* M for Monthly
A for Annual
S for Semi-Annual
    */
    global String PAYMENT_FREQUENCY__c;
    global String PERIOD_DATE__c;
    global String PRIVATE_LABEL__c;
    global String REBOOKED_YN__c;
    global Double REMAINING_PAYMENTS__c;
    global String REPORTING_ENTITY__c;
    global String SBU__c;
    global Double SOFT_COST__c;
    /* Sum this amount for all records.
    */
    global Double TOT_UNEARNED_LEASE_INCOME__c;
    global Double TOT_UNEARNED_RESIDUAL_INCOME__c;
    global Double UNBILLED_RECEIVABLE__c;
    global Double UNEARNED_LEASE_INCOME__c;
    global Double UNEARNED_RESIDUAL_INCOME__c;
    global Double UPFRONT_TAX_AMOUNT__c;
    global String VENDOR_NUMBER__c;
    global String VENDOR_PROGRAM__c;
    global Double YTD_LEASE_INCOME__c;
    global Double YTD_RESIDUAL_INCOME__c;
    global Double CAP_ROLLOVER_FEE_AMOUNT__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Int_OLMN_Net_Investment__Share> Shares;
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

    global Int_OLMN_Net_Investment__c () 
    {
    }
}