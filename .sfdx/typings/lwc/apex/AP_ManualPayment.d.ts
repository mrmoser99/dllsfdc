declare module "@salesforce/apex/AP_ManualPayment.addPayment" {
  export default function addPayment(param: {recordId: any, checkNumber: any, checkAmount: any, paymentDate: any, voidPNC: any, notes: any}): Promise<any>;
}
declare module "@salesforce/apex/AP_ManualPayment.addAdjustment" {
  export default function addAdjustment(param: {recordId: any, aType: any, credit: any, chargeId: any, dueId: any, taxAmount: any}): Promise<any>;
}
