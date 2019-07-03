/**
 * Owner: CLS-Q2
 * Description: Following trigger will block reversal of LPT if there are any invoice created and fully/partially applied
 **/
trigger reversalInvoiceTrigger on cllease__Repayment_Transaction_Adjustment__c (before insert, before update) {

    public Set<Id> reversalIds = new Set<Id>();
    public Map<Id, List<Cllease__Invoice_Credit__c>> lptToInvoiceCreditMap = new Map<Id, List<Cllease__Invoice_Credit__c>>();
    
    public class TransactionException extends Exception{}
    
    System.debug(Logginglevel.ERROR, '^^^ Inside Trigger');
    
    if (trigger.isBefore) {
        System.debug(Logginglevel.ERROR, '^^^ Inside Trigger isBefore');
        
        if (trigger.isInsert || trigger.isUpdate) {
            System.debug(Logginglevel.ERROR, '^^^ Inside Trigger isInsert');
            // Collect all the ids of reversal which are flowing through trigger
            for(cllease__Repayment_Transaction_Adjustment__c reversal : trigger.new){
                reversalIds.add(reversal.cllease__Lease_Payment_Transaction__c);
            }
            
            // Query Invoice credit where status != unapplied and payment id in invoice is equal to reversal lpt id.
            List<cllease__Invoice_Credit__c> invoiceList = [SELECT Id,
                                                            Name,
                                                            cllease__Account__c,
                                                            cllease__Comments__c,
                                                            cllease__Original_Credit_Amount__c,
                                                            cllease__Credit_Balance__c,
                                                            cllease__Contract__c,
                                                            Payment_Transaction__c,
                                                            cllease__Status__c
                                                            FROM cllease__Invoice_Credit__c
                                                            WHERE cllease__Status__c != 'Unapplied'
                                                            AND Payment_Transaction__c IN : reversalIds];
            
            System.debug(LoggingLevel.ERROR, '^^^^ invoiceList : ' + invoiceList);
            
            for(cllease__Invoice_Credit__c invoice : invoiceList){
                List<Cllease__Invoice_Credit__c> invoices = new List<Cllease__Invoice_Credit__c>();
                if(lptToInvoiceCreditMap.containsKey(invoice.Payment_Transaction__c)){
                    invoices = lptToInvoiceCreditMap.get(invoice.Payment_Transaction__c);
                    invoices.add(invoice);
                } else{
                    invoices.add(invoice);
                }
                lptToInvoiceCreditMap.put(invoice.Payment_Transaction__c, invoiceList);
            }
            
            for(cllease__Repayment_Transaction_Adjustment__c reversal : trigger.new){
                if(lptToInvoiceCreditMap.containsKey(reversal.cllease__Lease_Payment_Transaction__c)){
                    cllease__Invoice_Credit__c invoiceId = lptToInvoiceCreditMap.get(reversal.cllease__Lease_Payment_Transaction__c)[0];
                    reversal.addError('Invoice Id : ' + invoiceId.id + ' : Name : ' + invoiceId.Name + ' has to be reversed first.');
                    //throw new TransactionException('Invoice Id : ' + invoiceId.id + ' : Name : ' + invoiceId.Name + ' has to be reversed first.');
                }
            }
            
        }
        
        //Code for Invoice Credit Cancellation on LPT Reversal
        if(trigger.IsBefore && Trigger.isUpdate){
            Set<Id> reversedPaymentIds = new Set<Id>();
            for(cllease__Repayment_Transaction_Adjustment__c reversalPayment : Trigger.New){ 
                
                if(reversalPayment.cllease__cleared__c && reversalPayment.cllease__Reason_Code__c != 'ReApply'){
                    reversedPaymentIds.add(reversalPayment.cllease__Lease_Payment_Transaction__c);
                }
            }
            System.debug(LoggingLevel.ERROR, 'reversedPaymentIds == '+reversedPaymentIds);
            List<cllease__Invoice_Credit__c> invoiceCredits = [SELECT Id from cllease__Invoice_Credit__c where Payment_Transaction__c = :reversedPaymentIds];
            System.debug(LoggingLevel.ERROR, 'invoiceCredits == '+invoiceCredits);
            if(invoiceCredits != null && !invoiceCredits.isEmpty()){
                for(cllease__Invoice_Credit__c invoiceCredit : invoiceCredits){
                    invoiceCredit.cllease__Status__c = 'Cancelled';
                }
            }
            update invoiceCredits;
        }
        
        
    }
}