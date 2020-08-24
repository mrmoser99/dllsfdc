// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Batch_Jobs_Setting__c {
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
    /* Option is to Skip the ACH Processing Job
true: skip the ACH Processing Job
false: don't skip job
    */
    global Boolean cllease__Skip_ACH_Processing_Job__c;
    /* Option is to Skip the Allocate Excess Job
true: skip the Allocate Excess Job
false: don't skip job
    */
    global Boolean cllease__Skip_Allocate_Excess_Job__c;
    global Boolean cllease__Skip_Apply_Tax_Rates_Job__c;
    /* This job is to Skip the Credit ACH Processing Job
true: skip the Credit ACH Processing Job
false: don't skip job
    */
    global Boolean cllease__Skip_Credit_ACH_Processing_Job__c;
    /* This job is to Skip the Dealer Funding Job
true: skip the Dealer Funding Job
false: don't skip job
    */
    global Boolean cllease__Skip_Dealer_Funding_Job__c;
    /* Option is to Skip the Delinquency Processing Job
true: skip the Delinquency Processing Job
false: don't skip job
    */
    global Boolean cllease__Skip_Delinquency_Processing_Job__c;
    /* This job is to Skip the  Evergreen Processing Job
true: skip the  Evergreen Processing Job
false: don't skip job
    */
    global Boolean cllease__Skip_Evergreen_Processing_Job__c;
    /* This job is to Skip the  Fee Tax Rates for Avalara Job
true: skip the Job
false: don't skip job
    */
    global Boolean cllease__Skip_Fee_Tax_Rate_Collector_Job__c;
    global Boolean cllease__Skip_Fetch_Tax_Rates_Job__c;
    /* Option is to Skip the Generate GL Entries Job
true: skip the Generate GL Entries Job
false: don't skip job
    */
    global Boolean cllease__Skip_Generate_GL_Entries_Job__c;
    /* Option is to Skip the Generate GL Reversal Entries Job
true: skip the Generate GL Reversal Entries Job
false: don't skip job
    */
    global Boolean cllease__Skip_Generate_GL_Reversal_Entries_Job__c;
    global Boolean cllease__Skip_Installation_Job__c;
    /* Option to Skip the Late Charges Generate Job
true: skip the Late Charges Generate Job
false: don't skip job
    */
    global Boolean cllease__Skip_Late_Charges_Generate_Job__c;
    /* Option is to Skip the Lease Accrual Job
true: skip the Lease Accrual Job
false: don't skip job
    */
    global Boolean cllease__Skip_Lease_Accrual_Job__c;
    /* Option is to Skip the Lease Billing Job
true: skip the Lease Billing Job
false: don't skip job
    */
    global Boolean cllease__Skip_Lease_Billing_Job__c;
    /* option provided to skip the Lease Diagnostics job
True: Skip the job
false: don't skip job
    */
    global Boolean cllease__Skip_Lease_Diagnostics_Job__c;
    global Boolean cllease__Skip_Lease_Disbursement_Txn_ACH_Job__c;
    /* This job is to Skip the Lease Evergreen Billing Job
true: skip the Lease Evergreen Billing Job
false: don't skip job
    */
    global Boolean cllease__Skip_Lease_Evergreen_Billing_Job__c;
    /* This job is to Skip the Lease Maturity Job
true: skip the Lease maturity job
false: don't skip job
    */
    global Boolean cllease__Skip_Lease_Maturity_Job__c;
    global Boolean cllease__Skip_Lease_Payment_Txn_ACH_Job__c;
    /* Option is to Skip the Lease Payment Txn Clearing Job
true: skip the Lease Payment Txn Clearing Job
false: don't skip job
    */
    global Boolean cllease__Skip_Lease_Payment_Txn_Clearing_Job__c;
    /* Option is to Skip the Lease Payment Txn Generator Job
true: skip the Lease Payment Txn Generator Job
false: don't skip job
    */
    global Boolean cllease__Skip_Lease_Payment_Txn_Generator_Job__c;
    /* Option is to Skip the Lease Payment Txn Sweep To ACH Job
true: skip the Lease Payment Txn Sweep To ACH Job
false: don't skip job
    */
    global Boolean cllease__Skip_Lease_Payment_Txn_Sweep_To_ACH_Job__c;
    /* Option is to Skip the Passthrough Disbursement Generator Job
true: skip the  Job
false: don't skip job
    */
    global Boolean cllease__Skip_Passthrough_Disbursement_Gen_Job__c;
    /* Option is to Skip the Periodic Charge Job
true: skip the Periodic Charge Job
false: don't skip job
    */
    global Boolean cllease__Skip_Periodic_Charge_Job__c;
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

    global cllease__Batch_Jobs_Setting__c () 
    {
    }
}