declare module "@salesforce/apex/BatchUtility.runJob" {
  export default function runJob(): Promise<any>;
}
declare module "@salesforce/apex/BatchUtility.getJobDetails" {
  export default function getJobDetails(param: {refreshExecute: any}): Promise<any>;
}
