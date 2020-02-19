declare module "@salesforce/apex/PM_Controller.searchPortfolio" {
  export default function searchPortfolio(param: {customerName: any, contractNumber: any, assetSerialNumber: any, size: any, sortOrder: any, assetDetail: any, page: any, disableLogging: any}): Promise<any>;
}
declare module "@salesforce/apex/PM_Controller.getLeaseDetailsLeaseFirst" {
  export default function getLeaseDetailsLeaseFirst(param: {leaseInfo: any}): Promise<any>;
}
declare module "@salesforce/apex/PM_Controller.getLeaseDetails" {
  export default function getLeaseDetails(param: {leaseInfo: any}): Promise<any>;
}
declare module "@salesforce/apex/PM_Controller.generateQuotes" {
  export default function generateQuotes(param: {leaseNumber: any}): Promise<any>;
}
