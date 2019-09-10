({
  getDataHelper: function(component, reload) {
    component.set("v.isLoading", true);
    let action = component.get("c.getQuoteHistory");

    let leaseNumberFilter = component.get("v.contractNumber");
    let customerNameFilter = component.get("v.customerName");
    let pageNumber = component.get("v.pageNumber");
    let pageSize = component.get("v.pageSize");
    let offset = component.get("v.offset");

    action.setParams({
      pageSize: pageSize,
      offset: offset,
      leaseNumber: leaseNumberFilter,
      customerName: customerNameFilter
    });

    return new Promise(
      $A.getCallback((resolve, reject) => {
        action.setCallback(this, response => {
          let state = response.getState();
          if (state === "SUCCESS") {
            let data = response.getReturnValue();
            console.log(data);
            data.map(el => {
              el.NameDisplay = el.Name.split("TU")[1];
            });
            let existingData = component.get("v.data");
            let currentRowCount = component.get("v.rowCount");

            if (reload) {
              let newData = existingData.concat(data);
              component.set("v.data", newData);
              if (newData.length == currentRowCount) {
                component.set("v.enableInfiniteLoading", false);
              } else {
                component.set("v.enableInfiniteLoading", true);
                component.set("v.pageNumber", pageNumber + 1);
                component.set("v.offset", offset + pageSize);
                component.set("v.rowCount", newData.length);
                // component.set("v.data", newData);
              }
            } else {
              component.set("v.data", data);
              if (data.length == currentRowCount) {
                component.set("v.enableInfiniteLoading", false);
              } else {
                component.set("v.enableInfiniteLoading", true);
                component.set("v.pageNumber", pageNumber + 1);
                component.set("v.offset", offset + pageSize);
                component.set("v.rowCount", data.length);
                // component.set("v.data", data);
              }
            }
            resolve();
          } else {
            component.find("notifLib").showToast({
              title: "Something went wrong!",
              variant: "error",
              showCloseButton: true
            });
            reject();
          }
          component.set("v.isLoading", false);
        });
        $A.enqueueAction(action);
      })
    );
  },

  getQuoteHelper: function(component) {
    let action = component.get("c.getQuickQuote");
    let selectedRow = component.get("v.selectedRow");
    action.setParams({
      leaseNumber: selectedRow.Contract_Number__c
    });

    return new Promise(
      $A.getCallback((resolve, reject) => {
        action.setCallback(this, response => {
          let state = response.getState();
          if (state === "SUCCESS") {
            let data = response.getReturnValue();
            component.set("v.quickQuote", JSON.stringify(data));
            resolve(data);
          } else {
            component.find("notifLib").showToast({
              title: "Something went wrong!",
              variant: "error",
              showCloseButton: true
            });
            reject();
          }
        });
        $A.enqueueAction(action);
      })
    );
  },

  handleShowCreditApproval: function(component, data) {
    component.set("v.isLoading", true);

    let modalBody;
    $A.createComponent(
      "c:FMZ_CreditApproval",
      { tradeUpDetails: data },
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
          console.log(errorMessage);
          toast.setParams({
            title: "Error",
            message: errorMessage,
            type: "error"
          });
          toast.fire();
        }
        component.set("v.isLoading", false);
      }
    );
  },

  getLeaseData: function(component) {
    component.set("v.isLoading", true);
    let row = JSON.parse(component.get("v.selectedRowString"));
    var getDataAction = component.get("c.getData");
    console.log("Contract #");
    console.log(row.Contract_Number__c);
    getDataAction.setParams({
      customerName: "",
      contractNumber: row.Contract_Number__c,
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
          let error = a.getError();
          console.log(error);
          if (state === "SUCCESS") {
            let data = a.getReturnValue();
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
            component.set("v.leaseData", JSON.stringify(data.data[0]));
            component.set("v.isLoading", false);
            resolve(data.data[0]);
          } else {
            component.find("notifLib").showToast({
              title: "Something went wrong!",
              variant: "error",
              showCloseButton: true
            });
            component.set("v.isLoading", false);
            reject();
          }
        });
        $A.enqueueAction(getDataAction);
      })
    );
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