({
  fetchData: function(component) {
    var getDataAction = component.get("c.getData");
    getDataAction.setParams({
      customerName: "",
      contractNumber: component.get("v.leaseNumber"),
      assetSerialNumber: "",
      size: 50,
      sortOrder: "",
      assetDetail: true,
      page: 1,
      disableLogging: false
    });
    return new Promise(
      $A.getCallback((resolve, reject) => {
        getDataAction.setCallback(this, a => {
          let state = a.getState();
          if (state === "SUCCESS") {
            const data = a.getReturnValue();
            console.log("fetch Data");
            console.log(data);
            data.data.map(el => {
              if (el.assetDetail[0]) {
                el.assetAddressLine1 = el.assetDetail[0].assetAddressLine1;
                el.assetCity = el.assetDetail[0].assetCity;
                el.assetZipCode = el.assetDetail[0].assetZipCode;
                el.assetState = el.assetDetail[0].assetState;
              }
            });
            let leaseNumber = component.get("v.leaseNumber");
            component.set("v.selectedRow", data.data[0]);
            resolve(data.data[0]);
          } else {
            let error = a.getError();
            console.log(error);
            component.find("notifLib").showToast({
              title: "Something went wrong!",
              variant: "error",
              showCloseButton: true
            });
            reject();
          }
        });
        $A.enqueueAction(getDataAction);
      })
    );
  },

  
  getLeaseDetailsHelper: function(component, data) {
    console.log('in get lease detail shelper');
    return new Promise(
      $A.getCallback((resolve, reject) => {
        var action;
        if (component.get('v.fromNewco') == true){
          console.log('calling newco get lease');
          action = component.get("c.getLeaseDetailsNewco");
          console.log('data contract is: ' + component.get('v.leaseNumber'));
          action.setParams({
            leaseNumber: component.get('v.leaseNumber')
          }); 
    
        }
        else{
          console.log('NOT calling newco get lease');
          action = component.get("c.getLeaseDetails");
          action.setParams({
            leaseNumber: data
          });
        }
  
        action.setCallback(this, response => {
          let state = response.getState();
          if (state === "SUCCESS") {
            var stringData = response.getReturnValue();
            component.set("v.quoteLeaseData", stringData);
            var data = JSON.parse(stringData);
            // trying this out
            component.set("v.row", JSON.stringify(data));
            component.set("v.selectedRowObj", data);

            console.log("Quote Helper Dta");
            console.log(data);

            component.set("v.customerName", data.customerName);
            component.set("v.minPaymentsRemaining",data.numberOfRemainingPayments);
            component.set("v.leaseTerm", data.contractTerm);
            component.set("v.equipmentPayment", data.contractPayment);
            component.set("v.servicePayment", data.contractService);
            component.set("v.daysDelinquent", data.Dayspastdue);
            component.set("v.originationDate", data.contractStartDate);
            component.set("v.leaseType", data.contractType);
            component.set("v.maturityDate", data.contractExpireDate);
            component.set("v.quoteDate",$A.localizationService.formatDate(new Date(), "YYYY-MM-DD")
            );
            console.log ('here');
            let equipmentDetails = [];
            data.assetDetail.sort((a, b) =>
              Number(a.assetSequenceNumber) > Number(b.assetSequenceNumber)
                ? 1
                : -1
            );
            console.log ('here 2');
            data.assetDetail.map(el => {
              const obj = {
                assetNumber: el.assetSequenceNumber,
                make: el.assetManufacturer,
                model: el.assetModel,
                serialNumber: el.assetSerialNumber,
                installDate: el.Install_Date
                  ? $A.localizationService.formatDate(
                      el.Install_Date,
                      "MM/DD/YYYY"
                    )
                  : "",
                equipmentLocationAddress: `${el.assetAddressLine1}, ${
                  el.assetAddressLine2 ? el.assetAddressLine2 + ", " : ""
                }
                      ${el.assetCity}, ${el.assetState} ${el.assetZipCode}`
              };
              equipmentDetails.push(obj);
            });
            component.set("v.equipmentData", equipmentDetails);
            console.log ('here 3');
          } else {
            let error = response.getError();
            console.log(error);
            component.find("notifLib").showToast({
              title: "Unable to get Lease Details, please refresh!",
              variant: "error",
              showCloseButton: true
            });
          }
          console.log('resolve in get lease details');
          //resolve();
        });
        $A.enqueueAction(action);
      })
    );  //end new promise
  },

 
  

  generateQuoteByTypeHelper: function(component, type) {

    

    component.set("v.isLoading", true);
    let contractNumber = component.get("v.leaseNumber");
    let row = JSON.parse(component.get("v.row"));
    console.log("row in helper");
    console.log(row);
    return new Promise(
      $A.getCallback((resolve, reject) => {
        if (component.get('v.fromNewco') == true){

          if (type == 'TRADEUP_WITH_PURCHASE'){
            //only 1 call for fromNewco
            resolve();
            return;
          }
        }
        var generateQuotesAction;
        if (component.get('v.fromNewco') != true){
          console.log('newco is not processing quote');
          generateQuotesAction = component.get("c.generateQuoteByType");
        }  
        else{
          console.log('newco is processing quote');
          generateQuotesAction = component.get("c.generateQuoteByTypeNewco");
        }
        
        generateQuotesAction.setParams({
            leaseNumber: contractNumber,
            type: type,
            customerName: row.customerName
        });
        generateQuotesAction.setCallback(this, response => {
          let state = response.getState();
          if (state === "SUCCESS") {
            var data = response.getReturnValue();
            console.log("Helper TRADEUP");
            console.log(data);

            if (data.responseCode && data.responseCode == "400") {
              component.set("v.isQuoteModuleVisible", false);
              component.find("notifLib").showToast({
                title:
                  "This Contract has been terminated and can not be quoted at this time",
                variant: "error",
                showCloseButton: true
              });
            }
            if (component.get('v.fromNewco') == true){
              component.set("v.tradeUpWithoutPurchase", data.quotes[0]);
              component.set("v.tradeUpWithPurchase", data.quotes[1]);
            }
            else{
              if (type == "TRADEUP_WITHOUT_PURCHASE") {
                component.set("v.tradeUpWithoutPurchase", data.quotes[0]);
              } else {
                component.set("v.tradeUpWithPurchase", data.quotes[0]);
              }
            }
          } else {
            let error = response.getError();
            console.log(error);
            component.find("notifLib").showToast({
              title: "Unable to generate quotes, please refresh!",
              variant: "error",
              showCloseButton: true
            });
          }
          component.set("v.isLoading", false);
          resolve();
          return;
        });
        generateQuotesAction.setBackground();
        $A.enqueueAction(generateQuotesAction);
      })
    );
  },

  getQuoteDetailsHelper: function(component, quoteNumber, number) {
    component.set("v.isLoading", true);
    return new Promise(
      $A.getCallback((resolve, reject) => {
        var quoteDetailsAction;
        console.log('from newco:' +component.get('v.fromNewco') );
        if (component.get('v.fromNewco') != true)
          quoteDetailsAction = component.get("c.getQuoteDetails");
        else
          quoteDetailsAction = component.get("c.getQuoteDetailsNewco");

        quoteDetailsAction.setParams({
          quoteNumber: quoteNumber
        });
        quoteDetailsAction.setCallback(this, response => {
          let state = response.getState(); 
          if (state === "SUCCESS") {
            console.log('success');
            var data = response.getReturnValue();
            if (number === 1) {
              if (component.get('v.fromNewco') != true){ 
                component.set("v.quoteData", data);
                component.set("v.quoteId", data.Id);
                component.set("v.remainingLeasePayments",data.Remaining_Rental_Payments__c);
                component.set("v.tradeUpDiscount", data.Discount__c);
                component.set("v.equipmentPrice", data.Equipment_Price__c);
                component.set("v.salesTax", data.Sales_Tax__c);
                component.set("v.propertyTaxReimbursement", data.Property_Tax__c);
                component.set("v.pastDueService", data.Past_Due_Service__c);
                component.set("v.outstandingLeaseCharges", data.Lease_Charges__c);
                component.set("v.securityDeposit", data.Security_Deposit__c);
                component.set("v.netTradeUpAmount", data.Amount__c);
                component.set("v.expirationDate", data.Quote_Validity_Date__c);
              }
              else{
                //newco mapping
                console.log('start 1');
                component.set("v.quoteData", data);
                component.set("v.quoteId", data.Id);
                component.set("v.remainingLeasePayments",data.QUOTE_UNBILLED_RECEIVABLE__c);
                component.set("v.tradeUpDiscount", data.QUOTE_DISCOUNT__c);
                component.set("v.equipmentPrice", data.QUOTE_PURCHASE_AMOUNT__c);
                component.set("v.salesTax", data.QUOTE_ESTIMATED_SALES_TAX__c);
                component.set("v.propertyTaxReimbursement",data.QUOTE_ESTIMATED_PROPERTY_TAX__c);
                component.set("v.pastDueService", data.QUOTE_SERVICE_AND_MAINTENANCE__c);
                component.set("v.outstandingLeaseCharges",data.Outstanding_Charges__c);
                component.set("v.securityDeposit", '0');
                component.set("v.netTradeUpAmount", data.cllease__Quote_Amount__c);
                component.set("v.expirationDate", data.cllease__Effective_To__c);
                console.log('end 1');
              }
            } 

            else {  //else number ===1
              if (component.get('v.fromNewco') != true){ 
                component.set("v.quoteData2", data);
                component.set("v.quoteId2", data.Id);
                component.set("v.remainingLeasePayments2",data.Remaining_Rental_Payments__c);
                component.set("v.tradeUpDiscount2", data.Discount__c);
                component.set("v.equipmentPrice2", data.Equipment_Price__c);
                component.set("v.salesTax2", data.Sales_Tax__c);
                component.set("v.propertyTaxReimbursement2",data.Property_Tax__c);
                component.set("v.pastDueService2", data.Past_Due_Service__c);
                component.set("v.outstandingLeaseCharges2",data.Lease_Charges__c);
                component.set("v.securityDeposit2", data.Security_Deposit__c);
                component.set("v.netTradeUpAmount2", data.Amount__c);
                component.set("v.expirationDate2", data.Quote_Validity_Date__c);
              }
              else{
                component.set("v.quoteData2", data);
                component.set("v.quoteId2", data.Id);
                component.set("v.remainingLeasePayments2",data.QUOTE_UNBILLED_RECEIVABLE__c);
                component.set("v.tradeUpDiscount2", data.QUOTE_DISCOUNT__c);
                component.set("v.equipmentPrice2", data.QUOTE_PURCHASE_AMOUNT__c);
                component.set("v.salesTax2", data.QUOTE_ESTIMATED_SALES_TAX__c);
                component.set("v.propertyTaxReimbursement2",data.QUOTE_ESTIMATED_PROPERTY_TAX__c);
                component.set("v.pastDueService2", data.QUOTE_SERVICE_AND_MAINTENANCE__c);
                component.set("v.outstandingLeaseCharges2",data.Outstanding_Charges__c);
                component.set("v.securityDeposit2", '0');
                component.set("v.netTradeUpAmount2", data.cllease__Quote_Amount__c);
                component.set("v.expirationDate2", data.cllease__Effective_To__c);
              }
            }  //end number check 
          }
          else{
            component.find("notifLib").showToast({
              title: "Unable to get quote details, please refresh!",
              variant: "error",
              showCloseButton: true
            });
          }
          component.set("v.isLoading", false);
          resolve();
          //callback(response);
        });
        $A.enqueueAction(quoteDetailsAction);
      })
    );
  },

  emailSupport: function(component, subject, body) {
    var emailSupportAction = component.get("c.emailSupport");
    emailSupportAction.setParams({
      subject: subject,
      body: body
    });
    emailSupportAction.setCallback(this, function(response) {
      let state = response.getState();
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
  handleShowCreditApproval: function(component) {
    console.log('in handel show credit');
    let modalBody;
    var selectedTradeUp = component.get("v.selectedTradeUp");
    
    console.log('selected tu:' + JSON.stringify(selectedTradeUp));
    $A.createComponent(
      "c:FMZ_CreditApproval",
      { tradeUpDetails: selectedTradeUp },
      function(content, status, errorMessage) {
        if (status === "SUCCESS") {
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
    component.set("v.selectedTradeUp", null);
  },
  emailTearSheetOrQuoteHelper: function(component, subject, body) {
    var emailTearSheetOrQuoteAction = component.get("c.emailTearSheetOrQuote");
    emailTearSheetOrQuoteAction.setParams({
      subject: subject,
      body: body
    });
    emailTearSheetOrQuoteAction.setCallback(this, a => {
      let state = a.getState();
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
    $A.enqueueAction(emailTearSheetOrQuoteAction);
  },
  requoteApplicationHelper: function(component, subject, body) {
    let applicationId = component.get("v.applicationId");
    let leaseNumber = component.get("v.leaseNumber");
    let tradeUpQuote = component.get("v.selectedTradeUp");

    var requoteApplicationAction = component.get("c.requoteApplication");
    requoteApplicationAction.setParams({
      applicationId: applicationId,
      leaseNumber: leaseNumber,
      quoteAmount: tradeUpQuote.quoteAmount,
      quoteNumber: tradeUpQuote.quoteNumber,
      quoteExpirationDate: tradeUpQuote.expirationDate
    });
    requoteApplicationAction.setCallback(this, a => {
      let state = a.getState();
      if (state === "SUCCESS") {
        component.find("notifLib").showToast({
          title: "Requoted Application Successfully",
          variant: "success",
          showCloseButton: true
        });
        component.set("v.isQuoteModuleVisible", false);
        window.location.reload();
      } else {
        let error = a.getError();
        console.log(error);
        component.find("notifLib").showToast({
          title: "Something went wrong!",
          variant: "error",
          showCloseButton: true
        });
      }
    });
    $A.enqueueAction(requoteApplicationAction);
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