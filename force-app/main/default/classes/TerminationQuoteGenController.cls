/**
 * Owner: Cloud Lending Solutions
 * Usage: Following class created as part of Termination Functionality customization
 * Note: Code needs to retire on Upgrading latest versions where Multiple Termination Quotes can be created through API      
 **/
global with sharing class TerminationQuoteGenController extends BaseModalController {

    private static String nsPrefix = CLSCustomUtil.getNSWithUnderScore();
    public List<QuoteLine> quoteLines {get; set;}
    public Integer editableLineNumber {get;set;}
    public Integer totalEquipments {get; set;}
    public Integer noOfSelectedEquipments {get; set;}
    public cllease__Termination_Quote_Header__c termQuoteHeader {get; set;}
    public List<TerminationQuoteAction.Equipment> equipments {get; set;}
	public Boolean showEquipments {get; set;}
    private Set<Id> terminationEquipmentIdSet;
    private List<cllease__Termination_Quote_Header__c> existingTerminationQuotes;
    private List<cllease__Other_Transaction__c> blockingTransactions;
    private TerminationActionUnit.TerminationContract termContract;
    private cllease__Lease_Account__c contract;

    public TerminationQuoteGenController(ApexPages.StandardController controller) {
        String param = ApexPages.currentPage().getParameters().get('Id');
        Id termQuoteHeaderId;
        if(param != null) {
            try {
                termQuoteHeaderId = TerminationUtil.getSafeId(param, cllease__Termination_Quote_Header__c.SObjectType);
            }
            catch(Exception  ex) {
                System.debug(LoggingLevel.ERROR, 'provided leaseId parameter is not valid Id. Exception ex = ' + ex);
                throw new CLSCustomException('Invalid value for parameter leaseId. Ex = ' + ex);
            }
        }
        termQuoteHeader =  getQuoteHeader(termQuoteHeaderId);

        String aggregateQuery = '';
        String contractId = termQuoteHeader.cllease__Contract__c;
        contract = [SELECT Id,
                        cllease__Lease_product_Name__r.cllease__Termination_Lead_Days__c,
                        cllease__Lease_Product_Name__r.cllease__Quote_Effective_Days__c,
                        cllease__Contract_Date__c,
                        cllease__Enable_Calculation_Setup_Logs__c,
                        cllease__Lease_Status__c,
                        cllease__Next_Due_Date__c,
                        cllease__Next_Due_Generation_Date__c,
                        cllease__Maturity_Date__c,
                        cllease__Evergreen_Flag__c,
                        cllease__Evergreen_End_Date__c,
                        cllease__Evergreen_Frequency__c,
                        cllease__Payment_Frequency__c,
                        cllease__Payment_Method__c,
                        cllease__Pre_Bill_Days__c,
                        cllease__Evergreen_Next_Due_Date__c,
                        cllease__Evergreen_Next_Due_Generation_Date__c,
                        cllease__Evergreen_Start_Date__c,
                        cllease__Evergreen_Term__c,
                        cllease__Current_Evergreen_Term__c,
                        (SELECT Id,
                                Name,
                                cllease__Payment_Type__c,
                                cllease__Date__c,
                                cllease__Rental_Amount__c,
                                cllease__Tax__c,
                                cllease__Billed__c,
                                cllease__Period_Start_Date__c,
                                cllease__Period_End_Date__c
                         FROM cllease__Payment_Streams__r
                         WHERE cllease__Active__c = true
                             AND cllease__Payment_Type__c IN ('RENT', 'EVERGREEN RENT','RESIDUAL')
                         ORDER BY cllease__Date__c
                        )
                    FROM cllease__Lease_Account__c
                    WHERE Id = :termQuoteHeader.cllease__Contract__c];

        equipments = new List<TerminationQuoteAction.Equipment>();

        terminationEquipmentIdSet = new Set<Id>();
        // Checking for total no of Equipment / Equipment Details
        if(termQuoteHeader.cllease__Is_Equipment_Termination__c) {
            // Looping through all Termination Quote Equipments for Unit Ids
            for(cllease__Termination_Quote_Equipment__c quoteEqp : termQuoteHeader.cllease__Termination_Quote_Equipments__r) {
                if(quoteEqp.cllease__Contract_Equipment__c != null) {
                    terminationEquipmentIdSet.add(quoteEqp.cllease__Contract_Equipment__c);
                }
            }

            // Query Equipments reserved for termination
            String eqpFields  = CLSCustomUtil.fetchAllCustomFields('cllease__Contract_Equipment__c');
            eqpFields += ', ' + nsPrefix + 'Warehouse_Equipment__r.clcommon__Master_Equipment__c';
            eqpFields += ', ' + nsPrefix + 'Warehouse_Equipment__r.clcommon__Equipment_ID__c';

            String query = ' SELECT '+ eqpFields +
                            ' FROM cllease__Contract_Equipment__c '+
                            ' WHERE Id IN :terminationEquipmentIdSet '+
                            ' ORDER BY Name';

            List<cllease__Contract_Equipment__c> contractEqps = Database.query(query);

            for(cllease__Contract_Equipment__c contractEqp : contractEqps) {
                TerminationQuoteAction.Equipment unit = new TerminationQuoteAction.Equipment(contractEqp);
                equipments.add(unit);
            }

            // Getting total no of Equipments Count
            List<AggregateResult> res = [SELECT count(Id) noOfEquipments
                                         FROM cllease__Contract_Equipment__c
                                         WHERE cllease__Contract__c = :termQuoteHeader.cllease__Contract__c
                                             AND cllease__Status__c in ('LEASED')
                                         GROUP BY cllease__Contract__c];
            if(res.size() > 0) {
                totalEquipments = (Integer) res.get(0).get('noOfEquipments');
            }

        } 
        // Commenting the Equipment Unit level Termination
        /*else {
            // Looping through all Termination Quote Equipments for Unit Ids
            for(cllease__Termination_Quote_Equipment__c quoteEqp : termQuoteHeader.cllease__Termination_Quote_Equipments__r) {
                if(quoteEqp.cllease__Equipment_Detail__c != null) {
                    terminationEquipmentIdSet.add(quoteEqp.cllease__Equipment_Detail__c);
                }
            }

            Set<String> reqStatus = new Set<String>();
            reqStatus.add(LendingConstants.CONTRACT_EQUIPMENT_STATUS_TO_BE_TERMINATED);
            reqStatus.add(LendingConstants.MASTER_EQ_LEASED);

            Set<String> contractIds = new Set<String>{contractId};
            Map<Id, Map<Id, clcommon__Equipment_Detail__c>> contractEqpDetailMap;
            contractEqpDetailMap   = EquipmentDetailUtil.getEquipmentDetailsMapForContracts(contractIds, reqStatus);

            if(contractEqpDetailMap == null) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No Equipment Details with Leased status. Please check Details...'));
            }
            else {
                Map<Id, clcommon__Equipment_Detail__c> eqpDetailsMap = contractEqpDetailMap.get(contractId);
                totalEquipments = eqpDetailsMap.size();
                // Query Equipments reserved for termination
                for(clcommon__Equipment_Detail__c eqpDetail : eqpDetailsMap.values()) {
                    if(terminationEquipmentIdSet.contains(eqpDetail.Id)) {
                        TerminationQuoteAction.Equipment unit = new TerminationQuoteAction.Equipment(eqpDetail);
                        equipments.add(unit);
                    }
                }
            }
        } */

        quoteLines = new List <QuoteLine>();
        Integer counter = 0;
        for(cllease__Termination_Quote_line__c line : termQuoteHeader.cllease__Termination_Quote_lines__r) {
            // Initialize the record to be not editable
            quoteLines.add(new QuoteLine(line, false, counter++));
        }

        termContract = new TerminationActionUnit.TerminationContract(contract);

        if(!Test.isRunningTest()) {
            existingTerminationQuotes = termContract.getExistingTerminationQuotes();
            blockingTransactions = termContract.getBlockingOLTs();
        }

        noOfSelectedEquipments = equipments.size();
		showEquipments = noOfSelectedEquipments > 1000 ? false : true;
    }

    private Boolean validateTerminationDate() {
        // termination date  can have following situation.
        // 1. The contract is not /will not be matured at the time of termination date.
        // 2. The contract is/will be matured, but is not enabled for evergreen.
        // 3. The contract is/will be matured and is under evergreen period, before evergreen-end-date (if not null)
        // 4. The contract is/will be matured and is under evergreen period, after evergreen-end-date (if not null).
        // 5. The contract is maturing on Termination Date
        // 6. The contract evergreen end date (not null) is same as Termination date.
        // 7. The contract evergreen end date is not given
        // 8. The termination date is before existing future termination dates.
        // 9. The termination date is before the blocking transaction execution date.

        if(blockingTransactions != null && !blockingTransactions.isEmpty()) {
            //9
            Date lastBlockingTransactionDate = blockingTransactions.get(0).cllease__Txn_Date__c;
            if (termQuoteHeader.cllease__Termination_Date__c < lastBlockingTransactionDate) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Termination Date can not be before ' + blockingTransactions.get(0).cllease__Transaction_Type__c + ' date.'));
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

        return true;
    }

    public void enableRowEditAction() {
        // This enables the Visualforce page to determine which row to edit
        quoteLines.get( editableLineNumber ).editable = true;
    }

    public String recalculate() {
        try {
            Decimal totalAmount = 0;
            for(cllease__Termination_Quote_line__c line: termQuoteHeader.cllease__Termination_Quote_lines__r) {
                System.debug(LoggingLevel.FINE, 'Line type is ' + line.cllease__Line_Type__c+ ' amount: '+line.cllease__Amount__c);
                if(line.cllease__Line_Type__c == 'QUOTE DISCOUNT' && line.cllease__Amount__c >0) {
                    return 'DISCOUNT ERROR';
                }
                if(line.cllease__Add_To_Quote_Amount__c || line.cllease__Amount_Type__c == 'FEE') {
                    totalAmount += line.cllease__amount__c;
                }
                //TODO Validate EXCESS quote line
                if(line.cllease__Line_Type__c == 'EXCESS') {
                    cllease__Lease_Account__c leaseAcc = [SELECT Id,
                                                    cllease__Excess__c
                                                 FROM cllease__Lease_Account__c
                                                 WHERE Id = :termQuoteHeader.cllease__Contract__c];
                    //Instead of checking from the account balances, check the excess field in contract.
                    leaseAcc.cllease__Excess__c = (leaseAcc.cllease__Excess__c == null) ? 0 : leaseAcc.cllease__Excess__c;
                    if(line.cllease__amount__c.abs() > leaseAcc.cllease__Excess__c) {
                        return 'EXCESS ERROR';
                    }
                    totalAmount -= line.cllease__Amount__c.abs();
                    line.cllease__Amount__c= -line.cllease__Amount__c.abs();
                }
            }
            cllease__Termination_Quote_Header__c qh = new cllease__Termination_Quote_Header__c();
            qh = termQuoteHeader;
            qh.cllease__quote_amount__c = totalAmount;
            update qh;
            return 'Done';
        } catch (Exception e) {
          createMessage(ApexPages.severity.ERROR,'Exception: '+e.getMessage());
          return null;
        }
    }

    global PageReference saveRowEditAction() {
        try {
            // This enables the Visualforce page to determine which row to disable the edit save the record
            quoteLines.get(editableLineNumber).editable = false;

            // If Rebate Amount is updated, then same has to be updated in the Termination Header.
            cllease__Termination_Quote_line__c currentLine = quoteLines.get(editableLineNumber).currentLine;
            if (currentLine.cllease__Line_Type__c.equals(LendingConstants.TERMINATION_QUOTE_LINE_TYPE_REBATE_AMOUNT)) {
                // Validate whether Rebate Amount is negative and it is not exceeding the Third party Sale Amount.
                if (currentLine.cllease__Amount__c > 0 || currentLine.cllease__Amount__c < -termQuoteHeader.cllease__Third_Party_Sale_Amount__c) {
                    createMessage(ApexPages.severity.ERROR,'Rebate Amount must be between 0 and -'+termQuoteHeader.cllease__Third_Party_Sale_Amount__c);
                    enableRowEditAction();
                    return null;
                }
                // Update Rebate Amount/Percentage for Termination Header.
                termQuoteHeader.cllease__Rebate_Amount__c = cllease.ValueUtil.round(-currentLine.cllease__Amount__c);
                termQuoteHeader.cllease__Rebate_Percentage__c = termQuoteHeader.cllease__Rebate_Amount__c / termQuoteHeader.cllease__Third_Party_Sale_Amount__c * 100;
            }
            
            Update quoteLines.get(editableLineNumber).currentLine;

            String retvalue = recalculate();
            if(retvalue == 'DISCOUNT ERROR') {
                 createMessage(ApexPages.severity.ERROR,'Quote Discount Amount must be negative');
                 enableRowEditAction();
                 return null;
            } else if(retvalue == 'EXCESS ERROR') {
                 createMessage(ApexPages.severity.ERROR,'Quote Excess Amount cannot be greater than Excess Cash Balance');
                 enableRowEditAction();
            }
            return null;
        } catch (Exception e) {
          createMessage(ApexPages.severity.ERROR,'Exception: '+e.getMessage());
          return null;
        }
    }

    @testVisible
    private void setBlockingOLTsAndExistingTerminations(List<cllease__Other_Transaction__c> blockingTransactions,
                                                        List<cllease__Termination_Quote_Header__c> existingTerminationQuoteHeaders) {
        if(!Test.isRunningTest()) {
            return;
        }

        this.blockingTransactions = blockingTransactions;
        this.existingTerminationQuotes = existingTerminationQuoteHeaders;
    }

    public class QuoteLine {
        public cllease__Termination_Quote_line__c currentLine {get; set;}
        public Boolean editable {get; set;}
        public Integer counterNumber {get; set;}

        public QuoteLine(cllease__Termination_Quote_line__c currentLine,
                            Boolean editable,
                            Integer counterNumber) {
            this.currentLine = currentLine;
            this.editable = editable;
            this.counterNumber = counterNumber;
        }
    }

    global PageReference approveQuote() {
        // one can approve the termination only before effective-to-date.
        if(termQuoteHeader.cllease__Effective_To__c < cllease.SystemDateUtil.getCurrentSystemDate()) {
            createMessage(ApexPages.severity.ERROR, 'Outdated Effective-To Date! Can not approve.');
            return null;
        }

        //check if termination date i still valid.
        if(!validateTerminationDate()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'EXCEPTION'));
            return null;
        }

        System.debug(LoggingLevel.FINE, 'Quote status  is ' + termQuoteHeader.cllease__status__c);
        termQuoteHeader.cllease__status__c = 'APPROVED';
        Update termQuoteHeader;
        return null;
    }

    global PageReference acceptQuote() {

        // one can accept the termination only before effective-to-date.
        if(termQuoteHeader.cllease__Effective_To__c < cllease.SystemDateUtil.getCurrentSystemDate()) {
            createMessage(ApexPages.severity.ERROR, 'Outdated Effective-To Date! Can not accept.');
            return null;
        }

        if(termQuoteHeader.cllease__Status__c.equalsIgnoreCase('APPROVED') == false) {
            createMessage(ApexPages.severity.ERROR, 'Quote must be approved before it is accepted.');
            return null;
        }

        //check if termination date i still valid.
         if(!validateTerminationDate()) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'EXCEPTION'));
             return null;
         }

        termQuoteHeader.cllease__Status__c = 'ACCEPTED';
        Update termQuoteHeader;
        return null;
    }

    global PageReference cancelQuote() {
        //SecureDML.upsertRecords(QuoteLines);
        cllease__Termination_Quote_Header__c qh = new cllease__Termination_Quote_Header__c();
        qh = termQuoteHeader;
        qh.cllease__status__c = 'CANCELED';
        Update qh;
        return null;
    }

    global PageReference exitQuote() {
        PageReference accPage = new PageReference('/apex/tabbedLeaseAccount?id='+ termQuoteHeader.cllease__contract__c);
        return actionSuccessfulPageRef(accPage);
    }

    global PageReference processQuote() {

        if(termQuoteHeader.cllease__Status__c.equalsIgnoreCase('ACCEPTED') == false) {
            createMessage(ApexPages.severity.ERROR, 'Quote must be Accepted before it is processed.');
            return null;
        }

        //check if termination date i still valid.
        if(!validateTerminationDate()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'EXCEPTION'));
            return null;
        }

        SavePoint sp = Database.setSavePoint();
        try {
            cllease__Lease_Account__c lease;
            Set<Id> equipmentIds = new Set<Id>();

            if(termQuoteHeader.cllease__Is_Equipment_Termination__c) {
                for(TerminationQuoteAction.Equipment equipment : equipments) {
                    equipmentIds.add(equipment.eqp.Id);
                }

                List<cllease__Contract_Equipment__c> allEquipments = [SELECT Id
                                                                FROM cllease__Contract_Equipment__c
                                                                WHERE cllease__Contract__c = :termQuoteHeader.cllease__contract__c
                                                                    AND Id in :equipmentIds
                                                                    AND cllease__Status__c = :LendingConstants.CONTRACT_EQUIPMENT_STATUS_TERMINATED];
                if(allEquipments.size() > 0) {
                    createMessage(ApexPages.severity.ERROR,'Some of the Assets are already terminated, Please Modify Quote.');
                    return null;
                }

            } 
            //Commenting the Equipment Unit level Termination
            /*else {

                for(TerminationQuoteAction.Equipment equipment : equipments) {
                    equipmentIds.add(equipment.eqpDetail.Id);
                }
                // check for all Colleterals linked to contract
                List<clcommon__Equipment_Detail__c> allEqpDetails = [SELECT Id
                                                                        FROM clcommon__Equipment_Detail__c
                                                                        WHERE Id IN :equipmentIds
                                                                            AND clcommon__Status__c = :LendingConstants.CONTRACT_EQUIPMENT_STATUS_TERMINATED];
                if(allEqpDetails.size() > 0) {
                    createMessage(ApexPages.severity.ERROR,'Some of the Equipment Details are already terminated, Please Modify Quote.');
                    return null;
                }
            }*/

            Set<Id> contractIdSet = new Set<Id> { termQuoteHeader.cllease__Contract__c} ;
            //we have requested-date and termination-date. termination-date is always the payment-date of period, next to period of requested date.
            //lets find the payment-setup where the requested date falls.
            List<cllease__Payment_Stream__c> pmtStreams = contract.cllease__Payment_Streams__r;
            Integer count11 = 0;
            Integer foundIndex = -1;
            for(cllease__Payment_Stream__c pmtStream : pmtStreams) {
                if(pmtStream.cllease__Payment_Type__c != LendingConstants.PAYMENT_STREAM_PAYMENT_TYPE_RENT
                    && pmtStream.cllease__Payment_Type__c != LendingConstants.PAYMENT_STREAM_PAYMENT_TYPE_EVERGREEN_RENT) {
                    continue;
                }
                count11++;
                if(pmtStream.cllease__Period_Start_Date__c <= termQuoteHeader.cllease__Requested_Termination_Date__c
                    && termQuoteHeader.cllease__Requested_Termination_Date__c <= pmtStream.cllease__Period_End_Date__c) {
                    foundIndex = count11;
                    break;
                }

            }
            if(foundIndex == -1) {
                throw new CLSCustomException ('Requested date seems to be modified / or streams modified - no matching period found');
            }

            Date billsToBeCreatedDate = null;

            //create all bills before termination date. as termination date is set to period start date of next period,
            //no bills should be created for period of termination date. for advance contract period-start-date and payment
            //date is same, hence the bills should be created for any date just before the termination date.
            billsToBeCreatedDate = termQuoteHeader.cllease__Termination_Date__c;

            //till the next period's start date, the contract needs to be reversed.
            /*Date contractToBeReversedDate = termQuoteHeader.cllease__Termination_Date__c;

            RestructuredContractReversalHandler.restructureLeaseTransactionsToDate(termQuoteHeader.Contract__c,
                                            contractToBeReversedDate);
            */
            if(billsToBeCreatedDate != null) {
                // RECHECK
                /*Date terminationDate = billsToBeCreatedDate.addDays((Integer)(-1*contract.cllease__Pre_Bill_Days__c) -1); // we shuould  consider prebill days

                String billGenerationQuery = ProcessJobQueryUtil1.getBillGenetorJobQuery(terminationDate,
                                                                            null, contractIdSet);
                List<cllease__Lease_Account__c> billLeaseAccounts = (List<cllease__Lease_Account__c>) Database.query(billGenerationQuery);
                BillGeneratorHandler billGenerationHandle = new BillGeneratorHandler(terminationDate);
                billGenerationHandle.process(billLeaseAccounts);

                String dueDetailGenerationQuery = ProcessJobQueryUtil1.getBillDetailGeneratorJobQuery(terminationDate,
                                                                                null, contractIdSet);
                List<Lease_account_Due_Details__c> dueDetailGenBills = (List<Lease_account_Due_Details__c>) Database.query(dueDetailGenerationQuery);
                BillDetailGeneratorHandler billingHandler = new BillDetailGeneratorHandler(terminationDate);
                billingHandler.process(dueDetailGenBills);*/
            }

            String query = TerminationUtil.getContractsForTermination(null, contractIdSet, null);
            lease = Database.query(query);
            cllease__Termination_Quote_Header__c quoteHeader0 = getQuoteHeader(termQuoteHeader.Id);
            System.debug(LoggingLevel.FINE, '######## quoteHeader0 : '+quoteHeader0);

            EquipmentDomainObject terminatedEquip = new EquipmentDomainObject(lease, terminationEquipmentIdSet, termQuoteHeader.cllease__Is_Equipment_Termination__c);
            terminatedEquip.updateWarehouseDtls(termQuoteHeader.cllease__Quote_Type__c, termQuoteHeader.cllease__Termination_Date__c);
            TerminationQuoteAction action = new TerminationQuoteAction(new Map<cllease__Lease_Account__c, cllease__Termination_Quote_Header__c>{lease => quoteHeader0});
            TerminationActionUnit quoteHeader2 = action.processTerminationQuote(lease,
                                                                                quoteHeader0,
                                                                                quoteHeader0.cllease__Termination_Quote_Lines__r,
                                                                                quoteHeader0.cllease__Termination_Quote_Equipments__r);
            
            action.updateAll(quoteHeader2);
            termQuoteHeader = quoteHeader2.qh;
            return null;
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + '\n Stack : ' + e.getStackTraceString());
            createMessage(ApexPages.severity.ERROR,'Process Quote - Exception: '+e.getMessage());
            return null;
        }
    }

    private cllease__Termination_Quote_Header__c getQuoteHeader(Id quoteHeaderId) {
        List<cllease__Termination_Quote_Header__c> quoteHeaders;
        quoteHeaders = TerminationUtil.getQuoteHeaders(quoteHeaderId);
        System.debug(LoggingLevel.DEBUG, '######## quoteHeader2 : '+quoteHeaders);
        return quoteHeaders.get(0);
    }

    global PageReference processTermination() {
        SavePoint sp = Database.setSavePoint();
        try {
            Boolean quoteDuePaid = true;
            Boolean quoteChargePaid = true;
            cllease__Lease_Account__c contract = [SELECT Id,
                                            cllease__Lease_Product_Name__c,
                                            cllease__Lease_Product_Name__r.cllease__Wait_for_Cash__c,
                                            cllease__Excess__c,
                                            (SELECT Id,
                                                Name,
                                                cllease__Balance_Type__c,
                                                cllease__Balance_Sub_Type__c,
                                                cllease__Posted_Amount__c,
                                                cllease__Closing_Balance_Amount__c
                                            FROM cllease__Cash_Account_Balances__r),
                                            (SELECT Id, Name
                                                FROM cllease__Dues_Details__r
                                                WHERE cllease__quote_header__c = :termQuoteHeader.id
                                                    AND cllease__Payment_Satisfied__c = false),
                                            (SELECT Id
                                                FROM cllease__Charges__r
                                                WHERE cllease__quote_header__c = :termQuoteHeader.id
                                                    AND cllease__Paid__c = false)
                                        FROM cllease__Lease_Account__c
                                        WHERE Id =:termQuoteHeader.cllease__contract__c];



            if(contract.cllease__Dues_Details__r.size() > 0) {
                quoteDuePaid = false;
            }
            if(contract.cllease__Charges__r.size() > 0) {
                quoteChargePaid = false;
            }

            System.debug(LoggingLevel.ERROR, 'quoteDuePaid = ' + quoteDuePaid);
            System.debug(LoggingLevel.ERROR, 'quoteChargePaid = ' + quoteChargePaid);
            System.debug(LoggingLevel.ERROR, 'contract.Lease_Product_Name__r.cllease__Wait_for_Cash__c = ' + contract.cllease__Lease_Product_Name__r.cllease__Wait_for_Cash__c);

            List<cllease__Contract_Equipment__c> equipmentstoBeTerminated = new List<cllease__Contract_Equipment__c>();
            List<clcommon__Equipment_Detail__c> eqpDetailsToBeTerminated = new List<clcommon__Equipment_Detail__c>();
            cllease__Asset_Return__c assetReturn;

            if((quoteDuePaid && quoteChargePaid) || !contract.cllease__Lease_Product_Name__r.cllease__Wait_for_Cash__c) {
                List<cllease__Asset_Return__c> assetReturnList = new List<cllease__Asset_Return__c>();
                for(TerminationQuoteAction.Equipment unit : equipments) {
                    assetReturn = new cllease__Asset_Return__c();
                    assetReturn.cllease__contract__c = contract.Id;

                    if(termQuoteHeader.cllease__Is_Equipment_Termination__c) {
                        equipmentstoBeTerminated.add(new cllease__Contract_Equipment__c(Id = unit.eqp.Id, cllease__Status__c = 'TERMINATED'));
                        assetReturn.cllease__Contract_Equipment__c =  unit.eqp.Id;
                    } 
                    // Commenting the Equipment Unit level Termination
                    /*else {
                        eqpDetailsToBeTerminated.add(new clcommon__Equipment_Detail__c(Id = unit.eqpDetail.Id, clcommon__Status__c = 'TERMINATED'));
                        assetReturn.cllease__Contract_Equipment__c   =  unit.eqpDetail.cllease__Contract_Equipment__c;
                        assetReturn.cllease__Equipment_Detail__c     =  unit.eqpDetail.Id;
                    }*/

                    if(!termQuoteHeader.cllease__Termination_With_Purchase__c) {
                        assetReturn.cllease__Return_Status__c = 'Scheduled for Return';
                    } else {
                        assetReturn.cllease__Return_Status__c = 'Sold';
                    }
                    assetReturnList.add(assetReturn);
                }

                if (equipmentstoBeTerminated.size() > 0) {
                    cllease.EquipmentOperations.updateEquipment(equipmentstoBeTerminated);
                }

                if(eqpDetailsToBeTerminated.size() > 0) {
                    //EquipmentDetailOperations.upsertEquipmentDetails(eqpDetailsToBeTerminated);
                }

                if (termQuoteHeader.cllease__full_termination__c) {
                    contract.cllease__Lease_Status__c = 'TERMINATED';
                }

                if(assetReturnList.size() > 0) {
                    // MultiCurrency update
                    Map<Id, List<SObject>> objMap = new Map<Id, List<SObject>>();
                    objMap.put(contract.Id, (List<sObject>)assetReturnList);
                    clcommon.MultiCurrencyUtil.setCurrencyCodes(objMap);
                    insert assetReturnList;
                }

                //Like the way excess account balance was updated, update the excess field in contract
                contract.cllease__Excess__c = (contract.cllease__Excess__c == null) ? 0 : contract.cllease__Excess__c;
                if(contract.cllease__Excess__c != null && contract.cllease__Excess__c != 0) {
                    List<cllease__Termination_Quote_Line__c> terminationLines = getQuoteHeader(termQuoteHeader.Id).cllease__Termination_Quote_Lines__r;
                    for (cllease__Termination_Quote_Line__c quoteLine : terminationLines) {
                        if (quoteLine.cllease__Line_Type__c == 'EXCESS') {
                            contract.cllease__Excess__c -= quoteLine.cllease__Amount__c.abs();
                        }
                    }
                }

                //Update contract overall
                Update contract;

                termQuoteHeader.cllease__Status__c = 'TERMINATION PROCESSED';
                Update termQuoteHeader;
                return null;
              } else {
                  createMessage(ApexPages.severity.ERROR,'Outstanding dues/charges are not satisfied. Termination can not be processed');
                  return null;
            }
        } catch (Exception e) {
            Database.rollback(sp);
            createMessage(ApexPages.severity.ERROR,'Process Termination - Exception: '+e.getMessage());
            return null;
        }
    }

    private void createMessage(ApexPages.severity severity, String message) {
        ApexPages.addmessage(new ApexPages.message(severity, message));
    }

}