// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Debt_Schedule__c {
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
    /* Debt detail
    */
    global cllease__Debt_Detail__c cllease__Debt_Detail__r;
    /* Debt detail
    */
    global Id cllease__Debt_Detail__c;
    /* Closing balance of debt
    */
    global Decimal cllease__Closing_Balance__c;
    /* Date
    */
    global Date cllease__Date__c;
    /* Interest deduction
    */
    global Decimal cllease__Interest_Deduction__c;
    /* Opening balance of debt
    */
    global Decimal cllease__Opening_Balance__c;
    /* Payment amount
    */
    global Decimal cllease__Payment_Amount__c;
    /* Principal deduction
    */
    global Decimal cllease__Principal_Deduction__c;
    global cllease__Disbursement_Transaction__c cllease__Disbursement_Transaction__r;
    global Id cllease__Disbursement_Transaction__c;
    global clcommon__Disbursement_Transaction__c cllease__Disbursement_Txn__r;
    global Id cllease__Disbursement_Txn__c;
    /* This flag will be set to True, once the gl accounting entry will be generated for this transaction
    */
    global Boolean cllease__GL_Posted_Flag__c;
    /* Date on which the batch job processed this record for GL posting.
    */
    global Date cllease__GL_Process_Date__c;
    /* This field will be populated with any error/messages happened while gl processing.
    */
    global String cllease__GL_Processing_Message__c;
    /* This flag will determine that gl entry will be generated for this transaction.
    */
    global Boolean cllease__GL_Transaction_Flag__c;
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
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Accounting_Entries__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Debt_Schedule__c () 
    {
    }
}