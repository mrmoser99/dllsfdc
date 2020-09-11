declare module "@salesforce/apex/CD_ManualController.approveApplication" {
  export default function approveApplication(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/CD_ManualController.declineApplication" {
  export default function declineApplication(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/CD_ManualController.rescoreApplication" {
  export default function rescoreApplication(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/CD_ManualController.rejectLOS" {
  export default function rejectLOS(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/CD_ManualController.chooseLOS" {
  export default function chooseLOS(param: {leId: any}): Promise<any>;
}
