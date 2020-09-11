declare module "@salesforce/apex/FMZ_ApplicationServiceAndFeesController.getPicklistOptions" {
  export default function getPicklistOptions(param: {fieldName: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationServiceAndFeesController.getEquipmentOptions" {
  export default function getEquipmentOptions(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationServiceAndFeesController.getFees" {
  export default function getFees(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationServiceAndFeesController.getApp" {
  export default function getApp(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationServiceAndFeesController.getFeeName" {
  export default function getFeeName(param: {feeDefId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationServiceAndFeesController.search" {
  export default function search(param: {searchTerm: any, selectedIds: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationServiceAndFeesController.addFees" {
  export default function addFees(param: {applicationId: any, feeId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationServiceAndFeesController.addAllFees" {
  export default function addAllFees(param: {fee: any, equipment: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationServiceAndFeesController.deleteFee" {
  export default function deleteFee(param: {appFeeId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationServiceAndFeesController.updateFee" {
  export default function updateFee(param: {feeString: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationServiceAndFeesController.updateApplication" {
  export default function updateApplication(param: {appId: any, customerInsurance: any}): Promise<any>;
}
