// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Cash_Receipt_Transaction__c {
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
    global clcommon__Cash_Receipt__c clcommon__Cash_Receipt__r;
    global Id clcommon__Cash_Receipt__c;
    global Boolean clcommon__GL_Posted__c;
    global Date clcommon__GL_Process_Date__c;
    global String clcommon__GL_Processing_Message__c;
    global Boolean clcommon__GL_Transaction__c;
    global Boolean clcommon__Migrated__c;
    global Account clcommon__New_Account__r;
    global Id clcommon__New_Account__c;
    global clcommon__Payment_Mode__c clcommon__New_Payment_Mode__r;
    global Id clcommon__New_Payment_Mode__c;
    global Date clcommon__New_Receipt_Date__c;
    global Account clcommon__SS_Account__r;
    global Id clcommon__SS_Account__c;
    global clcommon__Payment_Mode__c clcommon__SS_Payment_Mode__r;
    global Id clcommon__SS_Payment_Mode__c;
    global Decimal clcommon__SS_Receipt_Amount__c;
    global Date clcommon__SS_Receipt_Date__c;
    global Decimal clcommon__Transaction_Amount__c;
    global Date clcommon__Transaction_Date__c;
    global String clcommon__Transaction_Sub_Type__c;
    global String clcommon__Description__c;
    /* If checked, disbursement transaction is already created for Cash Receipt Refund Transaction.
    */
    global Boolean clcommon__Disbursed__c;
    /* Disbursement Transaction for Cash Receipt Transaction having Transaction type as REFUND CASH RECEIPT
    */
    global clcommon__Disbursement_Transaction__c clcommon__Disbursement_Transaction__r;
    /* Disbursement Transaction for Cash Receipt Transaction having Transaction type as REFUND CASH RECEIPT
    */
    global Id clcommon__Disbursement_Transaction__c;
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

    global clcommon__Cash_Receipt_Transaction__c () 
    {
    }
}