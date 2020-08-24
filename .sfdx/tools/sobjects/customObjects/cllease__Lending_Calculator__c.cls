// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Lending_Calculator__c {
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
    global Double cllease__APR__c;
    global String cllease__Accrual_Base_Method_Code__c;
    /* Accrual Start Date
    */
    global Date cllease__Accrual_Start_Date__c;
    /* Accrual Start Days
    */
    global Double cllease__Accrual_Start_Days__c;
    global String cllease__Action__c;
    global Double cllease__Additional_Interest_Amount__c;
    global Date cllease__Advance_Payment_Date__c;
    global Date cllease__Amort_Start_Date__c;
    global String cllease__Amortization_Calculation_Method_Code__c;
    global Boolean cllease__Amortization_Schedule_Creation_Flag__c;
    global Double cllease__Amortized_Rate__c;
    global Double cllease__Balance_Amount__c;
    global String cllease__Balloon_Method_Code__c;
    global Double cllease__Balloon_Payment_Amount__c;
    global String cllease__Billing_Method_Code__c;
    global String cllease__Calculator_Type__c;
    global Date cllease__Contract_Date__c;
    global Boolean cllease__Dep_Stream_Accrual_Flag__c;
    global String cllease__Depreciation_Stream_Basis__c;
    global Double cllease__Equipment_Cost__c;
    global Double cllease__Final_Payment_Amount__c;
    global Double cllease__Financed_Amount__c;
    global Double cllease__Financed_Fees__c;
    global Date cllease__First_Payment_Date__c;
    global Double cllease__First_Period_Calender_Days__c;
    global Double cllease__First_Period_Interest__c;
    global Boolean cllease__Flat_Interest_Flag__c;
    global Boolean cllease__Flexible_Repayment_Flag__c;
    global Boolean cllease__IDC_Accrual_Flag__c;
    global Boolean cllease__Income_Accrual_Flag__c;
    global String cllease__Income_Accrual_Frequency__c;
    /* Initial_Direct_Cost, only applicable for lease.
    */
    global Double cllease__Initial_Direct_Cost_Amount__c;
    global String cllease__Installment_Method_Code__c;
    global Double cllease__Interest_Amount__c;
    global Double cllease__Interest_Only_Period__c;
    global Double cllease__Lease_Amount__c;
    global Date cllease__Maturity_Date__c;
    /* This the original financed amount.
    */
    global Double cllease__Net_Investment_Amount__c;
    global Double cllease__Original_Lease_Amount__c;
    global Double cllease__Original_Term__c;
    global Date cllease__Payment_Amount_2_Start_Date__c;
    global Double cllease__Payment_Amount_2__c;
    global Double cllease__Payment_Amount__c;
    global String cllease__Payment_Frequency_Code__c;
    global String cllease__Payment_Method__c;
    global Boolean cllease__Payment_in_Arrears__c;
    global Date cllease__Periodic_Payment_Starts__c;
    global Double cllease__Prepaid_Fees__c;
    global Double cllease__Principal_Payment_Amount__c;
    global String cllease__Product_Sub_Type__c;
    global Double cllease__Rate__c;
    global Date cllease__Rent_Maturity_Date__c;
    global Boolean cllease__Rental_Accrual_Flag__c;
    global String cllease__Repayment_Type_Code__c;
    global Boolean cllease__Residual_Accrual_Flag__c;
    /* Residual Amount, only applicable for lease.
    */
    global Double cllease__Residual_Amount__c;
    global Double cllease__Residual_Term__c;
    global String cllease__Residual_Type__c;
    global String cllease__Term_Residual_Frequency__c;
    global Double cllease__Term__c;
    global String cllease__Time_Counting_Method_Code__c;
    global Double cllease__Total_Finance_Charge__c;
    global Double cllease__Total_Financed_Amount__c;
    global Decimal cllease__Total_Lease_Receivable__c;
    global Double cllease__Total_Of_Payments__c;
    global String cllease__advance_payments__c;
    global Boolean cllease__dep_over_asset_life__c;
    global Boolean cllease__is_evergreen__c;
    global Double cllease__life_in_months__c;
    global Double cllease__Currency_Precision__c;
    global Decimal cllease__Total_Rent_Receivable__c;
    /* This is the amount on which the residual amount will depreciate in the Evergreen period.
    */
    global Decimal cllease__Evergreen_Depreciation_Amount__c;
    /* The basis on which the Depreciation Stream will be generated during the Evergreen period.
    */
    global String cllease__Evergreen_Depreciation_Basis__c;
    global Date cllease__Evergreen_Start_Date__c;
    global Boolean cllease__Tax_Exempt__c;
    global Boolean cllease__Tax_Override__c;
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
    global List<cllease__Lending_Calculator__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Lending_Calculator__c () 
    {
    }
}