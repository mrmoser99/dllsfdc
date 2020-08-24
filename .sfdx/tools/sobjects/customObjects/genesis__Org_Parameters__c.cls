// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Org_Parameters__c {
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
    /* If this is checked then we do the rounding off the payment amount and the last principal/interest due amount will be adjusted.
    */
    global Boolean genesis__Adjust_Rounding_in_last_Payment__c;
    global String genesis__Closed_Satus__c;
    global String genesis__Custom_Final_Application_Page__c;
    global String genesis__Custom_Pricing_Calculator__c;
    global String genesis__Custom_Yodlee_Post_Processor_Class__c;
    /* Digits are decimals for rounding.
    */
    global Double genesis__Digits_After_Decimals__c;
    /* If this is checked then there will not any any rounding in amz schedule.
All the interest and payment amount will be saved as un rounded one.
    */
    global Boolean genesis__Disable_Rounding_In_AMZ_Schedule__c;
    /* This option disables all triggers. It is only to be used while migrating data into the system. At all other times, it must be disabled.
    */
    global Boolean genesis__Disable_Triggers__c;
    global Boolean genesis__Enable_Criteria_Based_Task__c;
    global String genesis__Enumerate_Loan_Number_On_Application__c;
    /* This works in combination with Adjust rounding in last Pmt parameter.
If both are checked then rounding is done in last payment by increasing the last payment amount.
If this is unchecked then all the payments will be equated(even).
    */
    global Boolean genesis__Final_Payment_Differ__c;
    /* Enter the version number of calculator.
If it is null, then by default we will use Calculator Version 2.
    */
    global Double genesis__FinancialCalculatorVersion__c;
    /* 1. 'Actual'
2. 'FirstPeriodInterest'
3. 'OneCycleInterest'
4. 'UniformInterestSpread'
    */
    global String genesis__Interest_Only_Period_Behavior__c;
    /* The loggin level of the application. Valid options are:
DEBUG, ERROR, NONE
    */
    global String genesis__Log_Level__c;
    global Boolean genesis__Map_Loan_Number_On_Application__c;
    /* This is MFiFlex internal. Do not delete/edit this value.
    */
    global String genesis__Namespace_Prefix__c;
    global String genesis__Rounding_Mode__c;
    /* Tick this checkbox if you want to choose scorecards that need to be evaluated on an application.
    */
    global Boolean genesis__Scorecard_Selection_Allowed__c;
    /* When this value is true, holidays are not included in dates of the amortization schedule and no dues are generated on holidays. This feature is supported only for the contracts with Daily payment frequency.
    */
    global Boolean genesis__Skip_Holidays__c;
    global Boolean genesis__Use_CL_Product__c;
    /* If checked, CL Common objects for document management(Account & Collateral based folders) will be used else Originate's objects will be used
    */
    global Boolean genesis__Use_Common_Document_Management__c;
    global Boolean genesis__Use_Contact_as_Account__c;
    global Boolean genesis__Use_Appraisal_Management__c;
    global Boolean genesis__Use_Enhanced_Task__c;
    global Boolean genesis__Auto_Assign_Queue_Items__c;
    /* This parameter enables the users use Collateral as Equipment.
    */
    global Boolean genesis__Use_Collateral_As_Equipment__c;
    global Boolean genesis__Use_Rule_Based_Document_Management__c;
    /* This parameter enables the enhanced rule based functionalities for Scorecards.
    */
    global Boolean genesis__Use_Rule_Based_Scorecards__c;
    /* This parameter enables the users to move the stages backward
    */
    global Boolean genesis__Enable_Backward_Stage_Movement__c;
    /* This setting when checked uses expected close date for schedule generation, pricing etc. Otherwise Expected Start Date is used for calculations.
    */
    global Boolean genesis__Use_Expected_Close_Date__c;
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

    global genesis__Org_Parameters__c () 
    {
    }
}