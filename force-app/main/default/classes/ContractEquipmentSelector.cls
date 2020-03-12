/**
 * Created by sreerupa on 9/9/18.
 */

public class ContractEquipmentSelector extends mfiflexUtil.SObjectSelectorBase {

    private static String nsPrefix = CLSCustomUtil.getNSWithUnderScore();
    public mfiflexUtil.SObjectSelectorBase.QueryBuilder queryBuilder;

    public ContractEquipmentSelector() {
        this(getFields(false));
    }

    public ContractEquipmentSelector(Boolean fetchCustomFields) {
        this(getFields(fetchCustomFields));
    }

    public ContractEquipmentSelector(list<String> fieldsList) {
        super(cllease__Contract_Equipment__c.SObjectType, fieldsList);
        queryBuilder = createObjectCacheInstance();
    } 

    public static List<String> getFields(Boolean fetchCustomFields) {
        List<String> contractEquipmentFields = new List<String> {'Id', 'Name',
                                    nsPrefix + 'Contract__c',
                                    nsPrefix + 'Contract__r.' + nsPrefix + 'Contract_Date__c',
                                    nsPrefix + 'Contract__r.' + nsPrefix + 'Maturity_Date__c',
                                    nsPrefix + 'Contract__r.' + nsPrefix + 'Has_Asset_Level_Rent__c',
                                    nsPrefix + 'VIN__c',
                                    nsPrefix + 'Make__c',
                                    nsPrefix + 'Model__c',
                                    nsPrefix + 'Equipment_Serial_Number__c',
                                    nsPrefix + 'Equipment_Type__c',
                                    nsPrefix + 'Override_Tax_Flag__c',
                                    nsPrefix + 'Life_In_Months__c',
                                    nsPrefix + 'Country__c',
                                    nsPrefix + 'State_Province__c',
                                    nsPrefix + 'County__c',
                                    nsPrefix + 'City__c',
                                    nsPrefix + 'Street_Address__c',
                                    nsPrefix + 'Zip_Code__c',
                                    nsPrefix + 'Tax_Depreciation__r.' + nsPrefix + 'Tax_Depreciation_Method__c',
                                    nsPrefix + 'Subvention__c',
                                    nsPrefix + 'Equipment_Calculated_Cost__c',
                                    nsPrefix + 'Warehouse_Equipment__c',
                                    nsPrefix + 'Flag_To_Delete__c',
                                    nsPrefix + 'Dealer_Party__c',
                                    nsPrefix + 'Status__c',
                                    nsPrefix + 'Original_Equipment_Id__c',
                                    nsPrefix + 'Dealer_Fees__c',
                                    nsPrefix + 'Equipment_Cost__c',
                                    nsPrefix + 'Estimated_Selling_Price__c',
                                    nsPrefix + 'Other_Financed_Fees__c',
                                    nsPrefix + 'Residual_Amount__c',
                                    nsPrefix + 'Tax_Amount__c',
                                    nsPrefix + 'Total_Dealer_Charges__c',
                                    nsPrefix + 'Warranty_Amount__c',
                                    nsPrefix + 'Total_Tax_Amount__c',
                                    nsPrefix + 'Subsidy__c',
                                    nsPrefix + 'Generate_Book_Depreciation__c' ,
                                    nsPrefix + 'Depreciation_Basis__c' ,
                                    nsPrefix + 'life_in_months__c' ,
                                    nsPrefix + 'Rent__c' ,
                                    nsPrefix + 'Tax_Residual_Value__c'};
        if(fetchCustomFields){
            List<String> customFields = CLSCustomUtil.getAllCustomFields('Contract_Equipment__c');
            if(!customFields.isEmpty() && customFields.size() > 0){
                for(String field : customFields){
                    contractEquipmentFields.add(field);
                }
            }
        }
        return contractEquipmentFields;
    }

    // get contract equpment by Id list
    public List<cllease__Contract_Equipment__c> getContractEquipmentByIds(Set<Id> idSet){
        if(idSet != null && idSet.size() > 0) {
            queryBuilder.addNamedParameter('idSet', idSet);
            String whereClause = 'Id in :idSet';
            queryBuilder.setWhereClause(whereClause);
            System.debug(logginglevel.error, 'query ' + queryBuilder.getQuery());
            return queryBuilder.getRecords();
        } 
        return null;
    }

    // get active Contract id list having the Warehouse Equipment given
    public Map<Object, List<SObject>> getContractEquipmentByEquipmentId(Id equipmentId){
        if(equipmentId != null) {
            List<String> avtiveStatus =  new List<String> { LendingConstants.STATUS_ACTIVE_GOOD_STANDING,
                                                            LendingConstants.STATUS_ACTIVE_BAD_STANDING,
                                                            LendingConstants.STATUS_EVERGREEN};
            queryBuilder.addNamedParameter('equipmentId', equipmentId);
            queryBuilder.addNamedParameter('activeStatus', avtiveStatus);
            String whereClause = nsPrefix + 'Warehouse_Equipment__c = :equipmentId ';
            whereClause += ' AND ' + nsPrefix +'Contract__r.' + nsPrefix + 'Lease_Status__c in :activeStatus';
            queryBuilder.setWhereClause(whereClause);
            System.debug(logginglevel.error, 'query ' + queryBuilder.getQuery());
            String keyField = nsPrefix + 'Contract__c';
            return queryBuilder.getRecordsMap(keyField);
        } 
        return null;
    }
    
    public List<cllease__Contract_Equipment__c> getContractEquipmentForLeaseId(Id leaseId) {
        List<String> statusType = new List<String> {LendingConstants.MASTER_EQ_LEASED};
        queryBuilder.addNamedParameter('statusType', statusType);
        String whereClause = nsPrefix + 'Status__C IN :statusType';
        if(leaseId != null) {
            queryBuilder.addNamedParameter('leaseId', leaseId);
            whereClause += ' AND ' + nsPrefix + 'Contract__c =:leaseId';
        }
        queryBuilder.setWhereClause(whereClause);
        return queryBuilder.getRecords();
    }

    // Utility method to get Collateral Ids for corresponding Contract Equpment Ids
    public Set<Id> getCollaterIdsForEquipmentIds(Set<Id> contractEquipmentIds) {
        Set<Id> collateraIds = new Set<Id>();
        if(contractEquipmentIds != null && contractEquipmentIds.size() > 0) {
            queryBuilder.addNamedParameter('contractEquipmentIds', contractEquipmentIds);
            String whereClause = 'Id in :contractEquipmentIds';
            queryBuilder.setWhereClause(whereClause);
            List<cllease__Contract_Equipment__c> contractEquipment = queryBuilder.getRecords();

            for (cllease__Contract_Equipment__c cep : contractEquipment) {
                collateraIds.add(cep.cllease__Warehouse_Equipment__c);
            }
        }
        return collateraIds;
    }

}