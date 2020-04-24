/**
 * Owner: Cloud Lending Solutions
 * Usage: Following class created as part of Termination Functionality customization
 * Note: Code needs to retire on Upgrading latest versions where Multiple Termination Quotes can be created through API      
 **/
global with sharing class TerminationQuoteViewController extends BaseModalController {
    private static String nsPrefix = CLSCustomUtil.getNSWithUnderScore();
    public Cllease__Termination_Quote_Header__c termQuoteHeader {get; set;}
    public List<TerminationQuoteAction.Equipment> equipmentDetails {get; set;}
    public List<Cllease__Contract_Equipment__c> equipments;
    //public Map<Id, Map<Id, clcommon__Equipment_Detail__c>> eqpDetailMap;
    public Boolean showEquipments {get; set;}
    public Integer noOfSelectedEquipments {get; set;}
    public Integer noOfEquipments {get; set;}
    public Boolean equipmentLevelTermination {get; set;}
    public Set<String> reqStatus;
    public Date effectiveTerminationDate {get; set;}

    private List<Cllease__Termination_Quote_Header__c> existingTerminationQuotes;
    private List<Cllease__Other_Transaction__c> blockingTransactions;

    private Cllease__Lease_Account__c contract;
    public Boolean debugOn {get; set;}
    public String debugStr {get; set;}
    public Boolean isTerminationNotPossible {get; set;}
    public Set<Cllease__Contract_Equipment__c> contractEquipmentToBeTermianted;

    private TerminationActionUnit.TerminationContract termContract;
    private TerminationActionUnit termQUnit;

    public TerminationQuoteViewController(ApexPages.StandardController controller) {

        this.termQuoteHeader = (Cllease__Termination_Quote_Header__c)controller.getRecord();
        this.debugOn = false;
        isTerminationNotPossible = true;
        equipmentLevelTermination = true;
        contract = [SELECT Id,
                        Cllease__Lease_product_Name__r.Cllease__Termination_Lead_Days__c,
                        Cllease__Lease_Product_Name__r.Cllease__Quote_Effective_Days__c,
                        Cllease__Contract_Date__c,
                        Cllease__Enable_Calculation_Setup_Logs__c,
                        Cllease__Lease_Status__c,
                        Cllease__Next_Due_Date__c,
                        Cllease__Next_Due_Generation_Date__c,
                        Cllease__Maturity_Date__c,
                        Cllease__Evergreen_Flag__c,
                        Cllease__Evergreen_End_Date__c,
                        Cllease__Evergreen_Frequency__c,
                        Cllease__Payment_Frequency__c,
                        Cllease__Payment_Method__c,
                        Cllease__Evergreen_Next_Due_Date__c,
                        Cllease__Evergreen_Next_Due_Generation_Date__c,
                        Cllease__Evergreen_Start_Date__c,
                        Cllease__Evergreen_Term__c,
                        Cllease__Current_Evergreen_Term__c,
                        Cllease__Pre_Bill_Days__c,
                        (SELECT Id,
                                Name,
                                Cllease__Payment_Type__c,
                                Cllease__Date__c,
                                Cllease__Rental_Amount__c,
                                Cllease__Tax__c,
                                Cllease__Billed__c,
                                Cllease__Period_Start_Date__c,
                                Cllease__Period_End_Date__c
                         FROM Cllease__Payment_Streams__r
                         WHERE Cllease__Active__c = true
                             AND Cllease__Payment_Type__c IN (:LendingConstants.PAYMENT_STREAM_PAYMENT_TYPE_RENT,
                                                     :LendingConstants.PAYMENT_STREAM_PAYMENT_TYPE_EVERGREEN_RENT,
                                                     :LendingConstants.PAYMENT_STREAM_PAYMENT_TYPE_RESIDUAL)
                         ORDER BY Cllease__Date__c
                        )
                    FROM Cllease__Lease_Account__c
                    WHERE Id = :termQuoteHeader.Cllease__Contract__c];

        if (contract.Cllease__Lease_Status__c == LendingConstants.STATUS_ACTIVE_GOOD_STANDING
                || contract.Cllease__Lease_Status__c == LendingConstants.STATUS_ACTIVE_BAD_STANDING
                || contract.Cllease__Lease_Status__c == LendingConstants.STATUS_EVERGREEN){
            isTerminationNotPossible = false;
        } else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR , 'Contract in status ACTIVE - GOOD STANDING or ACTIVE - BAD STANDING or EVERGREEN can be terminated');
            ApexPages.addMessage(msg);
        }

        reqStatus = new Set<String>();
        reqStatus.add(LendingConstants.CONTRACT_EQUIPMENT_STATUS_TO_BE_TERMINATED);
        reqStatus.add(LendingConstants.MASTER_EQ_LEASED);
        termContract = new TerminationActionUnit.TerminationContract(contract);

        getEquipmentList();
        if(!Test.isRunningTest()) {
            existingTerminationQuotes = termContract.getExistingTerminationQuotes();
            blockingTransactions = termContract.getBlockingOLTs();
        }
        if(debugOn) {
            debugInfo();
        }
        System.debug(LoggingLevel.FINE, 'Total equipments are ' + equipmentDetails.size());
        termQuoteHeader.Cllease__Effective_From__c = Cllease.SystemDateUtil.getCurrentSystemDate();
        termQuoteHeader.Cllease__Effective_To__c = termContract.getTerminationExpiryDate(termQuoteHeader);

        //To avoid the validatin that the Termination_Date__c which is schema level required field is not empty,
        //lets give the value to the same.
        termQuoteHeader.Cllease__Requested_Termination_Date__c = Cllease.SystemDateUtil.getCurrentSystemDate();
        computeEffectiveTermindationDate();

    }

    public void computeDatesAsPerMatchingConfig() {
        // Recomputing dates whenever Quote Type/Reason gets changed. 
        // Computation logic will depend on the matching Termination Config at product level
        termQuoteHeader.Cllease__Effective_To__c = termContract.getTerminationExpiryDate(termQuoteHeader);
        computeEffectiveTermindationDate();
    }

    public void debugInfo() {
        debugStr = 'Contract = \n' + JSON.serializePretty(contract);
        debugStr += '-----------------------------';
        debugStr += 'PaymentStreams = \n' + JSON.serializePretty(contract.cllease__Payment_Streams__r);
    }

    public PageReference getEquipmentList() {
        //System.debug(LoggingLevel.ERROR, 'getEquipmentList called => equipmentLevelTermination = ' + equipmentLevelTermination);
        if(equipmentDetails != null) {
            equipmentDetails.clear();
        }
        else {
            equipmentDetails = new List<TerminationQuoteAction.Equipment>();
        }

        if(equipmentLevelTermination) {
            if(equipments == null || equipments.isEmpty()) {
                String eqpFields = CLSCustomUtil.fetchAllCustomFields('Cllease__Contract_Equipment__c');
                eqpFields += ', ' + nsPrefix + 'Warehouse_Equipment__r.clcommon__Master_Equipment__c';
                eqpFields += ', ' + nsPrefix + 'Warehouse_Equipment__r.clcommon__Equipment_ID__c';
                String contractId = contract.Id;

                String query;

                query = ' SELECT ' + eqpFields +
                    ' FROM Cllease__Contract_Equipment__c ' +
                    ' WHERE cllease__Contract__c =: contractId ' +
                    '   AND cllease__Status__c IN :reqStatus ' +
                    ' ORDER BY Name ASC';

                System.debug(LoggingLevel.DEBUG, 'query = ' + query);

                equipments = Database.query(query);
                System.debug(LoggingLevel.DEBUG, 'equipments = ' + equipments);
            }

            showEquipments = equipments.size() > 1000 ? false : true;
            noOfSelectedEquipments = 0;
            for(Cllease__Contract_Equipment__c equipment : equipments) {
                TerminationQuoteAction.Equipment eq = new TerminationQuoteAction.Equipment(equipment);
                if(eq != null) {
                    System.debug(LoggingLevel.DEBUG, 'eq = ' + eq);
                }
                else {
                    System.debug(LoggingLevel.DEBUG, ' null eq');
                }
                //select the equipment if the full-termination is already selected and the list is being refreshed.
                if(termQuoteHeader.Cllease__Full_Termination__c) {
                    eq.isSelected = true;
                }

                if(eq.isSelected) {
                    noOfSelectedEquipments++;
                }
                equipmentDetails.add(eq);
            }
            noOfEquipments = equipmentDetails.size();

        } 
        // Commenting the Equipment Unit level Termination
        /*else {

            if(eqpDetailMap == null || eqpDetailMap.isEmpty()) {
                Set<String> contractIds = new Set<String>{
                    contract.Id
                };
                eqpDetailMap = EquipmentDetailUtil.getEquipmentDetailsMapForContracts(contractIds, reqStatus);

                // Checking for validation
                if (eqpDetailMap == null || eqpDetailMap.size() == 0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Equipment Details not Attached to Contract, Equipment Detail Termination Not possible'));
                    equipmentLevelTermination = true;
                    noOfEquipments = 0;
                    return null;
                }
            }
            List<clcommon__Equipment_Detail__c> eqpDetails = eqpDetailMap.get(contract.Id).values();

            showEquipments = eqpDetails.size() > 1000 ? false : true;

            noOfSelectedEquipments = 0;
            for(clcommon__Equipment_Detail__c eqpDetail : eqpDetails) {
                TerminationQuoteAction.Equipment eq = new TerminationQuoteAction.Equipment(eqpDetail);
                //select the equipment if the full-termination is already selected and the list is being refreshed.
                if(termQuoteHeader.cllease__Full_Termination__c) {
                    eq.isSelected = true;
                }
                if(eq.isSelected) {
                    noOfSelectedEquipments++;
                }
                System.debug(LoggingLevel.ERROR, 'Eq detail eq = ' + eq);
                equipmentDetails.add(eq);
            }
            noOfEquipments = equipmentDetails.size();
        }*/

        return null;
    }
    
    //all the transactions for the below types are blocking transactions for new termination.
    public void checkEquipment() {
        if(termQuoteHeader.cllease__Full_Termination__c == true) {
            for(TerminationQuoteAction.Equipment equipment : equipmentDetails) {
                equipment.isSelected = true;
            }
        } else {
            for(TerminationQuoteAction.Equipment equipment : equipmentDetails) {
                equipment.isSelected = false;
            }
        }
    }

    public void computeEffectiveTermindationDate() {
        Boolean considerPreBillDays = false;
        TerminationQuoteAction terminationAction = new TerminationQuoteAction();
        cllease__Termination_Config__c terminationConfig = terminationAction.getMatchingTerminationConfig(contract, termQuoteHeader);
        if (terminationConfig != null) {
            // Update the 'Consider Pre Bill Days' flag as per the matching Termination Config.
            considerPreBillDays = terminationConfig.Cllease__Consider_Pre_Bill_Days__c;
            // If Termination is of type 'Third Party Sale', then defaulting the Rebate values to 95%, else setting to null.
            if (terminationConfig.Cllease__Third_Party_Sale__c) {
                if (!termQuoteHeader.Cllease__Third_Party_Sale__c) {
                    termQuoteHeader.Cllease__Third_Party_Sale__c = true;
                    termQuoteHeader.Cllease__Rebate_Percentage__c = 95;
                }
            }
            else if (!terminationConfig.Cllease__Third_Party_Sale__c) {
                termQuoteHeader.Cllease__Third_Party_Sale__c = false;
                termQuoteHeader.Cllease__Third_Party_Sale_Amount__c = null;
                termQuoteHeader.Cllease__Rebate_Percentage__c = null;
                termQuoteHeader.Cllease__Rebate_Amount__c = null;
            }
        }
        // Calculating the Effective Termination date considering the Pre-Bill days, as configured in the matching Termination Configuration
        effectiveTerminationDate = termContract.getEffectiveTerminationDate(termQuoteHeader.Cllease__Requested_Termination_Date__c, considerPreBillDays);
        termQuoteHeader.Cllease__Termination_Date__c = effectiveTerminationDate;
        return;
    }

    public Boolean validateAndUpdateThirdPartySaleDetails(TerminationQuoteAction terminationAction, Map<Id, TerminationQuoteAction.Equipment> equipmentsToBeTerminated) {
        // Fetching Asset Sale details for the selected Equipment
        Map<Id, Decimal> saleAmountbyColId = new Map<Id, Decimal>();
        List<clcommon__Equipment_Transaction__c> equipmentTxns = terminationAction.getThirdPartySaleDetails(equipmentsToBeTerminated.keyset());
        for (clcommon__Equipment_Transaction__c equipmentTxn : equipmentTxns) {
            if (equipmentTxn!= null) {
                // There should be only 1 transaction per Equipment for the Sale.
                if (saleAmountbyColId != null && saleAmountbyColId.containsKey(equipmentTxn.clcommon__Collateral__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Multiple Sale Transaction present for Equipment'));
                    return false;
                }
                saleAmountbyColId.put(equipmentTxn.clcommon__Collateral__c, equipmentTxn.clcommon__Transaction_Amount__c);
            }
        }
        // Validate whether all the Equipment selected are sold as part of Third Party Asset Sale.
        Decimal saleAmount = 0;
        for (TerminationQuoteAction.Equipment equipment : equipmentsToBeTerminated.values()) {
            if (saleAmountbyColId != null && !saleAmountbyColId.containskey(equipment.eqp.Cllease__Warehouse_Equipment__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Third Party Asset Sale not yet complete for '+ equipment.eqp.Name));
                return false;
            }
            saleAmount += saleAmountbyColId.get(equipment.eqp.Cllease__Warehouse_Equipment__c);
        }
        termQuoteHeader.Cllease__Third_Party_Sale_Amount__c = cllease.ValueUtil.round(saleAmount);
        termQuoteHeader.Cllease__Rebate_Amount__c = Cllease.ValueUtil.round(termQuoteHeader.Cllease__Rebate_Percentage__c * termQuoteHeader.Cllease__Third_Party_Sale_Amount__c / 100);
        return true;
    }

    public void validateThirdPartySaleRebate() {
        if (termQuoteHeader.Cllease__Rebate_Percentage__c == null || termQuoteHeader.Cllease__Rebate_Percentage__c < 0 || termQuoteHeader.Cllease__Rebate_Percentage__c > 100) {
            // Resetting the Rebate Percentage to 95% whenever an invalid input is given
            termQuoteHeader.Cllease__Rebate_Percentage__c = 95;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Rebate Percentage must be between 0 and 100'));
            return;
        }
    }

    public Boolean validate(Map<Id, TerminationQuoteAction.Equipment> equipMap) {
        System.debug(LoggingLevel.DEBUG, 'inside validate 1');
        if(termQuoteHeader.Cllease__Quote_Reason__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Termination quote reason must be entered.'));
            return false;
        }
        System.debug(LoggingLevel.DEBUG, 'inside validate 2');
        if(termQuoteHeader.Cllease__Quote_Type__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Termination quote Type must be entered'));
            return false;
        }
        System.debug(LoggingLevel.DEBUG, 'inside validate 3');
        if(termQuoteHeader.Cllease__Termination_Date__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Termination Date must be Entered.'));
            return false;
        }

        if(termQuoteHeader.Cllease__Effective_From__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Quote Effective From Date must be Entered.'));
            return false;
        }
        System.debug(LoggingLevel.DEBUG, 'inside validate 4');
        if(validateTerminationDate() == false) {
            return false;
        }
        System.debug(LoggingLevel.DEBUG, 'inside validate 5');
        if(equipMap.isEmpty())  {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'At Least One Equipment must be Selected.'));
            return false;
        }
        System.debug(LoggingLevel.DEBUG, 'inside validate 6');
        String error = TerminationUtil.validateParentChildEquipment(new List<Cllease__Contract_Equipment__c>(contractEquipmentToBeTermianted), TerminationUtil.Action.TERMINATED);
        if(! String.isBlank(error)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            return false;
        }
        System.debug(LoggingLevel.DEBUG, 'inside validate 7');

        return true;
    }

    private Boolean validateTerminationDate() {
        // termination date  can have following situation.
        // 1. The contract is not /will not be matured at the time of termination date.
        // 8. The termination date is before existing future termination dates.
        // 9. The termination date is before the blocking transaction execution date.
        if(blockingTransactions != null && !blockingTransactions.isEmpty()) {
            //9
            Date lastBlockingTransactionDate = blockingTransactions.get(0).cllease__Txn_Date__c;
            if (termQuoteHeader.cllease__Termination_Date__c < lastBlockingTransactionDate) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Termination Date can not be before ' + blockingTransactions.get(0).Cllease__Transaction_Type__c + ' date.'));
                return false;
            }
        }

        //8
        if(existingTerminationQuotes != null
            && existingTerminationQuotes.size() > 0) {
            Date latestAcceptedDate = existingTerminationQuotes.get(0).cllease__Termination_Date__c;
            if (termQuoteHeader.cllease__Termination_Date__c < latestAcceptedDate) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Termination Date can not be before the last Accepted/processed Termination quote of contract'));
                return false;
            }
        }
        System.debug(LoggingLevel.DEBUG, 'inside validateTerminationDate 3');
        //7, 3, 1
        return true;
    }

    //This is an interesting function.  If contract has many equipment (or equipmentDetails), it is cumbersome for user
    //to select many of these equipments for terminating.  The user, in this case are expected to do the following.
    //1. Create CSV of equipment / equipmentdetails with Status__c marked as 'TO BE TERMINATED'.
    //2. Go to create Quote option.
    //3. save quote or cancel quote.
    //When user  goes to create quote - and selects apt flag based on his CSV uploaded (equipmentLevelTermination)
    //the equipments are selected if the status is already 'TO BE TERMINATED'.
    //If customer saves the equipment, by unselecting some of the selected equipments with status as 'TO BE TERMINATED' ,
    //or if the customer cancncels the quotes, system reverts the status from 'TO BE TERMINATED' to 'LEASED'.
    //This has to be done atomically so that any further quote creation via CSV file is avoided.
    private void revertEquipmentStatus() {
        //skip calculation setup
        contract.cllease__Enable_Calculation_Setup_Logs__c = true;
        update contract;
        List<Cllease__Contract_Equipment__c> equipmentsToBeUpdated = new List<Cllease__Contract_Equipment__c>();
        //List<clcommon__Equipment_Detail__c> eqpDetailsToBeUpdated = new List<clcommon__Equipment_Detail__c>();
        if(equipmentLevelTermination) {
            for(TerminationQuoteAction.Equipment equipment : equipmentDetails) {
                if(equipment.eqp.cllease__Status__c.equalsIgnoreCase(LendingConstants.CONTRACT_EQUIPMENT_STATUS_TO_BE_TERMINATED)) {
                    equipment.eqp.cllease__Status__c = LendingConstants.MASTER_EQ_LEASED;
                    equipmentsToBeUpdated.add(equipment.eqp);
                }
            }
            if(equipmentsToBeUpdated.size() > 0) {
                cllease.EquipmentOperations.updateEquipment(equipmentsToBeUpdated);
            }

        } 
        // Commenting the Equipment Unit level Termination
        /*else {
            if(equipmentDetails != null && equipmentDetails.size() > 0) {
                for(TerminationQuoteAction.Equipment equipment : equipmentDetails) {
                    System.debug(LoggingLevel.ERROR, 'revertEquipmentStatus(): equipment = ' + equipment);
                    if(equipment.eqpDetail.clcommon__Status__c.equalsIgnoreCase(LendingConstants.CONTRACT_EQUIPMENT_STATUS_TO_BE_TERMINATED)) {
                        equipment.eqpDetail.clcommon__Status__c = LendingConstants.MASTER_EQ_LEASED;
                        eqpDetailsToBeUpdated.add(equipment.eqpDetail);
                    }
                }
                if(eqpDetailsToBeUpdated.size() > 0) {
                    //EquipmentDetailOperations.upsertEquipmentDetails(eqpDetailsToBeUpdated);
                }
            }
        }*/

        //restore calculation setup flag
        contract.cllease__Enable_Calculation_Setup_Logs__c = false;
        update contract;
    }

    global PageReference cancelQuote() {
        revertEquipmentStatus();
        return new PageReference('/' + contract.Id);
    }

    global PageReference saveQuote() {
        try {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                'Using Effective date ' + effectiveTerminationDate + ' instead of '
                + termQuoteHeader.cllease__Termination_Date__c + ' as termination date'));

            //termQuoteHeader.Termination_Date__c = effectiveTerminationDate;
            computeEffectiveTermindationDate();

            Map<Id, TerminationQuoteAction.Equipment> equipmentsToBeTerminated;
            equipmentsToBeTerminated = getSelectedEquipmentByIds();

            if (!validate(equipmentsToBeTerminated)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'EXCEPTION'));
                return null;
            }
            System.debug(LoggingLevel.ERROR, 'validation successfull  ' );
            termQuoteHeader.cllease__Is_Equipment_Termination__c = equipmentLevelTermination;

            revertEquipmentStatus();
            System.debug(LoggingLevel.ERROR, 'revert equipment successfull  ' );
            System.debug(LoggingLevel.ERROR, 'Number of equipments to be terminated : ' + equipmentsToBeTerminated.size());

            TerminationQuoteAction terminationAction = new TerminationQuoteAction();
            // If it is a 'Third Party Sale' type Termination, fetch and update Third Party Sale related details.
            if (termQuoteHeader.cllease__Third_Party_Sale__c) {
                if (!validateAndUpdateThirdPartySaleDetails(terminationAction, equipmentsToBeTerminated)) {
                    return null;
                }
            }

            String fields = TerminationUtil.getTerminationLineFieldAPINames();
            String query = TerminationUtil.getContractsForTermination(fields, new Set<String>{contract.Id}, null);
            System.debug(LoggingLevel.ERROR, 'lease-account requery =  ' + query );
            Cllease__Lease_Account__c leaseAccount = (Cllease__Lease_Account__c)Database.query(query);

            termQUnit =  terminationAction.createTerminationQuote(leaseAccount, equipmentsToBeTerminated, termQuoteHeader);
            terminationAction.updateAll(termQUnit);

            PageReference accPage = new PageReference('/apex/terminationGenQuote?id='+termQuoteHeader.Id);
            return actionSuccessfulPageRef(accPage);
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            System.debug(LoggingLevel.ERROR, 'exception : ' + e.getMessage() + ' \n stack trace : ' + e.getStackTraceString());
            return null;
        }
    }

    @testVisible
    private Map<Id, TerminationQuoteAction.Equipment> getSelectedEquipmentByIds() {
        Map<Id, TerminationQuoteAction.Equipment> equipmentsToBeTerminated = new Map<Id, TerminationQuoteAction.Equipment>();
        System.debug(LoggingLevel.ERROR, 'equipmentDetails size is  ' + equipmentDetails.size());
        System.debug(LoggingLevel.ERROR, 'equipmentDetails  ' + equipmentDetails);
        contractEquipmentToBeTermianted = new Set<Cllease__Contract_Equipment__c>();
        for(TerminationQuoteAction.Equipment equipment : equipmentDetails) {
            if(equipment.isSelected) {
                equipmentsToBeTerminated.put(equipment.getId(), equipment);
                if(equipmentLevelTermination){
                    contractEquipmentToBeTermianted.add(equipment.eqp); 
                }
            }
        }
        return equipmentsToBeTerminated;
    }

    @testVisible
    private void setBlockingOLTsAndExistingTerminations(List<Cllease__Other_Transaction__c> blockingTransactions,
                                                        List<Cllease__Termination_Quote_Header__c> existingTerminationQuoteHeaders) {
        if(!Test.isRunningTest()) {
            return;
        }

        this.blockingTransactions = blockingTransactions;
        this.existingTerminationQuotes = existingTerminationQuoteHeaders;
    }
}