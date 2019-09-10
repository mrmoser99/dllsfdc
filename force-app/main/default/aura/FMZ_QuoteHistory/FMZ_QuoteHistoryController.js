({
  doInit: function(component, event, helper) {
    component.set("v.columns", [
      {
        label: "Quote Number",
        fieldName: "NameDisplay",
        type: "text",
        sortable: false
      },
      {
        label: "Customer Name",
        fieldName: "Customer_Name__c",
        type: "text",
        sortable: false
      },
      {
        label: "Lease Number",
        fieldName: "Contract_Number__c",
        type: "text",
        sortable: false
      },
      {
        label: "Quote Type",
        fieldName: "Termination_Quote_Type__c",
        type: "text",
        sortable: false
      },
      {
        label: "Quote Amount",
        fieldName: "Amount__c",
        type: "currency",
        sortable: false,
        typeAttributes: { currencyCode: "USD" },
        cellAttributes: { alignment: "left" }
      },
      {
        label: "Quote Date",
        fieldName: "CreatedDate",
        type: "date",
        sortable: false,
        typeAttributes: {
          day: "numeric",
          month: "numeric",
          year: "numeric"
        }
      },
      {
        label: "Expiration Date",
        fieldName: "Quote_Validity_Date__c",
        type: "date",
        sortable: false,
        typeAttributes: {
          day: "numeric",
          month: "numeric",
          year: "numeric"
        }
      },
      {
        label: "Credit Approval Number",
        fieldName: "Quick_Quote_Number__c",
        type: "text",
        sortable: false
      },
      {
        label: "View Detail",
        type: "button",
        initialWidth: 135,
        typeAttributes: {
          label: "View Details",
          name: "viewDetails",
          title: "Click to view quote details"
        }
      },
      {
        label: "Submit to Credit Approval",
        type: "button",
        initialWidth: 210,
        typeAttributes: {
          label: "Submit to Credit Approval",
          name: "submitCreditApproval",
          title: "Click to Submit for Credit Approval"
        }
      }
    ]);

    helper.getDataHelper(component, false);
    helper.getEnvSettingsHelper(component);
  },

  getDataController: function(component, event, helper) {
    let isLoading = component.get("v.isLoading");
    let rowCount = component.get("v.rowCount");
    let pageSize = component.get("v.pageSize");
    console.log("get data reloading");
    if (rowCount >= pageSize && !isLoading) {
      helper.getDataHelper(component, true);
    }
  },

  filterResults: function(component, event, helper) {
    let isLoading = component.get("v.isLoading");
    let filtering = component.get("v.filtering");
    let leaseNumberFilter = component.get("v.contractNumber");
    let customerNameFilter = component.get("v.customerName");
    component.set("v.pageNumber", 0);
    component.set("v.offset", 0);

    if (
      ((leaseNumberFilter != null && leaseNumberFilter != "") ||
        (customerNameFilter != null && customerNameFilter != "")) &&
      filtering
    ) {
      // component.set("v.pageNumber", 0);
      component.set("v.filtering", false);
    } else if (
      ((leaseNumberFilter != null && leaseNumberFilter != "") ||
        (customerNameFilter != null && customerNameFilter != "")) &&
      !filtering
    ) {
      component.set("v.rowCount", 0);
      // component.set("v.pageNumber", 0);
      component.set("v.filtering", true);
    }
    if (!isLoading) {
      helper.getDataHelper(component, false);
    }
  },
  handleRowAction: function(component, event, helper) {
    let rowAction = event.getParam("action");
    let row = event.getParam("row");
    component.set("v.selectedRow", row);
    component.set("v.selectedRowString", JSON.stringify(row));
    switch (rowAction.name) {
      case "viewDetails":
        component.set("v.showQuoteDetails", true);
        return;

      case "submitCreditApproval":
        if (
          $A.localizationService.formatDate(
            new Date(row.Quote_Validity_Date__c),
            "YYYY-MM-DD"
          ) >= $A.localizationService.formatDate(new Date(), "YYYY-MM-DD")
        ) {
          helper.getQuoteHelper(component).then(data => {
            if (data == null) {
              helper.getLeaseData(component).then(leaseData => {
                if (leaseData != null) {
                  let quoteData = JSON.parse(
                    component.get("v.selectedRowString")
                  );
                  // Conversion of names to make it work for various modules
                  quoteData.leaseNumber = quoteData.Contract_Number__c;
                  quoteData.quoteNumberDisplay = quoteData.NameDisplay;
                  quoteData.quoteAmount = quoteData.Amount__c;
                  quoteData.quoteNumber = quoteData.Name;
                  quoteData.expirationDate = quoteData.Quote_Validity_Date__c;
                  quoteData.leaseDetails = leaseData;

                  helper.handleShowCreditApproval(component, quoteData);
                }
              });
            } else if (
              $A.localizationService.formatDate(
                new Date(data.Oracle_Trade_up_Quote_Expiration_Date__c),
                "YYYY-MM-DD"
              ) >= $A.localizationService.formatDate(new Date(), "YYYY-MM-DD")
            ) {
              component.set("v.creditApprovalScreenForward", true);
            } else {
              helper.getLeaseData(component).then(() => {
                component.set("v.requoteConfirmationScreen", true);
              });
            }
          });
        } else {
          helper.getLeaseData(component).then(() => {
            component.set("v.requoteConfirmationScreen", true);
          });
        }
        return;
    }
  },

  closeModal: function(component, event, helper) {
    component.set("v.showQuoteDetails", false);
    component.set("v.requoteConfirmationScreen", false);
    component.set("v.isQuoteModuleVisible", false);
    component.set("v.creditApprovalScreenForward", false);
  },

  showRequoteApplicationScreen: function(component, event, helper) {
    component.set("v.requoteConfirmationScreen", false);
    component.set("v.isQuoteModuleVisible", true);
  },

  redirectToApplication: function(component, event, helper) {
    let settings = component.get("v.settings");
    let quote = JSON.parse(component.get("v.quickQuote"));

    console.log("Settings");
    console.log(settings);

    console.log("Quote");
    console.log(quote);
    // window.open(
    //   `${settings.Community_URL__C}/dealer/s/quick-quotes/${quote.Id}`,
    //   "_top"
    // );
    let urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      url: `/quick-quotes/${quote.Id}`
    });
    urlEvent.fire();
    component.set("v.creditApprovalScreenForward", false);
  }
});