
import { LightningElement, wire, track } from 'lwc';
 
import getLeaseList from "@salesforce/apex/NewcoPortfolioUtility.getLeaseList";

const actions = [
    { label: 'TearSheet', name: 'tear' },
    { label: 'Quote', name: 'quote' }
];

const columns = [
    { label: 'Name', fieldName: 'Name' },

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

    @wire(getLeaseList,  { refreshExecute: "$refreshExecute"}) wired_getLeases({ error, data }) {

        this._wiredLeaseList = [];
        this.leaseDetails = [];
    
        if (data) {
            data.forEach(r => {
                this.leaseDetails.push({
                    Name: r.name
                });
            });
      
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

