/**
 * Owner: CLS-Q2
 * Date : 09/24/2019
 * Description: Moving the money back to cash receipt in case of ReApplication and cancelling the cash receipt in case of NSF
 **/
public class reversalHandler {
    public class TransactionException extends Exception{}
    
    private List<cllease__Repayment_Transaction_Adjustment__c> reversalTxns = new List<cllease__Repayment_Transaction_Adjustment__c>();
    private Map<Id, cllease__Lease_Payment_Transaction__c> pmtList;
    Map<Id, clcommon__Cash_Receipt_Application__c> crApplicationList;
    
    public reversalHandler(List<cllease__Repayment_Transaction_Adjustment__c> reversalTxns){
        this.reversalTxns = reversalTxns;
    }
    
    public List<cllease__GL_Transaction_Detail__c> reverseGlAndCreateOnAccount(List<cllease__Repayment_Transaction_Adjustment__c> txns){
        Map<Id, Id> pmtTxnId = new Map<Id, Id>();
        Map<Id, Id> lpdToLpt = new Map<Id, Id>();
        List<cllease__GL_Transaction_Detail__c> gls;
        List<cllease__GL_Transaction_Detail__c> glReversal = new List<cllease__GL_Transaction_Detail__c>();
        List<cllease__Lease_Payment_Detail__c> lpds;
        
        for(cllease__Repayment_Transaction_Adjustment__c txn : txns)
            pmtTxnId.put(txn.cllease__Lease_Payment_Transaction__c, txn.Id);
        
        System.debug(LoggingLevel.ERROR, '^^^ pmtTxnId : ' + pmtTxnId);
        
        lpds = [SELECT ID,
                        cllease__Payment_Transaction__c
                    FROM cllease__Lease_Payment_Detail__c
                    WHERE cllease__Payment_Transaction__c IN : pmtTxnId.keySet()
                    AND cllease__Transaction_Sub_Type__r.Name != 'ON ACCOUNT'];
        
        for(cllease__Lease_Payment_Detail__c lpd : lpds)
            lpdToLpt.put(lpd.Id, lpd.cllease__Payment_Transaction__c);
        
        System.debug(LoggingLevel.ERROR, '^^^ lpdToLpt : ' + lpdToLpt);
        
        // Retrive On Account id
        List<cllease__GL_Account__c> onAccountId = [SELECT Id FROM cllease__GL_Account__c WHERE NAME = 'On Account' LIMIT 1];
        gls = [SELECT ID, 
                      cllease__Transaction_Type__c,
                      cllease__Company__c,
                      cllease__Contract__c,
                      cllease__Credit_Amount__c,
                      cllease__Credit_GL_Account__c,
                      cllease__Debit_Amount__c,
                      cllease__Debit_GL_Account__c,
                      cllease__Generation_Scheme__c,
                      cllease__Payment_Transaction_Reversal__c,
                      cllease__Lease_Payment_Detail__c,
                      cllease__Transaction_Description__c,
                      cllease__Reversal_Processed__c
                  FROM cllease__GL_Transaction_Detail__c
                  WHERE cllease__Lease_Payment_Detail__c IN : lpdToLpt.keySet()];
        for(cllease__GL_Transaction_Detail__c gl : gls){
            cllease__GL_Transaction_Detail__c new_txn = new cllease__GL_Transaction_Detail__c();
            new_txn = gl.clone();
            new_txn.cllease__Debit_GL_Account__c = gl.cllease__Credit_GL_Account__c;
            new_txn.cllease__Credit_GL_Account__c = onAccountId[0].Id;
            new_txn.cllease__GL_Date__c = cllease.SystemDateUtil.getCurrentSystemDate();
            new_txn.cllease__Generation_Scheme__c = 'REVERSAL';
            new_txn.cllease__Payment_Transaction_Reversal__c = pmtTxnId.get(lpdToLpt.get(gl.cllease__Lease_Payment_Detail__c));
            new_txn.cllease__Lease_Payment_Detail__c = null;
            glReversal.add(new_txn);           
        }
        return glReversal;
    }
    
    public void process(){
        List<cllease__Lease_Payment_Transaction__c> pmtList = new List<cllease__Lease_Payment_Transaction__c>();
        Set<Id> pmtIds = new Set<Id>();
        Set<Id> craIds = new Set<Id>();
        Set<Id> crIds = new Set<Id>();
        Map<Id, Id> pmtToCashReceipt = new Map<Id, Id>();
        
        // Get all the lpt ids from reversal transactions
        for(cllease__Repayment_Transaction_Adjustment__c reversal : reversalTxns){
            pmtIds.add(reversal.cllease__Lease_Payment_Transaction__c);
        }
        
        // query all payments which are part of reversals
        pmtList = [SELECT Id,
                        cllease__Contract__r.cllease__Account__c,
                        cllease__Cash_Application__c,
                        cllease__Cash_Application__r.clcommon__Cash_Receipt__c
                    FROM cllease__Lease_Payment_Transaction__c
                    WHERE Id IN : pmtIds];
        
        for(cllease__Lease_Payment_Transaction__c pmt : pmtList){
            if(pmt.cllease__Cash_Application__c != null)
                craIds.add(pmt.cllease__Cash_Application__c);
            if(pmt.cllease__Cash_Application__r.clcommon__Cash_Receipt__c != null)
                crIds.add(pmt.cllease__Cash_Application__r.clcommon__Cash_Receipt__c);
            pmtToCashReceipt.put(pmt.Id, pmt.cllease__Cash_Application__r.clcommon__Cash_Receipt__c);
        }
        
        // Query cash receipt application record to put the status back to reversed.
        
        crApplicationList = new Map<Id, clcommon__Cash_Receipt_Application__c>([SELECT Id,
                                                                                    clcommon__Cash_Receipt__c,
                                                                                    clcommon__Allocated_Amount__c,
                                                                                    clcommon__Unused_Amount__c,
                                                                                    clcommon__Receipt_Application_Status__c
                                                                                FROM clcommon__Cash_Receipt_Application__c
                                                                                WHERE Id IN : craIds]);
        updateCashReceipt(pmtToCashReceipt);
    }
    
    public void updateCashReceipt(Map<Id, Id> pmtToCashReceipt){
        // Loop through all the reversal and cancel the cash receipt if it is NSF
        // Also create cancel transaction for cash receipt for accouting reversal
        // Put the money in cash receipt but don't create and make it unapplied
        // Do not create reversal accounting
        List<clcommon__Cash_Receipt__c> crToBeUpdated = new List<clcommon__Cash_Receipt__c>();
        List<clcommon__Cash_Receipt_Transaction__c> crTxns = new List<clcommon__Cash_Receipt_Transaction__c>();
        List<clcommon__Cash_Receipt__c> newCR = new List<clcommon__Cash_Receipt__c>();
        List<cllease__GL_Transaction_Detail__c> reversedGL = new List<cllease__GL_Transaction_Detail__c>();
        List<cllease__Repayment_Transaction_Adjustment__c> reApplyTxn = new List<cllease__Repayment_Transaction_Adjustment__c>();
        List<clcommon__Cash_Receipt_Application__c> craToUpdate = new List<clcommon__Cash_Receipt_Application__c>();
        List<clcommon__Payment_Mode__c > commonPaymentModes = [SELECT Id, Name 
                                                            FROM clcommon__Payment_Mode__c 
                                                            WHERE Name = 'ON ACCOUNT' LIMIT 1];
        //query Payments to identify the exact amount applied amount without excess
        pmtList = new Map<Id, cllease__Lease_Payment_Transaction__c>(
                        [SELECT ID, 
                                cllease__Contract__r.cllease__Account__c,
                                cllease__Transaction_Amount__c,
                                cllease__Cash_Application__c,
                                cllease__Cash_Application__r.Name,
                                cllease__Cash_Application__r.clcommon__Allocated_Amount__c,
                                Invoice_Credit_Amount__c
                            FROM cllease__Lease_Payment_Transaction__c
                            WHERE Id IN : pmtToCashReceipt.keySet()]);
        
        //query cash receipt to make necessary changes
        Map<Id, clcommon__Cash_Receipt__c> crList = new Map<Id, clcommon__Cash_Receipt__c> ([SELECT ID,
                                                                                                Name,
                                                                                                clcommon__Account__c,
                                                                                                clcommon__Receipt_Amount__c,
                                                                                                clcommon__Unused_Amount__c,
                                                                                                clcommon__Receipt_Status__c
                                                                                              FROM clcommon__Cash_Receipt__c
                                                                                              WHERE Id IN : pmtToCashReceipt.values()]);
        
        // Query cash receipt created because of On Account(Excess)
        List<clcommon__Cash_Receipt__c> onAccountCRList = [SELECT ID,
                                                                   Name,
                                                                   clcommon__Receipt_Amount__c,
                                                                   clcommon__Unused_Amount__c,
                                                                   clcommon__Receipt_Status__c,
                                                                   Payment_Transaction__c
                                                               FROM clcommon__Cash_Receipt__c
                                                               WHERE Payment_Transaction__c IN : pmtToCashReceipt.keySet()
                                                               AND clcommon__Payment_Mode__r.Name = 'ON ACCOUNT'];
        Map<Id, clcommon__Cash_Receipt__c> pmtToOnAccCr = new Map<Id, clcommon__Cash_Receipt__c>();
        
        for(clcommon__Cash_Receipt__c onAccCr : onAccountCRList){
            pmtToOnAccCr.put(onAccCr.Payment_Transaction__c, onAccCr);
        }
        
        for(cllease__Repayment_Transaction_Adjustment__c txn : reversalTxns){
            cllease__Lease_Payment_Transaction__c pmt = pmtList.get(txn.cllease__Lease_Payment_Transaction__c);
            clcommon__Cash_Receipt_Application__c cra = new clcommon__Cash_Receipt_Application__c();
            Decimal pmtAmount = pmt.cllease__Transaction_Amount__c - pmt.Invoice_Credit_Amount__c;
            Id crId = pmtToCashReceipt.get(txn.cllease__Lease_Payment_Transaction__c);
            if(txn.cllease__Reason_Code__c != null && pmt.cllease__Cash_Application__r.clcommon__Allocated_Amount__c != pmt.cllease__Transaction_Amount__c){
                String revException = 'Cash Receipt Application ID : ' + pmt.cllease__Cash_Application__c + ' : NAME : ' + pmt.cllease__Cash_Application__r.Name;
                revException += 'has satisfied more than one payment';
                revException += ', so it cannot be reversed through Cash receipt. Please Go TO -> Cash Receipt Tab And Select Cash Receipt : ' + crId;
                revException += ' -> Reverse Cash Receipt Application.';
                throw new TransactionException(revException);
            }
            if(crList.containsKey(crId)){
                clcommon__Cash_Receipt__c cr = crList.get(crId);
                Id craId = pmtList.get(txn.cllease__Lease_Payment_Transaction__c).cllease__Cash_Application__c;
                System.debug(LoggingLevel.ERROR, '^^^ cr : ' + cr);
                if(txn.cllease__Reason_Code__c == 'NSF'){
                    cr.clcommon__Receipt_Status__c = 'CANCELLED';
                    if(pmtToOnAccCr.containsKey(txn.cllease__Lease_Payment_Transaction__c)){
                        clcommon__Cash_Receipt__c onAccCr = pmtToOnAccCr.get(txn.cllease__Lease_Payment_Transaction__c);
                        if(onAccCr.clcommon__Receipt_Amount__c == onAccCr.clcommon__Unused_Amount__c){
                            onAccCr.clcommon__Receipt_Status__c = 'CANCELLED';
                            crToBeUpdated.add(onAccCr);
                        }
                        else{
                            String revException = 'On Account cash receipt ID : ' + onAccCr.Id + ' : NAME : ' + onAccCr.Name;
                            revException += ' with excess amount of LPT : ' + txn.cllease__Lease_Payment_Transaction__c;
                            revException += 'is partially or fully applied';
                            revException += ', so it cannot be reversed through LPT. Please Go TO -> Cash Receipt Tab And Select Cash Receipt : ' + onAccCr.Name;
                            revException += ' -> Cancel Cash Receipt';
                            throw new TransactionException(revException);
                        }
                    }
                    // Create accounting only if it is cancelled
                    /*if(cr.clcommon__Receipt_Status__c == 'CANCELLED'){
                        clcommon__Cash_Receipt_Transaction__c crTxn = new clcommon__Cash_Receipt_Transaction__c();
                        crTxn.clcommon__Cash_Receipt__c = crId;
                        crTxn.clcommon__SS_Receipt_Amount__c = cr.clcommon__Receipt_Amount__c;
                        crTxn.clcommon__Transaction_Amount__c = cr.clcommon__Receipt_Amount__c;
                        crTxn.clcommon__Transaction_Sub_Type__c = 'CANCELLED_WITH_BORROWER';
                        crTxn.clcommon__New_Account__c = pmt.cllease__Contract__r.cllease__Account__c;
                        crTxns.add(crTxn);
                    }*/
                    System.debug(LoggingLevel.ERROR, '^^^ crToBeUpdated : ' + crToBeUpdated);
                } else if(txn.cllease__Reason_Code__c == 'ReApply'){
                    if(pmt.cllease__Cash_Application__c != null){
                        if(pmt.cllease__Cash_Application__r.clcommon__Allocated_Amount__c != pmt.cllease__Transaction_Amount__c){
                            String revException = 'There are more than one LPT applied through this cash receipt application Id : ';
                            revException += pmt.cllease__Cash_Application__c + ' : NAME : ' + pmt.cllease__Cash_Application__r.Name;
                            revException += ', so it cannot be reversed through LPT. Please Go TO -> Cash Receipt Application Tab And Select Cash Receipt Application : ' + pmt.cllease__Cash_Application__r.Name;
                            revException += ' -> Reverse Cash Receipt Application';
                            throw new TransactionException(revException);
                        }else{
                            clcommon__Cash_Receipt__c cashReceipt = new clcommon__Cash_Receipt__c();
                            cashReceipt.clcommon__Account__c = cr.clcommon__Account__c;
                            cashReceipt.clcommon__Payment_Mode__c = commonPaymentModes[0].Id;
                            cashReceipt.clcommon__Receipt_Date__c = txn.cllease__Adjustment_Txn_Date__c;
                            cashReceipt.clcommon__Receipt_Amount__c = pmtAmount;
                            cashReceipt.clcommon__Creation_Date__c  = txn.cllease__Adjustment_Txn_Date__c;
                            cashReceipt.clcommon__Unused_Amount__c =  pmtAmount;
                            cashReceipt.clcommon__Receipt_Status__c = 'CREATED';
                            cashReceipt.Payment_Transaction__c = txn.cllease__Lease_Payment_Transaction__c;
                            newCR.add(cashReceipt);
                            reApplyTxn.add(txn);
                        }
                    }
                }
                cra = crApplicationList.get(craId);
                cra.clcommon__Receipt_Application_Status__c = 'REVERSED';
                craToUpdate.add(cra);
                crToBeUpdated.add(cr);
                System.debug(LoggingLevel.ERROR, '^^^ crToBeUpdated : ' + crToBeUpdated);
                System.debug(LoggingLevel.ERROR, '^^^ newCR : ' + newCR);
                System.debug(LoggingLevel.ERROR, '^^^ craToUpdate : ' + craToUpdate);
                //throw new TransactionException('TEST');
            }
        }
        // Perofrming reversal for all reApply transaction
        if(reApplyTxn.size() > 0)
            reversedGL.addAll(reverseGlAndCreateOnAccount(reApplyTxn));
        System.debug(LoggingLevel.ERROR, '^^^ reversedGL : ' + reversedGL);
        //throw new TransactionException('TEST');
        // Updating the CR
        update crToBeUpdated;
        update craToUpdate;
        // Inserting the cancel cr txn
        if(crTxns.size() > 0)
            insert crTxns;
        // Inserting new cash receipt
        if(newCR.size() > 0)
            insert newCR;
        // Inserting reversal GLs
        if(reversedGL.size() > 0)
            insert reversedGL;
        //Updating Cash Receipt Application
        for(clcommon__Cash_Receipt_Application__c cra : crApplicationList.values()){
            cra.clcommon__Receipt_Application_Status__c = 'REVERSED';
        }
        
        // Updating the cash receipt application to status REVERSED
        update crApplicationList.values();
    }

}