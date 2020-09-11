declare module "@salesforce/apex/ICNewClaim.getLease" {
  export default function getLease(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/ICNewClaim.save" {
  export default function save(param: {recordId: any, eList: any}): Promise<any>;
}
declare module "@salesforce/apex/ICNewClaim.createClaim" {
  export default function createClaim(param: {recordId: any, claim: any, eList: any, notes: any}): Promise<any>;
}
