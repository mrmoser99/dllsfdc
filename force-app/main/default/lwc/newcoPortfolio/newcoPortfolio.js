import { LightningElement, wire, track, api } from 'lwc';
 
import getLeaseList from "@salesforce/apex/NewcoPortfolioUtility.getLeaseList";
import getLeaseListForPortfolio from "@salesforce/apex/NewcoPortfolioUtility.getLeaseListForPortfolio";
import filterLeaseList from "@salesforce/apex/NewcoPortfolioUtility.filterLeaseList";




import { refreshApex } from '@salesforce/apex';

const actions = [
    { label: 'TearSheet', name: 'tear' },
    { label: 'Quote', name: 'quote' }
];


const columns = [
    { label: 'Customer', fieldName: 'CustomerName', wrapText:false, initialWidth: 200}, 
    { label: 'Lease', fieldName: 'contractNumber', initialWidth: 125 },
    { label: '#Assets', fieldName: 'nbrOfAssets', initialWidth: 100 },
    { label: 'Pay Amt', fieldName: 'contractPayment', type: 'currency', initialWidth: 90},
    { label: 'Rem # Pays', fieldName: 'numberOfRemainingPayments', initialWidth: 120 },
    { label: 'Term', fieldName: 'contractTerm',  initialWidth: 80  },
    { label: 'Equipment Address', fieldName: 'assetAddressLine1', initialWidth: 200},
    { label: 'City', fieldName: 'assetCity', initialWidth: 100  },
    { label: 'State', fieldName: 'assetState', initialWidth: 60 },
    { label: 'Zip', fieldName: 'assetZipCode', initialWidth: 90  },
    {
        label: "TearSheet",
        type: "button",
        initialWidth: 110,
        typeAttributes: {
          label: "TearSheet",
          name: "tear",
          title: "Click to generate tear sheet"
        }
     },
     {
        label: "Quote",
        type: "button",
        initialWidth: 100,
        typeAttributes: {
          label: "Quote",
          name: "quote",
          title: "Click to generate quotes",
          class: { fieldName: 'ModeClass' }
        }
      }
   
];





export default class NewcoPortfolio extends LightningElement {   

     
    @track customerName;
    @track leaseNumber;
    @track serialNumber;
    searchCustomer;
    searchLease;
    searchSerial;
    leaseList = [];
    
    csvData = [];
    _wiredLeaseList;
    @track refreshExecute = "";
    @track loading = true;
    @track downLoad = false;
   
    error;
    data = [];
    record = {}; 
    columns = columns;
  
    
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'quote':
                this.quote(row);
               
                break;
            case 'tear':
                this.tear(row);
                break;
            default:
        }
    }

    quote(row) {

        console.log('ready to call quote with lease id: ' + row.contractNumber);

        const lease = row.contractNumber;

        console.log('  quote rqo is row: ' + row);
    
        const displayQuoteEvent = new CustomEvent('displayquote', {
            detail: { lease, row },
        });
        // Fire the custom event
        this.dispatchEvent(displayQuoteEvent);
    }
        
    

    tear(row) {
        this.record = row;

        console.log('ready to call tear sheet with lease id: ' + row.Id);
        const lease = row;
        console.log('lease is  ' + lease);
        const displayTearEvent = new CustomEvent('displaytear', {
            detail: { lease , row},
        });
        // Fire the custom event
        this.dispatchEvent(displayTearEvent);
    }

    @wire(getLeaseList,{ refreshExecute: "$refreshExecute"}) 
        wired_getLeases({ error, data }) {
            
            this._wiredLeaseList = [];
            this.leaseList = [];
            
            //need to flatten to display for relationship fields
            this.data = data;
            if (this.data) {
                console.log ('refresh execute 2');
                this.loading = true;
                let preparedLeases = [];
                this.data.forEach(lease => {
                    let preparedLease = {};
                    preparedLease.Id = lease.Id;
                    preparedLease.CustomerName = lease.cllease__Account__r.Name;
                    preparedLease.contractNumber = lease.Name;
                    preparedLease.contractPayment = lease.Total_Monthly_Payment__c;
                    preparedLease.numberOfRemainingPayments = lease.Remaining_Payments__c;
                    preparedLease.nbrOfAssets = lease.Equipment_Count__c;
                    preparedLease.contractTerm = lease.cllease__Term__c;
                    preparedLease.assetAddressLine1 = lease.Billing_Address_Line_1__c;
                    preparedLease.assetCity = lease.City__c;
                    preparedLease.assetState = lease.State__c;
                    preparedLease.assetZipCode = lease.Zip_Code__c;

                    const leaseStatus = lease.cllease__Lease_Status__c;
                    const pos = leaseStatus.indexOf('ACTIVE');
                    if (pos != -1 || leaseStatus == 'EVERGREEN')
                        preparedLease.ModeClass = 'slds-visible';
                    else
                        preparedLease.ModeClass = 'slds-hidden';
                         
                    preparedLeases.push(preparedLease);
                    
                });
                this.leaseList = preparedLeases;
                this.loading = false;
            } else if (error) {  
                this.error = error; 
            }
        }

     @wire(filterLeaseList,{}) wired_filterLeases({ error, data }) {}

    onRefresh(){
        console.log('on refresh');
        var today = new Date();
        this.loading = true;
        this.refreshExecute  = today.getSeconds() + today.getMilliseconds();
    }

    getLoading(){
        console.log('get loading');
        return this.loading;
    }

   
    handleChange(event){
        

        const field = event.target.name;
        if (field == 'customerName'){
            this.customerName = event.target.value;
           
            console.log('value is: ' + this.customerName);
        }
        else if (field == 'leaseNumber'){
            this.leaseNumber = event.target.value;
            
            console.log('value is: ' + this.leaseNumber);
        }
        else if (field == 'serialNumber'){
            this.serialNumber = event.target.value;
           
            console.log('value is: ' + this.serialNumber);
        }
         
         
    }

    
    handleClick(evt) {
        console.log('handle click');
        this.loading = true;
        new Promise(
            (resolve,reject) => {
                setTimeout(()=> {
                    const allValid = [...this.template.querySelectorAll('lightning-input')]
                        .reduce((validSoFar, inputCmp) => {
                            inputCmp.reportValidity();
                            return validSoFar && inputCmp.checkValidity();
                        }, true);
                    
                    if (allValid) {
                        //alert('All form entries look valid. Ready to submit!');
                        
                        this.searchCustomer = this.customerName;
                        this.searchLease = this.leaseNumber;
                        this.searchSerial = this.serialNumber;
        
                        filterLeaseList({searchCustomer: this.searchCustomer, searchLease: this.searchLease, searchSerial: this.searchSerial})
                        .then(result =>{
                            this.loading = true;
                            let preparedLeases = [];
                            result.forEach(lease => {
                                console.log('lease is: ' + JSON.stringify(lease));
                                let preparedLease = {};

                                preparedLease.Id = lease.Id;
                                preparedLease.CustomerName = lease.cllease__Account__r.Name;
                                preparedLease.contractNumber = lease.Name;
                                preparedLease.contractPayment = lease.Total_Monthly_Payment__c;
                                preparedLease.numberOfRemainingPayments = lease.Remaining_Payments__c;
                                preparedLease.nbrOfAssets = lease.Equipment_Count__c;
                                preparedLease.contractTerm = lease.cllease__Term__c;
                                preparedLease.assetAddressLine1 = lease.Billing_Address_Line_1__c;
                                preparedLease.assetCity = lease.City__c;
                                preparedLease.assetState = lease.State__c;
                                preparedLease.ssetZipCode = lease.Zip_Code__c;
                                preparedLeases.push(preparedLease);
                            
                            });
                            this.leaseList = preparedLeases;
                            this.loading = false;
                        })
                        .catch(error =>{
                            this.errorMsg = error;
                        })
                    } else {
                        alert('Please update the invalid form entries and try again.');
                    }
                resolve();
            }, 2000);
        }).then(
            () => this.loading = false
        );
    }

    @wire(getLeaseListForPortfolio,{ }) wired_getLeasesForPortfolio({ error, data }) {}

    handleDownload(component, event, helper)  {
        console.log('in download newco portfolio');
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

        getLeaseListForPortfolio()
            .then(result =>{
                 
                let preparedAssets = [];
                this.loading = true;
                result.forEach(asset => {
                    
                    let preparedAsset = {};
                    preparedAsset.customerName =asset.cllease__Contract__r.cllease__Account__r.Name;
                    preparedAsset.contractNumber = asset.cllease__Contract__r.Name;
                    
                    preparedAsset.billingAddressLine1 = asset.cllease__Contract__r.Billing_Address_Line_1__c;
                    preparedAsset.billingCity = asset.cllease__Contract__r.City__c;
                    preparedAsset.billingState = asset.cllease__Contract__r.State__c;
                    preparedAsset.billingZipCode = asset.cllease__Contract__r.Zip_Code__c;
                    preparedAsset.contractType = 'STD';
                    preparedAsset.contractTerm = asset.cllease__Contract__r.cllease__Term__c;
                    preparedAsset.contractPeriodicity = asset.cllease__Contract__r.cllease__Evergreen_Frequency__c
                    preparedAsset.contractPurchaseOption = asset.cllease__Contract__r.cllease__Residual_Type__c ;
                    preparedAsset.contractStartDate = asset.cllease__Contract__r.cllease__Commencement_Date__c;
                    preparedAsset.contractExpireDate = asset.cllease__Contract__r.cllease__Maturity_Date__c;
                    preparedAsset.contractOriginalCost = asset.Total_Equipment_Cost__c;
                    preparedAsset.contractPayment = asset.Rent_Amount__c;
                    preparedAsset.contractSigner = asset.cllease__Contract__r.Contract_Signer__c + ' ' + asset.cllease__Contract__r.Contract_Signer_Last_Name__c;
                    preparedAsset.contractSignerTitle = asset.cllease__Contract__r.Contract_Signer_Title__c;
                    preparedAsset.numberOfRemainingPayments = asset.cllease__Contract__r.Remaining_Payments__c;
                    preparedAsset.lastPaymentReceivedDate = asset.cllease__Contract__r.cllease__Last_Payment_Date__c;
                    preparedAsset.assetAddressLine1 = asset.Install_Address_Line_1__c;
                    preparedAsset.assetAddressLine2 = asset.Install_Address_Line_2__c;
                    preparedAsset.assetCity = asset.City_InstallAddress__c;
                    preparedAsset.assetZipCode = asset.Zip_Code_InstallAddress__c; 
                    preparedAsset.assetState = asset.State__c;
                    preparedAsset.assetSequenceNumber = asset.Name;
                    preparedAsset.assetManufacturer = asset.Manufacturer__c
                    preparedAsset.assetModel = asset.cllease__Model__c;
                    preparedAsset.assetSerialNumber = asset.Serial_Number__c;
                    
                    
                  

                    preparedAssets.push(preparedAsset);
                            
                });
                //console.log('download list: ' + preparedAssets);
                this.csvData = preparedAssets;
                let csvStringResult = "";
                csvStringResult += labels.join(columnDivider);
                csvStringResult += lineDivider;
                //console.log('ready to parse');
                for (var i = 0; i < this.csvData.length; i++) {
                    let counter = 0;
        
                    for (var sTempkey in keys) {
                        //console.log('looping thru keys' + sTempkey);
                        var skey = keys[sTempkey];
        
                        if (counter > 0) {
                            csvStringResult += columnDivider;
                        }
                        if (this.csvData[i][skey] == null || this.csvData[i][skey] == undefined) {
                            this.csvData[i][skey] = " ";
                        }
                        csvStringResult += '"' + this.csvData[i][skey] + '"';
                        //console.log('string res: ' + csvStringResult);
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
                this.loading = false;
            });
        
    }
    
}