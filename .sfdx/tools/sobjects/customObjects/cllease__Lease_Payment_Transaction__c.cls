// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Lease_Payment_Transaction__c {
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
    global String cllease__ACH_Filename__c;
    global Account cllease__Account__r;
    global Id cllease__Account__c;
    global clcommon__Automated_Payment_Setup__c cllease__Automated_Payment_Setup__r;
    global Id cllease__Automated_Payment_Setup__c;
    global String cllease__Balance_s_Snapshot__c;
    /* Name of the bank to which the check belongs
    */
    global String cllease__Bank_Name__c;
    global cllease__Lease_account_Due_Details__c cllease__Bill__r;
    global Id cllease__Bill__c;
    global String cllease__Borrower_Email__c;
    global String cllease__Cash_Balances_Snapshot__c;
    global cllease__Charge__c cllease__Charge__r;
    global Id cllease__Charge__c;
    /* Captures the check number
    */
    global String cllease__Cheque_Number__c;
    /* Indicates if this lease payment transaction is supervised or not.
    */
    global Boolean cllease__Cleared__c;
    global Datetime cllease__Clearing_Date__c;
    global Decimal cllease__Contract_Sale_Receivable_Billed__c;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Decimal cllease__Current_Payment_Amount_Snapshot__c;
    global Boolean cllease__Custom_Logic__c;
    global Double cllease__Days_Past_Due_SS__c;
    global Decimal cllease__Delinquent_Amount_SS__c;
    global String cllease__Dues_Snapshot__c;
    /* After a lease is disbursed, a client can at any time repay the lease in a single payment.
he system calculates the total amount due as of the current date, including principal, interest, fees and penalties.
    */
    global Boolean cllease__Early_Total_Repayment_of_the_Lease__c;
    global Decimal cllease__Evergreen_Receivable_Billed__c;
    global Decimal cllease__Evergreen_Tax_Billed__c;
    global Decimal cllease__Excess__c;
    /* This field stores an encrypted string of all paid 'Overdue Fees' and 'Charges'. No need to add 'Due Fees' because it is being recorded as a part of 'Installment Snapshot' field on the installment.
    */
    global String cllease__Fee_Snapshot__c;
    global Decimal cllease__Fees__c;
    global Decimal cllease__Fees_spread__c;
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
    global Boolean cllease__GL_Transaction_Flag__c;
    global String cllease__Id__c;
    global Decimal cllease__Interest__c;
    global Decimal cllease__Last_Payment_Amount_SS__c;
    global Date cllease__Last_Payment_Date_SS__c;
    global Datetime cllease__Last_Transaction_Timestamp_SS__c;
    global String cllease__Last_Transaction_Type_SS__c;
    global Decimal cllease__Late_Charge_Principal__c;
    global String cllease__LeaseApplicationNumber__c;
    global String cllease__Lease_Snapshot__c;
    global Boolean cllease__Manual_Payment__c;
    global Date cllease__Oldest_Due_Date_SS__c;
    global Double cllease__Other_Charges_Principal__c;
    global Date cllease__Paid_Off_Date_SS__c;
    global Boolean cllease__Paid_to_Broker_Reversed__c;
    global Boolean cllease__Paid_to_Broker__c;
    global Boolean cllease__Paid_to_Investor_Reversed__c;
    global Boolean cllease__Paid_to_Investor__c;
    global cllease__Payment_Mode__c cllease__Payment_Mode__r;
    global Id cllease__Payment_Mode__c;
    global cllease__Payment_Stream__c cllease__Payment_Stream__r;
    global Id cllease__Payment_Stream__c;
    global Decimal cllease__Principal__c;
    /* Receipt Date
    */
    global Date cllease__Receipt_Date__c;
    /* Receipt ID
    */
    global String cllease__Receipt_ID__c;
    global Decimal cllease__Receivable_Billed__c;
    global Boolean cllease__Rejected__c;
    /* Total amount paid toward Rent (Due bill Rent, Evergreen Rent, Termination Rent & Contract Sale Rent)
    */
    global Decimal cllease__Rent_Amount__c;
    global Boolean cllease__Reversed__c;
    global Date cllease__Sent_To_ACH_On__c;
    global Boolean cllease__Sent_to_ACH__c;
    global Boolean cllease__Skip_Validation__c;
    global Boolean cllease__Spead_Manually__c;
    global String cllease__Status_SS__c;
    /* Total amount paid toward Tax(Due bill Rent, Evergreen Rent & Termination Rent)
    */
    global Decimal cllease__Tax_Amount__c;
    global Decimal cllease__Tax_Billed__c;
    /* DEPRECATED, DO NOT USE.
    */
    global Decimal cllease__Tax_Upfront__c;
    global Decimal cllease__Termination_Receivable_Billed__c;
    global Decimal cllease__Termination_Tax_Billed__c;
    global Decimal cllease__Total_Charges_Principal__c;
    /* Transaction Amount
    */
    global Decimal cllease__Transaction_Amount__c;
    /* Transaction Date
    */
    global Date cllease__Transaction_Date__c;
    global Datetime cllease__Transaction_Time__c;
    global Boolean cllease__Write_Off_Recovery_Payment__c;
    global Double cllease__Cleared_Reversal_Txn_Count__c;
    global Invoice__c For_Invoice__r;
    global Id For_Invoice__c;
    global cllease__Transaction_Sub_Type__c Transaction_Sub_Type__r;
    global Id Transaction_Sub_Type__c;
    /* Field to track PNC Payment Batch Date in all its payments created in CL Lease.
    */
    global Date PNC_Payment_Batch_Date__c;
    /* Field to track PNC Payment Batch total in all cl lease payments.
    */
    global Decimal PNC_Payment_Batch_Total_Amount__c;
    global cllease__Invoice_Credit__c cllease__Invoice_Credit__r;
    global Id cllease__Invoice_Credit__c;
    global Double Invoice_Credit_Amount__c;
    global String cllease__Bills__c;
    global clcommon__Cash_Receipt_Application__c cllease__Cash_Application__r;
    global Id cllease__Cash_Application__c;
    global String cllease__Charges__c;
    /* If checked, LPT is considered as invalid and no further operations are applicable to this LPT e.g. Reversal
    */
    global Boolean cllease__Invalid__c;
    global Decimal cllease__On_Account_Amount__c;
    global String cllease__Remarks__c;
    /* Has this payment been fully or partially reversed due to a contract restructure or termination?
    */
    global Boolean cllease__Restructured__c;
    global Int_PX_Remit__c Int_PX_Remit__r;
    global Id Int_PX_Remit__c;
    /* Internal use.
    */
    global Boolean On_Account_Created__c;
    global clcommon__Consolidated_Invoice__c Pmt_For_Invoice__r;
    global Id Pmt_For_Invoice__c;
    /* Balance writeoff put here for accounting purposes
    */
    global Decimal cllease__Balance_Writeoff__c;
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
    global List<clcommon__Cash_Receipt__c> Payment_Transaction__r;
    global List<cllease__Bill_Payment__c> cllease__Bill_Payments__r;
    global List<cllease__Fee_Payment__c> cllease__Fee_Payment__r;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Transaction_Detail__r;
    global List<cllease__Invoice_Credit__c> On_Account__r;
    global List<cllease__Lease_Payment_Detail__c> cllease__Lease_Payment_Details__r;
    global List<cllease__Lease_Payment_Transaction__History> Histories;
    global List<cllease__Lease_Payment_Transaction__Share> Shares;
    global List<cllease__Repayment_Transaction_Adjustment__c> cllease__Repayment_Transaction_Adjustment__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Lease_Payment_Transaction__c () 
    {
    }
}