// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Transaction_Sub_Type__c {
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
    /* This field is used to indicate if this transaction sub type should be reversed when a contract becomes NPA.
    */
    global Boolean cllease__NPA_Flag__c;
    global String External_Id__c;
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
    global List<clcommon__Disbursement_Transaction__c> cllease__Payment_Txns__r;
    global List<cllease__Accounting_Template_Line__c> cllease__Accounting_Template_Lines__r;
    global List<cllease__Amz_Stream__c> cllease__Amz_Streams__r;
    global List<cllease__Charge__c> cllease__Charges__r;
    global List<cllease__Dep_Streams__c> cllease__Dep_Streams__r;
    global List<cllease__Disbursement_Transaction__c> cllease__Payment_Transactions__r;
    global List<cllease__Expense_Fee_Transaction__c> cllease__Expense_Payment_Txns__r;
    global List<cllease__Expense_Fees__c> cllease__Expense_Fees__r;
    global List<cllease__Fee_Stream__c> cllease__Fee_Streams__r;
    global List<cllease__Initial_Direct_Cost_Stream__c> cllease__IDC_Stream__r;
    global List<cllease__Lease_Payment_Detail__c> cllease__Lease_Payment_Details__r;
    global List<cllease__Lease_Payment_Transaction__c> Payment_Transactions__r;
    global List<cllease__Lease_Trx_Lines__c> cllease__Lease_Transaction_Line__r;
    global List<cllease__Lease_account_Due_Details__c> cllease__Bills__r;
    global List<cllease__Payment_Stream__c> cllease__Payment_Streams__r;
    global List<cllease__Rental_Accrual_Stream1__c> cllease__Rental_Accrual_Streams__r;
    global List<cllease__Rental_Stream__c> cllease__Income_Streams__r;
    global List<cllease__Repayment_Transaction_Adjustment__c> cllease__Repayment_Transaction_Reversal__r;
    global List<cllease__Residual_Stream__c> cllease__Residual_Streams__r;
    global List<cllease__Subsidy_Stream__c> cllease__Subsidy_Streams__r;
    global List<cllease__Transaction_Sub_Type__History> Histories;
    global List<cllease__Transaction_Sub_Type__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Transaction_Sub_Type__c () 
    {
    }
}