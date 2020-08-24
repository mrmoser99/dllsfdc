// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Lending_Calculator__c {
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
    global String genesis__Accrual_Base_Method_Code__c;
    /* Accrual Start Date
    */
    global Date genesis__Accrual_Start_Date__c;
    /* Accrual Start Days
    */
    global Double genesis__Accrual_Start_Days__c;
    global String genesis__Action__c;
    global Double genesis__Additional_Interest_Amount__c;
    global String genesis__Amortization_Calculation_Method_Code__c;
    global Boolean genesis__Amortization_Schedule_Creation_Flag__c;
    global Double genesis__Amortization_Term__c;
    global Double genesis__Balance_Amount__c;
    global String genesis__Balloon_Method_Code__c;
    global Double genesis__Balloon_Payment_Amount__c;
    global String genesis__Billing_Method_Code__c;
    global String genesis__Calculation_Action__c;
    global String genesis__Calculator_Type__c;
    global Date genesis__Contract_Date__c;
    /* Due Day by default will have the value of the Expected First Payment Date Day value.
    */
    global Double genesis__Due_Day__c;
    global Date genesis__Expected_Second_Pay_Day_Date__c;
    global Double genesis__Final_Payment_Amount__c;
    global Double genesis__Financed_Amount__c;
    global Double genesis__Financed_Fees__c;
    global Date genesis__First_Payment_Date__c;
    global Double genesis__First_Period_Calender_Days__c;
    global Double genesis__First_Period_Interest__c;
    global Boolean genesis__Flat_Interest_Flag__c;
    global Boolean genesis__Flexible_Repayment_Flag__c;
    global Double genesis__Initial_Direct_Cost_Amount__c;
    global String genesis__Installment_Method_Code__c;
    global Double genesis__Interest_Amount__c;
    /* Interest compounding frequency can be used to calculate Interest with Compound Interest as calculation method for the respective frequency selected.
    */
    global String genesis__Interest_Compounding_Frequency__c;
    global Double genesis__Interest_Only_Period__c;
    global Date genesis__Last_Payment_Date__c;
    global Double genesis__Loan_Amount__c;
    global Double genesis__Net_Investment_Amount__c;
    global Double genesis__Original_Loan_Amount__c;
    global Date genesis__Payment_Amount_2_Start_Date__c;
    global Double genesis__Payment_Amount_2__c;
    /* This input is provided, only for Fin-Calc v.3.0 and above. This field has as percentage or amount. However this value is provided only for step-up repayment schedule, for step-up option.
    */
    global String genesis__Payment_Amount_Step_Up_Type__c;
    global Double genesis__Payment_Amount__c;
    global String genesis__Payment_Frequency_Code__c;
    /* Will be used as a multiplier factor with Payment Frequency to calculate Amortization Schedule.
    */
    global Double genesis__Payment_Frequency_Multiplier__c;
    global Double genesis__Prepaid_Fees__c;
    global Double genesis__Principal_Payment_Amount__c;
    global Double genesis__Rate__c;
    global String genesis__Repayment_Type_Code__c;
    /* Residual Amount, only applicable for lease.
    */
    global Double genesis__Residual_Amount__c;
    global Double genesis__Residual_Term__c;
    global String genesis__Residual_Type__c;
    global Double genesis__Term__c;
    global String genesis__Time_Counting_Method_Code__c;
    global Double genesis__Total_Finance_Charge__c;
    global Double genesis__Total_Financed_Amount__c;
    global Decimal genesis__Total_Lease_Receivable__c;
    global Double genesis__Total_Of_Payments__c;
    global BusinessHours genesis__Bank_Hours__r;
    global Id genesis__Bank_Hours__c;
    global Double genesis__Digits_After_Decimal__c;
    global Boolean genesis__Move_Across_Month__c;
    global String genesis__Repayment_Procedure__c;
    global String genesis__Rounding_Method__c;
    global String genesis__Schedule_Adjustment_Method__c;
    global String genesis__Interest_Period_Calculation__c;
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
    global List<genesis__Lending_Calculator__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Lending_Calculator__c () 
    {
    }
}