// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Transaction_Summary__c {
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
    global cllease__Lease_Account__c cllease__Lease_Account__r;
    global Id cllease__Lease_Account__c;
    global Double cllease__Additional_Interest_Amt__c;
    global String cllease__Billing_Method__c;
    global Boolean cllease__Cleared__c;
    global Date cllease__Due_Date__c;
    global Double cllease__Excess__c;
    global String cllease__Fee_Name__c;
    global Double cllease__Fees__c;
    global String cllease__Frequency_of_Lease_Payment__c;
    global Double cllease__Interest_Only_Period__c;
    global Double cllease__Interest_Rate__c;
    global Double cllease__Interest__c;
    global String cllease__LeaseApplicationNumber__c;
    global String cllease__Lease_Snapshot__c;
    global Double cllease__Number_of_Installments__c;
    /* One time ACH account number
    */
    global String cllease__OT_ACH_Account_Number__c;
    global String cllease__OT_ACH_Account_Type__c;
    /* One time ACH Drawer Zip
    */
    global String cllease__OT_ACH_Bank_Name__c;
    global Date cllease__OT_ACH_Debit_Date__c;
    /* One time ACH Drawer Address Line 1
    */
    global String cllease__OT_ACH_Drawer_Address1__c;
    /* One time ACH Drawer Address Line 2
    */
    global String cllease__OT_ACH_Drawer_Address2__c;
    /* One time ACH Drawer City
    */
    global String cllease__OT_ACH_Drawer_City__c;
    /* One time ACH Drawer Name
    */
    global String cllease__OT_ACH_Drawer_Name__c;
    /* One time ACH Drawer State
    */
    global String cllease__OT_ACH_Drawer_State__c;
    /* One time ACH Drawer Zip
    */
    global String cllease__OT_ACH_Drawer_Zip__c;
    /* One time ACH fee amount
    */
    global Double cllease__OT_ACH_Fee_Amount__c;
    /* One time ACH payment amount
    */
    global Double cllease__OT_ACH_Payment_Amount__c;
    global String cllease__OT_ACH_Relationship_Type__c;
    /* One time ACH Routing number
    */
    global String cllease__OT_ACH_Routing_Number__c;
    global Double cllease__Passed_Term__c;
    global Date cllease__Pay_Off_Date__c;
    global Double cllease__Principal_Remaining__c;
    global Double cllease__Principal__c;
    global Decimal cllease__Receivable_Billed__c;
    global Boolean cllease__Rejected__c;
    /* Days by which repayments are extended
    */
    global Double cllease__Repayment_Extension_Days__c;
    global Date cllease__Repayment_Start_Date__c;
    global Boolean cllease__Reversed__c;
    global Boolean cllease__Same_monthly_payment__c;
    global Decimal cllease__Tax_Billed__c;
    global Double cllease__Total_Fees_Due__c;
    global Double cllease__Total_Interest_Due__c;
    global String cllease__Transaction_Id__c;
    global String cllease__Transaction_Type__c;
    global Double cllease__Txn_Amt__c;
    global Date cllease__Txn_Date__c;
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
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Transaction_Summary__c () 
    {
    }
}