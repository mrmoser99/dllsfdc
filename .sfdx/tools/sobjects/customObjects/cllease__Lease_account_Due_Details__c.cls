// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Lease_account_Due_Details__c {
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
    global cllease__Lease_Account__c cllease__Lease_Account__r;
    global Id cllease__Lease_Account__c;
    global Account cllease__Account__r;
    global Id cllease__Account__c;
    global Decimal cllease__Balance_Amount__c;
    global String cllease__Branch__c;
    global String cllease__Contract_Status__c;
    global String cllease__Customer__c;
    global Double cllease__Discount__c;
    /* Due Date of the Due
    */
    global Date cllease__Due_Date__c;
    global String cllease__Due_Type_Description__c;
    global Double cllease__Due_Type__c;
    global Boolean cllease__Evergreen_Rent_Flag__c;
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
    global String cllease__Id__c;
    global Boolean cllease__Late_Charge_Applied__c;
    global String cllease__LeaseApplicationNumber__c;
    global Date cllease__Maturity_Date__c;
    global Decimal cllease__Other_Due_Amount__c;
    global Decimal cllease__Other_Paid_Amount__c;
    global Date cllease__Payment_Date__c;
    global Boolean cllease__Payment_Satisfied__c;
    global Date cllease__Period_End_Date__c;
    global Date cllease__Period_Start_Date__c;
    global Boolean cllease__Primary_Flag__c;
    global Double cllease__Purchase_Amount__c;
    global cllease__Termination_Quote_Header__c cllease__Quote_Header__r;
    global Id cllease__Quote_Header__c;
    global Double cllease__Quote_Tax__c;
    global String cllease__Remarks__c;
    global Decimal cllease__Rental_Due_Amount__c;
    global Decimal cllease__Rental_Paid_Amount__c;
    /* This flag will be set to true of the bill is reversed.
    */
    global Boolean cllease__Reversed_Flag__c;
    global Date cllease__Start_Date__c;
    global String cllease__Status__c;
    global Decimal cllease__Tax_Due_Amount__c;
    global Decimal cllease__Tax_Paid_Amount__c;
    global Boolean cllease__Tax_Processed__c;
    global cllease__Termination_Quote__c cllease__Termination_Quote__r;
    global Id cllease__Termination_Quote__c;
    /* Populated from lease account on the basis of tolerance defined.
    */
    global Double cllease__Tolerance__c;
    global Decimal cllease__Total_Due_Amount__c;
    global Decimal cllease__Total_Paid_Amount__c;
    global Double cllease__Total_Tax_Rate__c;
    /* Date on which the transaction got created.
    */
    global Date cllease__Transaction_Date__c;
    global Double cllease__Unbilled_Receivable__c;
    global Double cllease__Cumulative_Tax_Rate__c;
    global Double cllease__Duelines_Items_Count__c;
    global Decimal cllease__Total_Bill_Amount__c;
    global Double Gain_Loss__c;
    global Invoice__c Invoiced_In__r;
    global Id Invoiced_In__c;
    global Decimal Premium_Purchase_Amount__c;
    global Decimal Unbilled_Service_and_Maintenance__c;
    global Double VertexTax_Computed_DDL_Count__c;
    global String Aging_Bucket__c;
    global Double Days_Past_Due__c;
    global Datetime Report_Date_Time__c;
    global Decimal Tax_Due__c;
    global Decimal Rent_Due__c;
    global Decimal Total_Invoice_Amount__c;
    /* This field is populated by the system.
    */
    global clcommon__Bill_Group__c cllease__Bill_Group__r;
    /* This field is populated by the system.
    */
    global Id cllease__Bill_Group__c;
    global clcommon__Billing_Group__c cllease__Billing_Group__r;
    global Id cllease__Billing_Group__c;
    global clcommon__Consolidated_Invoice__c cllease__Consolidated_Invoice__r;
    global Id cllease__Consolidated_Invoice__c;
    global clcommon__Invoice__c cllease__Invoice__r;
    global Id cllease__Invoice__c;
    global Boolean cllease__Invoiced__c;
    /* Payment Stream for which the bill is generated
    */
    global cllease__Payment_Stream__c cllease__Payment_Stream__r;
    /* Payment Stream for which the bill is generated
    */
    global Id cllease__Payment_Stream__c;
    /* Indicates whether this bill has been reversed due to a restructure
    */
    global Boolean cllease__Restructured__c;
    global Decimal Quote_Discount__c;
    global Decimal Quote_Estimated_Property_Tax__c;
    global Decimal Quote_Fee__c;
    global Decimal Quote_Purchase_Amount__c;
    global Decimal Quote_Rollover_Incentive__c;
    global Decimal Quote_Service_and_Maintainence__c;
    global Decimal Quote_Unbilled_Receivable__c;
    global Decimal Rent_Balance__c;
    global Decimal Rent_Bill_Accounting__c;
    global Decimal Quote_Discount_TAX__c;
    global Decimal Quote_Estimated_Property_Tax_TAX__c;
    global Decimal Quote_Fee_TAX__c;
    global Decimal Quote_Purchase_Amount_TAX__c;
    global Decimal Quote_Rollover_Incentive_TAX__c;
    global Decimal Quote_Service_and_Maintenance_TAX__c;
    global Decimal Quote_Unbilled_Receivable_TAX__c;
    global Decimal NPBA_Rent__c;
    global Boolean Include_Rent_In_NPBA__c;
    /* ACH filename by which charge got paid
    */
    global String cllease__ACH_Filename__c;
    global Decimal cllease__Balance_Writeoff__c;
    /* Field to indicate tax exemption
    */
    global Boolean cllease__Tax_Exempt__c;
    /* Field to indicate tax override
    */
    global Boolean cllease__Tax_Override__c;
    global cllease__Transaction_Sub_Type__c cllease__Transaction_Sub_Type__r;
    global Id cllease__Transaction_Sub_Type__c;
    /* Field lookup to VAT Rate used
    */
    global clcommon__VAT_Rate_Setup__c cllease__VAT_Code__r;
    /* Field lookup to VAT Rate used
    */
    global Id cllease__VAT_Code__c;
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
    global List<cllease__Bill_Payment__c> cllease__Bill_Payments__r;
    global List<cllease__Charge__c> cllease__Charges__r;
    global List<cllease__Due_Detail_Lines__c> cllease__Due_Detail_Lines__r;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Transaction_Detail__r;
    global List<cllease__Lease_Payment_Transaction__c> cllease__Payment_Transactions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Lease_account_Due_Details__c () 
    {
    }
}