/**
 * Following Global class will be using for CLO Application to Contract Creation
 * Need to mention following class NAME with namespace to Use for conversion process
 * Setup:
 *      Custom settings
 *      --> Custom Logic Parameters(genesis)
 *      --> Edit
 *      --> genesis__Custom_Contract_Generation_Class__c = 'cllease.ContractProcessor'
 * Note:
 *     ContractProcessor not bulkied, it should call with batch size = 1
 */
global virtual class ContractProcessor implements clcommon.IContractProcessor {

    private cllease__Lease_Account__c leaseAccount;
    private SObject product;
    private SObject purpose;
    private sObject application;
    private Map<String, List<SObject>> childObjects;
    private Map<String,Id> contEquipmentIdMap;
    private Map<String,Id> partyContractPartyMap;
    private Map<String,Id> feeToContractFeeMap;

    /**
     *  Getting details from clcommon.ApplicationContractBO for Contract Processing
     */
    global virtual Map<Id, SObject> createContracts(List<clcommon.ApplicationContractBO> appContracts) {
        if(appContracts == null || appContracts.size() == 0) {
            return null;
        }
        /**
         *  Creating [Application,Contract] Map for tracking details
         */
        Map<Id, SObject> appToContract = new Map<Id, SObject>();
        for(clcommon.ApplicationContractBO app:appContracts) {
            this.leaseAccount   = (cllease__Lease_Account__c)app.getContract();
            this.product        = app.getProduct();
            this.purpose        = app.getPurpose();
            this.childObjects   = app.getChildObjects();
            this.application    = app.getApplication();
            this.processContract();
            appToContract.put(app.getApplication().Id, leaseAccount);
        }
        return appToContract;
    }

    /**
     *  Internal helper class to process Contract
     *  methods helps in contract creation , GenerateStreams and ActivateContract based on the Application's Status
     */
    private void processContract() {
        System.debug(Logginglevel.DEBUG, 'Contract Conversion Process Starting for Application: '+application.get('Name'));
        cllease__Lending_Account_Validation__c loggingValidation = new cllease__Lending_Account_Validation__c();
        cllease.ContractBuilder builder;
        String response;

        SavePoint sp = Database.setSavePoint();
        /**
         * 1. Insert Contract and also linked Child Objects
         *    and creating 2 SavePoint to make sure contract create happens
         *    if failure comes from regenerate streams and activate contract
         */
        try {
            // Getting Product details which links to CL Lease Product
            this.getLeaseProduct();
            /**
             * 1. Create LS Contract through ContractBuilder
             */
            builder = new cllease.ContractBuilder(leaseAccount);
            builder.addChildObjects(childObjects);
            builder.setSkipCalcSetup();
            response = builder.createContract(null);
            System.debug(LoggingLevel.DEBUG, 'Lease Account Details in ContractProcessor: '+leaseAccount);
            System.debug(LoggingLevel.DEBUG, 'Child Object Details in ContractProcessor: '+childObjects);
            if(!response.containsIgnoreCase('Contract Creation Successful')) {
                throw new cllease.LeaseServicingException(response, 'ERROR');
            }
            contEquipmentIdMap = new Map<String,Id>();
            partyContractPartyMap = new Map<String,Id>();
            feeToContractFeeMap = new map<String,Id>();
            List<cllease__Contract_Equipment__c> contractEquips = [select id,cllease__Contract__c,External_Id__c from 
                                                                cllease__Contract_Equipment__c 
                                                                where cllease__Contract__c=:leaseAccount.id];
            
            for(cllease__Contract_Equipment__c contEquip : contractEquips){
                contEquipmentIdMap.put(contEquip.External_Id__c,contEquip.id);
            }
            update contractEquips;
            
            List<cllease__Contract_Parties__c> parties = [select id,External_Id__c from cllease__Contract_Parties__c 
                                                            where cllease__Contract__c =: leaseAccount.Id];
            for(cllease__Contract_Parties__c party : parties){
                partyContractPartyMap.put(party.External_Id__c,party.id);
            }
            
            List<cllease__Contract_Fees__c> contractFees = [select id,cllease__Contract__c,Equipment_External_Id__c,External_id__c,
                                                           cllease__Expense_fee__c 
                                                           from cllease__Contract_Fees__c
                                                           where cllease__Contract__c=:leaseAccount.id];
            for(cllease__Contract_Fees__c contFee:contractFees){
                contFee.cllease__Contract_Equipment__c = contEquipmentIdMap.get(contFee.Equipment_External_Id__c);
                feeToContractFeeMap.put(contFee.External_id__c,contFee.cllease__Expense_fee__c);
            } 
            update contractFees;
            
            
            List<Equipment_Funding_Detail__c> equipFundingDetails = [select id,Application__c,Dealer_Charges__c,
                                                                    Equipment__c,Party__c
                                                                    from Equipment_Funding_Detail__c
                                                                    where Equipment__c in:contEquipmentIdMap.keyset()];
            List<cllease__Dealer_Funding_Detail__c> dealerFundingDetails = new List<cllease__Dealer_Funding_Detail__c>();
            if(equipFundingDetails.size()>0){
                for(Equipment_Funding_Detail__c equipDetail : equipFundingDetails){
                    cllease__Dealer_Funding_Detail__c fundingDetail = new cllease__Dealer_Funding_Detail__c();
                    fundingDetail.cllease__Contract__c = leaseAccount.id;
                    fundingDetail.cllease__Contract_Equipment__c = contEquipmentIdMap.get(equipDetail.Equipment__c);
                    fundingDetail.cllease__Dealer__c = partyContractpartyMap.get(equipDetail.Party__c);
                    fundingDetail.cllease__Dealer_Charges__c = equipDetail.Dealer_Charges__c ; 
                    dealerFundingDetails.add(fundingDetail);
                }
            }
            
            insert dealerFundingDetails;
            
            List<Application_Fee_Payment__c> feePayments = [select id,Application__c,Application_Fee__c,
                                                            End_Date__c,Payment_Percentage__c,Pay_To__c,
                                                            Start_Date__c
                                                            from Application_Fee_Payment__c 
                                                            where Application_Fee__c in:feeToContractFeeMap.keySet()];
            List<cllease__Contract_Fee_Payment__c> contFeePayments = new List<cllease__Contract_Fee_Payment__c>();
            if(feePayments.size()>0){
                for(Application_Fee_Payment__c feePayment:feePayments){
                    cllease__Contract_Fee_Payment__c contFeePayment = new cllease__Contract_fee_payment__c();
                    contFeePayment.cllease__Contract__c = leaseAccount.Id;
                    contFeePayment.cllease__Contract_fee__c = feeToContractFeemap.get(feePayment.Application_Fee__c);
                    // Note: Stop copying start date and end date as there is no functionality around with it in CL Lease
                    // and passthrough doesn't work if only one date is available out of start and end dates.
                    //contfeePayment.cllease__Start_Date__c = feePayment.Start_Date__c;
                    //contFeePayment.cllease__End_Date__c = feePayment.End_Date__c;
                    contFeePayment.cllease__Payment_Percentage__c = feePayment.Payment_Percentage__c;
                    contFeePayment.cllease__Pay_To__c = partyContractpartyMap.get(feePayment.Pay_To__c);
                    contFeePayments.add(contFeePayment);
                }
            }
            
            insert contFeePayments;

        } catch(Exception e) {
            //Database.rollback(sp);
            //throw is needed as CL O might want to throw its own exception and also error code.
            throw e;
        }

        /**
         * 2. Generate Streams and Activate Contract through ContractBuilder
         */
        SavePoint sp2 = Database.setSavePoint();
        try {
            /** TODO: Needs to use generic soluton mark from genesis for Generate Streams and activate Contract
             * 2.a. Skipping incase of
             *    i. No genesis application status in coversion mapping.
             *   ii. Generate Streams and Activate Contract Processs incase Application status not "CREDIT APPROVED"
             */
            if(application.get('genesis__Status__c') ==null
                || application.get('genesis__Status__c') != 'CAMS APPROVED') {
                return;
            }

            /**
             * 2.b. Regenerating, Activating contract and log alert exception message
             *      in case of any error during the process
             */
            /*response = builder.createContract(LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
            if (!response.containsIgnoreCase('Contract Creation Successful')) {
                loggingValidation.Error_Code__c =  LendingConstants.VALIDATION_TYPE_DIAGNOSTIC;
                throw new LeaseServicingException('Exception During Streams Generation: ' + response, 'ERROR');
            }*/
            String result = cllease.RegenerateStreamsCtrl.FinregenerateStreams(leaseAccount.Id, null);
            if (result.containsIgnoreCase(cllease.LendingConstants.CLLEASE_EXCEPTION)) {
                throw new genesis.OriginationException(result);
            }
            leaseAccount.cllease__Lease_Status__c = cllease.LendingConstants.STATUS_APPROVED;
            // CRUD Permissions check
            if(Schema.sObjectType.cllease__Lease_Account__c.isUpdateable()) {
                update leaseAccount;
            } else {
                throw new genesis.OriginationException('Insufficient Update Access on custom object: Lease_Account__c');
            }
            result = cllease.ActivateContractCtrl.activateContract(leaseAccount.Id);
            if (result.containsIgnoreCase(cllease.LendingConstants.CLLEASE_ERROR)) {
                //In case of ActivateContract, Error messsages will be stored in
                List<cllease__Lending_Account_Validation__c> validationMsgs = [SELECT id, cllease__Error_Message__c
                                                                          FROM cllease__Lending_Account_Validation__c
                                                                          WHERE cllease__Lease__c =:leaseAccount.Id];
                if(validationMsgs.size() > 0) {
                    result = validationMsgs.get(0).cllease__Error_Message__c;
                }
                throw new genesis.OriginationException(result);
            }
            System.debug(Logginglevel.DEBUG, 'Contract conversion process is completed.');
        } catch (Exception ex) {
            Database.rollback(sp2);
            loggingValidation.cllease__Error_Message__c = ex.getMessage();
            loggingValidation.cllease__Lease__c = leaseAccount.Id;
            loggingValidation.cllease__Interface_Record_External_Id__c = leaseAccount.Id;
            loggingValidation.cllease__Level__c = 'ERROR';
            insert loggingValidation;
            //throw ex;
        }
    }

    /**
     * Hence if an explicit mapping is not provided,
     * Passed product's instance is supposed to have a lending product's lookup
     */
    private void getLeaseProduct() {
        if(this.product != null && this.leaseAccount.cllease__Lease_Product_Name__c == null) {
            String cloProductID = (String)this.product.get('id');
            if(cloProductID != null) {
                List<cllease__Lease_Product__c> products = [Select Id,Name
                                                    From cllease__Lease_Product__c
                                                    Where cllease__CL_Product__c =:cloProductID ];
                if(products.size()>0) {
                    this.leaseAccount.cllease__Lease_Product_Name__c = products[0].id;
                }
            }
        }
    }
}