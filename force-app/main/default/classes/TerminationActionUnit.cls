/**
 *  Author: Cloud Lending Solutions
 *  Description: Customizing the CL Lease product Termination Functionality due to DLL's Feature Gap
 *      This class is acting as a unit of termination. One termination will have one TerminationActionUnit.
 *      Almost all the operations will be done as part of this class.
 *      There is refactor possible across the restructure and will work with Rupa on the same.
 *
 *      This class is used in two ways:
 *      1. When the termination quote is being created - at this point it creates "Termination quote Lines" and "Termination quote equipments".
 *      2. When the termination quote is processed, then all the streams update and creation of bills, asset-returns etc are handled by this class.
 *
 **/
public class TerminationActionUnit {

    private String namespaceUS = CLSCustomUtil.getNSWithUnderScore();

    private Decimal selectedEquipCost = 0.0;
    private Decimal selectedAssetRentCost = 0.0;
    private Decimal selectedEquipResidual = 0.0;
    private Decimal totalEquipCost = 0.0;
    private Decimal totalEquipResidualAmt = 0.0;
    private Decimal totalSubsidyAmount = 0.0;
    private Decimal selectedSubsidyAmount = 0.0;

    private Decimal rateFactorCost = 1.00;
    private Decimal subventionReductionFactor = 1.0;
    private Decimal residualReductionFactor = 1.0;
    private Decimal subsidyReductionFactor = 1.0;

    private Decimal totalSubventionAmount = 0.0;
    private Decimal selectedSubventionAmount = 0.0;
    private Decimal totalToBeAccrueIncome = 0.0;
    private Decimal totalUnAccruedIncome = 0.0;
    private Decimal totalToBeAccruedSubventionAmount = 0.0;
    private Decimal totalUnAccruedSubventionAmount = 0.0;
    private Decimal totalUnAccruedIdcAmount = 0.0;
    private Decimal totalToBeBilledAmount = 0.0;
    private Decimal totalUnbilledAmount = 0.0;
    private Decimal totalEffectiveAccruedDep = 0.0;
    private Decimal totalAccruedDep = 0.0;
    private Decimal totalToBeAccruedDep = 0.0;

    private Boolean isWaitForCashEnabled = false;

    public cllease__Lease_Account__c lacc;
    public cllease__Termination_Quote_Header__c qh;

    public static String OLT_DEVNAME_TERMINATION = 'Termination_Record_Type';
    public static String OLT_DEVNAME_ASSET_RETURN = 'Asset_Return_Record';
    public static String OLT_DEVNAME_ASSET_SOLD = 'Asset_Sold_Record';

    //these two objects are created during the termination quote creation.
    public List<cllease__Termination_Quote_Equipment__c> terminationEquipments;
    public List<cllease__Termination_Quote_Line__c> terminationLines;
    public Map<Id,TerminationQuoteAction.Equipment> allActiveEquipments = new Map<Id,TerminationQuoteAction.Equipment>();

    //All the records are created/modified as part of processing quote.
    private List<cllease__Asset_Return__c> assetReturnForContract;
    private List<cllease__Charge__c> chargesToCreate;
    private cllease__Lease_Account_Due_Details__c terminationBill;
    private List<cllease__Due_Detail_Lines__c> dueLinesToCreate;
    private clcommon__Cash_Receipt__c cashReceipt;
    private List<cllease__Payment_Schedule__c> paymentScheduleToInsert;
    private List<cllease__Payment_Stream__c> paymentStreamsToUpdateById;
    private List<cllease__Rental_Stream__c> rentalStreamsToUpdate;
    private List<cllease__Amz_Stream__c> amzStreamsToUpdate;
    private List<cllease__Residual_Stream__c> residualStreamsToUpdate;
    private List<cllease__Rental_Accrual_Stream1__c> rentalAccrualStreamsToUpdate;
    private List<cllease__Dep_Streams__c> depStreamsToUpdate;
    private List<cllease__Initial_Direct_Cost_Stream__c> idcStreamsToUpdate;
    private List<cllease__Fee_Stream__c> feeStreamsToUpdate;
    private List<cllease__Subsidy_Stream__c> subsidyStreamsToUpdate;
    private List<Cllease__Non_Cash_Account_Balance__c> nonCashAccountBalancesToUpdate;
    private cllease__Lease_Trx_Header__c acceleratedAccrualHeader;
    private List<cllease__Lease_Trx_Lines__c> acceleartedAccrualsLines;
    private List<cllease__Other_Transaction__c> terminationTxnOLTs;

    private List<cllease__Payment_Schedule__c> listPaymentSchedule;
    //cllease__Cash_Account_Balance__c.Id and cllease__Cash_Account_Balance__c map.
    private Map<Id, cllease__Cash_Account_Balance__c> balToUpdate;
    //Billed amount by fee-schedule id.
    private Map<Id, Decimal> billedAmountByFeeSchedule;
    //Accrued amount by fee-schedule id.
    private Map<Id, Decimal> accruedAmountByFeeSchedule;
    //Accelrate fee income during partial/full termiantion. Creating map to store amount by fee-schedule id.
    private Map<Id, Decimal> unAccruedAmountByFeeSchedule;
    //Fee-stream's contract fee id, to fee-streams transaction subtype id.
    private Map<Id, Id> txnSubTypeByFeeSchedule;

    public Map<Id, TerminationQuoteAction.Equipment> equipmentsToTerminate;
    private Map<String, Id> trxSubTypeMap;
    private Id assetReturnRecordTypeId;
    private Id assetSoldRecordTypeId;
    private Id terminationRecordTypeId;
    private Id subventionTxnSubTypeID;

    public TerminationActionUnit(cllease__Termination_Quote_Header__c qh,
        cllease__Lease_Account__c lacc) {
        this.qh = qh;
        this.lacc = lacc;
        this.isWaitForCashEnabled = lacc.cllease__lease_product_name__r.cllease__Wait_For_Cash__c;
        this.equipmentsToTerminate = new Map<Id, TerminationQuoteAction.Equipment>();
        this.chargesToCreate = new List<cllease__Charge__c>();
        this.balToUpdate = new Map<Id, cllease__Cash_Account_Balance__c>();
        this.dueLinesToCreate = new List<cllease__Due_Detail_Lines__c>();
        this.paymentStreamsToUpdateById = new List<cllease__Payment_Stream__c>();
        this.rentalStreamsToUpdate = new List<cllease__Rental_Stream__c>();
        this.amzStreamsToUpdate = new List<cllease__Amz_Stream__c>();
        this.residualStreamsToUpdate = new List<cllease__Residual_Stream__c>();
        this.rentalAccrualStreamsToUpdate = new List<cllease__Rental_Accrual_Stream1__c>();
        this.depStreamsToUpdate = new List<cllease__Dep_Streams__c>();
        this.idcStreamsToUpdate = new List<cllease__Initial_Direct_Cost_Stream__c>();
        this.feeStreamsToUpdate = new List<cllease__Fee_Stream__c>();
        this.subsidyStreamsToUpdate = new List<cllease__Subsidy_Stream__c>();
        this.nonCashAccountBalancesToUpdate = new List<Cllease__Non_Cash_Account_Balance__c>();
        this.terminationEquipments = new List<cllease__Termination_Quote_Equipment__c>();
        this.assetReturnForContract = new List<cllease__Asset_Return__c>();
        this.terminationLines = new List<cllease__Termination_Quote_Line__c>();
        this.terminationTxnOLTs = new List<cllease__Other_Transaction__c>();
        this.acceleartedAccrualsLines = new List<cllease__Lease_Trx_Lines__c>();

        this.billedAmountByFeeSchedule   = new Map<Id, Decimal>();
        this.accruedAmountByFeeSchedule = new Map<Id, Decimal>();
        this.unAccruedAmountByFeeSchedule = new Map<Id, Decimal>();

        this.txnSubTypeByFeeSchedule = new Map<Id, Id>();
        this.paymentScheduleToInsert = new List<cllease__Payment_Schedule__c>();
        this.listPaymentSchedule = new List<cllease__Payment_Schedule__c>();
        trxSubTypeMap = TerminationUtil.getTransactionSubTypesMap(null);

        Set<String> oltRecordTypes = new Set<String> { OLT_DEVNAME_TERMINATION, OLT_DEVNAME_ASSET_RETURN, OLT_DEVNAME_ASSET_SOLD };
        List<RecordType> exList = [SELECT Id, Name, DeveloperName
                                    FROM RecordType
                                    WHERE DeveloperName IN :oltRecordTypes
                                        AND SobjectType = :namespaceUS + 'Other_Transaction__c'
                                  ];

        if(exList != null && exList.size() > 0) {
            for(RecordType exl : exList) {
                if(exl.DeveloperName.equalsIgnoreCase( OLT_DEVNAME_TERMINATION)) {
                    terminationRecordTypeId = exl.ID;
                }
                else if(exl.DeveloperName.equalsIgnoreCase( OLT_DEVNAME_ASSET_RETURN)) {
                    assetReturnRecordTypeId = exl.ID;
                }
                else if(exl.DeveloperName.equalsIgnoreCase( OLT_DEVNAME_ASSET_SOLD)) {
                    assetSoldRecordTypeId = exl.ID;
                }
            }
        }
        this.subventionTxnSubTypeID = trxSubTypeMap.get(LendingConstants.TXN_SUBTYPE_SUBVENTION_ACCRUAL);
    }

    /**
     * This method computes following ratios:
     * 1. rateFactorCost
     * 2. residualReductionFactor
     * 3. subventionReductionFactor
     *
     * This method is used at the time of creation of quote as well as at the time of processing of quotes.
     */
    public void computeVariousRatios() {
        if (this.totalEquipCost > 0) {
            this.rateFactorCost = (this.selectedEquipCost / this.totalEquipCost);
        }

        if (this.totalEquipResidualAmt > 0) {
            this.residualReductionFactor = (this.selectedEquipResidual / this.totalEquipResidualAmt);
        }

        if(this.totalSubsidyAmount > 0) {
            this.subsidyReductionFactor = (this.selectedSubsidyAmount / this.totalSubsidyAmount);
        }

        // Checking for Subvention Enable
        if (this.lacc.Cllease__Accrual_Streams__c != null
            && this.lacc.Cllease__Accrual_Streams__c.contains(LendingConstants.STREAM_SUBVENTION)
            && this.totalSubventionAmount > 0) {
            this.subventionReductionFactor = (this.selectedSubventionAmount / this.totalSubventionAmount);
        }
    }

    /**
     * Creates the unit-of-work against given uowTransaction. The calling method / class may
     * roll-up all the uow's created against same uowTransaction as single DML operation.
     *
     * Please note that - the Contract-Equipment and Equipment detail records are not added to uow as they
     * were handled by the respective classes. Work needs to be done to bring them under same uow. [TBD : AHR]
     * @param uowTransaction
     */
    public void createUoW(mfiflexUtil.UnitOfWorkTransaction uowTransaction) {
        mfiflexUtil.UnitOfWork uow;
        uow = uowTransaction.createUnitOfWork(lacc.Name);

        Boolean quoteIsBeingGenerated = true;
        if(qh.cllease__Status__c.equalsIgnoreCase(LendingConstants.TERMINATION_QUOTE_STATUS_GENERATED) == false) {
            quoteIsBeingGenerated = false;
        }
        //insert  if quote is being generated
        if(qh.Id == null) {
            uow.addToInsert(qh);
            if(!terminationLines.isEmpty()) {
                uow.addToInsert(terminationLines);
                uow.addRelationshipAndResolve(terminationLines, qh);
            }

            if(!terminationEquipments.isEmpty()) {
                uow.addToInsert(terminationEquipments);
                uow.addRelationshipAndResolve(terminationEquipments, qh);
            }
        }
        else {
            uow.addToUpdate(qh);
        }

        if(quoteIsBeingGenerated == true) {
            return;
        }

        lacc.Cllease__Enable_Calculation_Setup_Logs__c = true;

        if(terminationBill != null) {
            uow.addToInsert(terminationBill);
            uow.addRelationshipAndResolve(terminationBill, qh);

            if(!dueLinesToCreate.isEmpty()) {
                //System.debug((LoggingLevel.FINE, 'dueLinestoCreate size = ' + dueLinesToCreate.size());
                uow.addToInsert(dueLinesToCreate);
                uow.addRelationshipAndResolve(dueLinesToCreate, terminationBill);
                uow.addRelationshipAndResolve(dueLinesToCreate, lacc);
            }
        }

        if(cashReceipt != null) {
            // not using uow since can't configure the same in LeaseAccountObjectHierarchy.
            insert cashReceipt;
        }

        if(acceleratedAccrualHeader != null) {
            uow.addToInsert(acceleratedAccrualHeader);
            uow.addRelationshipAndResolve(acceleratedAccrualHeader, lacc);
            if(!acceleartedAccrualsLines.isEmpty()) {
                uow.addToInsert(acceleartedAccrualsLines);
                uow.addRelationshipAndResolve(acceleartedAccrualsLines, lacc);
                uow.addRelationshipAndResolve(acceleartedAccrualsLines, acceleratedAccrualHeader);
            }
        }

        if(!chargesToCreate.isEmpty()) {
            uow.addToInsert(chargesToCreate);
            uow.addRelationshipAndResolve(chargesToCreate, qh);
        }

        if(!terminationTxnOLTs.isEmpty()) {
            uow.addToInsert(terminationTxnOLTs);
            uow.addRelationshipAndResolve(terminationTxnOLTs, lacc);
        }

        if(!assetReturnForContract.isEmpty()) {
            uow.addToInsert(assetReturnForContract);
            uow.addRelationshipAndResolve(assetReturnForContract, lacc);
            uow.addRelationshipAndResolve(assetReturnForContract, qh);
        }

        if(!paymentStreamsToUpdateById.isEmpty()) {
            uow.addToUpdate(paymentStreamsToUpdateById);
        }

        if(!rentalAccrualStreamsToUpdate.isEmpty()) {
            uow.addToUpdate(rentalAccrualStreamsToUpdate);
        }

        if(!rentalStreamsToUpdate.isEmpty()) {
            uow.addToUpdate(rentalStreamsToUpdate);
        }

        if(!amzStreamsToUpdate.isEmpty()) {
            uow.addToUpdate(amzStreamsToUpdate);
        }

        if(!residualStreamsToUpdate.isEmpty()) {
            uow.addToUpdate(residualStreamsToUpdate);
        }

        if(!idcStreamsToUpdate.isEmpty()) {
            uow.addToUpdate(idcStreamsToUpdate);
        }

        if(!feeStreamsToUpdate.isEmpty()) {
            uow.addToUpdate(feeStreamsToUpdate);
        }

        if(!subsidyStreamsToUpdate.isEmpty()) {
            uow.addToUpdate(subsidyStreamsToUpdate);
        }

        if(!depStreamsToUpdate.isEmpty()) {
            uow.addToUpdate(depStreamsToUpdate);
        }

        if(!balToUpdate.isEmpty()) {
            uow.addToUpdate(balToUpdate.values());
        }

        if(!nonCashAccountBalancesToUpdate.isEmpty()) {
            uow.addToUpdate(nonCashAccountBalancesToUpdate);
        }

        if(!paymentScheduleToInsert.isEmpty()) {
            if(!listPaymentSchedule.isEmpty()) {
                uow.addToDelete(listPaymentSchedule);
            }
            uow.addToInsert(paymentScheduleToInsert);
            uow.addRelationshipAndResolve(paymentScheduleToInsert,lacc);
        }
    }

    /**
     * populate Termination_Quote_Equipment__c records for given terminating equipment. If terminating equipment passed is of type
     * Equipment Detail, only one record will be added. If the equipment passed is Contract-Equipment and is selected, then
     * also only one record will be added. if the contract-equipmement is not selected, the number of records will match number
     * of equipment details selected for the contract-equipment.
     *
     * @param termEquip
     */

    public void createTermQuoteEquipmentRecord(TerminationQuoteAction.Equipment termEquip) {

        List<cllease__Termination_Quote_Equipment__c> selectedTerminationEquipments;
        selectedTerminationEquipments = termEquip.createTerminationQuoteEquipment();
        //System.debug((LoggingLevel.FINE, 'createTermEquipment(): terminationEquipment = ' + selectedTerminationEquipments);
        terminationEquipments.addAll(selectedTerminationEquipments);
    }

    /**
     * populate Asset_Return__c records for given terminating equipment. If terminating equipment passed is of type
     * Equipment Detail, only one record will be added. If the equipment passed is Contract-Equipment and is selected, then
     * also only one record will be added. if the contract-equipmement is not selected, the number of records will match number
     * of equipment details selected for the contract-equipment.
     *
     * @param termEquip
     */
    public void createAssetReturn(TerminationQuoteAction.Equipment termEquip) {
        //System.debug((LoggingLevel.FINE, 'createAssetReturn(): termEquip =' + termEquip);
        //System.debug((LoggingLevel.FINE, 'createAssetReturn(): isWaitForCashEnabled =' + isWaitForCashEnabled);
        if(isWaitForCashEnabled) {
            return;
        }

        List<Cllease__Asset_Return__c> assetReturns = termEquip.createAssetReturn(qh.Cllease__Termination_With_Purchase__c);
        assetReturnForContract.addAll(assetReturns);
    }

    /**
     * populates termination bill to be created.
     */
    public void createTerminationBill() {
        terminationBill = new cllease__Lease_Account_Due_Details__c();
        terminationBill.cllease__Total_Due_Amount__c = 0;
        terminationBill.cllease__Lease_Account__c       = lacc.id;
        terminationBill.cllease__Account__c             = lacc.cllease__Account__c;
        terminationBill.cllease__GL_Transaction_Flag__c = true;
        terminationBill.cllease__Total_Paid_Amount__c   = 0;
        terminationBill.cllease__Transaction_Date__c    = cllease.SystemDateUtil.getCurrentSystemDate();
        if(qh.Id != null) {
            terminationBill.cllease__Quote_header__c = qh.Id;
        }
        terminationBill.cllease__Remarks__c             = 'Termination Quote Invoice';
        terminationBill.cllease__Due_Date__c            = cllease.SystemDateUtil.getCurrentSystemDate();
        terminationBill.cllease__Due_Type_Description__c= 'TERMINATION';
        terminationBill.cllease__Tax_Due_Amount__c = 0;
        terminationBill.cllease__Rental_Due_Amount__c = terminationBill.cllease__Total_Due_Amount__c;
        terminationBill.cllease__Status__c = LendingConstants.BILL_STATUS_PROCESSED;
        //System.debug((LoggingLevel.ERROR, '## bill: '+terminationBill);
        terminationBill.cllease__Id__c = TerminationUtil.generateUUID();
    }

    /**
     * For full termination, the depreciation streams to be accrued after the termination date are deactivated.
     * For partial termination, adjust the beginning and end amount and depreciation-expense amount.
     */
    public void  updateDepreciationStreams() {
        Decimal adjustmentFactor = this.rateFactorCost;
        if(this.qh.Cllease__Full_Termination__c) {
            for (cllease__Dep_Streams__c depAcrStream: this.lacc.cllease__Dep_Streams__r) {
                if(depAcrStream.Cllease__Date__c >= this.qh.Cllease__Termination_Date__c) {
                    depAcrStream.Cllease__Accrued__c = false;
                    depAcrStream.Cllease__Active__C = false;
                    depAcrStream.Cllease__comment__C = LendingConstants.TERMINATION_STREAM_ACCRUAL_COMMENT;
                    this.depStreamsToUpdate.add(depAcrStream);
                }
            }
        }
        else {
            //Decimal unAccruedAmount = 0.00;
            Decimal newAmount = 0.00;
            Decimal beginningNBV = 0.00;
            Decimal lastEndingNBV = 0.00;
            Decimal endResidualValue = 0;
            Integer countOfStreams = 0;
            Integer countOfUnaccruedStreams = 0;

            for (cllease__Dep_Streams__c depStream : this.lacc.cllease__Dep_Streams__r) {
                if(!depStream.cllease__Active__c) { //if this is not the first termination.
                    continue;
                }
                if(depStream.cllease__Date__c < this.qh.Cllease__Termination_Date__c) {
                    countOfStreams += 1;
                    lastEndingNBV = depStream.Cllease__Ending_Residual__c;
                    //unAccruedAmount += depStream.Dep_Expense__c;
                }
                else {
                    countOfUnaccruedStreams += 1;
                    depStream.Cllease__Accrued__c = false;
                }
            }

            if(countOfStreams < this.lacc.cllease__Dep_Streams__r.size()) {
                lastEndingNBV = this.lacc.cllease__Dep_Streams__r[countOfStreams].Cllease__Beginning_Residual__c;
            }

            Integer totalActiveStreams = countOfStreams + countOfUnaccruedStreams;
            endResidualValue = this.lacc.cllease__Dep_Streams__r[totalActiveStreams-1].Cllease__Ending_Residual__c;

            beginningNBV = lastEndingNBV;
            beginningNBV -= (beginningNBV * adjustmentFactor);
            if(countOfUnaccruedStreams > 0) {
                newAmount = (beginningNBV - (endResidualValue - this.selectedEquipResidual)) / countOfUnaccruedStreams;
            }
            for (cllease__Dep_Streams__c depStream: this.lacc.cllease__Dep_Streams__r) {
                if (depStream.Cllease__Accrued__c) {
                    continue;
                }

                if(depStream.Cllease__Date__c >= this.qh.Cllease__Termination_Date__c) {
                    if(beginningNBV <= 0) {
                        depStream.Cllease__Active__C = false;
                        depStream.Cllease__Comment__C = LendingConstants.TERMINATION_STREAM_ACCRUAL_COMMENT;
                        depStream.Cllease__Beginning_Residual__c = null;
                        depStream.Cllease__Dep_Expense__c = null;
                        depStream.Cllease__Ending_Residual__c = null;
                        beginningNBV = beginningNBV - newAmount;
                    }
                    else {
                        depStream.Cllease__Beginning_Residual__c = beginningNBV;
                        depStream.Cllease__Dep_Expense__c = newAmount;
                        depStream.Cllease__Ending_Residual__c = beginningNBV - newAmount;
                        beginningNBV = depStream.Cllease__Ending_Residual__c;
                    }

                }
                this.depStreamsToUpdate.add(depStream);
            }
        }
    }

    /**
     *  For full termination, deactivate all the AMZ steams.
     *  For partial termination, adjust the unearned beginning and end balance and monthly earning amount
     */
    private void  updateAmzStreams() {
        Decimal adjustmentFactor = 1.00 - rateFactorCost;
        for (Cllease__Amz_Stream__c amzStream: lacc.Cllease__Amz_Streams__r) {
            if (amzStream.Cllease__Date__c < qh.Cllease__Termination_Date__c) {
                continue;
            }
            amzStream.Cllease__Accrued_Flag__c = false;
            if (qh.Cllease__Full_Termination__c) {
                amzStream.Cllease__Active__c = false;
                amzStream.Cllease__Comment__c = LendingConstants.TERMINATION_STREAM_DEACTIVATION_COMMENT;
            }
            else {
                // Partial termination process - Applying Reduction factor on valid Amz Streams
                amzStream.Cllease__Monthly_Earning__c = cllease.ValueUtil.round(amzStream.Cllease__Monthly_Earning__c * adjustmentFactor);
                amzStream.Cllease__Unearned_Beginning_balance__c = cllease.ValueUtil.round(amzStream.Cllease__Unearned_Beginning_balance__c * adjustmentFactor);
                amzStream.Cllease__Unearned_Ending_balance__c = cllease.ValueUtil.round(amzStream.Cllease__Unearned_Ending_balance__c * adjustmentFactor);
                amzStream.Cllease__Comment__c = LendingConstants.TERMINATION_STREAM_ADJUSTED_COMMENT;
            }
            amzStreamsToUpdate.add(amzStream);
        }
    }

    /**
     * For full termination, deactivate all the streams after 'termination date'.
     * For partial termination, update each stream with respect to 1-ratefactorcost.
     */
    public void  updateRentalStreams() {

        if(qh.Cllease__Full_Termination__c) {
            for (Cllease__Rental_Stream__c rentalStream: lacc.Cllease__Rental_Streams__r) {
                if(rentalStream.Cllease__Date__c < qh.Cllease__Termination_Date__c) {
                    continue;
                }
                rentalStream.Cllease__Accrued_Flag__c = false;
                rentalStream.Cllease__Active__c = false;
                rentalStream.Cllease__comment__c = LendingConstants.TERMINATION_STREAM_ACCRUAL_COMMENT;
                rentalStreamsToUpdate.add(rentalStream);
            }
        }
        else {

            Decimal adjustmentFactor = rateFactorCost;            
            Decimal oneMinusAdjFactor = 1.00 - adjustmentFactor;
            for (Cllease__Rental_Stream__c rentalStream : lacc.Cllease__Rental_Streams__r) {

                if(rentalStream.Cllease__Date__c < qh.Cllease__Termination_Date__c) {
                    continue;
                }


                if(rentalStream.Cllease__Ending_Unearned_Income__c == null) {
                    rentalStream.Cllease__Ending_Unearned_Income__c = 0.0;
                }

                if(rentalStream.Cllease__Contract__r.Cllease__Has_Asset_Level_Rent__c) {
                    adjustmentFactor = selectedAssetRentCost/rentalStream.Cllease__Payment_Amount__c;
                    oneMinusAdjFactor = 1.00 - adjustmentFactor;
                }

                rentalStream.Cllease__Accrued_Flag__c = false;
                rentalStream.Cllease__Lease_Income__c = cllease.ValueUtil.round(rentalStream.Cllease__Lease_Income__c * oneMinusAdjFactor);
                rentalStream.Cllease__Beginning_Net_Book_Value__c = cllease.ValueUtil.round(rentalStream.Cllease__Beginning_Net_Book_Value__c * oneMinusAdjFactor);
                rentalStream.Cllease__Ending_Net_Book_Value__c = cllease.ValueUtil.round(rentalStream.Cllease__Ending_Net_Book_Value__c * oneMinusAdjFactor);
                rentalStream.Cllease__Beginning_Net_Investment__c = cllease.ValueUtil.round(rentalStream.Cllease__Beginning_Net_Investment__c * oneMinusAdjFactor);
                rentalStream.Cllease__Ending_Net_Investment__c = cllease.ValueUtil.round(rentalStream.Cllease__Ending_Net_Investment__c * oneMinusAdjFactor);
                rentalStream.Cllease__Beginning_Lease_Receivable__c = cllease.ValueUtil.round(rentalStream.Cllease__Beginning_Lease_Receivable__c * oneMinusAdjFactor);
                rentalStream.Cllease__Ending_Lease_Receivable__c = cllease.ValueUtil.round(rentalStream.Cllease__Ending_Lease_Receivable__c * oneMinusAdjFactor);
                rentalStream.Cllease__Beginning_Unearned_Income__c = cllease.ValueUtil.round(rentalStream.Cllease__Beginning_Unearned_Income__c * oneMinusAdjFactor);
                rentalStream.Cllease__Ending_Unearned_Income__c = cllease.ValueUtil.round(rentalStream.Cllease__Ending_Unearned_Income__c * oneMinusAdjFactor);
                rentalStream.Cllease__Capital_Recovery__c = cllease.ValueUtil.round(rentalStream.Cllease__Capital_Recovery__c * oneMinusAdjFactor);
                rentalStream.Cllease__Payment_Amount__c = cllease.ValueUtil.round(rentalStream.Cllease__Payment_Amount__c * oneMinusAdjFactor);
                rentalStreamsToUpdate.add(rentalStream);
            }
        }
    }

    /**
     *  For full termination, the rental accrual streams are deactivate for date later than termination date.
     *  for partial termination, the accrual streams are adjusted for ratefactorcost for the NBV
     */
    public void  updateRentalAccrualStreams() {
        Decimal adjustmentFactor = 1.00 - rateFactorCost;

        if(qh.Cllease__Full_Termination__c) {
            for (Cllease__Rental_Accrual_Stream1__c rentalAcrStream: lacc.Cllease__Rental_Accrual_Streams__r) {
                if(rentalAcrStream.Cllease__Date__c < qh.Cllease__Termination_Date__c) {
                    continue;
                }
                rentalAcrStream.Cllease__Accrued__c = false;
                rentalAcrStream.Cllease__Active__C = false;
                rentalAcrStream.Cllease__comment__C = LendingConstants.TERMINATION_STREAM_ACCRUAL_COMMENT;
                rentalAccrualStreamsToUpdate.add(rentalAcrStream);
            }
        }
        else {
            Decimal unAccruedAmount = 0.00;
            //Decimal newAmount = 0.00;
            Decimal beginningNBV = 0.00;
            List<Cllease__Rental_Accrual_Stream1__c> accrualStreamsToUpdate = new List<Cllease__Rental_Accrual_Stream1__c>();
            for (Cllease__Rental_Accrual_Stream1__c rentalAcrStream: lacc.Cllease__Rental_Accrual_Streams__r) {
                if(rentalAcrStream.Cllease__Date__c < qh.Cllease__Termination_Date__c) {
                    continue;
                }
                rentalAcrStream.Cllease__Accrued__c = false;
                unAccruedAmount += rentalAcrStream.Cllease__Rental_Accrual__c;
                accrualStreamsToUpdate.add(rentalAcrStream);
            }

            beginningNBV = cllease.ValueUtil.round(unAccruedAmount * adjustmentFactor);

            for (cllease__Rental_Accrual_Stream1__c oldAccrual :accrualStreamsToUpdate) {
                oldAccrual.Cllease__Beginning_Net_Book_Value__c = beginningNBV;
                oldAccrual.Cllease__Rental_Accrual__c = cllease.ValueUtil.round(oldAccrual.Cllease__Rental_Accrual__c * adjustmentFactor);
                oldAccrual.Cllease__Ending_Net_Book_Value__c = beginningNBV - oldAccrual.Cllease__Rental_Accrual__c;
                beginningNBV = oldAccrual.Cllease__Ending_Net_Book_Value__c;
                rentalAccrualStreamsToUpdate.add(oldAccrual);
            }
        }
    }

    /**
     * For full termination, deactivate the residual stream after the termination date.
     * For partial termination the values are adjusted as per residualReductionFactor.
     */
    public void updateResidualStreams() {
        Decimal adjustmentFactor = 1.00 - residualReductionFactor;

        for(Cllease__Residual_Stream__c residualStream: lacc.Cllease__Residual_Streams__r) {
            if(residualStream.Cllease__Date__c < qh.Cllease__Termination_Date__c) {
                continue;
            }

            residualStream.Cllease__Accrued_Flag__c = false;
            if(qh.Cllease__Full_Termination__c) {
                residualStream.Cllease__Active__c = false;
                residualStream.Cllease__comment__C = LendingConstants.TERMINATION_STREAM_ACCRUAL_COMMENT;
            }
            else {
                residualStream.Cllease__Beginning_Lease_Residual__c = cllease.ValueUtil.round(residualStream.Cllease__Beginning_Lease_Residual__c * adjustmentFactor);
                residualStream.Cllease__Beginning_Residual_Net_Book_Value__c = cllease.ValueUtil.round(residualStream.Cllease__Beginning_Residual_Net_Book_Value__c * adjustmentFactor);
                residualStream.Cllease__Beginning_Unearned_Residual_Income__c = cllease.ValueUtil.round(residualStream.Cllease__Beginning_Unearned_Residual_Income__c * adjustmentFactor);
                residualStream.Cllease__Ending_Net_Book_Value__c = cllease.ValueUtil.round(residualStream.Cllease__Ending_Net_Book_Value__c * adjustmentFactor);
                residualStream.Cllease__Ending_Lease_Residual__c = cllease.ValueUtil.round(residualStream.Cllease__Ending_Lease_Residual__c * adjustmentFactor);
                residualStream.Cllease__Residual_Income__c = cllease.ValueUtil.round(residualStream.Cllease__Residual_Income__c * adjustmentFactor);
                residualStream.Cllease__Residual_Amount__c = cllease.ValueUtil.round(residualStream.Cllease__Residual_Amount__c * adjustmentFactor);
            }
            residualStreamsToUpdate.add(residualStream);
        }
    }

    /**
     * For full termination, deactivate the idcStream after termination date.
     * For partial termination, adjust the stream by rateFactorCost.
     */
    private void  updateIDCStreams() {
        Decimal adjustmentFactor = rateFactorCost;

        if(qh.cllease__Full_Termination__c) {
            for (Cllease__Initial_Direct_Cost_Stream__c idcStream: lacc.Cllease__IDC_Stream__r) {
                if (idcStream.Cllease__Date__c < qh.Cllease__Termination_Date__c) {
                    continue;
                }
                idcStream.Cllease__Active__c = false;
                idcStream.Cllease__Accrued_Flag__c = true;
                idcStream.Cllease__comment__C = LendingConstants.TERMINATION_STREAM_ACCRUAL_COMMENT;
                idcStreamsToUpdate.add(idcStream);
            }
        }
        else {
            Decimal originalAmount = 0,unAccruedAmount = 0,newAmount = 0,beginningNBV = 0;
            List<Cllease__Initial_Direct_Cost_Stream__c> idcStreamsList = new List<Cllease__Initial_Direct_Cost_Stream__c>();
            for (Cllease__Initial_Direct_Cost_Stream__c idcStream: lacc.Cllease__IDC_Stream__r) {
                if (idcStream.cllease__Date__c < qh.Cllease__Termination_Date__c) {
                    continue;
                }
                idcStream.Cllease__Accrued_Flag__c = false;
                unAccruedAmount += idcStream.Cllease__Expense_Initial_Direct_Cost__c;
                idcStreamsList.add(idcStream);
            }
            beginningNBV = unAccruedAmount - cllease.ValueUtil.round(unAccruedAmount * adjustmentFactor);
            for (cllease__Initial_Direct_Cost_Stream__c newAccrual :idcStreamsList) {
                originalAmount = newAccrual.Cllease__Expense_Initial_Direct_Cost__c;
                newAmount = (originalAmount - cllease.ValueUtil.round(originalAmount * adjustmentFactor));
                newAccrual.Cllease__Beginning_Initial_Direct_Cost__c = beginningNBV;
                newAccrual.Cllease__Expense_Initial_Direct_Cost__c = newAmount;
                newAccrual.Cllease__Ending_Initial_Direct_Cost__c = beginningNBV - newAmount;
                beginningNBV = newAccrual.Cllease__Ending_Initial_Direct_Cost__c;
                idcStreamsToUpdate.add(newAccrual);
            }
        }
    }

    //In case of partial termination, if it is an asset level fees and asset is being terminated, we need to delete the streams
    private  void updateFeeStreams() {
        Set<Id> equipmentsToBeTerminated = equipmentsToTerminate.keySet();
        //Map<Id, Decimal> feeMap = new Map<Id, Decimal>();

        //in case of full as well as partial we need to do this
        for(Cllease__Fee_Stream__c feeStream : lacc.Cllease__Fee_Streams__r) {
            //if fee stream is not accrued and it was related to asset which is being terminated
            //we should delete the fee stream line
            if(feeStream.Cllease__Contract_Fee__r.Cllease__Contract_Equipment__c != null
                && equipmentsToBeTerminated.contains(feeStream.Cllease__Contract_Fee__r.Cllease__Contract_Equipment__c)) {

                if(feeStream.Cllease__Date__c < qh.Cllease__Termination_Date__c) {

                    Decimal accruedAmount = 0;
                    if(accruedAmountByFeeSchedule.containsKey(feeStream.Cllease__Contract_Fee__c)) {
                        accruedAmount = accruedAmountByFeeSchedule.get(feeStream.Cllease__Contract_Fee__c);
                    }
                    accruedAmount += feeStream.Cllease__Fee_Amount__c;
                    accruedAmountByFeeSchedule.put(feeStream.Cllease__Contract_Fee__c, accruedAmount);
                }
                else {
                    feeStream.Cllease__Accrued__c = false;
                    if(!qh.Cllease__Full_Termination__c) {
                        feeStream.Cllease__Active__c = false;
                    }
                }
                feeStreamsToUpdate.add(feeStream);
            } else{
                Decimal unAccruedAmount = 0;
                Boolean computedUnAccruedAmount = false;
                if(!feeStream.Cllease__Accrued__c && feeStream.Cllease__Date__c >= qh.Cllease__Termination_Date__c) {
                    if(unAccruedAmountByFeeSchedule.containsKey(feeStream.Cllease__Contract_Fee__c)){
                        unAccruedAmount = unAccruedAmountByFeeSchedule.get(feeStream.Cllease__Contract_Fee__c);
                    }
                    if(!qh.Cllease__Full_Termination__c){
                        unAccruedAmount += feeStream.Cllease__Fee_Amount__c - (feeStream.Cllease__Fee_Amount__c * rateFactorCost);
                        unAccruedAmountByFeeSchedule.put(feeStream.Cllease__Contract_Fee__c, unAccruedAmount);
                        feeStream.Cllease__Beginning_Balance__c = feeStream.Cllease__Beginning_Balance__c * rateFactorCost;
                        feeStream.Cllease__Fee_Amount__c = feeStream.Cllease__Fee_Amount__c * rateFactorCost;
                        feeStream.Cllease__Ending_Balance__c = feeStream.Cllease__Beginning_Balance__c - feeStream.Cllease__Fee_Amount__c;
                    }
                    else{
                        unAccruedAmount += feeStream.Cllease__Fee_Amount__c;
                        unAccruedAmountByFeeSchedule.put(feeStream.Cllease__Contract_Fee__c, unAccruedAmount);
                        
                        feeStream.Cllease__Accrued__c = true;
                        feeStream.Cllease__Date_Accrued__c = cllease.SystemDateUtil.getCurrentSystemDate();
                        feeStream.Cllease__comment__C = LendingConstants.TERMINATION_STREAM_ACCRUAL_COMMENT;
                    }
                }
                feeStreamsToUpdate.add(feeStream);
            }
            txnSubTypeByFeeSchedule.put(feeStream.Cllease__Contract_Fee__c, feeStream.Cllease__Transaction_Sub_Type__c);
        }
    }

    private Cllease__Payment_Schedule__c createPaymentSchedule(Cllease__Payment_Schedule__c originalPaymentSchedule,
                                                        Integer noOfPayments,
                                                        Integer sequence,
                                                        Date payDate,
                                                        Decimal tax,
                                                        Decimal paymentAmount,
                                                        Decimal totalPaymentAmount) {

        Cllease__Payment_Schedule__c pmtSchedule = new Cllease__Payment_Schedule__c(Cllease__Contract__c = lacc.Id,
        Cllease__Contractual_Payments_Flag__c = true,
        Cllease__Primary_Flag__c = lacc.Cllease__Is_Rescheduled__c?false:true,
        Cllease__Payment_Date__c = payDate == null ? originalPaymentSchedule.cllease__Payment_Date__c : payDate,
        Cllease__VAT__c = tax == null ? originalPaymentSchedule.cllease__VAT__c: tax,
        Cllease__Payment_Amount__c = paymentAmount == null ? cllease.ValueUtil.round(originalPaymentSchedule.Cllease__Payment_Amount__c) : paymentAmount,
        Cllease__Number_Of_Payments__c = noOfPayments == null ? originalPaymentSchedule.Cllease__Number_Of_Payments__c : noOfPayments,
        Cllease__Frequency__c = originalPaymentSchedule.Cllease__Frequency__c,
        Cllease__Due_Day__c = originalPaymentSchedule.Cllease__Due_Day__c,
        Cllease__Evergreen_Flag__c = originalPaymentSchedule.Cllease__Evergreen_Flag__c,
        Cllease__Total_Payment__c = totalPaymentAmount == null ? cllease.ValueUtil.round(originalPaymentSchedule.cllease__Total_Payment__c) : totalPaymentAmount,
        Cllease__Sequence__c = sequence == null ? originalPaymentSchedule.Cllease__Sequence__c : sequence);
        return pmtSchedule;
    }

    private void updatePaymentSchedule() {
        if(!qh.Cllease__Full_Termination__c) {  //Done only for partial termination.
            Decimal adjustmentFactor = rateFactorCost;
            Decimal oneMinusAdjFactor = 1.00 - adjustmentFactor; // Rate which can be multiplied with Tax,Payment Amount and Total Amount to update                                                      
            //Will be used in the loop below
            Date startDate; // For storing start date of the payment schedule 
            listPaymentSchedule = [SELECT Id,
                                    Cllease__Contract__c,
                                    Cllease__Contractual_Payments_Flag__c,
                                    Cllease__Primary_Flag__c,
                                    Cllease__Payment_Date__c,
                                    Cllease__Due_Day__c,
                                    Cllease__Evergreen_Flag__c,
                                    Cllease__LeaseApplicationNumber__c,
                                    Cllease__VAT__c,
                                    Cllease__Payment_Amount__c,
                                    Cllease__Number_Of_Payments__c,
                                    Cllease__Frequency__c,
                                    Cllease__Total_Payment__c,
                                    Cllease__Sequence__c
                                FROM Cllease__Payment_Schedule__c
                                WHERE Cllease__Contract__c =:lacc.id]; //Querying all the payment schedule present in the contract

            if(lacc.Cllease__Has_Asset_Level_Rent__c) { //Checking if Asset Level Rent
                    adjustmentFactor = selectedAssetRentCost/listPaymentSchedule[0].cllease__Payment_Amount__c; //Accordingly making adjustment for that condition
                    oneMinusAdjFactor = 1.00 - adjustmentFactor; //Asset level rent has payment schedule restricted to one.
            }

            for(Cllease__Payment_Schedule__c paySched: listPaymentSchedule) { // Looping through all the payment schedules.

                Date endDate = Cllease.DateUtil.getNextCycleDate(paySched.cllease__Payment_Date__c,
                                                        paySched.cllease__Payment_Date__c.day(),
                                                        paySched.cllease__Frequency__c,
                                                        (Integer)paySched.cllease__Number_Of_Payments__c,
                                                        false); //Finding the End Date for the Current Payment Schedule.

                if(qh.Cllease__Termination_Date__c >= paySched.Cllease__Payment_Date__c && qh.Cllease__Termination_Date__c < endDate) { //Checking whether the termination date is in the current payment schedule period
                    Integer originalPaymentCount = (Integer)paySched.Cllease__Number_Of_Payments__c; // Stored so that it can be used later for splitting payment schedule. 
                    startDate = paySched.Cllease__Payment_Date__c;
                    Integer dueDay = (Integer)startDate.day(); //Contains due Day of the start date
                    Integer numberOfDays = Date.daysInMonth(startDate.year(), startDate.month()); //Contains the no. of days in the start date

                    if(numberOfDays == startDate.day()) { //Checking if the start date day is the last day of the month
                        dueDay = numberOfDays; // Assigning the dueDay with the last day for using to get the next cycle date
                    }

                    Integer numberOfPaymentsCount = 0;  
                    while(startDate < qh.Cllease__Termination_Date__c) { //This condition is used so to find the count of the payment schedules which are before the termination date.

                         numberOfPaymentsCount++; //Increasing no. of payments count
                         startDate = Cllease.DateUtil.getNextCycleDate(startDate,  
                                                    dueDay,
                                                    paySched.Cllease__Frequency__c,
                                                    1,
                                                    false); //Getting the next start date
                    }

                    if(numberOfPaymentsCount > 0) { // If there are any payment sequences before the termination date, we will update Sequence and Number of payments.
                  
                        Cllease__Payment_Schedule__c pmtSchedule = createPaymentSchedule(paySched,
                                                                                numberOfPaymentsCount,
                                                                                paymentScheduleToInsert.size() + 1,
                                                                                null,
                                                                                null,
                                                                                null,
                                                                                null);
                        paymentScheduleToInsert.add(pmtSchedule); //adding to a list to insert
                    }

                    // This is the payment schedule which contains the termination date.
                    // Which will be updated with new Sequence,Number of Payments,Payment Start Date,Payment Amount, Tax and Total Payment Amount.
                    Cllease__Payment_Schedule__c pmtSchedule2 = createPaymentSchedule(paySched,
                                                                            originalPaymentCount - numberOfPaymentsCount,
                                                                            paymentScheduleToInsert.size() + 1,
                                                                            startDate,
                                                                            paySched.Cllease__VAT__c*oneMinusAdjFactor,
                                                                            paySched.Cllease__Payment_Amount__c*oneMinusAdjFactor,
                                                                            paySched.Cllease__Total_Payment__c*oneMinusAdjFactor);

                    paymentScheduleToInsert.add(pmtSchedule2); //adding to a list to insert

                } else if( paySched.Cllease__Payment_Date__c > qh.Cllease__Termination_Date__c) { //This check is for updating those payment schedules, which are after the payment schedule which contained the termination date.
                                                                                // We update No of payments,Tax, Payment amount and Total Payemnt Amount.
                    Cllease__Payment_Schedule__c pmtSchedule = createPaymentSchedule(paySched,
                                                                            null,
                                                                            paymentScheduleToInsert.size() + 1,
                                                                            null,
                                                                            paySched.Cllease__VAT__c*oneMinusAdjFactor,
                                                                            paySched.Cllease__Payment_Amount__c*oneMinusAdjFactor,
                                                                            paySched.Cllease__Total_Payment__c*oneMinusAdjFactor);
                    paymentScheduleToInsert.add(pmtSchedule); //adding to a list to insert
                } else {
                    // This will update the payment schedule which is before the payment schedule containing the termiantion date.
                    Cllease__Payment_Schedule__c pmtSchedule = createPaymentSchedule(paySched,
                                                                            null,
                                                                            paymentScheduleToInsert.size() + 1,
                                                                            null,
                                                                            null,
                                                                            null,
                                                                            null);
                    paymentScheduleToInsert.add(pmtSchedule);   //adding to a list to insert
                }
            }
        }
    }

    /**
     * For full termination, deactivate the Subsidy or Subvention transaction streams after termination date.
     * For partial termination, the stream is adjusted as per adjustment factor.
     *
     * @param transactionSubType
     */
    public void updateSubsidySubventionStreams(String transactionSubType) {

        Decimal adjustmentFactor;
        Id transactionSubtypeId = trxSubTypeMap.get(transactionSubType);
        if(transactionSubType.equalsIgnoreCase(LendingConstants.TXN_SUBTYPE_SUBSIDY_ACCRUAL)) {
            adjustmentFactor = subsidyReductionFactor;
        }
        else if (transactionSubType.equalsIgnoreCase(LendingConstants.TXN_SUBTYPE_SUBVENTION_ACCRUAL)) {
            adjustmentFactor = subventionReductionFactor;
        }


        //List<Subsidy_Stream__c>  subsidyStreamList = new List <Subsidy_Stream__c>();
        if(qh.Cllease__Full_Termination__c) {
            for (Cllease__Subsidy_Stream__c subsidyStream :lacc.Cllease__subsidy_streams__r) {
                if (subsidyStream.Cllease__Transaction_Sub_Type__c != transactionSubtypeId
                    || subsidyStream.Cllease__Date__c < qh.Cllease__Termination_Date__c) {
                    continue;
                }
                subsidyStream.Cllease__Accrued__c = true;
                subsidyStream.Cllease__Date_Accrued__c = Cllease.SystemDateUtil.getCurrentSystemDate();
                subsidyStream.Cllease__comment__C = LendingConstants.TERMINATION_STREAM_ACCRUAL_COMMENT;
                subsidyStreamsToUpdate.add(subsidyStream);
            }
        }
        else {
            Decimal originalAmount = 0,unAccruedAmount = 0,newAmount = 0,beginningNBV = 0;
            List<Cllease__Subsidy_Stream__c> subsidyStreamsList = new List<Cllease__Subsidy_Stream__c>();
            for (Cllease__Subsidy_Stream__c accrual: lacc.Cllease__subsidy_streams__r) {
                if (accrual.cllease__Transaction_Sub_Type__c != transactionSubtypeId
                    || accrual.Cllease__Date__c < qh.Cllease__Termination_Date__c) {
                    continue;
                }
                accrual.Cllease__Accrued__c = false;
                unAccruedAmount += accrual.Cllease__Accrued_Amount__c;
                subsidyStreamsList.add(accrual);
            }
            beginningNBV = unAccruedAmount - cllease.ValueUtil.round(unAccruedAmount * adjustmentFactor);
            for (Cllease__Subsidy_Stream__c oldAccrual :subsidyStreamsList) {
                originalAmount = oldAccrual.Cllease__Accrued_Amount__c;
                newAmount = (originalAmount - cllease.ValueUtil.round(originalAmount * adjustmentFactor));
                oldAccrual.Cllease__Beginning_Balance__c = beginningNBV;
                oldAccrual.Cllease__Accrued_Amount__c = newAmount;
                oldAccrual.Cllease__Ending_Balance__c = beginningNBV - newAmount;
                beginningNBV = oldAccrual.Cllease__Ending_Balance__c;
                subsidyStreamsToUpdate.add(oldAccrual);
            }
        }
    }

    /**
     * Process the termination quote. if the caller is running in bulk mode, total equipment cost is taken from roll-up field of effective selling price.[WHY?]
     * This method acts as driver method to call all the streams update and bill/charge creation.
     * @param isBulkAPICall
     */
    public void  processTerminationQuote(Boolean isBulkAPICall) {
        try {
            // Loop through all Termination QuoteTerminationQuoteAction.Equipments to create Map forTerminationQuoteAction.Equipment
            // Details in process for termination
            //System.debug((LoggingLevel.ERROR, 'processTerminationQuote(): allActiveEquipments.keySet() = ' + allActiveEquipments.keySet());
            // Loop through all ContractTerminationQuoteAction.Equipments attached.
            for (Id activeEquipId : allActiveEquipments.keySet()) {
               TerminationQuoteAction.Equipment equipment = allActiveEquipments.get(activeEquipId);

                //if process termination quote is immediately after creation without saving,
                // the values will be already computed.
                if(qh.Id != null) {
                    computeEquipmentCostAndResiduals(equipment );
                }

                // ProcessingTerminationQuoteAction.Equipments which in process for termination
                if(equipment.eqpOrEqpDetailSelected()) {
                    Id terminatingEqpId = equipment.getParentId();
                    equipmentsToTerminate.put(terminatingEqpId, equipment);
                    createAssetReturn(equipment);
                    selectedAssetRentCost += equipment.getSelectedEqpAssetRent();
                }

            }

            if(!isWaitForCashEnabled) {
                for (Id termEqpId : equipmentsToTerminate.keySet()) {
                   TerminationQuoteAction.Equipment termEquipment = equipmentsToTerminate.get(termEqpId);
                    termEquipment.terminateEquipment();
                }
                EquipmentDomainObject terminatedEquip = new EquipmentDomainObject(this.lacc, equipmentsToTerminate.keySet(), this.qh.Cllease__Is_Equipment_Termination__c);
                terminatedEquip.updateWarehouseDtls(this.qh.Cllease__Quote_Type__c, this.qh.Cllease__Termination_Date__c);
                //lacc.enable_calculation_setup_logs__c = true;
            }

            // Check and update all equipment details incase of termination @Equipment level

            // In case of Bulk API Calls, Needs to take Rollup field onTerminationQuoteAction.Equipment's Invoice Price
            if(isBulkAPICall) {
                totalEquipCost = lacc.Cllease__Equipment_Selling_Price__c;
                //System.debug((LoggingLevel.INFO, '(BulkAPI = true)Total Non-TerminatedTerminationQuoteAction.Equipment Cost: '+ totalEquipCost);
            }

            // Calculating the ratios.
            computeVariousRatios();
            // Streams Processing for Calculating the Total Amounts and creating Termination Transaction
            calculateFutureReceivables();
            calculateDepreciationAccruals();
            calculateIncomeAccruals();
            calculateSubventionAccruals();
            calculateIdcAccruals();
            createTerminationOLT();

            for(Id equipId : equipmentsToTerminate.keySet()) {
                createAssetTerminationOLTs(equipId);
            }

            createBillAndAccount();
            updatePaymentStreams();

            if(lacc.Cllease__Product_Sub_Type__c == LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE) {
                if(lacc.Cllease__Calculation_Method__c == null
                    || lacc.Cllease__Calculation_Method__c == LendingConstants.CALCULATION_METHOD_IRR) {
                    updateRentalStreams();
                }
                else {
                    updateAmzStreams();
                }

                if(lacc.Cllease__Accrual_Streams__c != null
                    && lacc.Cllease__Accrual_Streams__c.contains(LendingConstants.STREAM_RESIDUAL)) {
                    updateResidualStreams();
                }
            }
            else if(lacc.Cllease__Product_Sub_Type__c == LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE) {
                updateRentalAccrualStreams();

                if(lacc.Cllease__Accrual_Streams__c != null
                    && lacc.Cllease__Accrual_Streams__c.contains(LendingConstants.STREAM_DEPRECIATION)) {

                    updateDepreciationStreams();
                }
            }

            updateIDCStreams();
            updateFeeStreams();
            updateNonCashAccountBalances();
            
            if(lacc.Cllease__Accrual_Streams__c != null
                && lacc.Cllease__Accrual_Streams__c.contains(LendingConstants.STREAM_SUBSIDY)) {
                updateSubsidySubventionStreams(LendingConstants.TXN_SUBTYPE_SUBSIDY_ACCRUAL);
            }

            if(lacc.Cllease__Accrual_Streams__c != null
                && lacc.Cllease__Accrual_Streams__c.contains(LendingConstants.STREAM_SUBVENTION)) {
                updateSubsidySubventionStreams(LendingConstants.TXN_SUBTYPE_SUBVENTION_ACCRUAL);
            }

            //process asset level fees for accelerated accrual
            createAcceleratedAccruals();

            if(isWaitForCashEnabled) {
                qh.Cllease__Status__c = LendingConstants.TERMINATION_QUOTE_STATUS_PROCESSED;
            }
            else {
                updateExcessCashBalances(lacc, terminationLines);
                qh.Cllease__Status__c = LendingConstants.TERMINATION_QUOTE_STATUS_TERMPROCESSED;
            }

            if ((qh.Cllease__Full_Termination__c) && (!isWaitForCashEnabled)) {
                lacc.cllease__Lease_Status__c = LendingConstants.STATUS_TERMINATED;
                lacc.Cllease__Termination_Quote_accepted_flag__c = true;
                //to skip calculation setups while updating equipments
                //calculations will be skipped irrespective of product configuration
                //lacc.enable_calculation_setup_logs__c = true;
            }
            reComputeVariousContractParameters();
            updatePaymentSchedule();
            //System.debug((LoggingLevel.FINE, '### quoteheader1: '+ qh);

            // START: MultiCurrency Processing currencyISOCode assignment
            Map<Id, List<SObject>> objMap = new Map<Id, List<SObject>>();
            List<SObject> lis = new List<SObject>();
            if(assetReturnForContract.size()>0) {
                lis.addAll((List<sObject>)assetReturnForContract);
            }
            lis.addAll((List<sObject>)terminationTxnOLTs);
            objMap.put(lacc.Id,lis);
            clcommon.MultiCurrencyUtil.setCurrencyCodes(objMap);
            // END: MultiCurrency Processing currencyISOCode assignment
            //System.debug((LoggingLevel.FINE, '### multicurrency over: ');

        }
        catch(Exception e) {
            //System.debug((LoggingLevel.ERROR, 'Exception while Process termination quote: '+e.getMessage()+' stack:'+e.getStackTraceString());
            throw new CLSCustomException('Exception while Process termination quote: '+e.getMessage()+' stack:'+e.getStackTraceString());
        }
    }

    /**
     * For given equipment id being terminated, create the OLT for asset return or asset-sold.
     * [AHR] - Is this correct behavior?
     * @param equipId
     */
    public void createAssetTerminationOLTs(Id equipId) {
       TerminationQuoteAction.Equipment equip = equipmentsToTerminate.get(equipId);
        cllease__Other_Transaction__c assetR = new cllease__Other_Transaction__c();
        assetR.Cllease__Txn_Date__c = Cllease.SystemDateUtil.getCurrentSystemDate();
        assetR.Cllease__Security_Deposit__c = lacc.Cllease__Security_Deposit_Amount__c;
        assetR.Cllease__GL_Transaction_Flag__c = true;
        assetR.Cllease__Txn_Amt__c = qh.Cllease__quote_amount__c;
        assetR.Cllease__Equipment_Cost__c = equip.getEqpCost();
        assetR.Cllease__Residual_Amount_New__c = equip.getEqpResidualValue();

        /*if(equip.isEquipmentDetail()) {
            assetR.cllease__Equipment_Detail__c = equipId;
        }
        else {*/
            assetR.cllease__ContractEquipment__c = equipId;
        //}

        if (!qh.cllease__Termination_With_Purchase__c) {
            assetR.cllease__Transaction_Type__c = LendingConstants.TRANSACTION_RETURN;
            assetR.RecordTypeId = assetReturnRecordTypeId;
        }
        else {
            assetR.cllease__Transaction_Type__c = LendingConstants.TRANSACTION_ASSET_SOLD;
            assetR.RecordTypeId = assetSoldRecordTypeId;
        }
        terminationTxnOLTs.add(assetR);
    }

    /**
     * Create the termination OLT.
     */
    public void createTerminationOLT() {
        cllease__Other_Transaction__c termTrx = new cllease__Other_Transaction__c();
        termTrx.Cllease__Equipment_Cost__c = lacc.Cllease__Equipment_Selling_Price__c;
        //termTrx.cllease__Lease_Account__c = lacc.Id;
        termTrx.Cllease__Txn_Date__c = Cllease.SystemDateUtil.getCurrentSystemDate();
        termTrx.Cllease__Transaction_Type__c = LendingConstants.TRANSACTION_TERMINATION;
        termTrx.Cllease__Unearned_Lease_Income_Amount__c = cllease.ValueUtil.round(totalUnAccruedIncome * rateFactorCost);
        termTrx.Cllease__Termination_Profit__c = 0;
        termTrx.Cllease__To_Be_Billed_Rent__c = cllease.ValueUtil.round(totalToBeBilledAmount); //No reduction factor as this is the amount before termination
        termTrx.Cllease__To_Be_Accrued_Income__c = cllease.ValueUtil.round(totalToBeAccrueIncome); //No reduction factor as this is the amount before termination
        termTrx.Cllease__Unbilled_Rent__c = cllease.ValueUtil.round(totalUnbilledAmount * rateFactorCost);
        termTrx.Cllease__Accum_Depreciation__c = cllease.ValueUtil.round(totalEffectiveAccruedDep * rateFactorCost);
        termTrx.Cllease__Accrue_Subvention__c = cllease.ValueUtil.round(totalUnAccruedSubventionAmount * subventionReductionFactor);
        termTrx.Cllease__Residual_Amount_New__c = selectedEquipResidual;
        termTrx.Cllease__Security_Deposit__c = lacc.Cllease__Security_Deposit_Amount__c;
        termTrx.Cllease__GL_Transaction_Flag__c = true;
        termTrx.RecordTypeId = terminationRecordTypeId;
        termTrx.Cllease__Txn_Amt__c = qh.cllease__quote_amount__c;
        termTrx.Cllease__Initial_Direct_Cost_Amount__c = cllease.ValueUtil.round(totalUnAccruedIdcAmount * rateFactorCost);
        // Updating the Rebate Amount for a 'Third Party Sale' type Termination
        if (qh.Cllease__Third_Party_Sale__c) {
            termTrx.Cllease__Rebate_Amount__c = qh.Cllease__Rebate_Amount__c;
        }
        terminationTxnOLTs.add(termTrx);
    }

    /**
     *  calculate the subvention accruals
     */
    private void calculateSubventionAccruals() {
        for (Cllease__Subsidy_Stream__c subventionStream : lacc.Cllease__Subsidy_Streams__r) {
            if (subventionTxnSubTypeID == null
                || subventionStream.Cllease__Transaction_Sub_Type__c != subventionTxnSubTypeID) {
                continue;
            }

            if (subventionStream.Cllease__Accrued__c == false
                && subventionStream.Cllease__Date__c <= qh.Cllease__Termination_Date__c) {
                totalToBeAccruedSubventionAmount += subventionStream.Cllease__Accrued_Amount__c;
            }

            if (subventionStream.Cllease__Date__c > qh.Cllease__Termination_Date__c) {
                totalUnAccruedSubventionAmount += subventionStream.Cllease__Accrued_Amount__c;
            }
        }
    }

    private void calculateIdcAccruals() {
        for (Cllease__Initial_Direct_Cost_Stream__c idcStream: lacc.Cllease__IDC_Stream__r) {
            if (idcStream.Cllease__Date__c < qh.Cllease__Termination_Date__c) {
                continue;
            }
            totalUnAccruedIdcAmount += idcStream.Cllease__Expense_Initial_Direct_Cost__c;
        }
    }

    /**
     * compute the income accruals
     */
    private void calculateIncomeAccruals() {
        //Total unaccrued income will have following
        //if the stream is <= termination date, whether accrued or not, it should be considered as accrued income.
        //if the stream is >= termination date, whether accrued or not, it should be considered as un-accrued income.
        //the to-be-accrued-income will be un-accrued but less that termination date.
        //cllease__Lease_Account__c leaseAccount =
        if (lacc.Cllease__Product_Sub_Type__c == LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE) {
            if (lacc.Cllease__Calculation_Method__c == null ||
                lacc.Cllease__Calculation_Method__c == LendingConstants.CALCULATION_METHOD_IRR) {
                for (Cllease__Rental_Stream__c incomeStream : lacc.Cllease__Rental_Streams__r) {

                    if (incomeStream.Cllease__Date__c >= qh.Cllease__Termination_Date__c) {
                        totalUnAccruedIncome += incomeStream.Cllease__Lease_Income__c;
                    }
                }
            } else {
                for (Cllease__Amz_Stream__c amzStream : lacc.Cllease__Amz_Streams__r) {
                    if (amzStream.Cllease__Date__c >= qh.Cllease__Termination_Date__c) {
                        totalUnAccruedIncome += amzStream.Cllease__Monthly_Earning__c;
                    }
                }
            }
        } // fin lease
        else { // op lease
            for (Cllease__Rental_Accrual_Stream1__c rentalStream : lacc.Cllease__Rental_Accrual_Streams__r) {
                if (rentalStream.Cllease__Date__c >= qh.Cllease__Termination_Date__c) {
                    totalUnAccruedIncome += rentalStream.Cllease__Rental_Accrual__c;
                }
            }
        }
    }

    /**
     * compute the depreciation accruals
     */
    private void calculateDepreciationAccruals() {
        //We need to compute following for accrued depreciation:
        //if dep streams are accrued, but are after termination date, they should not be considered as accrued.
        // this case happens, when the termination date is backdated.
        //if dep streams are not accrued, but are before termination date, they should be considered as accrued.
        // this case happens when the termindation date is in future.
        for (cllease__Dep_Streams__c depStream : lacc.cllease__Dep_Streams__r) {
            if (depStream.Cllease__Date__c < qh.Cllease__Termination_Date__c) {
                totalEffectiveAccruedDep += depStream.Cllease__Dep_Expense__c;
            }
        }
    }

    /**
     * calculate future receivables which are not to be billed after the termination date.
     */
    private void calculateFutureReceivables() {
        //We need to compute following for rentals:
        //1. To-be-billed Rentals - To be billed rentals are all those payment-streams which are not-billed, but has date less than Termination date.
        //    In case of back dated termination, the to-be-billed-rentals should normally be empty (unless the job had not run till the termination date)
        //2. Unbilled Rental - All payment streams which are due on/after termination date.

        for (cllease__Payment_Stream__c payStream : lacc.cllease__Payment_Streams__r) {
            if (payStream.cllease__Transaction_Sub_Type__c == trxSubTypeMap.get(LendingConstants.TXN_SUBTYPE_PERIODIC_RENT)) {
                if (payStream.Cllease__Date__c >= qh.Cllease__Termination_Date__c) {
                    totalUnbilledAmount += payStream.Cllease__Rental_Amount__c;
                }
            }
        }
    }

    /**
     * update the non-cash balances for the lease-contract
     */
    private void updateNonCashAccountBalances() {

        for(Cllease__Non_Cash_Account_Balance__c nonCashAccountBalance :lacc.Cllease__Non_Cash_Account_Balances__r) {

            if(nonCashAccountBalance.cllease__Opening_Balance_Amount__c == null) {
                nonCashAccountBalance.cllease__Opening_Balance_Amount__c = 0.00;
            }
            if(nonCashAccountBalance.cllease__Transactions_Amount__c == null) {
                nonCashAccountBalance.cllease__Transactions_Amount__c = 0.00;
            }

            if(nonCashAccountBalance.Cllease__Balance_Type__c.equalsIgnoreCase(LendingConstants.LEASE_NONCASHBAL_RESIDUAL_RECEIVABLE)) {
                //RESIDUAL RECEIVABLE
                Decimal openingBalance = nonCashAccountBalance.Cllease__Opening_Balance_Amount__c - selectedEquipResidual;
                nonCashAccountBalance.Cllease__Opening_Balance_Amount__c = cllease.ValueUtil.round(openingBalance);
            }
            else if(nonCashAccountBalance.Cllease__Balance_Type__c.equalsIgnoreCase(LendingConstants.LEASE_NONCASHBAL_UNEARNED_RESIDUAL)) {
                nonCashAccountBalance.Cllease__Transactions_Amount__c = cllease.ValueUtil.round((nonCashAccountBalance.Cllease__Closing_Balance_Amount__c) * residualReductionFactor) + nonCashAccountBalance.Cllease__Transactions_Amount__c;
            }
            else {
                nonCashAccountBalance.Cllease__Transactions_Amount__c = cllease.ValueUtil.round(( nonCashAccountBalance.Cllease__Closing_Balance_Amount__c) * rateFactorCost) + nonCashAccountBalance.Cllease__Transactions_Amount__c;
            }
            nonCashAccountBalance.Cllease__Closing_Balance_Amount__c = nonCashAccountBalance.Cllease__Opening_Balance_Amount__c - nonCashAccountBalance.Cllease__Transactions_Amount__c;
            nonCashAccountBalancesToUpdate.add(nonCashAccountBalance);
        }
    }

    /**
     * create the termination bill and process all termination quotelines. also compute the tax for termination bill.
     */
    private void createBillAndAccount() {
        // Start creating bills
        try {

            List<cllease__Charge__c> chargesForContract = new List<cllease__Charge__c>();

            createTerminationBill();
            processTermBillForQuoteLines();
            
            if (terminationBill.cllease__Total_Due_Amount__c >= 0) {
                taxProcessForTerminationBill();
                // START: MultiCurrency Processing currencyISOCode assignment
                Map<Id, List<SObject>> objMap = new Map<Id, List<SObject>>();
                objMap.put(lacc.Id, new List<SObject>());
                if(chargesForContract.size()>0) {
                    objMap.get(lacc.id).addAll((List<SObject>) chargesForContract);
                }
                objMap.get(lacc.Id).add((sObject)terminationBill);
                objMap.get(lacc.Id).addAll((List<SObject>)dueLinesToCreate);
                clcommon.MultiCurrencyUtil.setCurrencyCodes(objMap);
                // END: MultiCurrency Processing currencyISOCode assignment

            } else {
                processCashReceiptRefund();
            }
        }
        catch(Exception e) {
            throw new CLSCustomException('Exception while creating TermiantionBill: '+e.getMessage()+' stack:'+e.getStackTraceString());
        }

    }

    /**
     * process the tax for termination bill.
     * [TBD: AHR - this can be refactored. need to work]
     */
    private void taxProcessForTerminationBill() {
        String taxSource = lacc.cllease__Branch__r.cllease__Tax_Calculation_Source__c;
        Boolean allTaxesProcessed = true;
        // create due lines
        Decimal billAmount = terminationBill.cllease__Total_Due_Amount__c;
        //This is for avoiding rounding errors
        //cannot use totalRent field as in case of VAT inclusive
        //actual rent is total due amount on due detail line
        Decimal actualRent = 0;
        Decimal totalRent = 0;
        Decimal totalTax = 0;
        Integer count = 0;

        //System.debug((LoggingLevel.FINE, 'Termination bill - tax processing., size of equipmentsToTerminate = ' + equipmentsToTerminate.keySet().size());

        for (Id equipmentId : equipmentsToTerminate.keySet()) {
           TerminationQuoteAction.Equipment equipmentUnit = equipmentsToTerminate.get(equipmentId);
            //System.debug((LoggingLevel.FINE, 'equipmentUnit = ' + equipmentUnit);
            cllease__Contract_Equipment__c equipment = equipmentUnit.eqp;
            cllease__Due_Detail_Lines__c dueLine = new cllease__Due_Detail_Lines__c();
            dueline.cllease__Remarks__c = 'Termination Rental Due';
            Decimal equipmentCost = equipmentUnit.getSelectedEqpCost();
            Decimal factor = this.rateFactorCost;
            if (selectedEquipCost > 0) {
                factor = (equipmentCost / selectedEquipCost);
            }

            if (count == (equipmentsToTerminate.keySet().size() - 1)) {
                dueLine.cllease__Rental_Due_Amount__c = billAmount - actualRent;
            }
            else {
                dueLine.cllease__Rental_Due_Amount__c = billAmount * factor;
            }
            dueLine.cllease__Rental_Due_Amount__c = cllease.ValueUtil.round(dueLine.cllease__Rental_Due_Amount__c);
            actualRent += dueLine.cllease__Rental_Due_Amount__c;
            dueline.cllease__Tax_Due_Amount__c = 0;
            dueline.cllease__Id__c = terminationBill.cllease__Id__c;
            dueline.cllease__Due_Date__c = terminationBill.cllease__Due_Date__c;
            dueline.cllease__Contract_Equipment__c = equipmentId;

            //Currently code is duplicate in BillDetailGeneratorHandler and this class.
            //calculate tax
            //For Avalara,  Upfront tax and override tax are not permitted, so ignoring those in case of Avalara
            //For tax source other than avalara, tax exempted means we have processed the tax.
            if ((equipment.cllease__Tax_exemption__c
                || lacc.cllease__Account__r.cllease__Tax_Exemption__c)
                && (taxSource == null
                || taxSource != LendingConstants.TAX_SOURCE_AVALARA)) {
                //System.debug((LoggingLevel.FINE, 'Tax is exempted for equiment : ' + equipment.Name);
                dueLine.cllease__Tax_Processed__c = true;
                dueLine.cllease__Remarks__c = 'Tax is exempted on this Contract Equipment';
            }
            else if (taxSource != null
                && taxSource == LendingConstants.TAX_SOURCE_AVALARA) { //for avalara tax will be processed later
                dueLine.cllease__Tax_Processed__c = false;
                dueLine.cllease__Remarks__c = 'Tax is not yet processed. Tax source is Avalara.';
            }
            else if (equipment.cllease__Override_Tax_Flag__c) {
                //null tax rate is considered as 0
                if (equipment.cllease__Override_Tax_Rate__c != null
                    && equipment.cllease__Override_Tax_Rate__c > 0) {
                    dueLine.cllease__Tax_Due_Amount__c = cllease.ValueUtil.round((equipment.cllease__Override_Tax_Rate__c / 100)
                        * dueLine.cllease__Rental_Due_Amount__c);

                    //Ideally we should be able to use 'common -> createmessage'. TBD: AHR
                    dueLine.cllease__Remarks__c = ' Overriden Tax Rate :' + equipment.cllease__Override_Tax_Rate__c
                        + ' Rent Amount  ' + cllease.ValueUtil.round(dueLine.cllease__Rental_Due_Amount__c);
                }
                else if (equipment.cllease__Tax_Amount__c != null && equipment.cllease__Tax_Amount__c > 0) {
                    dueLine.cllease__Tax_Due_Amount__c = cllease.ValueUtil.round(equipment.cllease__Tax_Amount__c);

                    //Ideally we should be able to use 'common -> createmessage'. TBD: AHR
                    dueLine.cllease__Remarks__c = ' Overriden Tax Amount :' + equipment.cllease__Tax_Amount__c
                        + ' Rent Amount  ' + cllease.ValueUtil.round(dueLine.cllease__Rental_Due_Amount__c);
                }
                dueLine.cllease__Tax_Processed__c = true; //even if null or 0, we have processed the tax
            }
            else if (lacc.cllease__Branch__r.cllease__Tax_Basis__c == LendingConstants.TAX_METHOD_VAT
                && lacc.cllease__Branch__r.cllease__Vat_Rate__c > 0) {
                //Need to continue with earlier functionality
                //Avalara takes first priority, Vat and then CL Lease (or null)
                //Irrespective of inclusive or exclusive, we have the value on bill header
                if (lacc.cllease__Branch__r.cllease__Tax_Method__c == LendingConstants.TAX_METHOD_VAT_INCLUSIVE) {
                    Decimal rentalDue =  dueLine.cllease__Rental_Due_Amount__c;
                    Decimal unroundedRent = rentalDue / (1 + (lacc.cllease__Branch__r.cllease__Vat_Rate__c / 100));
                    Decimal rent = cllease.ValueUtil.round(unroundedRent);
                    dueLine.cllease__Tax_Due_Amount__c = cllease.ValueUtil.round(rentalDue - rent);
                    dueLine.cllease__Rental_Due_Amount__c = cllease.ValueUtil.round(rent);
                }
                else if (lacc.cllease__Branch__r.cllease__Tax_Method__c == LendingConstants.TAX_METHOD_VAT_EXCLUSIVE) {
                    dueLine.cllease__Tax_Due_Amount__c = cllease.ValueUtil.round((lacc.cllease__Branch__r.cllease__Vat_Rate__c / 100)
                        * dueLine.cllease__Rental_Due_Amount__c);
                }
                dueLine.cllease__Tax_Processed__c = true;

                //Ideally we should be able to use 'common -> createmessage'. TBD: AHR
                dueLine.cllease__Remarks__c = ' VAT Rate : ' + lacc.cllease__Branch__r.cllease__Vat_Rate__c
                    + ' Rent Amount : ' + cllease.ValueUtil.round(dueLine.cllease__Rental_Due_Amount__c);
            }
            else if (taxSource == null || taxSource == LendingConstants.TAX_SOURCE_CL_LEASE) {
                if (equipment.cllease__Total_Tax_Rate_Derived__c > 0) {
                    dueLine.cllease__Tax_Due_Amount__c = cllease.ValueUtil.round(getTotalTax(equipment, dueLine));
                    //Ideally we should be able to use 'common -> createmessage'. TBD: AHR
                    dueLine.cllease__Remarks__c = 'Total tax Rate : ' + equipment.cllease__Total_Tax_Rate_Derived__c
                        + ' Rent Amount : ' + cllease.ValueUtil.round(dueLine.cllease__Rental_Due_Amount__c)
                        + ' Surcharge is calulated separately on tax amount if applicable';
                }
                dueLine.cllease__Tax_Processed__c = true;
                //System.debug((LoggingLevel.FINE, 'Tax calculation complete');
            }
            if (!dueLine.cllease__Tax_Processed__c) {
                allTaxesProcessed = false;
            }
            //uow.addToInsert(dueLine);
            //uow.addRelationshipAndResolve(dueLine, bill);
            count++;
            totalRent += dueLine.cllease__Rental_Due_Amount__c;
            totalTax += dueLine.cllease__Tax_Due_Amount__c;
            dueline.cllease__Total_Due_Amount__c = cllease.ValueUtil.round(dueline.cllease__Rental_Due_Amount__c + dueline.cllease__Tax_Due_Amount__c, 2, 'Nearest');
            //System.debug((LoggingLevel.FINE, '----dueline: ' + dueline);
            dueLinesToCreate.add(dueLine);
        }
        terminationBill.cllease__Tax_Due_Amount__c = totalTax;
        terminationBill.cllease__Rental_Due_Amount__c = totalRent; //in case of vat inclusive rent amount is also recalculated
        terminationBill.cllease__Total_Due_Amount__c = cllease.ValueUtil.round(terminationBill.cllease__Rental_Due_Amount__c
            + terminationBill.cllease__Tax_Due_Amount__c, 2, 'Nearest');
        if (allTaxesProcessed) {
            terminationBill.cllease__Status__c = LendingConstants.BILL_STATUS_TAX_PROCESSED;
        }
    }

    /**
     * process the termination bill for quote lines in the termination quote header.  create the charge if needed.
     * Cash balances are also updated if the quote line is account balanceable.
     */
    private void processTermBillForQuoteLines() {
        Map<String, cllease__Cash_Account_Balance__c> balanceTypeToCashAccBalanceMap;
        balanceTypeToCashAccBalanceMap = new Map<String, cllease__Cash_Account_Balance__c>();
        for (cllease__Cash_Account_Balance__c balance : lacc.Cllease__Cash_Account_Balances__r) {
            balanceTypeToCashAccBalanceMap.put(balance.Cllease__Balance_Type__c, balance);
        }

        cllease__Lease_account_Due_Details__c bill = terminationBill;

        for (cllease__Termination_Quote_Line__c line : terminationLines) {
            //System.debug((LoggingLevel.FINE, '##### line: ' + line);

            // creating bills or charges based on the setup.
            if (line.cllease__Amount__c == null) {
                line.cllease__Amount__c = 0.00;
            }

            if (line.cllease__Billable__c
                && line.cllease__Amount_Type__c.equalsIgnoreCase('LINE')) {
                bill.cllease__Total_Due_Amount__c += line.cllease__Amount__c;

                if (line.cllease__Bill_Field_API_Name__c != null) {
                    //System.debug((LoggingLevel.FINE, '##### line: ' + line.Line_Type__c + '   bill field:' + line.Bill_Field_API_Name__c);

                    Decimal sum = 0;
                    if (bill.get(line.cllease__Bill_Field_API_Name__c) != null) {
                        sum = (Decimal) bill.get(line.cllease__Bill_Field_API_Name__c);
                    }
                    //System.debug((LoggingLevel.FINE, '##### value: ' + sum);

                    sum += line.cllease__Amount__c;
                    bill.put(line.cllease__Bill_Field_API_Name__c, sum);
                }
            }
            else if (line.cllease__Billable__c
                && line.cllease__Amount__c > 0.00 // This should be always true for Fee.
                && line.cllease__Amount_type__c.equalsIgnoreCase('FEE')) {
                cllease__Charge__c charge;
                charge = new cllease__Charge__c();
                charge.cllease__Date__c = cllease.SystemDateUtil.getCurrentSystemDate();
                charge.cllease__Original_Amount__c = line.cllease__Amount__c;
                charge.cllease__Fee_Definition__c = line.cllease__Fee_Definition__c;
                charge.cllease__GL_Transaction_Flag__c = true;
                charge.cllease__Transaction_Sub_Type__c = trxSubTypeMap.get(line.cllease__Line_Type__c);
                charge.cllease__Paid_Amount__c = 0;
                charge.cllease__Lease_Account__c = lacc.id;

                //taxCalculationOnChargeVoid(charge, line.cllease__Fee_Definition__r);

                chargesToCreate.add(charge);
                //System.debug((LoggingLevel.FINE, '## charge: ' + charge);
            }

            // creating cash balances based on the Termiantion config Line creation
            if (line.cllease__Is_Account_Balancable__c) {
                cllease__Cash_Account_Balance__c balance = balanceTypeToCashAccBalanceMap.get(line.cllease__Account_Balance_Type__c);
                if(balance != null) {
                    if (balance.cllease__Posted_Amount__c == null) {
                        balance.cllease__Posted_Amount__c = 0.0;
                    }
                    if (balance.cllease__Closing_Balance_Amount__c == null) {
                        balance.cllease__Closing_Balance_Amount__c = 0.0;
                    }
                    balance.cllease__Posted_Amount__c += line.cllease__Amount__c;
                    balance.cllease__Closing_Balance_Amount__c -= line.cllease__Amount__c;
                    if (!balToUpdate.containsKey(balance.Id)) {
                        balToUpdate.put(balance.Id, balance);
                    }
                }
            }
        }
    }

    /**
     * Process the refund through Cash Receipt in case of negative Termination Bill amount.
     * Termination Bill will not be generated for zero or negative amount.
     */
    private void processCashReceiptRefund() {
        if (terminationBill.cllease__Total_Due_Amount__c < 0) {
            // Create a Cash Receipt for the Lessee
            Decimal crAmount = -terminationBill.cllease__Total_Due_Amount__c;
            clcommon__Payment_Mode__c pMode = [SELECT Id, Name FROM clcommon__Payment_Mode__c where Name = :LendingConstants.PAYMENT_MODE_CASH];
            cashReceipt = new clcommon__Cash_Receipt__c();
            cashReceipt.clcommon__Account__c = lacc.cllease__Account__c;
            cashReceipt.clcommon__Receipt_Amount__c = crAmount;
            cashReceipt.clcommon__Unused_Amount__c = crAmount;
            cashReceipt.clcommon__Payment_Mode__c = pMode.Id;
            cashReceipt.clcommon__Receipt_Date__c = cllease.SystemDateUtil.getCurrentSystemDate();
            cashReceipt.clcommon__Creation_Date__c = cllease.SystemDateUtil.getCurrentSystemDate();
        }
        terminationBill = null;
        dueLinesToCreate = null;
    }

    /**
     * accelerate the accruals for the fees.
     */
    private void createAcceleratedAccruals() {
        acceleratedAccrualHeader = new cllease__Lease_Trx_Header__c();
        //acceleratedAccrualHeader.Contract__c = lacc.Id;
        acceleratedAccrualHeader.cllease__GL_Posted_Flag__c = false;
        acceleratedAccrualHeader.cllease__GL_Transaction_Flag__c = true;
        acceleratedAccrualHeader.cllease__Transaction_Type__c = 'ACCRUAL'; //AHR - check what is use of Lease_Trx_Header__c
        acceleratedAccrualHeader.cllease__Transaction_Date__c = cllease.SystemDateUtil.getCurrentSystemDate();
        acceleratedAccrualHeader.cllease__Amount__c = 0;

        for(Id feeScheduleId : billedAmountByFeeSchedule.keySet()) {
            //fee schedule present in billedAmountByFeeSchedule may not be present in accruedAmountByFeeSchedule
            //as a fee may not always be amortized
            if(accruedAmountByFeeSchedule.containsKey(feeScheduleId)) {
                Decimal billedAmount = billedAmountByFeeSchedule.get(feeScheduleId);
                Decimal accruedAmount = accruedAmountByFeeSchedule.get(feeScheduleId);
                //if billed amount > accrued amount, we need to create accrual txn for the difference
                //as charges are already billed
                //need to create accrual txn
                acceleratedAccrualHeader.cllease__Amount__c += billedAmount - accruedAmount;
                //create line
                cllease__Lease_Trx_Lines__c line = new cllease__Lease_Trx_Lines__c();
                //line.Contract__c = lacc.Id;
                line.cllease__Transaction_Sub_Type__c = txnSubTypeByFeeSchedule.get(feeScheduleId);
                line.cllease__Transaction_Date__c = cllease.SystemDateUtil.getCurrentSystemDate();
                line.cllease__Amount__c = billedAmount - accruedAmount;
                //GlobalContext.INSTANCE.addObjectForCurrencyUpdate(lacc.Id, line);
                //acceleartedAccrualsLines.add(line);
            }
        }

        for(Id feeId : unAccruedAmountByFeeSchedule.keySet()){
            acceleratedAccrualHeader.cllease__Amount__c += unAccruedAmountByFeeSchedule.get(feeId);
            cllease__Lease_Trx_Lines__c line = new cllease__Lease_Trx_Lines__c();
            line.cllease__Transaction_Sub_Type__c = txnSubTypeByFeeSchedule.get(feeId);
            line.cllease__Transaction_Date__c = cllease.SystemDateUtil.getCurrentSystemDate();
            line.cllease__Amount__c = unAccruedAmountByFeeSchedule.get(feeId);
            //GlobalContext.INSTANCE.addObjectForCurrencyUpdate(lacc.Id, line);
            //acceleartedAccrualsLines.add(line);
        }
    }

    /**
     * update the payment streams.
     * For fee type of payment streams if the stream is related to terminating equipment, deactivate all the streams.
     * For all the other streams, adjust the stream wrt rateFactorCost.
     */
    private void updatePaymentStreams() {
        //System.debug((LoggingLevel.FINE, 'inside updatePaymentStreams: fullTerminaion: ' +qh.Full_Termination__c);
        //System.debug((LoggingLevel.FINE, 'equipmentsToBeTerminated: ' +equipmentsToTerminate.keySet());
        Decimal adjustmentFactor = rateFactorCost;
        Set<Id> equipmentsToBeTerminated = equipmentsToTerminate.keySet();

        //in case of full as well as partial termination we need to do this
        for(cllease__Payment_Stream__c paymentStream: lacc.cllease__Payment_Streams__r) {
            if(paymentStream.cllease__Payment_Type__c != LendingConstants.PAYMENT_STREAM_PAYMENT_TYPE_FEES) {
                continue;
            }
            if(paymentStream.cllease__Contract_Fee__r.cllease__Contract_Equipment__c == null) {
                continue;
            }
            Id equipmentId = paymentStream.cllease__Contract_Fee__r.cllease__Contract_Equipment__c;
            if(equipmentsToBeTerminated.contains(equipmentId)) {
                System.debug(LoggingLevel.ERROR, 'Processing paymentStream: '+paymentStream);
                if(paymentStream.cllease__Date__c < qh.cllease__Termination_Date__c) {
                    Decimal billedFeeAmount = 0;
                    if(billedAmountByFeeSchedule.containsKey(paymentStream.cllease__Contract_Fee__c)) {
                        billedFeeAmount = billedAmountByFeeSchedule.get(paymentStream.cllease__Contract_Fee__c);
                    }
                    billedFeeAmount += paymentStream.cllease__Rental_Amount__c;
                    billedAmountByFeeSchedule.put(paymentStream.cllease__Contract_Fee__c, billedFeeAmount);
                }
                else if(!qh.cllease__Full_Termination__c) {
                    paymentStream.cllease__Active__c = false;
                    paymentStreamsToUpdateById.add(paymentStream);
                }
            }
        }

        // incase of fullTermination
        if(qh.cllease__Full_Termination__c) {
            // disabling all unbilled payment streams incase of full termination
            for (cllease__Payment_Stream__c paymentStream: lacc.cllease__Payment_Streams__r) {
                if (paymentStream.cllease__Date__c >= qh.cllease__Termination_Date__c) {
                    paymentStream.cllease__Billed__c = false;
                    paymentStream.cllease__Active__c = false;
                    paymentStream.cllease__comment__c = LendingConstants.TERMINATION_STREAM_ACCRUAL_COMMENT;
                    paymentStreamsToUpdateById.add(paymentStream);
                }
            }
        }
        else {
            Decimal beginningReceivable = 0, unbilledAmount = 0;
            Decimal originalPayAmount = 0, newPayAmount = 0;
            List<cllease__Payment_Stream__c> pmtStreamsAfterTerminationDate = new List<cllease__Payment_Stream__c>();

            for (cllease__Payment_Stream__c paymentStream: lacc.cllease__Payment_Streams__r) {
                if(paymentStream.cllease__Date__c < qh.cllease__Termination_Date__c) {
                    continue;
                }
                if(trxSubTypeMap.get(LendingConstants.TXN_SUBTYPE_PERIODIC_RENT) != paymentStream.cllease__Transaction_Sub_Type__c
                    && trxSubTypeMap.get(LendingConstants.TXN_SUBTYPE_EVERGREEN_RENT) != paymentStream.cllease__Transaction_Sub_Type__c) {
                    continue;
                }
                paymentStream.cllease__Billed__c = false;
                unbilledAmount += paymentStream.cllease__Rental_Amount__c;
                if(paymentStream.cllease__Contract__r.cllease__Has_Asset_Level_Rent__c) {
                    adjustmentFactor = selectedAssetRentCost/paymentStream.cllease__Rental_Amount__c;
                }
                pmtStreamsAfterTerminationDate.add(paymentStream);
            }
            beginningReceivable = unbilledAmount - cllease.ValueUtil.round(unbilledAmount * adjustmentFactor);
            for (cllease__Payment_Stream__c paymentStream :pmtStreamsAfterTerminationDate) {

                originalPayAmount = paymentStream.cllease__Rental_Amount__c;
                newPayAmount = originalPayAmount - cllease.ValueUtil.round(originalPayAmount * adjustmentFactor);
                paymentStream.cllease__Rental_Amount__c = newPayAmount;
                paymentStream.cllease__Beginning_Receivable__c = beginningReceivable;
                paymentStream.cllease__Ending_Receivable__c    = beginningReceivable - newPayAmount ;
                beginningReceivable = paymentStream.cllease__Ending_Receivable__c;
                paymentStreamsToUpdateById.add(paymentStream);
            }
        }
    }


    /**
     * update excess cash balance.
     *
     * @param leaseAccount
     * @param terminationLines
     */
    private void updateExcessCashBalances(cllease__Lease_Account__c leaseAccount,
        List<cllease__Termination_Quote_Line__c> terminationLines) {

        //Like the way excess account balance was updated, update the excess field in leaseAccount as well
        if(leaseAccount.cllease__Excess__c != null && leaseAccount.cllease__Excess__c != 0) {
            for (cllease__Termination_Quote_Line__c quoteLine : terminationLines) {
                if (quoteLine.cllease__Line_Type__c == 'EXCESS') {
                    leaseAccount.cllease__Excess__c += quoteLine.cllease__Amount__c;
                }
            }
            //System.debug((LoggingLevel.ERROR, '^^^leaseAccount:' + leaseAccount);
        }

    }

    /**
     * Update the quote headers with all neccesary fields.
     *
     * @param isBulkAPICall
     * @param isAPICall
     */
    public void markQuoteHeaderAsGenerated( Boolean isBulkAPICall, Boolean isAPICall) {
        if (isBulkAPICall) {
            totalEquipCost = lacc.cllease__Equipment_Selling_Price__c;
            //System.debug((LoggingLevel.FINE, '(BulkAPI = true)Total Non-Terminated Equipment Cost: ' + totalEquipCost);
        }
        if (isAPICall) {
            qh.cllease__Quote_Type__c = LendingConstants.TERMINATION_QUOTE_TYPE_WITH_PURCHASE;
            qh.cllease__Quote_Reason__c = LendingConstants.TERMINATION_QUOTE_REASON_CUSTOMER_REQ;
        }

        if (totalEquipCost > 0) {
            rateFactorCost = (selectedEquipCost / totalEquipCost);
        }

        //System.debug(LoggingLevel.FINE, 'Terminating Equipments Unit Rate Factor :' + rateFactorCost);

        if (totalEquipCost == selectedEquipCost) {
            qh.cllease__Full_Termination__c = true;
        }

        //System.debug((LoggingLevel.FINE, 'quoteHeader.Full_Termination__c = ' + qh.Full_Termination__c);


        // Updating termination quote header
        qh.cllease__Effective_From__c = cllease.SystemDateutil.getCurrentSystemDate();
        qh.cllease__Contract__c = lacc.Id;
        qh.cllease__Status__c = LendingConstants.TERMINATION_QUOTE_STATUS_GENERATED;
        qh.cllease__Effective_To__c = getTerminationExpiryDate();
    }

    /**
     * Go through the termination config and create the termination quote lines as required.
     * also create termination quote line for excessAmount.
     *
     * @param terminationConfig
     */
    public void computeQuoteLines(cllease__Termination_Config__c terminationConfig) {
        qh.cllease__Quote_Amount__c = 0.0;

        System.debug(LoggingLevel.ERROR, 'terminationConfig = ' + terminationConfig);
        processTerminationConfigLines(terminationConfig);
        qh.cllease__Termination_With_Purchase__c = terminationConfig.cllease__Termination_With_Purchase__c;


        // check if excess cash balance is present
        Decimal excessAmount = 0;
        excessAmount = lacc.cllease__Excess__c;

        if (excessAmount > 0) {
            // create EXCESS Termination Quote Line
            cllease__Termination_Quote_Line__c excessLine = new cllease__Termination_Quote_Line__c();
            excessLine.cllease__Amount__c = -excessAmount;
            excessLine.cllease__Line_Type__c = LendingConstants.TERMINATION_CONFIG_EXCESS;
            terminationLines.add(excessLine);
            qh.cllease__Quote_Amount__c -= excessAmount;
        }

        processTerminationConfigFees(terminationConfig);
    }

    public void populateEquipAndEqipDetailForTermination(Set<Id> eqpOrEqpDetailsIdsForTermination) {
        //System.debug((LoggingLevel.ERROR, 'populateEquipAndEqipDetailForTermination() - eqpOrEqpDetailsIdsForTermination = ' + eqpOrEqpDetailsIdsForTermination);
        for(cllease__Contract_Equipment__c eqp1 : lacc.cllease__Contract_Equipments__r) {
            if(eqp1.cllease__Status__c == LendingConstants.STATUS_TERMINATED) {
                continue;
            }
            TerminationQuoteAction.Equipment equipment = new TerminationQuoteAction.Equipment(eqp1);
            allActiveEquipments.put(eqp1.Id, equipment);
        }

        // Calculating Total Equipment Cost for Equipment Level Termination
        if(qh.cllease__Is_Equipment_Termination__c) {
            //System.debug((LoggingLevel.ERROR, 'populateEquipAndEqipDetailForTermination() - contract-eqp level termination');
            for(Id equipmentId : eqpOrEqpDetailsIdsForTermination) {
                TerminationQuoteAction.Equipment equipmentUnit = allActiveEquipments.get(equipmentId);
                //System.debug((LoggingLevel.ERROR, 'populateEquipAndEqipDetailForTermination() - equipmentUnit = ' + equipmentUnit);
                equipmentUnit.isSelected = true;
            }
            //get all equipment details for all selected equipments.
            /* List<clcommon__Equipment_Detail__c> eqpDetails;

            //This will be loopy query - we need to revisit
            eqpDetails = EquipmentDetailUtil.getEquipmentDetails(eqpOrEqpDetailsIdsForTermination, true);
            for(clcommon__Equipment_Detail__c eqpDetail : eqpDetails) {
                TerminationQuoteAction.Equipment parentEquip = allActiveEquipments.get(eqpDetail.cllease__Contract_Equipment__c);
                TerminationQuoteAction.Equipment childEquip = new TerminationQuoteAction.Equipment(eqpDetail);
                 parentEquip.addEqpDetailsToEqp(childEquip);
                 //System.debug((LoggingLevel.ERROR, 'populateEquipAndEqipDetailForTermination() - parentEquip = ' + parentEquip);
            }
            */
        }
        // Commenting the Equipment Unit level Termination
        /*else {
            //System.debug((LoggingLevel.ERROR, 'populateEquipAndEqipDetailForTermination() - eqpDetail level termination');

            Set<String> reqStatus = new Set<String>{
                LendingConstants.CONTRACT_EQUIPMENT_STATUS_TO_BE_TERMINATED,
                LendingConstants.MASTER_EQ_LEASED
            };
            Set<String> contractIds = new Set<String>{lacc.Id};
            Map<Id, Map<Id, clcommon__Equipment_Detail__c>> contractsToEqpDetailsMap;

            //This will be loopy query - we need to revisit
            contractsToEqpDetailsMap = EquipmentDetailUtil.getEquipmentDetailsMapForContracts(contractIds, reqStatus);

            if(contractsToEqpDetailsMap != null
                && contractsToEqpDetailsMap.containsKey(lacc.Id)) {
                Map<Id, clcommon__Equipment_Detail__c> eqpDetailMap;
                eqpDetailMap = contractsToEqpDetailsMap.get(lacc.Id);

                for(clcommon__Equipment_Detail__c eqpDetail : eqpDetailMap.values()) {
                    if (eqpDetail.clcommon__Status__c == LendingConstants.STATUS_TERMINATED) {
                        continue;
                    }

                    
                    TerminationQuoteAction.Equipment equipmentUnit = new TerminationQuoteAction.Equipment(eqpDetail);
                    if(eqpOrEqpDetailsIdsForTermination.contains(eqpDetail.Id)) {
                        equipmentUnit.isSelected = true;
                    }
                    //System.debug((LoggingLevel.ERROR, 'populateEquipAndEqipDetailForTermination() - equipmentUnit = ' + equipmentUnit);
                    
                    TerminationQuoteAction.Equipment parentEquip = allActiveEquipments.get(equipmentUnit.getParentId());
                    parentEquip.addEqpDetailsToEqp(equipmentUnit);
                    //System.debug((LoggingLevel.ERROR, 'populateEquipAndEqipDetailForTermination() - parentEquip = ' + parentEquip);


                }
            }
        }*/
    }

    private void  processTerminationConfigLines(cllease__Termination_Config__c terminationConfig)  {
        //System.debug(LoggingLevel.FINE, 'rateFactorCost = ' + rateFactorCost);
        //List<cllease__Termination_Quote_Line__c> configQuoteLines = new List<cllease__Termination_Quote_Line__c>();
        for (cllease__Termination_Config_Line__c termCfgLine : terminationConfig.cllease__Termination_Config_Lines__r) {
            System.debug(LoggingLevel.ERROR, 'processTerminationConfigLines:termCfgLine = ' + termCfgLine);
            cllease__Termination_Quote_Line__c quote = new cllease__Termination_Quote_Line__c();
            quote.cllease__Amount_Type__c = 'LINE';
            quote.cllease__Billable__c = termCfgLine.cllease__Is_Billable__c;
            quote.cllease__Line_Type__c = termCfgLine.cllease__Quote_Line__c;
            quote.cllease__Account_Balance_Type__c = termCfgLine.cllease__Account_Balance_Type__c;
            quote.cllease__Is_Account_Balancable__c = termCfgLine.cllease__Is_Account_Balancable__c;
            quote.cllease__Add_To_Quote_Amount__c = termCfgLine.cllease__Add_To_Quote_Amount__c;
            quote.cllease__Bill_Field_API_Name__c = termCfgLine.cllease__Bill_Field_API_Name__c;

            if (termCfgLine.cllease__Quote_Line__c == LendingConstants.TERMINATION_CONFIG_UNBILLED_RECEIVABLE) {
                Decimal amount = getUnbilledReceivable();
                quote.cllease__Amount__c = amount * rateFactorCost;
            }
            else if (termCfgLine.cllease__Quote_Line__c == LendingConstants.TERMINATION_CONFIG_UNPAID_RENT
                || termCfgLine.cllease__Quote_Line__c == LendingConstants.TERMINATION_CONFIG_UNPAID_TAX) {
                Decimal amount = getBilledUnpaidReceivables(termCfgLine.cllease__Quote_Line__c);
                quote.cllease__Amount__c = amount * rateFactorCost;
            }
            else if (termCfgLine.cllease__Quote_Line__c == LendingConstants.TERMINATION_CONFIG_UNPAID_CHARGE) {
                Decimal amount = getChargesUnpaidReceivables();
                quote.cllease__Amount__c = amount * rateFactorCost;
            }
            else if (termCfgLine.cllease__Quote_Line__c == LendingConstants.TERMINATION_CONFIG_DISCOUNT) {
                if (termCfgLine.cllease__Field_API_Name__c == null) {
                    continue;
                }
                Decimal amount = 0.0;
                if (lacc.get(termCfgLine.cllease__Field_API_Name__c) != null) {
                    amount = (Decimal) lacc.get(termCfgLine.cllease__Field_API_Name__c);
                }
                quote.cllease__Amount__c = -1 * amount * rateFactorCost;
            }
            else if (termCfgLine.cllease__Quote_Line__c == LendingConstants.TERMINATION_CONFIG_SECURITY_DEPOSIT) {
                if (!qh.cllease__Full_Termination__c) {
                    continue;
                }
                quote.cllease__Amount__c = 0.0;
                if (lacc.cllease__Security_Deposit_Amount__c != null) {
                    quote.cllease__Amount__c = -1 * lacc.cllease__Security_Deposit_Amount__c;
                }
            }
            else if(termCfgLine.cllease__Quote_Line__c == LendingConstants.TERMINATION_CONFIG_PURCHASE_AMOUNT) {
                System.debug(LoggingLevel.ERROR, 'quote line is for purchase amount, setting purchaseAmountQuoteLineExists to true');
                if (termCfgLine.cllease__Field_API_Name__c == null) { // No field given, cant generate.
                    continue;
                }
                Decimal amount = ((Decimal) lacc.get(termCfgLine.cllease__Field_API_Name__c));
                quote.cllease__Amount__c = (amount != null ? amount : 0) * rateFactorCost;
            }
            else {
                if (termCfgLine.cllease__Field_API_Name__c == null) {
                    continue;
                }
                Decimal amount = ((Decimal) lacc.get(termCfgLine.cllease__Field_API_Name__c));
                quote.cllease__Amount__c = (amount != null ? amount : 0) * rateFactorCost;


            }

            quote.cllease__Amount__c = cllease.ValueUtil.round(quote.cllease__Amount__c);
            if(quote.cllease__Add_To_Quote_Amount__c) {
                qh.cllease__Quote_Amount__c += (quote.cllease__Amount__c != null ? quote.cllease__Amount__c : 0);
                qh.cllease__Quote_Amount__c = cllease.ValueUtil.round(qh.cllease__Quote_Amount__c);
            }

            terminationLines.add(quote);
            //System.debug((LoggingLevel.FINE, '### LINE: ' + quote);
        }

        if (terminationConfig.cllease__Third_Party_Sale__c) {
            cllease__Termination_Quote_Line__c quote = processThirdPartySaleQuoteLine();
            terminationLines.add(quote);
        }

    }

    public cllease__Termination_Quote_Line__c processThirdPartySaleQuoteLine() {
        cllease__Termination_Quote_Line__c quote = new cllease__Termination_Quote_Line__c();
        quote.cllease__Amount_Type__c = 'LINE';
        quote.cllease__Billable__c = true;
        quote.cllease__Line_Type__c = LendingConstants.TERMINATION_QUOTE_LINE_TYPE_REBATE_AMOUNT;
        quote.cllease__Account_Balance_Type__c = LendingConstants.LEASE_CASHBAL_LEASE_RECEIVABLE;
        quote.cllease__Is_Account_Balancable__c = false;
        quote.cllease__Add_To_Quote_Amount__c = false;
        quote.cllease__Bill_Field_API_Name__c = null;
        quote.cllease__Amount__c = cllease.ValueUtil.round(-qh.cllease__Rebate_Amount__c);
        return quote;
    }

    private Decimal getUnbilledReceivable() {
        //System.debug((LoggingLevel.FINE, 'getUnbilledReceivable(): term date = ' + qh.Termination_Date__c);

        Decimal amount = 0.0;
        List<cllease__Payment_Stream__c> pmtStreams = lacc.cllease__Payment_Streams__r;
        for(cllease__Payment_Stream__c pmt : pmtStreams) {
            //System.debug((LoggingLevel.FINE, 'amount = ' + amount +  'pmt = ' + pmt);
            if(isPmtStreamForRentals(pmt) && pmt.cllease__Date__c >= qh.cllease__Termination_Date__c) {
                amount += pmt.cllease__Rental_Amount__c;
            }
        }
        return amount;
    }

    private Decimal getBilledUnpaidReceivables(String billComponent) {
        if(String.isBlank(billComponent)) {
            return 0.0;
        }

        //System.debug((LoggingLevel.FINE, 'getBilledUnpaidReceivables(): billComponent = ' + billComponent);
        String fieldName1;
        String fieldName2;
        Boolean billComponentIsTax = false;
        if(billComponent.equalsIgnoreCase(LendingConstants.TERMINATION_CONFIG_UNPAID_RENT) == true) {
            fieldName1 = CLSCustomUtil.getNSWithUnderScore() + 'Rental_Due_Amount__c';
            fieldName2 = CLSCustomUtil.getNSWithUnderScore() + 'Rental_Paid_Amount__c';
        }
        else if(billComponent.equalsIgnoreCase(LendingConstants.TERMINATION_CONFIG_UNPAID_TAX) == true) {
            fieldName1 = CLSCustomUtil.getNSWithUnderScore() + 'Tax_Due_Amount__c';
            fieldName2 = CLSCustomUtil.getNSWithUnderScore() + 'Tax_Paid_Amount__c';
            billComponentIsTax = true;
        }
        else {
            throw new CLSCustomException('Incorrect Bill Component provided');
        }

        Decimal amount = 0.0;

        //System.debug((LoggingLevel.FINE, 'getBilledUnpaidReceivables(): fields = ' + fieldName1 + ' & ' + fieldName2);
        List<cllease__Lease_Account_Due_Details__c> billList = lacc.cllease__Dues_Details__r;

        //System.debug((LoggingLevel.FINE, 'getBilledUnpaidReceivables(): billList size = ' + billList.size());
        //System.debug((LoggingLevel.FINE, 'getBilledUnpaidReceivables(): qh.Termination_Date__c = ' + qh.Termination_Date__c);

        //Please note that it is assumed that tax is processed by the time termination is called.
        for(cllease__Lease_Account_Due_Details__c bill : billList) {
            //System.debug((LoggingLevel.FINE, 'getBilledUnpaidReceivables(): bill = ' + bill);

            if(bill.cllease__Payment_Satisfied__c) {
                continue;
            }

            if(bill.cllease__Due_Date__c < qh.cllease__Termination_Date__c) {
                Decimal dueAmount = 0.00;
                if(bill.get(fieldName1) != null) {
                    dueAmount = (Decimal) bill.get(fieldName1);
                }

                Decimal paidAmount = 0.00;
                if(bill.get(fieldName2) != null) {
                    paidAmount = (Decimal)bill.get(fieldName2);
                }

                amount += (dueAmount - paidAmount);
                //System.debug((LoggingLevel.FINE, 'getBilledUnpaidReceivables(): field amounts = ' + dueAmount + ' & ' + paidAmount);
            }
        }

        //As the termination date can be in future, some of the bills are still not created. We would need to
        //consider that amount also as unpaid bills.
        //
        // In case billComponent is 'BILLED NOT PAID - TAX' , the value of tax on payment-stream may not be calculated
        // if the tax base is not 'VAT'. We would assume it to be zero in that case. However if this line is part of termination bill, it
        // will be incorrect tax amount. So we may have to populate the tax. [AHR - to discuss]

        List<cllease__Payment_Stream__c> pmtStreams = lacc.cllease__Payment_Streams__r;
        for(cllease__Payment_Stream__c pmt : pmtStreams) {

            if(pmt.cllease__Billed__c == false && isPmtStreamForRentals(pmt)
                && pmt.cllease__Date__c < qh.cllease__Termination_Date__c){

                if(billComponentIsTax) {
                    if(pmt.cllease__Tax__c != null) {
                        amount += pmt.cllease__Tax__c;
                        //System.debug((LoggingLevel.FINE, 'getBilledUnpaidReceivables(): fields amount(tax) = ' +  pmt.Tax__c);
                    }
                }
                else {
                    //System.debug((LoggingLevel.FINE, 'getBilledUnpaidReceivables(): fields amount(rent) = ' +  pmt.Rental_Amount__c);
                    amount += pmt.cllease__Rental_Amount__c;
                }
            }
        }
        return amount;
    }

    private Boolean isPmtStreamForRentals(cllease__Payment_Stream__c pmt) {
        Boolean isRentalStream = false;
        if(pmt.cllease__Payment_Type__c.equalsIgnoreCase('RENT')
            || pmt.cllease__Payment_Type__c.equalsIgnoreCase('EVERGREEN RENT')) {
            isRentalStream = true;
        }
        return isRentalStream;
    }

    private Boolean isPmtStreamForFees(cllease__Payment_Stream__c pmt) {
        Boolean isFeeStream = false;
        if(pmt.cllease__Payment_Type__c.equalsIgnoreCase('FEES')) {
            isFeeStream = true;
        }
        return isFeeStream;
    }

    private Decimal getChargesUnpaidReceivables() {
        Decimal amount = 0.0;
        //System.debug(LoggingLevel.FINE, 'getChargesUnpaidReceivables(): entering => termination dte = ' + qh.Termination_Date__c);
        List<cllease__Charge__c> charges = lacc.cllease__Charges__r;
        for(cllease__Charge__c chrg : charges) {
            //System.debug(LoggingLevel.FINE, 'amount = ' + amount +  'chrg = ' + chrg);
            if(chrg.cllease__Paid__c == false
                && chrg.cllease__Date__c < qh.cllease__Termination_Date__c) {
                amount += (chrg.cllease__Total_Due_Amount__c - chrg.cllease__Paid_Amount__c);
            }
        }

        //if termination date is in future, then fee-streams in future should be considered.
        List<cllease__Payment_Stream__c> pmtStreams = lacc.cllease__Payment_Streams__r;
        for(cllease__Payment_Stream__c pmt : pmtStreams) {
            //System.debug(LoggingLevel.FINE, 'amount = ' + amount +  'pmt = ' + pmt);
            if(pmt.cllease__Billed__c == false && isPmtStreamForFees(pmt)
                && pmt.cllease__Date__c < qh.cllease__Termination_Date__c) {
                amount += pmt.cllease__Rental_Amount__c;
            }
        }

        return amount;
    }
    
    private Date getTerminationExpiryDate() {
        Date expiryDate;
        Integer quoteEffectiveDays = 15; //Default Quote Effective Days
        Date systemDate = cllease.SystemDateUtil.getCurrentSystemDate();
        
        Boolean considerPreBillDays = false;
        TerminationQuoteAction terminationAction = new TerminationQuoteAction();
        cllease__Termination_Config__c terminationConfig = terminationAction.getMatchingTerminationConfig(lacc, qh);

        // Check if matching Termination-Configuration is found at the product and contract is not in evergreen
        if (terminationConfig != null && systemDate <= lacc.cllease__Maturity_Date__c) {

            considerPreBillDays = terminationConfig.cllease__Consider_Pre_Bill_Days__c;
            if (considerPreBillDays && lacc.cllease__Next_Due_Generation_Date__c != null)
                expiryDate = lacc.cllease__Next_Due_Generation_Date__c.addDays(-1);
            else if (lacc.cllease__Next_Due_Date__c != null)
                expiryDate = lacc.cllease__Next_Due_Date__c.addDays(-1);
        }

        // If expiryDate is somehow not populated due to failure of any internal conditions
        if (expiryDate == null) {
            // Check if Quote Effective Days is mentioned at the product, else take default as 15
            if(lacc.cllease__lease_product_name__r.cllease__quote_effective_Days__c != null)
                quoteEffectiveDays = (Integer) lacc.cllease__lease_product_name__r.cllease__quote_effective_Days__c;
            expiryDate = qh.cllease__Effective_From__c.addDays((Integer) quoteEffectiveDays);
        }

        if(expiryDate >= lacc.cllease__Maturity_Date__c) {
            if(lacc.cllease__Lease_Status__c == LendingConstants.STATUS_EVERGREEN) {
                // if evergreen contract effetive to date should be next evergreen term date
                TerminationActionUnit.TerminationContract termContract = new TerminationActionUnit.TerminationContract(lacc);
                expiryDate = termContract.getEverGreenEndDate();
            } else {
                // If Expiry Date falls after Maturity, then updating the same as Maturity Date.                    
                expiryDate = lacc.cllease__Maturity_Date__c;
            }
           
        }
        return expiryDate;        
    }
    
    private Boolean isEarlyTermination() {
        Boolean earlyTermination = false;
        Integer termLeadDays = 15;// Defualt Quote Lead Days
        if (lacc.cllease__lease_product_name__r.cllease__Termination_Lead_Days__c != null) {
            termLeadDays = (Integer) lacc.cllease__lease_product_name__r.cllease__Termination_Lead_Days__c;
        }

        if (qh.cllease__Termination_Date__c <= lacc.cllease__Maturity_Date__c.addDays(-1 * termLeadDays)) {
            earlyTermination = true;
        }
        return earlyTermination;
    }

    //Compute config lines for fees. update quote header for the total quote amount.
    private void  processTerminationConfigFees(cllease__Termination_Config__c terminationConfig) {
        qh.cllease__Early_Termination__c = isEarlyTermination();
        Boolean earlyTermination = qh.cllease__Early_Termination__c;
        for (cllease__Termination_Config_Fee__c fee : terminationConfig.cllease__Termination_Config_Fees__r) {
            // EARLY TERMINATION CHECKS
            if (fee.cllease__Quote_Reason__c == qh.cllease__Quote_Reason__c
                && fee.cllease__Quote_Type__c == qh.cllease__Quote_Type__c
                && ((fee.cllease__Termination_Type__c == LendingConstants.TERMINATION_TYPE_EARLY
                && earlyTermination)
                || (fee.cllease__Termination_Type__c == LendingConstants.TERMINATION_TYPE_END_OF_TERM
                && !earlyTermination))) {
                cllease__Termination_Quote_Line__c quote;
                quote = new cllease__Termination_Quote_Line__c();
                quote.cllease__Line_Type__c = fee.cllease__Fee_Definition__r.Name;
                quote.cllease__Amount__c = (fee.cllease__Fee_Amount__c != null ? fee.cllease__Fee_Amount__c : 0.00);
                quote.cllease__Fee_Definition__c = fee.cllease__Fee_Definition__c;
                quote.cllease__Amount_Type__c = 'FEE';
                quote.cllease__Billable__c = true;
                terminationLines.add(quote);
                qh.cllease__Quote_Amount__c += quote.cllease__Amount__c;
            }
        }
    }

    //This function is not required as per the fix for LD-1631. Keeping this for now, once confirmed that this is not needed, we will remove this.
    private cllease__Termination_Quote_Line__c getQuoteLineWithPurchase(cllease__Lease_Account__c leaseAccount) {
        Map<String, Decimal> BeginValueMap = new Map<String, Decimal>();
        Map<String, Decimal> EndValueMap = new Map<String, Decimal>();
        Map<String, Date> PaymentMap = new Map<String, Date>();

        for (cllease__Payment_Stream__c payment : leaseAccount.cllease__Payment_Streams__r) {
            PaymentMap.put(getDateKey(payment.cllease__Date__c), payment.cllease__date__c);
        }

        if (leaseAccount.cllease__lease_product_name__r.cllease__Product_sub_type__C == LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE) {
            for (cllease__Rental_Stream__c income : leaseAccount.cllease__Rental_streams__r) {
                BeginValueMap.put(getDateKey(income.cllease__Date__c), income.cllease__Beginning_Net_Book_Value__c);
                EndValueMap.put(getDateKey(income.cllease__Date__c), income.cllease__Ending_Net_Book_Value__c);
            }
        }
        else if (leaseAccount.cllease__lease_product_name__r.cllease__Product_sub_type__C == LendingConstants.PRODUCT_SUB_TYPE_OP_LEASE) {
            for (cllease__Dep_Streams__c dep : leaseAccount.cllease__Dep_Streams__r) {
                BeginValueMap.put(getDateKey(dep.cllease__Date__c), dep.cllease__Beginning_Residual__c);
                EndValueMap.put(getDateKey(dep.cllease__Date__c), dep.cllease__Ending_Residual__c);
            }
        }

        cllease__Termination_Quote_Line__c quote;
        quote = new cllease__Termination_Quote_Line__c();
        quote.cllease__Amount_Type__c = 'LINE';
        quote.cllease__Billable__c = true;
        quote.cllease__Line_Type__c = LendingConstants.TERMINATION_CONFIG_PURCHASE_AMOUNT;
        quote.cllease__Add_To_Quote_Amount__c = true;
        quote.cllease__Bill_Field_API_Name__c = 'Purchase_Amount__c';

        if (leaseAccount.cllease__Residual_Type__c == null
            || leaseAccount.cllease__Residual_Type__c == 'FMV') {
            quote.cllease__Amount__c = (selectedEquipResidual == null ? 0 : selectedEquipResidual);
        }
        else {
            String effectiveDateKey = getDateKey(qh.cllease__Termination_Date__c);
            Decimal totalPurchaseAmount = 0.0;
            if (leaseAccount.cllease__lease_product_name__r.cllease__Product_sub_type__C == LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE) {
                if (PaymentMap.get(effectiveDateKey) > qh.cllease__Termination_Date__c) {
                    totalPurchaseAmount = BeginValueMap.get(effectiveDateKey);
                } else {
                    totalPurchaseAmount = EndValueMap.get(effectiveDateKey);
                }
            }
            quote.cllease__Amount__c = (totalPurchaseAmount != null ? totalPurchaseAmount : 0) * rateFactorCost;
        }
        return quote;
    }

    private String getDateKey(Date date1) {
        return String.valueof(date1.year()) + String.valueof(date1.month()).leftpad(2).replace(' ', '0');
    }


    /**
     * add to total equipment cost, residual amount and subvention amount for given equipment. as the equipment
     * is always stores the contract equipment, the various values are cumulative if the eqp details are selected.
     *
     * @param equipmentUnit
     */
    //by construction the equipmentUnit will always point to ContractEquipment
    public void computeEquipmentCostAndResiduals(TerminationQuoteAction.Equipment equipmentUnit) {
        Decimal eqpCost = equipmentUnit.getEqpCost();
        Decimal eqpResidualValue = equipmentUnit.getEqpResidualValue();
        Decimal subventionAmount = equipmentUnit.getSubventionAmount();
        Decimal subsidyAmount = equipmentUnit.getSubsidyAmount();

        totalEquipCost += eqpCost;
        totalEquipResidualAmt += eqpResidualValue;
        totalSubventionAmount += subventionAmount;
        totalSubsidyAmount += subsidyAmount;

        //it is possible that some of the equipmentdetails are selected
        selectedEquipCost += equipmentUnit.getSelectedEqpCost();
        selectedEquipResidual += equipmentUnit.getSelectedEqpResidualValue();
        selectedSubventionAmount += equipmentUnit.getSelectedSubventionAmount();
        selectedSubsidyAmount += equipmentUnit.getSelectedSubsidyAmount();
    }

    private Decimal getTotalTax(cllease__Contract_Equipment__c equipment, cllease__Due_Detail_Lines__c dueLine) {
        // Updating the Tax Details in Due Detail line after CL Lease Tax Setup Calculations.
        TaxWithSurcharge cityTax = new TaxWithSurcharge(dueLine.cllease__Rental_Due_Amount__c,
            equipment.cllease__City_Tax_Rate__c,
            equipment.cllease__City_Surcharge__c);
        dueLine.cllease__City_Tax__c = cityTax.tax;
        dueLine.cllease__City_Surcharge__c = cityTax.surcharge;

        TaxWithSurcharge countyTax = new TaxWithSurcharge(dueLine.cllease__Rental_Due_Amount__c,
            equipment.cllease__County_Tax_Rate__c,
            equipment.cllease__County_Surcharge__c);
        dueLine.cllease__County_Tax__c = countyTax.tax;
        dueLine.cllease__County_Surcharge__c = countyTax.surcharge;

        TaxWithSurcharge stateTax = new TaxWithSurcharge(dueLine.cllease__Rental_Due_Amount__c,
            equipment.cllease__State_Tax_Rate__c,
            equipment.cllease__State_Surcharge__c);
        dueLine.cllease__State_Tax__c = stateTax.tax;
        dueLine.cllease__State_Surcharge__c = stateTax.surcharge;

        Decimal totalTax = 0.0;
        totalTax += cityTax.tax + cityTax.surcharge;
        totalTax += countyTax.tax + countyTax.surcharge;
        totalTax += stateTax.tax + stateTax.surcharge;
        return  totalTax;
    }

    private void reComputeVariousContractParameters() {
        //TODO: Oldest Due Date ? Can we find this. do we have bills to find Oldest Due Date? The delinquency job should find this.
        //Last Due Date => this is date for the last generated bill. We would set it to be the last bill which is not restructured.
        //this is same as last billed payment stream's date
        //the next due date is the first unbilled payment stream's date
        //the next due generation date is the
        Date lastDueDate = null;
        Date nextDueDate = null;
        Date nextDueGenDate = null;
        for(cllease__Payment_Stream__c pmtStream :lacc.cllease__Payment_Streams__r) {
            if(trxSubTypeMap.get(LendingConstants.TXN_SUBTYPE_PERIODIC_RENT) != pmtStream.cllease__Transaction_Sub_Type__c
                && trxSubTypeMap.get(LendingConstants.TXN_SUBTYPE_EVERGREEN_RENT) != pmtStream.cllease__Transaction_Sub_Type__c) {
                continue;
            }
            if(pmtStream.cllease__Billed__c) {
                if(lastDueDate == null || lastDueDate < pmtStream.cllease__Date__c ) {
                    lastDueDate = pmtStream.cllease__Date__c;
                }
            }
            else {
                if(nextDueDate == null) {
                    nextDueDate = pmtStream.cllease__Date__c;
                    nextDueGenDate = nextDueDate.addDays((-1)*lacc.cllease__Pre_Bill_Days__c.intValue());
                }
            }
        }
        lacc.cllease__Next_Due_Date__c = nextDueDate;
        lacc.cllease__Next_Due_Generation_Date__c = nextDueGenDate;
        lacc.cllease__Last_Due_Date__c = lastDueDate;
    }

    private class TaxWithSurcharge {
        public Decimal tax;
        public Decimal surcharge;
        public TaxWithSurcharge(Decimal amount, Decimal rate, Decimal surchargeRate) {
            if(rate >= 0) {
                tax = cllease.ValueUtil.round((rate/100) * amount);
                if(surchargeRate >= 0) {
                    surcharge = cllease.ValueUtil.round((surchargeRate/100) * tax);
                }
            }
        }
    }

    public class TerminationContract {
        cllease__Lease_Account__c contract;

        public TerminationContract() {}

        public TerminationContract(cllease__Lease_Account__c contract) {
            //System.debug((LoggingLevel.ERROR, 'TerminationContract() - contract = ' + contract);
            this.contract = contract;
        }

        public Date getEverGreenStartDate() {

               Date evergreenEndDate;
               Date evergreenStartDate = LendingConstants.DT_MAX;
               //String evergreenFrequency;

               //if EG flag is set, both eg-end-date and eg-start-date are populated.
               if(contract.cllease__Evergreen_Flag__c == true) {
                   evergreenEndDate = contract.cllease__Evergreen_End_Date__c;
                   evergreenStartDate = contract.cllease__Evergreen_Start_Date__c;
               }
               else if(contract.cllease__Evergreen_Term__c > 0) {
                   //First find the EG Start-date, which is one day later than  maturity-date
                   evergreenStartDate = contract.cllease__Maturity_Date__c.addDays(1);
               }

               return evergreenStartDate;
           }

        public Date getEverGreenEndDate() {
            Date evergreenEndDate;
            Date evergreenStartDate = LendingConstants.DT_MAX;
            String evergreenFrequency;

            //if EG flag is set, both eg-end-date and eg-start-date are populated.
            if(contract.cllease__Evergreen_Flag__c == true) {
                evergreenEndDate = contract.cllease__Evergreen_End_Date__c;
            }
            else if(contract.cllease__Evergreen_Term__c != null
                && contract.cllease__Evergreen_Term__c > 0) {
                //First find the EG Start-date, which is one day later than  maturity-date
                evergreenStartDate = contract.cllease__Maturity_Date__c.addDays(1);
                evergreenFrequency = contract.cllease__Evergreen_Frequency__c;
                if(String.isBlank(evergreenFrequency)) {
                    evergreenFrequency = contract.cllease__Payment_Frequency__c;
                }

                Integer termCount = contract.cllease__Evergreen_Term__c.intValue();
                evergreenEndDate = cllease.DateUtil.getNextCycleDate(evergreenStartDate,
                                                               evergreenStartDate.day(),
                                                               evergreenFrequency,
                                                               termCount,
                                                               true);

            }
            return evergreenEndDate;
        }

        /**
         *  Given requestedTerminationDate, return the effective Termination date.
         *  Effective termination date will be the Period_Start_Date of the next period of period in which requested
         *  termination date falls. For example, if requested date is 15/Nov for period 1/Nov to 30/Nov, then effective
         *  Termination Date will be 1/Dec - the period start date of the next period.
         *  If the requested date is in last period, then termination date is effectively maturity date + 1.
         *  In case of Evergreen term given, but evergreen stream is not generated, the requested date beyond maturity date
         *  will be rejected. If evergreen stream is generated, then requested date must be less than last payment streams'
         *  period-end-date (ie evergreen end-date).
         *
         * @param requestedTerminationDate
         *
         * @return
         */
        public Date getEffectiveTerminationDate(Date requestedTerminationDate, Boolean considerPreBillDays) {
            Integer preBillDays = (considerPreBillDays) ? (Integer)contract.cllease__Pre_Bill_Days__c : 0;

            List<cllease__Payment_Stream__c> paymentStreams = contract.cllease__Payment_Streams__r;
            //Date terminationDate = termQuoteHeader.Termination_Date__c;
            if(requestedTerminationDate == null) {
                throw new CLSCustomException('Termination date is empty');
            }
            if(requestedTerminationDate < contract .cllease__Contract_Date__c) {
                throw new CLSCustomException('Termination date is before contract date, not allowed');
            }

            System.debug(LoggingLevel.ERROR, 'pmtStream  size:' + paymentStreams.size());
            Date closestPaymentDate = LendingConstants.DT_MIN;
            Integer matchingStreamIndex = 0;
            //Whether contract with Payment-in-advance or payment-in-arrear, the payment for the period where termination date belongs to
            //should be realized. the payment next to that should be stopped.
            for(cllease__Payment_Stream__c pmtStream : paymentStreams) {
                System.debug(LoggingLevel.ERROR, 'pmtStream  :' + pmtStream + ' => terminationDate = ' + requestedTerminationDate);
                //the requested termination date before the starting of contract should be rejected.
                matchingStreamIndex++;
                if(matchingStreamIndex == 0) {
                    //for the first period, the period start date can be later than contract start date.
                    //For any date till the first period's end date, all dates will be accepted and contract
                    // will be terminated from 2nd period start date.
                    if(requestedTerminationDate <= pmtStream.cllease__Period_End_Date__c.addDays(-preBillDays)) {
                        break;
                    }
                }
                else if(pmtStream.cllease__Period_Start_Date__c.addDays(-preBillDays) <= requestedTerminationDate &&
                    requestedTerminationDate <= pmtStream.cllease__Period_End_Date__c.addDays(-preBillDays)) {
                    break;
                }
            }
            System.debug(LoggingLevel.ERROR, 'matchingStreamIndex = ' + matchingStreamIndex);

            //matchingStreamIndex can never be bigger than paymentStreams.size() -1.
            if(matchingStreamIndex == paymentStreams.size()) {
                // the requested termination date can be in last period or not found.
                cllease__Payment_Stream__c pmtStream = paymentStreams.get(matchingStreamIndex-1);
                System.debug(LoggingLevel.ERROR, 'matchingStreamIndex = ' + matchingStreamIndex + '## pmtStream = ' + pmtStream);
                if(pmtStream.cllease__Period_Start_Date__c.addDays(-preBillDays) <= requestedTerminationDate &&
                    requestedTerminationDate <= pmtStream.cllease__Period_End_Date__c.addDays(-preBillDays)) {
                    System.debug(LoggingLevel.ERROR, 'match found in last term');
                    //last period matched. if there was another period, its start date would be one more than period-end-date.
                    closestPaymentDate = pmtStream.cllease__Period_End_Date__c.addDays(1-preBillDays);
                }
                else {
                    System.debug(LoggingLevel.ERROR, 'match is not found at all');
                    closestPaymentDate = cllease.LeaseConstants.DT_MIN; //enforce the min date so that validation throws error
                }
            }
            else { //termination date is the start date of next period
                cllease__Payment_Stream__c pmtStream1 = paymentStreams.get(matchingStreamIndex);
                closestPaymentDate = pmtStream1.cllease__Period_Start_Date__c.addDays(-preBillDays);
            }
            return closestPaymentDate;
        }

        public List<cllease__Other_Transaction__c> getBlockingOLTs() {
               
            List<cllease__Other_Transaction__c> blockingTransactions;

            blockingTransactions = [SELECT Id,
                                               Name,
                                               cllease__Transaction_Type__c,
                                               cllease__Txn_Date__c,
                                               cllease__Lease_Account__c
                                       FROM cllease__Other_Transaction__c
                                       WHERE cllease__Lease_Account__c = :contract.Id
                                       AND cllease__Transaction_Type__c IN ('BOOKING',
                                           'CHARGE OFF', 'RESTRUCTURE', 'EVERGREEN',
                                           'CONTRACT SALE', 'CONTRACT BUYBACK')
                                       ORDER BY cllease__Txn_Date__c DESC
                                      ];


            return blockingTransactions;
        }
        
        public Date getTerminationExpiryDate(cllease__Termination_Quote_Header__c termQuoteHeader) {
            Date expiryDate;
            Integer quoteEffectiveDays = 15; //Default Quote Effective Days
            Date systemDate = cllease.SystemDateUtil.getCurrentSystemDate();
        
            Boolean considerPreBillDays = false;
            TerminationQuoteAction terminationAction = new TerminationQuoteAction();
            cllease__Termination_Config__c terminationConfig = terminationAction.getMatchingTerminationConfig(contract, termQuoteHeader);
            
            // Check if matching Termination-Configuration is found at the product and contract is not in evergreen
            if (terminationConfig != null && systemDate <= contract.cllease__Maturity_Date__c) {
                considerPreBillDays = terminationConfig.cllease__Consider_Pre_Bill_Days__c;

                if (considerPreBillDays && contract.cllease__Next_Due_Generation_Date__c != null)
                    expiryDate = contract.cllease__Next_Due_Generation_Date__c.addDays(-1);
                else if (contract.cllease__Next_Due_Date__c != null)
                    expiryDate = contract.cllease__Next_Due_Date__c.addDays(-1);
            }

            // If expiryDate is somehow not populated due to failure of any internal conditions
            if (expiryDate == null) {
                // Check if Quote Effective Days is mentioned at the product, else take default as 15
                if(contract.cllease__lease_product_name__r.cllease__quote_effective_Days__c != null)
                    quoteEffectiveDays = (Integer) contract.cllease__lease_product_name__r.cllease__quote_effective_Days__c;
                expiryDate = termQuoteHeader.cllease__Effective_From__c.addDays((Integer) quoteEffectiveDays);
            }

            if(expiryDate >= contract.cllease__Maturity_Date__c) {
                if(contract.cllease__Lease_Status__c == LendingConstants.STATUS_EVERGREEN) {
                    // if evergreen contract effetive to date should be next evergreen term date
                    expiryDate = getEverGreenEndDate();
                } else {
                    // If Expiry Date falls after Maturity, then updating the same as Maturity Date.                    
                    expiryDate = contract.cllease__Maturity_Date__c;
                }
               
            }
            return expiryDate;    
        }
        
        public List<cllease__Termination_Quote_Header__c> getExistingTerminationQuotes() {
               List<cllease__Termination_Quote_Header__c> existingTerminationQuotes;
               existingTerminationQuotes   =  [SELECT  Id,
                                                       Name,
                                                       cllease__Contract__c,
                                                       cllease__Termination_Date__c,
                                                       cllease__Requested_Termination_Date__c,
                                                       cllease__Effective_From__c,
                                                       cllease__Effective_To__c,
                                                       cllease__Full_Termination__c,
                                                       cllease__Quote_Reason__c,
                                                       cllease__Quote_Type__c,
                                                       cllease__Status__c,
                                                       cllease__Quote_Amount__c,
                                                       cllease__Early_Termination__c,
                                                       cllease__Termination_With_Purchase__c,
                                                       cllease__Third_Party_Sale__c,
                                                       cllease__Is_Equipment_Termination__c,
                                                       (SELECT cllease__Line_Type__c,
                                                            cllease__Amount__c,
                                                            cllease__Amount_Type__c,
                                                            cllease__Billable__c,
                                                            cllease__Fee_Definition__c,
                                                            cllease__Add_To_Quote_Amount__c
                                                       FROM cllease__Termination_Quote_Lines__r),
                                                       (SELECT Id, Name,
                                                            cllease__Contract_Equipment__c,
                                                            cllease__Equipment_Detail__c
                                                       FROM cllease__Termination_Quote_Equipments__r)
                                               FROM cllease__Termination_Quote_Header__c
                                               WHERE cllease__Contract__c = :contract.Id
                                               AND cllease__Status__c  IN ( :LendingConstants.TERMINATION_QUOTE_STATUS_PROCESSED,
                                                                   :LendingConstants.TERMINATION_QUOTE_STATUS_TERMPROCESSED,
                                                                   :LendingConstants.TERMINATION_QUOTE_STATUS_ACCEPTED)
                                               ORDER BY cllease__Termination_Date__c DESC
                                              ];
               return existingTerminationQuotes;
        }
    }
}