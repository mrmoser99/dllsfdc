// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__ACH_Parameters__c {
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
    global String cllease__ACH_Id__c;
    global Double cllease__Days_In_Advance_To_Create_File__c;
    global String cllease__Fed_Tax_Id__c;
    global String cllease__Folder_Name__c;
    /* This class will be instantiated at runtime to generate the banking file for Investor Deposits.
    */
    global String cllease__Investor_Deposit_Transaction_Filegen__c;
    global Double cllease__Lock_Period_for_Investor_Funds__c;
    global Double cllease__Lock_Period_for_Lease_Payments__c;
    global String cllease__Organization_Name__c;
    /* Please enter one of the values.
1. IGNORE HOLIDAYS
2. BEFORE HOLIDAYS
3. AFTER HOLIDAYS
    */
    global String cllease__ACH_Processing_For_Holidays__c;
    /* If bills are split due to bill group configuration then un-checking this flag will ensure that all the split bills must be taxed to be eligible for ACH. If this flag is checked then the system will pick all taxed bills from the split bills for ACH.
    */
    global Boolean cllease__Process_ACH_On_Bill_Groups__c;
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

    global cllease__ACH_Parameters__c () 
    {
    }
}