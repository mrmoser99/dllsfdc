/** 
 *   Following class will be called from Process builder to update the Equipment values to 
 *   copy  "" --> "" on Application Pricing generated.
 * */
public with sharing class UpdateEquipmentValues {
    @InvocableMethod(label='UpdateEquipmentValues' 
    description='Following method helps in updating Equipment other financed fee from oracle tradeup amount')
    public static void updateEquipmentDetail(List<ID> equipmentIds) {
        if(equipmentIds == null || equipmentIds.size() == 0) {
            // throw exception incase of EquipmentIds null
            throw new CLSCustomException('equipmentIds are not valid. Please provide valid application IDs');
        }
        
        // 1. Query application with Equipments for details to copy
        List<genesis__Application_Equipment__c> applicationEquipmentList = [SELECT Id, Name, genesis__Other_Financed_Fees__c, Oracle_Trade_Up_Amount__c
                                                                            FROM genesis__Application_Equipment__c
                                                                            WHERE Id IN :equipmentIds];
    
        List<genesis__Application_Equipment__c> equipmentsToUpdate = new List<genesis__Application_Equipment__c>();
        // 2. loop through applications
        for(genesis__Application_Equipment__c equipment : applicationEquipmentList) {
            equipment.genesis__Other_Financed_Fees__c = equipment.Oracle_Trade_Up_Amount__c;
            equipmentsToUpdate.add(equipment);
        }
        // 3  update Equipments after processing
        if(equipmentsToUpdate.size() > 0) {
            update equipmentsToUpdate;
        }
    }
}