declare module "@salesforce/apex/FMZ_PortfolioManager.getData" {
  export default function getData(param: {customerName: any, contractNumber: any, assetSerialNumber: any, size: any, sortOrder: any, assetDetail: any, page: any, disableLogging: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_PortfolioManager.getLeaseDetails" {
  export default function getLeaseDetails(param: {leaseNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_PortfolioManager.getLeaseDetailsNewco" {
  export default function getLeaseDetailsNewco(param: {leaseNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_PortfolioManager.generateQuoteByType" {
  export default function generateQuoteByType(param: {leaseNumber: any, type: any, customerName: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_PortfolioManager.generateQuoteByTypeNewco" {
  export default function generateQuoteByTypeNewco(param: {leaseNumber: any, type: any, customerName: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_PortfolioManager.getQuoteDetails" {
  export default function getQuoteDetails(param: {quoteNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_PortfolioManager.getQuoteDetailsNewco" {
  export default function getQuoteDetailsNewco(param: {quoteNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_PortfolioManager.emailTearSheetOrQuote" {
  export default function emailTearSheetOrQuote(param: {subject: any, body: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_PortfolioManager.emailSupport" {
  export default function emailSupport(param: {subject: any, body: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_PortfolioManager.requoteApplication" {
  export default function requoteApplication(param: {applicationId: any, leaseNumber: any, quoteAmount: any, quoteNumber: any, quoteExpirationDate: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_PortfolioManager.getEnvVariables" {
  export default function getEnvVariables(): Promise<any>;
}
declare module "@salesforce/apex/FMZ_PortfolioManager.getQuoteHistory" {
  export default function getQuoteHistory(param: {pageSize: any, offset: any, customerName: any, leaseNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_PortfolioManager.getQuickQuote" {
  export default function getQuickQuote(param: {leaseNumber: any}): Promise<any>;
}
