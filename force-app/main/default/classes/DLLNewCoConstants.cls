/**
 *  Author: Cloud Lending Solutions
 *  Following class to maintain org level Constants
 **/
public with sharing class DLLNewCoConstants {
    
    // Transaction Sub Types
    public static String TXNSUBTYPE_SERVICES_FEE_PASSTHROUGH = 'Service Fees - Passthrough';
    public static String TXNSUBTYPE_ASSETSALE    = 'ASSET SALE';
    public static String TXNSUBTYPE_ESTIMATED_PROPERTY_TAX  = 'Estimated Property Tax';
    public static String TXNSUBTYPE_INSURANCE_FEE = 'Insurance Fees';
        
    // Transaction Types
    public static String TXN_DISBURSEMENT = 'DISBURSEMENT';
    public static String TXN_DEALERFUNDING = 'DEALER FUNDING';
    public static String TXN_ASSETSALE = 'ASSET SALE';
    public static String TXN_CHARGE = 'CHARGE';
    public static String TXN_RESTRUCTURE = 'RESTRUCTURE';
    public static String TXN_TERMINATION = 'TERMINATION';            
    
    // DLL Fund Type
    public static String FUNDTYPE_PASSTHROUGH = 'PASSTHROUGH';
    public static String FUNDTYPE_ASSET = 'ASSET';


    // Tax Process flags
    public static String BILL_TAX_PROCESSED = 'Tax Calculated';
    public static String CHARGE_TAX_PROCESSED = 'Tax Calculated';

    // Fee Definition Types
    public static String FEE_ACTUAL_PROPERTY_TAX    = 'Actual Property Tax';
    public static String FEE_ASSET_REPAIR_FEE       = 'Asset Repair Fee';
    public static String FEE_ASSET_RETURN_FEE_TYPE  = 'Asset Return Fee type';
    public static String FEE_ASSET_SALE             = 'ASSET SALE';
    public static String FEE_EARLY_TERMINATION_FEE  = 'Early Termination Fee';
    public static String FEE_ESTIMATED_PROPERTY_TAX = 'Estimated Property Tax';
    public static String FEE_TERMINATION_QUOTE_FEE  = 'TERMINATION QUOTE FEES';
    public static String FEE_FINANCE_FEE        = 'Finance Fees';
    public static String FEE_INSURANCE_FEE      = 'Insurance Fees';
    public static String FEE_INTERIM_RENT       = 'Interim Rent';
    public static String FEE_LATE_FEE           = 'Late Fees';
    public static String FEE_ORIGINATION_FEE    = 'Origination Fees';
    public static String FEE_SERVICE_FEE        = 'Service Fees';
    public static String FEE_UPFRONT_TAX_FEE    = 'Upfront Tax Fees';
    public static String FEE_ASSETSALE          = 'ASSET SALE';  
    public static String FEE_NSF                = 'NSF Fees';  
    
    //Recordtype names
    public static String REC_ASSETSALE    = 'ASSET SALE';
    public static String REC_STOP_PERIODIC_FEE    = 'Stop-Periodic-Fee';
    
    //Duetype description names
    public static String DUETYPE_BILLDUEDATE = 'BILL / DUE DATE';
    
    //soap version - used in conga classes
    public static String SOAP_VERSION = '/services/Soap/u/39.0/';


    public static String EQUIPMENT_STATUS_SOLD = 'SOLD';

    public static String EXPERIAN_VALIDATION_STATUS = 'Verified by Experian';
    public static String USER_PREFERED_STATUS = 'User Preferred';

    // Ints Batch Status Records Names
    public static String BATCH_STATUS_AP_CONFIRMATION   = 'AP Confirm';
    public static String BATCH_STATUS_PNC_PAYMENTS      = 'Px Remit'; 
    public static String BATCH_STATUS_PNC_NSF           = 'Px NSF'; 


    public static String PNC_BATCH_HEADER           = 'BATCH HEADER';
    public static String BATCH_STATUS_READY         = 'Ready';
    public static String BATCH_STATUS_COMPLETED     = 'Completed';

    public static String QUOTE_ESTIMATED_PROPERTY_TAX = 'QUOTE ESTIMATED PROPERTY TAX';
    public static String QUOTE_ESTIMATED_SALES_TAX = 'SALES TAX';
    
}