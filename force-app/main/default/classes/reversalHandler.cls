/**
 * Owner: CLS-Q2
 * Date : 09/24/2019
 * Description: Moving the money back to cash receipt in case of ReApplication and cancelling the cash receipt in case of NSF
 **/
public class reversalHandler {
    public class TransactionException extends Exception{}
    
    private List<cllease__Repayment_Transaction_Adjustment__c> reversalTxns = new List<cllease__Repayment_Transaction_Adjustment__c>();
    private Map<Id, cllease__Lease_Payment_Transaction__c> pmtList;
    
    public reversalHandler(List<cllease__Repayment_Transaction_Adjustment__c> reversalTxns){
        this.reversalTxns = reversalTxns;
    }
    
    public void process(){
        List<cllease__Lease_Payment_Transaction__c> pmtList = new List<cllease__Lease_Payment_Transaction__c>();
        List<clcommon__Cash_Receipt_Application__c> crApplicationList = new List<clcommon__Cash_Receipt_Application__c>();
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
        
        crApplicationList = [SELECT Id,
                             	clcommon__Cash_Receipt__c,
                            	clcommon__Allocated_Amount__c,
                            	clcommon__Unused_Amount__c,
                            	clcommon__Receipt_Application_Status__c
                            FROM clcommon__Cash_Receipt_Application__c
                            WHERE Id IN : craIds];
        for(clcommon__Cash_Receipt_Application__c cra : crApplicationList){
            cra.clcommon__Receipt_Application_Status__c = 'REVERSED';
        }
        
        // Updating the cash receipt application to status REVERSED
        update crApplicationList;
        
        updateCashReceipt(pmtToCashReceipt);
    }
    
    public void updateCashReceipt(Map<Id, Id> pmtToCashReceipt){
        // Loop through all the reversal and cancel the cash receipt if it is NSF
        // Also create cancel transaction for cash receipt for accouting reversal
        // Put the money in cash receipt but don't create and make it unapplied
        // Do not create reversal accounting
		List<clcommon__Cash_Receipt__c> crToBeUpdated = new List<clcommon__Cash_Receipt__c>();
        List<clcommon__Cash_Receipt_Transaction__c> crTxns = new List<clcommon__Cash_Receipt_Transaction__c>();
        //query Payments to identify the exact amount applied amount without excess
        pmtList = new Map<Id, cllease__Lease_Payment_Transaction__c>(
            			[SELECT ID, 
                         		cllease__Contract__r.cllease__Account__c,
                                cllease__Transaction_Amount__c,
                                Invoice_Credit_Amount__c
                        	FROM cllease__Lease_Payment_Transaction__c
                        	WHERE Id IN : pmtToCashReceipt.keySet()]);
        
        //query cash receipt to make necessary changes
        Map<Id, clcommon__Cash_Receipt__c> crList = new Map<Id, clcommon__Cash_Receipt__c> ([SELECT ID,
                                                                                             	clcommon__Receipt_Amount__c,
                                                                                                clcommon__Unused_Amount__c,
                                                                                                clcommon__Receipt_Status__c
                                                                                              FROM clcommon__Cash_Receipt__c
                                                                                              WHERE Id IN : pmtToCashReceipt.values()]);
        for(cllease__Repayment_Transaction_Adjustment__c txn : reversalTxns){
            cllease__Lease_Payment_Transaction__c pmt = pmtList.get(txn.cllease__Lease_Payment_Transaction__c);
            Decimal pmtAmount = pmt.cllease__Transaction_Amount__c - pmt.Invoice_Credit_Amount__c;
            Id crId = pmtToCashReceipt.get(txn.cllease__Lease_Payment_Transaction__c);
            clcommon__Cash_Receipt__c cr = crList.get(crId);
            if(txn.cllease__Reason_Code__c == 'NSF'){
                cr.clcommon__Unused_Amount__c += pmtAmount;
                if(cr.clcommon__Unused_Amount__c == cr.clcommon__Receipt_Amount__c)
                	cr.clcommon__Receipt_Status__c = 'CANCELLED';
                else
                    cr.clcommon__Receipt_Status__c = 'PARTIALLY_APPLIED';
                // Create accounting only if it is cancelled
                if(cr.clcommon__Receipt_Status__c == 'CANCELLED'){
                    clcommon__Cash_Receipt_Transaction__c crTxn = new clcommon__Cash_Receipt_Transaction__c();
                    crTxn.clcommon__Cash_Receipt__c = crId;
                    crTxn.clcommon__SS_Receipt_Amount__c = cr.clcommon__Receipt_Amount__c;
                    crTxn.clcommon__Transaction_Amount__c = cr.clcommon__Receipt_Amount__c;
                    crTxn.clcommon__Transaction_Sub_Type__c = 'CANCELLED_WITH_BORROWER';
                    crTxn.clcommon__New_Account__c = pmt.cllease__Contract__r.cllease__Account__c;
                    crTxns.add(crTxn);
                    crToBeUpdated.add(cr);
                }
            } else if(txn.cllease__Reason_Code__c == 'Re_Apply'){
                cr.clcommon__Unused_Amount__c += pmtAmount;
                if(cr.clcommon__Unused_Amount__c == cr.clcommon__Receipt_Amount__c)
                    cr.clcommon__Receipt_Status__c = 'CREATED';
                else
                    cr.clcommon__Receipt_Status__c = 'PARTIALLY_APPLIED';
            }
        }
        // Updating the CR
        update crToBeUpdated;
        // Inserting the cancel cr txn
        if(crTxns.size() > 0)
            insert crTxns;
    }

}