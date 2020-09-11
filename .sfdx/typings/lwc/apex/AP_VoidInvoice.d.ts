declare module "@salesforce/apex/AP_VoidInvoice.void" {
  export default function void(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/AP_VoidInvoice.getCharges" {
  export default function getCharges(param: {invoiceId: any, intOffset: any}): Promise<any>;
}
declare module "@salesforce/apex/AP_VoidInvoice.approve" {
  export default function approve(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/AP_VoidInvoice.getInvoice" {
  export default function getInvoice(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/AP_VoidInvoice.getAdjustments" {
  export default function getAdjustments(param: {invoiceId: any, intOffset: any}): Promise<any>;
}
declare module "@salesforce/apex/AP_VoidInvoice.deleteAdj" {
  export default function deleteAdj(param: {toDelete: any}): Promise<any>;
}
