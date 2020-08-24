({
  // load fields from the field set
  /*
 Change Log:

 08/24/2020 - MRM - Made it work from account
*/
  loadFields: function(component, helper) {
    var action = component.get("c.getQQFields");
    action.setParams({
      fieldsetName: "FMZ_NewQuickQuote"
    });
    action.setStorable();
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.fields", response.getReturnValue());
        var tradeUpDetails = component.get("v.tradeUpDetails");
        if (component.get("v.accountId")) {
          this.prepopulateAccountInfo(component, helper);
          if (tradeUpDetails) {
            this.prepopulateField(
              component,
              "genesis__Business_Name__c",
              tradeUpDetails.leaseDetails.customerName
            );
          }
        } else if (tradeUpDetails) {
          this.prepopulateField(
            component,
            "genesis__Business_Name__c",
            tradeUpDetails.leaseDetails.customerName
          );
          component
            .find("addressLine1")
            .set(
              "v.value",
              tradeUpDetails.leaseDetails.customerAddressLine1 || ""
            );
          component
            .find("city")
            .set("v.value", tradeUpDetails.leaseDetails.customerCity || "");
          component.find("county").set("v.value", "");
          component
            .find("state")
            .set("v.value", tradeUpDetails.leaseDetails.customerState || "");
          component
            .find("postalCode")
            .set("v.value", tradeUpDetails.leaseDetails.customerZipCode || "");

          helper.helpFindMatchingAddress(component);
        }
        component.set("v.processing", false);
      }
    });

    //component.set('v.processing', true);

    $A.enqueueAction(action);
  },
  // load accountid for the dealer user
  loadDealerId: function(component) {
    var action = component.get("c.getDealerAccount");
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.dealerId", response.getReturnValue());
      }
    });
    $A.enqueueAction(action);
  },

  // submit for credit approval
  submitForApproval: function(component, qqId) {
    console.log("!!!SubmittingForApproval: " + qqId);
    var action = component.get("c.submitForApproval");
    action.setParams({
      qqId: qqId
    });
    action.setCallback(this, function(response) {
      console.log("Callback");
      var state = response.getState();
      console.log("STATE: " + state);
      if (state === "SUCCESS") {
        var result = response.getReturnValue();
        console.log(result);
        if (
          Boolean(result) &&
          (result.indexOf("success") != -1 || result.indexOf("Submitted"))
        ) {
          this.showToast(
            component,
            "success",
            "Your credit approval was submitted.  {0} to view the credit approval record.",
            "Click here",
            qqId
          );
        } else {
          this.showToast(
            component,
            "error",
            "An error occurred. " +
              (result || "") +
              " {0} to view the credit approval record.",
            "Click here",
            qqId
          );
        }
        let dismiss = $A.get("e.force:closeQuickAction");
        dismiss.fire();
        component.set("v.processing", false);
      } else if (state === "ERROR") {
        console.log(response.getError());
        this.showToast(
          component,
          "error",
          "An error occurred. " +
            (response.getError() || "") +
            " {0} to view the credit approval record.",
          "Click here",
          qqId
        );
        let dismiss = $A.get("e.force:closeQuickAction");
        dismiss.fire();
        component.set("v.processing", false);
      }
    });
    component.set("v.processing", true);
    console.log("!!!About to Enqueue");
    $A.enqueueAction(action);
  },

  clearAddressData: function(component) {
    component.find("addressLine1").set("v.value", "");
    component.find("city").set("v.value", "");
    component.find("county").set("v.value", "");
    component.find("state").set("v.value", "");
    component.find("postalCode").set("v.value", "");
    component.find("validStatus").set("v.value", "");
    component.find("validTime").set("v.value", "");
  },

  // get account info to prepopulate the quick quote
  prepopulateAccountInfo: function(component, helper) {
    var action = component.get("c.getAccountInfo");
    console.log(component.get("v.accountId"));
    action.setParams({
      accountId: component.get("v.accountId")
    });
    action.setCallback(this, function(response) {
      console.log("Callback!");
      var state = response.getState(),
        recordId = component.get("v.recordId");
      component.set("v.processing", false);
      if (state === "SUCCESS") {
        console.log("Success!!!");
        var account = response.getReturnValue();
        component.set("v.account", account);
        if (recordId) {
          this.prepopulateField(
            component,
            "genesis__Business_Name__c",
            account.Name
          );
        }
        this.prepopulateField(
          component,
          "Primary_Phone_number__c",
          account.Phone
        );
        console.log(account.Phone);
        this.prepopulateField(
          component,
          "Email_Address__c",
          account.Email_Address__c
        );
        if (account.Primary_Address__r) {
          console.log("Populatng Address Fields");
          component
            .find("addressLine1")
            .set("v.value", account.Primary_Address__r.Address_Line_1__c || "");
          component
            .find("city")
            .set("v.value", account.Primary_Address__r.City__c || "");
          component
            .find("county")
            .set("v.value", account.Primary_Address__r.County__c || "");
          component
            .find("state")
            .set("v.value", account.Primary_Address__r.State__c || "");
          component
            .find("postalCode")
            .set("v.value", account.Primary_Address__r.Zip_Code__c || "");
          component
            .find("validStatus")
            .set(
              "v.value",
              account.Primary_Address__r.Validation_Status__c || ""
            );
          component
            .find("validTime")
            .set(
              "v.value",
              account.Primary_Address__r.Validation_Time_Stamp__c || ""
            );
        }
        component.set("v.accountId", account.Id);
        this.prepopulateField(component, "genesis__Account__c", account.Id);
      }
    });
    $A.enqueueAction(action);
  },

  // set the value of inputField based on field set position
  prepopulateField: function(component, fieldName, value) {
    var inputField = component.find("inputField"),
      inputFieldPhone = component.find("inputFieldPhone"),
      inputAccountName = component.find("inputFieldAccountId");
    if (inputField) {
      if (!Array.isArray(inputField)) {
        inputField = [inputField, inputFieldPhone, inputAccountName];
      } else {
        inputField.push(inputFieldPhone);
        inputField.push(inputAccountName);
      }
    }
    for (var i = 0; i < inputField.length; i++) {
      console.log(inputField[i].get("v.fieldName"));
      if (fieldName == inputField[i].get("v.fieldName")) {
        inputField[i].set("v.value", value);
        break;
      }
    }
  },

  // check for required fields
  isValid: function(component) {
      console.log('checking is valid');
      var result = true,
      fields = component.get("v.fields"),
      inputField = component.find("inputField"),
      inputFieldPhone = component.find("inputFieldPhone"),
      inputFieldFinance = component.find("inputFieldFinance");

    /*
    if (component.get("v.newAccount")) {
      var inputAccountId = component.find("inputFieldAccountId");
      if (
        !inputAccountId.get("v.value") ||
        inputAccountId.get("v.value") == ""
      ) {
        $A.util.addClass(inputAccountId, "slds-has-error");
        result = false;
      }
    } else {
      var inputAccountName = component.find("inputFieldAccountName");
      if (
        !inputAccountName.get("v.value") ||
        inputAccountName.get("v.value") == ""
      ) {
        $A.util.addClass(inputAccountName, "slds-has-error");
        result = false;
      }
    }
    */

    if (inputField) {
      if (!Array.isArray(inputField)) {
        inputField = [inputField, inputFieldPhone, inputFieldFinance];
      } else {
        inputField.push(inputFieldPhone);
        inputField.push(inputFieldFinance);
      }
    }
    var phoneValue = inputFieldPhone.get("v.value").replace(/(\(|\)| |-)/g, "");
    var regularExpression;
    var re = new RegExp("[1-9]{1}[0-9]{9}");
    console.log("REGEXP PHONE: " + !re.test(phoneValue));
    if (!re.test(phoneValue) || phoneValue.length != 10) {
      component.set("v.invalidFormatPhone", true);
      $A.util.addClass(inputFieldPhone, "slds-has-error");
      result = false;
    }
    if (
      !inputFieldFinance.get("v.value") ||
      inputFieldFinance.get("v.value") == ""
    ) {
      $A.util.addClass(inputFieldFinance, "slds-has-error");
      result = false;
    }
    var requiredByFieldPath = [];
    for (var i = 0; i < fields.length; i++) {
      requiredByFieldPath[fields[i].fieldPath] = fields[i].required;
    }
    for (var j = 0; i < inputField.length; i++) {
      if (
        requiredByFieldPath[inputField[j].get("v.fieldName")] &&
        !Boolean(inputField[j].get("v.value"))
      ) {
        $A.util.addClass(inputField[j], "slds-has-error");
        result = false;
      }
    }
    var addressLine1 = component.find("addressLine1").get("v.value");
    var city = component.find("city").get("v.value");
    var county = component.find("county").get("v.value");
    var state = component.find("state").get("v.value");
    var postalCode = component.find("postalCode").get("v.value");

    if (!addressLine1 || addressLine1 == "") {
      result = false;
    } else if (!city || city == "") {
      result = false;
    } else if (!state || state == "") {
      result = false;
    } else if (!county || county == "") {
      result = false;
    } else if (!postalCode || postalCode == "") {
      result = false;
    }
    component.set("v.isInvalid", !result);
    console.log('is valid result is: ' + result);
    return result;
  },

  // show toast message
  showToast: function(component, variant, message, linkLabel, qqId) {
    component.find("notifLib").showToast({
      variant: variant,
      message: message,
      messageData: [
        {
          url: "/detail/" + qqId,
          label: linkLabel
        }
      ],
      mode: "dismissible",
      duration: "5000"
    });
  },
  helpFindMatchingAddress: function(component) {
    var action = component.get("c.getMatches");
    var addressSearchString = component.find("addressLine1").get("v.value");
    action.setParams({
      addressString: addressSearchString
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var matches = response.getReturnValue();
        component.set("v.matches", matches);
        var cmpTarget = component.find("matchesOverlay");
        $A.util.removeClass(cmpTarget, "no-display");
      }
    });
    $A.enqueueAction(action);
  },
  populateAddressFields: function(component, address) {
    component.find("addressLine1").set("v.value", address.addressLine1);
    component.find("city").set("v.value", address.city);
    component.find("county").set("v.value", address.county);
    component.find("state").set("v.value", address.state);
    component.find("postalCode").set("v.value", address.postalCode);
    component.find("validStatus").set("v.value", address.validStatus);
    component.find("validTime").set("v.value", address.validTime);
  },
  emailSupport: function(component, subject, body) {
    var emailSupportAction = component.get("c.emailSupport");
    emailSupportAction.setParams({
      subject: subject,
      body: body
    });
    emailSupportAction.setCallback(this, function(response) {
      let state = response.getState();
      console.log(state);
      if (state === "SUCCESS") {
        component.find("notifLib").showToast({
          title: "Email Sent!",
          variant: "success",
          showCloseButton: true
        });
      } else {
        component.find("notifLib").showToast({
          title: "Something went wrong!",
          variant: "error",
          showCloseButton: true
        });
      }
    });
    $A.enqueueAction(emailSupportAction);
    return;
  },
  getEnvSettingsHelper: function(component, subject, body) {
    var settingsAction = component.get("c.getEnvVariables");

    return new Promise(
      $A.getCallback((resolve, reject) => {
        settingsAction.setCallback(this, response => {
          let settings = response.getReturnValue();
          component.set("v.settings", settings);
          resolve();
        });
        $A.enqueueAction(settingsAction);
      })
    );
  }
});