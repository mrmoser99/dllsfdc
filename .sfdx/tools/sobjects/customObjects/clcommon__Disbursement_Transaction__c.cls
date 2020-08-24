// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Disbursement_Transaction__c {
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
    global String clcommon__ACH_Filename__c;
    global Date clcommon__ACH_Sent_Date__c;
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global Decimal clcommon__Accrue_Subvention__c;
    /* This field represents the Total Amount including Tax
    */
    global Decimal clcommon__Amount__c;
    global Decimal clcommon__Dealer_Payable_Amount__c;
    global Date clcommon__Due_Date__c;
    global clcommon__Collateral__c clcommon__Equipment_Id__r;
    global Id clcommon__Equipment_Id__c;
    global Date clcommon__GL_Date__c;
    global Boolean clcommon__GL_Posted_Flag__c;
    global Date clcommon__GL_Process_Date__c;
    global String clcommon__GL_Processing_Message__c;
    global Boolean clcommon__GL_Transaction_Flag__c;
    global Boolean clcommon__Is_Dealer_Funding_Txn__c;
    global String clcommon__Name__c;
    /* This field represents the Amount excluding Tax
    */
    global Decimal clcommon__Net_Amount__c;
    global Boolean clcommon__Sent_To_ACH__c;
    /* This field represents the Tax Component
    */
    global Decimal clcommon__Tax_Amount__c;
    global Date clcommon__Transaction_Date__c;
    global String clcommon__Transaction_Type__c;
    global cllease__Charge__c cllease__Charge__r;
    global Id cllease__Charge__c;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Date cllease__Expense_Date__c;
    global cllease__Transaction_Sub_Type__c cllease__Transaction_Sub_Type__r;
    global Id cllease__Transaction_Sub_Type__c;
    global String AP_Processing_Status__c;
    global Decimal Fee_Amount_To_Dealer__c;
    global String Int_OLMN_AP_link__c;
    global Date Payment_Date__c;
    global String Payment_Reference__c;
    global String Remark__c;
    global String Vendor_ID__c;
    global String Description__c;
    global Date Invoice_Date__c;
    global String Invoice_Number__c;
    global clcommon__Cash_Receipt__c clcommon__Cash_Receipt__r;
    global Id clcommon__Cash_Receipt__c;
    global String clcommon__Transaction_Sub_Type__c;
    global cllease__Contract_Fees__c cllease__Contract_Fee__r;
    global Id cllease__Contract_Fee__c;
    global Boolean cllease__Restructured__c;
    global String cllease__Reversal_Comments__c;
    /* If checked, Disbursement Transaction is reversed  or cancelled
    */
    global Boolean cllease__Reversed__c;
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
    global List<clcommon__Cash_Receipt_Transaction__c> clcommon__Cash_Receipt_Transactions__r;
    global List<clcommon__Disbursement_Transaction__Share> Shares;
    global List<cllease__Dealer_Funding_Detail__c> cllease__Dealer_Funding_Details__r;
    global List<cllease__Debt_Schedule__c> cllease__Debt_Schedule__r;
    global List<cllease__Disbursement_Transaction__c> cllease__Old_Disbursement_Transactions__r;
    global List<cllease__Expense_Fee_Transaction__c> cllease__Expense_Fees__r;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Transaction_Details__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Disbursement_Transaction__c () 
    {
    }
}