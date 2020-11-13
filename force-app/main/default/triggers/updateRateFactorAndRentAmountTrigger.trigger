trigger updateRateFactorAndRentAmountTrigger on genesis__Application_Pricing_Detail__c (after insert) {
	genesis__Application_Pricing_Detail__c appPricingDetail = trigger.new[0];
    String updated = CLVendorPoint.updatePricingDetail(appPricingDetail.id);
    appPricingDetail.adderror(updated);
}