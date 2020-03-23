/**
 *  Author: Cloud Lending Solutions
 *  Description: Customizing the CL Lease product Termination Functionality due to DLL's Feature Gap
 *
 **/
public with sharing class CLLeaseTerminationQuoteServices {
    

    public static void generateTerminationQuotes(String contractId) {
        // 1. Extract Contract Details for termination
        Set<Id> contractIdSet = new Set<Id>{contractId};
        String fields = TerminationUtil.getTerminationLineFieldAPINames();
        String query = TerminationUtil.getContractsForTermination(fields, contractIdSet, null);
        cllease__Lease_Account__c contract = Database.query(query);

        // 2. Create Map of Map<Id, Equipment> for Equipmments to Terminate (all Equipments for DLL)
        Map<Id, TerminationQuoteAction.Equipment> eqpUnitMap = new Map<Id, TerminationQuoteAction.Equipment>();
        TerminationQuoteAction.Equipment unit;
        // contractEquipmentListMap.put(contract.Id, contract.Contract_Equipments__r);
        if (contract.cllease__Contract_Equipments__r != null && contract.cllease__Contract_Equipments__r.size() > 0) {
            // looping through all Equipments for Equipment POJO Creation
            for (cllease__Contract_Equipment__c equipment : contract.cllease__Contract_Equipments__r) {
                // Creating Temp Equipment POJO
                unit = new TerminationQuoteAction.Equipment(equipment);
                unit.isSelected = true;
                eqpUnitMap.put(equipment.Id, unit);
            }
        }

        // 3. Retrieve Termination Config IDs from Org Parameters && throw exception incase of Termination IDs are not available
        Set<Id> terminationConfigIdSet = new Set<Id>();
        cllease__Org_Parameters__c orgParam = CLSCustomUtil.getCLLeaseOrgParameters();
        if(orgParam.TradeupToKeep_ConfigId__c == null || orgParam.TradeupToReturn_ConfigId__c == null) {
            throw new CLSCustomException('Termination Config Ids are missing for Tradeup to Keep/Return in Custome Setting: Org Parameter(CL Lease)');
        }
        terminationConfigIdSet.add(orgParam.TradeupToKeep_ConfigId__c);
        terminationConfigIdSet.add(orgParam.TradeupToReturn_ConfigId__c);

        // 4. Termination Configuration Retrieval
        List<cllease__Termination_Config__c> terminationConfigs;
        terminationConfigs = Database.query(TerminationUtil.getTerminationConfiguration(new Set<Id>(), terminationConfigIdSet));
        
        // 5. Call the API for Termination Quotes creation TerminationQuoteAction.createTerminationQuote()
        List<TerminationActionUnit> termQtUnitList = new List<TerminationActionUnit>();
        // Creating Termination Quote Headers
        TerminationQuoteAction terminationAction = new TerminationQuoteAction();
        TerminationActionUnit termQUnit1 =  terminationAction.createTerminationQuote(contract, eqpUnitMap, null, terminationConfigs[0]);
        TerminationActionUnit termQUnit2 =  terminationAction.createTerminationQuote(contract, eqpUnitMap, null, terminationConfigs[1]);
        termQtUnitList.add(termQUnit1);
        termQtUnitList.add(termQUnit2);
        terminationAction.updateAll(termQtUnitList);
        System.debug('QuoteHeader1: '+termQUnit1.qh);
        System.debug('QuoteHeader2: '+termQUnit2.qh);
    
    }

    public void getTerminationQuotes() {
        // Retrieve termination Quotes for for API call
    }

    public static void processTerminationQuote(String contractId, String terminationQuoteId) {
        // 0. Extract Contract Details for termination
        Set<Id> contractIdSet = new Set<Id>{contractId};
        String query = TerminationUtil.getContractsForTermination(null, contractIdSet, null);
        cllease__Lease_Account__c contract = Database.query(query);

        // 1. Query  the Termination Quote Header , Quote Lines and Equipment for specific quote Number
        List<cllease__Termination_Quote_Header__c> quoteHeaders = TerminationUtil.getQuoteHeaders(terminationQuoteId);

        // 2. Call the API for Termination Quotes creation TerminationQuoteAction.processTerminationQuote()
        TerminationQuoteAction action = new TerminationQuoteAction(new Map<cllease__Lease_Account__c, cllease__Termination_Quote_Header__c>{contract => quoteHeaders[0]});
        TerminationActionUnit termQUnit = action.processTerminationQuote(contract,
                                                                            quoteHeaders[0],
                                                                            quoteHeaders[0].cllease__Termination_Quote_Lines__r,
                                                                            quoteHeaders[0].cllease__Termination_Quote_Equipments__r);
            
        action.updateAll(termQUnit);
        //termQuoteHeader = quoteHeader2.qh;
        System.debug('QuoteHeader1: '+termQUnit.qh);
    }
}