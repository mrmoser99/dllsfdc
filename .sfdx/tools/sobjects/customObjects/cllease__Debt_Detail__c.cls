// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Debt_Detail__c {
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
    /* Lease contract
    */
    global cllease__Lease_Account__c cllease__Contract__r;
    /* Lease contract
    */
    global Id cllease__Contract__c;
    /* Debt amount
    */
    global Decimal cllease__Amount__c;
    /* Balloon payment at the end of payment cycle
    */
    global Decimal cllease__Balloon_Payment__c;
    /* Day count method used by debtor for interest computation
    */
    global String cllease__Day_Count_Method__c;
    global String cllease__Debt_Name__c;
    /* Debt repayment end date
    */
    global Date cllease__End_Date__c;
    /* First payment date
    */
    global Date cllease__First_Payment_Date__c;
    /* Frequency for compounding interest
    */
    global String cllease__Interest_Compounding_Frequency__c;
    /* Interest only period for debt repayment
    */
    global Double cllease__Interest_Only_Term__c;
    /* Interest rate charged by debtor. Leave this field blank when entering a repayment plan with equal number of payments as debt's term. In case repayment plan has fewer payments than term, then interest rate is required.
    */
    global Double cllease__Interest_Rate__c;
    /* Method used by debtor for computing repayment amount
    */
    global String cllease__Repayment_Computation_Method__c;
    /* Debt repayment frequency
    */
    global String cllease__Repayment_Frequency__c;
    /* Debt contract start date
    */
    global Date cllease__Start_Date__c;
    /* Number of payment terms for debt repayment
    */
    global Double cllease__Term__c;
    global String cllease__Type__c;
    /* Equipment for which the debt is taken
    */
    global cllease__Contract_Equipment__c cllease__Contract_Equipment__r;
    /* Equipment for which the debt is taken
    */
    global Id cllease__Contract_Equipment__c;
    global Boolean cllease__Disburse_Debt__c;
    /* Equipment for which the debt is taken
    */
    global clcommon__Collateral__c cllease__Equipment__r;
    /* Equipment for which the debt is taken
    */
    global Id cllease__Equipment__c;
    global cllease__Contract_Parties__c cllease__Funder__r;
    global Id cllease__Funder__c;
    global String cllease__Status__c;
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
    global List<clcommon__Repayment_Plan__c> cllease__Repayment_Plan__r;
    global List<cllease__Debt_Schedule__c> cllease__Debt_Schedule__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Debt_Detail__c () 
    {
    }
}