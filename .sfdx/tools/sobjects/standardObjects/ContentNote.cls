// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ContentNote {
    global Id Id;
    global String Title;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastViewedDate;
    global String FileType;
    global String TextPreview;
    global Integer ContentSize;
    global Boolean IsDeleted;
    global String FileExtension;
    global ContentVersion LatestPublishedVersion;
    global Id LatestPublishedVersionId;
    global User Owner;
    global Id OwnerId;
    global Blob Content;
    global Boolean IsReadOnly;
    global String SharingPrivacy;
    global List<FlowRecordRelation> RelatedRecord;

    global ContentNote () 
    {
    }
}