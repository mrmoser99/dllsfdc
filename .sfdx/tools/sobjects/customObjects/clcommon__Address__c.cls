// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Address__c {
    global Id Id;
    global SObject Owner;
    global Id OwnerId;
    global Boolean IsDeleted;
    global String Name;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global String clcommon__City__c;
    global String clcommon__Country__c;
    global String clcommon__County__c;
    global String clcommon__State_Province__c;
    global String clcommon__Street_Address__c;
    global String clcommon__Zip_Code__c;
    global Contact clcommon__Contact__r;
    global Id clcommon__Contact__c;
    /* This field is to be added to capture the additional address line.
    */
    global String clcommon__Address_Line_2__c;
    /* This checkbox is to identify the address as billing address.
    */
    global Boolean clcommon__Billing_Address__c;
    /* This checkbox is to identify the “Current address” .
    */
    global Boolean clcommon__Current_Address__c;
    /* This field will store the time spent at a particular address. This is the end month and year.
    */
    global Date clcommon__End_Date__c;
    /* This field is to capture the foreign city postal code related to the address, if address is not local.
    */
    global String clcommon__Foreign_City_Postal_Code__c;
    /* This checkbox is to identify the address as mailing address.
    */
    global Boolean clcommon__Mailing_Address__c;
    /* This field is to identify if the address is a Military Address.
    */
    global Boolean clcommon__Military_Address__c;
    /* This field will store the Army Post Office or Fleet Post Office Box number if the address is a military address.
    */
    global String clcommon__Military_Post_Office_Box__c;
    /* This field will store the postal service center if the address is a military address.
    */
    global String clcommon__Military_Postal_Service_Center__c;
    /* This checkbox is to identify an address as Previous address.
    */
    global Boolean clcommon__Other_Address__c;
    /* This checkbox is to identify an address as Previous address.
    */
    global Boolean clcommon__Previous_Address__c;
    /* This checkbox is to identify the address as primary address.
    */
    global Boolean clcommon__Primary_Address__c;
    /* This checkbox is to identify the address as shipping address.
    */
    global Boolean clcommon__Shipping_Address__c;
    /* This field will store the time spent at a particular address. This is the start month and year.
    */
    global Date clcommon__Start_Date__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<clcommon__Address__Share> Shares;
    global List<clcommon__Bank__c> clcommon__Banks__r;
    global List<clcommon__Bill_Group__c> clcommon__Bill_Groups__r;
    global List<clcommon__Billing_Group__c> clcommon__Billing_Groups__r;
    global List<clcommon__Invoice__c> clcommon__Invoices__r;
    global List<cllease__Lease_Account__c> cllease__LS_Contracts__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Address__c () 
    {
    }
}