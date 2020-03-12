public class EquipmentDomainObject {

	List<Cllease__Contract_Equipment__c> equipments;
	List<clcommon__Equipment_Detail__c> equipmentDetails;
	List<clcommon__Collateral__c> collaterals;
	Map<Id, Cllease__Contract_Equipment__c> collateralIdToEquipMap;
	Map<Id, clcommon__Equipment_Detail__c> collateralIdToEqDetailMap;
	Map<Id, Decimal> equipmentIdToCost;
	Cllease__Lease_Account__c lsContract;

	public EquipmentDomainObject(Cllease__Lease_Account__c lsContract, Set<Id> equipmentIds, Boolean equipmentLevel) {
		this.lsContract = lsContract;
		equipments = new List<Cllease__Contract_Equipment__c>();
		equipmentIdToCost = new Map<Id, Decimal>();
		equipmentDetails = new List<clcommon__Equipment_Detail__c>();
		if(equipmentLevel){
			System.debug(LoggingLevel.ERROR, 'Equipment Ids sent ' + equipmentIds);
			List<Cllease__Contract_Equipment__c> allEquipments = [SELECT Id,
                                                        Cllease__Warehouse_Equipment__c,
                                                        Cllease__Depreciation_Basis__c,
                                                        Cllease__Generate_Book_Depreciation__c, 
                                                        Cllease__Equipment_Calculated_Cost__c,
                                                        Cllease__Estimated_Selling_Price__c,
														 (SELECT Id FROM Cllease__Equipment_Details__r)
														 FROM Cllease__Contract_Equipment__c 
							  							 WHERE Id in :equipmentIds];
			for(Cllease__Contract_Equipment__c equipment : allEquipments){
				if(equipment.Cllease__Warehouse_Equipment__c != null){ 
					System.debug(LoggingLevel.ERROR, 'No Equipment Details');
					this.equipments.add(equipment);
					this.equipmentIdToCost.put(equipment.Id, getEqpCost(equipment));
				} else{
					System.debug(LoggingLevel.ERROR, 'Equipment details exist for this equip');
					for(clcommon__Equipment_Detail__c eqpDtl : equipment.Cllease__Equipment_Details__r){
						this.equipmentDetails.add(eqpDtl);
					}
				}
			}
		}
		// Commenting code for Equipment Unit level Termination
		/*else{
			System.debug(LoggingLevel.ERROR, 'Equipment Detail Ids sent');
			this.equipmentDetails = [SELECT Id FROM clcommon__Equipment_Detail__c
					 				 WHERE Id in :equipmentIds];
		}*/
	}

    /**
     * Common function to get the Equipment Cost 
    **/
    private Decimal getEqpCost(Cllease__Contract_Equipment__c equipment) {
        Decimal eqpCost;
        if (equipment.Cllease__Equipment_Calculated_Cost__c != null) 
            eqpCost = equipment.Cllease__Equipment_Calculated_Cost__c;
        else if (equipment.Cllease__Estimated_Selling_Price__c != null)
            eqpCost = equipment.Cllease__Estimated_Selling_Price__c;
        else
            eqpCost = 0;
        return eqpCost;
    }

	public void updateWarehouseDtls(String status, Date effectiveDate){
		System.debug(LoggingLevel.ERROR, 'Came in updateCollateralDtls ' + effectiveDate);
		Date nextDepdate = effectiveDate.addmonths(1).toStartofMonth().addDays(-1);

		Set<Id> collateralids = new Set<Id>();
		if(equipments.size() > 0){
			collateralIdToEquipMap = new Map<Id, Cllease__Contract_Equipment__c>();
			for(Cllease__Contract_Equipment__c equip : equipments){
				collateralids.add(equip.Cllease__Warehouse_Equipment__c);
				collateralIdToEquipMap.put(equip.Cllease__Warehouse_Equipment__c, equip);
			}
		}

		if(collateralids.size() > 0){
			collaterals = [SELECT Id, Name, 
                            Cllease__In_Partial_Contract__c,
						   clcommon__Status__c,
						   clcommon__Equipment_NBV__c,
						   clcommon__Next_Depreciation_Date__c,
						   clcommon__depreciation_start_Date__c,
						   (SELECT Id, Name, clcommon__Date__c, 
						   clcommon__Ending_Net_Book_Value__c
						    FROM clcommon__Depreciation_Streams__r)
						   FROM clcommon__Collateral__c
						   WHERE Id in :collateralids];
			List<clcommon__Depreciation_Stream__c> depStreams = new List<clcommon__Depreciation_Stream__c>();
	    	for(clcommon__Collateral__c collateral : collaterals){
	    		collateral.clcommon__Next_Depreciation_Date__c = nextDepdate;
	    		collateral.Cllease__In_Partial_Contract__c = false;
				if(status.equals(LendingConstants.MASTER_EQ_RETURNED) ||
					status.equals(LendingConstants.TERMINATION_QUOTE_TYPE_WITHOUT_PURCHASE)){
					collateral.clcommon__Status__c = clcommon.Constants.COLLATERAL_STATUS_WAREHOUSE;
				}else if(status.equals(LendingConstants.MASTER_EQ_SOLD) || 
					status.equals(LendingConstants.TERMINATION_QUOTE_TYPE_WITH_PURCHASE)) {
					collateral.clcommon__Status__c = 'Sold';
				}
	    		if(collateralIdToEquipMap.containsKey(collateral.id)){
					Cllease__Contract_Equipment__c equipment = collateralIdToEquipMap.get(collateral.id);
					if(equipment.Cllease__Generate_Book_Depreciation__c){
						for(clcommon__Depreciation_Stream__c stream : collateral.clcommon__Depreciation_Streams__r) {
							if(stream.clcommon__Date__c >= effectiveDate) {
								depStreams.add(stream);
							}
							if(stream.clcommon__Date__c < effectiveDate) {
								collateral.clcommon__Equipment_NBV__c = stream.clcommon__Ending_Net_Book_Value__c;
							}
						}
	    			}
	    		}
	    	}
	    	delete depStreams;
	    	update collaterals;
	    }
	}
}