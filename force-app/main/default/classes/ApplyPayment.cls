public class ApplyPayment {
    /*
     * Following method helps in applying payment towards Bill
	*/
    public static void createPayment(String billNumber) {
        
        cllease__Lease_account_Due_Details__c bill = [SELECT Id, Name, cllease__Balance_Amount__c, 
                                                            cllease__Account__c, 
                                                            cllease__Lease_Account__c
                                                        FROM cllease__Lease_account_Due_Details__c WHERE Name = :billNumber];
                                                        
        Decimal dueAmount = bill.cllease__Balance_Amount__c;
        String LesseeAccId = bill.cllease__Account__c;
        String contractId  = bill.cllease__Lease_Account__c;
        
        Date currentSysDate = cllease.SystemDateUtil.getCurrentSystemDate();
        cllease__Payment_Mode__c paymentMode    = [SELECT Id, Name FROM cllease__Payment_Mode__c WHERE Name = 'Invoice Credit' LIMIT 1];
        clcommon__Payment_Mode__c autoPmtACHMode    = [SELECT Id, Name FROM clcommon__Payment_Mode__c WHERE Name = 'Auto ACH' LIMIT 1];
        
        // 1. Creating Invoice Creedit 
        cllease__Invoice_Credit__c invCrdTmp = new cllease__Invoice_Credit__c();
        invCrdTmp.cllease__Status__c                    = 'UNAPPLIED';
        invCrdTmp.cllease__Original_Credit_Amount__c    = dueAmount;
        invCrdTmp.cllease__Credit_Balance__c            = dueAmount;
        invCrdTmp.cllease__Account__c                   = LesseeAccId;
        invCrdTmp.cllease__Contract__c                  = contractId;
        insert invCrdTmp;
        
        // 2.a Creation of cash receipt
        clcommon__Cash_Receipt__c cashReceipt = new clcommon__Cash_Receipt__c();
        cashReceipt.clcommon__Account__c        = LesseeAccId;
        cashReceipt.clcommon__Payment_Mode__c   = autoPmtACHMode.Id;
        cashReceipt.clcommon__Receipt_Date__c   = currentSysDate;
        cashReceipt.clcommon__Receipt_Amount__c = dueAmount;
        cashReceipt.clcommon__Creation_Date__c  = currentSysDate;
        cashReceipt.clcommon__Unused_Amount__c  = dueAmount;
        cashReceipt.clcommon__Receipt_Status__c = 'CREATED';
        insert cashReceipt;
        
        // 2.b Creating Cash Transaction
        clcommon__Cash_Receipt_Transaction__c accountingTxn = new clcommon__Cash_Receipt_Transaction__c();
        accountingTxn.clcommon__Cash_Receipt__c         = cashReceipt.Id;
        accountingTxn.clcommon__Transaction_Amount__c   = cashReceipt.clcommon__Receipt_Amount__c;
        accountingTxn.clcommon__Transaction_Date__c     = cashReceipt.clcommon__Creation_Date__c;
        accountingTxn.clcommon__New_Receipt_Date__c     = cashReceipt.clcommon__Receipt_Date__c;
        accountingTxn.clcommon__New_Account__c          = cashReceipt.clcommon__Account__c;
        accountingTxn.clcommon__Transaction_Sub_Type__c = 'CREATED_WITH_BORROWER';
        insert accountingTxn;
        
        // 2.c Creating Cash Application
        clcommon__Cash_Receipt_Application__c cashApplication = new clcommon__Cash_Receipt_Application__c();
        cashApplication.clcommon__Cash_Receipt__c       = cashReceipt.Id;
        cashApplication.clcommon__Creation_Date__c      = cashReceipt.clcommon__Creation_Date__c;
        cashApplication.clcommon__Allocated_Amount__c   = cashReceipt.clcommon__Receipt_Amount__c;
        cashApplication.clcommon__Receipt_Application_Status__c   = 'CREATED';
        cashApplication.clcommon__Unused_Amount__c      = cashReceipt.clcommon__Receipt_Amount__c;
        insert cashApplication;
        
        // 3. Creating Payment Transaction
        cllease__Lease_Payment_Transaction__c pmtTxn = new cllease__Lease_Payment_Transaction__c();
        pmtTxn.cllease__Contract__c             = contractId;                    
        pmtTxn.cllease__Bills__c                = billNumber;
        pmtTxn.cllease__Transaction_Amount__c   = dueAmount;
        pmtTxn.cllease__Payment_Mode__c         = paymentMode.Id;
        pmtTxn.cllease__Transaction_Date__c     = currentSysDate;
        pmtTxn.cllease__Receipt_Date__c         = currentSysDate;
        pmtTxn.cllease__Remarks__c              = 'Payment Created from Invoice Credit from AutoTradeup Process...';
        pmtTxn.cllease__Cash_Application__c 	= cashApplication.Id; // new item to add. 
        insert pmtTxn;
        
    }
    
    public static void applyPayment(String pmtNumber) {
        Date currentSysDate = cllease.SystemDateUtil.getCurrentSystemDate();
        clcommon__Payment_Mode__c onAccountpmtMode 	= [SELECT Id, Name FROM clcommon__Payment_Mode__c WHERE Name = 'ON ACCOUNT' LIMIT 1];
		
        
        // 4. Applying payment 
        Set<String> pmtNumbers = new Set<String>{pmtNumber};
            
            List<cllease__Lease_Payment_Transaction__c> paymentTransactionList = 
            [SELECT id, name,
             cllease__Contract__c,
             cllease__Contract__r.Id,
             cllease__Contract__r.Name,
             cllease__Contract__r.cllease__Lease_Status__c,
             cllease__Contract__r.cllease__Lease_Product_Name__c,
             cllease__Contract__r.cllease__Lease_Product_Name__r.cllease__Lease_Product_Type__c,
             cllease__Contract__r.cllease__Payment_Frequency__c,
             cllease__Contract__r.cllease__current_payment_amount__c,
             cllease__Contract__r.cllease__Next_Due_Date__c ,
             cllease__Contract__r.cllease__Term__c,
             cllease__Contract__r.cllease__Payment_Spread__c,
             cllease__Contract__r.cllease__Termination_Quote_accepted_flag__c,
             cllease__Lease_Snapshot__c,
             cllease__Fee_Snapshot__c,
             cllease__Dues_Snapshot__c,
             cllease__Cash_Balances_Snapshot__c,
             cllease__Balance_s_Snapshot__c,
             cllease__Custom_Logic__c,
             cllease__Receipt_Id__c,
             cllease__Transaction_Date__c,
             cllease__Transaction_Time__c,
             cllease__Early_Total_Repayment_of_the_Lease__c,
             cllease__Write_Off_Recovery_Payment__c,
             cllease__Payment_Mode__c,
             cllease__Payment_Mode__r.Name,
             cllease__Transaction_Amount__c,
             cllease__Cleared__c,
             cllease__Manual_Payment__c,
             cllease__Fees__c,
             cllease__Receivable_Billed__c,
             cllease__Evergreen_Receivable_Billed__c,
             cllease__Tax_Billed__c,
             cllease__Excess__c,
             cllease__Total_Charges_Principal__c,
             cllease__Other_Charges_Principal__c,
             cllease__Late_Charge_Principal__c,
             cllease__Charge__c,
             cllease__Bill__c,
             cllease__Cash_Application__c 
             FROM cllease__Lease_Payment_Transaction__c
             WHERE Name IN :pmtNumbers
             order by cllease__Transaction_Date__c]; 
        
        // 3. Calling CL Lease Global API to Apply Payments
        Savepoint sp = database.setsavepoint();
        try{
            cllease.BulkLeasePaymentAction dAction = new cllease.BulkLeasePaymentAction(paymentTransactionList);
            dAction.postPayments();
        } catch(Exception e){
            database.rollback(sp);   
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());
        }
        
        // 4. After payment processing we need to move the applied amount to zero in the cash recipt as we are moving the over applied amount to onAccount
        Set<Id> craIds = new Set<Id>();
        Set<Id> crIds = new Set<Id>();
        
        for(cllease__Lease_Payment_Transaction__c lpt : paymentTransactionList){
            craIds.add(lpt.cllease__Cash_Application__c);
        }
        
        Map<Id, clcommon__Cash_Receipt_Application__c> crApplications = new Map<Id, clcommon__Cash_Receipt_Application__c>([SELECT ID, 
                                                                                                                            clcommon__Cash_Receipt__c,
                                                                                                                            clcommon__Allocated_Amount__c,
                                                                                                                            clcommon__Unused_Amount__c,
                                                                                                                            clcommon__Receipt_Application_Status__c 
                                                                                                                            FROM clcommon__Cash_Receipt_Application__c
                                                                                                                            WHERE Id IN : craIds
                                                                                                                            AND clcommon__Unused_Amount__c > 0]);
        System.debug(LoggingLevel.ERROR, '^^^^ crApplications : ' + crApplications);
        
        if(crApplications.keySet().size() > 0){
            for(clcommon__Cash_Receipt_Application__c cra : crApplications.values()){
                crIds.add(cra.clcommon__Cash_Receipt__c);
            }
            
            Map<Id, clcommon__Cash_Receipt__c> crMap = new Map<Id, clcommon__Cash_Receipt__c>([SELECT ID,
                                                                                               clcommon__Account__c,
                                                                                               clcommon__Receipt_Date__c,
                                                                                               clcommon__Unused_Amount__c
                                                                                               FROM clcommon__Cash_Receipt__c
                                                                                               WHERE Id IN : crIds]);
            List<clcommon__Cash_Receipt_Application__c> craToUpdate = new List<clcommon__Cash_Receipt_Application__c>();
            List<clcommon__Cash_Receipt__c> crToUpdate = new List<clcommon__Cash_Receipt__c>();
            List<clcommon__Cash_Receipt__c> newCr = new List<clcommon__Cash_Receipt__c>();
            for(cllease__Lease_Payment_Transaction__c lpt : paymentTransactionList){
                if(crApplications.containsKey(lpt.cllease__Cash_Application__c)){
                    clcommon__Cash_Receipt_Application__c crApplication = crApplications.get(lpt.cllease__Cash_Application__c);
                    System.debug(LoggingLevel.ERROR, '^^^^ crApplication : ' + crApplication);
                    if(crApplication.clcommon__Unused_Amount__c != null && crApplication.clcommon__Unused_Amount__c > 0){
                        clcommon__Cash_Receipt__c cr = crMap.get(crApplication.clcommon__Cash_Receipt__c);
                        if(cr.clcommon__Unused_Amount__c == crApplication.clcommon__Unused_Amount__c){
                            clcommon__Cash_Receipt__c chReceipt = new clcommon__Cash_Receipt__c();
                            chReceipt.clcommon__Account__c = cr.clcommon__Account__c;
                            chReceipt.clcommon__Payment_Mode__c = onAccountpmtMode.Id;
                            chReceipt.clcommon__Receipt_Date__c = lpt.cllease__Transaction_Date__c;
                            chReceipt.clcommon__Receipt_Amount__c = cr.clcommon__Unused_Amount__c;
                            chReceipt.clcommon__Creation_Date__c  = lpt.cllease__Transaction_Date__c;
                            chReceipt.clcommon__Unused_Amount__c =  cr.clcommon__Unused_Amount__c;
                            chReceipt.clcommon__Receipt_Status__c = 'CREATED';
                            chReceipt.Payment_Transaction__c = lpt.Id;
                            newCr.add(chReceipt);
                            cr.clcommon__Unused_Amount__c = 0;
                            cr.clcommon__Receipt_Status__c = 'APPLIED';
                            crToUpdate.add(cr);
                        }
                        crApplication.clcommon__Unused_Amount__c = 0;
                        craToUpdate.add(crApplication);
                    }
                }
            }
            // Committing all records
            if(craToUpdate.size()>0)
                Update craToUpdate;
            if(crToUpdate.size()>0)
                Update crToUpdate;
            if(newCr.size()>0)
                Insert newCr;
        }
    }
}