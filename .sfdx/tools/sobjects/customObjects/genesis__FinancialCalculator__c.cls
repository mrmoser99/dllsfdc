// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__FinancialCalculator__c {
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
    global Double genesis__APR__c;
    global String genesis__Accrual_Base_Method_Cd__c;
    /* Date from when the interest accrual will start.
    */
    global Date genesis__Accrual_Start_Date__c;
    global Double genesis__Accrual_Start_Days__c;
    global String genesis__Action__c;
    global Double genesis__Additional_Interest_Amt__c;
    global String genesis__Amortization_Calculation_Method_Cd__c;
    global Double genesis__Balance_Amt__c;
    global String genesis__Balloon_Method_Cd__c;
    global Double genesis__Balloon_Payment_Amt__c;
    global String genesis__Billing_Method_Cd__c;
    global Date genesis__Contract_Dt__c;
    global Double genesis__Final_Payment_Amt__c;
    global Double genesis__Financed_Amt__c;
    global Double genesis__Financed_Fees__c;
    global Date genesis__First_Payment_Dt__c;
    global Double genesis__First_Period_Calender_Days__c;
    global Double genesis__First_Period_Interest__c;
    global Boolean genesis__Flat_Interest_Flag__c;
    global Boolean genesis__Flexible_Repayment_Flag__c;
    global String genesis__Installment_Method_Cd__c;
    global Double genesis__Interest_Amt__c;
    global Double genesis__Interest_Only_Period__c;
    global Double genesis__Loan_Amt__c;
    global Double genesis__Original_Loan_Amt__c;
    global Date genesis__Payment_Amt_2_Start_dt__c;
    global Double genesis__Payment_Amt_2__c;
    global Double genesis__Payment_Amt__c;
    global String genesis__Payment_Frequency_Cd__c;
    global Double genesis__Prepaid_Fees__c;
    global Double genesis__Principal_Payment_Amt__c;
    global Double genesis__Rate__c;
    global String genesis__Repayment_Type_Cd__c;
    global Double genesis__Term__c;
    global String genesis__Time_Counting_Method_Cd__c;
    global Double genesis__Total_Finance_Charge__c;
    global Double genesis__Total_Financed_Amt__c;
    global Double genesis__Total_Of_Payments__c;
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
    global List<genesis__FinancialCalculator__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__FinancialCalculator__c () 
    {
    }
}