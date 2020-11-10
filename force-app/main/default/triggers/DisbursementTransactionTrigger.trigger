trigger DisbursementTransactionTrigger on clcommon__Disbursement_Transaction__c (after insert, after update) {
    
   Map<Id, Id> disbursementTransactionMap = new Map<Id, Id>();
   list<clcommon__Disbursement_Transaction__c> disbursementTxnsToUpdate = new list<clcommon__Disbursement_Transaction__c>();
   
   // 1. Looping through Disbursement Transactions and mapping to LS Contracts
   for(clcommon__Disbursement_Transaction__c dt : trigger.new){
        if(dt.cllease__Contract__c != null ){        
            disbursementTransactionMap.put(dt.cllease__Contract__c, dt.id);
            System.debug(LoggingLevel.ERROR, '^^^^ disbursementTransactionMap : ' + disbursementTransactionMap);     
        }
    }
    
    if(disbursementTransactionMap.keyset() != null){

        // 2. Querying Equipments for required details
        Map<Id, cllease__Contract_Equipment__c> equipmentMap = 
            new Map<Id, cllease__Contract_Equipment__c>([SELECT Id
                                                            FROM cllease__Contract_Equipment__c
                                                            WHERE cllease__Contract__c in:disbursementTransactionMap.keyset()]);

         // 3. Querying Disbursement Transactions to update details from Equipment
        Map<Id, clcommon__Disbursement_Transaction__c> disbursementTransactionMap2 = 
            new Map<Id, clcommon__Disbursement_Transaction__c>([SELECT Id, Contract_Equipment__c
                                                            FROM clcommon__Disbursement_Transaction__c 
                                                            WHERE Id in :disbursementTransactionMap.values()]);

        for(ID dt : disbursementTransactionMap.keySet()) {
            // Retrieving Disbursement Trascantion and Equipments
            clcommon__Disbursement_Transaction__c disbursementTransaction = disbursementTransactionMap2.get(dt);
            cllease__Contract_Equipment__c equipment    = equipmentMap.get(disbursementTransactionMap.get(dt));
            // Updating following fields from Equipment to Disbursement Transaction
            disbursementTransaction.Contract_Equipment__c=equipment.Id;
            disbursementTxnsToUpdate.add(disbursementTransaction);
        }
        System.debug(LoggingLevel.ERROR, '^^^^ disbursementTxnsToUpdate : ' + disbursementTxnsToUpdate);
    }
    
    if(disbursementTxnsToUpdate.size()>0) {
        update disbursementTxnsToUpdate;
    }   
    
}