/**
 * Owner: Cloud Lending Solutions
 * Usage: Following class created as part of Termination Functionality customization
 * Note: Code needs to retire on Upgrading latest versions where Multiple Termination Quotes can be created through API      
 **/
public with sharing class TerminationUtil {

    /**
     * Following method helps in getting the termination configuration attached to Lease Product
     */
    public static String getTerminationConfiguration(Set<Id> productIds, Set<Id> terminationConfigIdSet) {

        String nsPrefix = 'cllease__';
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache termConfigOC = ec.getObject('TerminationConfigs2');
        if (termConfigOC != null) {
            ec.deleteObject('TerminationConfigs2');
        }
        termConfigOC = ec.createObject('TerminationConfigs2', nsPrefix + 'Termination_Config__c');
        termConfigOC.addFields(nsPrefix + 'Lease_Product__c');
        termConfigOC.addFields(nsPrefix + 'Quote_Reason__c');
        termConfigOC.addFields(nsPrefix + 'Quote_Type__c');
        termConfigOC.addFields(nsPrefix + 'Default__c');
        termConfigOC.addFields(nsPrefix + 'Termination_With_Purchase__c');
        termConfigOC.addFields(nsPrefix + 'Third_Party_Sale__c');
        termConfigOC.addFields(nsPrefix + 'Consider_Pre_Bill_Days__c');

        String termConfigWhereClause = ' ( cllease__Enable__c = true ) ';
        // Quering termination Configuration with Product details with conditions
        if(!productIds.isEmpty()) {
            termConfigOC.addNamedParameter('productIds', productIds);
            termConfigWhereClause += ' AND ';
            termConfigWhereClause += ' ( cllease__Lease_Product__c IN :productIds ) ';

        // Quering termination Configuration with ID details
        } else if(!terminationConfigIdSet.isEmpty()) {
            termConfigOC.addNamedParameter('termConfigIds', terminationConfigIdSet);
            termConfigWhereClause += ' AND ';
            termConfigWhereClause += ' ( Id IN :termConfigIds ) ';
        }

        termConfigOC.setWhereClause(termConfigWhereClause);
        termConfigOC.setOrderClause('LastModifiedDate DESC');

        mfiflexUtil.ObjectCache feeOC = ec.createRelationship(nsPrefix + 'Termination_Config_Fees__r');
        termConfigOC.addRelationship(feeOC);
        feeOC.addFields(nsPrefix + 'Fee_Amount__c');
        feeOC.addFields(nsPrefix + 'Fee_Definition__c');
        feeOC.addFields(nsPrefix + 'Fee_Definition__r.Name');
        feeOC.addFields(nsPrefix + 'Quote_Reason__c');
        feeOC.addFields(nsPrefix + 'Quote_Type__c');
        feeOC.addFields(nsPrefix + 'Termination_Config__c');
        feeOC.addFields(nsPrefix + 'Termination_Type__c');


        mfiflexUtil.ObjectCache lineOC = ec.createRelationship(nsPrefix + 'Termination_Config_Lines__r');
        termConfigOC.addRelationship(lineOC);
        lineOC.addFields(nsPrefix + 'Account_Balance_Type__c');
        lineOC.addFields(nsPrefix + 'Bill_Field_API_Name__c');
        lineOC.addFields(nsPrefix + 'Field_API_Name__c');
        lineOC.addFields(nsPrefix + 'Is_Account_Balancable__c');
        lineOC.addFields(nsPrefix + 'Is_Billable__c');
        lineOC.addFields(nsPrefix + 'Quote_Line__c');
        lineOC.addFields(nsPrefix + 'Termination_Config__c');
        lineOC.addFields(nsPrefix + 'Add_To_Quote_Amount__c');

        String query = termConfigOC.buildQuery().getQuery();
        System.debug('getTerminationConfiguration.quey: '+query);
        return query;
    }

    /**
     * Extracting default Termination Configuration from all Lease Products
     */
    public static String getTerminationConfiguration(){
        String query = getTerminationConfiguration(new Set<Id>(), new Set<Id>());
        return query;
    }
  
    /**
     * Query Termination Configuration for the Contract and Quote Header created
     */
    public static String getTerminationConfiguration(Map<cllease__Lease_Account__c, cllease__Termination_Quote_Header__c> leaseAccTermHeaderMap) {
        Set<Id> productIds = new Set<Id>();
        if(leaseAccTermHeaderMap.size() > 0) {
            for(cllease__Lease_Account__c leaseAcc : leaseAccTermHeaderMap.keySet()) {
                productIds.add(leaseAcc.cllease__Lease_Product_Name__c);
            }
        }
        return getTerminationConfiguration(productIds, new Set<Id>());
    }

    /**
     * Extracting the Termination Configuration Line's Field APIs for query
     */
    public static String getTerminationLineFieldAPINames() {
        Set<String> lineFieldAPINames = new Set<String>();
        List<cllease__Termination_Config__c> terminationConfigs =Database.query(getTerminationConfiguration());
        for (cllease__Termination_Config__c termConfig : terminationConfigs) {
            for (cllease__Termination_Config_Line__c line : termConfig.cllease__Termination_Config_Lines__r) {
                if (line.cllease__Quote_Line__c == 'SECURITY DEPOSIT'
                        && (line.cllease__Field_API_Name__c == 'Security_Deposit_Amount__c'
                            || line.cllease__Field_API_Name__c == 'cllease__Security_Deposit_Amount__c'))
                    continue;
                if (line.cllease__Field_API_Name__c != null)
                    lineFieldAPINames.add(line.cllease__Field_API_Name__c);
            }
        }

        // converting to comma separated fields
        String fields = '';
        for (String field : lineFieldAPINames) {
            fields += field + ',';
        }

        return fields;
    }

    /**
     * Query the Contracts for Termination
     */
    public static String getContractsForTermination(String newFields, Set<String> contractIdStrList, Set<String> equipmentIdStrList) {
        Set<Id> contractIds = new Set<Id>();
        Set<Id> equipmentIds = new Set<Id>();
        if(contractIdStrList != null) {
            for (String contractIdStr : contractIdStrList) {
                contractIds.add((Id) contractIdStr);
            }
        }

        if(equipmentIdStrList != null) {
            for(String equipmentIdStr : equipmentIdStrList) {
                equipmentIds.add((Id)equipmentIdStr);
            }
        }

        return getContractsForTermination(newFields, contractIds, equipmentIds);
    }

    /**
     * Query the Contracts for Termination
     */
    public static String getContractsForTermination(String newFields, Set<Id> contractIds, Set<Id> equipmentIds) {

        String contractsLimit = CLSCustomUtil.getContractsSizeForBatch();
        String nsPrefix = 'cllease__';

        String customfields =  '';
        if(String.isNotBlank(newFields)) {
            customfields = newFields;
        }

        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache leaseOC = ec.getObject('LeaseObject12');
        if (leaseOC != null) {
            ec.deleteObject('LeaseObject12');
        }
        leaseOC = ec.createObject('LeaseObject12', nsPrefix + 'Lease_Account__c');

        List<String> lsContractFields = new List<String>();

        lsContractFields.add(nsPrefix + 'Lease_Product_Name__r.cllease__Calculation_Method__c');
        lsContractFields.add(nsPrefix + 'Lease_Product_Name__r.cllease__Termination_Discount_Rate__c');
        lsContractFields.add(nsPrefix + 'Lease_product_Name__r.cllease__quote_effective_Days__c');
        lsContractFields.add(nsPrefix + 'Lease_Product_Name__r.cllease__Product_sub_type__C');
        lsContractFields.add(nsPrefix + 'Lease_product_Name__r.cllease__Wait_for_Cash__c');
        lsContractFields.add(nsPrefix + 'Lease_product_Name__r.cllease__Termination_Lead_Days__c');
        lsContractFields.add(nsPrefix + 'Lease_Product_Name__r.Name');
        lsContractFields.add(nsPrefix + 'Lease_Product_Name__r.cllease__Track_Non_Cash_Account_Balances__c');
        lsContractFields.add(nsPrefix + 'Branch__r.cllease__Tax_Method__c');
        lsContractFields.add(nsPrefix + 'Branch__r.cllease__Tax_Calculation_Source__c');
        lsContractFields.add(nsPrefix + 'Branch__r.cllease__Tax_Basis__c');
        lsContractFields.add(nsPrefix + 'Branch__r.cllease__Vat_Rate__c');
        lsContractFields.add(nsPrefix + 'Branch__r.cllease__Current_System_Date__c');
        lsContractFields.add(nsPrefix + 'Branch__r.cllease__Currency_Precision__c');
        lsContractFields.add(nsPrefix + 'Account__r.cllease__Tax_Exemption__c');
        lsContractFields.add(nsPrefix + 'Account__c');
        lsContractFields.add(nsPrefix + 'Accrual_Streams__c');
        lsContractFields.add(nsPrefix + 'Amount_To_Current__c');
        lsContractFields.add(nsPrefix + 'Calculation_Method__c');
        lsContractFields.add(nsPrefix + 'Contract_Date__c');
        lsContractFields.add(nsPrefix + 'Current_Evergreen_Term__c');
        lsContractFields.add(nsPrefix + 'Current_Payment_Amount__c');
        lsContractFields.add(nsPrefix + 'Current_Term_Rental_Payment__c');
        lsContractFields.add(nsPrefix + 'Current_Term__c');
        lsContractFields.add(nsPrefix + 'Days_Convention__c');
        lsContractFields.add(nsPrefix + 'Delinquent_Amount__c');
        lsContractFields.add(nsPrefix + 'Effective_Date__c');
        lsContractFields.add(nsPrefix + 'Effective_Term__c');
        lsContractFields.add(nsPrefix + 'Equipment_Selling_Price__c');
        lsContractFields.add(nsPrefix + 'Evergreen_Count__c');
        lsContractFields.add(nsPrefix + 'Evergreen_Current_Payment_Amount__c');
        lsContractFields.add(nsPrefix + 'Evergreen_End_Date__c');
        lsContractFields.add(nsPrefix + 'Evergreen_Flag__c');
        lsContractFields.add(nsPrefix + 'Evergreen_Frequency__c');
        lsContractFields.add(nsPrefix + 'Evergreen_Last_Due_Date__c');
        lsContractFields.add(nsPrefix + 'Evergreen_Next_Due_Date__c');
        lsContractFields.add(nsPrefix + 'Evergreen_Next_Due_Generation_Date__c');
        lsContractFields.add(nsPrefix + 'Evergreen_Start_Date__c');
        lsContractFields.add(nsPrefix + 'Evergreen_Term__c');
        lsContractFields.add(nsPrefix + 'Excess__c');
        lsContractFields.add(nsPrefix + 'Financed_Amount__c');
        lsContractFields.add(nsPrefix + 'First_Payment_Amount__c');
        lsContractFields.add(nsPrefix + 'First_Payment_Date__c');
        lsContractFields.add(nsPrefix + 'Has_Asset_Level_Rent__c');
        lsContractFields.add(nsPrefix + 'Income_Accrual_Frequency__c ');
        lsContractFields.add(nsPrefix + 'Initial_Direct_Cost_Amount1__c');
        lsContractFields.add(nsPrefix + 'Initial_Direct_Cost__c');
        lsContractFields.add(nsPrefix + 'Is_Rescheduled__c');
        lsContractFields.add(nsPrefix + 'Lease_Receivable_Amount__c');
        lsContractFields.add(nsPrefix + 'Last_Due_Date__c');
        lsContractFields.add(nsPrefix + 'Lease_Status__c');
        lsContractFields.add(nsPrefix + 'Matured_Flag__c');
        lsContractFields.add(nsPrefix + 'Maturity_Date_Current__c');
        lsContractFields.add(nsPrefix + 'Maturity_Date__c');
        lsContractFields.add(nsPrefix + 'Next_Due_Date__c');
        lsContractFields.add(nsPrefix + 'Next_Due_Generation_Date__c');
        lsContractFields.add(nsPrefix + 'Oldest_Due_Date__c');
        lsContractFields.add(nsPrefix + 'Payment_Frequency__c');
        lsContractFields.add(nsPrefix + 'Payment_Method__c');
        lsContractFields.add(nsPrefix + 'Pre_Bill_Days__c');
        lsContractFields.add(nsPrefix + 'Product_Sub_Type__c');
        lsContractFields.add(nsPrefix + 'Rent_Maturity_Date__c');
        lsContractFields.add(nsPrefix + 'Residual_Amount__c');
        lsContractFields.add(nsPrefix + 'Residual_Type__c');
        lsContractFields.add(nsPrefix + 'Security_Deposit_Amount__c');
        lsContractFields.add(nsPrefix + 'Subsidy1__c');
        lsContractFields.add(nsPrefix + 'Subvention__c');
        lsContractFields.add(nsPrefix + 'Term__c');
        lsContractFields.add(nsPrefix + 'Termination_Discount_Rate__c');
        lsContractFields.add(nsPrefix + 'Warranty_Amount__c');
        lsContractFields.add(nsPrefix + 'Enable_Calculation_Setup_Logs__c');

        leaseOC.addFields(lsContractFields);
        if(String.isNotBlank(customfields)) {
            leaseOC.addFields(customfields);
        }
        //leaseOC.addNamedParameter('activeFlag', activeFlag);
        String whereClause = ' cllease__Invalid_Data__c = false ';
        //whereClause += ' AND Active_Flag__c = :activeFlag ';

        if(contractIds != null && !contractIds.isEmpty()) {
            leaseOC.addNamedParameter('contractIds', contractIds);
            whereClause += ' AND Id IN :contractIds AND cllease__batch_job_completed__c = false ';
        }

        leaseOC.setWhereClause(whereClause);
        leaseOC.setLimitClause(contractsLimit);
        leaseOC.setOrderClause('Name');


        mfiflexUtil.ObjectCache pmtScheduleOC = ec.createRelationship(nsPrefix + 'Payment_Schedule__r');
        leaseOC.addRelationship(pmtScheduleOC);



        mfiflexUtil.ObjectCache cepOC = ec.createRelationship(nsPrefix + 'Contract_Equipments__r');
        leaseOC.addRelationship(cepOC);
        List<String> cepFields = new List<String>();
        cepFields.add(nsPrefix + 'Contract__c');
        cepFields.add(nsPrefix + 'Equipment_Calculated_Cost__c');
        cepFields.add(nsPrefix + 'Equipment_Serial_Number__c');
        //cepFields.add(nsPrefix + 'NBV_On_Restructure_Date__c');
        cepFields.add(nsPrefix + 'Status__c');
        cepFields.add(nsPrefix + 'Rent__c');
        cepFields.add(nsPrefix + 'Tax_Amount__c');
        cepFields.add(nsPrefix + 'Override_Tax_Rate__c');
        cepFields.add(nsPrefix + 'Total_Tax_Rate_Derived__c');
        cepFields.add(nsPrefix + 'City_Tax_Rate__c');
        cepFields.add(nsPrefix + 'Upfront_Tax_Flag__c');
        cepFields.add(nsPrefix + 'Override_Tax_Flag__c');
        cepFields.add(nsPrefix + 'County_Tax_Rate__c');
        cepFields.add(nsPrefix + 'County_Surcharge__c');
        cepFields.add(nsPrefix + 'State_Tax_Rate__c');
        cepFields.add(nsPrefix + 'City_Surcharge__c');
        cepFields.add(nsPrefix + 'State_Surcharge__c');
        cepFields.add(nsPrefix + 'Tax_Exemption__c');
        cepFields.add(nsPrefix + 'Warranty_Amount__c');

        //we are commenting this for now.

        cepFields.add(nsPrefix + 'Estimated_Selling_Price__c');
        cepFields.add(nsPrefix + 'Subvention__c');
        cepFields.add(nsPrefix + 'Subsidy__c');
        cepFields.add(nsPrefix + 'Residual_Amount__c');

        Map<String, String> mappingFields = new Map<String, String>(); //EquipmentDetailUtil.getEqptoEqpDetailFieldMap();
        //System.debug(LoggingLevel.ERROR, 'AHR: mappingFields = ' + mappingFields);

        //Lets remove field from mappingFieldKeys if it is already added.
        //Basic assumption here is that mappingField will always be along with
        //namespace. As the mappingFields has keys and values in lowercase, we need to
        //compare the lowercase only.
        Set<String> mappingFieldKeys = new Set<String>();
        mappingFieldKeys.addAll(mappingFields.keySet());
        for(String field : cepFields) {
            String nsField = nsPrefix + field;
            nsField = nsField.toLowerCase();
            if(mappingFieldKeys.contains(nsField)) {
                mappingFieldKeys.remove(nsField);
            }
        }
        cepFields.addAll(mappingFieldKeys);

        cepOC.addFields(cepFields);
        cepOC.addNamedParameter('terminatedStatus', LendingConstants.STATUS_TERMINATED);
        String cepWhereClause = 'cllease__Status__c != :terminatedStatus';
        if(equipmentIds != null && !equipmentIds.isEmpty()) {
            cepOC.addNamedParameter('equipmentIds', equipmentIds);
            cepWhereClause += ' AND Id IN :equipmentIds';
        }
        cepOC.setWhereClause(cepWhereClause);

        mfiflexUtil.ObjectCache cashAccBalanceOC = ec.createRelationship(nsPrefix + 'Cash_Account_Balances__r');
        leaseOC.addRelationship(cashAccBalanceOC);
        List<String> cashAccBalanceFields = new List<String>();
        cashAccBalanceFields.add(nsPrefix + 'Balance_Type__c');
        cashAccBalanceFields.add(nsPrefix + 'Balance_Sub_Type__c');
        cashAccBalanceFields.add(nsPrefix + 'Posted_Amount__c');
        cashAccBalanceFields.add(nsPrefix + 'Closing_Balance_Amount__c');
        cashAccBalanceOC.addFields(cashAccBalanceFields);

        mfiflexUtil.ObjectCache nonCashAccBalanceOC = ec.createRelationship(nsPrefix + 'Non_Cash_Account_Balances__r');
        leaseOC.addRelationship(nonCashAccBalanceOC);
        List<String> nonCashAccBalanceFields = new List<String>();
        nonCashAccBalanceFields.add(nsPrefix + 'Balance_Type__c');
        nonCashAccBalanceFields.add(nsPrefix + 'Opening_Balance_Amount__c');
        nonCashAccBalanceFields.add(nsPrefix + 'Transactions_Amount__c');
        nonCashAccBalanceFields.add(nsPrefix + 'Closing_Balance_Amount__c');
        nonCashAccBalanceOC.addFields(nonCashAccBalanceFields);

        mfiflexUtil.ObjectCache pmtStreamOC = ec.createRelationship(nsPrefix + 'Payment_Streams__r');
        leaseOC.addRelationship(pmtStreamOC);
        List<String> pmtStreamFields = new List<String>();
        pmtStreamFields.add(nsPrefix + 'Beginning_Receivable__c');
        pmtStreamFields.add(nsPrefix + 'Billed__c');
        pmtStreamFields.add(nsPrefix + 'Contract__c');
        pmtStreamFields.add(nsPrefix + 'Contract__r.cllease__Has_Asset_Level_Rent__c');
        pmtStreamFields.add(nsPrefix + 'Contract_Fee__c');
        pmtStreamFields.add(nsPrefix + 'Contract_Fee__r.cllease__Contract_Equipment__c');
        pmtStreamFields.add(nsPrefix + 'Date__c');
        pmtStreamFields.add(nsPrefix + 'Ending_Receivable__c');
        pmtStreamFields.add(nsPrefix + 'Payment_Type__c');
        pmtStreamFields.add(nsPrefix + 'Period_Start_Date__c');
        pmtStreamFields.add(nsPrefix + 'Period_End_Date__c');
        pmtStreamFields.add(nsPrefix + 'Rental_Amount__c');
        pmtStreamFields.add(nsPrefix + 'Transaction_Sub_Type__c');
        pmtStreamFields.add(nsPrefix + 'Tax__c');

        pmtStreamOC.addFields(pmtStreamFields);
        /*
        mfiflexUtil.ObjectCache incomeCalcDtlsOC = ec.createRelationship(nsPrefix + 'Income_Calculation_Details__r');
        leaseOC.addRelationship(incomeCalcDtlsOC);
        List<String> incomeCalculationFields = new List<String>();
        incomeCalculationFields.add(nsPrefix + 'Contract__c');
        incomeCalculationFields.add(nsPrefix + 'Start_Date__c');
        incomeCalculationFields.add(nsPrefix + 'End_Date__c');
        incomeCalculationFields.add(nsPrefix + 'No_of_Days__c');
        incomeCalculationFields.add(nsPrefix + 'Payment_Amount__c');
        incomeCalculationFields.add(nsPrefix + 'Beginning_Net_Book_Value__c');
        incomeCalculationFields.add(nsPrefix + 'Income_Per_Day__c');
        incomeCalculationFields.add(nsPrefix + 'Income__c');
        incomeCalculationFields.add(nsPrefix + 'Capital_Recovery__c');
        incomeCalculationFields.add(nsPrefix + 'Ending_Net_Book_Value__c');
        incomeCalculationFields.add(nsPrefix + 'Residual_Beginning_Value__c');
        incomeCalculationFields.add(nsPrefix + 'Residual_Income_Per_Day__c');
        incomeCalculationFields.add(nsPrefix + 'Residual_Income__c');
        incomeCalculationFields.add(nsPrefix + 'Residual_Ending_Value__c');
        incomeCalculationFields.add(nsPrefix + 'Yield__c');
        incomeCalcDtlsOC.addFields(incomeCalculationFields);
        incomeCalcDtlsOC.setOrderClause('cllease__End_Date__c ASC');
        */
        mfiflexUtil.ObjectCache rentalStreamOC = ec.createRelationship(nsPrefix + 'Rental_Streams__r');
        leaseOC.addRelationship(rentalStreamOC);
        List<String> rentalStreamFields = new List<String>();
        rentalStreamFields.add(nsPrefix + 'Date__c');
        rentalStreamFields.add(nsPrefix + 'Accrued_Flag__c');
        rentalStreamFields.add(nsPrefix + 'Lease_Income__c');
        rentalStreamFields.add(nsPrefix + 'Beginning_Net_Book_Value__c');
        rentalStreamFields.add(nsPrefix + 'Ending_Net_Book_Value__c');
        rentalStreamFields.add(nsPrefix + 'Beginning_Net_Investment__c');
        rentalStreamFields.add(nsPrefix + 'Ending_Net_Investment__c');
        rentalStreamFields.add(nsPrefix + 'Beginning_Lease_Receivable__c');
        rentalStreamFields.add(nsPrefix + 'Ending_Lease_Receivable__c');
        rentalStreamFields.add(nsPrefix + 'Beginning_Unearned_Income__c');
        rentalStreamFields.add(nsPrefix + 'Ending_Unearned_Income__c');
        rentalStreamFields.add(nsPrefix + 'Contract__r.cllease__Has_Asset_Level_Rent__c');
        rentalStreamFields.add(nsPrefix + 'Capital_Recovery__c');
        rentalStreamFields.add(nsPrefix + 'Payment_Amount__c');
        rentalStreamFields.add(nsPrefix + 'Active__c');
        rentalStreamOC.addFields(rentalStreamFields);
        rentalStreamOC.setOrderClause('cllease__Date__c ASC');

        mfiflexUtil.ObjectCache rentalAccStreamOC = ec.createRelationship(nsPrefix + 'Rental_Accrual_Streams__r');
        leaseOC.addRelationship(rentalAccStreamOC);
        List<String> rentalAccStreamFields = new List<String>();
        rentalAccStreamFields.add(nsPrefix + 'Accrued__c');
        rentalAccStreamFields.add(nsPrefix + 'Beginning_Net_Book_Value__c');
        rentalAccStreamFields.add(nsPrefix + 'Date__c');
        rentalAccStreamFields.add(nsPrefix + 'Ending_Net_Book_Value__c');
        rentalAccStreamFields.add(nsPrefix + 'Rental_Accrual__c');
        rentalAccStreamOC.addFields(rentalAccStreamFields);
        rentalAccStreamOC.setOrderClause(nsPrefix + 'Date__c ASC');

        mfiflexUtil.ObjectCache residualStreamOC = ec.createRelationship(nsPrefix + 'Residual_Streams__r');
        leaseOC.addRelationship(residualStreamOC);
        List<String> residualStreamFields = new List<String>();
        residualStreamFields.add(nsPrefix + 'Accrued_Flag__c');
        residualStreamFields.add(nsPrefix + 'Beginning_Lease_Residual__c');
        residualStreamFields.add(nsPrefix + 'Beginning_Residual_Net_Book_Value__c');
        residualStreamFields.add(nsPrefix + 'Date__c');
        residualStreamFields.add(nsPrefix + 'Beginning_Unearned_Residual_Income__c');
        residualStreamFields.add(nsPrefix + 'Ending_Net_Book_Value__c');
        residualStreamFields.add(nsPrefix + 'Ending_Lease_Residual__c');
        residualStreamFields.add(nsPrefix + 'Residual_Income__c');
        residualStreamFields.add(nsPrefix + 'Residual_Amount__c');
        residualStreamOC.addFields(residualStreamFields);
        residualStreamOC.setOrderClause('cllease__Date__c ASC');


        mfiflexUtil.ObjectCache idcStreamOC = ec.createRelationship(nsPrefix + 'IDC_Stream__r');
        leaseOC.addRelationship(idcStreamOC);
        List<String> idStreamFields = new List<String>();
        idStreamFields.add(nsPrefix + 'Date__c');
        idStreamFields.add(nsPrefix + 'Accrued_Flag__c');
        idStreamFields.add(nsPrefix + 'Beginning_Initial_Direct_Cost__c');
        idStreamFields.add(nsPrefix + 'Expense_Initial_Direct_Cost__c');
        idStreamFields.add(nsPrefix + 'Ending_Initial_Direct_Cost__c');
        idcStreamOC.addFields(idStreamFields);
        idcStreamOC.setOrderClause('cllease__Date__c ASC');

        mfiflexUtil.ObjectCache feeStreamOC = ec.createRelationship(nsPrefix + 'Fee_Streams__r');
        leaseOC.addRelationship(feeStreamOC);
        List<String> feeStreamFields = new List<String>();
        feeStreamFields.add(nsPrefix + 'Accrued__c');
        feeStreamFields.add(nsPrefix + 'Beginning_Balance__c');
        feeStreamFields.add(nsPrefix + 'Contract_Fee__c');
        feeStreamFields.add(nsPrefix + 'Contract_Fee__r.cllease__Contract_Equipment__c');
        feeStreamFields.add(nsPrefix + 'Date__c');
        feeStreamFields.add(nsPrefix + 'Ending_Balance__c');
        feeStreamFields.add(nsPrefix + 'Fee_Amount__c');
        feeStreamFields.add(nsPrefix + 'Transaction_Sub_Type__c');
        feeStreamOC.addFields(feeStreamFields);
        feeStreamOC.setOrderClause('cllease__Date__c ASC');

        mfiflexUtil.ObjectCache subsidyOC = ec.createRelationship(nsPrefix + 'Subsidy_Streams__r');
        leaseOC.addRelationship(subsidyOC);
        List<String> subsidyStreamFields = new List<String>();
        subsidyStreamFields.add(nsPrefix + 'Date__c');
        subsidyStreamFields.add(nsPrefix + 'Accrued__c');
        subsidyStreamFields.add(nsPrefix + 'Accrued_Amount__c');
        subsidyStreamFields.add(nsPrefix + 'Beginning_Balance__c');
        subsidyStreamFields.add(nsPrefix + 'Transaction_Sub_Type__c');
        subsidyStreamFields.add(nsPrefix + 'Ending_Balance__c');
        subsidyOC.addFields(subsidyStreamFields);
        subsidyOC.setOrderClause('cllease__Date__c ASC');

        mfiflexUtil.ObjectCache depStreamOC = ec.createRelationship(nsPrefix + 'Dep_Streams__r');
        leaseOC.addRelationship(depStreamOC);
        List<String> depStreamFields = new List<String>();
        depStreamFields.add(nsPrefix + 'Date__c');
        depStreamFields.add(nsPrefix + 'Accrued__c');
        depStreamFields.add(nsPrefix + 'Active__c');
        depStreamFields.add(nsPrefix + 'Beginning_Residual__c');
        depStreamFields.add(nsPrefix + 'Dep_Expense__c');
        depStreamFields.add(nsPrefix + 'Ending_Residual__c');
        depStreamOC.addFields(depStreamFields);
        depStreamOC.setOrderClause('cllease__Date__c ASC');


        mfiflexUtil.ObjectCache amzStreamOC = ec.createRelationship(nsPrefix + 'Amz_Streams__r');
        leaseOC.addRelationship(amzStreamOC);
        List<String> amzStreamFields = new List<String>();
        amzStreamFields.add(nsPrefix + 'Date__c');
        amzStreamFields.add(nsPrefix + 'Accrued_Flag__c');
        amzStreamFields.add(nsPrefix + 'Monthly_Earning__c');
        amzStreamFields.add(nsPrefix + 'Unearned_Beginning_balance__c');
        amzStreamFields.add(nsPrefix + 'Active__c');
        amzStreamFields.add(nsPrefix + 'Unearned_Ending_balance__c');
        amzStreamFields.add(nsPrefix + 'Comment__c');
        amzStreamFields.add(nsPrefix + 'SYD__c');
        amzStreamOC.addFields(amzStreamFields);
        amzStreamOC.setOrderClause(nsPrefix + 'Date__c ASC');


        mfiflexUtil.ObjectCache dueDetailOC = ec.createRelationship(nsPrefix + 'Dues_Details__r');
        leaseOC.addRelationship(dueDetailOC);
        List<String> dueDetailFields = new List<String>();
        dueDetailFields.add(nsPrefix + 'Transaction_Date__c');
        dueDetailFields.add(nsPrefix + 'Due_Date__c');
        dueDetailFields.add(nsPrefix + 'Balance_Amount__c');
        dueDetailFields.add(nsPrefix + 'Payment_Satisfied__c');
        dueDetailFields.add(nsPrefix + 'Rental_Due_Amount__c');
        dueDetailFields.add(nsPrefix + 'Rental_Paid_Amount__c');
        dueDetailFields.add(nsPrefix + 'Status__c');
        dueDetailFields.add(nsPrefix + 'Tax_Due_Amount__c');
        dueDetailFields.add(nsPrefix + 'Tax_Paid_Amount__c');
        dueDetailFields.add(nsPrefix + 'Tax_Processed__c');
        dueDetailFields.add(nsPrefix + 'Total_Due_Amount__c');
        dueDetailFields.add(nsPrefix + 'Total_Paid_Amount__c');
        dueDetailFields.add(nsPrefix + 'Late_Charge_Applied__c');
        dueDetailFields.add(nsPrefix + 'Primary_Flag__c');
        dueDetailFields.add(nsPrefix + 'Reversed_Flag__c');
        dueDetailFields.add(nsPrefix + 'Restructured__c');
        dueDetailFields.add(nsPrefix + 'Due_Type__c');
        dueDetailFields.add(nsPrefix + 'GL_Posted_Flag__c');
        dueDetailFields.add(nsPrefix + 'GL_Process_Date__c');
        dueDetailFields.add(nsPrefix + 'Due_Type_Description__c');
        dueDetailOC.addFields(dueDetailFields);
        dueDetailOC.setOrderClause(nsPrefix + 'Due_Date__c ASC');

        if(Test.isRunningTest()) {
            mfiflexUtil.ObjectCache dueDetailLinesOC = ec.createRelationship(nsPrefix + 'Due_Detail_Lines__r');
            leaseOC.addRelationship(dueDetailLinesOC);
            List<String> dueDetailLineFields = new List<String>();
            dueDetailLineFields.add(nsPrefix + 'Bill__c');
            dueDetailLineFields.add(nsPrefix + 'Bill__r.Name');
            dueDetailLineFields.add(nsPrefix + 'Contract_Equipment__r.Name');
            dueDetailLineFields.add(nsPrefix + 'Contract__r.Name');
            dueDetailLineFields.add(nsPrefix + 'Due_Date__c');
            dueDetailLineFields.add(nsPrefix + 'Rental_Due_Amount__c');
            dueDetailLineFields.add(nsPrefix + 'Tax_Due_Amount__c');
            dueDetailLineFields.add(nsPrefix + 'Total_Due_Amount__c');
            dueDetailLineFields.add(nsPrefix + 'Transaction_Date__c');
            dueDetailLinesOC.addFields(dueDetailLineFields);
            dueDetailLinesOC.setOrderClause(nsPrefix + 'Bill__c ASC');

            mfiflexUtil.ObjectCache otherTxnOC = ec.createRelationship(nsPrefix + 'Other_Lease_Transactions__r');
            leaseOC.addRelationship(otherTxnOC);
            List<String> oltFields = new List<String>();
            oltFields.add(nsPrefix + 'Accrue_Subvention__c');
            oltFields.add(nsPrefix + 'Accum_Depreciation__c');
            oltFields.add(nsPrefix + 'ContractEquipment__c');
            oltFields.add(nsPrefix + 'Equipment_Cost__c');
            oltFields.add(nsPrefix + 'Equipment_Detail__c');
            oltFields.add(nsPrefix + 'GL_Transaction_Flag__c');
            oltFields.add(nsPrefix + 'Lease_Account__c');
            oltFields.add(nsPrefix + 'Residual_Amount_New__c');
            oltFields.add(nsPrefix + 'Security_Deposit__c');
            oltFields.add(nsPrefix + 'Termination_Profit__c');
            oltFields.add(nsPrefix + 'To_Be_Accrued_Income__c');
            oltFields.add(nsPrefix + 'To_Be_Billed_Rent__c');
            oltFields.add(nsPrefix + 'Transaction_Type__c');
            oltFields.add(nsPrefix + 'Txn_Amt__c');
            oltFields.add(nsPrefix + 'Txn_Date__c');
            oltFields.add(nsPrefix + 'Unbilled_Rent__c');
            oltFields.add(nsPrefix + 'Unearned_Lease_Income_Amount__c');
            otherTxnOC.addFields(oltFields);

            Set<String> oltTxnTypes = new Set<String> {'ASSET RETURN', 'ASSET SOLD', 'TERMINATION'  };
            String oltWhereClause = ' cllease__Transaction_Type__c IN :oltTxnTypes ';
            otherTxnOC.addNamedParameter('oltTxnTypes', oltTxnTypes);
            otherTxnOC.setWhereClause(oltWhereClause);

            mfiflexUtil.ObjectCache assetReturnOC = ec.createRelationship(nsPrefix + 'Asset_Return__r');
            leaseOC.addRelationship(assetReturnOC);
            List<String> assetReturnFields = new List<String>();
            assetReturnFields.add(nsPrefix + 'Contract__c');
            assetReturnFields.add(nsPrefix + 'Contract__r.Name');
            assetReturnFields.add(nsPrefix + 'Return_Status__c');
            assetReturnFields.add(nsPrefix + 'Contract_Equipment__c');
            assetReturnFields.add(nsPrefix + 'Contract_Equipment__r.Name');
            assetReturnFields.add(nsPrefix + 'Equipment_Detail__c');
            assetReturnFields.add(nsPrefix + 'Equipment_Detail__r.Name');
            assetReturnFields.add(nsPrefix + 'Quote_Header__c');
            assetReturnFields.add(nsPrefix + 'Quote_Header__r.Name');
        }

        mfiflexUtil.ObjectCache chargesOC = ec.createRelationship(nsPrefix + 'Charges__r');
        leaseOC.addRelationship(chargesOC);
        List<String> chargesFields = new List<String>();
        chargesFields.add(nsPrefix + 'Paid_Amount__c');
        chargesFields.add(nsPrefix + 'Paid__c');
        chargesFields.add(nsPrefix + 'Total_Due_Amount__c');
        chargesFields.add(nsPrefix + 'Date__c');
        chargesFields.add(nsPrefix + 'Transaction_Date__c');
        chargesFields.add(nsPrefix + 'Transaction_Sub_Type__c');
        chargesFields.add(nsPrefix + 'Tax_Processed__c');
        chargesFields.add(nsPrefix + 'Waive__c');
        chargesFields.add(nsPrefix + 'Original_Amount__c');
        chargesFields.add(nsPrefix + 'Original_Tax_Amount__c');
        chargesOC.addFields(chargesFields);
        chargesOC.setOrderClause(nsPrefix + 'Date__c ASC');


        // batch_job_completed__c
        // = false condition required only when batch job processing
        // Id will be processed incase of TerminationQuote generation for single contract
        String query = leaseOC.buildQuery().getQuery();
        return query;
    }

    /**
     * Extract the Transaction Sub Types from CL Lease and create Map<String, Id> 
     */
    public static Map<String, Id> getTransactionSubTypesMap(List<String> subTypeNameList) {
        Map<String, Id> transactionSubTypeIdByName;
        Map<String, Id> resultMap = new Map<String, Id>();
        if(subTypeNameList == null || subTypeNameList.size() == 0) {
            transactionSubTypeIdByName = new Map<String, Id>();
            List<cllease__Transaction_Sub_Type__c> transactionSubTypes = [SELECT Id, Name FROM cllease__Transaction_Sub_Type__c LIMIT 1000];
            for (cllease__Transaction_Sub_Type__c ts : transactionSubTypes) {
                transactionSubTypeIdByName.put(ts.Name, ts.Id);
            }
            resultMap.putAll(transactionSubTypeIdByName); 
        }
        return resultMap;
    }

    /**
     * Creating Query fro 3rd Party Sale 
     */
    public static String getThirdPartySaleDetailsQuery(Set<Id> collateralIds) {
        String collateralIdStr = getBranchStrFromSet(collateralIds);
        String query = 'SELECT Id, ' +
                        'Name, ' +
                        'clcommon__Collateral__c, ' +
                        'clcommon__Transaction_Amount__c ' +
                        'FROM clcommon__Equipment_Transaction__c ' +
                        'WHERE clcommon__Collateral__c in ( ' + collateralIdStr + ' ) ' +
                        // can be optimized later by adding the below clause after verifying the field in the Object.
                        //'AND clcommon__Equipment_Sale_Quote__r.clcommon__Third_Party_Sale__c = true ' +
                        'AND clcommon__Transaction_Type__c = \'' + clcommon.Constants.TRANSACTION_SOLD + '\'';
        return query.trim();
    }

    /**
     * Helper method to create String form from Set of Branch Ids
     */
    private static String getBranchStrFromSet(Set<Id> branchIds) {
        String branchIdStr = '';
        for(Id branchId : branchIds) {
            branchIdStr = branchIdStr + '\'' + String.escapeSingleQuotes(branchId) + '\'' + ',';
        }
        branchIdStr = branchIdStr + '\'\'';
        System.debug('branchIdStr: ' + branchIdStr);
        return branchIdStr;
    }

    // Generating the Unique ID for creating the Bills and Due detail lines insertion
    private static String kHexChars = '0123456789abcdefABCDEF';
    private static Integer count = 0;
    public enum Action {IMPORTED, TERMINATED, REPLACED}

    public static String generateUUID(){
        return String.valueOf(count++);

    }

    /**
     * Given an unsafeUrl string the function return the safeUrl.
     */
    public static String getSafeUrl(String unsafeUrl) {

        final String URL = '^([a-zA-Z0-9\\.\\&\\+\\/\\=\\?\\#\\\\]|%([0-9A-Fa-f]{2}))*$';
        Pattern urlPattern = Pattern.compile(URL);

        //Try to retrieve it from ApexPage.currentPage() if we fail set it to null
        String currentDomain = null;
        try {
            currentDomain = ApexPages.currentPage().getHeaders().get('Host');

            if (currentDomain != null) {
                currentDomain = currentDomain.trim();
            }

            if (String.isEmpty(currentDomain)) {
                currentDomain = null;
            }

        } catch (Exception e) {
            currentDomain = null;
        }

        if(currentDomain == null) {
            throw new CLSCustomException('Empty/null current domain');
        }

        String safeUrl = null;
        if (String.isEmpty(unsafeUrl)) {
            throw new CLSCustomException('Empty url');
        }
        if(unsafeUrl.length() > 512) {
            throw new CLSCustomException('Too long url');
        }

        Integer startPos = 0;
        Integer endPos = 0;
        if (unsafeUrl.toLowerCase().startsWith('http://')) {
            // remove http:// by setting startPos to after it
            startPos = 7;
        }
        else if (unsafeUrl.toLowerCase().startsWith('https://')) {
            // remove https:// by setting startPos to after it
            startPos = 8;
        }

        if(startPos > 0) { //input started with http or https
            endPos = unsafeUrl.indexOf('/', startPos);
            if (endPos == -1) {
                // did not find / to signal end of domain, check entire remainder as domain
                endPos = unsafeUrl.length();
            }
            // check domain - allow only strict domain name characters
            String urlDomain = unsafeUrl.substring(startPos, endPos);
            if(String.isEmpty(urlDomain)) {
                throw new CLSCustomException('Url doesnt have domain');
            }
            if(urlDomain.length() > 100) {
                throw new CLSCustomException('Too long url domain');
            }
            if(currentDomain != urlDomain) {
                throw new CLSCustomException('Unexpected url domain');
            }

            //now get the string after domain
            startPos = endPos;
            endPos = unsafeUrl.length();
            String url2 = unsafeUrl.substring(startPos, endPos);
            if(urlPattern.matcher(url2).matches() == false) {
                throw new CLSCustomException('URL Pattern not matching');
            }
        }
        else { // input didnt start with http or https

            if (unsafeUrl.startsWith('/') == true) {
                unsafeUrl = unsafeUrl.replaceFirst('/+', '');
            }


            if(urlPattern.matcher(unsafeUrl).matches() == false) {
                throw new CLSCustomException('URL Pattern not matching');
            }

            unsafeUrl = '/' + unsafeUrl;
        }


        safeUrl = unsafeUrl;
        return safeUrl;
    }

    /**
     * this method validaes if any action done on the warehouse equipment such as Importing , Replacing or Termination, it should be done on the 
     * entire set of Master Child equipment and not independently 
     */
	public static String validateParentChildEquipment(List<cllease__Contract_Equipment__c> contractEquipmentList, Action equipmentAction){
        list<Id> parentIds = new List<Id>();
        Map<Id, List<Id>> parentToChildEquipment = new Map<Id, List<Id>>();
        Map<Id, String> equipmentIdToName = new Map<Id, String>();
        for(cllease__Contract_equipment__c contractEquipment : contractEquipmentList) {
            Id warehouseEquipmentId = contractEquipment.cllease__Warehouse_Equipment__c;
            if(warehouseEquipmentId == null) {
                continue;
            }
            equipmentIdToName.put(contractEquipment.cllease__Warehouse_Equipment__c, contractEquipment.cllease__Warehouse_Equipment__r.clcommon__Equipment_Id__c);
            if (contractEquipment.cllease__Warehouse_Equipment__r.clcommon__Master_equipment__c == null) {
                parentIds.add(warehouseEquipmentId); // list of Parent equipment in the contract, selected for the action 
                if (! parentToChildEquipment.containsKey(warehouseEquipmentId)) {
                    parentToChildEquipment.put(warehouseEquipmentId, new List<Id>());
                }
            } else {
                Id masterId = contractEquipment.cllease__Warehouse_Equipment__r.clcommon__Master_equipment__c;
                List<Id> childIds;
                if (parentToChildEquipment.containsKey(masterId)) {
                    childIds = parentToChildEquipment.get(masterId);
                } else {
                    childIds = new List<Id>();
                }
                childIds.add(warehouseEquipmentId);
                parentToChildEquipment.put(masterId, childIds); // Either the parent or the child selected for action in the contract.
            }
        } 

        Map<Id, clcommon__Collateral__c> parentEquipmentISelected = new Map<Id, clcommon__Collateral__c>([SELECT Id, clcommon__Equipment_Id__c,
                                                                                                	   (SELECT Id FROM clcommon__Child_Equipments__r)
                                                                                                 	   FROM clcommon__Collateral__c
                                                                                                 	   WHERE Id IN :parentIds]);
        
        for(Id parentId : parentToChildEquipment.keySet()) {
            Integer childInLease = 0, childEquipmentSize = 0;
            String error;
            if (parentEquipmentISelected.containsKey(parentId)) {
                childEquipmentSize = parentEquipmentISelected.get(parentId).clcommon__Child_equipments__r.size();
                childInLease = parentToChildEquipment.get(parentId).size();
            } else { 
                // parent equipment is not in the parent Equipment selected for action, hence only child is seledted for action
            	String chilEquipName = equipmentIdToName.get(parentToChildEquipment.get(parentId).get(0));
            	if(equipmentAction == Action.TERMINATED) {
            		error = chilEquipName + ' cannot be terminated without terminating associated Master Equipment. Equipment associated as Master Child cannot be terminated independently';
            	} else if(equipmentAction == Action.REPLACED) {
            		error = chilEquipName + ' cannot be replaced without replacing associated Master Equipment. Please select associated Master equipment also for replacement, or de-link the Master Child relationship to continue.';
            	} else if(equipmentAction == Action.IMPORTED) {
            		error = chilEquipName + ' cannot be leased independently without leasing associated Master Equipment. Please import the Master equipment to continue.';
            	}
            	return error;
            }
            if (childEquipmentSize != childInLease) {
                // Parent equipment is selected for action, but not all of its child equipment, 
            	if(equipmentAction == Action.TERMINATED) {
            		error = 'All the Child Equipment of ' + equipmentIdToName.get(parentId) + ' are not terminated. Equipment associated as Master Child cannot be terminated independently';
            	} else if(equipmentAction == Action.REPLACED) {
            		error = 'All the Child Equipment of ' + equipmentIdToName.get(parentId) + ' are not replaced. Equipment associated as Master Child cannot be replaced independently';
            	} else if(equipmentAction == Action.IMPORTED) {
            		error = 'All the Child Equipment of ' + equipmentIdToName.get(parentId) + ' are not leased in the contract. Equipment associated as Master Child cannot be leased independently';
            	}
            	return error;
            }
        }
        return null;
    }
    
    /**
     * Given the idString, extract the valid Id from it and confirm that it is valid id for given expectedSObjectType.
     * Throws exception if the sobject type is not valid
     */
    public static Id getSafeId(String idString, SObjectType expectedSObjectType) {
        Id validId = null;
        try {
            if(isValidSalesforceId(idString, expectedSObjectType)) {
                validId = ID.valueOf(idString);
            }
            else {
                throw new CLSCustomException('incorrect salesforce id');
            }
        }
        catch (Exception e) {
            validId = null;
            throw e;
        }
        return validId;
    }

    /**
     * Test a String to see if it is a valid SFDC  ID
     */
    public static Boolean isValidSalesforceId( String sfdcId, SObjectType expectedSObjectType ) {
        Id retId = null;
        Boolean retVal = false;
        try {

            if (Pattern.compile('[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}').matcher(sfdcId).matches()) {
                // Try to assign it to an Id before checking the type
                retId = ID.valueOf(sfdcId);

                // Use the Type to construct an instance of this sObject
                sObject sObj = expectedSObjectType.newSObject(sfdcId);

                // If the tests passed, it's valid
                retVal = true;
            }
        }
        catch ( Exception e ) {
            retId = null;
            retVal = false;
            throw new CLSCustomException('Not valid Salesforce ID. Exception : ' + e.getMessage());
        }

        // ID is not valid
        return retVal;
    }

    /**
     * Extracting QUote Header details during termination processing
     */
    public static List<cllease__Termination_Quote_Header__c> getQuoteHeaders(Id quoteHeaderId) {
        return getQuoteHeaders(null, quoteHeaderId);
    }

    /**
     * Extracting QUote Header details during termination processing
     */
    public static List<cllease__Termination_Quote_Header__c> getQuoteHeaders(cllease__Lease_Account__c contract) {
        return getQuoteHeaders(contract, null);
    }

    /**
     * Extracting QUote Header details during termination processing
     */
    public static List<cllease__Termination_Quote_Header__c> getQuoteHeaders(cllease__Lease_Account__c contract, Id quoteHeaderId) {

        String nsPrefix = CLSCustomUtil.getNSWithUnderScore();
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache termHeaderOC = ec.getObject('TerminationHeaders2');
        if (termHeaderOC != null) {
            ec.deleteObject('TerminationHeaders2');
        }

        termHeaderOC = ec.createObject('TerminationHeaders2', nsPrefix + 'Termination_Quote_Header__c');
        termHeaderOC.addFields(nsPrefix + 'Contract__c');
        termHeaderOC.addFields(nsPrefix + 'Early_Termination__c');
        termHeaderOC.addFields(nsPrefix + 'Effective_From__c');
        termHeaderOC.addFields(nsPrefix + 'Effective_To__c');
        termHeaderOC.addFields(nsPrefix + 'Full_Termination__c');
        termHeaderOC.addFields(nsPrefix + 'Is_Equipment_Termination__c');
        termHeaderOC.addFields(nsPrefix + 'Quote_Amount__c');
        termHeaderOC.addFields(nsPrefix + 'Quote_Reason__c');
        termHeaderOC.addFields(nsPrefix + 'Quote_Type__c');
        termHeaderOC.addFields(nsPrefix + 'Status__c');
        termHeaderOC.addFields(nsPrefix + 'Termination_Date__c');
        termHeaderOC.addFields(nsPrefix + 'Rebate_Amount__c');
        termHeaderOC.addFields(nsPrefix + 'Rebate_Percentage__c');
        termHeaderOC.addFields(nsPrefix + 'Requested_Termination_Date__c');
        termHeaderOC.addFields(nsPrefix + 'Termination_With_Purchase__c');
        termHeaderOC.addFields(nsPrefix + 'Third_Party_Sale__c');
        termHeaderOC.addFields(nsPrefix + 'Third_Party_Sale_Amount__c');

        String termHeaderWhereClause = '';
        if(contract != null && contract.Id != null) {
            termHeaderOC.addNamedParameter('contractId', contract.Id);
            termHeaderWhereClause += ' (' + nsPrefix + 'Contract__c = :contractId) ';
        }
        if(quoteHeaderId != null ) {
            termHeaderOC.addNamedParameter('quoteHeaderId', quoteHeaderId);
            if(String.isNotBlank(termHeaderWhereClause)) {
                termHeaderWhereClause += ' AND ';
            }
            termHeaderWhereClause += ' (Id = :quoteHeaderId) ';
        }

        if(String.isNotBlank(termHeaderWhereClause)) {
            termHeaderOC.setWhereClause(termHeaderWhereClause);
        }

        termHeaderOC.setOrderClause(nsPrefix + 'Termination_Date__c DESC');


        mfiflexUtil.ObjectCache lineOC = ec.createRelationship(nsPrefix + 'Termination_Quote_Lines__r');
        termHeaderOC.addRelationship(lineOC);
        lineOC.addFields(nsPrefix + 'Account_Balance_Type__c');
        lineOC.addFields(nsPrefix + 'Add_To_Quote_Amount__c');
        lineOC.addFields(nsPrefix + 'Amount__c');
        lineOC.addFields(nsPrefix + 'Amount_Type__c');
        lineOC.addFields(nsPrefix + 'Billable__c');
        lineOC.addFields(nsPrefix + 'Bill_Field_API_Name__c');
        lineOC.addFields(nsPrefix + 'Fee_Definition__c');
        lineOC.addFields(nsPrefix + 'Fee_Definition__r.clcommon__Taxable__c');
        lineOC.addFields(nsPrefix + 'Fee_Definition__r.clcommon__Tax_Exempt__c');
        lineOC.addFields(nsPrefix + 'Fee_Definition__r.clcommon__Vat_Rate__c');
        lineOC.addFields(nsPrefix + 'Fee_Definition__r.clcommon__Vat_Rate__r.clcommon__Tax_Rate__c');
        lineOC.addFields(nsPrefix + 'Is_Account_Balancable__c');
        lineOC.addFields(nsPrefix + 'Line_Type__c');
        lineOC.addFields(nsPrefix + 'Quote_Header__c');

        mfiflexUtil.ObjectCache quoteEqpOC = ec.createRelationship(nsPrefix + 'Termination_Quote_Equipments__r');
        termHeaderOC.addRelationship(quoteEqpOC);
        quoteEqpOC.addFields(nsPrefix + 'Contract_Equipment__c');
        quoteEqpOC.addFields(nsPrefix + 'Contract_Equipment__r.' + nsPrefix + 'Equipment_Serial_Number__c');
        quoteEqpOC.addFields(nsPrefix + 'Equipment_Detail__c');
        quoteEqpOC.addFields(nsPrefix + 'Termination_Quote_Header__c');

        return (List<cllease__Termination_Quote_Header__c>) termHeaderOC.buildQuery().executeQuery().getRecords();

    }

    @Future(callout=true)
    public static void updateVertexTax(String quoteHeaderId) {

        // Retrieving the Quote details with equipment Quote
        cllease__Termination_Quote_Header__c quoteHeader = [SELECT Id, Name, cllease__Contract__r.Name,
                                                                    cllease__Contract__r.cllease__First_Payment_Date__c,
                                                                    cllease__Contract__r.cllease__Maturity_Date__c,
                                                                (SELECT Id, Name,
                                                                    cllease__Amount__c,
                                                                    cllease__Line_Type__c,
                                                                    cllease__Add_To_Quote_Amount__c,
                                                                    cllease__Amount_Type__c
                                                                FROM cllease__Termination_Quote_Lines__r),
                                                                (SELECT Id, Name,
                                                                    Amount__c,
                                                                    Tax_Exempt__c,
                                                                    Termination_Quote_Line__c,
                                                                    Termination_Quote_Line__r.cllease__Amount__c,
                                                                    Termination_Quote_Line__r.cllease__Line_Type__c,
                                                                    Termination_Quote_Line__r.cllease__Add_To_Quote_Amount__c,
                                                                    Termination_Quote_Equipment__c,
                                                                    Termination_Quote_Equipment__r.cllease__Contract_Equipment__r.Name,
                                                                    Termination_Quote_Equipment__r.cllease__Contract_Equipment__r.GARD__c,
                                                                    DestinationCity__c,
                                                                    DestinationCounty__c,
                                                                    DestinationState__c,
                                                                    DestinationZipCode__c
                                                                FROM Termination_Equipment_Quotes__r )
                                                            FROM cllease__Termination_Quote_Header__c
                                                            WHERE Id = :quoteHeaderId];
        
        // Limitation: Currently This trigger handles quote line tax calculation for single quote at a time
        getTerminationQuoteTax(quoteHeader);

    }
    
    /**
     * Following method helps in Calculating the Tax for Termination Quote
     **/
    public static void getTerminationQuoteTax(cllease__Termination_Quote_Header__c quoteHeader) {

        VertexApi__c vertexConfig = CLSCustomUtil.getVertexConfiguration();
        Vertex_Log__c vertexLog = new Vertex_Log__c();
        cllease__Termination_Quote_Line__c vertexTaxQuoteLine;

        HttpResponse res;
        Integer responseCode = 0; 
        try {

            // Getting Termination Quote Field API Map
            Set<String> terminationQuoteLinesTypes = VertexUtil2.terminationDueDetailLineFieldAPIMap.keySet();

            // Validation on Quote Lines
            // 2. Create XML Request
            Map<String, Termination_Equipment_Quote__c> quoteLinesToProcessForTaxMap = new Map<String, Termination_Equipment_Quote__c>();
            Map<String, Termination_Equipment_Quote__c> quoteLinesMap = new Map<String, Termination_Equipment_Quote__c>();
            
            for(Termination_Equipment_Quote__c eqpQuoteLine : quoteHeader.Termination_Equipment_Quotes__r) {
                if(eqpQuoteLine.Termination_Quote_Line__r.cllease__Line_Type__c == DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX) {
                    vertexTaxQuoteLine = new cllease__Termination_Quote_Line__c(Id = eqpQuoteLine.Termination_Quote_Line__c, cllease__Quote_Header__c = quoteHeader.Id);
                } else if(terminationQuoteLinesTypes.contains(eqpQuoteLine.Termination_Quote_Line__r.cllease__Line_Type__c)) {
                    quoteLinesToProcessForTaxMap.put(eqpQuoteLine.Name, eqpQuoteLine);
                    quoteLinesMap.put(eqpQuoteLine.Termination_Quote_Line__r.cllease__Line_Type__c, eqpQuoteLine);
                }
            }
            System.debug(LoggingLevel.ERROR, '--- quoteLinesToProcessForTaxMap: '+quoteLinesToProcessForTaxMap.values());

            // 3. Send HTTP Rquest 
            Dom.document methoddoc = VertexUtil2.getTerminationQuoteReqXml(quoteHeader, quoteLinesToProcessForTaxMap.values());
            System.debug(LoggingLevel.ERROR, '=================================');
            System.debug(LoggingLevel.ERROR,'request: '+methoddoc.toXmlString());
            System.debug(LoggingLevel.ERROR, '=================================');

            // B.1 Creating Http Request
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(vertexConfig.End_Point__c);
            req.setHeader('Content-Type', 'text/xml');
            req.setBody(methoddoc.toXMlString());

            Http http = new Http();
            // if (actual response ) else (test mock response)
            if(!System.Test.isRunningTest()) {
                res = http.send(req);
            } else {
                //res = VertexHttpResponseGenerator.vertexBillHTTPResponse(dueDetailLines);
            }
            System.debug(LoggingLevel.ERROR, ' Response Code: '+res.getStatusCode());
            responseCode = res.getStatusCode();

            // Recording Vertex Request XML & Response XML
            if(!System.Test.isRunningTest() && vertexConfig.Enable_Vertex_Xml_Logging__c) {
                vertexLog.Request_XML__c  = methoddoc.toXMlString();
                vertexLog.Response_XML__c = res.getBody();
            }
        } catch(Exception e) {
            // A. Insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name='Termination Quote Request: ', cllease__Date__c=system.today(), 
            cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
            // C. Skip the process in case of any exception during initial Callout Exception
            return; 

        } finally {
            // Logging the Vertex Request
            if(!System.Test.isRunningTest() && vertexConfig.Enable_Vertex_Xml_Logging__c
                && vertexLog.Request_XML__c != null && vertexLog.Response_XML__c != null) {
                vertexLog.Contract_Names__c = CLSCustomUtil.getStringsFromList(new List<String> {quoteHeader.cllease__Contract__r.Name});
                vertexLog.Category__c = 'TERMINATION QUOTE-VERTEX TAX CALL';
                insert vertexLog;
            }
        }

        // 2. Processing Vertex Response SOAP only incase No HTTP Failures from 1.
        Savepoint sp = Database.setsavepoint();
        try {
            // Process Successful Response
            Dom.Document responseDom = new Dom.Document();
            responseDom.load(res.getbody());

            System.debug(LoggingLevel.ERROR, '=================================');
            System.debug(LoggingLevel.ERROR,'response: '+responseDom.toXmlString());
            System.debug(LoggingLevel.ERROR, '=================================');

            // Processing Vertex Response SOAP
            if(responseCode == 200) {
                DOM.XMLNode root = responseDom.getRootElement();
                Boolean foundProduct = false, foundTotalTax = false;
                String lineType; 
                Decimal taxAmount = 0;
                // 4. Process the response and update the tax amounts in Quote Line.
                for(Dom.XMLNode soapBodyChild : root.getChildren()) {
                    //System.debug(LoggingLevel.ERROR, ' processing node: '+soapBodyChild.getName());
                    if(soapBodyChild.getName() == 'Body') {
                        for(Dom.XMLNode vertexEnvelope : soapBodyChild.getChildren()) {
                            if(vertexEnvelope.getName() == 'VertexEnvelope') {
                                System.debug(LoggingLevel.ERROR, ' inside processing vertexEnvelope');
                                // Process the Vertex Envelope
                                for(DOM.XMLNode child1 : vertexEnvelope.getChildren()) {
                                    if(child1.getName() == 'QuotationResponse') {
                                        System.debug(LoggingLevel.ERROR, ' inside processing QuotationResponse');
                                        /*for(DOM.XMLNode child2 :child1.getChildren()) {
                                            // Resetting the flag for each item iteration
                                            //foundProduct = false;
                                            foundTotalTax = false;
                                            if(child2.getName() == 'LineItem') {
                                                for(DOM.XMLNode child3 :child2.getChildren()) {
                                                    // Check for Product and Tax Amounts from Node.

                                                    if(child3.getName() == 'TotalTax') {
                                                        taxAmount = Decimal.valueOf(child3.getText());

                                                        //foundTotalTax = true;
                                                    }
                                                }
                                            }

                                        }*/

                                        // Getting Total Estimated Tax for Quote level
                                        for(DOM.XMLNode child2 :child1.getChildren()) {
                                            if(child2.getName() == 'TotalTax') {
                                                taxAmount = Decimal.valueOf(child2.getText());
                                                //foundTotalTax = true;
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                } 

                System.debug(LoggingLevel.ERROR, ' Updated Vertex QUoteline record:taxAmount  '+taxAmount);
                // Updating the Tax Amount in VERTEX TAX quote line
                vertexTaxQuoteLine.cllease__Amount__c =  taxAmount;
                update vertexTaxQuoteLine;

                 // Updating the Termination Quote Amount
                Decimal totalAmount = 0;

                // adding Tax Value 
                totalAmount = taxAmount;
                // Update the QUote Header value including the Tax Value
                for(cllease__Termination_Quote_Line__c eqpQuoteLine : quoteHeader.cllease__Termination_Quote_Lines__r) {
                    if(eqpQuoteLine.cllease__Add_To_Quote_Amount__c || eqpQuoteLine.cllease__Amount_Type__c == 'FEE' ) {
                        totalAmount += eqpQuoteLine.cllease__Amount__c;
                    }
                }

                quoteHeader.cllease__Quote_Amount__c = totalAmount;
                update quoteHeader;


                // ReSetting Vertex calculated flag = false after processing
                //TerminationUtil.updateQuoteVertexFlag(quoteHeader.Id, false);

            } else if(responseCode == 500){
                // Process the response for Error message
                responseDom.load(res.getbody());
                DOM.XMLNode root = responseDom.getRootElement();
                for(Dom.XMLNode soapBodyChild : root.getChildren()) {
                    System.debug(LoggingLevel.ERROR, ' processing node: '+soapBodyChild.getName());
                    if(soapBodyChild.getName() == 'Body') {
                        for(Dom.XMLNode fault : soapBodyChild.getChildren()) {
                            if(fault.getName() == 'Fault') {
                                for(Dom.XMLNode faultString : fault.getChildren()) {
                                    if(faultString.getName() == 'faultstring') {
                                        throw new CLSCustomException(faultString.getText().trim());
                                    }
                                }
                            }
                        }
                    }
                }

            } else {
                // For any other responses apart from 200, 500
                throw new CLSCustomException('Unknown Vertex API Response Code: '+responseCode +' Please check with Vertex.');
            
            }
            
        } catch(exception e){           
            Database.rollback(sp);   
            insert new cllease__Batch_Process_Log__c(Name='Termination Quote Request: ', cllease__Date__c=system.today(), 
            cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
       }  

    }


    /**
     * Following method helps in Creating Termination Equipment Quotes
     **/
    public static void createTerminationEqpQuoteObjects(String terminationQuoteId) {

        System.debug(LoggingLevel.ERROR, 'Started Processing the Termination Equipment Quote Creation...');
        
        // 1. Query Existing TEmination Quote Equipment Quote Junction Objects
        String query = ' SELECT Id, Name, cllease__Contract__c, ' +
                        '   (SELECT Id, cllease__Contract_Equipment__c, cllease__Contract_Equipment__r.cllease__Estimated_Selling_Price__c FROM cllease__Termination_Quote_Equipments__r ), ' +
                        '   (SELECT Id, cllease__Amount__c, cllease__Add_To_Quote_Amount__c, cllease__Line_Type__c FROM cllease__Termination_Quote_Lines__r ), ' +
                        '   (SELECT Id FROM Termination_Equipment_Quotes__r ) ' +
                        ' FROM cllease__Termination_Quote_Header__c ' +
                        ' WHERE ID =: terminationQuoteId ';

        System.debug(LoggingLevel.ERROR, ' Query on TerminationUtil: '+query);

        List<cllease__Termination_Quote_Header__c> quoteHeaders = Database.query(query);  
        cllease__Termination_Quote_Header__c quoteHeader;
        List<Termination_Equipment_Quote__c> eqpQuoteLines;

        if(quoteHeaders.size() > 1 || quoteHeaders.size() == 0) {
            throw new CLSCustomException('Invalid no of Termination Quotes created...');
        }       

        quoteHeader = quoteHeaders.get(0);

        // Skipping the process incase 
        /*if(quoteHeader.Quote_Vertex_Call_Completed__c) {
            return;
        }*/

        System.debug(LoggingLevel.ERROR, ' quoteHeader eqps: '+quoteHeader.cllease__Termination_Quote_Equipments__r);
        System.debug(LoggingLevel.ERROR, ' quoteHeader lines: '+quoteHeader.cllease__Termination_Quote_Lines__r);
        
        // Delete existing termination Equipmennt Quotes and create new ones for changed amounts
        if(quoteHeader != null && quoteHeader.Termination_Equipment_Quotes__r != null) {
            delete quoteHeader.Termination_Equipment_Quotes__r;
        }
        
        // Calculate Prorated amounts for Termination Equipment Quotes and calculate tax per Equipment level in Termination.

        Decimal totalEquipmentCost = 0;
        for(cllease__Termination_Quote_Equipment__c quoteEqp : quoteHeader.cllease__Termination_Quote_Equipments__r) {
            totalEquipmentCost += quoteEqp.cllease__Contract_Equipment__r.cllease__Estimated_Selling_Price__c;
        }

        System.debug(LoggingLevel.ERROR, ' totalEquipmentCost: '+totalEquipmentCost);
        
        // 2. Calculate the Proration for each Equipments for amount split up for Contract Level
        String contractId = quoteHeader.cllease__Contract__c;
        
        // Create Map of Payment Streams of FEES type with Equipments
        AggregateResult[] unEarnedChargesList = [SELECT sum(cllease__Rental_Amount__c) unbilledCharge, cllease__Contract_Equipment__c equipId
                                                    FROM  cllease__Payment_Stream__c
                                                    WHERE cllease__Payment_Type__c = 'FEES' 
                                                       AND cllease__Contract__c = :contractId
                                                       AND cllease__Contract_Equipment__c != null
                                                       AND cllease__Active__c = true
                                                       AND cllease__Billed__c = false
                                                    GROUP BY cllease__Contract_Equipment__c];

        Map<Id, Decimal> eqpToUnbilledChargesMap = new Map<Id, Decimal>();
        Decimal totalQuoteServiceAmount = 0;

        for (AggregateResult r : unEarnedChargesList) {
            Decimal amount  = (Decimal)r.get('unbilledCharge');
            Id eqpId    = (Id)r.get('equipId');
            eqpToUnbilledChargesMap.put(eqpId, amount);
            totalQuoteServiceAmount += amount;
        }

        System.debug(LoggingLevel.ERROR, ' totalQuoteServiceAmount: '+totalQuoteServiceAmount);

        System.debug(LoggingLevel.ERROR, ' eqpToUnbilledChargesMap: '+eqpToUnbilledChargesMap);

        cllease__Termination_Quote_Line__c serviceQuoteLine;

        // Create Termination Equipment Quotes
        if(quoteHeader != null) {
            
            eqpQuoteLines = new List<Termination_Equipment_Quote__c>();
            // Looping through QUote Equipments
            for(cllease__Termination_Quote_Equipment__c quoteEqp : quoteHeader.cllease__Termination_Quote_Equipments__r) {
                Decimal prorated = (quoteEqp.cllease__Contract_Equipment__r.cllease__Estimated_Selling_Price__c) / totalEquipmentCost;
                // Looping through Quote Lines
                for(cllease__Termination_Quote_Line__c quoteLine : quoteHeader.cllease__Termination_Quote_Lines__r) {
                    System.debug(LoggingLevel.ERROR, ' processing quote Line '+ quoteLine.cllease__Line_Type__c);
                    // Creating junction object
                    Termination_Equipment_Quote__c termEqpQuote = new Termination_Equipment_Quote__c(Termination_Quote__c = quoteHeader.Id,
                                                                            Termination_Quote_Equipment__c = quoteEqp.Id,
                                                                            Termination_Quote_Line__c = quoteLine.Id);

                    if(quoteLine.cllease__Line_Type__c == 'QUOTE SERVICE AND MAINTENANCE') {
                        serviceQuoteLine = new cllease__Termination_Quote_Line__c(Id = quoteLine.Id);
                        termEqpQuote.Amount__c = (Decimal)eqpToUnbilledChargesMap.get(quoteEqp.cllease__Contract_Equipment__c);
                    } else {
                        Decimal amountSplit = prorated * quoteLine.cllease__Amount__c;
                        termEqpQuote.Amount__c = amountSplit;
                    }
                    eqpQuoteLines.add(termEqpQuote);
                }
            }
            
        }

        if(serviceQuoteLine != null) {
            // Updating the Service & Estimate Quote amount.
            serviceQuoteLine.cllease__Amount__c = totalQuoteServiceAmount;
             update serviceQuoteLine;
        }
        

        System.debug(LoggingLevel.ERROR, ' Equipment Quote lines created: '+eqpQuoteLines);
        // 2. If no records available, create new records for Equipments and Quotes and return.
        insert eqpQuoteLines;
    }

    /**
     * Following method helps in updating Vertex Calculated flag in QUote Header
     **/
    /*public static void updateQuoteVertexFlag(String quoteHeaderId, Boolean vertexFlag) {
        cllease__Termination_Quote_Header__c quoteHeader = [SELECT Id, Name, Quote_Vertex_Call_Completed__c
                                                            FROM cllease__Termination_Quote_Header__c
                                                            WHERE Id = :quoteHeaderId];

        // updatign the flag // if true: vertex calculation is completed , false : not completed.
        quoteHeader.Quote_Vertex_Call_Completed__c = (vertexFlag != null ? vertexFlag : false);
        System.debug(LoggingLevel.ERROR, ' Checking for update value; '+quoteHeader.Quote_Vertex_Call_Completed__c);
        update quoteHeader;
    }*/

    /**
     * Following method the value of Vertex Calculated flag from QUote Header
     **/
    /*public static Boolean getQuoteVertexFlag(String quoteHeaderId) {
        cllease__Termination_Quote_Header__c quoteHeader = [SELECT Id, Name, Quote_Vertex_Call_Completed__c
                                                            FROM cllease__Termination_Quote_Header__c
                                                            WHERE Id = :quoteHeaderId];

        return (quoteHeader.Quote_Vertex_Call_Completed__c != null ? quoteHeader.Quote_Vertex_Call_Completed__c : false);
    }*/

}