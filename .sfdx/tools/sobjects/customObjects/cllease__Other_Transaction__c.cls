// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Other_Transaction__c {
    global Id Id;
    global Boolean IsDeleted;
    global String Name;
    global RecordType RecordType;
    global Id RecordTypeId;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global cllease__Lease_Account__c cllease__Lease_Account__r;
    global Id cllease__Lease_Account__c;
    global Date cllease__ACH_End_Date__c;
    global String cllease__ACH_Filename__c;
    global String cllease__ACH_Frequency__c;
    global Date cllease__ACH_Next_Debit_Date__c;
    global Date cllease__ACH_Sent_Date__c;
    global Date cllease__ACH_Start_Date__c;
    global Decimal cllease__Accrue_Subvention__c;
    global Double cllease__Accum_Depreciation__c;
    global Double cllease__Additional_Interest_Amt__c;
    global cllease__Bank_Account__c cllease__Bank_Account__r;
    global Id cllease__Bank_Account__c;
    global Decimal cllease__Bill_Tax_Upfront_Amount__c;
    global String cllease__Billing_Method__c;
    global String cllease__Branch__c;
    global Decimal cllease__Cash_Received_Amount__c;
    global Date cllease__Charged_Off_Date__c;
    global Double cllease__Charged_Off_Fees__c;
    global Double cllease__Charged_Off_Interest__c;
    global Double cllease__Charged_Off_Principal__c;
    global cllease__Contract_ACH_Setup__c cllease__Contract_ACH_Setup__r;
    global Id cllease__Contract_ACH_Setup__c;
    global String cllease__Contract_Old_Status__c;
    global String cllease__Contract_Status__c;
    global Account cllease__Dealer_Name__r;
    global Id cllease__Dealer_Name__c;
    global cllease__Contract_Parties__c cllease__Dealer_Party__r;
    global Id cllease__Dealer_Party__c;
    global Decimal cllease__Dealer_Payable_Amount__c;
    global String cllease__Dealer__c;
    /* Description
    */
    global String cllease__Description__c;
    global Decimal cllease__Documentation_Fee_Amount__c;
    global Date cllease__Due_Date__c;
    global Decimal cllease__Equipment_Cost__c;
    global String cllease__Evergreen_Frequency__c;
    global Boolean cllease__Extend_Maturity_Date__c;
    global String cllease__Frequency_of_Lease_Payment__c;
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
    global Decimal cllease__Gross_Rent_Amount__c;
    global Decimal cllease__Initial_Direct_Cost_Amount__c;
    global Double cllease__Interest_Only_Period__c;
    global Double cllease__Interest_Rate__c;
    global String cllease__LeaseApplicationNumber__c;
    global Decimal cllease__Lease_Residual_Receivable_Amount__c;
    global String cllease__Lease_Snapshot__c;
    global Date cllease__Maturity_Date__c;
    global Decimal cllease__Net_Book_Value_Lease__c;
    global Decimal cllease__Net_Book_Value_Residual__c;
    global Double cllease__New_Due_Day__c;
    global Double cllease__New_Interest_Rate__c;
    global Date cllease__New_Maturity_Date__c;
    global Double cllease__New_Term__c;
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
    global Double cllease__OT_Amount_to_Current__c;
    global Date cllease__OT_Maturity_Date__c;
    global Double cllease__Old_Due_Day__c;
    /* Payment amount before this transaction
    */
    global Double cllease__Old_Payment_Amount__c;
    global cllease__Other_Transaction__c cllease__Parent_Transaction__r;
    global Id cllease__Parent_Transaction__c;
    global Double cllease__Passed_Term__c;
    global Date cllease__Pay_Off_Date__c;
    global Double cllease__Payment_Amount__c;
    global Boolean cllease__Payment_Auto_Compute_Flag__c;
    global cllease__Payment_Mode__c cllease__Payment_Mode__r;
    global Id cllease__Payment_Mode__c;
    /* End date for the payment tolerance
    */
    global Date cllease__Payment_Tolerance_End_Date__c;
    global Double cllease__Payment_Tolerance_Rate__c;
    /* Start date to apply the payment tolerance
    */
    global Date cllease__Payment_Tolerance_Start_Date__c;
    global Double cllease__Principal_Remaining__c;
    global String cllease__Reference__c;
    global Decimal cllease__Referral_Fee_Payable_Amount__c;
    global Boolean cllease__Rejected__c;
    /* Days by which repayments are extended
    */
    global Double cllease__Repayment_Extension_Days__c;
    global Date cllease__Repayment_Start_Date__c;
    global Decimal cllease__Residual_Amount_New__c;
    global Decimal cllease__Residual_Amount_Old__c;
    global Boolean cllease__Reversed__c;
    global Boolean cllease__Same_monthly_payment__c;
    global Double cllease__Security_Deposit__c;
    global Boolean cllease__Sent_To_ACH__c;
    /* Contract Start Date
    */
    global Date cllease__Start_Date__c;
    global Double cllease__Term__c;
    global Double cllease__Termination_Profit__c;
    global Double cllease__Total_Fees_Due__c;
    global Double cllease__Total_Interest_Due__c;
    global String cllease__Transaction_Sub_Type__c;
    global Datetime cllease__Transaction_Time__c;
    global String cllease__Transaction_Type__c;
    global Double cllease__Txn_Amt__c;
    global Date cllease__Txn_Date__c;
    global Double cllease__Unbilled_Rent__c;
    global Decimal cllease__Unearned_Income_Residual_Amount__c;
    global Decimal cllease__Unearned_Lease_Income_Amount__c;
    global Decimal cllease__Unpaid_Dues__c;
    global Decimal cllease__Unpaid_Fees__c;
    global Decimal cllease__Unpaid_Rent__c;
    global Double cllease__Waived_Interest__c;
    global Decimal cllease__disbursement_amount__c;
    global Decimal cllease__income_difference__c;
    global Decimal cllease__payment_difference__c;
    global String AP_Processing_Status__c;
    global String Account__c;
    global Decimal Asset_Cost_of_Sale__c;
    global Decimal Asset_Sale_Value__c;
    global cllease__Asset_workbench__c Asset_workbench__r;
    global Id Asset_workbench__c;
    global Date Contract_Date__c;
    global Double Gross_Receivable_Adjustment__c;
    global Double Income_Adjustment__c;
    /* (Internal usage): To have a link between dealer funding transaction and Int_OLMN_AP__c object
    */
    global String Int_OLMN_AP_link__c;
    global Date Invoice_Date__c;
    global String Invoice_Number__c;
    global Date Maturity_Date__c;
    global Date Payment_Date__c;
    global String Payment_Reference__c;
    global String Purchase_Option__c;
    global Decimal Receivable_Billed__c;
    global Double Residual_Adjustment_Decrease__c;
    global Decimal Rst_Residual__c;
    global Decimal Rst_Total_Income__c;
    global Decimal Rst_Total_Receivable__c;
    global Decimal Rst_Total_Residual_Income__c;
    global Account Sold_to__r;
    global Id Sold_to__c;
    global cllease__Contract_Equipment__c cllease__ContractEquipment__r;
    global Id cllease__ContractEquipment__c;
    global clcommon__Equipment_Detail__c cllease__Equipment_Detail__r;
    global Id cllease__Equipment_Detail__c;
    global Decimal Oracle_Trade_Up_Amount__c;
    global Decimal cllease__Debt_Interest__c;
    global Decimal cllease__Debt_Principal__c;
    /* Applicable for Termination: Part of 'Sale Amount' from the Asset Sale to a Third Party used as a Rebate.
    */
    global Decimal cllease__Rebate_Amount__c;
    /* On restructure this field will be populated with unaccredited subsidy value of the swapped equipment
    */
    global Decimal cllease__Subsidy__c;
    /* On restructure this field will be populated with unaccredited subvention value of the swapped equipment
    */
    global Decimal cllease__Subvention__c;
    /* This amount represents the income which is not yet accrued by system, but falls before the termination date.
    */
    global Double cllease__To_Be_Accrued_Income__c;
    /* This amount represents the rent which is not yet billed by system, but falls before the termination date.
    */
    global Double cllease__To_Be_Billed_Rent__c;
    global Decimal Financed_Upfront_Tax_Amount__c;
    global Decimal Buyout_Billed_Not_Paid_Charges__c;
    global Decimal Buyout_Billed_Not_Paid__c;
    global Decimal Buyout_Residual_Amount__c;
    global Decimal Buyout_Security_Deposit__c;
    global Decimal Buyout_Unbilled_Rent__c;
    global Decimal Buyout_Unearned_Lease_Income__c;
    global Decimal Buyout_Unearned_Residual_Income__c;
    global Decimal Buyout_With_Purchase_Income__c;
    global Decimal Buyout_Without_Purchase_Income__c;
    global Decimal Charge_Off_Billed_Not_Paid__c;
    global Decimal Charge_Off_Residual_Amount__c;
    global Decimal Charge_Off_Security_Deposit_Amount__c;
    global Decimal Charge_Off_Transaction_Amount__c;
    global Decimal Charge_Off_Unbilled_Rent__c;
    global Decimal Charge_Off_Unearned_Lease_Income__c;
    global Decimal Charge_Off_Unearned_Residual_Income__c;
    global Double Equipment_Cost_Rate__c;
    global Decimal Premium_Residual__c;
    global Decimal QUOTE_DISCOUNT__c;
    global Decimal QUOTE_ESTIMATED_SALES_TAX__c;
    global Decimal QUOTE_FEE__c;
    global Decimal QUOTE_PURCHASE_AMOUNT__c;
    global Decimal QUOTE_ROLLOVER_INCENTIVE__c;
    global Decimal QUOTE_SERVICE_AND_MAINTENANCE__c;
    global Decimal QUOTE_UNBILLED_RECEIVABLE__c;
    global Double Residual_Rate__c;
    global Decimal Roll_Over_Quote_Amount__c;
    global Decimal Rollover_Gain__c;
    global Decimal Rollover_Loss__c;
    global Decimal Rollover_Purchase_Amount__c;
    global Decimal Rollover_Quote_Discount__c;
    global Decimal Rollover_Quote_Estimated_Property_Tax__c;
    global Decimal Rollover_Quote_Fee__c;
    global Decimal Rollover_Quote_Service_and_Maintenance__c;
    global Decimal Rollover_Quote_Unbilled_Receivable__c;
    global Double Subsidy_Rate__c;
    global Double Subvention_Rate__c;
    global Decimal Termination_Bill_Unpaid__c;
    global Decimal Termination_Fee_Unpaid__c;
    global Decimal Termination_Future_Rent__c;
    global Decimal Termination_Gain__c;
    global Decimal Termination_IDC_Expense__c;
    global Decimal Termination_Income__c;
    global Decimal Termination_Loss__c;
    global Decimal Termination_Quote_Amount__c;
    global String Termination_Quote_Reason__c;
    global String Termination_Quote_Type__c;
    global cllease__Termination_Quote_Header__c Termination_Quote__r;
    global Id Termination_Quote__c;
    global Decimal Termination_Residual_Income__c;
    global Decimal Termination_Security_Deposit__c;
    global Decimal Termination_Subsidy_Income__c;
    global Decimal Termination_Subvention_Income__c;
    global Decimal Termination_Unearned_Income__c;
    global Decimal Termination_With_Purchase_Residual__c;
    global Decimal Termination_Without_Purchase_Residual__c;
    global Decimal NPA_Temp_Booking_Amounts__c;
    global String cllease__History_Information__c;
    global String cllease__History_Tracking_Id__c;
    global cllease__Termination_Quote_Header__c cllease__Termination_Quote__r;
    global Id cllease__Termination_Quote__c;
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
    global List<cllease__Dealer_Funding_Detail__c> cllease__Dealer_Funding_Details__r;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Transaction_Detail__r;
    global List<cllease__Income_Stream_History__c> cllease__Income_Stream_History__r;
    global List<cllease__Initial_Direct_Cost_Stream_History__c> cllease__IDC_Stream_History__r;
    global List<cllease__Other_Transaction__c> cllease__Other_Lease_Transactions__r;
    global List<cllease__Residual_Stream_History__c> cllease__Residual_Stream_History__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Other_Transaction__c () 
    {
    }
}