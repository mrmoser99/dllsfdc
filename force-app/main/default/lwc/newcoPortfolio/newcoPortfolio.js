import { LightningElement, wire, track, api } from 'lwc';
 
import getLeaseList from "@salesforce/apex/NewcoPortfolioUtility.getLeaseList";
import filterLeaseList from "@salesforce/apex/NewcoPortfolioUtility.filterLeaseList";
import getQuotes from "@salesforce/apex/NewcoPortfolioUtility.getQuotes";



import { refreshApex } from '@salesforce/apex';

const actions = [
    { label: 'TearSheet', name: 'tear' },
    { label: 'Quote', name: 'quote' }
];


const columns = [
    { label: 'Customer', fieldName: 'CustomerName' }, 
    { label: 'Lease Number', fieldName: 'Name' },
    { label: 'Equip Count', fieldName: 'Equipment_Count__c' },
    { label: 'Payment', fieldName: 'Total_Monthly_Payment__c', type: 'currency'},
    { label: 'Remaining Payments', fieldName: 'Remaining_Payments__c' },
    { label: 'Term', fieldName: 'cllease__Term__c' },
    { label: 'Address', fieldName: 'Billing_Address_Line_1__c' },
    { label: 'City', fieldName: 'City__c' },
    { label: 'State', fieldName: 'State__c' },
    { label: 'Zip', fieldName: 'Zip_Code__c' },

    {
        type: 'action',
        typeAttributes: { rowActions: actions }
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
    _wiredLeaseList;
    @track refreshExecute = "";
    @track loading = false;
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

        console.log('ready to call quote with lease id: ' + row.Id);
        
    }


    tear(row) {
        this.record = row;
    }

    @wire(getLeaseList,{ refreshExecute: "$refreshExecute"}) 
        wired_getLeases({ error, data }) {

            this._wiredLeaseList = [];
            this.leaseList = [];
             
            //need to flatten to display for relationship fields
            this.data = data;
            if (this.data) {
                let preparedLeases = [];
                this.data.forEach(lease => {
                    let preparedLease = {};
                    preparedLease.Id = lease.Id;
                    preparedLease.CustomerName = lease.cllease__Account__r.Name;
                    preparedLease.Name = lease.Name;
                    preparedLease.Total_Monthly_Payment__c = lease.Total_Monthly_Payment__c;
                    preparedLease.Remaining_Payments__c = lease.Remaining_Payments__c;
                    preparedLease.Equipment_Count__c = lease.Equipment_Count__c;
                    preparedLease.cllease__Term__c = lease.cllease__Term__c;
                    preparedLease.Billing_Address_Line_1__c = lease.Billing_Address_Line_1__c;
                    preparedLease.City__c = lease.City__c;
                    preparedLease.State__c = lease.State__c;
                    preparedLease.Zip_Code__c = lease.Zip_Code__c;
                    preparedLeases.push(preparedLease);
                    
                });
                this.leaseList = preparedLeases;
                this.loading = false;
            } else if (error) {  
                this.error = error; 
            }
        }

     @wire(filterLeaseList,{searchCustomer: "$searchCustomer", searchLease: "$searchLease", searchSerial: '"$searchSerial'}) 
        wired_filterLeases({ error, data }) {}

    onRefresh(){
     
        var today = new Date();
        this.loading = true;
        this.refreshExecute  = today.getSeconds() + today.getMilliseconds();
    }

    getLoading(){
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
                    console.log('in result');
                    let preparedLeases = [];
                    result.forEach(lease => {
                        let preparedLease = {};
                        preparedLease.Id = lease.Id;
                        preparedLease.CustomerName = lease.cllease__Account__r.Name;
                        preparedLease.Name = lease.Name;
                        preparedLease.Total_Monthly_Payment__c = lease.Total_Monthly_Payment__c;
                        preparedLease.Remaining_Payments__c = lease.Remaining_Payments__c;
                        preparedLease.Equipment_Count__c = lease.Equipment_Count__c;
                        preparedLease.cllease__Term__c = lease.cllease__Term__c;
                        preparedLease.Billing_Address_Line_1__c = lease.Billing_Address_Line_1__c;
                        preparedLease.City__c = lease.City__c;
                        preparedLease.State__c = lease.State__c;
                        preparedLease.Zip_Code__c = lease.Zip_Code__c;
                        preparedLeases.push(preparedLease);
                    
                    });
                    this.leaseList = preparedLeases;
                   
                })
                .catch(error =>{
                    this.errorMsg = error;
                     
                })
            } else {
                alert('Please update the invalid form entries and try again.');
            }
       }
    
}