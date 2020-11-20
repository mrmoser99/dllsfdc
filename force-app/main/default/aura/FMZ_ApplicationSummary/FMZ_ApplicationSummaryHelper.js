({
  getApplicationInfo: function(component, showUpdate) {
    let action = component.get("c.getApplicationInfo");
    action.setParams({
      applicationId: component.get("v.applicationId")
    });
    action.setCallback(this, function(response) {
      let state = response.getState();
      component.set("v.recalculating", false);
      if (state === "SUCCESS") {
        var application = response.getReturnValue();
          console.log('app info is: ' + JSON.stringify(application));
          if(application.Oracle_Trade_up_Quote_Number__c){
              application.Oracle_Trade_up_Quote_Number__c_Display = application.Oracle_Trade_up_Quote_Number__c.split(
                  "TU"
                )[1];
          }
        
        component.set("v.application", application);
        if (application.Oracle_Trade_up_Quote_Expiration_Date__c &&
          application.Oracle_Trade_up_Quote_Expiration_Date__c <
          $A.localizationService.formatDate(new Date(), "YYYY-MM-DD")
        ) {
          component.find("notifLib").showToast({
            title: "Trade up quote expired, please re-quote the application!",
            variant: "warning",
            showCloseButton: true
          });
        }
        if (showUpdate) {
          $A.util.addClass(component, "new-item");
        }
      }
    });
    $A.util.removeClass(component, "new-item");
    $A.enqueueAction(action);
  },
  getApprovalInfo: function(component, showUpdate) {
    let action = component.get("c.getApprovalInfo");
    action.setParams({
      applicationId: component.get("v.applicationId")
    });
    action.setCallback(this, function(response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        var approval = response.getReturnValue();
        component.set("v.approval", approval);
      }
    });
    $A.enqueueAction(action);
  },
  getLocations: function(component) {
    let action = component.get("c.getInstallLocations");
    action.setParams({
      applicationId: component.get("v.applicationId")
    });
    action.setCallback(this, function(response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        var locations = response.getReturnValue();
        component.set("v.locations", locations);
      }
    });
    $A.enqueueAction(action);

    let billAction = component.get("c.getBillingAddress");
    billAction.setParams({
      applicationId: component.get("v.applicationId")
    });
    billAction.setCallback(this, function(response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        var billing = response.getReturnValue();
        component.set("v.billing", billing);
      }
    });
    $A.enqueueAction(billAction);
  },
  handleShowQuoteModule: function(component) {
    let modalBody;
    var leaseNumber = component.get(
      "v.application.Oracle_Trade_up_Lease_Number__c"
    );
    console.log("In helper with lease number " + leaseNumber);
    $A.createComponent(
      "c:FMZ_TradeUpQuote",
      { leaseNumber: leaseNumber },
      function(content, status, errorMessage) {
        console.log("!!! STATUS: " + status);
        if (status === "SUCCESS") {
          console.log("IN SUCCESS");
          modalBody = content;
          component.find("overlayLib").showCustomModal({
            body: modalBody,
            showCloseButton: true,
            cssClass: "mymodal",
            closeCallback: function() {}
          });
        } else if (status === "ERROR") {
          let toast = $A.get("e.force:showToast");
          toast.setParams({
            title: "Error",
            message: errorMessage,
            type: "error"
          });
          toast.fire();
        }
      }
    );
  }
});