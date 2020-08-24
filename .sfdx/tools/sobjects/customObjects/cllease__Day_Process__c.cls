// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Day_Process__c {
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
    global Boolean cllease__Accounts_Accrured__c;
    global cllease__Office_Name__c cllease__Branch__r;
    global Id cllease__Branch__c;
    global Date cllease__Date__c;
    global Boolean cllease__Day_Ended__c;
    global Boolean cllease__Day_Started__c;
    global String cllease__Day_Status__c;
    global Boolean cllease__EOD_Finished__c;
    global Boolean cllease__EOD_Process_Started__c;
    global Boolean cllease__SOD_Process_Started__c;
    global Boolean cllease__Skip_ACH_Processing_Job__c;
    global Boolean cllease__Skip_Allocate_Excess_Job__c;
    global Boolean cllease__Skip_Apply_Tax_Rates_Job__c;
    global Boolean cllease__Skip_Credit_ACH_Processing_Job__c;
    global Boolean cllease__Skip_Dealer_Funding_Job__c;
    global Boolean cllease__Skip_Delinquency_Processing_Job__c;
    global Boolean cllease__Skip_Evergreen_Processing_Job__c;
    global Boolean cllease__Skip_Fetch_Tax_Rates_Job__c;
    global Boolean cllease__Skip_Generate_GL_Entries_Job__c;
    global Boolean cllease__Skip_Generate_GL_Reversal_Entries_Job__c;
    global Boolean cllease__Skip_Installation_Job__c;
    global Boolean cllease__Skip_Late_Charges_Generate_Job__c;
    global Boolean cllease__Skip_Lease_Accrual_Job__c;
    global Boolean cllease__Skip_Lease_Billing_Job__c;
    global Boolean cllease__Skip_Lease_Diagnostics_Job__c;
    global Boolean cllease__Skip_Lease_Disbursement_Txn_ACH_Job__c;
    global Boolean cllease__Skip_Lease_Evergreen_Billing_Job__c;
    global Boolean cllease__Skip_Lease_Maturity_Job__c;
    global Boolean cllease__Skip_Lease_Payment_Txn_ACH_Job__c;
    global Boolean cllease__Skip_Lease_Payment_Txn_Clearing_Job__c;
    global Boolean cllease__Skip_Lease_Payment_Txn_Generator_Job__c;
    global Boolean cllease__Skip_Lease_Payment_Txn_Sweep_To_ACH_Job__c;
    global Boolean cllease__Skip_Periodic_Charge_Job__c;
    global Double cllease__Start_Index__c;
    global String cllease__Status__c;
    global Double cllease__limit__c;
    global Double cllease__size__c;
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
    global List<cllease__Day_Process__History> Histories;
    global List<cllease__Day_Process__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Day_Process__c () 
    {
    }
}