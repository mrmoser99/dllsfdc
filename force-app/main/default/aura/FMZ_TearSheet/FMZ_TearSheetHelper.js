({
  initColumns: function(component) {
    component.set("v.columns", [
      { label: "Asset Number", fieldName: "assetNumber", type: "text" },
      { label: "Make", fieldName: "make", type: "text" },
      { label: "Model", fieldName: "model", type: "text" },
      { label: "Serial Number", fieldName: "serialNumber", type: "text" },
      {
        label: "Install Date",
        fieldName: "installationDate",
        type: "text"
      },
      {
        label: "Equipment location address",
        fieldName: "equipmentLocationAddress",
        type: "text"
      }
    ]);
  },

  initFakeData: function(component) {
    // component.set('v.customerName', '12TH STREET CATERING');
    // component.set('v.customerLegalName', 'CATERING INC');
    // component.set('v.creditApplicationNumber', 'FTW-148090');
  },

  fetchData: function(component) {
    component.set("v.isLoading", true);
    
    var leaseDetails;
    console.log('lease details: ' + JSON.stringify(component.get('v.leaseDetails')));
   

    leaseDetails = component.get("v.leaseDetails");
    
    var recordObject = JSON.parse(leaseDetails);
    console.log(recordObject);

    var billingAddress = "";
    if (recordObject.billingAddressLine1 != null) {
      billingAddress += recordObject.billingAddressLine1 + ", ";
    }
    if (recordObject.billingAddressLine2 != null) {
      billingAddress += recordObject.billingAddressLine2 + ", ";
    }
    if (recordObject.billingCity != null) {
      billingAddress += recordObject.billingCity + ", ";
    }
    if (recordObject.billingState != null) {
      billingAddress += recordObject.billingState + ", ";
    }
    if (recordObject.billingZipCode != null) {
      billingAddress += recordObject.billingZipCode;
    }

    var equipmentLocationAddress = "";
    if (recordObject.assetDetail.length != 0) {
      if (recordObject.assetDetail[0].assetAddressLine1 != null) {
        equipmentLocationAddress +=
          recordObject.assetDetail[0].assetAddressLine1 + ", ";
      }
      if (recordObject.assetDetail[0].assetCity != null) {
        equipmentLocationAddress +=
          recordObject.assetDetail[0].assetCity + ", ";
      }
      if (recordObject.assetDetail[0].assetState != null) {
        equipmentLocationAddress +=
          recordObject.assetDetail[0].assetState + ", ";
      }
      if (recordObject.assetDetail[0].assetZipCode != null) {
        equipmentLocationAddress += recordObject.assetDetail[0].assetZipCode;
      }
    }

    // customer information
    component.set("v.customerName", recordObject.customerName);
    component.set("v.accountNumber", recordObject.customerAccount);
    component.set("v.billingAddress", billingAddress);
    component.set("v.equipmentLocationAddress", equipmentLocationAddress);
    component.set("v.leaseSigner", recordObject.contractSigner);

    // general information
    component.set("v.bookedDate", recordObject.contractStartDate);
    component.set("v.maturityDate", recordObject.contractExpireDate);
    component.set("v.term", recordObject.contractTerm);
    component.set(
      "v.remainingPayments",
      recordObject.numberOfRemainingPayments
    );
    component.set("v.purchaseOption", recordObject.Purchaseoption);
    component.set("v.daysDelinquent", recordObject.Dayspastdue);
    component.set("v.leaseStatus", recordObject.Contract_Status);
    component.set("v.preTaxEquipmentPayment", recordObject.contractPayment);
    component.set("v.servicePayment", recordObject.contractService);

    // equipment summary
    var assets = [];
    var asset = {};

    for (var i in recordObject.assetDetail) {
      var arrayAsset = recordObject.assetDetail[i];
      var equipmentLocationAddress = "";
      if (arrayAsset.assetAddressLine1 != null) {
        equipmentLocationAddress += arrayAsset.assetAddressLine1 + ", ";
      }
      if (arrayAsset.assetCity != null) {
        equipmentLocationAddress += arrayAsset.assetCity + ", ";
      }
      if (arrayAsset.assetState != null) {
        equipmentLocationAddress += arrayAsset.assetState + ", ";
      }
      if (arrayAsset.assetZipCode != null) {
        equipmentLocationAddress += arrayAsset.assetZipCode;
      }

      asset = {
        assetNumber: arrayAsset.assetSequenceNumber,
        make: arrayAsset.assetManufacturer,
        model: arrayAsset.assetModel,
        serialNumber: arrayAsset.assetSerialNumber,
        installationDate: arrayAsset.Install_Date
          ? $A.localizationService.formatDate(
              arrayAsset.Install_Date,
              "MM/DD/YYYY"
            )
          : "",
        equipmentLocationAddress: equipmentLocationAddress
      };
      assets.push(asset);
    }

    component.set("v.data", assets);

    component.set("v.isLoading", false);
  },

  fetchDataFromNewco: function(component) {
    component.set("v.isLoading", true);

    //get lease details
    this.getLeaseDetails(component);

    component.set("v.isLoading", false);
  },

  getLeaseDetails: function(component) {

    console.log('getting lease detail for lease number:' + component.get('v.leaseNumber'));     
    
    var leaseDetailsAction = component.get("c.getLeaseDetails");
    leaseDetailsAction.setParams({
      leaseNumber: component.get("v.leaseNumber")
    });
  }
  
});