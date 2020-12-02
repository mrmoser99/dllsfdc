({
  fetchData: function(component, pageSize, page, reload) {
    if (!reload) {
      component.set("v.prepareDownload", true);
    }
    var action = component.get("c.getData");
    const customerName = component.get("v.customerName") || "";
    const contractNumber = component.get("v.contractNumber") || "";
    const equipmentSerialNumber =
      component.get("v.equipmentSerialNumber") || "";
    const sortedBy = component.get("v.sortedBy") || "";

    //if (contractNumber.length !== 0 && contractNumber.length !== 8) {
    //  return new Promise((resolve, reject) => {
    //    resolve();
    //  });
    //}
    action.setParams({
      customerName: customerName,
      contractNumber: contractNumber,
      assetSerialNumber: equipmentSerialNumber,
      size: pageSize,
      sortOrder: sortedBy,
      assetDetail: true,
      page: page,
      disableLogging: false
    });
    return new Promise(
      $A.getCallback((resolve, reject) => {
        action.setCallback(this, a => {
          let state = a.getState();
          if (state === "SUCCESS") {
            const data = a.getReturnValue();
            console.log(data);
            if (data.data) {
              //var i;
              //for (i=0; i < data.data.length; i++) {
              //  console.log('row data is: ' + JSON.stringify(data.data[i]));
              //}
              data.data.map(el => {
                if (el.assetDetail && el.assetDetail[0]) {
                  el.assetAddressLine1 = el.assetDetail[0].assetAddressLine1;
                  el.assetCity = el.assetDetail[0].assetCity;
                  el.assetZipCode = el.assetDetail[0].assetZipCode;
                  el.assetState = el.assetDetail[0].assetState;
                }
              });

              if (reload) {
                const currentData = component.get("v.data");
                const newData = currentData.concat(data.data);
                component.set("v.data", newData);
                component.set("v.rowCount", newData.length);
                if (data.meta.page == data.meta.pageTotal) {
                  component.set("v.enableInfiniteLoading", false);
                }
              } else {
                component.set("v.data", data.data);
                component.set("v.itemTotal", data.meta.itemTotal);
                if(!component.get('v.fullCount')){
                  component.set('v.fullCount', data.meta.itemTotal);
                }
                component.set("v.rowCount", data.data.length);
                if (
                  data.data.length < pageSize ||
                  data.meta.page == data.meta.pageTotal
                ) {
                  component.set("v.enableInfiniteLoading", false);
                } else {
                  component.set("v.enableInfiniteLoading", true);
                }
              }
            } else {
              component.set("v.data", []);
              component.set("v.itemTotal", 0);
              component.set("v.rownCount", 0);

              component.set("v.enableInfiniteLoading", false);
            }
          } else {
            component.find("notifLib").showToast({
              title: "Something went wrong!",
              variant: "error",
              showCloseButton: true
            });
          }
          component.set("v.prepareDownload", false);
          resolve();
        });
        $A.enqueueAction(action);
      })
    );
  },

  getPortfolio: function(component, page, size) {
    component.find("notifLib").showToast({
      title: "The download is preparing in the background",
      variant: "success",
      showCloseButton: true
    });
    var porfolioAction = component.get("c.getData");
    porfolioAction.setParams({
      customerName: "",
      customerNumber: "",
      assetSerialNumber: "",
      size: size,
      sortOrder: "",
      assetDetail: true,
      page: page,
      disableLogging: true
    });
    return new Promise(
      $A.getCallback((resolve, reject) => {
        porfolioAction.setCallback(this, a => {
          let state = a.getState();
          if (state === "SUCCESS") {
            const data = a.getReturnValue();
            data.data.map(el => {
              if (el.assetDetail[0]) {
                el.assetAddressLine1 = el.assetDetail[0].assetAddressLine1;
                el.assetCity = el.assetDetail[0].assetCity;
                el.assetZipCode = el.assetDetail[0].assetZipCode;
                el.assetState = el.assetDetail[0].assetState;
              }
            });
            resolve(data);
          } else {
            component.find("notifLib").showToast({
              title: "Something went wrong!",
              variant: "error",
              showCloseButton: true
            });
            resolve();
          }
        });
        $A.enqueueAction(porfolioAction);
      })
    );
  },

  fetchLeaseDetails: function(component, row) {
    component.set("v.prepareDownload", true);
    const rowRecord = JSON.parse(row);
    component.set("v.leaseNumber", rowRecord.contractNumber);
    let selectedRow = component.get("v.selectedRow");
    console.log('selected row: ' + JSON.stringify(selectedRow));
    var leaseDetailsAction = component.get("c.getLeaseDetails");
    leaseDetailsAction.setParams({
      leaseNumber: component.get("v.selectedRow")
    });
    return new Promise(
      $A.getCallback((resolve, reject) => {
        leaseDetailsAction.setCallback(this, a => {
          let state = a.getState();
          console.log("state");
          console.log(state);
          if (state !== "SUCCESS") {
            component.find("notifLib").showToast({
              title: "Something went wrong!",
              variant: "error",
              showCloseButton: true
            });
            resolve();
            return;
          }
          const leaseDetails = a.getReturnValue();
          console.log(JSON.parse(leaseDetails));
          let data = JSON.parse(leaseDetails);
          data.assetDetail.sort((a, b) =>
            Number(a.assetSequenceNumber) > Number(b.assetSequenceNumber)
              ? 1
              : -1
          );
          component.set("v.leaseDetails", JSON.stringify(data));
          component.set("v.prepareDownload", false);
          $A.enqueueAction(component.get("c.openTearSheetModal"));
          resolve();
        });
        $A.enqueueAction(leaseDetailsAction);
      })
    );
  },
  // handleShowCreditApproval: function(component) {
  //   let modalBody;
  //   var selectedTradeUp = component.get("v.selectedTradeUp");
  //   $A.createComponent(
  //     "c:FMZ_CreditApproval",
  //     { tradeUpDetails: selectedTradeUp },
  //     function(content, status, errorMessage) {
  //       console.log("!!! STATUS: " + status);
  //       if (status === "SUCCESS") {
  //         console.log("IN SUCCESS");
  //         modalBody = content;
  //         component.find("overlayLib").showCustomModal({
  //           body: modalBody,
  //           showCloseButton: true,
  //           cssClass: "mymodal",
  //           closeCallback: function() {}
  //         });
  //       } else if (status === "ERROR") {
  //         let toast = $A.get("e.force:showToast");
  //         toast.setParams({
  //           title: "Error",
  //           message: errorMessage,
  //           type: "error"
  //         });
  //         toast.fire();
  //       }
  //     }
  //   );
  //   component.set("v.selectedTradeUp", null);
  // },
  emailTearSheetOrQuoteHelper: function(component, subject, body) {
    console.log("In Helper 2");
    var emailTearSheetOrQuoteAction = component.get("c.emailTearSheetOrQuote");
    emailTearSheetOrQuoteAction.setParams({
      subject: subject,
      body: body
    });
    console.log("Going into callback");
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