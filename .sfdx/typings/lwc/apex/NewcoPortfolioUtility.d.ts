declare module "@salesforce/apex/NewcoPortfolioUtility.getLeaseList" {
  export default function getLeaseList(param: {refreshExecute: any}): Promise<any>;
}
declare module "@salesforce/apex/NewcoPortfolioUtility.filterLeaseList" {
  export default function filterLeaseList(param: {searchCustomer: any, searchLease: any, searchSerial: any}): Promise<any>;
}
declare module "@salesforce/apex/NewcoPortfolioUtility.getQuotes" {
  export default function getQuotes(param: {leaseId: any}): Promise<any>;
}
