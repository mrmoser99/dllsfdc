/**
 *  Author: Cloud Lending Solutions
 *  Description: Constants File for  the CL Lease product Termination Functionality due to DLL's Feature Gap
 *
 **/
public class LendingConstants {
    // SOQL WHERE CLAUSE OPERATORS
    public static String WHERE_CLAUSE_IN = 'IN';
    public static String WHERE_CLAUSE_NOTIN = 'NOT IN';

    //LEASE MATURITY DATE CALCULTION PICK LIST VALUE
    public static String CONTARCT_START_DATE = 'CONTRACT START DATE';
    public static String AMORT_START_DATE = 'AMORT START DATE';
    public static String FIRST_PMT_DATE = 'FIRST PAYMENT DATE';
    public static String INSTALLATION_DATE = 'INSTALLATION DATE';
    //PV CALCULATION OPTIOND
    public static String DO_NOT_CALCULATE = 'Do not calculate';
    public static String CALCULATE_PV_ONLY = 'Calculate PV only';
    public static String CALCULATE_PV_AND_INSERT_EQUIPMENT = 'Calculate PV and insert equipment';
    //PAYMENT METHOD
    public static String PAMENT_METHOD_ADVANCED = 'ADVANCE';
    public static String PAMENT_METHOD_ARREARS = 'ARREARS';
    //LEASE ACCOUNT STATUS
    public static String STATUS_PENDING_APPROVAL = 'PENDING APPROVAL';
    public static String STATUS_ACTIVE_GOOD_STANDING = 'ACTIVE - GOOD STANDING';
    public static String STATUS_SOLD = 'SOLD';
    public static String STATUS_INSTALLATION = 'INSTALLATION';
    public static String STATUS_ACTIVE_BAD_STANDING = 'ACTIVE - BAD STANDING';
    public static String STATUS_ACTIVE_MATURED = 'ACTIVE - MATURED';
    public static String STATUS_MATURED = 'MATURED';
    public static String STATUS_EXPIRED = 'EXPIRED';
    public static String STATUS_APPROVED = 'APPROVED';
    public static String STATUS_CANCELED = 'CANCELED';
    public static String STATUS_CLOSED_OBLIGATIONS_MET = 'CLOSED - OBLIGATIONS MET';
    public static String STATUS_CLOSED_RESCHEDULED = 'CLOSED - RESCHEDULED';
    public static String STATUS_CLOSED_WRITTEN_OFF = 'CLOSED- WRITTEN OFF';
    public static String STATUS_CHARGE_OFF = 'CHARGE OFF';
    public static String STATUS_PARTIAL_APPLICATION = 'PARTIAL APPLICATION';
    public static String STATUS_TERMINATED = 'TERMINATED';
    public static String STATUS_EVERGREEN = 'EVERGREEN';

    public static String NPA_STATUS_CURRENT = 'ACCRUAL';
    public static String NPA_STATUS_NPA = 'NON ACCRUAL';

    public static String STATUS_REPO_REQUESTED = 'Repossession Requested';
    public static String STATUS_REPO_SUCCESS = 'Repossession Successful';
    public static String STATUS_REPO_UNSUCCESS = 'Repossession Un-Successful';

    public static String APPL_STATUS_NEW_ENTERED = 'NEW - ENTERED';
    public static String APPL_STATUS_NEW_IN_REVIEW = 'NEW - IN REVIEW';
    public static String APPL_STATUS_NEW_IN_CREDIT_CHECK = 'NEW - IN CREDIT CHECK';
    public static String APPL_STATUS_NEW_IN_VEHICLE_VALUATION_REQD = 'NEW - VEHICLE VALUATION REQUIRED';
    public static String APPL_STATUS_NEW_APPROVED = 'APPROVED - APPROVED';
    public static String APPL_STATUS_NEW_APPROVED_DOCUMENT_CHECK = 'APPROVED - DOCUMENT CHECK';
    public static String APPL_STATUS_NEW_APPROVED_CONVERTED = 'APPROVED - CONVERTED TO CONTRACT';


    public static String VALIDATION_TYPE_ACTIVATION = 'ACTIVATION';
    public static String VALIDATION_TYPE_DIAGNOSTIC = 'DIAGNOSTIC';
    public static String VALIDATION_TYPE_ACH_ERROR = 'ACH ERROR STATE';
    public static String VALIDATION_TYPE_DATA_MIGRATION = 'DATA MIGRATION';

    public static String LEASE_NONCASHBAL_FUTURE_LEASE_RECEIVABLE = 'FUTURE LEASE RECEIVABLE';
    public static String LEASE_NONCASHBAL_FUTURE_EVG_LEASE_RECEIVABLE = 'FUTURE EVERGREEN LEASE RECEIVABLE';
    public static String LEASE_NONCASHBAL_UNEARNED_INCOME = 'UNEARNED INCOME';
    public static String LEASE_NONCASHBAL_RESIDUAL_RECEIVABLE = 'RESIDUAL RECEIVABLE';
    public static String LEASE_NONCASHBAL_UNEARNED_RESIDUAL = 'UNEARNED RESIDUAL';
    public static String LEASE_NONCASHBAL_IDC = 'INITIAL DIRECT COST';
    public static String LEASE_NONCASHBAL_IDC_ACCRUAL = 'INITIAL DIRECT COST ACCRUAL';
    public static String LEASE_NONCASHBAL_FEL_RECEIVABLE = 'FUTURE EVERGREEN LEASE RECEIVABLE';
    public static String LEASE_NONCASHBAL_TAX_PAYABLE = 'TAX PAYABLE';
    public static String LEASE_NONCASHBAL_COMMISSION_PAYABLE = 'COMMISSION PAYABLE';
    public static String LEASE_NONCASHBAL_RENTAL_ACCRUAL = 'RENTAL ACCRUAL';
    public static String LEASE_NONCASHBAL_DEPR_ACCRUAL = 'DEPRECIATION ACCRUAL';
    public static String LEASE_CASHBAL_LEASE_RECEIVABLE_BILLED = 'LEASE RECEIVABLE BILLED'; //deprecated do not use
    public static String LEASE_CASHBAL_TAX_BILLED = 'TAX BILLED'; //deprecated do not use
    public static String LEASE_CASHBAL_TAX_UPFRONT = 'TAX UPFRONT';        //deprecated do not use
    public static String LEASE_CASHBAL_LEASE_RECEIVABLE = 'LEASE RECEIVABLE';
    public static String LEASE_CASHBAL_TAX = 'TAX';
    public static String LEASE_CASHBAL_SERVICE_FEE_MAINT_CHG = 'SERVICE FEE/MAINTAINENCE CHARGE';
    public static String LEASE_CASHBAL_SERVICE_FEES = 'SERVICE FEES';
    public static String LEASE_CASHBAL_FEES = 'FEES';
    public static String LEASE_CASHBAL_FEES_NSF = 'FEES NSF';
    public static String LEASE_CASHBAL_FEES_OTHERS = 'FEES OTHERS';
    public static String LEASE_CASHBAL_FEES_LATE_CHARGE = 'FEES LATE CHARGE';
    public static String LEASE_CASHBAL_EXCESS = 'EXCESS';
    public static String LEASE_CASHBAL_LEASE_PAYABLE = 'VENDOR PAYABLE';
    public static String LEASE_CASHBAL_REFERRAL_PAYABLE = 'REFERRAL PAYABLE';
    public static String LEASE_BALANCE_TYPE_RECEIVABLE = 'RECEIVABLE';
    public static String LEASE_BALANCE_TYPE_PAYABLE = 'PAYABLE';

    public static String LEASE_CASHBAL_TAX_PAYABLE = 'TAX PAYABLE';
    public static String LEASE_CASHBAL_COMMISSION_PAYABLE = 'COMMISSION PAYABLE';


    public static String LEASE_UPFRONT_TAX_BASIS_GROSS_RENT = 'GROSS RENT';
    public static String LEASE_UPFRONT_TAX_BASIS_EQP_COST = 'EQUIPMENT COST';
    public static String LEASE_UPFRONT_TAX_BASIS_EQP_SELL_PRICE = 'EQUIPMENT SELLING PRICE';

    public static String TXN_BOOKING_CONTRACT = 'BOOKING';
    public static String TXN_INSTALLATION = 'INSTALLATION';
    public static String TXN_RESTRUCTURE_CONTRACT = 'RESTRUCTURE';
    public static String TXN_DEALER_FUNDING_CONTRACT = 'DEALER FUNDING';
    public static String TXN_DISBURSEMENT = 'DISBURSEMENT';
    public static String TXN_SUBVENTION = 'SUBVENTION';
    public static String TXN_DEBT = 'DEBT';
    public static String TXN_DEBT_CANCEL = 'DEBT CANCEL';
    public static String TXN_DEBT_SCHEDULE = 'DEBT SCHEDULE';
    public static String TXN_EXP_FEE = 'EXPENSE FEE';

    //accrual frequency
    public static String ACCRUAL_MONTH_END = 'END OF MONTH';
    public static String ACCRUAL_DUE_DATE = 'ON DUE DATE';

    public final static String ADDNL_DET_FACTOR_TYPE_CURRENCY = 'CURRENCY';
    public final static String FIELD_TYPE_DOUBLE = 'DOUBLE';
    public final static String FIELD_TYPE_INTEGER = 'INTEGER';
    /*public final static String FIELD_TYPE_PERCENT = 'PERCENT';
    public final static String FIELD_TYPE_PICKLIST = 'PICKLIST';
    public final static String FIELD_TYPE_STRING = 'STRING';*/

    //PRODUCT TYPES
    public static String LOAN = 'LOAN';
    public static String LEASE = 'LEASE';
    public static String LOC = 'LINE OF CREDIT';

    public static String UNDEF = 'UNDEFINED';

    //PRODUCT RECORD TYPES
    public static String LEASE_PRODUCT_RT = 'LEASE_PRODUCT_RECORD_TYPE';
    public static String LOC_PRODUCT_RT = 'LINE_OF_CREDIT_PRODUCT_RECORD_TYPE';

    //LEASE RECORD TYPES
    public static String LEASE_ACCOUNT_RT = 'LEASE_RECORD_TYPE';
    public static String LOC_ACCOUNT_RT = 'LINE_OF_CREDIT_RECORD_TYPE';

    //LOC BILLING METHOD
    public static String IO = 'INTEREST ONLY';
    public static String PRB = 'PERCENTAGE OF REMAINING BALANCE';
    public static String PPI = 'PRINCIPAL PLUS INTEREST';
    public static String PCL = 'PERCENTAGE OF CREDIT LIMIT';

    //AVERAGE DAILY BALANCE TXN
    public static String DISBURSAL = 'DISBURSAL';
    public static String PAYMENT = 'PAYMENT';

    //AMORTIZED BALANCES
    public static String AMZ_BAL_INTEREST = 'INTEREST';
    public static String AMZ_BAL_FEES = 'FEES';

    //AMORTIZED CALCULATION METHOD
    public static String AMZ_CAL_METHOD_IB = 'INTEREST BEARING';

    //AMORTIZED TRANSACTION CODE
    public static String INT_AMZ = 'INTEREST AMORTIZATION';
    public static String INT_AMZ_REV = 'INTEREST AMORTIZATION REVERSAL';

    //REPAYMENT PROCEDURES
    public static String REPAYMENT_PROC_FLEXIBLE = 'FLEXIBLE';
    public static String REPAYMENT_PROC_EMI = 'EQUAL MONTHLY INSTALLMENTS';

    //INTEREST CALCULATION METHOD. RENAMED AS 'BILLING METHOD'
    public static String REPAYMENT_INT_CALC_METHOD_FLAT = 'FLAT';
    public static String REPAYMENT_INT_CALC_METHOD_DEC_BAL = 'DECLINING BALANCE';
    public static String REPAYMENT_INT_CALC_METHOD_INTEREST_ONLY = 'INTEREST ONLY';
    public static String REPAYMENT_INT_CALC_METHOD_FLEXIBLE_REPAYMENT = 'FLEXIBLE REPAYMENT';

    //TIME COUNTING METHOD
    public static String TIME_COUNTING_MONTH_AND_DAYS = 'MONTH AND DAYS';
    public static String TIME_COUNTING_ACTUAL_DAYS = 'ACTUAL DAYS';



    // PAYMENT FREQUENCY
    public static String PAYMENT_FREQ_WEEKLY = 'WEEKLY';
    public static String PAYMENT_FREQ_SEMI_MONTHLY = 'SEMI-MONTHLY';
    public static String PAYMENT_FREQ_BI_WEEKLY = 'BI-WEEKLY';
    public static String PAYMENT_FREQ_MONTHLY = 'MONTHLY';
    public static String PAYMENT_FREQ_DAILY = 'DAILY';
    public static String PAYMENT_FREQ_BI_MONTHLY = 'BI-MONTHLY';
    public static String PAYMENT_FREQ_QUARTERLY = 'QUARTERLY';
    public static String PAYMENT_FREQ_SINGLEPMT = 'SINGLEPMT';
    public static String PAYMENT_FREQ_ANNUAL = 'ANNUAL';
    public static String PAYMENT_FREQ_SEMI_ANNUAL = 'SEMI-ANNUAL';

    // PAYMENT MODE
    public static String PAYMENT_MODE_CASH = 'CASH';
    public static String PAYMENT_MODE_CHECK = 'CHECK';
    public static String PAYMENT_MODE_ACH = 'ACH';
    public static String PAYMENT_MODE_WIRE = 'WIRE';
    public static String PAYMENT_MODE_MOBILE = 'MOBILE';
    public static String PAYMENT_MODE_EXCESS = 'EXCESS';
    public static String PAYMENT_MODE_TRUST = 'TRUST';
    public static String PAYMENT_MODE_CREDIT_CARD = 'CREDIT CARD';
    public static String PAYMENT_MODE_ADJUSTMENT = 'ADJUSTMENT';
    public static String PAYMENT_MODE_INTERNAL_TRANSFER = 'INTERNAL TRANSFER';
    public static String PAYMENT_MODE_INVOICE_CREDIT = 'INVOICE CREDIT';

    //ALL OTHER  TRANSACTION
    public static String TRANSACTION_RESCHEDULE = 'RESCHEDULE';
    public static String TRANSACTION_AMORTIZATION = 'AMORTIZATION';
    public static String TRANSACTION_DELINQUENT_PMT_PLAN = 'DELINQUENT PMT PLAN';
    public static String TRANSACTION_TERMINATION_QUOTE_GENERATION = 'TERMINATION QUOTE GENERATION';
    public static String TRANSACTION_EXTENSION = 'EXTENSION';
    public static String TRANSACTION_TERMINATION = 'TERMINATION';
    public static String TRANSACTION_EXTENSION_REV = 'EXTENSION REVERSAL';
    public static String TRANSACTION_PRINCIPAL_ADD = 'PRINCIPALADJUSTMENT-ADD';
    public static String TRANSACTION_PRINCIPAL_ADD_REV = 'PRINCIPALADJUSTMENT-ADD REVERSAL';
    public static String TRANSACTION_DDC = 'DUE DATE CHANGE';
    public static String TRANSACTION_PRINCIPAL_SUB = 'PRINCIPALADJUSTMENT-SUBTRACT';
    public static String TRANSACTION_PRINCIPAL_SUB_REV = 'PRINCIPALADJUSTMENT-SUBTRACT REVERSAL';
    public static String TRANSACTION_REFUND = 'REFUND';
    public static String TRANSACTION_BILLING = 'BILLING';
    public static String TRANSACTION_EVERGREEN = 'EVERGREEN';
    public static String TRANSACTION_EVERGREEN_BILLING = 'EVERGREEN BILLING';
    public static String TRANSACTION_INVESTOR_PAYOUT = 'INVESTOR PAYOUT';
    public static String TRANSACTION_ADDITIONAL_REPAYMENT = 'ADDITIONAL REPAYMENT';
    public static String TRANSACTION_RATE_CHANGE = 'RATE CHANGE';
    public static String TRANSACTION_PAYMENT_CHANGE = 'PAYMENT CHANGE';
    public static String TRANSACTION_PAYMENT = 'PAYMENT TRANSACTION';
    public static String TRANSACTION_DISBURSAL = 'DISBURSAL TRANSACTION';
    public static String TRANSACTION_DISBURSAL_REVERSAL = 'DISBURSAL REVERSAL';
    public static String CHARGE = 'CHARGES';
    public static String ACCOUNT_OTHER_LEASE_TRANSACTION = 'OTHER LEASE TRANSACTION';
    public static String TRANSACTION_PAYMENT_REVERSAL = 'PAYMENT REVERSAL';
    public static String TRANSACTION_START_ACCRUAL = 'START ACCRUAL';
    public static String TRANSACTION_STOP_ACCRUAL = 'STOP ACCRUAL';
    public static String TRANSACTION_ONE_TIME_ACH = 'ONE TIME ACH';
    public static String TRANSACTION_CANCEL_ONE_TIME_ACH = 'CANCEL ONE TIME ACH';
    public static String TRANSACTION_RECURRING_ACH = 'RECURRING ACH';
    public static String TRANSACTION_STOP_RECURRING_ACH = 'STOP RECURRING ACH';
    public static String TRANSACTION_PAYOFF_QUOTE_GENERATION = 'PAYOFF QUOTE GENERATION';
    public static String TRANSACTION_PAYMENT_TOLERANCE_CHANGE = 'PAYMENT TOLERANCE CHANGE';
    public static String TRANSACTION_CHARGE_OFF = 'CHARGE OFF';
    public static String TRANSACTION_SALE_OF_CONTRACT = 'CONTRACT SALE';
    public static String TRANSACTION_BUY_BACK_OF_CONTRACT = 'CONTRACT BUYBACK';
    public static String TRANSACTION_CHARGE_OFF_REV = 'CHARGE OFF REVERSAL';
    public static String TRANSACTION_INTEREST_WAIVE = 'INTEREST WAIVE';
    public static String TRANSACTION_INTEREST_ACCRUAL = 'INTEREST ACCRUAL';
    public static String TRANSACTION_DUE_DAY_CHANGE = 'DUE DAY CHANGE';
    public static String TRANSACTION_ACCRUAL = 'ACCRUAL';
    public static String TRANSACTION_REPO = 'REPOSSESSION';
    public static String TRANSACTION_RETURN = 'ASSET RETURN';
    public static String TRANSACTION_ASSET_SOLD = 'ASSET SOLD';
    public static String TRANSACTION_ADDON = 'ASSET ADD ON';

    //LEASE  LOSS PROVISIONING CLASSES
    public static String LOSS_P_ON_TIME = 'ON TIME LEASES';
    public static String LOSS_P_LESS_T_30 = 'LEASES OVERDUE FOR < 30 DAYS';
    public static String LOSS_P_BETWEEN_31_60 = 'LEASES OVERDUE BETWEEN 31-60 DAYS';
    public static String LOSS_P_BETWEEN_61_90 = 'LEASES OVERDUE BETWEEN 61-90 DAYS';
    public static String LOSS_P_BETWEEN_91_180 = 'LEASES OVERDUE BETWEEN 91-180 DAYS';
    public static String LOSS_P_BETWEEN_181_365 = 'LEASES OVERDUE BETWEEN 181-365 DAYS';
    public static String LOSS_P_GREATER_T_365 = 'LEASES OVERDUE FOR ABOVE 365 DAYS';

    //RECOVERY ORDER - AMOUNT TYPES
    public static String RO_AMOUNT_TYPE_F = 'FEES';
    public static String RO_AMOUNT_TYPE_I = 'INTEREST';
    public static String RO_AMOUNT_TYPE_P = 'PRINCIPAL';
    public static String RO_AMOUNT_TYPE_O = 'OVERDUE';

    //LEASE PRODUCT STATUS
    public static String PRODUCT_STATUS_ACTIVE = 'ACTIVE';
    public static String PRODUCT_STATUS_INACTIVE = 'INACTIVE';



    //LEASE PRODUCT TYPE
    public static String INTEREST_CALC_METHOD_INT_BEARING = 'INTEREST BEARING';
    public static String INTEREST_CALC_METHOD_AMORTIZATION_BASED = 'AMORTIZATION BASED';

    //DUE TYPE
    public static Integer DUE_TYPE_REGULAR_BILLS = 1;
    public static Integer DUE_TYPE_EVERGREEN_BILLS = 2;

    //LEASE ACCRUAL BASE METHOD CODE
    public static String ACCRUAL_METHOD_CODE_360_360 = '360/360';  //360/360 AND 30/360 IS SAME
    public static String ACCRUAL_METHOD_CODE_30_360 = '30/360';
    public static String ACCRUAL_METHOD_CODE_360_365 = '360/365';
    public static String ACCRUAL_METHOD_CODE_360_366 = '360/366';
    public static String ACCRUAL_METHOD_CODE_ACTUAL_ACTUAL = 'ACTUAL/ACTUAL';
    public static String ACCRUAL_METHOD_CODE_365_360 = '365/360';
    public static String ACCRUAL_METHOD_CODE_365_365 = '365/365';
    public static String ACCRUAL_METHOD_CODE_365_366 = '365/366';
    public static String ACCRUAL_METHOD_CODE_366_360 = '366/360';
    public static String ACCRUAL_METHOD_CODE_366_365 = '366/365';
    public static String ACCRUAL_METHOD_CODE_366_366 = '366/366';


    public static String PRODUCT_SUB_TYPE_OP_LEASE = 'OPERATING LEASE';
    public static String PRODUCT_SUB_TYPE_FN_LEASE = 'FINANCE LEASE';

    // Product subvention Stream basis picklist values (Income Basis, Straight Line)
    public static String PRODUCT_SUBVENTION_STREAM_INCOME_BASIS = 'Income Basis';
    public static String PRODUCT_SUBVENTION_STREAM_STL_BASIS = 'Straight Line';

    // Fee Stream basis picklist values (Income Basis, Straight Line)
    public static String FEE_STREAM_INCOME_BASIS = 'Income Basis';
    public static String FEE_STREAM_STL_BASIS = 'Straight Line';

    //RESIDUAL METHOD
    public static String TERM_RESIDUAL = 'TERM RESIDUAL';
    public static String FMV_RESIDUAL = 'FMV';

    //DATE
    public static Date DT_MAX = DATE.NEWINSTANCE(3000, 12, 31); //DATE.VALUEOF(5000+ '-'+12+'-'+31+ ' ' +'00:00:00');
    public static Date DT_MIN = DATE.NEWINSTANCE(1900, 1, 1); //DATE.VALUEOF(1900+ '-'+01+'-'+01+ ' ' +'00:00:00');

    //PREPAYMENT PENALTY METHODS
    public static String PREPAYMENT_PERCENT_LEASE_AMOUNT = '% OF LEASE AMOUNT';
    public static String PREPAYMENT_PERCENT_LEASE_BALANCE = '% OF LEASE BALANCE';
    public static String PREPAYMENT_PERCENT_PRIN_REM = '% OF PRINCIPAL BALANCE';
    public static String PREPAYMENT_PERCENT_FIXED = 'FIXED';

    //FRACTIONALIZATION
    public static String INVESTMENT_ACTIVATION_DESC = 'INVESTMENT ACTIVATED';
    public static String INVESTMENT_RELEASED_DESC = 'PAYMENT RELEASED';
    public static String INVESTMENT_DEACTIVATION_DESC = 'INVESTMENT DEACTIVATED';
    public static String INVESTMENT_SER_RATE_CHANGE_DESC = 'SERVICE RATE CHANGED';
    public static String INVESTMENT_CER_RATE_CHANGE_DESC = 'CERTIFICATE RATE CHANGED';
    public static String INVESTMENT_PAYMENT_DESC = 'PAYMENT APPROVED';
    public static String INVESTMENT_ACTIVATION = 'ACTIVE';
    public static String INVESTMENT_DEACTIVATION = 'DE-ACTIVE';
    public static String INVESTMENT_PAYMENT = 'PAYMENT APPROVAL';
    public static String INVESTMENT_PAYMENT_REVERSED = 'PAYMENT REVERSED';
    public static String INVESTMENT_RELEASED = 'PAYMENT RELEASE';
    public static String PRINCIPAL_PAYMENT_REINVESTED = 'PRINCIPAL REINVESTED';
    public static String INTEREST_PAYMENT_REINVESTED = 'INTEREST REINVESTED';
    public static String PRINCIPAL_INTEREST_REINVESTED = 'PRINCIPAL & INTEREST REINVESTED';
    public static String PAYMENT_REINVESTED = 'PAYMENT REINVESTED';
    public static String INVESTMENT_SER_RATE_CHANGE = 'SERVICE RATE CHANGE';
    public static String INVESTMENT_CER_RATE_CHANGE = 'CERTIFICATE RATE CHANGE';

    //TRUST ACCOUNT
    public static String RESERVE_HOLD = 'RESERVE HOLD';
    public static String RESERVE_RELEASE = 'RESERVE RELEASE';

    //ACH
    public static String ACH_RELATIONSHIP_TYPE_PRIMARY = 'PRIMARY';
    public static String ACH_RELATIONSHIP_TYPE_SPOUSE = 'SPOUSE';
    public static String ACH_RELATIONSHIP_TYPE_SECONDARY = 'SECONDARY';
    public static String ACH_RELATIONSHIP_TYPE_COSIGNER = 'COSIGNER';
    public static String ACH_RELATIONSHIP_TYPE_COSIGNER_SPOUSE = 'COSIGNER SPOUSE';
    public static String ACH_RELATIONSHIP_TYPE_COSIGNER2 = 'COSIGNER2';
    public static String ACH_RELATIONSHIP_TYPE_COSIGNER2_SPOUSE = 'COSIGNER2 SPOUSE';
    public static String ACH_RELATIONSHIP_TYPE_3RD_PARTY = 'THIRD PARTY';
    public static String ACCOUNT_TYPE_SAVING = 'SAVING';
    public static String ACCOUNT_TYPE_CHECKING = 'CHECKING';
    public static String ACCOUNT_TYPE_SAVINGS = 'SAVINGS';
    public static String ACCOUNT_TYPE_CHECKINGS = 'CHECKINGS';
    public static String EVENT_LEASE_PAYMENT = 'LEASE PAYMENT';
    public static String EVENT_DISBURSEMENT  = 'DISBURSEMENT';
    public static String EVENT_CHANGES       = 'CHANGES';
    public static String EVENT_SUBSIDY       = 'SUBSIDY';

    //LEASE FRACTIONALIZATION
    public static String FRACTIONALIZATION_STATUS_ACTIVE = 'ACTIVE';
    public static String FRACTIONALIZATION_STATUS_PENDING = 'PENDING';

    //BROKER
    public static String FLAT = 'FLAT AMOUNT';
    public static String PER_FIN_AMOUNT = 'PERCENTAGE OF FINANCED AMOUNT';
    public static String SPREAD = 'SPREAD';
    public static String PAY_AS_RECEIVED = 'PAY AS RECEIVED';
    public static String UPFRONT = 'UPFRONT';
    public static String UPFRONT_ME = 'UPFRONT AT MONTH END';
    public static String TXN_COMMISSION_DISB = 'COMMISSION DISBURSEMENT';
    public static String TXN_COMMISSION_CGBK = 'COMMISSION CHARGEBACK';
    public static String TXN_COMMISSION_UP_DISB = 'UPFRONT COMMISSION DISBURSEMENT';

    // PAGE MODES
    public static String EDITED_RECORD = 'EDIT';
    public static String NEW_RECORD = 'NEW';

    //RESIDUAL TYPES
    public static String RESIDUAL_TERM = 'TERM RESIDUAL';
    public static String RESIDUAL_FMV = 'FAIR MARKET VALUE';

    public static String PARTY_LESSOR = 'LESSOR';
    public static String PARTY_LESSEE = 'LESSEE';
    public static String PARTY_DEALER = 'DEALER';

    public static String SOURCE_BROKER = 'BROKER';
    public static String SOURCE_DIRECT = 'DIRECT';
    public static String SOURCE_DEALER = 'DEALER';


    //FEES CALCULATION METHODS
    public static String FIXED = 'FIXED';
    public static String PERCENTAGE_EQP_COST = 'PERCENTAGE OF EQUIPMENT COST';

    public static String QUICK_QUOTE_STATUS_ENTERED = 'ENTERED';
    public static String QUICK_QUOTE_STATUS_GENERATED = 'GENERATED';
    public static String QUICK_QUOTE_STATUS_CONVERTED = 'CONVERTED TO APPLICATION';

    // FEE TYPES
    public static String FEE_TYPE_MAINTENANCE_FEES = 'MAINTENANCE FEES';

    public static String FEE_TYPE_DOCUMENT_FEES    = 'DOCUMENTATION FEES';
    public static String FEE_TYPE_SECURITY_DEPOSIT = 'SECURITY DEPOSIT';

    //PRICING TYPES
    public static String PRICING_RATE_CARD = 'RATE_CARD';

    //APPLICATION - LEASE FIELD MAPPING NAMES
    public static String AMORTIZABLE_AMOUNT = 'AMORTIZABLE AMOUNT';
    public static String FIRST_PAYMENT_DATE = 'FIRST PAYMENT DATE';
    public static String EXPECTED_FIRST_PAYMENT_DATE = 'EXPECTED FIRST PAYMENT DATE';
    public static String INTEREST_RATE = 'INTEREST RATE';
    public static String LEASE_AMOUNT = 'LEASE AMOUNT';
    public static String PAYMENT_AMOUNT = 'PAYMENT AMOUNT';
    public static String PAYMENT_FREQUENCY = 'PAYMENT FREQUENCY';
    public static String TERM = 'TERM';

    // VEHICLE VALUATION SOURCES
    public static String SOURCE_BLACKBOOK = 'BLACKBOOK';

    //STATUS AVAILABLE FOR MASTER EQUIPMENT OBJECTS
    public static String MASTER_EQ_AVAILABLE = 'AVAILABLE';
    public static String MASTER_EQ_PENDING = 'PENDING';
    public static String MASTER_EQ_LEASED = 'LEASED';
    public static String MASTER_EQ_SCRAPPED = 'SCRAPPED';
    public static String MASTER_EQ_RETURNED = 'RETURNED';
    public static String MASTER_EQ_SOLD = 'SOLD';
    public static String MASTER_EQ_RETIRED = 'RETIRED';
    public static String MASTER_EQ_RELEASE = 'AVAILABLE FOR RE-LEASE';
    public static String MASTER_EQ_AUCTION = 'SENT FOR AUCTION';
    public static String MASTER_EQ_SCHEDULED = 'SCHEDULED FOR RETURN';
    public static String MASTER_EQ_RESTRUCTURE = 'RETURNED ON RESTRUCTURE';
    public static String EQUIPMENT_LEASED = 'Leased';
    public static String EQUIPMENT_WAREHOUSE = 'Warehouse';


    public static String PRIVILEGES_INSUFFICIENT = 'Insufficient user privileges to perform this action.';

    //PAYMENT SPREAD BALANCE TYPE
    public static String SPREAD_BAL_TYPE_TAX_UPFRONT = 'TAX UPFRONT'; //deprecated
    public static String SPREAD_BAL_TYPE_TAX_BILLED = 'TAX BILLED';//deprecated
    public static String SPREAD_BAL_TYPE_LEASE_RECEIVABLE_BILLED = 'LEASE RECEIVABLE BILLED';//deprecated
    public static String SPREAD_BAL_TYPE_LEASE_RECEIVABLE = 'LEASE RECEIVABLE';
    public static String SPREAD_BAL_TYPE_FEES = 'FEES';
    public static String SPREAD_BAL_TYPE_TAX = 'TAX';
    public static String SPREAD_BAL_TYPE_EXCESS = 'EXCESS';

    //CASH ACCOUNT BALANCE TYPE
    public static String CASH_ACC_BAL_TYPE_TAX_UPFRONT = 'TAX UPFRONT'; //deprecated
    public static String CASH_ACC_BAL_TYPE_TAX_BILLED = 'TAX BILLED'; //deprecated
    public static String CASH_ACC_BAL_TYPE_LEASE_RECEIVABLE_BILLED = 'LEASE RECEIVABLE BILLED';//deprecated
    public static String CASH_ACC_BAL_TYPE_TAX = 'TAX';
    public static String CASH_ACC_BAL_TYPE_EVG_LEASE_RECEIVABLE = 'EVERGREEN LEASE RECEIVABLE';
    public static String CASH_ACC_BAL_TYPE_SERVICE_FEES = 'SERVICE FEES';
    public static String CASH_ACC_BAL_TYPE_LEASE_RECEIVABLE = 'LEASE RECEIVABLE';
    public static String CASH_ACC_BAL_TYPE_FEES = 'FEES';
    public static String CASH_ACC_BAL_TYPE_EXCESS = 'EXCESS';

    //BILL TYPE
    public static String BILL_TYPE_TAX_UPFRONT = 'BILL / UPFRONT TAX';
    public static String BILL_TYPE_RENTAL = 'BILL / DUE DATE';
    public static String BILL_TYPE_ADVANCED_RENTAL = 'BILL / ADVANCE RENT';
    public static String BILL_TYPE_EVG_RENTAL = 'EVERGREEN BILL / DUE DATE';
    public static String BILL_TYPE_QUOTE_UNBILLED_RECEIVABLE = 'QUOTE UNBILLED RECEIVABLE';
    public static String BILL_TYPE_QUOTE_DISCOUNT = 'QUOTE DISCOUNT';
    public static String BILL_TYPE_QUOTE_PURCHASE_AMOUNT = 'QUOTE PURCHASE AMOUNT';
    public static String BILL_TYPE_TAX_ON_QUOTE = 'TAX ON QUOTE';
    public static String BILL_TYPE_TERMINATION = 'TERMINATION';
    public static String BILL_TYPE_SALE = 'CONTRACT SALE';
    public static String BILL_TYPE_RESIDUAL = 'BILL / RESIDUAL';

    // ACH TYPES
    public static String ACH_TYPE_ONE_TIME = 'ONE TIME';
    public static String ACH_TYPE_RECURRING = 'RECURRING';

    // Accounting Template Line "Amount to be Accounted" types
    public static String ACCT_TMP_LINE_ADVANCE_PAYMENTS_RECEIVED = 'ADVANCE PAYMENTS RECEIVED';
    public static String ACCT_TMP_LINE_AMORTIZED_FEES = 'AMORTIZED FEES';
    public static String ACCT_TMP_LINE_BILL_TAX_ON_STREAM = 'BILL TAX ON STREAM';
    public static String ACCT_TMP_LINE_DEALER_PAYABLE = 'DEALER PAYABLE';
    public static String ACCT_TMP_LINE_DOCUMENTATION_FEES = 'DOCUMENTATION FEES';
    public static String ACCT_TMP_LINE_EQUIPMENT = 'EQUIPMENT';
    public static String ACCT_TMP_LINE_GROSS_RENT = 'GROSS RENT';
    public static String ACCT_TMP_LINE_INITIAL_DIRECT_COST = 'INITIAL DIRECT COST';
    public static String ACCT_TMP_LINE_INITIAL_RENT_DUE = 'INITIAL RENT DUE';
    public static String ACCT_TMP_LINE_LATE_FEES = 'LATE FEES';
    public static String ACCT_TMP_LINE_LEASE_INCOME = 'LEASE INCOME';
    public static String ACCT_TMP_LINE_LEASE_RESIDUAL_RECEIVABLE = 'LEASE RESIDUAL RECEIVABLE';
    public static String ACCT_TMP_LINE_MAINTENANCE_FEES = 'MAINTENANCE FEES';
    public static String ACCT_TMP_LINE_NSF_FEES = 'NSF FEES';
    public static String ACCT_TMP_LINE_OTHER_FEES = 'OTHER FEES';
    public static String ACCT_TMP_LINE_PAYMENT_ADVANCE_RENTAL = 'PAYMENT - ADVANCE RENTAL';
    public static String ACCT_TMP_LINE_PAYMENT_EXCESS = 'PAYMENT - EXCESS';
    public static String ACCT_TMP_LINE_PAYMENT_FEES = 'PAYMENT - FEES';
    public static String ACCT_TMP_LINE_PAYMENT_RENT = 'PAYMENT - RENT';
    public static String ACCT_TMP_LINE_PAYMENT_TAX = 'PAYMENT - TAX';
    public static String ACCT_TMP_LINE_PAY_OFF_FEES = 'PAY-OFF FEES';
    public static String ACCT_TMP_LINE_PERIODIC_FEES = 'PERIODIC FEES';
    public static String ACCT_TMP_LINE_REFERRAL = 'REFERRAL';
    public static String ACCT_TMP_LINE_REFERRAL_FEE_PAYABLE = 'REFERRAL FEE PAYABLE';
    public static String ACCT_TMP_LINE_RENT = 'RENT';
    public static String ACCT_TMP_LINE_RESIDUAL_INCOME = 'RESIDUAL INCOME';
    public static String ACCT_TMP_LINE_UNEARNED_INCOME_LEASE = 'UNEARNED INCOME LEASE';
    public static String ACCT_TMP_LINE_UNEARNED_INCOME_RESIDUAL = 'UNEARNED INCOME RESIDUAL';
    public static String ACCT_TMP_LINE_UPFRONT_TAX_DUE = 'UPFRONT TAX DUE';
    public static String ACCT_TMP_LINE_WIRE_FEES = 'WIRE FEES';
    public static String ACCT_TMP_LINE_REFERRAL_FEE_PAYABLE_DEALER = 'REFERRAL FEE PAYABLE – DEALER';
    public static String ACCT_TMP_LINE_REFERRAL_FEE_PAYABLE_BROKER = 'REFERRAL FEE PAYABLE – BROKER';
    public static String ACCT_TMP_LINE_REFERRAL_FEE_PAYABLE_PROGRAM = 'REFERRAL FEE PAYABLE – PROGRAM';
    public static String ACCT_TMP_LINE_REFERRAL_FEE_PAYABLE_OTHER = 'REFERRAL FEE PAYABLE – OTHER';
    public static String ACCT_TMP_LINE_DEPRECIATION = 'DEPRECIATION';
    public static String ACCT_TMP_LINE_RENTAL_ACCRUAL = 'RENTAL ACCRUAL';

    public static String DEPRECIATION_METHOD = 'STRAIGHT LINE';
    public static String DEPRECIATION_CALCULATION_BASIS_EQUIPMENT_COST = 'Equipment Cost';
    public static String DEPRECIATION_CALCULATION_BASIS_BOOKED_LEASE_VALUE = 'Booked Lease Value';

    //Accrual Type Constants
    public static String ACCRUAL_TYPE_REGULAR = 'REGULAR';
    public static String ACCRUAL_TYPE_NPA = 'NPA';
    public static String ACCRUAL_TYPE_NPA_REVERSAL = 'NPA REVERSAL';
    public static String ACCRUAL_TYPE_NPA_CATCHUP = 'NPA CATCHUP';

    public static String ACCT_AMOUNT_OBJECT_COLUMN = 'Original_Amount__c';

    //account recordtypes
    public static String ACCOUNT_RECORDTYPE_DEALER = 'Dealer – Truck/Trailer';
    public static String ACCOUNT_RECORDTYPE_BROKER = 'Broker';
    public static String ACCOUNT_RECORDTYPE_PROGRAM = 'Program';
    public static String ACCOUNT_RECORDTYPE_OTHER = 'Others';

    public static String PAGE_SETUP_PRICING_DETAILS = 'PRICING DETAILS';
    public static String PAGE_SETUP_CONTRACT_EQUIPMENT = 'CONTRACT EQUIPMENT';

    public static String CONTRACT_EQUIPMENT_STATUS_TERMINATED = 'TERMINATED';
    public static String CONTRACT_EQUIPMENT_STATUS_TO_BE_TERMINATED = 'TO BE TERMINATED';

     // CRUD Operations
    public static String CRUD_INSERT = 'INSERT';
    public static String CRUD_UPDATE = 'UPDATE';
    public static String CRUD_UPSERT = 'UPSERT';
    public static String CRUD_DELETE = 'DELETE';

    // batch job names
    public static String LEASE_NPA_REVERSAL_CATCHUP_JOB = 'NPA Reversal And Catchup Job';
    public static String LEASE_DIAGNOSTICS_BATCH_JOB = 'Lease Diagnostics Job';
    public static String LEASE_MATURITY_BATCH_JOB    = 'Lease Maturity Job';
    public static String LEASE_EQUIPMENT_LATEST_TAX_RATES_UPDATE_JOB = 'Equipment Latest Tax Rates Update Job';
    public static String LEASE_EVERGREEN_PROCESSING_BATCH_JOB  = 'Evergreen Processing Job';
    public static String LEASE_DEALER_FUNDING_BATCH_JOB        = 'Dealer Funding Job';
	public static String LEASE_DISBURSEMENT_TXN_BATCH_JOB      = 'Disbursement Txn Generator Job';
    public static String LEASE_CREDIT_ACH_PROCESSING_BATCH_JOB = 'Credit ACH Processing Job';
    public static String LEASE_ALLOCATE_EXCESS_BATCH_JOB       = 'Allocate Excess Job';
    public static String LEASE_LATECHARGE_GENERATE_BATCH_JOB   = 'Late Charges Generate Job';
    public static String LEASE_PERIODIC_CHARGE_BATCH_JOB       = 'Periodic Charge Job';
    public static String LEASE_BILLING_BATCH_JOB               = 'Lease Billing Job';
    public static String LEASE_BILL_DETAIL_BATCH_JOB           = 'Bill Detail Generator Job';
    public static String LEASE_FETCH_TAX_RATES_BATCH_JOB       = 'Fetch Tax Rates Job';
    public static String LEASE_FETCH_FEETAX_RATES_BATCH_JOB    = 'Fetch Fee Tax Rates Job';
    public static String LEASE_PAYMENT_TXN_CLEARING_BATCH_JOB  = 'Lease Payment Txn Clearing Job';
    public static String LEASE_PAYMENT_TXN_GENERATE_BATCH_JOB  = 'Lease Payment Txn Generator Job';
    public static String LEASE_PAYMENT_TXN_ACH_BATCH_JOB        = 'Lease Payment Txns ACH Generator Job';
    public static String LEASE_DISBURSEMENT_TXN_ACH_BATCH_JOB = 'Lease Disbursement Txn ACH Job';
    public static String LEASE_DELINQUENCY_PROCESSING_BATCH_JOB = 'Delinquency Processing Job';
    public static String LEASE_ACCRUAL_BATCH_JOB                = 'Lease Accrual Job';
    public static String LEASE_APPLY_TAX_RATES_BATCH_JOB        = 'Apply Tax Rates Job';
    public static String LEASE_GLENTRIES_GENERATE_BATCH_JOB     = 'Generate GL Entries Job';
    public static String LEASE_GLREVERSAL_GENERATE_BATCH_JOB    = 'Generate GL Reversal Entries Job';
    public static String LEASE_INSTALLATION_JOB                 =  'Update Contract after Installation Job';
    public static String LEASE_PASSTHROUGH_DISB_BATCH_JOB       =  'Passthrough Disbursement Generator Job';
    public static String LEASE_INVOICE_GENERATION_BATCH_JOB     =  'Invoice Generation Job';
    public static String LEASE_EQUIPMENT_DEPRECIATION_GENERATE_JOB     = 'Generate Equipment Depreciation Job';
    public static String LEASE_EQUIPMENT_GLENTRIES_GENERATE_BATCH_JOB     = 'Generate Equipment GL Entries Job';
    public static String EQUIPMENT_CHARGE_GENERATION_BATCH_JOB     = 'Equipment Charge Generator Job';
    public static String LEASE_CASHRECIEPT_GLENTRIES_GENERATE_BATCH_JOB     = 'Generate Cash Receipt GL Entries Job';
    public static String VARIABLE_RENT_CREATION_JOB             = 'Variable Rent Creation Job';
	public static String LEASE_CASH_RECEIPT_ALLOCATION_JOB      = 'Cash Receipts Auto Application Job';
    
    // jobs has to remove from cl lease
    public static String LEASE_PAYMENT_TXN_SWEEPTOACH_BATCH_JOB = '';
    public static String LEASE_ACH_PROCESSING_BATCH_JOB         = 'ACH Processing Job';

    public static String LEASE_DAG_MOVE_DATE_WITH_PROCESSING    = 'CL Lease:DailyProcessing';
    public static String LEASE_DAG_BATCH_JOBS                   = 'CL Lease:BatchJobs';
    public static String LEASE_DAG_AVALARA_JOB                  = 'CL Lease:AvalaraJob';

    // Transaction SubTypes Constants
    public static String TXN_SUBTYPE_ADVANCE_PAYMENTS_RECEIVED  = 'ADVANCE PAYMENTS RECEIVED';
    public static String TXN_SUBTYPE_CASH_RECEIVED              = 'CASH RECEIVED';
    public static String TXN_SUBTYPE_DEALER_PAYABLE             = 'DEALER PAYABLE';
    public static String TXN_SUBTYPE_DEPRECIATION_ACCRUAL       = 'DEPRECIATION ACCRUAL';
    public static String TXN_SUBTYPE_EQUIPMENT_COST             = 'EQUIPMENT COST';
    public static String TXN_SUBTYPE_EVERGREEN_DEPRECIATION_ACCRUAL = 'EVERGREEN DEPRECIATION ACCRUAL';
    public static String TXN_SUBTYPE_GROSS_RENT                 = 'GROSS RENT';
    public static String TXN_SUBTYPE_IDC_COST                   = 'IDC COST';
    public static String TXN_SUBTYPE_IDC_EXPENSE_ACCRUAL        = 'IDC EXPENSE ACCRUAL';
    public static String TXN_SUBTYPE_LEASE_INCOME_ACCRUAL       = 'LEASE INCOME ACCRUAL';
    public static String TXN_SUBTYPE_NBV_LEASE                  = 'NBV LEASE';
    public static String TXN_SUBTYPE_NBV_RESIDUAL               = 'NBV RESIDUAL' ;
    public static String TXN_SUBTYPE_PAYMENT_RENT               = 'PAYMENT - RENT';
    public static String TXN_SUBTYPE_PAYMENT_TAX                = 'PAYMENT - TAX';
    public static String TXN_SUBTYPE_PAYMENT_EXCESS             = 'PAYMENT - EXCESS';
    public static String TXN_SUBTYPE_PAYMENT_SUBSIDY            = 'PAYMENT - SUBSIDY' ;
    public static String TXN_SUBTYPE_PAYMENT_FEES               = 'PAYMENT - FEES' ;
    public static String TXN_SUBTYPE_PAYMENT_ADVANCE_RENT       = 'PAYMENT – ADVANCE RENT';
    public static String TXN_SUBTYPE_REFERRAL_FEE               = 'REFERRAL FEE';
    public static String TXN_SUBTYPE_PERIODIC_RENT              = 'PERIODIC RENT';
    public static String TXN_SUBTYPE_RENTAL_ACCRUAL             = 'RENTAL ACCRUAL';
    public static String TXN_SUBTYPE_RESIDUAL_INCOME_ACCRUAL    = 'RESIDUAL INCOME ACCRUAL';
    public static String TXN_SUBTYPE_RESIDUAL_RECEIVABLE        = 'RESIDUAL RECEIVABLE';
    public static String TXN_SUBTYPE_SUBSIDY_ACCRUAL            = 'SUBSIDY ACCRUAL';
    public static String TXN_SUBTYPE_SUBSIDY_BILLING            = 'SUBSIDY BILLING';
    public static String TXN_SUBTYPE_TAX_UPFRONT                = 'TAX UPFRONT';
    public static String TXN_SUBTYPE_UNEARNED_LEASE_INCOME      = 'UNEARNED LEASE INCOME';
    public static String TXN_SUBTYPE_UNEARNED_RESIDUAL_INCOME   = 'UNEARNED RESIDUAL INCOME';
    public static String TXN_SUBTYPE_DOCUMENTATION_FEES         = 'DOCUMENTATION FEES';
    public static String TXN_SUBTYPE_PERIODIC_RENT_BILLING      = 'PERIODIC RENT BILLING';
    public static String TXN_SUBTYPE_TAX_BILLING                = 'TAX BILLING';
    public static String TXN_SUBTYPE_DOC_FEES                   = 'DOC FEES';
    public static String TXN_SUBTYPE_DEALER_PAYABLE_FUNDING     = 'DEALER PAYABLE FUNDING';
    public static String TXN_SUBTYPE_REFERRAL_FEE_FUNDING       = 'REFERRAL FEE FUNDING';
    public static String TXN_SUBTYPE_EVERGREEN_RENT             = 'EVERGREEN RENT';
    public static String TXN_SUBTYPE_EVERGREEN_TAX              = 'EVERGREEN TAX' ;
    public static String TXN_SUBTYPE_TERMINATION_RENT           = 'TERMINATION RENT';
    public static String TXN_SUBTYPE_TERMINATION_TAX            = 'TERMINATION TAX';
    public static String TXN_SUBTYPE_PAYMENT_CONTRACT_SALE      = 'PAYMENT - CONTRACT SALE';
    public static String TXN_SUBTYPE_SUBVENTION_ACCRUAL         = 'SUBVENTION ACCRUAL';
    public static String TXN_SUBTYPE_TERM_RESIDUAL              = 'TERM RESIDUAL';
    public static String TXN_SUBTYPE_DEBT_SCHEDULE              = 'DEBT SCHEDULE';
    // Fee's Amortization period picklist values
    public static String FEE_AMORTIZED_PERIOD_FEE_TERM      = 'FEE TERM';
    public static String FEE_AMORTIZED_PERIOD_CONTRACT_TERM = 'CONTRACT TERM';

    // Contract Creation
    public enum ContractCreateOption {GENERATESTREAMS, ACTIVATECONTRACT}

    public enum OperationType {ISDELETE, ISINSERT, ISUPDATE, ISUNDELETE}

    // Passthrough events
    public static String PASSTHROUGH_EVENT_ONBILLING        = 'On Billing';
    public static String PASSTHROUGH_EVENT_FULLPAYMENT      = 'On Full Payment';
    public static String PASSTHROUGH_EVENT_PARTIALPAYMENT   = 'On Partial Payment';

    // Passthrough Withhold Basis
    public static String PASSTHROUGH_WITHHOLD_AMOUNT        = 'Amount';
    public static String PASSTHROUGH_WITHHOLD_PERCENTAGE    = 'Percentage';

    public static String FEE_TYPE_PASSTHROUGH               = 'Passthrough';
    public static String PASSTHROUGH_SUFIX                  = ' - Passthrough';

    // CL ORIGINATION - Constants
    public static String CLO_CREDIT_APPROVED = 'CREDIT APPROVED';

    // Exception, Error constants
    public static String CLLEASE_EXCEPTION  = 'EXCEPTION';
    public static String CLLEASE_ERROR      = 'ERROR';

    //Stream related constants, used in contract's picklist
    public static String STREAM_DEPRECIATION = 'Depreciation';
    public static String STREAM_INCOME = 'Income';
    public static String STREAM_RESIDUAL = 'Residual';
    public static String STREAM_IDC = 'IDC';
    public static String STREAM_TAX = 'Tax';
    public static String STREAM_SUBSIDY = 'Subsidy';
    public static String STREAM_SUBVENTION = 'Subvention';
    public static String STREAM_RENT = 'Rent';
    public static String STREAM_FEE = 'Fee';

    // Record Types
    public static String RECORD_TYPE_OTHER_TRANSACTION_EVERGREEN = 'Evergreen_Record_Type';

    // Payment stream's payment type's picklist values
    public static String PAYMENT_STREAM_PAYMENT_TYPE_RENT = 'RENT';
    public static String PAYMENT_STREAM_PAYMENT_TYPE_ADVANCE_RENT = 'ADVANCE RENT';
    public static String PAYMENT_STREAM_PAYMENT_TYPE_RESIDUAL = 'RESIDUAL';
    public static String PAYMENT_STREAM_PAYMENT_TYPE_FEES = 'FEES';
    public static String PAYMENT_STREAM_PAYMENT_TYPE_EVERGREEN_RENT = 'EVERGREEN RENT';

    //Calculation Method
    public static String CALCULATION_METHOD_SYD = 'SYD';
    public static String CALCULATION_METHOD_IRR = 'IRR';

    //Bill status
    public static String BILL_STATUS_IN_PROCESS = 'In Process';
    public static String BILL_STATUS_PROCESSED = 'Processed';
    public static String BILL_STATUS_TAX_PROCESSED = 'Tax Calculated';
    public static String BILL_STATUS_INACTIVE = 'Inactive';

    //Charge Status
    public static String CHARGE_STATUS_TAX_PROCESSED = 'Tax Calculated';
    public static String CHARGE_STATUS_TAX_YET_TO_BE_CALCULATED = 'Tax Yet To Be Calculated For Location Based Tax';

    //tax source
    public static String TAX_SOURCE_AVALARA = 'Avalara';
    public static String TAX_SOURCE_CL_LEASE = 'CL Lease';

    //tax method
    public static String TAX_METHOD_VAT = 'VAT';
    public static String TAX_METHOD_SALES = 'Sales';

    //tax method
    public static String TAX_METHOD_VAT_INCLUSIVE = 'Inclusive';
    public static String TAX_METHOD_VAT_EXCLUSIVE = 'Exclusive';

    //Fee class
    public static String FEE_CLASS_EXPENSE = 'EXPENSE';
    public static String FEE_CLASS_INCOME = 'INCOME';

    //Run Batch Job Companies Values
    public static String CURRENT_COMPANY = 'Current Company';

    //Tax configurations in spread
    public static String SPREAD_TAX_CONFIG_TAX_FIRST = 'TAX FIRST';
    public static String SPREAD_TAX_CONFIG_RECEIVABLE_FIRST = 'RECEIVABLE FIRST';
    public static String SPREAD_TAX_CONFIG_DISTRIBUTE = 'DISTRIBUTE';

    //Invoice credit status
    public static String INVOICE_CREDIT_UNAPPLIED = 'UNAPPLIED';
    public static String INVOICE_CREDIT_PARTLY_APPLIED = 'PARTIALLY APPLIED';
    public static String INVOICE_CREDIT_FULLY_APPLIED = 'FULLY APPLIED';
    public static String INVOICE_CREDIT_CANCELLED = 'CANCELLED';

    //Tax Depreciation Methods
    public static String TAX_DEPRECIATION_STL = 'STL';
    public static String TAX_DEPRECIATION_SYD = 'SYD';
    public static String TAX_DEPRECIATION_WDV = 'WDV';


    //Termination quote status
    public static final String TERMINATION_QUOTE_STATUS_GENERATED = 'GENERATED';
    public static final String TERMINATION_QUOTE_STATUS_PROCESSED = 'PROCESSED';
    public static final String TERMINATION_QUOTE_STATUS_ACCEPTED = 'ACCEPTED';
    public static final String TERMINATION_QUOTE_STATUS_TERMPROCESSED = 'TERMINATION PROCESSED';

    //Terminaton quote header quote-type
    public static final String TERMINATION_QUOTE_TYPE_WITH_PURCHASE = 'TERMINATION WITH PURCHASE';
    public static final String TERMINATION_QUOTE_TYPE_WITHOUT_PURCHASE = 'TERMINATION WITHOUT PURCHASE';
    public static final String TERMINATION_QUOTE_REASON_CUSTOMER_REQ = 'CUSTOMER REQUESTED';
    public static final String TERMINATION_QUOTE_REASON_INSURANCE = 'INSURANCE';

    //Termination quote line type
    public static final String TERMINATION_CONFIG_UNBILLED_RECEIVABLE = 'QUOTE UNBILLED RECEIVABLE';
    public static final String TERMINATION_CONFIG_UNPAID_RENT = 'BILLED NOT PAID - RENT';
    public static final String TERMINATION_CONFIG_UNPAID_TAX = 'BILLED NOT PAID - TAX';
    public static final String TERMINATION_CONFIG_UNPAID_CHARGE = 'BILLED NOT PAID - CHARGES';
    public static final String TERMINATION_CONFIG_DISCOUNT = 'QUOTE DISCOUNT';
    public static final String TERMINATION_CONFIG_SECURITY_DEPOSIT = 'SECURITY DEPOSIT';
    public static final String TERMINATION_CONFIG_EXCESS = 'EXCESS';
    public static final String TERMINATION_CONFIG_PURCHASE_AMOUNT = 'QUOTE PURCHASE AMOUNT';
	
    public static final String TERMINATION_QUOTE_LINE_TYPE_REBATE_AMOUNT = 'REBATE AMOUNT - THIRD PARTY SALE';

	//Termination Quote Expiry Event
    public static final String TERMINATION_EXPIRY_NEXT_DUE_GENERATION_DATE = 'Next Due Generation Date';
    public static final String TERMINATION_EXPIRY_NEXT_DUE_DATE = 'Next Due Date';

    //termination type
    public static final String TERMINATION_TYPE_EARLY = 'EARLY TERMINATION';
    public static final String TERMINATION_TYPE_END_OF_TERM = 'END OF TERM TERMINATION';

    //termination related comments on various streams
    public static final String TERMINATION_STREAM_ACCRUAL_COMMENT = 'Termination Quote Accrual';
    public static final String TERMINATION_STREAM_DEACTIVATION_COMMENT = 'Deactivated Streams During Full Termination Process';
    public static final String TERMINATION_STREAM_ADJUSTED_COMMENT = 'Adjusted Streams During Partial Termination Process';

    //ACH Processing for holidays
    public static final String IGNORE_HOLIDAYS = 'IGNORE HOLIDAYS';
    public static final String BEFORE_HOLIDAYS = 'BEFORE HOLIDAYS';
    public static final String AFTER_HOLIDAYS = 'AFTER HOLIDAYS';

    //upfront payment picklist options
    public static final String FIRST_AND_LAST_ONE = '1ST AND LAST';
    public static final String FIRST_AND_LAST_TWO = '1ST AND LAST2';
    public static final String FIRST_AND_LAST_THREE = '1ST AND LAST3';


    //Variable Rent Basis
    public static final String VARIABLE_RENT_BASIS_COUNT = 'Count';
    public static final String VARIABLE_RENT_BASIS_TOTAL = 'Total';

    public static final String LEASE_CATEGORY = 'Lease Category';
	
	public static final String LEASE_SYSTEM_NAME = 'CL-Lease';

    public static final String GL_GENERATION_SCHEME_SYSTEM = 'SYSTEM';    
    public static final String GL_GENERATION_SCHEME_REVERSAL = 'REVERSAL';
}