declare module "@salesforce/apex/NewcoPortfolioUtility.getLeaseList" {
  export default function getLeaseList(param: {refreshExecute: any}): Promise<any>;
}
declare module "@salesforce/apex/NewcoPortfolioUtility.getQuoteList" {
  export default function getQuoteList(param: {refreshExecute: any}): Promise<any>;
}
declare module "@salesforce/apex/NewcoPortfolioUtility.getLeaseListForPortfolio" {
  export default function getLeaseListForPortfolio(param: {refreshExecute: any}): Promise<any>;
}
declare module "@salesforce/apex/NewcoPortfolioUtility.filterLeaseList" {
  export default function filterLeaseList(param: {searchCustomer: any, searchLease: any, searchSerial: any}): Promise<any>;
}
declare module "@salesforce/apex/NewcoPortfolioUtility.filterQuoteList" {
  export default function filterQuoteList(param: {searchCustomer: any, searchLease: any}): Promise<any>;
}
