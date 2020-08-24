// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__GL_Transaction_Detail__c {
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
    global cllease__Accrual_Transactions__c cllease__Accrual_Transaction__r;
    global Id cllease__Accrual_Transaction__c;
    global cllease__Lease_account_Due_Details__c cllease__Billing_Transactions__r;
    global Id cllease__Billing_Transactions__c;
    global cllease__Charge__c cllease__Charge__r;
    global Id cllease__Charge__c;
    global cllease__Office_Name__c cllease__Company__r;
    global Id cllease__Company__c;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Decimal cllease__Credit_Amount__c;
    global String cllease__Credit_GL_Account_Code__c;
    global cllease__GL_Account__c cllease__Credit_GL_Account__r;
    global Id cllease__Credit_GL_Account__c;
    global Decimal cllease__Debit_Amount__c;
    global String cllease__Debit_GL_Account_Code__c;
    global cllease__GL_Account__c cllease__Debit_GL_Account__r;
    global Id cllease__Debit_GL_Account__c;
    global cllease__Disbursement_Transaction__c cllease__Disbursement_Transaction__r;
    global Id cllease__Disbursement_Transaction__c;
    global Date cllease__Exported_Date__c;
    global Boolean cllease__Exported_Flag__c;
    global Date cllease__GL_Batch_Post_Date__c;
    global Date cllease__GL_Date__c;
    global String cllease__Item_Id__c;
    global String cllease__Item_Name__c;
    global String cllease__LeaseApplicationNumber__c;
    global cllease__Lease_Trx_Lines__c cllease__Lease_Accrual_Transaction__r;
    global Id cllease__Lease_Accrual_Transaction__c;
    global cllease__Lease_Payment_Detail__c cllease__Lease_Payment_Detail__r;
    global Id cllease__Lease_Payment_Detail__c;
    global cllease__Other_Transaction__c cllease__Other_Transactions__r;
    global Id cllease__Other_Transactions__c;
    global cllease__Repayment_Transaction_Adjustment__c cllease__Payment_Transaction_Reversal__r;
    global Id cllease__Payment_Transaction_Reversal__c;
    global cllease__Lease_Payment_Transaction__c cllease__Payment_Transaction__r;
    global Id cllease__Payment_Transaction__c;
    /* Description of GL Transaction
    */
    global String cllease__Transaction_Description__c;
    global String cllease__Transaction_Type__c;
    global String cllease__Transaction_type1__c;
    global String CL_Lease_Transaction_Type__c;
    /* This field will be used to track DLL Interface (Int_OLMN_GL__c) Record ID.
    */
    global String GL_Consolidation_Credit_Record_Id__c;
    /* This field will be used to track DLL Interface (Int_OLMN_GL__c) Debit Record ID.
    */
    global String GL_Consolidation_Debit_Record_Id__c;
    /* This field to track interface record for Subledger on Credit Account.
    */
    global String GL_SubLedger_Credit_Record_Id__c;
    global String GL_SubLedger_Debit_Record_Id__c;
    global Double Journal_Entry_Number__c;
    global String Movement_Code_CR_Segment__c;
    /* This field will track the Movement Code for Credit Account
    */
    global String Movement_Code_Cr__c;
    global String Movement_Code_DR_Segment__c;
    /* This field will track the Movement Code for Debit Account
    */
    global String Movement_Code_Dr__c;
    global String Remark__c;
    global String Transaction_Sub_Type__c;
    global String Global_SBU__c;
    global String Reporting_Entity__c;
    global Boolean Valid_GL_Entries__c;
    global cllease__Invoice_Credit__c Invoice_Credit__r;
    global Id Invoice_Credit__c;
    global clcommon__Cash_Receipt_Transaction__c cllease__Cash_Receipt_Transaction__r;
    global Id cllease__Cash_Receipt_Transaction__c;
    global clcommon__Cash_Receipt__c cllease__Cash_Receipt__r;
    global Id cllease__Cash_Receipt__c;
    global cllease__Debt_Schedule__c cllease__Debt_Schedule__r;
    global Id cllease__Debt_Schedule__c;
    global clcommon__Depreciation_Stream__c cllease__Depreciation_Stream__r;
    global Id cllease__Depreciation_Stream__c;
    global clcommon__Disbursement_Transaction__c cllease__Disbursement_Txn__r;
    global Id cllease__Disbursement_Txn__c;
    global clcommon__Equipment_Transaction__c cllease__Equipment_Transaction__r;
    global Id cllease__Equipment_Transaction__c;
    global clcommon__Collateral__c cllease__Equipment__r;
    global Id cllease__Equipment__c;
    global cllease__Expense_Fee_Transaction__c cllease__Expense_Fee_Transaction__r;
    global Id cllease__Expense_Fee_Transaction__c;
    global String cllease__Generation_Scheme__c;
    global Boolean cllease__Reversal_Processed__c;
    /* Field to indicate TAX Exemption
    */
    global Boolean cllease__Tax_Exempt__c;
    /* Field to indicate TAX Override
    */
    global Boolean cllease__Tax_Override__c;
    /* Look up to the VAT Code applied on the Transaction
    */
    global clcommon__VAT_Rate_Setup__c cllease__VAT_Code__r;
    /* Look up to the VAT Code applied on the Transaction
    */
    global Id cllease__VAT_Code__c;
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
    global List<cllease__GL_Transaction_Detail__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__GL_Transaction_Detail__c () 
    {
    }
}