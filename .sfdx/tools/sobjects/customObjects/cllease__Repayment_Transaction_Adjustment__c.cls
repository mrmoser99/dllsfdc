// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Repayment_Transaction_Adjustment__c {
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
    /* Lease Payment Transaction
    */
    global cllease__Lease_Payment_Transaction__c cllease__Lease_Payment_Transaction__r;
    /* Lease Payment Transaction
    */
    global Id cllease__Lease_Payment_Transaction__c;
    /* Adjusted Amount (+ve or -ve). This is not yet implemented.
Reversal Txn will reverse the master payment transaction's full amount.
    */
    global Double cllease__Adjusted_Amount__c;
    /* Adjustment Txn Date
    */
    global Date cllease__Adjustment_Txn_Date__c;
    global Boolean cllease__Cleared__c;
    global Boolean cllease__Custom_Logic__c;
    global Boolean cllease__GL_Posted_Flag__c;
    global Date cllease__GL_Process_Date__c;
    global String cllease__GL_Processing_Message__c;
    global Boolean cllease__GL_Transaction_Flag__c;
    global cllease__Lease_Account__c cllease__LS_Contract__r;
    global Id cllease__LS_Contract__c;
    global String cllease__Reason_Code__c;
    global String cllease__Receipt_ID__c;
    global String cllease__Reference__c;
    global Double cllease__Signed_Adjusted_Amount__c;
    global cllease__Transaction_Sub_Type__c cllease__Transaction_Sub_Type__r;
    global Id cllease__Transaction_Sub_Type__c;
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

    global cllease__Repayment_Transaction_Adjustment__c () 
    {
    }
}