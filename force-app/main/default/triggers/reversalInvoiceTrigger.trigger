/**
 * Owner: CLS-Q2
 * Date : 09/24/2019
 * Description: Moving the money back to cash receipt in case of ReApplication and cancelling the cash receipt in case of NSF
 **/
trigger reversalInvoiceTrigger on cllease__Repayment_Transaction_Adjustment__c (before update) {
    if (trigger.isBefore && trigger.isUpdate) {
        List<cllease__Repayment_Transaction_Adjustment__c> txnSentForReversal = new List<cllease__Repayment_Transaction_Adjustment__c>();
        for(cllease__Repayment_Transaction_Adjustment__c reversalTxn : trigger.new){
            if(!reversalTxn.cllease__Cleared__c || reversalTxn.cllease__Reason_Code__c == 'NSF')
                txnSentForReversal.add(reversalTxn);
        }
        if(txnSentForReversal.size() > 0){
            reversalHandler handler = new reversalHandler(trigger.new);
            handler.process();
        }
    }
}