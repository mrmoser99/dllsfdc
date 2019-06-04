declare module "@salesforce/apex/PM_Controller.searchPortfolio" {
  export default function searchPortfolio(param: {customerName: any, customerNumber: any, assetSerialNumber: any, size: any, sortOrder: any, assetDetail: any, page: any}): Promise<any>;
}
declare module "@salesforce/apex/PM_Controller.getLeaseDetails" {
  export default function getLeaseDetails(param: {leaseInfo: any}): Promise<any>;
}
declare module "@salesforce/apex/PM_Controller.generateQuotes" {
  export default function generateQuotes(param: {leaseNumber: any}): Promise<any>;
}
