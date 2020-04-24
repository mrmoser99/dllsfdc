/**
 *  Author: Cloud Lending Solutions
 *  Description: Customizing the CL Lease product Termination Functionality due to DLL's Feature Gap
 *
 **/
public with sharing class TerminationQuoteAction {

    List<cllease__Lease_Account__c> leaseAccounts;
    Boolean isAPICall = false;
    Boolean isBulkAPICAll = false;   // to be used while using an API call

    Map<String, cllease__Termination_Quote_Header__c> contractQuoteHeaderAPICallMap; //Do not know if this is used. may have to delete in future
    Map<Id, List<cllease__Termination_Config__c>> productIds2TerminationConfigsMap;
    Map<Id, cllease__Termination_Quote_Header__c> contractId2QuoteHeaderMap;
    private mfiflexUtil.UnitOfWorkTransaction uowTransaction;

    public TerminationQuoteAction() {
        this((List<cllease__Lease_Account__c>)null);
    }

    public TerminationQuoteAction(List<cllease__Lease_Account__c> leaseAccounts) {
        this.leaseAccounts = leaseAccounts;
        uowTransaction = new mfiflexUtil.UnitOfWorkTransaction(new LeaseAccountObjectHierarchy());
        // Populateing termination Configuration for All CL Lease Products
        populateTerminationConfigProductMap(new Set<Id>());
        this.contractId2QuoteHeaderMap = new Map<Id, cllease__Termination_Quote_Header__c>();
    }

    public TerminationQuoteAction(Map<cllease__Lease_Account__c, cllease__Termination_Quote_Header__c> quoteHeaderLeaseAccMap) {
        this(new List<cllease__Lease_Account__c>(quoteHeaderLeaseAccMap.keySet()));
        for(cllease__Lease_Account__c leaseAccount : quoteHeaderLeaseAccMap.keySet()) {
            this.contractId2QuoteHeaderMap.put(leaseAccount.Id, quoteHeaderLeaseAccMap.get(leaseAccount));
        }
    }

    /*public TerminationQuoteAction(List<cllease__Lease_Account__c> leaseAccounts,
                                  Map<String, cllease__Termination_Quote_Header__c> contractHeaderMap) {
        this(leaseAccounts);
        for(cllease__Lease_Account__c leaseAccount :leaseAccounts) {
            this.contractId2QuoteHeaderMap.put(leaseAccount.Id, contractHeaderMap.get(leaseAccount.Name));
        }
    }

    public TerminationQuoteAction(List<cllease__Lease_Account__c> leaseAccounts,
                                  Map<Id, cllease__Termination_Quote_Header__c> contractId2QuoteHeaderMap) {
        this(leaseAccounts);
        this.contractId2QuoteHeaderMap.putall(contractId2QuoteHeaderMap);
    }

    */
    
    public void populateTerminationConfigProductMap(Map<cllease__Lease_Account__c, cllease__Termination_Quote_Header__c> qtHeaderLsAccMap) {
        Set<Id> productIds = new Set<Id>();
        if(!qtHeaderLsAccMap.isEmpty()) {
            for(cllease__Lease_Account__c leaseAcc : qtHeaderLsAccMap.keySet()) {
                productIds.add(leaseAcc.cllease__Lease_Product_Name__c);
            }
        }
        populateTerminationConfigProductMap(productIds);
    }

    public void populateTerminationConfigProductMap(Set<Id> productIds) {
        List<cllease__Termination_Config__c> terminationConfigs;
        terminationConfigs = Database.query(TerminationUtil.getTerminationConfiguration(productIds, new Set<Id>()));

        productIds2TerminationConfigsMap = new Map<Id, List<cllease__Termination_Config__c>>();

        for(cllease__Termination_Config__c termConfig : terminationConfigs) {
            List<cllease__Termination_Config__c> termConfigList = productIds2TerminationConfigsMap.get(termConfig.cllease__Lease_Product__c);
            if(termConfigList == null) {
                termConfigList = new List<cllease__Termination_Config__c>();
                productIds2TerminationConfigsMap.put(termConfig.cllease__Lease_Product__c, termConfigList);
            }
            //System.debug((LoggingLevel.FINE, 'populateTerminationConfigProductMap(): termConfigList = ' + termConfigList);
            if(termConfig.cllease__Default__c && !termConfigList.isEmpty()) {
                termConfigList.add(0, termConfig);
            }
            else {
                termConfigList.add(termConfig);
            }
        }
    }

    /** if lease account and its quoteheader is passed, termination configuration will be matched for the same from
     * product's configs. if none match, default is returned.
     * if quoteHeader is not passed, and if the contractId2QuoteHeaderMap was populated, use the same header and find matching config.
     * else pass the default config.
     * @param leaseAccount
     * @param quoteHeader
     * @return
     */
    public cllease__Termination_Config__c getMatchingTerminationConfig(cllease__Lease_Account__c leaseAccount, cllease__Termination_Quote_Header__c quoteHeader) {
        List<cllease__Termination_Config__c> productTermConfigs;
        productTermConfigs = productIds2TerminationConfigsMap.get(leaseAccount.cllease__Lease_Product_Name__c);
        if(productTermConfigs == null || productTermConfigs.isEmpty()) {
            //product doesnt have any config.
            return null;
        }

        if(quoteHeader != null) {
            System.debug('quoteHeader.cllease__Quote_Type__c: '+quoteHeader.cllease__Quote_Type__c);
            System.debug('quoteHeader.cllease__Quote_Reason__c: '+quoteHeader.cllease__Quote_Reason__c);
        }
        
        cllease__Termination_Config__c matchTermConfig;
        //we got quoteheader, lets confirm if there is matching config for the leaseAccount's product.
        //if(quoteHeader != null) {
            for(cllease__Termination_Config__c termConfig :productTermConfigs) {
                System.debug('termConfig.cllease__Quote_Type__c: '+termConfig.cllease__Quote_Type__c);
                System.debug('termConfig.cllease__Quote_Reason__c: '+termConfig.cllease__Quote_Reason__c);
                if(termConfig.cllease__Quote_Type__c == quoteHeader.cllease__Quote_Type__c
                    && termConfig.cllease__Quote_Reason__c == quoteHeader.cllease__Quote_Reason__c) {
                    matchTermConfig = termConfig;
                    System.debug(LoggingLevel.ERROR, 'termination config found = ' + matchTermConfig);
                    break;
                }
            }
        //}

        //if matching config is not found, send default.
        /*if(matchTermConfig == null) {
            matchTermConfig = productTermConfigs.get(0); //by construction, the 1st element is always default.
            System.debug(LoggingLevel.ERROR, 'using default termination config found = ' + matchTermConfig);
            if(matchTermConfig.cllease__Default__c == false) {
                //looks like the product does not have any default. dont use this then.
                matchTermConfig = null;
            }
        }*/

        return matchTermConfig;
    }

    /**
     * Helper method for contract retrieval  with ContractIds as Strings
     */
    public static List<cllease__Lease_Account__c> queryContracts(Set<String> contractIds, Set<String> equipIds) {
        List<cllease__Lease_Account__c> contracts;
        try {
            String fields = TerminationUtil.getTerminationLineFieldAPINames();
            String query = TerminationUtil.getContractsForTermination(fields, contractIds, equipIds);
            //System.debug((LoggingLevel.ERROR, 'TerminationQuoteAction:queryContract() - 1 - query = ' + query);
            contracts = Database.query(query);
        }
        catch(Exception e) {
            throw new CLSCustomException('Exception while querying contracts: '+e.getMessage()+ ' Line: '+e.getLineNumber());
        }
        return contracts;
    }

    /**
     * Helper method for contract retrieval  with ContractIds as Ids
     */
    public static List<cllease__Lease_Account__c> queryContracts(Set<Id> contractIds, Set<Id> equipIds) {
        List<cllease__Lease_Account__c> contracts;
        try {
            String fields = TerminationUtil.getTerminationLineFieldAPINames();
            String query = TerminationUtil.getContractsForTermination(fields, contractIds, equipIds);
            //System.debug((LoggingLevel.ERROR, 'TerminationQuoteAction:queryContract() - 2 - query = ' + query);
            contracts = Database.query(query);
        }
        catch(Exception e) {
            throw new CLSCustomException('Exception while querying contracts: '+e.getMessage()+ ' Stack: '+e.getStackTraceString());
        }
        return contracts;
    }

    /**
     *  Extracting the 3rd party sales details
     */
    public List<clcommon__Equipment_Transaction__c> getThirdPartySaleDetails(Set<Id> contractEquipmentIds) {
        String nsPrefix = CLSCustomUtil.getNSWithUnderScore();
        Set<Id> collateralIds;
        List<clcommon__Equipment_Transaction__c> equipmentTxns;
        try {
            ContractEquipmentSelector selector = new ContractEquipmentSelector(new List<String>{'Id', nsPrefix+'Warehouse_Equipment__c'});
            collateralIds = selector.getCollaterIdsForEquipmentIds(contractEquipmentIds);
            String query = TerminationUtil.getThirdPartySaleDetailsQuery(collateralIds);
            equipmentTxns = Database.query(query);
        }
        catch(Exception e) {
            throw new CLSCustomException('Exception while querying Third Party Asset Sale details: '+e.getMessage()+ ' Line: '+e.getLineNumber());
        }
        return equipmentTxns;
    }

    /**
     * Process the Contract Termination
     */
    /*public void process() {
        //System.debug((LoggingLevel.ERROR,'#### inside process start:');
        List<TerminationActionUnit> terminationQuoteDetailsToUpdate = new List<TerminationActionUnit>();
        isAPICall = true;
        isBulkAPICall = true;
        try {
            Map<Id, List<Equipment>> contractId2EquipmentListMap;
            contractId2EquipmentListMap = new Map<Id, List<Equipment>>();
            for(cllease__Lease_Account__c leaseAccount: leaseAccounts) {
                // Creating Equipment Unit List
                List<Equipment> units = new List<Equipment>();
                for(cllease__Contract_Equipment__c equipmentUnit : leaseAccount.cllease__Contract_Equipments__r) {
                    Equipment unit = new Equipment(equipmentUnit);
                    unit.isSelected = true;
                    units.add(unit);
                }
                contractId2EquipmentListMap.put(leaseAccount.Id, units);
            }
            processTermination(contractId2EquipmentListMap, true);
        }
        catch(Exception e) {
            throw new CLSCustomException('Exception during process termination: '+e.getMessage()+' Stack: ' +
                e.getStackTraceString() + ' line: '+e.getLineNumber());
        }
    }*/

    /**
     * used to perform full/partial termination of contracts via Webservice/ Public API
     *
     * @param contractId2EquipmentListMap
     * @param isEquipmentLevelTermination
     */
    public void processTermination(Map<Id, List<Equipment>> contractId2EquipmentListMap, Boolean isEquipmentLevelTermination) {
        //System.debug((LoggingLevel.DEBUG, '-----------Started the processTermination --------');
        try {
            //First comfirm if we have termination quote for all the contracts.
            //we expect to not have more than one quote  per contract.

            validateOrCreateTerminationQuote(contractId2EquipmentListMap);
            processTermination(contractId2EquipmentListMap);
        }
        catch(Exception e) {
            throw new CLSCustomException('Exception during process termination: '+e.getMessage()+' Stack: ' +
                e.getStackTraceString() + ' line: '+e.getLineNumber());
        }
        //System.debug((LoggingLevel.DEBUG, '-----------Completed the processTermination --------');
    }

    /**
     * used to perform full/partial termination of contracts via Webservice/ Public API. It expects that the
     * valid quote header is already generator.
     *
     * @param contractId2EquipmentListMap
     */
    public void processTermination(Map<Id, List<Equipment>> contractId2EquipmentListMap) {
        List<TerminationActionUnit> terminationQuoteDetailsToUpdate = new List<TerminationActionUnit>();
        for(cllease__Lease_Account__c leaseAccount : leaseAccounts) {
            cllease__Termination_Quote_Header__c tempHeader;
            tempHeader = contractId2QuoteHeaderMap.get(leaseAccount.Id);
            System.assertNotEquals(null, tempHeader, 'The termination quote must be populated');
            //System.debug((LoggingLevel.ERROR, 'processTermination(2) : tempHeader = ' + tempHeader);

            List<Equipment> selectedUnits = contractId2EquipmentListMap.get(leaseAccount.Id);

            //if the contractEquipmentListMap can be map of map we dont need below step
            Map<Id, Equipment> selectedUnitsMap = new Map<Id, Equipment>();
            for(Equipment eqp : selectedUnits) {
                selectedUnitsMap.put(eqp.getId(), eqp);
            }

            TerminationActionUnit termQtUnit = createTerminationQuote(leaseAccount, selectedUnitsMap, tempHeader);
            termQtUnit.processTerminationQuote(isBulkAPICAll);
            terminationQuoteDetailsToUpdate.add(termQtUnit);
        }
        updateAll(terminationQuoteDetailsToUpdate);
    }

    /**
     * Validate and Create the Termination Quote for contract details
     */
    private void validateOrCreateTerminationQuote(Map<Id, List<Equipment>> contractId2EquipmentListMap) {
        Date systemDate = cllease.SystemDateUtil.getCurrentSystemDate();
        for(cllease__Lease_Account__c leaseAccount : leaseAccounts) {
            cllease__Termination_Quote_Header__c tempHeader;


            tempHeader = contractId2QuoteHeaderMap.get(leaseAccount.Id);
            if(tempHeader == null) {
                tempHeader = populateTermQuoteForLeaseAccount(leaseAccount, null);
            }

            //header was not populated by populateTermQuoteForLeaseAccount
            if(tempHeader.cllease__Termination_Date__c == null) {
                TerminationActionUnit.TerminationContract termContract;
                termContract = new TerminationActionUnit.TerminationContract(leaseAccount);
                tempHeader.cllease__Requested_Termination_Date__c = systemDate;  // This should be treated as current system date.
                tempHeader.cllease__Termination_Date__c = termContract.getEffectiveTerminationDate(systemDate, false);
            }

            List<Equipment> selectedUnits = contractId2EquipmentListMap.get(leaseAccount.Id);

            Integer countEquipments = 0;
            Integer countEquipmentDetails = 0;
            for(Equipment eq : selectedUnits) {
                /*if(eq.isEquipmentDetail) {
                    countEquipmentDetails += 1;
                }
                else {*/
                    countEquipments += 1;
                //}
            }

            //At present we dont support equipment and equipment-details being terminated in one go.
            if(countEquipments > 0 && countEquipmentDetails > 0) {
                throw new CLSCustomException('Lease Account ' + leaseAccount.Name+ ': Attempt to terminate Contract Equipments and EquopmeDetails in one '+ 'Transaction. This is not supported currently');
            }

            if(countEquipments > 0) {
                tempHeader.cllease__Is_Equipment_Termination__c = true;
            }
            //System.debug((LoggingLevel.ERROR, 'validateOrCreateTerminationQuote(1) : tempHeader = ' + tempHeader);
        }
    }

    /**
    *  given lease account, find the default termination config matching for its product.
    *  and create termination quote header. add the newly created termination quote header to
    *  contractId2QuoteHeaderMap against lease-account id.
    *
    *  @param  leaseAccount
    */
    public cllease__Termination_Quote_Header__c populateTermQuoteForLeaseAccount(cllease__Lease_Account__c leaseAccount, cllease__Termination_Config__c tempConfig) {
        TerminationActionUnit.TerminationContract termContract;
        termContract = new TerminationActionUnit.TerminationContract(leaseAccount);
        
        if(tempConfig == null) {
            tempConfig = getMatchingTerminationConfig(leaseAccount, null);
        }

        cllease__Termination_Quote_Header__c tempHeader;
        tempHeader = new cllease__Termination_Quote_Header__c();
        tempHeader.cllease__Quote_Reason__c = tempConfig.cllease__Quote_Reason__c;
        tempHeader.cllease__Quote_Type__c = tempConfig.cllease__Quote_Type__c;
        if(tempHeader.cllease__Termination_Date__c == null) {
            tempHeader.cllease__Requested_Termination_Date__c = cllease.SystemDateUtil.getCurrentSystemDate();
            tempHeader.cllease__Termination_Date__c = termContract.getEffectiveTerminationDate(cllease.SystemDateUtil.getCurrentSystemDate(), tempConfig.cllease__Consider_Pre_Bill_Days__c); // This should be treated as current system date.
        }
        tempHeader.cllease__Contract__c = leaseAccount.Id;
        //Store the tempHeader.
        contractId2QuoteHeaderMap.put(leaseAccount.Id, tempHeader);
        return tempHeader;
    }

    public TerminationActionUnit createTerminationQuote(cllease__Lease_Account__c leaseAccount, Map<Id, Equipment> termUnitsMap, cllease__Termination_Quote_Header__c quoteHeader) {
        return createTerminationQuote(leaseAccount, termUnitsMap, quoteHeader, null);
    }

    public TerminationActionUnit createTerminationQuote(cllease__Lease_Account__c leaseAccount, Map<Id, Equipment> termUnitsMap, cllease__Termination_Quote_Header__c quoteHeader, cllease__Termination_Config__c terminationConfig) {
        
        //create quotHeader for createTerminationQuote and not for processTerminationQuote;
        TerminationActionUnit termQtUnit = new TerminationActionUnit(quoteHeader, leaseAccount);
        try {
            
            // 3. QuoteHeader Initialization: Use quoteHeader from the map if it's a REST API call
            /*if(termQtUnit.qh == null
                && contractQuoteHeaderAPICallMap != null
                && isBulkAPICall) {
                termQtUnit.qh = contractQuoteHeaderAPICallMap.get(leaseAccount.Name);
                isAPICall = false; // if quoteHeader map is passed then set isAPICall to false
            }*/

            cllease__Termination_Quote_Header__c tempHeader  = quoteHeader;
            if(tempHeader == null) {
                tempHeader      = populateTermQuoteForLeaseAccount(leaseAccount, terminationConfig);
                termQtUnit.qh   = tempHeader;
            } else {
                // Since we could already be having the matching terminationConfig which is being passed
                if (terminationConfig == null) {
                    terminationConfig = getMatchingTerminationConfig(leaseAccount, tempHeader);
                }

            }

            
            if(terminationConfig == null) {
                throw new CLSCustomException('No termination configuration found in product, please check ... ');
            }
            if(terminationConfig.cllease__Termination_Config_Lines__r.size() == 0) {
                throw new CLSCustomException('No Quote config lines created for termination config ' + terminationConfig.Name + ', please check termination configuration again');
            }

            Set<Id> eqpOrEqpDetailsIdsForTermination = termUnitsMap.keySet();
            // Loop through all Termination Quote Equipments to create Map for Equipment
            // Details in process for termination
            termQtUnit.populateEquipAndEqipDetailForTermination(eqpOrEqpDetailsIdsForTermination);

            for(Id equipmentId : termQtUnit.allActiveEquipments.keySet()) {
                Equipment parentEquip = termQtUnit.allActiveEquipments.get(equipmentId);
                termQtUnit.computeEquipmentCostAndResiduals(parentEquip);
                termQtUnit.createTermQuoteEquipmentRecord(parentEquip);
            }

            Date effectiveToDate = termQtUnit.qh.cllease__Effective_To__c;
            // In case of Bulk API Calls, Needs to take Rollup field on Equipment's Invoice Price
            termQtUnit.markQuoteHeaderAsGenerated(isBulkAPICAll, isAPICall);
			
			/*User might edit Quote Effective To Date, so resetting to User entered value.
             Not changing in markQuoteHeaderAsGenerated() because that method might be called from API.*/
            termQtUnit.qh.cllease__Effective_To__c = effectiveToDate; 
            
            // Computing Quote Lines.
            termQtUnit.computeQuoteLines(terminationConfig);

            // adding parent: Termination Quote header ,
            //        childMap: Termination Quote Lines,
            //        childMap2: Termination Quote Equipment

            // START: MultiCurrency Processing currencyISOCode assignment
            Map<Id, List<SObject>> objMap = new Map<Id, List<SObject>>();
            List<SObject> lis = new List<SObject>();
            lis.add((sObject)termQtUnit.qh);
            lis.addAll((List<sObject>)termQtUnit.terminationLines);
            lis.addAll((List<sObject>)termQtUnit.terminationEquipments);
            objMap.put(leaseAccount.Id,lis);
            clcommon.MultiCurrencyUtil.setCurrencyCodes(objMap);
            // END: MultiCurrency Processing currencyISOCode assignment
        } catch(Exception e) {
            throw new CLSCustomException('Exception while creating termination quote: '+e.getMessage()+' stack:'+e.getStackTraceString());
        }
        return termQtUnit;
    }

    public TerminationActionUnit processTerminationQuote(cllease__Lease_Account__c leaseAccount, cllease__Termination_Quote_Header__c quoteHeader, List<cllease__Termination_Quote_line__c> terminationLines, List<cllease__Termination_Quote_Equipment__c> terminationEquipments) {
        //System.debug((LoggingLevel.FINE, 'Quote Header : ' + quoteHeader);
        TerminationActionUnit termQtUnit = new TerminationActionUnit(quoteHeader, leaseAccount);
        termQtUnit.terminationEquipments = terminationEquipments;
        termQtUnit.terminationLines = terminationLines;

        Set<Id> eqpOrEqpDetailsIdsForTermination = new Set<Id>();
        for(cllease__Termination_Quote_Equipment__c termEquip : terminationEquipments) {
            if(termQtUnit.qh.cllease__Is_Equipment_Termination__c) {
                eqpOrEqpDetailsIdsForTermination.add(termEquip.cllease__Contract_Equipment__c);
            }
            // Commenting the Equipment Unit Level Termination Code
            /*else {
                eqpOrEqpDetailsIdsForTermination.add(termEquip.cllease__Equipment_Detail__c);
            }*/
        }
        // Process Termination Quotes 
        termQtUnit.populateEquipAndEqipDetailForTermination(eqpOrEqpDetailsIdsForTermination);
        termQtUnit.processTerminationQuote(isBulkAPICAll);

        return termQtUnit;
    }

    public void updateAll(TerminationActionUnit termQtUnit) {
        List<TerminationActionUnit> termQtUnitList = new List<TerminationActionUnit> {termQtUnit};
        updateAll(termQtUnitList);
    }

    public void updateAll(List<TerminationActionUnit> termQtUnitList) {
        //System.debug((LoggingLevel.FINE, 'updateAll(List) Entering');
        List<cllease__Contract_Equipment__c> equipmentsToUpdate = new List<cllease__Contract_Equipment__c>();
        //List<clcommon__Equipment_Detail__c> eqpDetailsToUpdate = new List<clcommon__Equipment_Detail__c>();
        Map<Id, cllease__Lease_Account__c> leaseAccountsToUpdate = new Map<Id, cllease__Lease_Account__c>();

        //This is still handled separately due to the use of equipmentDetailUtil class.
        SavePoint sp = Database.setSavePoint();
        try{
            for(TerminationActionUnit termQtUnit : termQtUnitList) {
                termQtUnit.createUoW(uowTransaction);
                if(!termQtUnit.equipmentsToTerminate.isEmpty()) {

                    for(Id eqpId : termQtUnit.equipmentsToTerminate.keySet()) {
                        Equipment eqp = termQtUnit.equipmentsToTerminate.get(eqpId);
                        /*List<Equipment> dueDetailEqp = eqp.eqpDetailsById.values();
                        for(Equipment eqp2 : dueDetailEqp) {
                            eqpDetailsToUpdate.add(eqp2.eqpDetail);
                        }*/
                        if(eqp.isSelected) {
                            equipmentsToUpdate.add(eqp.eqp);
                        }
                    }
                    leaseAccountsToUpdate.put(termQtUnit.lacc.id, termQtUnit.lacc);
                }

            }

            //System.debug((LoggingLevel.ERROR, 'important objects ...: cpu utilization till now = ' + Limits.getCpuTime() + ' of ' + Limits.getLimitCpuTime());
            uowTransaction.commitWork();

            //Lease accounts are updated with a flag which indicates that we should
            //not use calculation setup
            //so the update statement of lease accounts should be before equipments
            if(leaseAccountsToUpdate.size() > 0) {
                update leaseAccountsToUpdate.values();
            }

            //pending to be added under createUoW for termQtUnit
            //System.debug((LoggingLevel.ERROR, 'update contract equipment ');
            if(equipmentsToUpdate.size()>0) {
                /*//Hack to avoid calling equipment trigger where calculation is redone
                //Ideally we should have a field on contract to avoid recalculation
                RecursiveTriggerHelper.setAlreadyModified();*/
                cllease.EquipmentOperations.updateEquipment(equipmentsToUpdate);
            }

            //pending to be added under createUoW for termQtUnit
            //after equipments update we need to restrore the flag on contract which
            //has skipped calculation setups
            //System.debug((LoggingLevel.ERROR, 'update contract 2 ');
            if(leaseAccountsToUpdate.size() > 0) {
                for(cllease__Lease_Account__c contract : leaseAccountsToUpdate.values()) {
                    contract.cllease__enable_calculation_setup_logs__c = false;
                }
                update leaseAccountsToUpdate.values();
            }
        }
        catch(Exception e) {
            Database.rollback(sp);
            //System.debug((LoggingLevel.ERROR, 'Exception while updating: '+e.getMessage()+' stack:'+e.getStackTraceString());
            throw new CLSCustomException('Exception while updating: '+e.getMessage()+' stack:'+e.getStackTraceString());
        }
    }

    /**
     * Equipment Object for storing generic details either from contract Equipment or Equipment Details object.
     */
    public class Equipment {
        public Boolean isSelected {get; set;}
        public Cllease__Contract_Equipment__c eqp {get; set;}
        //public clcommon__Equipment_Detail__c eqpDetail {get; set;}
        private Id eqpDetailsParentEqpId;
        //private Boolean isEquipmentDetail;
        private  Map<String, String> eqpDetailToEqpMapping;
        private Map<Id, Equipment> eqpDetailsById;
        private Integer numChildSelected = 0;
        private Decimal eqpCost = 0.00;
        private Decimal selectedEqpCost = 0.00;

        private String equipmentName() {
            /*if(isEquipmentDetail) {
                return eqpDetail.Name;
            }
            else {*/
                return eqp.Name;
            //}
        }

        public Equipment(Cllease__Contract_Equipment__c equip) {
            try {
                init();
                this.eqp = equip;
                if(this.eqp.cllease__Status__c == LendingConstants.CONTRACT_EQUIPMENT_STATUS_TO_BE_TERMINATED) {
                    this.isSelected = true;
                }
                eqpDetailsParentEqpId = equip.Id;
                eqpDetailsById = new Map<Id, Equipment>();
                //System.debug((LoggingLevel.ERROR, 'Constructor## ' +  equipmentName() + ': eqpCost = ' + eqpCost);
            }
            catch (Exception ex) {
                throw ex;
            }
        }

        /*public Equipment(clcommon__Equipment_Detail__c eqpDetail) {
            try {
                init();
                this.eqpDetail = eqpDetail;
                this.isEquipmentDetail = true;
                if(this.eqpDetail.clcommon__Status__c == LendingConstants.CONTRACT_EQUIPMENT_STATUS_TO_BE_TERMINATED) {
                    this.isSelected = true;
                }
                this.eqpDetailsParentEqpId = eqpDetail.Cllease__Contract_Equipment__c;
                //System.debug(LoggingLevel.ERROR, 'Constructor## ' +  equipmentName() + ': eqpCost = ' + eqpCost);
            }
            catch (Exception ex) {
                throw ex;
            }
        }*/

        private void init() {
            isSelected = false;
            //isEquipmentDetail = false;
            eqpDetailsById = null;
            // RECHECK eqpDetailToEqpMapping = EquipmentDetailUtil.getEqptoEqpDetailFieldMap();
            //System.debug(LoggingLevel.ERROR, 'Equipment::init() - eqpDetailToEqpMapping = ' + eqpDetailToEqpMapping);
        }

        public override String toString() {
            String isSelectedString = 'selected';
            if(!isSelected) {
                isSelectedString = 'not selected';
            }

            /*if (isEquipmentDetail) {
                return '{[' + this.eqpDetail.Name + '] ' + isSelectedString + '} ';
            } else {*/
                if(isSelected) {
                    return '{[' + this.eqp.Name + '] ' + isSelectedString + '} ';
                }
                else {
                    String str1 = '{[' + this.eqp.Name + '] ' + isSelectedString + '} ';
                    if(!eqpDetailsById.isEmpty()) {
                        str1 += ' ### Equipments\n';
                    }
                    Integer count = 1;
                    for(Id eqpDetailId : eqpDetailsById.keySet()) {
                        Equipment eqpD = eqpDetailsById.get(eqpDetailId);
                        str1 += 'count = ' + count + '=> ' +  eqpD.toString() + '\n';
                    }
                    return str1;
                }
            //}
        }

        /*
        public void addEqpDetailsToEqp(Equipment eqpDetail) {
            if(isEquipmentDetail) {
                throw new CLSCustomException('cant add eqpDetail to another eqpdetail');
            }

            if(eqpDetail.getParentId() != getParentId()) {
                throw new CLSCustomException('eqpDetail ' + eqpDetail.eqpDetail.Name
                            +' not child of ' + this.eqp.Name);
            }

            eqpDetailsById.put(eqpDetail.getId(), eqpDetail);
            if(eqpDetail.isSelected) {
                this.numChildSelected += 1;
                //this.selectedEqpCost += eqpDetail.selectedEqpCost;
            }
            //System.debug(LoggingLevel.ERROR, 'addEqpDetailsToEqp(): ' + equipmentName() + ' :  eqpCost = ' + eqpCost + ' and selected eqpCost = ' + selectedEqpCost);
        }
        */

        /**
         * If object instnce is of type Equipment Detail, only one record will be returned in list.
         * If the equipment passed is Contract-Equipment and is selected, then also only one record will be returned.
         * if the contract-equipmement is not selected, the number of records will match number of equipment details
         * selected for the contract-equipment.
         */
        public List<Cllease__Termination_Quote_Equipment__c> createTerminationQuoteEquipment() {
            List<Cllease__Termination_Quote_Equipment__c> selectedTerminationQuoteEquipments;
            selectedTerminationQuoteEquipments = new List<Cllease__Termination_Quote_Equipment__c>();

            if(isSelected) {
                Cllease__Termination_Quote_Equipment__c terminationQuoteEquipment;
                terminationQuoteEquipment = new Cllease__Termination_Quote_Equipment__c();
                /*if(isEquipmentDetail) {
                    terminationQuoteEquipment.Cllease__Equipment_Detail__c = this.eqpDetail.Id;
                }
                else {*/
                    terminationQuoteEquipment.Cllease__Contract_Equipment__c = this.eqp.Id;
                //}
                selectedTerminationQuoteEquipments.add(terminationQuoteEquipment);
            }
            else {
                //if(!isEquipmentDetail) {
                    for(Id eqpDetailId : eqpDetailsById.keySet()) {
                        Equipment eqpD = eqpDetailsById.get(eqpDetailId);
                        selectedTerminationQuoteEquipments.addAll(eqpD.createTerminationQuoteEquipment());
                    }
                //}
            }
            return selectedTerminationQuoteEquipments;
        }

        public Boolean eqpOrEqpDetailSelected() {
            Boolean somethingIsSelected = false;

            /*if(isEquipmentDetail) {
                somethingIsSelected = isSelected;
            }
            else {*/
                if(isSelected) {
                    somethingIsSelected = isSelected;
                }
                else {
                    if(numChildSelected > 0) {
                        somethingIsSelected = true;
                    }
                }
           // }

            return somethingIsSelected;
        }

        public Id getParentId() {
            return eqpDetailsParentEqpId;
        }

        /**
         * If object instnce is of type Equipment Detail, only one record will be returned in list.
         * If the equipment passed is Contract-Equipment and is selected, then also only one record will be returned.
         * if the contract-equipmement is not selected, the number of records will match number of equipment details
         * selected for the contract-equipment.
         */
        public List<Cllease__Asset_Return__c> createAssetReturn(Boolean withPurchase) {
             List<Cllease__Asset_Return__c> assetReturns;
             assetReturns = new List<cllease__Asset_Return__c>();

             if(isSelected) {
                Cllease__Asset_Return__c assetReturn = new Cllease__Asset_Return__c();
                 /*if(isEquipmentDetail) {
                     assetReturn.Cllease__Equipment_Detail__c = this.eqpDetail.Id;
                 }
                 else {*/
                     assetReturn.Cllease__Contract_Equipment__c = this.eqp.Id;
                 //}
                 if(withPurchase) {
                     assetReturn.Cllease__Return_Status__c = LendingConstants.MASTER_EQ_SOLD;
                 }
                 else {
                     assetReturn.Cllease__Return_Status__c = LendingConstants.MASTER_EQ_SCHEDULED;
                 }

                 assetReturns.add(assetReturn);
             }
             else {
                    //if(!isEquipmentDetail) {
                     for(Id eqpDetailId : eqpDetailsById.keySet()) {
                         Equipment eqpD = eqpDetailsById.get(eqpDetailId);
                         assetReturns.addAll(eqpD.createAssetReturn(withPurchase));
                    // }
                 }
             }

             return assetReturns;
        }

        /*public Boolean isEquipmentDetail() {
             return this.isEquipmentDetail;
        }*/

        public Id getId() {
             /*if(isEquipmentDetail) {
                 return this.eqpDetail.Id;
             }
             else {*/
                 return this.eqp.Id;
             //}
        }

        public Decimal getSelectedEqpCost() {
            Decimal selectedCost = 0.00;

            /*if(isEquipmentDetail) {
                if(isSelected) {
                    selectedCost = getEqpCost(this.eqpDetail);
                }
            }
            else {*/
                if(isSelected) {
                    selectedCost = getEqpCost(this.eqp);
                }
                else {
                    for(Id eqpDetailId : eqpDetailsById.keySet()) {
                        Equipment eqpD = eqpDetailsById.get(eqpDetailId);
                        selectedCost += eqpD.getSelectedEqpCost();
                    }
                }
            //}
            return selectedCost;
         }

        public Decimal getEqpCost() {
             Decimal equipCost = 0.00;
             /*if(isEquipmentDetail) {
                 equipCost = getEqpCost(this.eqpDetail);
             }
             else {*/
                 equipCost = getEqpCost(this.eqp);
             //}
             return equipCost;
         }

        /*private Decimal getEqpCost(clcommon__Equipment_Detail__c eqpDetail) {
             Decimal equipCost = 0.00;

             if(eqpDetailToEqpMapping == null
                 || eqpDetailToEqpMapping.size() == 0) {
                 //System.debug(LoggingLevel.ERROR, 'eqpDetailToEqpMapping is empty/null, returning 0');
                 return equipCost;
             }

             String namespaceUS = 'cllease__';
             String eqpCostFieldName = namespaceUS +'Equipment_Calculated_Cost__c';
             eqpCostFieldName = eqpCostFieldName.toLowerCase();
             String eqpInvoiceFieldName = namespaceUS +'Estimated_Selling_Price__c';
             eqpInvoiceFieldName = eqpInvoiceFieldName.toLowerCase();
             String eqpDetailEqpCostFieldName  = eqpDetailToEqpMapping.get(eqpCostFieldName);
             String eqpDetailInvoiceFieldName  = eqpDetailToEqpMapping.get(eqpInvoiceFieldName);

            // Extracting Required Values from Equipment Detail Object
            if(eqpDetailEqpCostFieldName != null  && eqpDetail.get(eqpDetailEqpCostFieldName) != null) {
                 equipCost = (Decimal) eqpDetail.get(eqpDetailEqpCostFieldName);
                 //System.debug(LoggingLevel.ERROR, 'eqpDetailEqpCostFieldName - equipCost = ' + equipCost);
            }
             else if(eqpDetailInvoiceFieldName != null  && eqpDetail.get(eqpDetailInvoiceFieldName) != null) {
                 equipCost = (Decimal) eqpDetail.get(eqpDetailInvoiceFieldName);
                 //System.debug(LoggingLevel.ERROR, 'eqpDetailInvoiceFieldName - equipCost = ' + equipCost);
            }
            //System.debug(LoggingLevel.ERROR, 'returning - equipCost = ' + equipCost);
            return equipCost;
         }*/

         private Decimal getEqpCost(Cllease__Contract_Equipment__c contractEquipment) {

            Decimal eqpCost = contractEquipment.cllease__Equipment_Calculated_Cost__c;
            if (eqpCost == null) { //set the selling price as eqpCost if it is null
                eqpCost = contractEquipment.Cllease__Estimated_Selling_Price__c;
            }
            if (eqpCost == null) {
                eqpCost = 0.0;
            }
            return eqpCost;
        }

        public Decimal getSelectedEqpResidualValue() {
            Decimal selectedEquipResidual = 0.00;
            System.debug(LoggingLevel.ERROR, 'getSelectedEqpResidualValue(): ');
            if(isSelected) {
                selectedEquipResidual = getEqpResidualValue();
            }
            else {
                //if(!isEquipmentDetail) {
                    for(Id eqpDetailId : eqpDetailsById.keySet()) {
                        Equipment eqpD = eqpDetailsById.get(eqpDetailId);
                        selectedEquipResidual += eqpD.getSelectedEqpResidualValue();
                    }
                //}
            }
            return selectedEquipResidual;
        }

        public Decimal getSelectedEqpAssetRent() {
            Decimal selectedEquipAssetRent = 0.00;
            //if(!isEquipmentDetail) {
                 selectedEquipAssetRent = getSelectedEqpAssetRent(this.eqp);
            //}
            return selectedEquipAssetRent;
        }

        public Decimal getSelectedEqpAssetRent(Cllease__Contract_Equipment__c contractEquipment) {
            Decimal selectedEquipAssetRent = 0.00;
            if(contractEquipment.Cllease__Rent__c != null) {
                selectedEquipAssetRent = eqp.Cllease__Rent__c;
            }
            return selectedEquipAssetRent;
        }

        public Decimal getEqpResidualValue() {
            Decimal eqpResidualValue = 0.0;
            /*if(isEquipmentDetail) {
                eqpResidualValue = getEqpResidualValue(this.eqpDetail);
            }
            else {*/
                eqpResidualValue = getEqpResidualValue(this.eqp);
            //}
            return eqpResidualValue;
        }

        /*private Decimal getEqpResidualValue(clcommon__Equipment_Detail__c eqpDetail) {
            if(eqpDetailToEqpMapping == null
                || eqpDetailToEqpMapping.size() == 0) {
                throw new CLSCustomException('Missing Contract Equipment to Equipment Details Field mapping. Please Check Company Configuration');
            }

            String namespace = 'cllease__';
            String eqpDetailResidualFieldName = eqpDetailToEqpMapping.get(namespace +'Residual_Amount__c');
            Decimal eqpResidualValue = 0.0;
            if(eqpDetailResidualFieldName != null
                && eqpDetail.get(eqpDetailResidualFieldName) != null) {
                eqpResidualValue =(Decimal) eqpDetail.get(eqpDetailResidualFieldName);
            }
            return eqpResidualValue;
        }*/

        private Decimal getEqpResidualValue(Cllease__Contract_Equipment__c contractEquipment) {

            Decimal eqpResidualValue = contractEquipment.Cllease__Residual_Amount__c;

            if (eqpResidualValue == null) {
                eqpResidualValue = 0.0;
            }
            return eqpResidualValue;
        }


        public Decimal getSelectedSubventionAmount() {
            Decimal selectedSubventionAmount = 0.00;

            if(isSelected) {
                selectedSubventionAmount = getSubventionAmount();
            }
            else {
                //if(!isEquipmentDetail) {
                    for(Id eqpDetailId : eqpDetailsById.keySet()) {
                        Equipment eqpD = eqpDetailsById.get(eqpDetailId);
                        selectedSubventionAmount += eqpD.getSelectedSubventionAmount();
                    }
                //}
            }
            return selectedSubventionAmount;
        }

        public Decimal getSubventionAmount() {
            Decimal subventionAmount = 0.0;
            /*if(isEquipmentDetail) {
                subventionAmount = getSubventionAmount(this.eqpDetail);
            }
            else {*/
                subventionAmount = getSubventionAmount(this.eqp);
            //}
            return subventionAmount;
        }

        private Decimal getSubventionAmount(Cllease__Contract_Equipment__c eqp) {
            Decimal subventionAmount = 0.0;
            if(eqp.Cllease__Subvention__c != null) {
                subventionAmount = eqp.Cllease__Subvention__c;
            }
            return subventionAmount;
        }

        /*private Decimal getSubventionAmount(clcommon__Equipment_Detail__c eqp) {
            if(eqpDetailToEqpMapping == null
                || eqpDetailToEqpMapping.size() == 0) {
                throw new CLSCustomException('Missing Contract Equipment to Equipment Details Field mapping. Please Check Company Configuration');
            }

            String namespace = 'cllease__';
            String eqpDetailsubventionFieldName = eqpDetailToEqpMapping.get(namespace +'Subvention__c');

            Decimal subventionAmount = 0.0;
            if(eqpDetailsubventionFieldName != null
                && eqpDetail.get(eqpDetailsubventionFieldName) != null) {
                subventionAmount = (Decimal)eqpDetail.get(eqpDetailsubventionFieldName);
            }
            return subventionAmount;
        }*/


        public Decimal getSelectedSubsidyAmount() {
            Decimal selectedSubsidyAmount = 0.00;

            if(isSelected) {
                selectedSubsidyAmount = getSubsidyAmount();
            }
            else {
                //if(!isEquipmentDetail) {
                    for(Id eqpDetailId : eqpDetailsById.keySet()) {
                        Equipment eqpD = eqpDetailsById.get(eqpDetailId);
                        selectedSubsidyAmount += eqpD.getSelectedSubsidyAmount();
                    }
                //}
            }
            return selectedSubsidyAmount;
        }

        public Decimal getSubsidyAmount() {
             Decimal subsidyAmount = 0.0;
             /*if(isEquipmentDetail) {
                 subsidyAmount = getSubsidyAmount(this.eqpDetail);
             }
             else {*/
                 subsidyAmount = getSubsidyAmount(this.eqp);
             //}

             if(subsidyAmount == null) {
                 subsidyAmount = 0.0;
             }
             return subsidyAmount;
        }

        private Decimal getSubsidyAmount(Cllease__Contract_Equipment__c eqp) {
             Decimal subsidyAmount = 0.0;
             if(eqp.cllease__Subvention__c != null) {
                 subsidyAmount = eqp.cllease__Subsidy__c;
             }
             return subsidyAmount;
        }

        /*private Decimal getSubsidyAmount(clcommon__Equipment_Detail__c eqp) {
            if(eqpDetailToEqpMapping == null
                || eqpDetailToEqpMapping.size() == 0) {
                throw new CLSCustomException('Missing Contract Equipment to Equipment Details Field mapping. Please Check Company Configuration');
            }

            String namespace = 'cllease__';
            String eqpDetailSubsidyFieldName = eqpDetailToEqpMapping.get(namespace +'Subsidy__c');

            Decimal subsidyAmount = 0.0;
            if(eqpDetailSubsidyFieldName != null
                && eqpDetail.get(eqpDetailSubsidyFieldName) != null) {
                subsidyAmount = (Decimal)eqpDetail.get(eqpDetailSubsidyFieldName);
            }
            return subsidyAmount;
        }*/

        public void terminateEquipment() {
            /*if(isEquipmentDetail) {
                terminateEquipment(this.eqpDetail);
            }
            else {*/
                terminateEquipment(this.eqp);
                for(Id eqpDetailId : eqpDetailsById.keySet()) {
                    Equipment chldEqp = eqpDetailsById.get(eqpDetailId);
                    chldEqp.terminateEquipment();
                }
            //}
        }

        /*private void terminateEquipment(clcommon__Equipment_Detail__c eqpD) {
            eqpD.clcommon__Status__c = LendingConstants.STATUS_TERMINATED;
        }*/

        private void terminateEquipment(Cllease__Contract_Equipment__c eqp) {
            eqp.cllease__Status__c = LendingConstants.STATUS_TERMINATED;
        }

        @testVisible
        private String serialNumber() {
            String serialNum;
            /*if(isEquipmentDetail) {
                serialNum = this.eqpDetail.clcommon__Equipment_Serial_Number__c;
            }
            else {*/
                serialNum = this.eqp.cllease__Equipment_Serial_Number__c;
            //}

            return serialNum;
        }
    }
}