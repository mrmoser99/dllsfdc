declare module "@salesforce/apex/FMZ_ApplicationDocumentsController.getApplication" {
  export default function getApplication(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationDocumentsController.getDocuments" {
  export default function getDocuments(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationDocumentsController.uploadAttachment" {
  export default function uploadAttachment(param: {applicationId: any, fileName: any, contentType: any, base64Body: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationDocumentsController.updateApplication" {
  export default function updateApplication(param: {app: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationDocumentsController.deleteDoc" {
  export default function deleteDoc(param: {documentId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationDocumentsController.callCongaTrigger" {
  export default function callCongaTrigger(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationDocumentsController.callCongaTriggerEsign" {
  export default function callCongaTriggerEsign(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationDocumentsController.generateLeaseDocument" {
  export default function generateLeaseDocument(param: {applicationId: any}): Promise<any>;
}
declare module "@salesforce/apex/FMZ_ApplicationDocumentsController.createDocumentAssosiation" {
  export default function createDocumentAssosiation(param: {attId: any}): Promise<any>;
}
