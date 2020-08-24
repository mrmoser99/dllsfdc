// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Applications__c {
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
    global Date LastActivityDate;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global Double genesis__APR__c;
    global Account genesis__Account__r;
    global Id genesis__Account__c;
    global genesis__Action__c genesis__Action__r;
    global Id genesis__Action__c;
    global Decimal genesis__Additional_Cash_Required__c;
    global Double genesis__Amortization_Term__c;
    global Boolean genesis__Arrears__c;
    global String genesis__Asset_Class__c;
    global genesis__Asset_Liability_Info__c genesis__Asset_Liability_Info__r;
    global Id genesis__Asset_Liability_Info__c;
    global User genesis__Assigned_To__r;
    global Id genesis__Assigned_To__c;
    global Boolean genesis__Auto_Decisioning__c;
    global Double genesis__Balloon_Payment__c;
    global String genesis__Bank_Account_Number__c;
    global String genesis__Bank_Account_Type__c;
    global String genesis__Bank_Name__c;
    global Boolean genesis__Bank_Transactions_Fetched__c;
    global clcommon__Company__c genesis__CL_Company__r;
    global Id genesis__CL_Company__c;
    global String genesis__CL_Product_Name__c;
    global clcommon__CL_Product__c genesis__CL_Product__r;
    global Id genesis__CL_Product__c;
    global clcommon__CL_Purpose__c genesis__CL_Purpose__r;
    global Id genesis__CL_Purpose__c;
    global String genesis__Calculation_Action__c;
    global String genesis__Call_Code__c;
    global Decimal genesis__Cap_Reduction__c;
    global Decimal genesis__Cash_Collected_By_Dealer__c;
    global String genesis__Charge_offs__c;
    global String genesis__Class_Code__c;
    global clcommon__Collateral_Type__c genesis__Collateral_Type__r;
    global Id genesis__Collateral_Type__c;
    global Decimal genesis__Collateral_Value__c;
    global genesis__Company__c genesis__Company__r;
    global Id genesis__Company__c;
    global Contact genesis__Contact__r;
    global Id genesis__Contact__c;
    global Double genesis__Credit_Limit__c;
    global genesis__Credit_Rating_Matrix__c genesis__Credit_Rating__r;
    global Id genesis__Credit_Rating__c;
    global Decimal genesis__Customer_Cash_Available__c;
    global String genesis__Customer_Cash_Used_For__c;
    global String genesis__Days_Convention__c;
    global Date genesis__Dealer_Payment_Date__c;
    global String genesis__Description__c;
    global Date genesis__Disbursement_Date__c;
    global String genesis__Discount_Rate_Based_On__c;
    global Double genesis__Discount_Rate__c;
    global Decimal genesis__Documentation_Charges__c;
    global Decimal genesis__Down_Payment__c;
    global Date genesis__Draw_Period_End_Date__c;
    global Double genesis__Draw_Term__c;
    /* If Due Day field is null, then by default it will have Expected First Payment Date day value
    */
    global Double genesis__Due_Day__c;
    global Boolean genesis__Employee_Loan__c;
    global Decimal genesis__Estimated_Selling_Price__c;
    global Date genesis__Expected_Close_Date__c;
    global Date genesis__Expected_First_Payment_Date__c;
    global Date genesis__Expected_Second_Pay_Day_Date__c;
    global Date genesis__Expected_Start_Date__c;
    global Decimal genesis__Fees_Amount__c;
    global Decimal genesis__Financed_Amount__c;
    global Boolean genesis__Funding_in_Tranches__c;
    global Decimal genesis__Gross_Annual_Income__c;
    global String genesis__Healthcare_Procedure__c;
    global String genesis__ID_Number__c;
    global String genesis__ID_State__c;
    global String genesis__ID_Type__c;
    global Decimal genesis__Initial_Advance__c;
    global String genesis__Interest_Calculation_Method__c;
    /* Interest compounding frequency can be used to calculate Interest with Compound Interest as calculation method for the respective frequency selected.
    */
    global String genesis__Interest_Compounding_Frequency__c;
    global Double genesis__Interest_Only_Period__c;
    global Double genesis__Interest_Rate__c;
    global Boolean genesis__Is_Get_Yield_Enabled__c;
    global Boolean genesis__Is_over_21__c;
    /* Ratio of Loan Amount to Total Pledged Collateral Amount
    */
    global Double genesis__LTV_Pledged_Collateral__c;
    global Double genesis__Landing_Sequence__c;
    global genesis__Loan_Product__c genesis__Lending_Product__r;
    global Id genesis__Lending_Product__c;
    global Double genesis__Loan_Amount__c;
    global String genesis__Loan_Number__c;
    global Double genesis__Margin__c;
    global Date genesis__Maturity_Date__c;
    global Decimal genesis__Maximum_Loan_Amount_DTI__c;
    global Decimal genesis__Minimum_Cash_Required__c;
    global Decimal genesis__Monthly_Debt_Payments__c;
    global genesis__Monthly_Income_Expense_Info__c genesis__Monthly_Income_Expense_Info__r;
    global Id genesis__Monthly_Income_Expense_Info__c;
    global Double genesis__Net_Present_Value__c;
    global Double genesis__No_Of_Payments_Required_Upfront__c;
    global Double genesis__Number_of_Pieces_of_Equipment__c;
    global Decimal genesis__Other_Financed_fees__c;
    /* Tracks overall status of the application.
    */
    global String genesis__Overall_Status__c;
    global genesis__Applications__c genesis__Parent_Application__r;
    global Id genesis__Parent_Application__c;
    global Date genesis__Participation_Date__c;
    global Decimal genesis__Payable_To_Dealer__c;
    /* This input is provided, only for Fin-Calc v.3.0 and above. This field has as percentage or amount. However this value is provided only for step-up repayment schedule, for step-up option.
    */
    global String genesis__Payment_Amount_Step_Up_Type__c;
    global Double genesis__Payment_Amount__c;
    global Date genesis__Payment_Due_Date__c;
    /* Will be used as a multiplier factor with Payment Frequency to calculate Amortization Schedule.
    */
    global Double genesis__Payment_Frequency_Multiplier__c;
    global String genesis__Payment_Frequency__c;
    global String genesis__Portfolio__c;
    global String genesis__Prepaid_Interest_Option__c;
    global String genesis__Prepayment_Penalty_Description__c;
    global Boolean genesis__Prepayment_Penalty__c;
    global String genesis__Pricing_Method__c;
    global String genesis__Primary_Collateral_Code__c;
    /* Address of Primary Property
    */
    global String genesis__Primary_Property_Address__c;
    global String genesis__Primary_Source_of_Repayment__c;
    /* Conversion Probablity
    */
    global Double genesis__Probability__c;
    global String genesis__Product_Sub_Type__c;
    global String genesis__Product_Type__c;
    global genesis__Quick_Quotes__c genesis__Quick_Quote__r;
    global Id genesis__Quick_Quote__c;
    global Double genesis__Rate_Ceiling__c;
    global Boolean genesis__Rate_Discount__c;
    global Double genesis__Rate_Floor__c;
    global String genesis__Regulation_O__c;
    global Decimal genesis__Required_Customer_Cash__c;
    global Decimal genesis__Residual_Amount__c;
    global Decimal genesis__Retained_Amount__c;
    global String genesis__Routing_Number__c;
    /* Sales Division.
    */
    global String genesis__Sales_Division__c;
    global String genesis__Secondary_Source_of_Repayment__c;
    global Double genesis__Spread__c;
    global String genesis__Status__c;
    global Decimal genesis__Sublimit_Variance__c;
    global Decimal genesis__Tax_Amount__c;
    global Double genesis__Term__c;
    global String genesis__Terms_Selected__c;
    global Decimal genesis__Total_Cash_Due_from_Customer__c;
    /* Total Amount Payable To Dealer by lessor.
    */
    global Decimal genesis__Total_Dealer_Payable__c;
    /* Total Dealer Price.
    */
    global Decimal genesis__Total_Dealer_Price__c;
    global Double genesis__Total_Estimated_Interest__c;
    global Double genesis__Total_Facilities__c;
    /* Sum of loan amount of all the facilities in the Package
    */
    global Decimal genesis__Total_Facility_Amount__c;
    /* Difference in loan amount on package application and the total facility amount
    */
    global Decimal genesis__Total_Facility_Variance__c;
    /* Sum of fee amount of all the fees associated with the application
    */
    global Decimal genesis__Total_Fee_Amount__c;
    /* Sum of pledged amount of all the collaterals associated with the application
    */
    global Decimal genesis__Total_Pledged_Collateral_Amount__c;
    global Decimal genesis__Total_Upfront_Payments__c;
    /* This field will be set to true once the pricing has been generated, but any subsequent update on quick quote will set this to false and will force user to generate the pricing again.
    */
    global Boolean genesis__Valid_Pricing_Flag__c;
    global Decimal genesis__Warranty_Amount__c;
    global Double genesis__Yield__c;
    /* Sum of amount on the sublimit for the application
    */
    global Decimal genesis__SubLimit_Total__c;
    global Double genesis__Total_Score__c;
    global String genesis__Repayment_Procedure__c;
    global Decimal genesis__Subvention_Amount__c;
    global Double genesis__Subvention_Percent__c;
    global Double Allowable_Soft_Cost__c;
    global Application_Fee__c Application_Fee__r;
    global Id Application_Fee__c;
    global Address__c Billing_Address1__r;
    global Id Billing_Address1__c;
    global String Billing_Email_Address__c;
    global Date Booking_Date__c;
    global String Capitalize_UpFront_Tax__c;
    global String Contract_Signer_Title__c;
    global String Contract_Signer__c;
    global String Contract_Type__c;
    global String DLL_Reference_Number__c;
    global Date Dealer_Invoice_Date__c;
    global String Dealer_Invoice_Number__c;
    global Boolean Dealer_Invoice__c;
    global String Dealer_Name__c;
    global clcommon__Agreement__c Dealer_Program__r;
    global Id Dealer_Program__c;
    global Account Dealer__r;
    global Id Dealer__c;
    global String EIN_Number__c;
    global genesis__Application_Equipment__c Equipment__r;
    global Id Equipment__c;
    global String Fee_Set_Lease__c;
    global String Fee_Set__c;
    global Boolean Insurance_Certificate__c;
    global Date Invoice_Date__c;
    global String Invoice_Number__c;
    global Boolean KYC_Cleared__c;
    global cllease__Lease_Account__c Lease_Number__r;
    global Id Lease_Number__c;
    global cllease__Lease_Product__c Lease_Product_Name__r;
    global Id Lease_Product_Name__c;
    global String Lease_Type__c;
    global Decimal Net_Dealer_Funding__c;
    global Decimal Net_Trade_Up_Amount__c;
    global String PO_Number__c;
    global String Payment_Method__c;
    global String Payment_Term__c;
    global genesis__Application_Pricing_Detail__c Pricing_Details__r;
    global Id Pricing_Details__c;
    global String Product_Name__c;
    global String Purchase_Option__c;
    global Boolean Purchase_Order__c;
    global Double Rate_Factor__c;
    global cllease__Termination_Quote_Header__c Roll_Over_Quote_Number__r;
    global Id Roll_Over_Quote_Number__c;
    global Decimal Service_Fee__c;
    global Boolean Signed_D_A__c;
    global Boolean Signed_Lease_Agreement__c;
    global Date Start_Date__c;
    global Boolean Tax_Exempt_Certificate__c;
    global Boolean Tax_Exempt__c;
    global Decimal Total_Lease_Payment__c;
    global Decimal Total_Upfront_Tax_Amount__c;
    global Boolean Trade_Up_Quote__c;
    global String Transaction_Code__c;
    global String fee_set_temp__c;
    global Date Equipment_Install_Date__c;
    global Double No_of_Equipments__c;
    global Decimal Total_Application_Fee_Amount__c;
    global Decimal Total_Estimated_Property_Tax__c;
    global Decimal Total_Insurance_Fees__c;
    global Decimal Total_Service_Fees__c;
    global Decimal Rent_Amount__c;
    global String Contract_Signer_Last_Name__c;
    global Double Selected_Pricing_Count__c;
    global String Duplicate_Dealer_Invoice_Number__c;
    global Boolean Customer_Provided_Insurance__c;
    global String Rate_Card_Selection__c;
    global String View_Record__c;
    global Double Pricing_Rate_Factor__c;
    global String Lease_Document_Trigger_Formula__c;
    global Boolean Lease_Document_Trigger__c;
    global String Custom_Finance_Charge_Grace_Days__c;
    global String Custom_Late_Charge_Grace_Days__c;
    global Decimal Oracle_Trade_Up_Amount__c;
    global String Oracle_Trade_up_Lease_Number__c;
    global String Oracle_Trade_up_Quote_Number__c;
    global Decimal Total_Equipment_Selling_Price__c;
    global Date Oracle_Trade_up_Quote_Expiration_Date__c;
    /* This field stores the Combined DTI ratio for an application
    */
    global Double genesis__Combined_Debt_To_Income_Ratio__c;
    global Boolean genesis__Employee_Application__c;
    /* This field is a lookup to the Vendor program for which the application is created
    */
    global clcommon__Program__c genesis__Program__r;
    /* This field is a lookup to the Vendor program for which the application is created
    */
    global Id genesis__Program__c;
    /* This field stores the Proposed DTI ratio for an application
    */
    global Double genesis__Proposed_Debt_to_Income_Ratio__c;
    /* This field stores the Unsecured DTI ratio for an application
    */
    global Double genesis__Unsecured_Debt_To_Income_Ratio__c;
    /* This field is lookup to the Vendor account
    */
    global Account genesis__Vendor__r;
    /* This field is lookup to the Vendor account
    */
    global Id genesis__Vendor__c;
    global Decimal Dll_Rent__c;
    global Boolean Not_Service__c;
    global Boolean Service__c;
    global String Lease_Document_ESign_Trigger_Formula__c;
    global Boolean Lease_Document_Trigger_Esign__c;
    global Double No_of_Equipment_with_Install_Date__c;
    global Decimal NPA_Amount__c;
    global Boolean Generate_UBO__c;
    global String UBO_Document_Formula__c;
    global String Trade_Up_From__c;
    global String Lease_eSign_Test__c;
    global String genesis__Account_Owner_Name__c;
    global Boolean genesis__Agricultural_Use__c;
    global Date genesis__Application_Submission_Date__c;
    /* This has to be a look up on Account.
    */
    global Account genesis__Auto_Debit_Account_Owner__r;
    /* This has to be a look up on Account.
    */
    global Id genesis__Auto_Debit_Account_Owner__c;
    /* This checkbox determines if the loan/lease application is exempt from beneficial owner requirements.
    */
    global Boolean genesis__Beneficial_Owner_Exempt__c;
    /* This field depicts Combined Loan to Value Ratio
    */
    global Double genesis__CLTV__c;
    /* This field will be captured on the application, when the loan involves a construction property as a collateral.
    */
    global String genesis__Construction_Type__c;
    /* This field represents the current repayment capacity of all the borrower parties to repay in term of monthly loan payment
    */
    global Double genesis__Current_Repayment_Capacity__c;
    global Double genesis__Downpayment_Percentage__c;
    global Date genesis__Due_Date__c;
    /* This checkbox is to indicate when an electronic signature will be used.
    */
    global Boolean genesis__E_Signatures__c;
    /* This field is to enter the amount of Florida documentary stamp tax.
    */
    global Decimal genesis__Florida_Stamp_Tax_Amount__c;
    /* Indicate if the Florida documentary stamp tax is applicable.
    */
    global Boolean genesis__Florida_Stamp_Tax__c;
    /* This checkbox is to indicate that the loan is exempt from beneficial owner due diligence.
    */
    global Boolean genesis__HMDA__c;
    global String genesis__Interest_Level__c;
    /* This field is to support indirect lending and leasing.
    */
    global Boolean genesis__Is_Indirect__c;
    /* This checkbox will determine if the application is a renewal application. It will be populated based on the renewal transaction.
    */
    global Boolean genesis__Is_Renewal__c;
    /* This checkbox will identify if the loan is a secured loan
    */
    global Boolean genesis__Is_Secured__c;
    global Double genesis__LOC_Fixed_Payment_Amount__c;
    global String genesis__LOC_Payment_Type__c;
    /* This field depicts Loan to Value Ratio
    */
    global Double genesis__LTV__c;
    /* This field is to identify specific application types that are needed for generation of closing documents.
    */
    global String genesis__Loan_Application_Type__c;
    /* This date is to record the date on which the loan decision has been made.This date must be updated via salesforce approval process or via other methods when the loan status is either approved or rejected.
    */
    global Date genesis__Loan_Decision_Date__c;
    /* This field is to identify if the loan is an open ended or closed ended loan.
    */
    global String genesis__Loan_Term_Type__c;
    global String genesis__No_Of_Payments_In_Advance__c;
    /* This is the date on which the acknowledgment was performed and the notary public has signed the acknowledgment.
    */
    global Date genesis__Notarization_Date__c;
    global String genesis__Notes__c;
    /* This checkbox will determine if the loan is payable on demand.
    */
    global Boolean genesis__Payable_On_Demand__c;
    /* This field will store the percentage of outstanding that needs to be repaid as part of the LOC repayment.
    */
    global Double genesis__Percentage_Of_Outstanding_Principal__c;
    /* This field will contain the total monthly payment amount from all liabilities of all borrowers+ the proposed monthly payment amount of the current application
    */
    global Double genesis__Proposed_Monthly_Payment_Amount__c;
    /* This field represents the proposed repayment capacity of all the borrower parties to repay in term of monthly loan payment considering the ongoing loan application
    */
    global Double genesis__Proposed_Repayment_Capacity__c;
    /* This field stores the date on which interest rate is locked on the application.
    */
    global Date genesis__Rate_Lock_Date__c;
    /* This field is used to capture the period for which interest rate on rate schedule will be locked.
    */
    global Double genesis__Rate_Lock_Period__c;
    /* This field stores the validity period for rate lock on the application.
    */
    global Double genesis__Rate_Lock_Validity_Period__c;
    /* This field denotes whether the rate for first rate schedule on application is locked or not.
    */
    global Boolean genesis__Rate_Lock__c;
    /* This field defines the frequency at which the index needs to be refreshed on the contract
    */
    global String genesis__Rate_Revision_Frequency__c;
    /* Reg O purpose captures the purpose for which the loan is being applied for by the employee/insder.
    */
    global String genesis__Reg_O_Purpose__c;
    /* This field keeps the information of requested loan amount at the time of application creation
    */
    global Decimal genesis__Requested_Loan_Amount__c;
    global clcommon__CL_Purpose__c genesis__Secondary_Purpose__r;
    global Id genesis__Secondary_Purpose__c;
    /* If true, then this application will not be considered in computing values on the associated Credit Line or Package application.
    */
    global Boolean genesis__Skip_Usage_On_Parent_Application__c;
    global String genesis__Solve_For__c;
    global String genesis__Solved_For__c;
    /* This field will store the notification type of the notice that needs to be sent to the spouse of the borrower in the loan application.
    */
    global String genesis__Spousal_Notice__c;
    global Date genesis__Tax_Deferral_Payment_Date__c;
    global Double genesis__Tax_Deferral_Payment_Period__c;
    /* This field aggregates the Points Amount of Points Type Broker.
    */
    global Decimal genesis__Total_Broker_Points__c;
    /* This field aggregates the Points Amount of Points Type Manufacturer.
    */
    global Decimal genesis__Total_Manufacturing_Points__c;
    /* This field will contain the total monthly income all borrowers in the application.
    */
    global Double genesis__Total_Monthly_Income_Of_All_Borrowers__c;
    /* This field will contain the total monthly payment amount from all liabilities of all borrowers.
    */
    global Double genesis__Total_Monthly_Payments__c;
    /* This field aggregates the Points Amount of Points Type Vendor.
    */
    global Decimal genesis__Total_Vendor_Points__c;
    global Double genesis__Yield_After_Payout__c;
    /* This field will store the rollup summary of all the borrower's Assets(sum of Market Value). This is from asset information.
    */
    global Double genesis__Total_Assets__c;
    global List<ActivityHistory> ActivityHistories;
    global List<Application_Fee_Payment__c> Application_Fee_Payment__r;
    global List<Application_Fee__c> Application_Fees__r;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CAMS_Check__c> CAMS_Checks__r;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Equipment_Funding_Detail__c> Equipment_Funding_Detail__r;
    global List<Event> Events;
    global List<LookedUpFromActivity> genesis__Activities__r;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OFAC_Log__c> OFAC_Log__r;
    global List<OpenActivity> OpenActivities;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<Service_Fee_Escalation_Config__c> Service_Fee_Escalation_Configs__r;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<clcommon__Approval_Instance__c> genesis__Application_Approval_Instances__r;
    global List<clcommon__CollateralLien__c> genesis__Collateral_Liens__r;
    global List<clcommon__Collateral__c> genesis__Collaterals__r;
    global List<clcommon__Covenant_Association__c> genesis__Covenant_Associations__r;
    global List<clcommon__Document_Category__c> genesis__Document_Category__r;
    global List<clcommon__Execution_Criteria_Result__c> genesis__Execution_Criteria_Result__r;
    global List<clcommon__Fee_Schedule__c> genesis__Fee_Schedules1__r;
    global List<clcommon__Fee__c> genesis__Fees__r;
    global List<clcommon__Financial_Statement__c> genesis__Financial_Statements__r;
    global List<clcommon__Holiday_Schedule__c> genesis__Holiday_Schedule__r;
    global List<clcommon__Party__c> genesis__Parties__r;
    global List<clcommon__Points__c> genesis__Points__r;
    global List<clcommon__Questionnaire_Instance__c> genesis__Questionnaire_Instances_Application__r;
    global List<clcommon__Repayment_Plan__c> genesis__Repayment_Plans__r;
    global List<clcommon__StepUp_Schedule__c> genesis__StepUp_Schedules__r;
    global List<cllease__Lease_Account__c> LS_Contracts__r;
    global List<dsfs__DocuSign_Status__c> DocuSign_Status__r;
    global List<genesis__Action__c> genesis__Action__r;
    global List<genesis__Adverse_Action_Application_Junction__c> genesis__Adverse_Action_Application_Junctions__r;
    global List<genesis__Agenda_Item__c> genesis__Agenda_Items__r;
    global List<genesis__Amortization_Schedule__c> genesis__Amortization_Schedule__r;
    global List<genesis__Application_Alternate_Product__c> genesis__Application_Alternate_Products__r;
    global List<genesis__Application_Business_Information__c> genesis__Business_Information__r;
    global List<genesis__Application_Collateral__c> genesis__Application_Collaterals__r;
    global List<genesis__Application_Compliance_Information__c> genesis__Application_Compliance_Informations__r;
    global List<genesis__Application_Decisions__c> genesis__decision__r;
    global List<genesis__Application_Department__c> genesis__Application_Departments__r;
    global List<genesis__Application_Document_Category__c> genesis__Application_Document_Category__r;
    global List<genesis__Application_Equipment__c> genesis__Application_Equipments__r;
    global List<genesis__Application_Note__c> genesis__Application_Notes__r;
    global List<genesis__Application_Parties__c> genesis__Application_Parties__r;
    global List<genesis__Application_Pricing_Detail__c> genesis__Pricing_Details__r;
    global List<genesis__Application_Rule_Setup__c> genesis__Application_Rule_Setup__r;
    global List<genesis__Application_Scorecard__c> genesis__Application_Scorecards__r;
    global List<genesis__Application_Status_History__c> genesis__Application_Status_History__r;
    global List<genesis__Application_s_Scorecard__c> genesis__Application_s_Scorecard__r;
    global List<genesis__Applications__Feed> Feeds;
    global List<genesis__Applications__History> Histories;
    global List<genesis__Applications__Share> Shares;
    global List<genesis__Applications__c> genesis__Parent_Applications__r;
    global List<genesis__Asset_Information__c> genesis__Assets_Information__r;
    global List<genesis__Budget__c> genesis__Budgets__r;
    global List<genesis__Change_Memo__c> genesis__Change_Memos__r;
    global List<genesis__Checklist__c> genesis__Checklist__r;
    global List<genesis__Credit_Memo__c> genesis__Credit_Memos__r;
    global List<genesis__Disbursement_Schedule_Item__c> genesis__Disbursement_Schdules__r;
    global List<genesis__Disbursement_Schedule__c> genesis__Disbursement_Schedules__r;
    global List<genesis__Document_Status__c> genesis__Document_Status__r;
    global List<genesis__Employment_Information__c> genesis__Employment_Information__r;
    global List<genesis__Fee_Schedule__c> genesis__Fee_Schedules__r;
    global List<genesis__Financial_Account_Applications__c> genesis__Financial_Account_Applications__r;
    global List<genesis__Funding_Transaction__c> genesis__Funding_Transactions__r;
    global List<genesis__Identification_Information__c> genesis__Identifications_Information2__r;
    global List<genesis__Income__c> genesis__Incomes__r;
    global List<genesis__Insurance__c> genesis__Insurances__r;
    global List<genesis__Letter_of_Intent__c> genesis__Letters_of_Intent__r;
    global List<genesis__Liability__c> genesis__Liabilities__r;
    global List<genesis__Payment_Stream__c> genesis__Payment_Streams__r;
    global List<genesis__Policy_Exception__c> genesis__Policy_Exceptions__r;
    global List<genesis__Property__c> genesis__Properties__r;
    global List<genesis__Quick_Quotes__c> genesis__Quick_Quotes__r;
    global List<genesis__Rate_Schedule_Setup__c> genesis__Rate_Schedule_Setup__r;
    global List<genesis__Referral__c> genesis__Referral_Opportunities__r;
    global List<genesis__Rent_Roll__c> genesis__Rent_Rolls__r;
    global List<genesis__SubLimit__c> genesis__SubLimits__r;
    global List<genesis__Transaction_Room__c> genesis__Transaction_Rooms__r;
    global List<genesis__Treasury_Criteria_Results__c> genesis__Treasury_Criteria_Results__r;
    global List<genesis__Yield__c> genesis__Yield__r;
    global List<ints__Collateral__c> genesis__Collateral__r;
    global List<ints__Credit_Report__c> genesis__Credit_Report__r;
    global List<ints__Yodlee_Call__c> genesis__Application_Yodlee_Calls__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global genesis__Applications__c () 
    {
    }
}