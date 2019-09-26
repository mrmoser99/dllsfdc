public without sharing class FMZ_ApplicationTermsController {

    @AuraEnabled
    public static List<Decimal> getTermOptions(String applicationId){
        List<Decimal> termOptions = new List<Decimal>();
        Set<Decimal> termSet = new Set<Decimal>();

        List<genesis__Product_Rate_Card_Association__c> rcAssociations = [
            SELECT genesis__Rate_Card_Setup__c
            FROM genesis__Product_Rate_Card_Association__c
            WHERE genesis__CL_Product__c IN (
                SELECT genesis__CL_Product__c
                FROM genesis__Applications__c
                WHERE Id =: applicationId
            )
        ];

        Set<Id> rcIds = new Set<Id>();
        for(genesis__Product_Rate_Card_Association__c rca : rcAssociations){
            rcIds.add(rca.genesis__Rate_Card_Setup__c);
        }

        List<genesis__Rate_Card_Setup_Detail__c> rcDetails = [
            SELECT Id, Name, genesis__Term__c
            FROM genesis__Rate_Card_Setup_Detail__c
            WHERE genesis__Enabled_Flag__c = true
            AND genesis__Rate_Card_Setup_Header__c IN (
                SELECT Id
                FROM genesis__Rate_Card_Setup_Header__c
                WHERE Id IN: rcIds
                    AND genesis__Enabled_Flag__c = true
            )
            ORDER BY genesis__Term__c
        ];

        for(genesis__Rate_Card_Setup_Detail__c rcDetail : rcDetails) {
            termSet.add(rcDetail.genesis__Term__c);
        }

        List<Decimal> oldOptions = new List<Decimal>(termSet);

        for(Integer i = 0; i < oldOptions.size(); i++){
            Integer term = (Integer) oldOptions[i];
            if(math.mod((Integer) term, 12) == 0){
                termOptions.add(oldOptions[i]);
            }
        }

        return termOptions;
    }

    @AuraEnabled
    public static genesis__Applications__c getApplicationTerms(Id applicationId) {

        genesis__Applications__c result =
            [SELECT Id, genesis__Term__c, Rate_Card_Selection__c,
                    genesis__Payment_Frequency__c
            FROM genesis__Applications__c
            WHERE Id = :applicationId];

        return result;

    }

    @AuraEnabled
    public static void updateApplicationTerms(String applicationString) {

        genesis__Applications__c applications =
                (genesis__Applications__c)JSON.deserialize(applicationString, genesis__Applications__c.class);

        update applications;

    }

}