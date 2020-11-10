({
    handleDisplayTear: function(component, event, helper) {
        
        console.log('Display the tear sheet brther' + event.getParam('lease'));
        component.set('v.fromNewco', true);
        component.set('v.leaseNumber',event.getParam('lease'));
        component.set('v.isTearSheetVisible', false);
        helper.getLeaseDetails(component);
        console.group('vis: ' + component.get('v.isTearSheetVisible'));
        component.set('v.isTearSheetVisible', true);
        console.group('vis: ' + component.get('v.isTearSheetVisible'));
      
    },
/*
    asdfasd
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

    asdfasd
*/
    handleDisplayQuote: function(component, event) {
        
        console.log('Display the quote sheet brther: ' + event.getParam('row'));
        component.set('v.row', event.getParam('row'));
        component.set('v.selectedRow', JSON.stringify(event.getParam('row')));
        component.set('v.leaseNumber',event.getParam('lease'));
        component.set('v.fromNewco', true);
        component.set('v.isQuoteModuleVisible', true);
    },

    closeModal: function(component, event, helper) {
        component.set("v.isTearSheetVisible", false);
        component.set("v.isQuoteModuleVisible", false);
    },

    switchToQuoteModule: function(component, event, helper) {
        component.set("v.isTearSheetVisible", false);
        component.set("v.isQuoteModuleVisible", true);
    },

    downloadTearSheet: function(component, event, helper) {
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
    
    
})