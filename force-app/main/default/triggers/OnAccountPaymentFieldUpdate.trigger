trigger OnAccountPaymentFieldUpdate on cllease__Lease_Payment_Detail__c (before insert,After insert) {
    public Map<Id, List<cllease__Lease_Payment_Detail__c>> lptToLpdMap = new Map<Id, List<cllease__Lease_Payment_Detail__c>>();
    System.debug(LoggingLevel.Error, 'In trigger---');
    if(trigger.isBefore){
        if(trigger.isInsert){
            for(cllease__Lease_Payment_Detail__c lpd : trigger.new){
                List<cllease__Lease_Payment_Detail__c> lpdList = new List<cllease__Lease_Payment_Detail__c>();
                if(lptToLpdMap.containsKey(lpd.cllease__Payment_Transaction__c)){
                    lpdList = lptToLpdMap.get(lpd.cllease__Payment_Transaction__c);
                    lpdList.add(lpd);
                } else{
                    lpdList.add(lpd);
                }
                lptToLpdMap.put(lpd.cllease__Payment_Transaction__c, lpdList);  
            }
            
            //Query payment transaction to identify the payment mode
            List<cllease__Lease_Payment_Transaction__c> paymentList = [SELECT ID
                                                                       FROM cllease__Lease_Payment_Transaction__c
                                                                       WHERE ID IN : lptToLpdMap.keySet()
                                                                       AND cllease__Payment_Mode__r.Name = 'Invoice Credit'];
            for(cllease__Lease_Payment_Transaction__c pmt : paymentList){
                if(lptToLpdMap.containsKey(pmt.Id)){
                    for(cllease__Lease_Payment_Detail__c lpd : lptToLpdMap.get(pmt.Id)){
                        lpd.On_Account_Payment__c = lpd.cllease__Amount__c;
                        lpd.cllease__Amount__c = 0;
                    }
                }
            }
        }
        
        
    }
    
    //Deleting excess LPD
    if(trigger.isAfter){
        if(trigger.isInsert){
            Set<Id> lpdsToBeProcessed = new Set<Id>();
            List<cllease__Transaction_Sub_Type__c> transactionSubTypes = [Select Id from cllease__Transaction_Sub_Type__c where Name = 'PAYMENT - EXCESS' LIMIT 1];
            if(transactionSubTypes != null && !transactionSubTypes.isEmpty()){
                Id excessTxnSubTypeId = transactionSubTypes[0].Id;
                for(cllease__Lease_Payment_Detail__c lpd : trigger.new){
                    System.debug(LoggingLevel.ERROR, 'lpd----'+lpd);
                    if(lpd.cllease__Transaction_Sub_Type__c == excessTxnSubTypeId){
                        lpdsToBeProcessed.add(lpd.Id);
                    }
                }
                System.debug(LoggingLevel.ERROR, 'lpdsToBeProcessed----'+lpdsToBeProcessed);
                List<cllease__Lease_Payment_Detail__c> paymentDetails = [Select Id from cllease__Lease_Payment_Detail__c where id in : lpdsToBeProcessed];
                delete paymentDetails;
                
            }
        }
        
    }

}