/*
 Change Log:

 08/24/2020 - MRM - Made it work from account
*/
({
  doInit: function(component, event, helper) {
    

    var recordId = component.get("v.recordId");
    var tradeUpDetails = component.get("v.tradeUpDetails");
    if (recordId) {
      var action = component.get("c.getAccountId");
      action.setParams({
        recordId: recordId
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var accId = response.getReturnValue();
          component.set("v.accountId", accId);
          component.set("v.newAccount", false);
          helper.loadFields(component, helper);
          helper.loadDealerId(component);
        }
      });
      $A.enqueueAction(action);
    } else if (tradeUpDetails) {
      var action = component.get("c.checkCustomerName");
      action.setParams({
        customerName: tradeUpDetails.leaseDetails.customerName
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var accId = response.getReturnValue();
          if (accId != null && accId != "") {
            component.set("v.accountId", accId);
            component.set("v.newAccount", true);
          } else {
            component.set("v.newAccount", true);
          }
          helper.loadFields(component, helper);
          helper.loadDealerId(component);
        }
      });
      $A.enqueueAction(action);
    } else {
      helper.loadFields(component, helper);
      helper.loadDealerId(component);
    }
  },
  findMatchingAddresses: function(component, event, helper) {
    helper.helpFindMatchingAddress(component);
  },
  selectMatch: function(component, event, helper) {
    component.set("v.processing", true);
    var cmpTarget = component.find("matchesOverlay");
    $A.util.addClass(cmpTarget, "no-display");
    var ctarget = event.currentTarget;
    var formatUrl = ctarget.dataset.value;

    var action = component.get("c.getFormat");
    action.setParams({
      formatUrl: formatUrl
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var formattedAddress = response.getReturnValue();
        helper.populateAddressFields(component, formattedAddress);
      }
      component.set("v.processing", false);
    });
    $A.enqueueAction(action);
  },
  doneLoading: function(component, event, helper) {
    var accountId = component.get("v.accountId");
    if (accountId) {
      if (Array.isArray(accountId)) {
        component.set("v.accountId", accountId[0]);
      }
      helper.prepopulateAccountInfo(component, helper);
    }
    component.set("v.processing", false);
  },
  handleLoad: function(component, event, helper) {
    $A.util.addClass(component, "is-loaded");
  },
  handleSubmit: function(component, event, helper) {
    console.log('clicked create');
    var fields = event.getParam("fields");
    var accountId = component.get("v.accountId");
    var dealerId = component.get("v.dealerId");
    console.log('here31a');
    var isValid = helper.isValid(component);
    console.log('here3b');
    var recordId = component.get("v.recordId");
    var account = component.get("v.account");

    var tradeUpDetails = component.get("v.tradeUpDetails");
    if (tradeUpDetails) {
      fields["Oracle_Trade_up_Lease_Number__c"] = tradeUpDetails.leaseNumber;
      fields["Oracle_Trade_Up_Quote_Amount__c"] = tradeUpDetails.quoteAmount;
      fields["Oracle_Trade_up_Quote_Number__c"] = tradeUpDetails.quoteNumber;
      fields["Oracle_Trade_up_Quote_Expiration_Date__c"] =
        tradeUpDetails.expirationDate;
    }
    console.log('here31');
    fields["Primary_Phone_number__c"] = fields[
      "Primary_Phone_number__c"
    ].replace(/(\(|\)| |-)/g, "");
    fields["genesis__Address_Line_1__c"] = component
      .find("addressLine1")
      .get("v.value");
    fields["genesis__City__c"] = component.find("city").get("v.value");
    fields["County__c"] = component.find("county").get("v.value");
    fields["genesis__State__c"] = component.find("state").get("v.value");
    fields["genesis__Postal_Code__c"] = component
      .find("postalCode")
      .get("v.value");
    fields["genesis__Country__c"] = "USA";
    fields["Validation_Status__c"] = component
      .find("validStatus")
      .get("v.value");
    fields["Validation_Time_Stamp__c"] = component
      .find("validTime")
      .get("v.value");
    fields["genesis__Account__c"] = accountId;
    fields["Dealer__c"] = dealerId;
    console.log('here4');
    if (account && account.Name) {
      fields["genesis__Business_Name__c"] = account.Name;
    }
    console.log('here13today');
    component.set("v.isInvalid", !isValid);
    console.log(component.get("v.isInvalid"));
    //if (!isValid(component)) {
    //  console.log('not valid');
    //  return;
    //}
    console.log('here3');
    var action = component.get("c.createRecords");
    action.setParams({
      qq: fields,
      ignoreDuplicates: false
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      console.log('here11');
      if (state === "SUCCESS") {
        console.log('here1');
        var createResponse = response.getReturnValue();
        console.log(createResponse);
        if (createResponse.status == "SUCCESS") {
          console.log('here2');
          helper.submitForApproval(component, createResponse.message);
        } else {
          let modalBody;
          console.log('here5');
          $A.createComponent(
            "c:FMZ_SelectDuplicate",
            {
              selectedId: component.getReference("v.accountId"),
              message: createResponse.message,
              duplicates: createResponse.duplicates
            },
            function(content, status, errorMessage) {
              if (status === "SUCCESS") {
                modalBody = content;
                component.find("overlayLib").showCustomModal({
                  body: modalBody,
                  showCloseButton: true,
                  cssClass: "mymodal",
                  closeCallback: function() {
                    accountId = component.get("v.accountId");
                    fields["genesis__Account__c"] = accountId;
                    if (accountId) {
                      var resubmitAction = component.get("c.createRecords");
                      resubmitAction.setParams({
                        qq: fields,
                        ignoreDuplicates: true
                      });
                      resubmitAction.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                          var createResponse = response.getReturnValue();
                          if (createResponse.status == "SUCCESS") {
                            helper.submitForApproval(
                              component,
                              createResponse.message
                            );
                          }
                        } else if (state == "ERROR") {
                          component.find("notifLib").showToast({
                            variant: "error",
                            message:
                              "ERROR: An error has occurred processing your request. Try again later, or report this issue to a System Administrator.",
                            mode: "dismissible",
                            duration: "5000"
                          });
                          let dismiss = $A.get("e.force:closeQuickAction");
                          dismiss.fire();
                          component.set("v.processing", false);
                        }
                      });
                      $A.enqueueAction(resubmitAction);
                    } else {
                      component.find("notifLib").showToast({
                        variant: "error",
                        message:
                          "Please use the existing Account to create this Credit Approval",
                        mode: "dismissible",
                        duration: "5000"
                      });
                      let dismiss = $A.get("e.force:closeQuickAction");
                      dismiss.fire();
                      component.set("v.processing", false);
                    }
                  }
                });
              } else if (status === "ERROR") {
                let toast = $A.get("e.force:showToast");
                toast.setParams({
                  title: "Error",
                  message: errorMessage,
                  type: "error",
                  mode: "dismissible",
                  duration: "5000"
                });
                toast.fire();
              }
            }
          );
        }
      } else if (state === "ERROR") {
        component.find("notifLib").showToast({
          variant: "error",
          message:
            "ERROR: An error has occurred processing your request. Try again later, or report this issue to a System Administrator.",
          mode: "dismissible",
          duration: "5000"
        });
        let dismiss = $A.get("e.force:closeQuickAction");
        dismiss.fire();
        component.set("v.processing", false);
      }
    });
    component.set("v.processing", true);
    $A.enqueueAction(action);
    event.preventDefault();
  },
  lookupChange: function(component, event, helper) {
    var accountId = component.get("v.accountId");
    if (accountId) {
      if (Array.isArray(accountId)) {
        component.set("v.accountId", accountId[0]);
      }
      helper.prepopulateAccountInfo(component);
    }
  },
  handleSuccess: function(component, event, helper) {
    var record = event.getParam("response");
    helper.submitForApproval(component, record.id);
  },
  handleError: function(component, event, helper) {
    component.set("v.isInvalid", false);

    if (event.getName() === "error") {
      var error = event.getParam("error");

      console.log(error.message);

      // top level error messages
      error.data.output.errors.forEach(function(msg) {
        console.log(msg.errorCode);
        console.log(msg.message);
      });

      // field specific error messages
      Object.keys(error.data.output.fieldErrors).forEach(function(field) {
        error.data.output.fieldErrors[field].forEach(function(msg) {
          console.log(msg.fieldName);
          console.log(msg.errorCode);
          console.log(msg.message);
        });
      });
    }
  },
  handleCancel: function(component, event, helper) {
    let dismiss = $A.get("e.force:closeQuickAction");
    dismiss.fire();
  },
  toggleNewAccount: function(component, event, helper) {
    component.set("v.processing", true);
    component.set("v.newAccount", !component.get("v.newAccount"));
    var inputField = component.find("inputField");
    for (var i = 0; i < inputField.length; i++) {
      inputField[i].set("v.value", "");
      component.set("v.accountId", null);
      component.set("v.account", null);
    }

    helper.clearAddressData(component);
    component.set("v.processing", false);
  },
  showSupportHandler: function(component, event, helper) {
    component.set("v.showSupport", true);
  },
  hideSupportHandler: function(component, event, helper) {
    component.set("v.showSupport", false);
  },
  sendSupportEmail: function(component, event, helper) {
    const textBody = component.get("v.body");
    if (!textBody) return;

    const quote = JSON.parse(JSON.stringify(component.get("v.tradeUpDetails")));
    let settings = component.get("v.settings");

    const baseUrl = `${settings.URL__c}/lightning/r/Lease_OLM_Quote__c/`;

    const subject = "Quote Support";

    const body = `${textBody}
    <p> </p>
    <p>Related Quotes: </p>
    <p>${baseUrl}${quote.Id}/view</p>`;

    helper.emailSupport(component, subject, body);
    return;
  }
});