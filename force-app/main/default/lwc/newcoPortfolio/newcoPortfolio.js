
import { LightningElement, wire, track } from 'lwc';
 
import getLeaseList from "@salesforce/apex/NewcoPortfolioUtility.getLeaseList";

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

    @track leaseDetails; 
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
        console.log('ready to call quote');
        const { id } = row;
        const index = this.findRowIndexById(id);
        if (index !== -1) {
            this.data = this.data
                .slice(0, index)
                .concat(this.data.slice(index + 1));
        }
    }

    findRowIndexById(id) {
        let ret = -1;
        this.data.some((row, index) => {
            if (row.id === id) {
                ret = index;
                return true;
            }
            return false;
        });
        return ret;
    }

    tear(row) {
        this.record = row;
    }

    @wire(getLeaseList,{ refreshExecute: "$refreshExecute"}) 
        wired_getLeases({ error, data }) {

            this._wiredLeaseList = [];
            this.leaseDetails = [];
            //need to flatten to display for relationship fields
            this.data = data;
            if (this.data) {
                let preparedLeases = [];
                this.data.forEach(lease => {
                    let preparedLease = {};
                    preparedLease.id = lease.id;
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
                this.leaseDetails = preparedLeases;
                this.loading = false;
            } else if (error) {  
                this.error = error; 
            }
        }


    onRefresh(){
     
        var today = new Date();
        this.loading = true;
        this.refreshExecute  = today.getSeconds() + today.getMilliseconds();
    }

    getLoading(){
        return this.loading;
    }
}

