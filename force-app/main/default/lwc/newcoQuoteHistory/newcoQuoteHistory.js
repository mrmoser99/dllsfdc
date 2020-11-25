import { LightningElement, wire, track, api } from 'lwc';

import getQuoteList from "@salesforce/apex/NewcoPortfolioUtility.getQuoteList";



const columns = [
    { label: "Quote Number",     initialWidth: 140, fieldName: "NameDisplay",           type: "text", },
    { label: "Customer Name",    initialWidth: 225, fieldName: "Customer_Name__c",      type: "text"},
    { label: "Contract Number",     initialWidth: 150, fieldName: "Contract_Number__c",    type: "text" },
    { label: "Quote Type",       initialWidth: 300, fieldName: "Termination_Quote_Type__c", type: "text"},
    { label: "Quote Amount",     initialWidth: 150, fieldName: "Amount__c",             type: "currency"},
    { label: "Quote Date",       initialWidth: 120, fieldName: "CreatedDate",           type: "date",
        typeAttributes: {
            day: "numeric",
            month: "numeric",
            year: "numeric"
        }
    },
    { label: "Expiration Date",  initialWidth: 120, fieldName: "Quote_Validity_Date__c", type: "date",
        typeAttributes: {
            day: "numeric",
            month: "numeric",
            year: "numeric"
        }
    },
    { label: "Credit Approval Number",  initialWidth: 195, fieldName: "Quick_Quote_Number__c", type: "text"},
    {
      label: "View Detail",
      type: "button",
      initialWidth: 135,
      typeAttributes: {
        label: "View Details",
        name: "viewdetails",
        title: "Click to view quote details"
      }
    },
    {
      label: "Submit to Credit Approval",
      type: "button",
      initialWidth: 210,
      typeAttributes: {
        label: "Submit to Credit Approval",
        name: "submittocredit",
        title: "Click to Submit for Credit Approval"
      }
    }
];

export default class NewcoQuoteHistory extends LightningElement {

    quoteList = [];
    @track refreshExecute = "";
    _wiredQuoteList;

    columns = columns;

    @wire(getQuoteList,{ refreshExecute: "$refreshExecute"}) 
    wired_getQuotes({ error, data }) {
        
        //need to flatten to display for relationship fields
        this.data = data;
        if (this.data) {
            console.log ('refresh execute 2');
            this.loading = true;
            let preparedQuotes = [];
            this.data.forEach(quote => {
                
                let preparedQuote = {};
                console.log(JSON.stringify(quote));
                preparedQuote.Id = quote.Id;
                preparedQuote.NameDisplay = quote.Name;
                preparedQuote.Customer_Name__c = quote.cllease__Contract__r.cllease__Account__r.Name;
                preparedQuote.Contract_Number__c = quote.cllease__Contract__r.Name;
                preparedQuote.Termination_Quote_Type__c = quote.cllease__Quote_Type__c;
                preparedQuote.Amount__c = quote.cllease__Quote_Amount__c;
                preparedQuote.CreatedDate = quote.CreatedDate;
                preparedQuote.Quote_Validity_Date__c = quote.cllease__Effective_To__c;
                preparedQuote.Quick_Quote_Number__c = quote.Quick_Quote_Name__c;
                preparedQuote.Sales_Tax__c = quote.QUOTE_ESTIMATED_SALES_TAX__c;
                preparedQuote.Equipment_Price__c = quote.Equipment_Price__c;
                preparedQuote.Remaining_Rental_Payments__c =  quote.Remaining_Payments__c;
                preparedQuote.Property_Tax__c = quote.QUOTE_ESTIMATED_PROPERTY_TAX__c;
                preparedQuote.Lease_Charges__c = quote.QUOTE_FEE__c;
                preparedQuote.LS_Contract__c = quote.cllease__Contract__r.Name;
                preparedQuote.Discount__c = 0;
                preparedQuote.Security_Deposit__c = 0;
                preparedQuote.Past_Due_Service__c = quote.QUOTE_FEE__c;
         
         
        
                preparedQuotes.push(preparedQuote);
                
            });
            this.quoteList = preparedQuotes;
            this.loading = false;
        } else if (error) {  
            this.error = error; 
        }
    }

    
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'viewdetails':
                this.view(row);
               
                break;
            case 'submittocredit':
                this.tear(row);
                break;
            default:
        }
    }

    view(row) {

        console.log('Display details with lease id: ' + row.Id);

        const lease = row.Id;

        console.log('  Display row: ' + JSON.stringify(row));
    
        const displayViewDetailsEvent = new CustomEvent('viewdetails', {
            detail: { lease, row },
        });
        // Fire the custom event
        this.dispatchEvent(displayViewDetailsEvent);
    }
        
    

    submittocredit(row) {
        this.record = row;

        console.log('ready to call tear sheet with lease id: ' + row.Id);
        const lease = row;
        console.log('lease is  ' + lease);
        const displaySubmitToCreditEvent = new CustomEvent('submittocredit', {
            detail: { lease , row},
        });
        // Fire the custom event
        this.dispatchEvent(displaySubmitToCreditEvent);
    }



}