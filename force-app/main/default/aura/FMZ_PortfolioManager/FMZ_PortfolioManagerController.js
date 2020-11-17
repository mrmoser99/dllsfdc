({
  doInit: function(component, event, helper) {
    component.set("v.columns", [
      {
        label: "Customer Name",
        fieldName: "customerName",
        type: "text",
        sortable: true
      },
      {
        label: "Lease number",
        fieldName: "contractNumber",
        type: "text",
        sortable: true
      },
      {
        label: "Number of assets",
        fieldName: "nbrOfAssets",
        type: "text",
        sortable: false
      },
      {
        label: "Payment",
        fieldName: "contractPayment",
        type: "currency",
        sortable: false
      },
      {
        label: "Remaining Payments",
        fieldName: "numberOfRemainingPayments",
        type: "text",
        sortable: true
      },
      {
        label: "Term",
        fieldName: "contractTerm",
        type: "text",
        sortable: false
      },
      {
        label: "Equipment location adddress",
        fieldName: "assetAddressLine1",
        type: "text",
        sortable: false
      },
      {
        label: "City",
        fieldName: "assetCity",
        type: "text",
        sortable: false
      },
      {
        label: "Zip",
        fieldName: "assetZipCode",
        type: "text",
        sortable: true
      },
      {
        label: "State",
        fieldName: "assetState",
        type: "text",
        sortable: false
      },
      {
        label: "TearSheet",
        type: "button",
        initialWidth: 135,
        typeAttributes: {
          label: "TearSheet",
          name: "tearsheet",
          title: "Click to generate tear sheet"
        }
      },
      {
        label: "Quote",
        type: "button",
        initialWidth: 135,
        typeAttributes: {
          label: "Quote",
          name: "quote",
          title: "Click to generate quotes"
        }
      }
    ]);

    let pageSize = component.get("v.pageSize");
    let page = component.get("v.page");
    helper.fetchData(component, pageSize, page);
    helper.getEnvSettingsHelper(component);
  },

  loadMoreData: function(component, event, helper) {
    // Display a spinner to signal that data is being loaded
    const rowCount = component.get("v.rowCount");
    const pageSize = component.get("v.pageSize");
    const isLoading = component.get("v.isLoading");
    event.getSource().set("v.isLoading", true);
    // If result set is smaller than page size don't trigger infinity loading
    // If already loading, don't trigger 2x
    if (rowCount >= pageSize && !isLoading) {
      let page = component.get("v.page");
      page = page + 1;
      helper.fetchData(component, pageSize, page, true).then(() => {
        component.set("v.page", page);
        event.getSource().set("v.isLoading", false);
      });
    }
  },

  filterResults: function(component, event, helper) {
    event.getSource().set("v.isLoading", true);
    const pageSize = component.get("v.pageSize");
    helper.fetchData(component, pageSize, 1).then(() => {
      if (component.get("v.equipmentSerialNumber") != "") {
        let data = JSON.parse(JSON.stringify(component.get("v.data")));
        component.set("v.contractNumber", data[0].contractNumber);
        component.set("v.equipmentSerialNumber", "");
        helper.fetchData(component, pageSize, 1);
      }
    });

    component.set("v.page", 1);
    event.getSource().set("v.isLoading", false);
  },

  sortData: function(component, event, helper) {
    const fieldName = event.getParam("fieldName");
    const sortDirection = event.getParam("sortDirection");
    // assign the latest attribute with the sorted column fieldName and sorted direction
    component.set("v.sortedBy", fieldName);
    component.set("v.sortedDirection", sortDirection);

    event.getSource().set("v.isLoading", true);
    const pageSize = component.get("v.pageSize");
    helper.getData(component, pageSize, 1);

    component.set("v.page", 1);
    event.getSource().set("v.isLoading", false);
  },

  download: function(component, event, helper) {
    let page = 1;
    const size = 50;
    let csvData = [];
    const itemTotal = component.get("v.fullCount");
    const pageTotal = Math.ceil(itemTotal / 50);
    let promises = [];
    for (page; page <= pageTotal; page++) {
      promises.push(helper.getPortfolio(component, page, size));
    }
    Promise.all(promises).then(result => {
      result.map(array => {
        let row;
        array.data.map(el => {
          el.assetDetail.map(subEl => {
            row = Object.assign(subEl, el);
          });
          csvData.push(row);
        });
      });

      const columnDivider = ",";
      const lineDivider = "\n";

      const keys = [
        "customerName",
        "contractNumber",
        "billingAddressLine1",
        "billingCity",
        "billingState",
        "billingZipCode",
        "contractType",
        "contractTerm",
        "contractPeriodicity",
        "contractPurchaseOption",
        "contractStartDate",
        "contractExpireDate",
        "contractOriginalCost",
        "contractPayment",
        "contractSigner",
        "contractSignerTitle",
        "numberOfRemainingPayments",
        "lastPaymentReceivedDate",
        "assetAddressLine1",
        "assetAddressLine2",
        "assetCity",
        "assetZipCode",
        "assetState",
        "assetSequenceNumber",
        "assetManufacturer",
        "assetModel",
        "assetSerialNumber"
      ];

      const labels = [
        "Customer Name",
        "Lease Number",
        "Billing Address Line 1",
        "Billing City",
        "Billing State",
        "Billing Zip Code",
        "Type",
        "Term",
        "Payment Frequency",
        "Purchase Option",
        "Start Date",
        "Contract Maturity Date",
        "Total Amount Financed",
        "Base Payment Amount",
        "Contract Signer",
        "Signer Title",
        "Remaining Payments",
        "Last Payment Received Date",
        "Address Line 1",
        "Address Line 2",
        "City",
        "ZIP",
        "State",
        "Asset Number",
        "Make",
        "Model",
        "Serial Number"
      ];

      let csvStringResult = "";
      csvStringResult += labels.join(columnDivider);
      csvStringResult += lineDivider;

      for (var i = 0; i < csvData.length; i++) {
        let counter = 0;

        for (var sTempkey in keys) {
          var skey = keys[sTempkey];

          if (counter > 0) {
            csvStringResult += columnDivider;
          }
          if (csvData[i][skey] == null || csvData[i][skey] == undefined) {
            csvData[i][skey] = " ";
          }
          csvStringResult += '"' + csvData[i][skey] + '"';

          counter++;
        }
        csvStringResult += lineDivider;
      }

      const hiddenElement = document.createElement("a");
      hiddenElement.href =
        "data:text/csv;charset=utf-8," + encodeURIComponent(csvStringResult);
      hiddenElement.target = "_self";
      hiddenElement.download = "LeasePortfolio.csv";
      document.body.appendChild(hiddenElement);
      hiddenElement.click();
    });
  },

  handleRowAction: function(component, event, helper) {
    var rowAction = event.getParam("action");
    var row = event.getParam("row");

    switch (rowAction.name) {
      case "tearsheet":
        component.set("v.selectedRow", JSON.stringify(row));
        helper.fetchLeaseDetails(component, JSON.stringify(row));
        return;
      case "quote":
        component.set("v.selectedRow", JSON.stringify(row));
        $A.enqueueAction(component.get("c.openQuoteModule"));
        return;
    }
  },
  

  openTearSheetModal: function(component, event, helper) {
    component.set("v.isTearSheetVisible", true);
  },

  openQuoteModule: function(component, event, helper) {
    component.set("v.isQuoteModuleVisible", true);
  },

  switchToQuoteModule: function(component, event, helper) {
    component.set("v.isTearSheetVisible", false);
    component.set("v.isQuoteModuleVisible", true);
  },

  closeModal: function(component, event, helper) {
    component.set("v.isTearSheetVisible", false);
    component.set("v.isQuoteModuleVisible", false);
  },

  downloadTearSheet: function(component, event, helper) {
    console.log('from newco is: ' + component.get('v.fromNewco'));
    let message = component.get("v.leaseDetails");
    const vfWindow = component.find("vfFrame").getElement().contentWindow;
    //Sending message using postMessage function
    //If sending an json object, its better to stringify first and send the object
    vfWindow.postMessage(message);
  },

  emailTearSheetController: function(component, event, helper) {
    const stringData = component.get("v.leaseDetails");
    const jsonData = JSON.parse(stringData);

    const subject = `TearSheet for ${jsonData.customerName} - ${
      jsonData.contractNumber
    }`;

    let equipmentInformationBody = "";
    jsonData.assetDetail.map(el => {
      equipmentInformationBody += `    <tr>
      <td style="width: 16.67%; border-right: 1px solid black">
        <p>${el.assetSequenceNumber}</p>
      </td>
      <td style="width: 16.67%; border-right: 1px solid black">
        <p>${el.assetManufacturer}</p>
      </td>
      <td style="width: 16.67%; border-right: 1px solid black">
        <p>${el.assetModel}</p>
      </td>
      <td style="width: 16.67%; border-right: 1px solid black">
        <p>${el.assetSerialNumber}</p>
      </td>
      <td style="width: 16.67%; border-right: 1px solid black">
        <p>${
          el.Install_date
            ? $A.localizationService.formatDate(el.Install_date, "MM/DD/YYYY")
            : ""
        }</p>
      </td>
      <td style="width: 16.67%;">
        <p>${
          el.assetAddressLine1 + el.assetAddressLine2
            ? ", " + el.assetAddressLine2
            : ""
        }</p>
        <p>${el.assetCity + ", " + el.assetState + " " + el.assetZipCode}</p>
      </td>
    </tr>`;
    });

    const body = `<p><strong>Contract Summary:</strong></p>
    <p><strong>Customer Name: </strong>${jsonData.customerName}</p>
    <p><strong>Account Number: </strong>${jsonData.customerAccount}</p>
    <p><strong>Lease Number: </strong>${jsonData.contractNumber}</p>
    <p><strong>Billing Address: </strong>${jsonData.billingAddressLine1}, ${
      jsonData.billingAddressLine2 ? jsonData.billingAddressLine2 + ", " : ""
    }</p>
            <p>${jsonData.billingCity}, ${jsonData.billingState} ${
      jsonData.billingZipCode
    }</p></p>
    <p><strong>Lease Signer: </strong>${jsonData.contractSigner}</p>          
    <p><strong>General Information:</strong></p>
    <p> </p>
    <table style="width: 100%; border: 1px solid black">
      <tbody>
        <tr>
          <td
            style="width: 11.1%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black"
          >
            <p><u>Contract Origination Date</u></p>
          </td>
          <td
            style="width: 11.1%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black"
          >
            <p><u>Contract Maturity Date</u></p>
          </td>
          <td
            style="width: 11.1%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black"
          >
            <p><u>Term</u></p>
          </td>
          <td
            style="width: 11.1%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black"
          >
            <p><u>Remaining Payments</u></p>
          </td>
          <td
            style="width: 11.1%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black"
          >
            <p><u>Days Delinquent</u></p>
          </td>
          <td
            style="width: 11.1%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black"
          >
            <p><u>Purchase Option</u></p>
          </td>
          <td
            style="width: 11.1%; background-color: #f2f2f2; border-bottom: 1px solid black; border-bottom: 1px solid black"
          >
            <p><u>Lease Status</u></p>
          </td>
          <td style="width: 11.1%; background-color: #f2f2f2; border-bottom: 1px solid black">
            <p><u>Pre-Tax Equipment Payment</u></p>
          </td>
          <td style="width: 11.1%; background-color: #f2f2f2; border-bottom: 1px solid black">
            <p><u>Service Payment</u></p>
          </td>
        </tr>
        <tr>
          <td style="width: 11.1%; border-right: 1px solid black">
            <p>${jsonData.contractStartDate}</p>
          </td>
          <td style="width: 11.1%; border-right: 1px solid black">
            <p>${jsonData.contractExpireDate}</p>
          </td>
          <td style="width: 11.1%; border-right: 1px solid black">
            <p>${jsonData.contractTerm}</p>
          </td>
          <td style="width: 11.1%; border-right: 1px solid black">
            <p>${jsonData.numberOfRemainingPayments}</p>
          </td>
          <td style="width: 11.1%; border-right: 1px solid black">
            <p>${jsonData.Dayspastdue}</p>
          </td>
          <td style="width: 11.1%; border-right: 1px solid black">
            <p>${jsonData.Purchaseoption}</p>
          </td>
          <td style="width: 11.1%; border-right: 1px solid black">
            <p>${jsonData.Contract_Status}</p>
          </td>
          <td style="width: 11.1%;">
            <p>${Number(jsonData.contractPayment).toLocaleString("en", {
              style: "currency",
              currency: "USD"
            })}</p>
          </td>
          <td style="width: 11.1%;">
            <p>${Number(jsonData.contractService).toLocaleString("en", {
              style: "currency",
              currency: "USD"
            })}</p>
          </td>
        </tr>
      </tbody>
    </table>
    <p><strong>Equipment Summary:</strong></p>
    <table style="width: 100%; border: 1px solid black">
      <tbody>
        <tr>
          <td
            style="width: 16.67%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black"
          >
            <p><u>Asset #</u></p>
          </td>
          <td
            style="width: 16.67%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black"
          >
            <p><u>Make</u></p>
          </td>
          <td
            style="width: 16.67%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black"
          >
            <p><u>Model</u></p>
          </td>
          <td
            style="width: 16.67%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black"
          >
            <p><u>Serial #</u></p>
          </td>
          <td
            style="width: 16.67%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black"
          >
            <p><u>Install Date</u></p>
          </td>
          <td style="width: 16.67%; background-color: #f2f2f2;">
            <p><u>Equipment Location Address</u></p>
          </td>
        </tr>
        ${equipmentInformationBody}
      </tbody>
    </table>
    `;

    helper.emailTearSheetOrQuoteHelper(component, subject, body);
    return;
  }

 
 
});