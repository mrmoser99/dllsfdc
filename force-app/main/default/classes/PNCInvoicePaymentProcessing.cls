/**
 * Owner: Cloud Lending Solutions
 * Description: Following job helps in processing PNC return file and 
 *              Create payments towards Bills and Charges FROM Invoice.
 *  next step: 
 *  Modified On : 09/23/2019 // Made changes in payment creation job to start using cash receipt  
 **/
global with sharing class PNCInvoicePaymentProcessing extends clcommon.DynamicJob {
   
    private Map<String, Id> paymentModesMap;
    private Map<String, Id> commonPaymentModesMap;
    private Date currentSystemDate;
    private String autoACHPaymentMode = 'Auto ACH';
    //private Int_PX_Remit__c pncBatchHeaderRecord;
    private static String query;
    private static final String JOB_NAME = 'PNC Invoice Payment Creation Job';
    private List<clcommon__Cash_Receipt__c> cashReceipts;
    private Map<Id, clcommon__Cash_Receipt__c> cashReceiptToRemit;
    private Map<Id, clcommon__Cash_Receipt_Application__c> cashReceiptToApplication;
    private Map<Id, cllease__Lease_Payment_Transaction__c> cashReceiptToLpt;
    private Map<id, Decimal> balanceCheckOnCashReceipt = new Map<Id, Decimal>();

    global PNCInvoicePaymentProcessing() {
        super(JOB_NAME, initialize(null));
        doInitialize();
    }
    
    global PNCInvoicePaymentProcessing(List<String> pncReturnRecordNames) {
        super(JOB_NAME, initialize(pncReturnRecordNames));
        doInitialize();
    }
    
    global virtual override String getRuntimeQuery() {
        System.debug(LoggingLevel.ERROR, 'PNCInvoicePaymentProcessing query in getRuntimeQuery : ' + query);
        return query; 
    }

    public static String initialize(List<String> pncReturnRecordNames) {

        // 1. Querying PNC Response Object : Int_PX_Remit__c for payments creation
        // Following query skips the first record of PNC Payment which is for BATCH HEADER
        query = ' SELECT Id, Name,            '+
                '   Account_Num__c,           '+
                '   Date__c,                  '+
                '   Invoice_Amount_Paid__c,   '+
                '   Invoice_Number__c,        '+
                '   Line_Data__c,             '+
                '   Record_Number__c,         '+
                '   Transaction_Amount__c,    '+
                '   Transaction_Type__c,      '+
                '   Trans_Source__c,          '+
                '   Trans_UID__c,             '+
                '   Committed__c,             '+
                '   Remark__c                 '+
                ' FROM Int_PX_Remit__c        '+
                ' WHERE Committed__c = false  ';
                //'   AND Name > \''+ pncBatchHeaderRecordTemp.Name +'\'';

        if(pncReturnRecordNames!=null && pncReturnRecordNames.size() > 0) {
            String pncReturnRecordNamesStr = '';
            for (String pncReturnRecordName : pncReturnRecordNames) {
              pncReturnRecordNamesStr = pncReturnRecordNamesStr + '\'' + String.escapeSingleQuotes(pncReturnRecordName) + '\'' + ',';
            }
            pncReturnRecordNamesStr = pncReturnRecordNamesStr.substring(0, pncReturnRecordNamesStr.length() - 1);
            query += ' AND Name IN ('+ pncReturnRecordNamesStr + ')';
        }

        query += ' ORDER BY Date__c ';
        
        System.debug(LoggingLevel.ERROR, 'PNCInvoicePaymentProcessing query in getRuntimeQuery : ' + query);
        return query;
    }
    
    /**
     * Following methos will create a cash receipt for an invoice and create lpt for all bills and charges on the contract.
     *      a. Creating payments towards Bills and charges attached to Invoice
     **/
    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {
          
        Map<string, List<Int_PX_Remit__c>> multPxRemMap = new Map<string, List<Int_PX_Remit__c>>();
        Map<string, Decimal> multPxRemTrnAmount = new Map<string,Decimal>();
        List<Int_PX_Remit__c> updatePxremList = new List<Int_PX_Remit__c>();
        List<cllease__Lease_Payment_Transaction__c> pmtsToInsert = new List<cllease__Lease_Payment_Transaction__c>();
        
        Savepoint sp = database.setsavepoint();
        try {
            List<Int_PX_Remit__c> pxRemitList = (List<Int_PX_Remit__c>)scope;     
            // A. Looping all PNC return records to consolidate all related PNC Return records with total amount
            for(Int_PX_Remit__c pxRem: pxRemitList) {
                
                // Validations
                // 1. Remit file cannot process if Invoice Number null.
                if(pxRem.Invoice_Number__c == null) {
                    pxRem.Remark__c = ' Remit Record doesnot have invoice Number to process...';
                    updatePxremList.add(pxRem);
                    continue; 
                } 
                // 2. Future Payments Can't Create in CL Lease System.
                if(pxRem.Date__c > currentSystemDate) {
                    pxRem.Remark__c = ' Futute Payments Cannot Create in CL Lease, Remit Transaction Date: '+pxRem.Date__c +
                                      ' Current System Date: '+currentSystemDate;
                    updatePxremList.add(pxRem);
                    continue;
                }   
                // a. Consolidating all PNC Return records per Invoice Number
                List<Int_PX_Remit__c> pxRemitlst = multPxRemMap.get(pxRem.Invoice_Number__c);
                if(pxRemitlst == null) {
                    pxRemitlst = new List<Int_PX_Remit__c>();
                }
                pxRemitlst.add(pxRem);
                multPxRemMap.put(pxRem.Invoice_Number__c, pxRemitlst);
            }

            // B. Querying all invoices with charges where invoices with Bills and Charges
            List<clcommon__Consolidated_Invoice__c> invoicesList = [SELECT Id, Name, LS_Contract__c, clcommon__Account__c, Balance_Invoice_Amount__c,
                                                (SELECT Id, Name, cllease__Total_Due_Amount__c, cllease__Consolidated_Invoice__c 
                                                    FROM cllease__Bills__r
                                                    WHERE cllease__Payment_Satisfied__c = false),
                                                (SELECT Id, Name,cllease__Total_Due_Amount__c,cllease__Consolidated_Invoice__c 
                                                    FROM cllease__Charges__r
                                                    WHERE cllease__Paid__c = false) 
                                            FROM clcommon__Consolidated_Invoice__c 
                                            WHERE name IN :multPxRemMap.keyset()];

            Map<Id, String> billDueAmountMap = new Map<Id, String>();
            Map<Id, String> chargeDueAmountMap = new Map<Id, String>();

            // Creating Map of Due Amount per Bill and Charges
            for(clcommon__Consolidated_Invoice__c invoice : invoicesList) {
                for(cllease__Lease_account_Due_Details__c bill : invoice.cllease__Bills__r) {
                    if(bill.cllease__Total_Due_Amount__c != null && bill.cllease__Total_Due_Amount__c > 0) {
                        String billNames;
                        if(billDueAmountMap.containsKey(invoice.Id))
                            billNames = billDueAmountMap.get(invoice.Id);
                        if(billNames == null)
                            billNames = bill.Name;
                        else
                        	billNames += ';' + bill.Name;
                        billDueAmountMap.put(invoice.Id, billNames);
                    }                    
                }
                for(cllease__Charge__c charge: invoice.cllease__Charges__r) {
                    if(charge.cllease__Total_Due_Amount__c != null && charge.cllease__Total_Due_Amount__c > 0) {
                        String chargeNames;
                        if(chargeDueAmountMap.containsKey(invoice.Id))
                            chargeNames = chargeDueAmountMap.get(invoice.Id);
                        if(chargeNames == null)
                        	chargeNames = charge.Name;
                        else
                            chargeNames += ';' + charge.Name;
                        chargeDueAmountMap.put(invoice.Id, chargeNames);
                    }
                }
            }

            System.debug(LoggingLevel.ERROR, ' BillDueAmountMap: '+billDueAmountMap);
            System.debug(LoggingLevel.ERROR, ' ChargeDueAmountMap: '+chargeDueAmountMap);

            Decimal currentPmtAmount, pxTotalPmtAmount; 
            List<cllease__Lease_Payment_Transaction__c> pmtsPerRemit;
            cashReceipts = new List<clcommon__Cash_Receipt__c>();
            cashReceiptToRemit = new Map<Id, clcommon__Cash_Receipt__c>();
            cashReceiptToApplication = new Map<Id, clcommon__Cash_Receipt_Application__c>();
            cashReceiptToLpt = new Map<Id, cllease__Lease_Payment_Transaction__c>();
            // C. Looping through all Invoices for Creating Payment Transactions in System
            for(clcommon__Consolidated_Invoice__c invoice : invoicesList) {
                // Looping all PNC Return files per Invoices to apply payments
                Decimal invoiceBalance = invoice.Balance_Invoice_Amount__c;
                for(Int_PX_Remit__c pxRem : multPxRemMap.get(invoice.Name)) {
                    pxRem.Transaction_Amount__c = pxRem.Transaction_Amount__c != null ? pxRem.Transaction_Amount__c : 0;
                    Date pmtDate = pxRem.Date__c;
                    pmtsPerRemit = new List<cllease__Lease_Payment_Transaction__c>();

                    // Validations
                    // 1. Payment Amount can't be <= 0 to create payments for Remit file
                    if(pxRem.Transaction_Amount__c <= 0 ) {
                        pxRem.Remark__c = 'Remit file has Transaction Amount = 0. Payments Cannot Create for it.';
                        updatePxremList.add(pxRem);
                        continue;
                    }

                    if(invoice.LS_Contract__c == null) {
                        pxRem.Remark__c = 'Invoice not linked to any Contract to create payments, Please verify Invoice: '+invoice.Name;
                        updatePxremList.add(pxRem);
                        continue;
                    }
                    
                    // Creation of cash receipt
                    clcommon__Cash_Receipt__c cashReceipt = new clcommon__Cash_Receipt__c();
                    cashReceipt.clcommon__Account__c = invoice.clcommon__Account__c;
                    cashReceipt.clcommon__Payment_Mode__c = commonPaymentModesMap.get(autoACHPaymentMode);
                    cashReceipt.clcommon__Receipt_Date__c = pmtDate;
                    cashReceipt.clcommon__Receipt_Amount__c = pxRem.Transaction_Amount__c;
                    cashReceipt.clcommon__Creation_Date__c  = pmtDate;
                    cashReceipt.clcommon__Unused_Amount__c =  pxRem.Transaction_Amount__c;
                    cashReceipt.clcommon__Receipt_Status__c = 'CREATED';
                    cashReceipt.Int_PX_Remit__c = pxRem.Id;
                    cashReceiptToRemit.put(pxRem.Id, cashReceipt);
                    cashReceipts.add(cashReceipt);
                    
                    /*if(invoiceBalance < pxRem.Transaction_Amount__c){
                        balanceCheckOnCashReceipt.put(pxRem.Id, pxRem.Transaction_Amount__c - invoiceBalance);  
                    }
                    invoiceBalance -= pxRem.Transaction_Amount__c;*/
                        
                    // Applying Payments per PNC Return file to get exact payment Date
                    cllease__Lease_Payment_Transaction__c pmtTxn = new cllease__Lease_Payment_Transaction__c();
                    pmtTxn.cllease__Contract__c = invoice.LS_Contract__c;                    
                    pmtTxn.cllease__Bills__c    = billDueAmountMap.get(invoice.Id);
                    pmtTxn.cllease__Charges__c  = chargeDueAmountMap.get(invoice.Id);
                    pmtTxn.Pmt_For_Invoice__c   = invoice.Id;
                    pmtTxn.cllease__Transaction_Amount__c   = pxRem.Transaction_Amount__c;
                    pmtTxn.cllease__Payment_Mode__c         = paymentModesMap.get(autoACHPaymentMode);
                    pmtTxn.cllease__Transaction_Date__c     = pmtDate;
                    pmtTxn.cllease__Receipt_Date__c         = pmtDate;
                    pmtTxn.cllease__Cheque_Number__c        = pxRem.Transaction_Type__c;
                    pmtTxn.Int_PX_Remit__c					= pxRem.Id;
                    cashReceiptToLpt.put(pxRem.Id, pmtTxn);
                    pmtsPerRemit.add(pmtTxn);
                    pxRem.Committed__c = true;
                    pxRem.Remark__c = 'Remit file Successfully Processed. Check Invoice for Payments...';
                    updatePxremList.add(pxRem);
                }
            }
        
            System.debug(LoggingLevel.ERROR,'pmtsToInsert values :::'+pmtsToInsert);
        
            // D. DML Operations on New Payments
            if(cashReceipts.size() > 0) {
                insert cashReceipts;
            }
            
            // Creating transaction for created cash receipt
            List<clcommon__Cash_Receipt_Transaction__c> accountingTxns = new List<clcommon__Cash_Receipt_Transaction__c>();
            for(clcommon__Cash_Receipt__c cashReceipt : cashReceipts){
                clcommon__Cash_Receipt_Transaction__c accountingTxn = new clcommon__Cash_Receipt_Transaction__c();
                accountingTxn.clcommon__Cash_Receipt__c = cashReceipt.Id;
                accountingTxn.clcommon__Transaction_Amount__c = cashReceipt.clcommon__Receipt_Amount__c;
                accountingTxn.clcommon__Transaction_Date__c = cashReceipt.clcommon__Creation_Date__c;
                accountingTxn.clcommon__New_Receipt_Date__c = cashReceipt.clcommon__Receipt_Date__c;
                accountingTxn.clcommon__New_Account__c = cashReceipt.clcommon__Account__c;
                accountingTxn.clcommon__Transaction_Sub_Type__c =  'CREATED_WITH_BORROWER';
                accountingTxns.add(accountingTxn);
            }
            insert accountingTxns;
            
            // Mapping created cash receipt with lpt through cash application
            List<clcommon__Cash_Receipt_Application__c> cashApplications = new List<clcommon__Cash_Receipt_Application__c>();
            // Lets loop through all the cash receipt to create cash application.
            for(clcommon__Consolidated_Invoice__c invoice : invoicesList){
                for(Int_PX_Remit__c pxRem : multPxRemMap.get(invoice.Name)) {
                    clcommon__Cash_Receipt_Application__c cashApplication = new clcommon__Cash_Receipt_Application__c();
                    cashApplication.clcommon__Cash_Receipt__c = cashReceiptToRemit.get(pxRem.Id).Id;
                    cashApplication.clcommon__Creation_Date__c = pxRem.Date__c;
                    cashApplication.clcommon__Allocated_Amount__c  = pxRem.Transaction_Amount__c;
                    cashApplication.clcommon__Receipt_Application_Status__c   = 'CREATED';
                    cashApplication.clcommon__Unused_Amount__c  = pxRem.Transaction_Amount__c;
                    /*if(balanceCheckOnCashReceipt.containsKey(pxRem.Id))
                        cashApplication.clcommon__Unused_Amount__c = balanceCheckOnCashReceipt.get(pxRem.Id);
                    else
                    	cashApplication.clcommon__Unused_Amount__c  = 0;*/
                    cashApplications.add(cashApplication);
                    cashReceiptToApplication.put(pxRem.Id, cashApplication);
            	}
            }
            
            if(cashApplications.size() > 0){
                insert cashApplications;
            }
            
            for(Id pxRemId : cashReceiptToApplication.keySet()){
                cllease__Lease_Payment_Transaction__c pmtTxn = new cllease__Lease_Payment_Transaction__c();
                pmtTxn = cashReceiptToLpt.get(pxRemId);
                pmtTxn.cllease__Cash_Application__c = cashReceiptToApplication.get(pxRemId).Id;
                pmtsToInsert.add(pmtTxn);
            }
            
            if(pmtsToInsert.size() > 0) {
                insert pmtsToInsert;
            }

            // E. Updating PNC Return records for processing "Committed__c = true"
            if(updatePxremList.size()>0) {
                update updatePxremList;
            }
                 
        } catch(Exception e) {
            database.rollback(sp);   
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());      
            //insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name='PNCInvoicePaymentProcessing',
            cllease__Date__c=system.today(), cllease__Message__c='Error is '+e.getMessage()
            +' in line number: '+ e.getLineNumber());
        }
    }
    
    public override void doInitialize() { 
        // Other Required setup: Payment Mode
        List<cllease__Payment_Mode__c> paymentModes = [SELECT Id, Name 
                                                            FROM cllease__Payment_Mode__c
                                                            LIMIT 100];
        // Common payment mode for cash receipt
        List<clcommon__Payment_Mode__c > commonPaymentModes = [SELECT Id, Name 
                                                            FROM clcommon__Payment_Mode__c 
                                                            LIMIT 100];

        paymentModesMap = new Map<String, Id>();                                                    
        for(cllease__Payment_Mode__c paymentMode : paymentModes) {
            paymentModesMap.put(paymentMode.Name, paymentMode.Id);
        }
        
        commonPaymentModesMap = new Map<String, Id>();                                                    
        for(clcommon__Payment_Mode__c paymentMode : commonPaymentModes) {
            commonPaymentModesMap.put(paymentMode.Name, paymentMode.Id);
        }

        // 2. Current CL Lease System Date
        currentSystemDate = cllease.SystemDateUtil.getCurrentSystemDate();
    }

    public override void doStart(Database.BatchableContext bc) { }   

    public override void doFinish(Database.BatchableContext bc) { }
}