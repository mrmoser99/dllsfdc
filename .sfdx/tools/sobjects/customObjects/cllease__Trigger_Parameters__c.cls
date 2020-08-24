// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Trigger_Parameters__c {
    global Id Id;
    global Boolean IsDeleted;
    global String Name;
    global SObject SetupOwner;
    global Id SetupOwnerId;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global Boolean cllease__Disable_Accounting_Period_Trigger__c;
    global Boolean cllease__Disable_Accounting_Segment_Setup_Trigger__c;
    /* Check to disable Accounting Transaction Trigger
    */
    global Boolean cllease__Disable_Accounting_Transaction_Trigger__c;
    /* Check to disable Branch Creation Trigger
    */
    global Boolean cllease__Disable_Branch_Creation_Trigger__c;
    /* Check to disable Charge Trigger
    */
    global Boolean cllease__Disable_Charge_Trigger__c;
    global Boolean cllease__Disable_ClientCrtUpd_Trigger__c;
    global Boolean cllease__Disable_ClientIdentification_Trigger__c;
    global Boolean cllease__Disable_Contract_Equipment_Trigger__c;
    global Boolean cllease__Disable_Day_Process_Trigger__c;
    global Boolean cllease__Disable_Expense_Fees_Trigger__c;
    global Boolean cllease__Disable_Fee_Trigger__c;
    global Boolean cllease__Disable_Group_Trigger__c;
    global Boolean cllease__Disable_InvFundTxn_Trigger__c;
    global Boolean cllease__Disable_LeasePrdCycle_Trigger__c;
    global Boolean cllease__Disable_LeaseWrtOffTxn_Trigger__c;
    /* Check to disable lease account trigger
    */
    global Boolean cllease__Disable_Lease_Account_Trigger__c;
    global Boolean cllease__Disable_Lease_Prd_Trigger__c;
    global Boolean cllease__Disable_MFAccount_Trigger__c;
    global Boolean cllease__Disable_Payment_Spread_Trigger__c;
    global Boolean cllease__Disable_Period_Status_Trigger__c;
    global Boolean cllease__Disable_PostDisbAccBalUpd_Trigger__c;
    global Boolean cllease__Disable_PostRpmtAccBalUpd_Trigger__c;
    global Boolean cllease__Disable_PostRpmtAdjTxn_Trigger__c;
    global Boolean cllease__Disable_Post_Disb_Adj_Txn_Trigger__c;
    global Boolean cllease__Disable_Question_Trigger__c;
    global Boolean cllease__Disable_Recovery_Order_Trigger__c;
    global Boolean cllease__Disable_Repo_Trigger__c;
    global Boolean cllease__Disable_Return_Trigger__c;
    global Boolean cllease__Disable_Rpmt_Schedule_Trigger__c;
    global Boolean cllease__Disable_Saving_Account_Trigger__c;
    global Boolean cllease__Disable_Saving_Pmt_Txn_Trigger__c;
    global Boolean cllease__Disable_Saving_Prd_Trigger__c;
    global Boolean cllease__Disable_Tax_Setup_Trigger__c;
    global Boolean cllease__Disable_Tell_Cash_Txn_Trigger__c;
    global Boolean cllease__Disable_User_Trigger__c;
    /* Check to disable Valid Account For Txn Entry Trigger
    */
    global Boolean cllease__Disable_ValidAccTxnEntryTrigger__c;
    /* Disable broker_populate_commission_plan trigger
    */
    global Boolean cllease__Disable_broker_commission_plan__c;
    global Boolean cllease__Disable_transaction_Sub_Type_Trigger__c;
    global Boolean cllease__Disable_Automated_Payment_Setup_Trigger__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
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

    global cllease__Trigger_Parameters__c () 
    {
    }
}