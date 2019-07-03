/**
 * Owner: CLS-Q2
 * Description: Following trigger helps in updating the Lease Payment Details's Transaction Sub type for Charges
 * 
 **/
trigger LPDTaxTxnSubTypeUpdateTrigger on cllease__Lease_Payment_Detail__c (before insert) {
    
    Savepoint sp = database.setsavepoint();
    try {
        // 1. Collect all Payment IDs and do query again to get details
        Set<Id> paymentIds = new Set<Id>();
        for(cllease__Lease_Payment_Detail__c lpd : trigger.new) {
            if(lpd.cllease__Payment_Transaction__c != null) {
                paymentIds.add(lpd.cllease__Payment_Transaction__c);
            }
        }

        // process the below logic only if payments are available
        if(paymentIds.size() > 0) {

            // Querying Transction SubTypes
            Map<String, Id> txnSubTypeMap = new Map<String, Id>();
            ID pmtTaxTxnSubTypeId;
            for(cllease__Transaction_Sub_Type__c txnSubType : [SELECT Id, Name FROM cllease__Transaction_Sub_Type__c LIMIT 1000]) {
                txnSubTypeMap.put(txnSubType.Name, txnSubType.Id);
                if(txnSubType.Name == 'PAYMENT - TAX') {
                    pmtTaxTxnSubTypeId = txnSubType.Id;
                }
            }

            System.debug(LoggingLevel.ERROR, ' charge pmt tax transaction sub type: '+pmtTaxTxnSubTypeId);


            // Querying All Fee Definition's Transaction Subtypes to deleting Lease Payment  Details
            List<clcommon__Fee_Definition__c> feeDefs = [SELECT Id, Name From clcommon__Fee_Definition__c];
            Set<Id> feeTxnSubTypes = new Set<Id>();
            for(clcommon__Fee_Definition__c feeDef : feeDefs) {
                feeTxnSubTypes.add(txnSubTypeMap.get(feeDef.Name));
            }

            // DO Query on Lease Payment Transactions and creating Map
            Map<Id, cllease__Lease_Payment_Transaction__c> lptMap = new Map<Id, cllease__Lease_Payment_Transaction__c>([
                                                                            SELECT Id, Name, 
                                                                                cllease__Charge__c,
                                                                                cllease__Charge__r.Name,
                                                                                cllease__Charge__r.cllease__Fee_Definition__r.Name
                                                                            FROM cllease__Lease_Payment_Transaction__c
                                                                            WHERE Id IN : paymentIds
                                                                                AND cllease__Charge__c != NULL
                                                                        ]);


            // looping over all Lease Payment Details again for updates
            for(cllease__Lease_Payment_Detail__c lpd : trigger.new) {
                if(pmtTaxTxnSubTypeId == null) {
                    lpd.cllease__GL_Processing_Message__c = 'Transaction sub type is not available1. Please verify';
                }

                // validating payment transaction and subtype with "Payment - Tax " for update, Following logic applies to only payment towards charges
                if(lpd.cllease__Payment_Transaction__c != null 
                    && lptMap != null
                    && lptMap.containskey(lpd.cllease__Payment_Transaction__c)
                    && lptMap.get(lpd.cllease__Payment_Transaction__c).cllease__Charge__c != null
                    && lpd.cllease__Transaction_Sub_Type__c == pmtTaxTxnSubTypeId) {
                        
                    // Extracting LPT and its charge name for transction sub type udpate
                    cllease__Lease_Payment_Transaction__c lpt = lptMap.get(lpd.cllease__Payment_Transaction__c);
                    // charge's tax transaction sub type
                    String chargeTaxTxnSubType = lpt.cllease__Charge__r.cllease__Fee_Definition__r.Name + ' - Tax';

                    System.debug(LoggingLevel.ERROR, ' charge tax transaction sub type: '+chargeTaxTxnSubType);

                    if(!txnSubTypeMap.containsKey(chargeTaxTxnSubType)) {
                        lpd.cllease__GL_Processing_Message__c = 'Transaction sub type is not available2. Please verify';
                    } else {
                        // updating transaction subtype on LPD
                        lpd.cllease__Transaction_Sub_Type__c = txnSubTypeMap.get(chargeTaxTxnSubType);
                    }

                }
            }   
        }

    } catch(exception e){           
        database.rollback(sp);   
        System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
        System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());      
        //insert batch process log for exceptions
        insert new cllease__Batch_Process_Log__c(Name='LPDTaxTxnSubTypeUpdateTrigger: ', cllease__Date__c=system.today(), 
        cllease__Message__c='Error is '+e.getmessage() + ' in line number: '+ e.getlinenumber());
    }
}