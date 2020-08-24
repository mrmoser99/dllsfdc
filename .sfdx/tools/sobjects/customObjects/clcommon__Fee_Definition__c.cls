// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Fee_Definition__c {
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
    global Boolean clcommon__Active__c;
    /* Number or %
Amount, is a flat amount. For other fee calculation methods, this is a % amount.
    */
    global Double clcommon__Amount__c;
    /* Fee Calculation Method
    */
    global String clcommon__Calculation_Method__c;
    /* If Calculation Method is custom, then add the implementation class for it.
    */
    global String clcommon__Implementation_Class__c;
    global Boolean clcommon__Include_In_Dues__c;
    global Boolean clcommon__Interest_Bearing__c;
    global Double clcommon__Interest_Rate__c;
    global Double clcommon__Maximum_Amount__c;
    global Double clcommon__Minimum_Amount__c;
    /* Type of fee
    */
    global String clcommon__Type__c;
    global String clcommon__Amortization_Method__c;
    global String clcommon__Amortization_Period__c;
    /* Select Yes if you want to apply pre bill days specified on the contract at the time of creating charge for this fee.
    */
    global String clcommon__Apply_Pre_Bill_Days__c;
    /* Select this check box to capitalize the charge and track  it in the income stream over the contract term.
    */
    global Boolean clcommon__Capitalize__c;
    /* Fee class can be Income or Expense. The fee is tracked in the related stream for the contract term.
    */
    global String clcommon__Class__c;
    global String clcommon__Fee_Type__c;
    global String clcommon__Passthrough_Event__c;
    /* Select this check box to calculate tax on the charge amount.
    */
    global Boolean clcommon__Taxable__c;
    global String clcommon__Withhold_Basis__c;
    global Double clcommon__Withhold_Value__c;
    global Double RateFactor__c;
    global String External_Id__c;
    /* It indicates if the fee is tax exempted explicitly even if it is taxable
    */
    global Boolean clcommon__Tax_Exempt__c;
    global clcommon__VAT_Rate_Setup__c clcommon__VAT_Rate__r;
    global Id clcommon__VAT_Rate__c;
    global Boolean clcommon__Approval_Process__c;
    global Boolean clcommon__Discount_Fee__c;
    global String clcommon__External_ID__c;
    /* This field identifies the party responsible for paying the fee.
    */
    global String clcommon__Fee_Paid_By__c;
    /* This field identifies the method in which the fee will be collected (e.g. fee amount to be deducted from loan proceeds or paid with borrower’s funds).
    */
    global String clcommon__Fee_Payment_Method__c;
    /* This field identifies the timing of fee payment either at the time of closing or before closing.
    */
    global String clcommon__Fee_Payment_Timing__c;
    global String clcommon__Frequency__c;
    global Boolean clcommon__Include_in_APR__c;
    global Decimal clcommon__Maximum_Discount_Amount__c;
    global Decimal clcommon__Maximum_Waiver_Amount__c;
    global Boolean clcommon__Override_Fee__c;
    global Boolean clcommon__Waive__c;
    /* This fee is applicable to the contract if any payment is rejected/reversed by ACH with mentioned return code
    */
    global String cllease__ACH_Return_Code__c;
    /* If checked, a charge will be created with this fee in the contract whenever ACH is rejected irrespective of the return code.
    */
    global Boolean cllease__Always_Apply_on_ACH_Return__c;
    /* The default value for Fee Amortization Date.
    */
    global String cllease__Amortization_Start_Date__c;
    global List<Application_Fee__c> Application_Fees__r;
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
    global List<clcommon__Equipment_Fees__c> clcommon__Equipment_Fees__r;
    global List<clcommon__Fee_Junction__c> clcommon__Fee_Junction__r;
    global List<clcommon__Fee__c> clcommon__Fees__r;
    global List<clcommon__Payment_Spread_Detail__c> clcommon__Payment_Spread_Details__r;
    global List<clcommon__Variable_Rent_Rate_Card__c> clcommon__Variable_Rent_Rate_Card__r;
    global List<cllease__Charge__c> cllease__Charges__r;
    global List<cllease__Contract_Fees__c> cllease__Contract_Fees__r;
    global List<cllease__Expense_Fee_Transaction__c> cllease__Expense_Fee_Txn__r;
    global List<cllease__Expense_Fees__c> cllease__Expense_Fees__r;
    global List<cllease__Fee_Stream__c> cllease__Fee_Streams__r;
    global List<cllease__Periodic_Fee_Setup__c> cllease__Periodic_Fee_Setup__r;
    global List<cllease__Spread_Detail__c> cllease__Spread_Details__r;
    global List<cllease__Termination_Config_Fee__c> cllease__Termination_Config_Fees__r;
    global List<cllease__Termination_Config_Line__c> cllease__Termination_Config_Lines__r;
    global List<cllease__Termination_Quote_Line__c> cllease__Termination_Quote_Lines__r;
    global List<genesis__Fee_Schedule__c> genesis__Fee_Schedules__r;
    global List<genesis__Yield_Fee_Definition_Association__c> genesis__Yield_Fee_Definition_Association__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Fee_Definition__c () 
    {
    }
}