/***********************************************************************************************************************************
 * 
 * Change Log:

  1/29/2020 - MRM Allow all Terms from Rate Card


 *******************************************************************************************************************************/ 
public without sharing class FMZ_ApplicationTermsController {


    @AuraEnabled
    public static String getDealer(String applicationId){
        
         

        genesis__Applications__c a = [select Dealer__c 
                            from  genesis__Applications__c 
                            where id = :applicationId
        ];

        return a.dealer__c;
    
    }

    @AuraEnabled
    public static List<Map<String,String>> getRateCards(String dealerId){
        
        LIst<Map<String,String>> cards = new List<Map<String,String>>();

        List<clcommon__CL_Product__c> pList = 
                [ select id
                , Rate_Card_Setup__r.name
                , dealer__c
                from clcommon__CL_Product__c
                where   (dealer__c = :dealerId and active__c = true and (Rate_Card_Setup__r.genesis__Start_Date__c <= :Date.today() and Rate_Card_Setup__r.genesis__End_Date__c >= :date.today() )  )
                   or  (dealer__c = :dealerId and active__c = true and (Rate_Card_Setup__r.genesis__Start_Date__c <= :Date.today() and Rate_Card_Setup__r.grandfather_date__c >= :date.today() ) )
                   or  (clcommon__Product_Name__c = 'Finance Lease' and dealer__c = null)
                order by dealer__c asc
                ]; 
        for (clcommon__CL_Product__c p:pList){
            if (p.dealer__c == null)
                cards.add(new Map<String, String>{'value' => p.Rate_Card_Setup__c, 'label' => 'Fair Market Value-ASTRA'});
            else
                cards.add(new Map<String, String>{'value' => p.Rate_Card_Setup__c, 'label' => p.Rate_Card_Setup__r.name});

        }

        return cards;

    }
     
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
            //if(math.mod((Integer) term, 12) == 0){
                termOptions.add(oldOptions[i]);
            //}
        }

        return termOptions;
    }

    

    @AuraEnabled
    public static genesis__Applications__c getApplicationTerms(Id applicationId) {

        genesis__Applications__c result =
            [SELECT Id, genesis__Term__c, Rate_Card_Selection__c, rate_card_setup__c,
                    genesis__Payment_Frequency__c
            FROM genesis__Applications__c
            WHERE Id = :applicationId];
        
        return result;

    }

    @AuraEnabled
    public static void updateApplicationRateCard(String applicationString, String rateCardId) {

        genesis__Applications__c applications =
                (genesis__Applications__c)JSON.deserialize(applicationString, genesis__Applications__c.class);

        system.debug('applications:' + applications);

        list<genesis__Rate_Card_Setup_Header__c> pList = new List<genesis__Rate_Card_Setup_Header__c>();
        clcommon__CL_Product__c p;
        
        p =  [select id from clcommon__CL_Product__c where dealer__c = null limit 1]; 

        cllease__Lease_Product__c lp =  [select id 
                                        from cllease__Lease_Product__c
                                        where cllease__CL_Product__c = :p.id
                                        ];
        
        if (rateCardId == 'Fair Market Value-ASTRA'){
            applications.rate_card_setup__c = null;
        }
        else{
            pList = [select CL_Product__c from genesis__Rate_Card_Setup_Header__c where id = :rateCardId];
            applications.rate_card_setup__c = rateCardid;
        }
        if (pList.size() == 0)
            applications.genesis__CL_Product__c = p.id;
        else
            applications.genesis__CL_Product__c = pList[0].CL_Product__c;

        system.debug('product is ' + applications.genesis__CL_Product__c);

        applications.Lease_Product_Name__c = lp.id;

        update applications;

    }

    @AuraEnabled
    public static void updateApplicationTerms(String applicationString) {

        genesis__Applications__c applications =
                (genesis__Applications__c)JSON.deserialize(applicationString, genesis__Applications__c.class);

        update applications;

    }

}