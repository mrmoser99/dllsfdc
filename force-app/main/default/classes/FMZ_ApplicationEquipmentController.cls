/**********************************************************************************************************************
 * 
 * 
 * Change Log:
 *  
 *  3/11/2020 - MRM - added upfront tax to display on this page
 * 
 * 
 * 
 */

public without sharing class FMZ_ApplicationEquipmentController {

    @AuraEnabled
    public static List<genesis__Application_Equipment__c> getEquipment(Id applicationId) {

        List<genesis__Application_Equipment__c> result =
            [SELECT Id, genesis__Equipment__c, genesis__Equipment__r.Manufacturer__c,
                    genesis__Equipment__r.genesis__Model__c,
                    Serial_Number__c, genesis__Equipment__r.MSRP__c,
                    Product_Type1__c, genesis__Estimated_Selling_Price__c, Manufacturer__c,
                    Install_Address1__c, Tax_Exempt__c, Installation_Date__c, genesis__Application__r.Trade_Up_Quote__c,
                    Oracle_Trade_Up_Amount__c, Upfront_Tax_Amount__c, genesis__tax_amount__c
            FROM genesis__Application_Equipment__c
            WHERE genesis__Application__c = :applicationId
            ORDER BY CreatedDate];

        return result;

    }

    private final static Integer MAX_RESULTS = 5;

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds) {

        searchTerm = '*' + searchTerm + '*';

        // Execute search query
        List<List<SObject>> searchResults = [
                FIND :searchTerm
                IN ALL FIELDS
                        RETURNING
                        genesis__Equipment_Master__c (Id, Manufacturer__c, genesis__Model__c, Product_Type__c, MSRP__c)
                LIMIT :MAX_RESULTS
        ];

        List<LookupSearchResult> results = new List<LookupSearchResult>();

        String equipmentIcon = 'standard:quotes';
        genesis__Equipment_Master__c [] equipment = ((List<genesis__Equipment_Master__c>) searchResults[0]);
        for (genesis__Equipment_Master__c e : equipment) {
            results.add(new LookupSearchResult(
                    e.Id, 'genesis__Equipment_Master__c', equipmentIcon,
                    e.Manufacturer__c + ' ' + e.genesis__Model__c, e.Product_Type__c + ' • MRSP: $' + e.MSRP__c.format()));
        }

        return results;

    }

    @AuraEnabled
    public static void calcUpfrontTax(String applicationId) {
    
        genesis__Applications__c a = [select name FROM genesis__Applications__c where id = :applicationId];

        VertexUpfrontTaxCalculation.VertexGetUpfrontTax(a.name);
        
    }

    

    @AuraEnabled
    public static void addEquipment(String applicationId, String equipmentId) {

        genesis__Applications__c app =
            [SELECT Id, genesis__Account__c FROM genesis__Applications__c
            WHERE Id = :applicationId];

        // default address to the first address
        List<Address__c> installLocations =
            [SELECT Id
            FROM Address__c
            WHERE Account__c = :app.genesis__Account__c
            AND Install_At__c = TRUE
            LIMIT 1];

        genesis__Application_Equipment__c equipment = new genesis__Application_Equipment__c (
            genesis__Application__c = applicationId,
            genesis__Equipment__c = equipmentId,
            Install_Account__c = app.genesis__Account__c
        );

        if (!installLocations.isEmpty()) {
            equipment.Install_Address1__c = installLocations[0].Id;
        }

        insert equipment;

        

    }

    @AuraEnabled
    public static void deleteEquipment(String appEquipmentId) {

        genesis__Application_Equipment__c equipment =
            new genesis__Application_Equipment__c( Id = appEquipmentId );

        delete equipment;

        

    }

    @AuraEnabled
    public static void updateEquipment(String equipmentString) {

        genesis__Application_Equipment__c equipment =
                (genesis__Application_Equipment__c)JSON.deserialize(equipmentString, genesis__Application_Equipment__c.class);

        update equipment;

       

    }

    @AuraEnabled
    public static List<Address__c> getInstallationAddresses(Id applicationId) {

        genesis__Applications__c app =
            [SELECT Id, genesis__Account__c FROM genesis__Applications__c
            WHERE Id = :applicationId];

        List<Address__c> result =
            [SELECT Id, Address_Line_1__c, City__c, State__c
            FROM Address__c
            WHERE Account__c = :app.genesis__Account__c
            AND Install_At__c = TRUE];

        return result;

    }

}