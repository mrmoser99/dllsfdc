trigger TermQuoteAmountUpdateInDDL on cllease__Termination_Quote_Header__c (after update) {
    // Retriving Termination Bills
    Set<Id> termQuoteIdSet = new Set<Id>();
    Set<String> contractSet = new Set<String>();

    for(cllease__Termination_Quote_Header__c termHeader : Trigger.new) {
        if(termHeader.cllease__Status__c == 'TERMINATION PROCESSED') {
            contractSet.add(termHeader.cllease__Contract__c);
            termQuoteIdSet.add(termHeader.Id);
        }
    }

    // Copy the Termination Quote details per Equipment.
    if(contractSet.size() > 0) {
        // Querying the Processed Termination Quote Details for Amount Updates
        List<Termination_Equipment_Quote__c> termEqpQuoteList = [SELECT id, name, Amount__c, 
                                                                        Termination_Quote_Line__r.cllease__Line_Type__c, 
                                                                        Termination_Quote__r.Name, 
                                                                        Termination_Quote__r.cllease__Quote_Type__c, 
                                                                        Termination_Quote__r.cllease__Quote_Reason__c, 
                                                                        Termination_Quote__r.cllease__Contract__r.cllease__Lease_Product_Name__c,
                                                                        Termination_Quote_Equipment__c,
                                                                        Termination_Quote_Equipment__r.cllease__Contract_Equipment__c
                                                                    FROM Termination_Equipment_Quote__c
                                                                    WHERE Termination_Quote__c IN :termQuoteIdSet];

        // Updating the Prorated values
        if(termEqpQuoteList.size() > 0) {
            String quoteType, quoteReason, productId;
            // Creating Map of Equipment with values
            Map<Id, List<Termination_Equipment_Quote__c>> eqpIdTermEqpQuoteMap = new Map<Id, List<Termination_Equipment_Quote__c>>();
            Boolean isRolloverTermination = false; 
            for(Termination_Equipment_Quote__c termEqpQuote : termEqpQuoteList) {
                Id eqpId = termEqpQuote.Termination_Quote_Equipment__r.cllease__Contract_Equipment__c;
                List<Termination_Equipment_Quote__c> termQuoteList = eqpIdTermEqpQuoteMap.get(eqpId);
                if(termQuoteList == null) {
                    termQuoteList = new List<Termination_Equipment_Quote__c>();
                }
                termQuoteList.add(termEqpQuote);
                eqpIdTermEqpQuoteMap.put(eqpId, termQuoteList);

                // Extracting details
                quoteType   = termEqpQuote.Termination_Quote__r.cllease__Quote_Type__c;
                quoteReason = termEqpQuote.Termination_Quote__r.cllease__Quote_Reason__c;
                productId   = termEqpQuote.Termination_Quote__r.cllease__Contract__r.cllease__Lease_Product_Name__c;
            }

            cllease__Termination_Config__c quoteConfig = CLSTerminationUtil.getTerminationConfiguration(quoteType, quoteReason, productId);
            List<cllease__Termination_Config_Line__c> quoteConfigLines = quoteConfig.cllease__Termination_Config_Lines__r;
            // Creating Map for Vertex Taxable Line Map.
            Map<String, String> quoteLineTaxableMap = new Map<String, String>();
            List<String> disbTxnFielAPINameList = new List<String>();
            for(cllease__Termination_Config_Line__c quoteConfigLine : quoteConfigLines) {
                if(quoteConfigLine.Consider_for_Vertex_Tax__c) {
                    quoteLineTaxableMap.put(quoteConfigLine.cllease__Quote_Line__c, quoteConfigLine.cllease__Bill_Field_API_Name__c);
                }
            }

            // Query Due DetailLines from System 
            List<cllease__Due_Detail_Lines__c> dueDetailLinesList = getTerminationDueDetailLineRecords(contractSet);

            if(dueDetailLinesList.size() > 0) {
                // Looping through Due Detail Lines for Quote Amount Updates
                for(cllease__Due_Detail_Lines__c ddl : dueDetailLinesList) {
                    List<Termination_Equipment_Quote__c> eqpTermQuoteList = eqpIdTermEqpQuoteMap.get(ddl.cllease__Contract_Equipment__c);
                    for(Termination_Equipment_Quote__c termEqpQuote : eqpTermQuoteList) {
                        String quoteLineType = termEqpQuote.Termination_Quote_Line__r.cllease__Line_Type__c;
                        if(quoteLineTaxableMap.containsKey(quoteLineType)) {
                            Decimal quoteAmount = termEqpQuote.Amount__c;
                            // Updating Quote Amounts as per Termination Config Lines.
                            String fieldAPIName = quoteLineTaxableMap.get(quoteLineType);
                            if(fieldAPIName != null) {
                                ddl.put(fieldAPIName, quoteAmount);
                            }
                        }
                        if(termEqpQuote.Termination_Quote__r.cllease__Quote_Reason__c == 'ROLL-OVER') {
                            isRolloverTermination = true;
                        }
                        // Updating Reason types for Termination Quote Tax Request.
                        ddl.put('Termination_Quote_Type__c', termEqpQuote.Termination_Quote__r.cllease__Quote_Type__c);
                        ddl.put('Termination_Quote_Reason__c', termEqpQuote.Termination_Quote__r.cllease__Quote_Reason__c);
                    }
                }

                update dueDetailLinesList;

                // Do post Termination updates to Create 1. Invoice Creation, 2. Disbursements Creation 3. Payment Creation & Apply
                // do actions only incase of RolloVer (Auto Tradeup) Termination
                if(isRolloverTermination) {
                    CLSTerminationUtil.doPostTerminationUpdates(contractSet, quoteConfig);
                }
            }
            
        }

    }

    private static List<cllease__Due_Detail_Lines__c> getTerminationDueDetailLineRecords(Set<String> contractSet) {
        // Creating Query using ObjectCache
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache dueDetailOC = ec.getObject('DueDetailLines');
        if(dueDetailOC != null) {
           ec.deleteObject('DueDetailLines');
        }        
        dueDetailOC = ec.createObject('DueDetailLines', 'cllease__Due_Detail_Lines__c');
        //Query all SetupAuditTrail records.
        String fields = CLSCustomUtil.fetchAllCustomFields('cllease__Due_Detail_Lines__c');
        dueDetailOC.addFields(fields);

        dueDetailOC.addNamedParameter('contractSet', contractSet); //we looking for this
        String whereClause = 'cllease__Bill__r.cllease__Due_Type_Description__c = \'TERMINATION\'';
        whereClause += ' AND cllease__Contract__c IN :contractSet';

        dueDetailOC.setWhereClause(whereClause);
        dueDetailOC.buildQuery();
        dueDetailOC.executeQuery();
        
        System.debug(LoggingLevel.ERROR, 'DueDetailLine Query: '+dueDetailOC.getQuery());    
        return dueDetailOC.getRecords();
    }
    
}