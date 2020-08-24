// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Charge__c {
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
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    /* The associated lease.
    */
    global cllease__Lease_Account__c cllease__Lease_Account__r;
    /* The associated lease.
    */
    global Id cllease__Lease_Account__c;
    /* This is the date from which the interest on the charge will be calculated. If this is not mentioned interest will be calculated from the date the charge was incurred.
    */
    global Date cllease__Accrue_Interest_From__c;
    global String cllease__Branch__c;
    global Decimal cllease__Calculated_Interest2__c;
    global Decimal cllease__Calculated_Interest3__c;
    global String cllease__Charge_Type__c;
    global cllease__Contract_Equipment__c cllease__Contract_Equipment__r;
    global Id cllease__Contract_Equipment__c;
    global cllease__Contract_Fees__c cllease__Contract_Fee__r;
    global Id cllease__Contract_Fee__c;
    global String cllease__Contract_Status__c;
    /* This is the date the charge was incurred.
    */
    global Date cllease__Date__c;
    global cllease__Lease_account_Due_Details__c cllease__Dues_Details__r;
    global Id cllease__Dues_Details__c;
    global cllease__Expense_Fees__c cllease__Expense_Fee__r;
    global Id cllease__Expense_Fee__c;
    /* The associated Fee. The Fee object is used in case of automatic application of a charge. For example, the late fees is charged automatically on a lease.
    */
    global clcommon__Fee_Definition__c cllease__Fee_Definition__r;
    /* The associated Fee. The Fee object is used in case of automatic application of a charge. For example, the late fees is charged automatically on a lease.
    */
    global Id cllease__Fee_Definition__c;
    global Decimal cllease__Fee_Due__c;
    /* Please use Fee Definition field that references Fee Definition from CL Common.
    */
    global cllease__Fee__c cllease__Fee__r;
    /* Please use Fee Definition field that references Fee Definition from CL Common.
    */
    global Id cllease__Fee__c;
    /* This flag will be set to True, once the gl accounting entry will be generated for this transaction
    */
    global Boolean cllease__GL_Posted_Flag__c;
    /* Date on which the batch job processed this record for GL posting.
    */
    global Date cllease__GL_Process_Date__c;
    /* This field will be populated with any error/messages happened while gl processing.
    */
    global String cllease__GL_Processing_Message__c;
    /* This flag will be set to True, once the gl accounting entry reversal will be generated for the reversed transaction
    */
    global Boolean cllease__GL_Reversal_Posted_Flag__c;
    /* Date on which the batch job processed this record for GL Reversal posting.
    */
    global Date cllease__GL_Reversal_Process_Date__c;
    /* This flag will determine that gl entry will be generated for this transaction.
    */
    global Boolean cllease__GL_Transaction_Flag__c;
    /* Check this option if the charge is interest bearing.
    */
    global Boolean cllease__Interest_Bearing__c;
    global Decimal cllease__Interest_Due__c;
    /* This is the interest rate to be applied on the charge (if applicable)
    */
    global Double cllease__Interest_Rate__c;
    /* The date when the last interest accrual was processed
    */
    global Date cllease__Last_Accrual_Date__c;
    global String cllease__LeaseApplicationNumber__c;
    global Date cllease__Maturity_Date__c;
    /* The original amount of the charge.
    */
    global Decimal cllease__Original_Amount__c;
    /* The amount that has been paid.
    */
    global Decimal cllease__Paid_Amount__c;
    global Boolean cllease__Paid__c;
    global Decimal cllease__Passthrough_Paid_Amount__c;
    global Boolean cllease__Passthrough_Paid__c;
    global Decimal cllease__Principal_Due__c;
    global cllease__Termination_Quote_Header__c cllease__Quote_header__r;
    global Id cllease__Quote_header__c;
    /* This text can be used to provide additional information about the charge.
    */
    global String cllease__Reference__c;
    global String cllease__Remarks__c;
    global Date cllease__Start_Date__c;
    global Decimal cllease__Tax_Due__c;
    global String cllease__Tax_Processed__c;
    global Double cllease__Tax_Rate__c;
    global Decimal cllease__Total_Due_Amount__c;
    global Date cllease__Transaction_Date__c;
    global cllease__Transaction_Sub_Type__c cllease__Transaction_Sub_Type__r;
    global Id cllease__Transaction_Sub_Type__c;
    /* Check this field if this charge must be waived off.
    */
    global Boolean cllease__Waive__c;
    global String AR_Type__c;
    global String BillingType__c;
    global String CompanyCode__c;
    global cllease__Contract_Equipment__c Contract_Equipment__r;
    global Id Contract_Equipment__c;
    global String Contract_Type__c;
    /* This field will be used to track current paid amount towards Fee amount. This field will be updated during Fee Payment Creation.
    */
    global Decimal Current_Fee_Paid__c;
    /* This field will be used to track current paid amount towards Tax amount. This field will be updated during Fee Payment Creation.
    */
    global Decimal Current_Tax_Paid__c;
    global String DestinationCity__c;
    global String DestinationCounty__c;
    global String DestinationZipCode__c;
    global Decimal Fee_Paid__c;
    global String Fee_Type_for_Term_Quote__c;
    global Boolean Finance_Fee_created__c;
    global Date Invoice_Period_End_Date__c;
    global Date Invoice_Period_Start_Date__c;
    global Invoice__c Invoiced_In__r;
    global Id Invoiced_In__c;
    global String LeaseType__c;
    global String MessageS__c;
    global Boolean Overdue__c;
    global Boolean Passthrough_Charge__c;
    global Property_Tax__c Property_Tax__r;
    global Id Property_Tax__c;
    global Decimal Tax_APO__c;
    global Decimal Tax_BOROUGH__c;
    global Decimal Tax_CITY__c;
    global Decimal Tax_COUNTRY__c;
    global Decimal Tax_COUNTY__c;
    global String Tax_Component__c;
    global Decimal Tax_DISTRICT__c;
    global Decimal Tax_FPO__c;
    global Decimal Tax_LOCAL_IMPROVEMENT_DISTRICT__c;
    global Decimal Tax_PARISH__c;
    global Decimal Tax_PROVINCE__c;
    global Decimal Tax_Paid__c;
    global String Tax_Payment_Type__c;
    global Boolean Tax_Processed__c;
    global Double Tax_Rate_APO__c;
    global Double Tax_Rate_BOROUGH__c;
    global Double Tax_Rate_CITY__c;
    global Double Tax_Rate_COUNTRY__c;
    global Double Tax_Rate_COUNTY__c;
    global Double Tax_Rate_DISTRICT__c;
    global Double Tax_Rate_FPO__c;
    global Double Tax_Rate_LOCAL_IMPROVEMENT_DISTRICT__c;
    global Double Tax_Rate_PARISH__c;
    global Double Tax_Rate_PROVINCE__c;
    global Double Tax_Rate_SPECIAL_PURPOSE_DISTRICT__c;
    global Double Tax_Rate_STATE__c;
    global Double Tax_Rate_TERRITORY__c;
    global Double Tax_Rate_TOWNSHIP__c;
    global Double Tax_Rate_TRADE_BLOCK__c;
    global Double Tax_Rate_TRANSIT_DISTRICT__c;
    global Decimal Tax_SPECIAL_PURPOSE_DISTRICT__c;
    global Decimal Tax_STATE__c;
    global Decimal Tax_TERRITORY__c;
    global Decimal Tax_TOWNSHIP__c;
    global Decimal Tax_TRADE_BLOCK__c;
    global Decimal Tax_TRANSIT_DISTRICT__c;
    global String Taxbasis__c;
    global Decimal Total_Amount__c;
    global String Transaction_Code__c;
    global String Transaction_SubType_Name__c;
    global Decimal Withheld_Amount__c;
    global String DestinationState__c;
    global Decimal cllease__Fee_Paid_Amount__c;
    global Decimal cllease__Original_Tax_Amount__c;
    global Decimal cllease__Tax_Paid_Amount__c;
    global Decimal Original_Tax_Amount__c;
    global Decimal Total_Original_Amount__c;
    global String Equipment__c;
    global clcommon__Consolidated_Invoice__c cllease__Consolidated_Invoice__r;
    global Id cllease__Consolidated_Invoice__c;
    global clcommon__Collateral__c cllease__Equipment_Id__r;
    global Id cllease__Equipment_Id__c;
    global clcommon__Invoice__c cllease__Invoice__r;
    global Id cllease__Invoice__c;
    global Boolean cllease__Invoiced__c;
    global cllease__Payment_Stream__c cllease__Payment_Stream__r;
    global Id cllease__Payment_Stream__c;
    global clcommon__Variable_Rent_Rate__c cllease__Variable_Rent_Rate__r;
    global Id cllease__Variable_Rent_Rate__c;
    /* ACH filename by which charge got paid
    */
    global String cllease__ACH_Filename__c;
    global Decimal cllease__Balance_Writeoff__c;
    global Boolean cllease__Restructured__c;
    /* To mark if the charge was tax exempted by virtue of the fee definition or contract fee
    */
    global Boolean cllease__Tax_Exempt__c;
    /* To mark if the charge had override tax by virtue of the fee definition or contract fee
    */
    global Boolean cllease__Tax_Override__c;
    /* The VAT code applied to the charge inherited from either fee definition or contract fee
    */
    global clcommon__VAT_Rate_Setup__c cllease__VAT_Code__r;
    /* The VAT code applied to the charge inherited from either fee definition or contract fee
    */
    global Id cllease__VAT_Code__c;
    global List<Adjustment__c> Adjustments__r;
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
    global List<Property_Tax__c> Property_Taxes__r;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<clcommon__Disbursement_Transaction__c> cllease__Disbursement_Txns__r;
    global List<cllease__Charge__History> Histories;
    global List<cllease__Disbursement_Transaction__c> cllease__Disbursement_Transactions__r;
    global List<cllease__Expense_Fee_Transaction__c> cllease__Expense_Fees_Txns__r;
    global List<cllease__Fee_Payment__c> cllease__Fee_Payment__r;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Transaction_Details__r;
    global List<cllease__Lease_Payment_Transaction__c> cllease__Payment_Transactions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Charge__c () 
    {
    }
}