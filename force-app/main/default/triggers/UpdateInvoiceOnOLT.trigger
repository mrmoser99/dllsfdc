trigger UpdateInvoiceOnOLT on cllease__Dealer_Funding_Detail__c (after update) {
    
   Map<Id, Id> dealerTxnEquipmentMap = new Map<Id, Id>();
   list<clcommon__Disbursement_Transaction__c> dealerFundTxnsToUpdate = new list<clcommon__Disbursement_Transaction__c>();
   
   // 1. Looping through Dealer Funding Details for dealerFundingTransaction and Equipment Details
   for(cllease__Dealer_Funding_Detail__c df : trigger.new){
        if(df.cllease__Disbursement_Txn__c != null 
            && df.cllease__Contract_Equipment__c!= null){        
            dealerTxnEquipmentMap.put(df.cllease__Disbursement_Txn__c , df.cllease__Contract_Equipment__c);        
        }
    }
    
    if(dealerTxnEquipmentMap.keyset() != null){

        // 2. Querying Equipments for required details
        Map<Id, cllease__Contract_Equipment__c> equipmentMap = 
            new Map<Id, cllease__Contract_Equipment__c>([SELECT Id, Name, Invoice_Number__c, Invoice_Date__c 
                                                            FROM cllease__Contract_Equipment__c
                                                            WHERE Id in:dealerTxnEquipmentMap.values()]);

        // 3. Querying Other Transactions to update details from Equipment
        Map<Id, clcommon__Disbursement_Transaction__c> dealerFundTxnsMap = 
            new Map<Id, clcommon__Disbursement_Transaction__c>([SELECT Id, Invoice_Number__c, Invoice_Date__c, Contract_Equipment__c
                                                            FROM clcommon__Disbursement_Transaction__c 
                                                            WHERE Id in :dealerTxnEquipmentMap.keyset()]);

        for(Id dealerFundID : dealerTxnEquipmentMap.keySet()) {
            // Retrieving related Dealer Funding Trascantion and Equipments
            clcommon__Disbursement_Transaction__c dealerFundTxn = dealerFundTxnsMap.get(dealerFundID);
            cllease__Contract_Equipment__c equipment    = equipmentMap.get(dealerTxnEquipmentMap.get(dealerFundID));
            // Updating foloowing fields from Equipment to dealerFunding Transaction
            dealerFundTxn.Invoice_Number__c = equipment.Invoice_Number__c;
            dealerFundTxn.Invoice_Date__c   = equipment.Invoice_Date__c;
            dealerFundTxn.Contract_Equipment__c=equipment.Id; //--JE 10/8/20 --mapping contract equipment to disbursement transaction - Case: 02407541
            //dealerFundTxn.AP_Processing_Status__c = 'New'; --JE 10/7/20 --commented out line to resolved duplicate AP records issuse - Case: 02386585
            dealerFundTxnsToUpdate.add(dealerFundTxn);
        }
        System.debug(LoggingLevel.ERROR, '^^^^ dealerFundTxnsToUpdate : ' + dealerFundTxnsToUpdate);
    }
    
    if(dealerFundTxnsToUpdate.size()>0) {
        update dealerFundTxnsToUpdate;
    }   
    
}