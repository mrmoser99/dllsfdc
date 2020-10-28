declare module "@salesforce/apex/FMZ_ApplicationLocationsController.getLocations" {
  export default function getLocations(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationLocationsController.getAppAccount" {
  export default function getAppAccount(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationLocationsController.search" {
  export default function search(param: {searchTerm: any, selectedIds: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationLocationsController.addLocation" {
  export default function addLocation(param: {applicationId: any, addressString: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationLocationsController.deleteLocation" {
  export default function deleteLocation(param: {addressId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationLocationsController.updateLocation" {
  export default function updateLocation(param: {addressString: any}): Promise<any>;
}
