/*
 Change Log:

 08/24/2020 - MRM - Made it work from account
 09/28/2020 - MRM - qq 2.0
*/
({
  doInit: function(component, event, helper) {
    
    console.log( 'in do init');
    
    var recordId = component.get("v.recordId");
    var tradeUpDetails = component.get("v.tradeUpDetails");
    var autoSubmitDetails = component.get("v.autoSubmitDetails");
    if (typeof autoSubmitDetails !== 'undefined')
      component.set("v.autoMode",true);

    console.log("Auto:" +  autoSubmitDetails) ;
    console.log("Automode = " + component.get("v.autoMode"));
     
    console.log('value is: ' + component.get("v.selectedFinanceAmount"));
    if (autoSubmitDetails == "10000")
      component.set("v.selectedFinanceAmount","$10,000");
    console.log('value is: ' + component.get("v.selectedFinanceAmount"));

    if (recordId) {
      var action = component.get("c.getAccountId");
      action.setParams({
        recordId: recordId
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          console.log('found account');
          var accId = response.getReturnValue();
          console.log('adccid : ' + accId);
          
          component.set("v.accountId", accId);
          component.set("v.newAccount", false);
          console.log('before fast path');
          helper.loadFields(component, helper);
          helper.loadDealerId(component);
          console.log('fastpath');
        }
      });
      $A.enqueueAction(action);
    } else if (tradeUpDetails) {
      console.log('check customer name');
      var action = component.get("c.checkCustomerName");
      action.setParams({
        customerName: tradeUpDetails.leaseDetails.customerName
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
        console.log('hello2');
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
      console.log('hello');
      helper.loadFields(component, helper);
      helper.loadDealerId(component);
    }

    console.log('leaving do init');
   
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
    console.log('start doneloading');
    var accountId = component.get("v.accountId");
    if (accountId) {
      if (Array.isArray(accountId)) {
        component.set("v.accountId", accountId[0]);
      }
      helper.prepopulateAccountInfo(component, helper);
    }
    component.set("v.processing", false);
    console.log('last thing really');
  },
  handleLoad: function(component, event, helper) {
    $A.util.addClass(component, "is-loaded");
  },
   
  handleSubmit: function(component, event, helper) {
  console.log('clicked create');
    component.set('v.processing', true);
    var accountId = component.get("v.accountId");

    //create quick quote fields to send to controller
    var fields = component.get("v.submitFields");
     


    var dealerId = component.get("v.dealerId");
    console.log('calling is valid on wed');
    var isValid = helper.isValid(component);
    console.log('back from isvalid');
    var recordId = component.get("v.recordId");
    var account = component.get("v.account");
    var tradeUpDetails = component.get("v.tradeUpDetails");

    if (tradeUpDetails) {
      fields["Oracle_Trade_up_Lease_Number__c"] = tradeUpDetails.leaseNumber;
      fields["Oracle_Trade_Up_Quote_Amount__c"] = tradeUpDetails.quoteAmount;
      fields["Oracle_Trade_up_Quote_Number__c"] = tradeUpDetails.quoteNumber;
      fields["Oracle_Trade_up_Quote_Expiration_Date__c"] = tradeUpDetails.expirationDate;
    }
    fields["Email_Address__c"] = component.find("inputFieldEmail").get("v.value");
    console.log('assigning f amount');
    if (component.get("v.autoSubmitDetails") == "10000"){
      fields["Estimated_Financed_Amount__c"] = "10000";
    }
    else{
        console.log('hi');
        console.log('value is: ' + component.get("v.selectedFinanceAmount"));
        fields["Estimated_Financed_Amount__c"] = component.get("v.selectedFinanceAmount");
    }
    fields["Primary_Phone_Number__c"] = component.find("inputFieldPhone").get("v.value");
    fields["genesis__Address_Line_1__c"] = component.find("addressLine1").get("v.value");
    fields["genesis__City__c"] = component.find("city").get("v.value");
    fields["County__c"] = component.find("county").get("v.value");
    fields["genesis__State__c"] = component.find("state").get("v.value");
    fields["genesis__Postal_Code__c"] = component.find("postalCode").get("v.value");
    fields["genesis__Country__c"] = "USA";
    fields["Validation_Status__c"] = component.find("validStatus").get("v.value");
    fields["Validation_Time_Stamp__c"] = component.find("validTime").get("v.value");
    fields["genesis__Account__c"] = accountId;

  console.log('account id is: ' + accountId);
    fields["Dealer__c"] = dealerId;
    
    if (account && account.Name) {
     console.log('account');
      fields["genesis__Business_Name__c"] = account.Name;
    }
    else{
      fields["genesis__Business_Name__c"] = component.get("v.inputValue");
    }
    
    component.set("v.isInvalid", !isValid);
  console.log("Invalid = " + component.get("v.isInvalid"));
    if (!isValid){
      component.set("v.processing", false);
      return;
    }
    var action = component.get("c.createRecords");
    action.setParams({
      jsonText:JSON.stringify(fields),
      ignoreDuplicates: false
    });

    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var createResponse = response.getReturnValue();
      console.log(createResponse);
        if (createResponse.status == "SUCCESS") {
          helper.submitForApproval(component, createResponse.message);
        } else {
          let modalBody;
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
                        jsonText:JSON.stringify(fields),
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
  console.log('look up change');
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
  onKeyPressEvent: function(component, event, helper) {
  console.log('key pressed=' + event.key);

    if (event.key == 'Enter' || event.key == 'Tab') {
     console.log('trying switcheroo');
       
      event.preventDefault();
      component.set("v.results", []);
      var cmpTarget = component.find("searchesOverlay");
     console.log('trying switcheroo2');
      $A.util.removeClass(cmpTarget, "no-display");
      //component.set("v.openDropDown", false);
      //temp
      component.set("v.inputValue", component.find("searchValue").get("v.value"));
     console.log('trying switcheroo3');
    console.log('setting focus');
      component.find("inputFieldFinance").focus();
       
      
    console.log('switcheroo');
    }
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
  },
  switchKey : function (component, event, helper) {
    
    component.set("v.results", []);
    component.set("v.openDropDown", false);
    component.set("v.inputValue", event.target.value);
  console.log('setting focus');
     
    
     
  },
  searchHandler : function (component, event, helper) {
  console.log('key code is: ' + event.key);
  console.log('event is:' + event);
    
    if (event.keyCode == 9 || event.keyCode == 13){
    console.log('hi there  tab/enter was pressed');
      component.set("v.results", []);
      component.set("v.openDropDown", false);
      //temp comment
      //component.set("v.inputValue", event.target.value);
      component.set("v.inputValue", component.find("searchValue").get("v.value"));
      component.find("inputFieldFinance").focus();
      if (event.keyCode == 13) {
      console.log('trying focus2' + component.find("inputFieldFinance"));
      console.log( component.find("inputFieldFinance").get("v.value") );
        component.find("inputFieldFinance").focus();
        component.set('v.isFocus1', true);
      console.log('trying focus end');

      } 
      
    }
    else{
  console.log('in searchHandler' + event.target.value);
    component.set("v.processing", true);
    //temp comment
    //const searchString = event.target.value;
    const searchString = component.find("searchValue").get("v.value");

  console.log('in search handler' + 'search string is: ' + searchString);
    if (searchString.length >= 4) {
        //Ensure that not many function execution happens if user keeps typing
        if (component.get("v.inputSearchFunction")) {
            clearTimeout(component.get("v.inputSearchFunction"));
        }

        var inputTimer = setTimeout($A.getCallback(function () {
            helper.searchRecords(component, searchString);
        }), 1);
        component.set("v.inputSearchFunction", inputTimer);
      console.log('not found');
        component.set("v.searchString",searchString);
      console.log('search string is' + component.get("v.searchString"));
    } else{
        component.set("v.results", []);
        var cmpTarget = component.find("searchesOverlay");
        $A.util.addClass(cmpTarget, "no-display");
        //component.set("v.openDropDown", false);

      console.log('r: ' + component.get("v.results"));
    }
  }
    component.set("v.processing", false);
},
optionClickHandler : function (component, event, helper) {
  //
console.log('option click handler');
  //on the url of the component are data-value and data-id...these can then be retrieved by currenttarget.dataset.putname here
  var selectedId = event.currentTarget.dataset.id;
  var selectedValue = event.currentTarget.dataset.value;
  component.set("v.processing", true);
  
  var cmpTarget = component.find("searchesOverlay");
  $A.util.addClass(cmpTarget, "no-display");
  
  component.set("v.processing", true);
  
  component.set("v.inputValue", selectedValue);
  component.set("v.selectedOption", selectedId);
console.log(component.get("v.selectedOption"));
  component.set("v.accountId",selectedId);
  component.set("v.recordId",selectedId);
   
  var action = component.get("c.getAccountId");
    action.setParams({
      recordId: selectedId
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
    console.log(state);
      if (state === "SUCCESS") {
      console.log('success');
        var accId = response.getReturnValue();
        component.set("v.accountId", accId);
        component.set("v.newAccount", false);
        helper.loadFields(component, helper);
        helper.loadDealerId(component);
        component.set("v.processing", false);
      }
    });
    $A.enqueueAction(action);
  
   
},

clearOption : function (component, event, helper) {
  console.log('clear option');
    component.set("v.results", []);
    component.set("v.openDropDown", false);
    component.set("v.inputValue", "");
    component.set("v.selectedOption", "");
   

},
loadOptions: function (component, event, helper) {
        var opts = [
            { value: "0", label: "Please choose an amount" },
            { value: "10000.00", label: "$10,000" },
            { value: "25000.00", label: "$25,000" },
            { value: "50000.00", label: "$50,000" }
        ];
        component.set("v.options2", opts);
    }
});


 