declare module "@salesforce/apex/PM_Controller.__sfdc_searchResults" {
  export default function __sfdc_searchResults(param: {value: any}): Promise<any>;
}
declare module "@salesforce/apex/PM_Controller.__sfdc_searchResults" {
  export default function __sfdc_searchResults(): Promise<any>;
}
declare module "@salesforce/apex/PM_Controller.searchPortfolio" {
  export default function searchPortfolio(param: {customerName: any, customerNumber: any, assetSerialNumber: any, size: any, sortOrder: any, assetDetail: any, page: any}): Promise<any>;
}
declare module "@salesforce/apex/PM_Controller.getLeaseDetails" {
  export default function getLeaseDetails(param: {leaseInfo: any}): Promise<any>;
}
declare module "@salesforce/apex/PM_Controller.generateQuotes" {
  export default function generateQuotes(param: {leaseNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/PM_Controller.generateQuotesSOQL" {
  export default function generateQuotesSOQL(param: {leaseNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/PM_Controller.getQuoteDetail" {
  export default function getQuoteDetail(param: {quoteNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/PM_Controller.processOLMBooking" {
  export default function processOLMBooking(param: {leaseNumber: any, quoteNumber: any, amount: any}): Promise<any>;
}
