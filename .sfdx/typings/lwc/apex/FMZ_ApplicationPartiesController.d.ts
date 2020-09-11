declare module "@salesforce/apex/FMZ_ApplicationPartiesController.getParties" {
  export default function getParties(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationPartiesController.search" {
  export default function search(param: {searchTerm: any, selectedIds: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationPartiesController.addParty" {
  export default function addParty(param: {applicationId: any, accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationPartiesController.deleteParty" {
  export default function deleteParty(param: {appPartyId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationPartiesController.updateParty" {
  export default function updateParty(param: {appPartyString: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationPartiesController.getPicklistOptions" {
  export default function getPicklistOptions(param: {fieldName: any}): Promise<any>;
}
