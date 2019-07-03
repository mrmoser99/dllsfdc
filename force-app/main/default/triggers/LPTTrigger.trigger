//Creating Invoice credit by the excess amount on LPT and making LPT's and contract's Excess to 0.
trigger LPTTrigger on cllease__Lease_Payment_Transaction__c (before update) {

    if(trigger.isBefore && trigger.isUpdate){
        List<cllease__Invoice_Credit__c> invoiceCredits = new List<cllease__Invoice_Credit__c>();
        List<cllease__lease_Account__c> contracts = new List<cllease__lease_Account__c>();
       
        Set<Id> contractIds = new Set<Id>();
        for(cllease__Lease_Payment_Transaction__c lpt : trigger.New){
            contractIds.add(lpt.cllease__Contract__c);
        }
        
        Map<Id,cllease__Lease_Account__c> contractsMap = new Map<Id,cllease__Lease_Account__c>([Select Id,
                                                                                                    Cllease__Excess__c 
                                                                                             from cllease__Lease_Account__c 
                                                                                             where id IN :contractIds]);
        for(cllease__Lease_Payment_Transaction__c lpt : trigger.New){
            
            if(lpt.cllease__Cleared__c && lpt.Cllease__Excess__c > 0){
                cllease__Lease_Account__c contract = contractsMap.get(lpt.cllease__Contract__c);
                contract.Cllease__Excess__c -= lpt.Cllease__Excess__c;
                contracts.add(contract);
                
                cllease__Invoice_Credit__c invoiceCredit = new cllease__Invoice_Credit__c();
                invoiceCredit.cllease__Contract__c = lpt.cllease__Contract__c;
                invoiceCredit.Payment_Transaction__c = lpt.Id;
                invoiceCredit.cllease__Original_Credit_Amount__c = lpt.Cllease__Excess__c;
                invoiceCredit.cllease__Credit_Balance__c = lpt.Cllease__Excess__c;
                invoiceCredit.cllease__Status__c = 'Unapplied';
                invoiceCredits.add(invoiceCredit);
                
                lpt.cllease__Excess__c = 0;
            }
        }
        insert invoiceCredits;
        update contracts;
        
       
    }
}