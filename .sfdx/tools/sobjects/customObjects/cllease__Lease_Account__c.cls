// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Lease_Account__c {
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
    global String cllease__ACH_Account_Number__c;
    global String cllease__ACH_Account_Type__c;
    /* ACH (Automated Clearing House) is an electronic funds-transfer system. This payment system deals with payroll, direct deposit, tax refunds, consumer bills, tax payments to name a few.
    */
    global Boolean cllease__ACH_Active__c;
    /* Name of the bank
    */
    global String cllease__ACH_Bank_Name__c;
    /* ACH Bank is the bank that processes the NACHA file.
    */
    global cllease__Bank__c cllease__ACH_Bank__r;
    /* ACH Bank is the bank that processes the NACHA file.
    */
    global Id cllease__ACH_Bank__c;
    /* Debit amount
    */
    global Decimal cllease__ACH_Debit_Amount__c;
    /* ACH Drawer Name
    */
    global String cllease__ACH_Drawer_Name__c;
    global Date cllease__ACH_End_Date__c;
    global String cllease__ACH_Frequency__c;
    /* It is the next date on which the installment amount will be deducted from the borrower's account.
    */
    global Date cllease__ACH_Next_Debit_Date__c;
    global String cllease__ACH_Relationship_Type__c;
    /* ACH routing number is a nine digit number used to clear electronic transactions to and from your bank account.
    */
    global String cllease__ACH_Routing_Number__c;
    global Date cllease__ACH_Start_Date__c;
    global Account cllease__Account__r;
    global Id cllease__Account__c;
    global String cllease__Accrual_Streams__c;
    global Boolean cllease__Accrue_Fee__c;
    global Boolean cllease__Accrue_Lease_Income__c;
    /* Ach Debit Day
    */
    global Double cllease__Ach_Debit_Day__c;
    /* Indicates if the account is Active.
    */
    global Boolean cllease__Active_flag__c;
    global clcommon__Address__c cllease__Address__r;
    global Id cllease__Address__c;
    global String cllease__Advance_Payments__c;
    /* It is used to determine whether a company carries overdue debtors that may never repay their bills.
    */
    global String cllease__Aging__c;
    global Double cllease__Amort_Finance_Amount__c;
    /* Date Accruals Start
    */
    global Date cllease__Amort_Start_Date__c;
    global Double cllease__Amortized_Yield__c;
    global Decimal cllease__Amount_Due_at_Signing__c;
    /* This includes delinquent amount + any unpaid fees on the account.
    */
    global Decimal cllease__Amount_to_Current__c;
    /* Application Received Date.
    */
    global Date cllease__Application_Date__c;
    /* The date on which the lease is approved.
    */
    global Date cllease__Approval_Date__c;
    global Decimal cllease__Average_Monthly_Income__c;
    /* Heavy payment at the end of a lease payment schedule.
    */
    global Decimal cllease__Balloon_Payment__c;
    global Boolean cllease__Bill_Rent__c;
    global cllease__Bank_Account__c cllease__Borrower_ACH__r;
    global Id cllease__Borrower_ACH__c;
    /* The branch name of the lease account.
    */
    global cllease__Office_Name__c cllease__Branch__r;
    /* The branch name of the lease account.
    */
    global Id cllease__Branch__c;
    global clcommon__CL_Product__c cllease__CL_Product__r;
    global Id cllease__CL_Product__c;
    global String cllease__Calculation_Method__c;
    global Decimal cllease__Cap_Reduction__c;
    global Decimal cllease__Cash_Collected_By_Dealer__c;
    /* Date on which the account was charged off.
    */
    global Date cllease__Charged_Off_Date__c;
    global Decimal cllease__City_Surcharge_Amount__c;
    global Decimal cllease__City_Tax_Amount__c;
    /* City Tax Rate, populated from setup
    */
    global Double cllease__City_Tax_Rate__c;
    /* The date when the lease was closed
    */
    global Date cllease__Closed_Date__c;
    global Date cllease__Commencement_Date__c;
    global Decimal cllease__Commission_Amount__c;
    global Contact cllease__Contact__r;
    global Id cllease__Contact__c;
    /* Contract date on the lease. This will be updated at the time of funding with the expected disbursal date.
    */
    global Date cllease__Contract_Date__c;
    /* true for contract restructured
    */
    global Boolean cllease__Contract_Restructured__c;
    global Decimal cllease__County_Surcharge_Amount__c;
    global Decimal cllease__County_Tax_Amount__c;
    /* County Tax Rate, populated from setup
    */
    global Double cllease__County_Tax_Rate__c;
    /* (Internal CL Lease): Field will be using to track currency code selection during contract creation.
If Currency selected during contract creation from picklist (UI), Contract sets to selected currency.
else CL Lease company default company
    */
    global String cllease__Currency_Code__c;
    /* The day on which the lease payment is due.
    */
    global Double cllease__Current_Due_Day__c;
    global Double cllease__Current_Evergreen_Term__c;
    /* This is the current installment amount that needs to be paid.
    */
    global Decimal cllease__Current_Payment_Amount__c;
    global Decimal cllease__Current_Term_Rental_Payment__c;
    global Decimal cllease__Current_Term_Surcharge_On_Stream__c;
    global Decimal cllease__Current_Term_Tax_On_Stream__c;
    global Decimal cllease__Current_Term_Total_Payment__c;
    /* Current lease account term.
    */
    global Double cllease__Current_Term__c;
    /* Current Yield
    */
    global Double cllease__Current_Yield__c;
    global String cllease__Days_Convention__c;
    /* Number of days for which there has been an overdue on the lease account.
    */
    global Double cllease__Days_Past_Due__c;
    global Decimal cllease__Dealer_Fees__c;
    global Boolean cllease__Dealer_Funded__c;
    global Date cllease__Dealer_Payment_Date__c;
    global Account cllease__Dealer__r;
    global Id cllease__Dealer__c;
    /* It is the number of days for which the system will wait before categorizing the account as a delinquent account.
    */
    global Double cllease__Delinquency_Grace_Days__c;
    /* Checked if the Account is Delinquent
    */
    global Boolean cllease__Delinquency_flag__c;
    /* Total Unpaid bills/invoices amount on this account.
    */
    global Decimal cllease__Delinquent_Amount__c;
    global Date cllease__Delivery_and_Acceptance_Date__c;
    global Boolean cllease__Depreciate_Over_Asset_Life__c;
    global String cllease__Depreciation_Calculation_Basis__c;
    global Boolean cllease__Depreciation_Expense_Flag__c;
    global String cllease__Depreciation_Method__c;
    global Decimal cllease__Documentation_Fees_Amount__c;
    global Decimal cllease__Down_Payment__c;
    /* Contractual Due Day for payments.
    */
    global Double cllease__Due_Day__c;
    global Boolean cllease__Early_Pre_Payment_Penalty_Indicator__c;
    global Decimal cllease__Early_Termination_Fees__c;
    global Date cllease__Effective_Date__c;
    global Double cllease__Effective_Term__c;
    global Decimal cllease__Equipment_Return_Fee__c;
    global Boolean cllease__Equipment_returned_flag__c;
    global Decimal cllease__Estimated_Selling_Price__c;
    global Double cllease__Evergreen_Count__c;
    global Decimal cllease__Evergreen_Current_Payment_Amount__c;
    global Date cllease__Evergreen_End_Date__c;
    global Boolean cllease__Evergreen_Flag__c;
    global String cllease__Evergreen_Frequency__c;
    global Date cllease__Evergreen_Last_Due_Date__c;
    global Date cllease__Evergreen_Next_Due_Date__c;
    global Date cllease__Evergreen_Next_Due_Generation_Date__c;
    global Date cllease__Evergreen_Start_Date__c;
    global Double cllease__Evergreen_Term__c;
    global Decimal cllease__Excess__c;
    /* A Fee Set is a collection of Fees that can be created using the Setup tab. All fees applied to a lease must be present in the corresponding set.
    */
    global clcommon__Fee_Set__c cllease__Fee_Set1__r;
    /* A Fee Set is a collection of Fees that can be created using the Setup tab. All fees applied to a lease must be present in the corresponding set.
    */
    global Id cllease__Fee_Set1__c;
    /* Please use Fee Set field that references Fee Set from CL Common.
    */
    global cllease__Fee_Set__c cllease__Fee_Set__r;
    /* Please use Fee Set field that references Fee Set from CL Common.
    */
    global Id cllease__Fee_Set__c;
    global Decimal cllease__Fees_Amount__c;
    global Decimal cllease__Financed_Amount__c;
    global Decimal cllease__First_Payment_Amount__c;
    /* This is the desired start date of the repayment schedule that is provided while creating the lease application.
    */
    global Date cllease__First_Payment_Date__c;
    global Date cllease__Fund_Date__c;
    global Decimal cllease__GPS_Removal_Fee__c;
    /* This is the number of grace days for which the system waits, before applying late charges on the lease.
    */
    global Double cllease__Grace_Period_for_Repayments__c;
    global String cllease__If_Other_Describe__c;
    global Boolean cllease__Income_Accrual_Flag__c;
    global String cllease__Income_Accrual_Frequency__c;
    global Decimal cllease__Initial_Direct_Cost_Amount1__c;
    global Decimal cllease__Initial_Direct_Cost_Amount__c;
    global Double cllease__Initial_Direct_Cost__c;
    global Date cllease__Install_Date__c;
    global Boolean cllease__Installation_Flag__c;
    global Boolean cllease__Invalid_Data__c;
    /* Rescheduled Indicator for internal processing purpose.
    */
    global Boolean cllease__Is_Rescheduled__c;
    /* This field indicates the date on which the contract's NPA status became NPA from Current.
    */
    global Date cllease__Last_Current_To_NPA_Date__c;
    /* Last Bill Date
    */
    global Date cllease__Last_Due_Date__c;
    global Date cllease__Last_Income_Accrual_Date__c;
    /* This fields indicates the date on which the contract's NPA status became Current from NPA.
    */
    global Date cllease__Last_NPA_To_Current_Date__c;
    /* Last Payment Received on this Account.
    */
    global Decimal cllease__Last_Payment_Amount__c;
    /* Date when the  last payment was received.
    */
    global Date cllease__Last_Payment_Date__c;
    global Datetime cllease__Last_Transaction_Timestamp__c;
    global String cllease__Last_Transaction_Type__c;
    global String cllease__Lease_Account_External_Id__c;
    /* Associated Lending Product.
    */
    global cllease__Lease_Product__c cllease__Lease_Product_Name__r;
    /* Associated Lending Product.
    */
    global Id cllease__Lease_Product_Name__c;
    global Decimal cllease__Lease_Receivable_Amount__c;
    /* Status of the Account, expected values are :
Pending Approval
Active - Good Standing
Active - Bad Standing
Active - Matured
Approved
Canceled
Closed- Written Off
Partial Application
Terminated
    */
    global String cllease__Lease_Status__c;
    /* This field indicates if the NPA Status is manually overridden. If this is true, the NPA Processing Job will ignore this contract.
    */
    global Boolean cllease__Manually_Override_NPA_Status__c;
    /* Indicates if the account has gone past maturity date.
    */
    global Boolean cllease__Matured_flag__c;
    /* This is the date on which the the lease matures
    */
    global Date cllease__Maturity_Date_Current__c;
    /* Maturity date as per contract.
    */
    global Date cllease__Maturity_Date__c;
    /* This will be reported only if the Account Status Code is 61-65, 71, 78, 80, 82-84, 88-89 and 93-97.
This field gets updated only when the status of lease account changes from Active-Good Standing to Active-Bad Standing.
    */
    global Date cllease__Metro2_First_Delinquency_Date__c;
    /* Report one month’s payment record in each byte from the left to right in least recent to most recent order.
    */
    global String cllease__Metro2_Payment_History__c;
    /* The Payment Rating contains a code that properly identifies whether the account is current, past due, in collections or charged off within the activity period being reported.
    */
    global String cllease__Metro2_Payment_Rating__c;
    /* Contains the one-character abbreviation for type of portfolio. Values available:
C = Line of credit
I = Installment
M = Mortgage
O = Open account
R = Revolving
    */
    global String cllease__Metro2_Portfolio_Type__c;
    global Date cllease__Migration_Date__c;
    /* This field indicates the contract's Non Performing Asset Status. It has 2 possible values: 
Current
NPA
    */
    global String cllease__NPA_Status__c;
    /* Next Payment Date For Commission.
    */
    global Date cllease__Next_Commission_Payment_Date__c;
    /* Date of the Next Due
    */
    global Date cllease__Next_Due_Date__c;
    /* This is determined by using the pre- bill days.
    */
    global Date cllease__Next_Due_Generation_Date__c;
    global Date cllease__Next_Income_Accrual_Date__c;
    global Double cllease__Number_of_Pieces_of_Equipment__c;
    /* One time ACH account number
    */
    global String cllease__OT_ACH_Account_Number__c;
    global String cllease__OT_ACH_Account_Type__c;
    /* One time ACH Bank's name
    */
    global String cllease__OT_ACH_Bank_Name__c;
    global Date cllease__OT_ACH_Debit_Date__c;
    /* One time ACH Drawer Address Line 1
    */
    global String cllease__OT_ACH_Drawer_Address1__c;
    /* One time ACH Drawer Address Line 2
    */
    global String cllease__OT_ACH_Drawer_Address2__c;
    /* One time ACH Drawer city
    */
    global String cllease__OT_ACH_Drawer_City__c;
    /* One time ACH drawer name
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
    global Decimal cllease__OT_ACH_Fee_Amount__c;
    /* One time ACH payment amount
    */
    global Decimal cllease__OT_ACH_Payment_Amount__c;
    global String cllease__OT_ACH_Relationship_Type__c;
    /* One time ACH Routing number
    */
    global String cllease__OT_ACH_Routing_Number__c;
    /* Oldest due date on the lease account.
    */
    global Date cllease__Oldest_Due_Date__c;
    global String cllease__Origin_Source__c;
    global Decimal cllease__Other_Financed_Fees__c;
    /* Tells the amount overdue for this account as of today
    */
    global Decimal cllease__Overdue_Amount_As_Of_Today__c;
    /* If this flag is checked the system will use Override Tax Rate
    */
    global Boolean cllease__Override_Tax_Flag__c;
    /* Override Tax Rate, populated from setup
    */
    global Double cllease__Override_Tax_Rate__c;
    /* Field to get the value of PV rate in order to get the present value
    */
    global Double cllease__PV_Rate__c;
    global Decimal cllease__Payable_To_Dealer__c;
    /* Contractual payment amount
    */
    global Decimal cllease__Payment_Amount__c;
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
    global String cllease__Payment_Frequency__c;
    global String cllease__Payment_Method__c;
    global cllease__Payment_Spread__c cllease__Payment_Spread__r;
    global Id cllease__Payment_Spread__c;
    /* End date for the payment tolerance
    */
    global Date cllease__Payment_Tolerance_End_Date__c;
    /* This is the percentage of amount that is tolerable for not marking the account as a delinquent account.
    */
    global Double cllease__Payment_Tolerance_Rate__c;
    /* Start date to apply the payment tolerance
    */
    global Date cllease__Payment_Tolerance_Start_Date__c;
    global Boolean cllease__Payment_in_Arrears__c;
    /* Checked if the Payoff fees needs to be assessed on the Lease account.
    */
    global Boolean cllease__Payoff_Fee_Indicator__c;
    global Boolean cllease__Periodic_Fee__c;
    global Date cllease__Periodic_Payment_Starts__c;
    /* Number of days for the bill to be generated before the actual installment date
    */
    global Double cllease__Pre_Bill_Days__c;
    global Date cllease__Prefund_Date__c;
    global String cllease__Prepayment_Method__c;
    /* Check this box to enable prepayment penalties on this lease. The prepayment penalty is only applicable to lease payoffs.
    */
    global Boolean cllease__Prepayment_Penalty_Indicator__c;
    /* This determines the number of payment periods for which the prepayment penalty is applicable.
For example, if a lease payoff occurs before the number of periods in this field has passed by, a prepayment penalty will be charged for the lease.
    */
    global Double cllease__Prepayment_Penalty_Periods__c;
    global Decimal cllease__Prepayment_Value__c;
    /* Field will provide the present value if the based on the present value calculation method in the product
    */
    global Decimal cllease__Present_Value__c;
    global String cllease__Private_Label__c;
    global Boolean cllease__Process_Fee__c;
    global String cllease__Product_Sub_Type__c;
    global String cllease__Product_Type__c;
    global String cllease__Referral_Category__c;
    global Decimal cllease__Referral_Fee_Amount__c;
    /* Pay Points On $$$
    */
    global Decimal cllease__Referral_Fee_Paid_On_Amount__c;
    global Double cllease__Referral_Fee_Points_ReadOnly__c;
    /* Applicable only of referral fees is being paid.
    */
    global Double cllease__Referral_Fee_Points__c;
    /* Checked, if need to pay referral fees.
    */
    global Boolean cllease__Referral_Fee__c;
    global Account cllease__Referral_Payee__r;
    global Id cllease__Referral_Payee__c;
    global Date cllease__Rent_Maturity_Date__c;
    global Boolean cllease__Rental_Accrual_Flag__c;
    global String cllease__Repayment_Billing_Method__c;
    /* This is the procedure to be followed to create the Installment schedule.
    */
    global String cllease__Repayment_Procedure__c;
    global Double cllease__Repayment_Term_Payment_Percent__c;
    global Decimal cllease__Residual_Amount__c;
    global String cllease__Residual_Owner__c;
    global String cllease__Residual_Type__c;
    global Date cllease__Restructure_Date__c;
    global String cllease__Restructure_Reason__c;
    global cllease__Lease_Account__c cllease__Restructured_Contract__r;
    global Id cllease__Restructured_Contract__c;
    /* Sales Division.
    */
    global String cllease__Sales_Division__c;
    global Account cllease__Sales_Rep__r;
    global Id cllease__Sales_Rep__c;
    global Double cllease__Secondary_Term__c;
    global Decimal cllease__Security_Deposit_Amount__c;
    global Decimal cllease__State_Surcharge_Amount__c;
    global Decimal cllease__State_Tax_Amount__c;
    /* State Tax Rate, populated from setup
    */
    global Double cllease__State_Tax_Rate__c;
    global Double cllease__Status_Order__c;
    global Double cllease__Subsidized_Yield__c;
    global String cllease__Subvention_Stream_Basis__c;
    global Decimal cllease__Subvention__c;
    global Decimal cllease__Tax_Amount__c;
    global String cllease__Tax_Treatment__c;
    global Decimal cllease__Tax_Upfront__c;
    global String cllease__Term_Residual_Frequency__c;
    /* Number of Term Residual Months, applicable only if the residual type is "TERM RESIDUAL"
    */
    global Double cllease__Term_Residual_Months__c;
    /* Number of payments not including residual payments
    */
    global Double cllease__Term__c;
    global Double cllease__Termination_Discount_Rate__c;
    /* This flag will be set to true if termination quote is accepted and bill is generated for termination quote
    */
    global Boolean cllease__Termination_Quote_accepted_flag__c;
    global Decimal cllease__Title_Transfer_Fee__c;
    global Decimal cllease__Total_Dealer_Charges__c;
    global Decimal cllease__Total_Surcharge_Amount__c;
    global Decimal cllease__Total_Tax_Amount__c;
    /* This is not a formula column
    */
    global Double cllease__Total_Tax_Rate_Derived__c;
    global Double cllease__Total_Tax_Rate__c;
    /* Upfront Rent
    */
    global Decimal cllease__Upfront_Rental_Amount__c;
    global String cllease__Upfront_Tax_Basis__c;
    /* Is the tax charged upfront on this account.
    */
    global Boolean cllease__Upfront_Tax_Flag__c;
    global Decimal cllease__Warranty_Amount__c;
    global String cllease__Who_remitted_Upfront_Tax__c;
    /* The tolerances determine the maximum amount that the system can write off to make the account as "Closed - Obligations met".
    */
    global Decimal cllease__Write_off_Tolerance_Amount__c;
    /* Contractual Yield
    */
    global Double cllease__Yield__c;
    global String cllease__application_number__c;
    global Boolean cllease__batch_job_completed__c;
    /* This is internally used by the system.
    */
    global Boolean cllease__enable_calculation_setup_logs__c;
    global Boolean cllease__generated_Streams_for_Restructure__c;
    global Boolean cllease__needStreamRegenerated__c;
    global Decimal cllease__sample__c;
    /* This is the field used for storing temp amount for storing termination quote
    */
    global Decimal cllease__temp_payment__c;
    global Decimal cllease__Equipment_Cost__c;
    global Decimal cllease__Equipment_Selling_Price__c;
    global Decimal cllease__Net_Balance_Amount__c;
    global Decimal cllease__Net_Fee_Balance__c;
    global Decimal cllease__Subsidy__c;
    global Decimal cllease__Total_Amount_Paid__c;
    global Decimal cllease__Total_Charges_Due__c;
    global String Account_Number__c;
    global Double Allowable_Soft_Cost__c;
    global String Application_Number__c;
    global genesis__Applications__c Application__r;
    global Id Application__c;
    global Decimal Applied_Amount_Conga__c;
    global String Billing_Address_Line_1__c;
    global String Billing_Address_Line_2__c;
    global Address__c Billing_Address__r;
    global Id Billing_Address__c;
    global String Billing_Email__c;
    global String Bokg_Yr_Mo__c;
    global Date Booking_Date__c;
    global String Business_Unit_Name__c;
    global Decimal Buyout_With_Purchase__c;
    global Decimal Buyout_Without_Purchase__c;
    global Date CTA_Booked_Date__c;
    global String City__c;
    global String Contract_Signer_Title__c;
    global String Contract_Signer__c;
    global Double Cost_of_Funds__c;
    global String Country__c;
    global String County__c;
    global String Cr_Apl_Tp_Code__c;
    global String Customer_City__c;
    global String Customer_Number__c;
    global String Customer_Primary_Contact__c;
    global String Customer_Primary_Phone__c;
    global String Customer_Zip_Code__c;
    global String Customer__c;
    global String DLL_Reference_Number__c;
    global clcommon__Party__c Dealer_Party__r;
    global Id Dealer_Party__c;
    global clcommon__Agreement__c Dealer_Program__r;
    global Id Dealer_Program__c;
    global Decimal Due_This_Period_Conga__c;
    global String EIN__c;
    global Decimal Estimated_Property_Tax__c;
    global Boolean Evergreen_Eligibility__c;
    global String Hyp_Based_Ent__c;
    global Boolean InsuranceNotification_Sent__c;
    global Date Insurance_Effective_date__c;
    global Decimal Insurance_Fees__c;
    global Boolean KYC_Cleared__c;
    global String Lease_Number__c;
    global String Lease_Type__c;
    global String Lessee_Company__c;
    global Decimal Net_Dealer_Funding__c;
    global Decimal Net_Trade_Up_Amount__c;
    global String PO_Number__c;
    global Decimal Payment_Amount_Conga__c;
    global cllease__Payment_Stream__c Payment_Stream__r;
    global Id Payment_Stream__c;
    global String Primary_Customer_Address_2__c;
    global String Primary_Customer_Address__c;
    global String Prom_Code__c;
    global String Purchase_Option__c;
    global Decimal Quote_Discount_Roll_over__c;
    global Decimal Quote_Discount__c;
    global Decimal Remaining_Amount_Due_Conga__c;
    global Double Remaining_Payments1__c;
    global Decimal Rent_Amount__c;
    global Double Rst_Residual__c;
    global Double Rst_Total_Income__c;
    global Double Rst_Total_Receivable__c;
    global Double Rst_Total_Residual_Income__c;
    global String Sales_Rep_Name__c;
    global Decimal Service_Fees__c;
    global String Source_System__c;
    global Date System_date__c;
    global Decimal Tax_Conga__c;
    global Date Termination_Date__c;
    global Date Todaydate__c;
    global Decimal Total_Amount_Conga__c;
    global Decimal Total_Monthly_Payment__c;
    global Decimal Trade_Up_Amount__c;
    global Decimal Trade_up_With_Purchase__c;
    global Decimal Trade_up_Without_Purchase__c;
    global String Transaction_Code__c;
    global String Zip_Code__c;
    global Decimal Additional_Residual_Amount__c;
    global Decimal Bill_Not_Paid_Estimated_Property_Tax__c;
    global Decimal Bill_Not_Paid_Insurance_Fees__c;
    global Decimal Bill_Not_Paid_Late_Fees__c;
    global Decimal Bill_Not_Paid_Origination_Fees__c;
    global Decimal Bill_Not_Paid_Rent__c;
    global Decimal Bill_Not_Paid_Service_Pass_Through__c;
    global Decimal Bill_not_Paid_Finance_Fees__c;
    global Decimal Billed_Not_Paid__c;
    global Decimal Estimated_Property_Tax1__c;
    global Decimal Insurance_Fees1__c;
    global Decimal Interim_Rent__c;
    global Decimal Next_Insurance_Fee__c;
    global Double Remaining_Payments__c;
    global Decimal Service_Fees1__c;
    global Decimal Sum_of_Equipment_Dealer_Charges__c;
    global Decimal Unbilled_Receivable__c;
    global Double Unbilled_Rent__c;
    global String Customer_State__c;
    global String State__c;
    global Date Dealer_Approved_Date__c;
    global String Dealer_Name__c;
    global String Dealer_Oracle_Vendor_Id__c;
    global String Dealer_State__c;
    global String Bill_To_Contact_Id__c;
    global Boolean Welcome_Package_Requested__c;
    global String Contract_Signer_Last_Name__c;
    global Decimal cllease__Subsidy1__c;
    global String Dealer_Email__c;
    global String Default_State__c;
    global Boolean Final_Letter_Sent__c;
    global String Final_Notice_Letter_Send__c;
    global Decimal Exposure__c;
    global String Final_Notice_Letter__c;
    global Double Number_of_Days_TO_Mature__c;
    global String ST_Derived_Product_Name__c;
    global String ST_Lessee_Accounting_Method__c;
    global String ST_Lessor_Accounting_Method__c;
    global String ST_Tax_Classification__c;
    global String Server_Url__c;
    global String SessionId__c;
    global Decimal Vertex_Tax_Amount__c;
    global Double AutoCaluclate_Finance_Charge_Grace_Days__c;
    global Double AutoCaluclate_Late_Charge_Grace_Days__c;
    global String Custom_Finance_Charge_Grace_Days__c;
    global String Custom_Late_Charge_Grace_Days__c;
    global Date Current_BranchSystemDate__c;
    global String Final_Notice_Letter_Sent__c;
    global Decimal Oracle_Trade_Up_Quote_Amount__c;
    global String Oracle_Trade_up_Lease_Number__c;
    global String Oracle_Trade_up_Quote_Number__c;
    global Date Oracle_Trade_up_Quote_Expiration_Date__c;
    global Decimal Fee_Schedule_Estimated_Property_Tax__c;
    global Decimal Charges_Estimated_Property_Tax_Paid__c;
    global Decimal Exposure_Estimated_Property_Tax__c;
    global String Operating_Lease__c;
    global Boolean cllease__Aging_History__c;
    /* Default bill group for corresponding equipments and should be entered only when invoices are to be generated for the account
    */
    global clcommon__Bill_Group__c cllease__Bill_Group__r;
    /* Default bill group for corresponding equipments and should be entered only when invoices are to be generated for the account
    */
    global Id cllease__Bill_Group__c;
    /* Default bill group for corresponding equipments and should be entered only when invoices are to be generated for the account
    */
    global clcommon__Billing_Group__c cllease__Billing_Group__r;
    /* Default bill group for corresponding equipments and should be entered only when invoices are to be generated for the account
    */
    global Id cllease__Billing_Group__c;
    /* If unchecked, a separate invoice would be generated for this contract
    */
    global Boolean cllease__Consolidate_Invoice__c;
    global Boolean cllease__Disbursement_File_To_Be_Generated__c;
    /* This is the amount on which the residual amount will depreciate in the Evergreen period.
    */
    global Decimal cllease__Evergreen_Depreciation_Amount__c;
    global Boolean cllease__Generating_Streams__c;
    /* This has to be checked if we have asset level rent
    */
    global Boolean cllease__Has_Asset_Level_Rent__c;
    global Boolean cllease__Initial_Streams_Generated__c;
    global Boolean cllease__Tax_Exempt__c;
    global Boolean cllease__isMigrated__c;
    global Date cllease__Last_Due_Generation_Date__c;
    global String Welcome_Packet__c;
    global Boolean New_Welcome_Packet__c;
    global Boolean Trigger_New_Packet_Workflow__c;
    global Double Equipment_Exempt_Count__c;
    global String Test_Welcome_Packet__c;
    global String Account_Salesperson__c;
    global Decimal Booked_Residual__c;
    global Decimal NPA_Amount__c;
    global Decimal NPBA_Amount__c;
    global Decimal NPBA_Amount_Temp__c;
    global Double Ending_Net_Investment_Last_Month__c;
    global String Trade_Up_From__c;
    global Decimal Unbilled_Estimated_Property_Tax__c;
    global Decimal Unbilled_Service_and_Maintenance__c;
    global Decimal Zero_Value__c;
    global Decimal Bill_Residual_Amount__c;
    global Decimal Billed_Rent_Only_Not_Paid__c;
    global Decimal Billed_Tax_Only_Not_Paid__c;
    /* Gross AR + Booked Residual - Unearned Income - Unearned Income Residual
    */
    global Decimal NPA_Booking_Transaction_Amount__c;
    /* Calculated daily by the batch process!
    */
    global Decimal NPBA_Amount_Calculated__c;
    global Datetime NPBA_Amount_Calculated_Date_Time__c;
    global String Credit__c;
    global String Debit__c;
    global Boolean cllease__Auto_Termination__c;
    /* When selected, the contract status will change to evergreen prior to maturity by prebill days. If the evergreen rental is billed in advance then first evergreen bill will be generated prior to maturity by prebill days
    */
    global Boolean cllease__Consider_Prebill_For_Evergreen__c;
    /* Effective date = Maturity date minus prebill days
    */
    global Date cllease__Effective_End_Date__c;
    /* The basis on which the Depreciation Stream will be generated during the Evergreen period.
    */
    global String cllease__Evergreen_Depreciation_Basis__c;
    /* When 'Evergreen Depreciation Basis' is 'Remaining Asset Life', the Equipment will be depreciated from Residual to Salvage in this duration.
    */
    global Double cllease__Evergreen_Depreciation_Term__c;
    /* Due Day for Evergreen payments.
    */
    global Double cllease__Evergreen_Due_Day__c;
    global Boolean cllease__Has_Changed__c;
    global String cllease__History_Tracking_Id__c;
    global Boolean cllease__Is_Rescheduled_For_Fee__c;
    /* The override VAT Rate of the lease contract
    */
    global clcommon__VAT_Rate_Setup__c cllease__Override_VAT_Rate__r;
    /* The override VAT Rate of the lease contract
    */
    global Id cllease__Override_VAT_Rate__c;
    global Boolean cllease__Residual_Billed_At_Maturity__c;
    /* Defaults to current yield of the contract getting restructured, can be changed based with required yield % during restructure. This value will be considered only Yield Based Payment is checked during restructure.
    */
    global Double cllease__Set_Restructure_Yield__c;
    global Boolean cllease__Skip_Child_Equip_Import__c;
    global Boolean cllease__Stream_Generation_Required__c;
    /* When on system will get the payment based on the current yield and construct payment schedule based on given frequency, term and start date in the editable payment schedule
    */
    global Boolean cllease__Yield_Based_Payment__c;
    global List<Account_History__c> Account_History__r;
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<Bill_Monitor__c> Bill_Monitor__r;
    global List<CAMS_Check__c> CAMS_Checks__r;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Event> Events;
    global List<ICS_Log__c> ICS_Logs__r;
    global List<Invoice__c> Invoice__r;
    global List<Lease_Claim_Equipment__c> Lease_Claim_Equipment__r;
    global List<Lease_Claims__c> Lease_Claims__r;
    global List<Lease_Exposure_Snapshot__c> Lease_Exposure_Snapshot__r;
    global List<Lease_Exposure__c> Lease_Exposure__r;
    global List<Lease_OLM_Quote__c> Lease_OLM_Quotes__r;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OpenActivity> OpenActivities;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<Supertrump_Log__c> Supetrump_Log__r;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<clcommon__Automated_Payment_Setup__c> cllease__Automated_Payment_Setup__r;
    global List<clcommon__Book_Depreciation_Stream__c> cllease__Book_Depreciation_Streams__r;
    global List<clcommon__Consolidated_Invoice__c> Invoices__r;
    global List<clcommon__Depreciation_Stream__c> cllease__Depreciation_Streams__r;
    global List<clcommon__Disbursement_Transaction__c> cllease__Disbursement_Txns__r;
    global List<cllease__Accrual_Transactions__c> cllease__Accrual_Transactions__r;
    global List<cllease__Aging_History__c> cllease__Aging_History__r;
    global List<cllease__Amz_Stream__c> cllease__Amz_Streams__r;
    global List<cllease__Asset_Return_History__c> cllease__Asset_Return_Historys__r;
    global List<cllease__Asset_Return__c> cllease__asset_return__r;
    global List<cllease__Asset_workbench__c> cllease__Asset_workbenchs__r;
    global List<cllease__Broker__c> cllease__Brokers__r;
    global List<cllease__Cash_Account_Balance__c> cllease__Cash_Account_Balances__r;
    global List<cllease__Charge__c> cllease__Charges__r;
    global List<cllease__Contract_ACH_Setup__c> cllease__Contract_ACH_Setup__r;
    global List<cllease__Contract_Equipment__c> cllease__Contract_Equipments__r;
    global List<cllease__Contract_Fee_Payment__c> cllease__Contract_Fee_Payments__r;
    global List<cllease__Contract_Fees__c> cllease__Contract_Fees__r;
    global List<cllease__Contract_Parties__c> cllease__Contract_Parties__r;
    global List<cllease__Contract_Pricing_Detail__c> cllease__Contract_Pricing_Details__r;
    global List<cllease__Credit_Card__c> cllease__Credit_Cards__r;
    global List<cllease__Dealer_Funding_Detail__c> cllease__Dealer_Equipment_details__r;
    global List<cllease__Dealer_Funding_Header__c> cllease__Dealer_Funding_Header__r;
    global List<cllease__Debt_Detail__c> cllease__Debt_Details__r;
    global List<cllease__Dep_Streams__c> cllease__Dep_Streams__r;
    global List<cllease__Disbursement_Transaction__c> cllease__Disbursement_Transactions__r;
    global List<cllease__Due_Detail_Lines__c> cllease__Due_Detail_Lines__r;
    global List<cllease__Expense_Fee_Transaction__c> cllease__Expense_Fees_Txns__r;
    global List<cllease__Expense_Fees__c> cllease__Expense_Fees__r;
    global List<cllease__Fee_Stream__c> cllease__Fee_Streams__r;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Transaction_Details__r;
    global List<cllease__Income_Calculation_Details__c> cllease__Income_Calculation_Details__r;
    global List<cllease__Income_Stream_History__c> cllease__Income_Streams_History__r;
    global List<cllease__Initial_Direct_Cost_Stream_History__c> cllease__IDC_Stream_History__r;
    global List<cllease__Initial_Direct_Cost_Stream__c> cllease__IDC_Stream__r;
    global List<cllease__Insurance_Policy_Equipment__c> cllease__Insurance_Policy_Equipments__r;
    global List<cllease__Insurance_Policy__c> cllease__Insurance_Policies__r;
    global List<cllease__Invoice_Credit__c> cllease__Invoice_Credit__r;
    global List<cllease__Lease_Account__Feed> Feeds;
    global List<cllease__Lease_Account__History> Histories;
    global List<cllease__Lease_Account__Share> Shares;
    global List<cllease__Lease_Account__c> cllease__LS_Contracts__r;
    global List<cllease__Lease_Payment_Detail__c> cllease__Lease_Payment_Details__r;
    global List<cllease__Lease_Payment_Transaction__c> cllease__Contract_Payment_Transactions__r;
    global List<cllease__Lease_Portfolio_Report__c> cllease__Lease_Portfolio_Reports__r;
    global List<cllease__Lease_Trx_Header__c> cllease__Lease_Transaction_Header__r;
    global List<cllease__Lease_Trx_Lines__c> cllease__Lease_Transaction_Line__r;
    global List<cllease__Lease_account_Due_Details__c> cllease__Dues_Details__r;
    global List<cllease__Lending_Account_Validation__c> cllease__Data_Migration_Errors__r;
    global List<cllease__Lessee_Statement__c> cllease__Lessee_Statements__r;
    global List<cllease__NPA_Detail__c> cllease__NPA_Details__r;
    global List<cllease__NPA_History__c> cllease__NPA_History_Records__r;
    global List<cllease__Non_Cash_Account_Balance__c> cllease__Non_Cash_Account_Balances__r;
    global List<cllease__Other_Transaction__c> cllease__Other_Lease_Transactions__r;
    global List<cllease__Payment_Schedule__c> cllease__Payment_Schedule__r;
    global List<cllease__Payment_Stream__c> cllease__Payment_Streams__r;
    global List<cllease__Periodic_Fee_Setup__c> cllease__Periodic_Fee_Setup__r;
    global List<cllease__Rate_Schedule_Setup__c> cllease__Rate_Schedule_Setup__r;
    global List<cllease__Rental_Accrual_Stream1__c> cllease__Rental_Accrual_Streams__r;
    global List<cllease__Rental_Stream__c> cllease__Rental_Streams__r;
    global List<cllease__Repayment_Transaction_Adjustment__c> cllease__Repayment_Transaction_Reversal__r;
    global List<cllease__Repossession__c> cllease__Repossessions__r;
    global List<cllease__Residual_Stream_History__c> cllease__Residual_Streams_History__r;
    global List<cllease__Residual_Stream__c> cllease__Residual_Streams__r;
    global List<cllease__Search__c> cllease__Search__r;
    global List<cllease__Subsidy_Stream__c> cllease__Subsidy_Streams__r;
    global List<cllease__Subsidy__c> cllease__Contract_Subsidy__r;
    global List<cllease__Tax_Dep_Stream__c> cllease__Tax_Dep_Streams__r;
    global List<cllease__Termination_Fee__c> cllease__Termination_Fees__r;
    global List<cllease__Termination_Quote_Header__c> cllease__Termination_Quote_Header__r;
    global List<cllease__Termination_Quote__c> cllease__Payoff_Quote__r;
    global List<cllease__Transaction_Summary__c> cllease__Transaction_Summaries__r;
    global List<cllease__Yield_Analysis__c> cllease__Yield_Analysis__r;
    global List<collect__Collection_Activity__c> Collection_Activities__r;
    global List<genesis__Applications__c> Applications__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global cllease__Lease_Account__c () 
    {
    }
}