({
  doInit: function(component, event, helper) {
    // Equipment Summary Columns
    console.log('in do init of tradeupquotecontroller');
    component.set("v.equipmentColumns", [
      { label: "Asset Number", fieldName: "assetNumber", type: "text" },
      { label: "Make", fieldName: "make", type: "text" },
      { label: "Model", fieldName: "model", type: "text" },
      { label: "Serial Number", fieldName: "serialNumber", type: "text" },
      { label: "Install Date", fieldName: "installDate", type: "text" },
      {
        label: "Equipment location address",
        fieldName: "equipmentLocationAddress",
        type: "text"
      }
    ]);

    component.set("v.quoteSummaryColumns", [
      {
        label: "Quote Type",
        fieldName: "quoteType",
        type: "text"
      },
      {
        label: "Quote Amount",
        fieldName: "quoteAmount",
        type: "currency",
        typeAttributes: { currencyCode: "USD" },
        cellAttributes: { alignment: "left" }
      },
      {
        label: "Quote Number",
        fieldName: "quoteNumberDisplay",
        type: "text"
      },
      {
        label: "Lease Number",
        fieldName: "leaseNumber",
        type: "text"
      }
      // {
      //   label: "Details",
      //   type: "button",
      //   initialWidth: 135,
      //   typeAttributes: {
      //     label: "Details",
      //     name: "details",
      //     title: "Click to see quote details"
      //   }
      // }
    ]);
    let row = component.get("v.row");
    let leaseNumber = component.get("v.leaseNumber");
   
    console.log('row is: ' + row);
    console.log('fromnewco is : ' + component.get('v.fromNewco'));
   
     
    if (row) {
      let rowRecord = JSON.parse(row);
      component.set("v.selectedRowObj", rowRecord);
      component.set("v.leaseNumber", rowRecord.contractNumber);
    }

    helper.getEnvSettingsHelper(component);
   

    if (!row) {
      console.log('not row');
      helper.fetchData(component).then(data => {
        component.set("v.row", JSON.stringify(data));
        component.set("v.selectedRowObj", data);
        console.log('call 1');
        helper.getLeaseDetailsHelper(component, JSON.stringify(data));
      
        Promise.all([
          helper.generateQuoteByTypeHelper(component,"TRADEUP_WITHOUT_PURCHASE"),
          helper.generateQuoteByTypeHelper(component, "TRADEUP_WITH_PURCHASE")
        ]).then(() => {
         
          let quoteData = component.get("v.tradeUpWithoutPurchase");
          let quoteData2 = component.get("v.tradeUpWithPurchase");

          if (quoteData && quoteData2) {
            let data = JSON.parse(JSON.stringify(quoteData));
            helper.getQuoteDetailsHelper(component, data.quoteNumber, 1);

            let data2 = JSON.parse(JSON.stringify(quoteData2));
            helper.getQuoteDetailsHelper(component, data2.quoteNumber, 2);

            const tableData = [];
            let obj = {
              quoteType: quoteData.terminationQuoteType,
              quoteAmount: quoteData.amount,
              quoteNumber: quoteData.quoteNumber,
              quoteNumberDisplay: quoteData.quoteNumber.split("TU")[1],
              leaseNumber: component.get("v.leaseNumber")
              };
            let obj2 = {
              quoteType: quoteData2.terminationQuoteType,
              quoteAmount: quoteData2.amount,
              quoteNumber: quoteData2.quoteNumber,
              quoteNumberDisplay: quoteData2.quoteNumber.split("TU")[1],
              leaseNumber: component.get("v.leaseNumber")
              };
            tableData.push(obj);
            tableData.push(obj2);
            component.set("v.quoteSummaryData", tableData);
         }  
          else {
              component.find("notifLib").showToast({
                title: "Something went wrong, please refresh!",
                variant: "error",
                showCloseButton: true
              });
          }
        });
      });
    } else {
      console.log('in row');
      console.log('call 1a');
      helper.getLeaseDetailsHelper(component, row);
      console.log('hello');
      Promise.all([
        helper.generateQuoteByTypeHelper(component,"TRADEUP_WITHOUT_PURCHASE"),
        helper.generateQuoteByTypeHelper(component, "TRADEUP_WITH_PURCHASE")
      ]).then(() => {
        
        let quoteData = component.get("v.tradeUpWithoutPurchase");
        let quoteData2 = component.get("v.tradeUpWithPurchase");
        
        if (quoteData && quoteData2) { 
           
            let data = JSON.parse(JSON.stringify(quoteData));
            helper.getQuoteDetailsHelper(component, data.quoteNumber, 1);

            let data2 = JSON.parse(JSON.stringify(quoteData2));
            helper.getQuoteDetailsHelper(component, data2.quoteNumber, 2);

            const tableData = [];
            var qDisplay;
            var qDisplay2;
            if (component.get('v.fromNewco') == true){
                qDisplay = quoteData.quoteNumber;
                qDisplay2 = quoteData2.quoteNumber;
            }
            else{
                qDisplay = quoteData.quoteNumber.split("TU")[1];
                qDisplay2 = quoteData2.quoteNumber.split("TU")[1];
            }
            let obj = {
              quoteType: quoteData.terminationQuoteType,
              quoteAmount: quoteData.amount,
              quoteNumber: qDisplay,
              quoteNumberDisplay: qDisplay,
              leaseNumber: component.get("v.leaseNumber")
            };
            let obj2 = {
              quoteType: quoteData2.terminationQuoteType,
              quoteAmount: quoteData2.amount,
              quoteNumber: qDisplay2,
              quoteNumberDisplay: qDisplay2,
              leaseNumber: component.get("v.leaseNumber")
            };
            tableData.push(obj);
            tableData.push(obj2);
            component.set("v.quoteSummaryData", tableData);
        } else {
           component.find("notifLib").showToast({
            title: "Something went wrong, please refresh!",
            variant: "error",
            showCloseButton: true
          });
        }
      });  //promise all
    }
  },

  handleRowAction: function(component, event, helper) {
    var rowAction = event.getParam("action");
    var row = event.getParam("row");

    switch (rowAction.name) {
      case "details":
        component.set("v.selectedRow", JSON.stringify(row));
        helper.getQuoteDetailsHelper(component);
    }
  },
  onQuoteSelect: function(component, event, helper) {
    var selected = event.getSource().get("v.text");
    var quotes = component.get("v.quoteSummaryData");

    var q;
    for (var x in quotes) {
      if (quotes[x].quoteNumber === selected) {
        q = quotes[x];
        var row = JSON.parse(JSON.stringify(component.get("v.selectedRowObj")));
        q.leaseDetails = row;
        if (q.Id == component.get("v.quoteId")) {
          q.expirationDate = component.get("v.expirationDate");
          q.Id = component.get("v.quoteId");
        } else {
          q.expirationDate = component.get("v.expirationDate2");
          q.Id = component.get("v.quoteId2");
        }
        component.set("v.selectedTradeUp", q);
        break;
      }
    }
  },
  sendSupportEmail: function(component, event, helper) {
    const textBody = component.get("v.body");
    if (!textBody) return;

    const quoteId = JSON.parse(JSON.stringify(component.get("v.quoteId")));
    const quoteId2 = JSON.parse(JSON.stringify(component.get("v.quoteId2")));
    let settings = component.get("v.settings");
    const baseUrl = `${settings.URL__c}/lightning/r/Lease_OLM_Quote__c/`;

    const subject = "Quote Support";

    const body = `${textBody}
    <p> </p>
    <p>Related Quotes: </p>
    <p>${baseUrl}${quoteId}/view</p>
    <p>${baseUrl}${quoteId2}/view</p>`;

    helper.emailSupport(component, subject, body);
    return;
  },
  contactSupport: function(component, event, helper) {
    component.set("v.showSupport", true);
    return;
  },

  returnToQuote: function(component, event, helper) {
    component.set("v.showSupport", false);
    return;
  },

  emailQuote: function(component, event, helper) {
    let quoteLeaseData = JSON.parse(component.get("v.quoteLeaseData"));
    let leaseNumber = component.get("v.leaseNumber");
    let quoteSummaryData = JSON.parse(
      JSON.stringify(component.get("v.quoteSummaryData"))
    );
    let quoteData = JSON.parse(JSON.stringify(component.get("v.quoteData")));
    let quoteData2 = JSON.parse(JSON.stringify(component.get("v.quoteData2")));
    if (!quoteLeaseData) return;

    let subject = `Quote for ${quoteLeaseData.customerName} - ${leaseNumber}`;

    let equipmentInformationBody = "";
    quoteLeaseData.assetDetail.map(el => {
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
          el.Install_Date
            ? $A.localizationService.formatDate(el.Install_Date, "MM/DD/YYYY")
            : ""
        }</p>
      </td>
      <td style="width: 16.67%;">
        <p>${el.assetAddressLine1}, ${
        el.assetAddressLine2 ? el.assetAddressLine2 + ", " : ""
      }</p>
        <p>${el.assetCity}, ${el.assetState} ${el.assetZipCode}</p>
      </td>
    </tr>`;
    });

    let body = `
    <p><strong>Customer Name: </strong>${quoteLeaseData.customerName}</p>
<p><strong>Quote Date: </strong>${$A.localizationService.formatDate(
      new Date(),
      "MM/DD/YYYY"
    )}</p>
<p><strong>Lease Number: </strong>${quoteLeaseData.contractNumber}</p>
<p><strong>Contract Summary:</strong></p>
<table style="width: 100%; border: 1px solid black">
  <tbody>
    <tr>
      <td style="width: 12.5%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><u>Type</u></p>
      </td>
      <td style="width: 12.5%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><u>Term</u></p>
      </td>
      <td style="width: 12.5%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><u>Contract Origination Date</u></p>
      </td>
      <td style="width: 12.5%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><u>Contract Maturity Date</u></p>
      </td>
      <td style="width: 12.5%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><u>Days Delinquent</u></p>
      </td>
      <td style="width: 12.5%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><u>Pmt. Remaining</u></p>
      </td>
      <td style="width: 12.5%; background-color: #f2f2f2; border-bottom: 1px solid black">
        <p><u>Equipment Payment</u></p>
      </td>
      <td style="width: 12.5%; background-color: #f2f2f2; border-bottom: 1px solid black">
        <p><u>Service Payment</u></p>
      </td>
    </tr>
    <tr>
      <td style="width: 12.5%; border-right: 1px solid black">
        <p>${quoteLeaseData.contractType}</p>
      </td>
      <td style="width: 12.5%; border-right: 1px solid black">
        <p>${quoteLeaseData.contractTerm}</p>
      </td>
      <td style="width: 12.5%; border-right: 1px solid black">
        <p>${$A.localizationService.formatDate(
          quoteLeaseData.contractStartDate,
          "MM/DD/YYYY"
        )}</p>
      </td>
      <td style="width: 12.5%; border-right: 1px solid black">
        <p>${$A.localizationService.formatDate(
          quoteLeaseData.contractExpireDate,
          "MM/DD/YYYY"
        )}</p>
      </td>
      <td style="width: 12.5%; border-right: 1px solid black">
        <p>${quoteLeaseData.Dayspastdue}</p>
      </td>
      <td style="width: 12.5%; border-right: 1px solid black">
        <p>${quoteLeaseData.numberOfRemainingPayments}</p>
      </td>
      <td style="width: 12.5%;">
        <p>${Number(quoteLeaseData.contractPayment).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
      <td style="width: 12.5%;">
        <p>${Number(quoteLeaseData.contractService).toLocaleString("en", {
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
      <td style="width: 16.67%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><u>Asset #</u></p>
      </td>
      <td style="width: 16.67%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><u>Make</u></p>
      </td>
      <td style="width: 16.67%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><u>Model</u></p>
      </td>
      <td style="width: 16.67%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><u>Serial #</u></p>
      </td>
      <td style="width: 16.67%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><u>Install Date</u></p>
      </td>
      <td style="width: 16.67%; background-color: #f2f2f2;">
        <p><u>Equipment Location Address</u></p>
      </td>
    </tr>
    ${equipmentInformationBody}
  </tbody>
</table>
<p><strong>Quote Details:</strong></p>
<table style="width: 100%; border: 1px solid black">
  <tbody>
    <tr>
      <td style="width: 20%; border-right: 1px solid black; border-bottom: 1px solid black">&nbsp;</td>
      <td style="width: 40%; background-color: #f2f2f2; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><u>${quoteSummaryData[0].quoteType}</u></p>
      </td>
      <td style="width: 40%; background-color: #f2f2f2; border-bottom: 1px solid black">
        <p><u>${quoteSummaryData[1].quoteType}</u></p>
      </td>
    </tr>
    <tr>
      <td style="width: 20%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><strong>Quote Amount</strong></p>
      </td>
      <td style="width: 40%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p>${Number(quoteSummaryData[0].quoteAmount).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
      <td style="width: 40%; border-bottom: 1px solid black">
        <p>${Number(quoteSummaryData[1].quoteAmount).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
    </tr>
    <tr>
      <td style="width: 20%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><strong>Quote Number</strong></p>
      </td>
      <td style="width: 40%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p>${quoteSummaryData[0].quoteNumber.split("TU")[1]}</p>
      </td>
      <td style="width: 40%; border-bottom: 1px solid black">
        <p>${quoteSummaryData[1].quoteNumber.split("TU")[1]}</p>
      </td>
    </tr>
    <tr>
      <td style="width: 20%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><strong>Lease Number</strong></p>
      </td>
      <td style="width: 40%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p>${quoteLeaseData.contractNumber}</p>
      </td>
      <td style="width: 40%; border-bottom: 1px solid black">
        <p>${quoteLeaseData.contractNumber}</p>
      </td>
    </tr>
    <tr>
      <td style="width: 20%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><strong>Remaining Lease Payments</strong></p>
      </td>
      <td style="width: 40%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p>${Number(quoteData.Remaining_Rental_Payments__c).toLocaleString(
          "en",
          {
            style: "currency",
            currency: "USD"
          }
        )}</p>
      </td>
      <td style="width: 40%; border-bottom: 1px solid black">
        <p>${Number(quoteData2.Remaining_Rental_Payments__c).toLocaleString(
          "en",
          {
            style: "currency",
            currency: "USD"
          }
        )}</p>
      </td>
    </tr>
    <tr>
      <td style="width: 20%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><strong>Trade-up Discount with Purchase</strong></p>
      </td>
      <td style="width: 40%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p>${Number(quoteData.Discount__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
      <td style="width: 40%; border-bottom: 1px solid black">
        <p>${Number(quoteData2.Discount__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
    </tr>
    <tr>
      <td style="width: 20%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><strong>Equipment Price</strong></p>
      </td>
      <td style="width: 40%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p>${Number(quoteData.Equipment_Price__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
      <td style="width: 40%; border-bottom: 1px solid black">
        <p>${Number(quoteData2.Equipment_Price__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
    </tr>
    <tr>
      <td style="width: 20%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><strong>Sales Tax</strong></p>
      </td>
      <td style="width: 40%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p>${Number(quoteData.Sales_Tax__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
      <td style="width: 40%; border-bottom: 1px solid black">
        <p>${Number(quoteData2.Sales_Tax__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
    </tr>
    <tr>
      <td style="width: 20%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><strong>Property Tax Reimbursement</strong></p>
      </td>
      <td style="width: 40%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p>${Number(quoteData.Property_Tax__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
      <td style="width: 40%; border-bottom: 1px solid black">
        <p>${Number(quoteData2.Property_Tax__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
    </tr>
    <tr>
      <td style="width: 20%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><strong>Past Due Service and Meter Overage</strong></p>
      </td>
      <td style="width: 40%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p>${Number(quoteData.Past_Due_Service__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
      <td style="width: 40%; border-bottom: 1px solid black">
        <p>${Number(quoteData2.Past_Due_Service__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
    </tr>
    <tr>
      <td style="width: 20%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><strong>Outstanding Lease Charges</strong></p>
      </td>
      <td style="width: 40%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p>${Number(quoteData.Remaining_Rental_Payments__c).toLocaleString(
          "en",
          {
            style: "currency",
            currency: "USD"
          }
        )}</p>
      </td>
      <td style="width: 40%; border-bottom: 1px solid black">
        <p>${Number(quoteData2.Remaining_Rental_Payments__c).toLocaleString(
          "en",
          {
            style: "currency",
            currency: "USD"
          }
        )}</p>
      </td>
    </tr>
    <tr>
      <td style="width: 20%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p><strong>Security Deposit</strong></p>
      </td>
      <td style="width: 40%; border-right: 1px solid black; border-bottom: 1px solid black">
        <p>${Number(quoteData.Security_Deposit__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
      <td style="width: 40%; border-bottom: 1px solid black">
        <p>${Number(quoteData2.Security_Deposit__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
    </tr>
    <tr>
      <td style="width: 20%; border-right: 1px solid black">
        <p><strong>Net Trade-up Amount</strong></p>
      </td>
      <td style="width: 40%; border-right: 1px solid black">
        <p>${Number(quoteData.Amount__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
      <td style="width: 40%;">
        <p>${Number(quoteData2.Amount__c).toLocaleString("en", {
          style: "currency",
          currency: "USD"
        })}</p>
      </td>
    </tr>
    <tr>
      <td style="width: 20%; border-right: 1px solid black">
        <p><strong>Quote Expiration Date</strong></p>
      </td>
      <td style="width: 40%; border-right: 1px solid black">
        <p>${$A.localizationService.formatDate(
          quoteData.Quote_Validity_Date__c,
          "MM/DD/YYYY"
        )}</p>
      </td>
      <td style="width: 40%;">
        <p>${$A.localizationService.formatDate(
          quoteData2.Quote_Validity_Date__c,
          "MM/DD/YYYY"
        )}</p>
      </td>
    </tr>
  </tbody>
</table>`;

    helper.emailTearSheetOrQuoteHelper(component, subject, body);
    return;
  },

  contactSupport: function(component, event, helper) {
    component.set("v.showSupport", true);
    return;
  },

  returnToQuote: function(component, event, helper) {
    component.set("v.showSupport", false);
    return;
  },

  closeModal: function(component, event, helper) {
    component.set("v.isQuoteModuleVisible", false);
    return;
  },

  showCreditApproval: function(component, event, helper) {
    helper.handleShowCreditApproval(component);
    // add helper to save PDF
  },

  requoteApplicationController: function(component, event, helper) {
    helper.requoteApplicationHelper(component);
  }
});