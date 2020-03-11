public without sharing class FMZ_ApplicationSummaryController {

    @AuraEnabled
    public static genesis__Applications__c getApplicationInfo(String applicationId) {

        genesis__Applications__c app =
            [SELECT Id, genesis__Account__r.Name, No_of_Equipments__c, genesis__Expected_First_Payment_Date__c,
                    Total_Estimated_Property_Tax__c, /*Pre_Upfront_Tax_Payment_Amount1__c,*/ Name, Net_Dealer_Funding__c,
                    Service_Fee__c, Total_Lease_Payment__c, Total_Insurance_Fees__c, genesis__Payment_Amount__c,
                    genesis__Term__c, Rate_Card_Selection__c, genesis__Financed_Amount__c, genesis__Other_Financed_fees__c,
                    genesis__Payment_Frequency__c, Pricing_Rate_Factor__c, genesis__Status__c, Oracle_Trade_Up_Amount__c,
                    Oracle_Trade_up_Lease_Number__c, Oracle_Trade_up_Quote_Number__c, Oracle_Trade_up_Quote_Expiration_Date__c, Trade_Up_Quote__c, genesis__tax_amount__c
            FROM genesis__Applications__c
            WHERE Id = :applicationId];

        return app;

    }

    @AuraEnabled
    public static genesis__Quick_Quotes__c getApprovalInfo(String applicationId) {

        genesis__Quick_Quotes__c approval =
        [SELECT Id, Estimated_Financed_Amount__c
        FROM genesis__Quick_Quotes__c
        WHERE genesis__Application__c = :applicationId];

        return approval;

    }

    @AuraEnabled
    public static List<Address__c> getInstallLocations(Id applicationId) {

        genesis__Applications__c app =
        [SELECT Id, genesis__Account__c FROM genesis__Applications__c
        WHERE Id = :applicationId];

        List<Address__c> result =
        [SELECT Id, Address_Line_1__c, City__c, State__c, Zip_Code__c, County__c, Install_At__c
        FROM Address__c
        WHERE Id IN
        (SELECT Install_Address1__c
        FROM genesis__Application_Equipment__c
        WHERE genesis__Application__c = :applicationId)];

        return result;

    }

    @AuraEnabled
    public static Address__c getBillingAddress(Id applicationId) {

        genesis__Applications__c app = [
                SELECT Id, genesis__Account__c, Billing_Address1__r.Address_Line_1__c, Billing_Address1__r.City__c,
                    Billing_Address1__r.State__c, Billing_Address1__r.Zip_Code__c, Billing_Address1__r.County__c,
                    Billing_Address1__r.Email_Address__c
                FROM genesis__Applications__c
                WHERE Id = :applicationId
        ];

        return new Address__c(
                Id = app.Billing_Address1__c,
                Email_Address__c = app.Billing_Address1__r.Email_Address__c,
                Address_Line_1__c = app.Billing_Address1__r.Address_Line_1__c,
                City__c = app.Billing_Address1__r.City__c,
                State__c = app.Billing_Address1__r.State__c,
                Zip_Code__c = app.Billing_Address1__r.Zip_Code__c,
                County__c = app.Billing_Address1__r.County__c
        );

    }

}