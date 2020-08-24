// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Lease_Product__c {
    global Id Id;
    global SObject Owner;
    global Id OwnerId;
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
    global Boolean cllease__Accrue_Subvention__c;
    /* The date on which the lease is approved.
    */
    global Date cllease__Approval_Date__c;
    global clcommon__CL_Product__c cllease__CL_Product__r;
    global Id cllease__CL_Product__c;
    /* Maturity date will be derived by keeping the selected option as the base date.
    */
    global String cllease__Calculate_Maturity_From__c;
    global String cllease__Calculation_Method__c;
    global cllease__Calculation_Set__c cllease__Calculation_Set__r;
    global Id cllease__Calculation_Set__c;
    global String cllease__Days_Convention__c;
    /* Default number of installments
    */
    global Double cllease__Default_Number_of_Installments__c;
    global String cllease__Default_Residual_Type__c;
    /* Number of days the system will wait before categorizing the account as a delinquent account.
    */
    global Double cllease__Delinquency_Grace_Days__c;
    /* Check this Box if you want to do Accrual for Depreciation Expense. Applicable for Operating Leases.
    */
    global Boolean cllease__Dep_Stream_Accrual_Flag__c;
    /* Check this box if Asset is to be depreciated for the full asset life. If not checked, Asset will depreciate over the contract life.
    */
    global Boolean cllease__Dep_over_asset_life__c;
    global Boolean cllease__Depreciation_Expense_Flag__c;
    global String cllease__Depreciation_Method__c;
    /* Base amount over which the depreciation is to be calculated.
    */
    global String cllease__Depreciation_Stream_Basis__c;
    global Decimal cllease__Early_Termination_Fees__c;
    global Boolean cllease__Enable_Subsidy__c;
    global Decimal cllease__Equipment_Return_Fee__c;
    global String cllease__Evergreen_Frequency__c;
    global Double cllease__Evergreen_Term__c;
    /* Fee set contains the details of all the fees associated with the lease.
    */
    global clcommon__Fee_Set__c cllease__Fee_Set1__r;
    /* Fee set contains the details of all the fees associated with the lease.
    */
    global Id cllease__Fee_Set1__c;
    /* Please use Fee Set field that references Fee Set from CL Common.
    */
    global cllease__Fee_Set__c cllease__Fee_Set__r;
    /* Please use Fee Set field that references Fee Set from CL Common.
    */
    global Id cllease__Fee_Set__c;
    /* This decides the Payment Frequency, below are the supported ones:
Daily
Weekly
Bi-weekly
Semi-Monthly
Monthly
Bi-Monthly
Quarterly
Semi-Annual
Annual
SinglePmt
    */
    global String cllease__Frequency_of_Lease_Payment__c;
    global Decimal cllease__GPS_Removal_Fee__c;
    /* Set Flag to Generate Lessee Statment
    */
    global Boolean cllease__Generate_Lessee_Statement__c;
    /* It allows you to provide the client with additional days after the due date for lease repayment.
For example, if the Grace period is defined as 7 days, then the system will wait for 7 days before it starts accruing any Overdue Interest .
    */
    global Double cllease__Grace_Period_Duration__c;
    /* Grace period for repayments
This is the grace period for number of days before the accounts are moved to “Active in bad standing”
    */
    global Double cllease__Grace_Period_for_Repayments__c;
    /* If a date on the repayment schedule falls on a holiday, then shift the repayment date before or after the holiday.
    */
    global String cllease__Holiday_Shift__c;
    /* Check this box if you want to Accrue the Initial Direct Cost.
    */
    global Boolean cllease__IDC_Accrual_Flag__c;
    /* Check this box for Finance Lease for Accrual of Lease Income
    */
    global Boolean cllease__Income_Accrual_Flag__c;
    global String cllease__Income_Accrual_Frequency__c;
    global Boolean cllease__Install_Equipment_Later__c;
    /* This is the number of days for which the system will wait before charging penalty on any charge that is due.
    */
    global Double cllease__Late_Charge_Grace_Days__c;
    /* System generated Lease Product Code
    */
    global String cllease__Lease_Product_Code__c;
    global String cllease__Lease_Product_External_Id__c;
    /* Type of Product, Possible values are
LEASE
    */
    global String cllease__Lease_Product_Type__c;
    /* If this flag is checked then the Amort Start Day from the contract will be taken as base to derive maturity if not then Contract Start Date will be taken as base.
    */
    global Boolean cllease__Maturity_Calculation_Base__c;
    /* Maximum Financed amount for this lease product.
    */
    global Double cllease__Max_Lease_Amount__c;
    /* Maximum number of installments for the lease
    */
    global Double cllease__Max_Number_of_Installments__c;
    /* Maximum number of days between 2 installments
    */
    global Double cllease__Maximum_Gap_Between_Installments__c;
    /* Minimum Financed amount for this lease product.
    */
    global Double cllease__Min_Lease_Amount__c;
    /* Minimum number of installments for the lease
    */
    global Double cllease__Min_Number_of_Installments__c;
    global String cllease__Minimum_Amount_Due_Type__c;
    /* Minimum % of bill amount to be paid by borrower to avoid late fee.
    */
    global Double cllease__Minimum_Amount_Due__c;
    /* Specifies the minimum gap between 2 installments in days.
Mandatory if Can configure variable installments is checked.
    */
    global Double cllease__Minimum_Gap_Between_Installments__c;
    /* Specifies the minimum installment amount for a variable installment lease
    */
    global Double cllease__Minimum_Installment_Amount__c;
    /* Do not calculate - System will not calculate PV
Calculate PV only -  Calculates PV and display the value in the Present Value in the contract details page
Calculate PV and insert equipment - Calculates PV and insert an equipment with the PV value
    */
    global String cllease__PV_Calculation_Options__c;
    global String cllease__Payment_Method__c;
    global cllease__Payment_Spread__c cllease__Payment_Spread__r;
    global Id cllease__Payment_Spread__c;
    /* Number of days for the bill to be generated before the due date.
    */
    global Double cllease__Pre_Bill_Days__c;
    global Account cllease__Private_Label__r;
    global Id cllease__Private_Label__c;
    global String cllease__Product_Sub_Type__c;
    global Double cllease__Quote_Effective_Days__c;
    /* Check this box if you want to accrue Rent. Applicable for Operating Leases.
    */
    global Boolean cllease__Rental_Accrual_Flag__c;
    /* This  field contains the procedure which will be followed to create the installment schedule. The two types of procedures are:
 EMI (Equated Monthly Installments) and Flexible.
    */
    global String cllease__Repayment_Procedure__c;
    /* Check this box if you want to do Residual Accretion
    */
    global Boolean cllease__Residual_Accrual_Flag__c;
    global String cllease__Status__c;
    global String cllease__Subvention_Stream_Basis__c;
    global Double cllease__Termination_Discount_Rate__c;
    global Double cllease__Termination_Lead_Days__c;
    global Decimal cllease__Title_Transfer_Fee__c;
    global String cllease__Track_Cash_Account_Balances__c;
    global String cllease__Track_Non_Cash_Account_Balances__c;
    global Boolean cllease__Use_Calculation_Setup__c;
    global Boolean cllease__Use_Location_Based_Tax_Setup__c;
    /* When this is checked, the latest open period is derived automatically when current period is not open for Accounting. When not checked, the accounting will not happen if the period is closed.
    */
    global Boolean cllease__Use_Open_Acct_Period__c;
    global Boolean cllease__Wait_for_Cash__c;
    /* The Write off tolerance amount determines the maximum amount that the system can write off
    */
    global Double cllease__Write_off_Tolerance_Amount__c;
    /* Check this field to suppress yield calculation. Field applicable only for product sub type operating lease
    */
    global Boolean cllease__Yield_Not_Applicable__c;
    /* Generate Tax Depreciation Streams
    */
    global Boolean cllease__tax_depreciation_streams__c;
    global String cllease__Streams_to_Accrue__c;
    global Double Finance_Charge_Grace_Days__c;
    /* If this field is checked, Termination Quote will expire on Next Due Generation Date, else Quote Effective Days will be considered.
    */
    global Boolean cllease__Quote_Expires_On_Next_Due_Date__c;
    /* Check this if VAT is to be exempted for payment streams
    */
    global Boolean cllease__Tax_Exempt__c;
    /* The date on which Termination Quote will expire
    */
    global String cllease__Termination_Quote_Expiry_Date__c;
    /* No Accrual - System will not accelerate the accrual
Partial Accrual -  System will partially accrue based on the rate factor of terminated equipment
Full Accrual - System will accrue entire income and will not rate factor based on terminated equipment
    */
    global String cllease__Accelerated_Accrual_Option__c;
    /* This field helps to enable Automatic Termination on maturity of Contract
    */
    global Boolean cllease__Auto_Termination__c;
    /* When selected, the contract status will change to evergreen prior to maturity by prebill days. If the evergreen rental is billed in advance then first evergreen bill will be generated prior to maturity by prebill days
    */
    global Boolean cllease__Consider_Prebill_For_Evergreen__c;
    /* The basis on which the Depreciation Stream will be generated during the Evergreen period.
    */
    global String cllease__Evergreen_Depreciation_Basis__c;
    global String cllease__External_Id__c;
    global Boolean cllease__Residual_Billed_At_Maturity__c;
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
    global List<cllease__Accounting_Template_Header__c> cllease__Accounting_Rule_Headers__r;
    global List<cllease__Branch_Lease_Product__c> cllease__Branch_s_Lease_Products__r;
    global List<cllease__Lease_Account__c> cllease__Lease_Accounts__r;
    global List<cllease__Lease_Portfolio_Report__c> cllease__Lease_Portfolio_Reports__r;
    global List<cllease__Lease_Product__History> Histories;
    global List<cllease__Lease_Product__Share> Shares;
    global List<cllease__Search__c> cllease__Search__r;
    global List<cllease__Termination_Config__c> cllease__Termination_Config__r;
    global List<genesis__Applications__c> Applications__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Lease_Product__c () 
    {
    }
}