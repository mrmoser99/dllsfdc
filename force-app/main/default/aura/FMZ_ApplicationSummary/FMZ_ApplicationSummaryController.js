({
  onInit: function(component, event, helper) {
    helper.getApplicationInfo(component, false);
    helper.getApprovalInfo(component);
    helper.getLocations(component);
  },
  updateView: function(component, event, helper) {
    helper.getApplicationInfo(component, true);
    helper.getLocations(component);
  },
  quoteModuleHandler: function(component, event, helper) {
    component.get("v.applicationId");
    component.get("v.Oracle_Trade_up_Quote_Number__c");
    component.get("v.Oracle_Trade_up_Quote_Amount__c");
    component.set("v.isQuoteModuleVisible", true);
  },
  closeModal: function(component, event, helper) {
    component.set("v.isQuoteModuleVisible", false);
  }
});