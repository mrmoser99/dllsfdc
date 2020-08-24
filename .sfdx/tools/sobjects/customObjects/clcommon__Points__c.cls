// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Points__c {
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
    /* This field points to Accounts of type 'Vendor, Manufacturer, Broker'.
    */
    global Account clcommon__Accounts_Payable__r;
    /* This field points to Accounts of type 'Vendor, Manufacturer, Broker'.
    */
    global Id clcommon__Accounts_Payable__c;
    /* This field contains information whether points have been computed manually or not
    */
    global String clcommon__Computation_Type__c;
    /* This field displays amount based on the Points Override percentage.
    */
    global Double clcommon__Points_Amount_Override__c;
    /* This field displays amount calculated based on points configured.
    */
    global Double clcommon__Points_Amount__c;
    /* This field displays override points by User.
    */
    global Double clcommon__Points_Override__c;
    /* This field displays the type of Points which will be configured.
    */
    global String clcommon__Points_Type__c;
    /* This field displays points percentage configured against each points name in the Points Setup.
    */
    global Double clcommon__Points__c;
    /* This field points to Application.
    */
    global genesis__Applications__c genesis__Application__r;
    /* This field points to Application.
    */
    global Id genesis__Application__c;
    /* This field refers to Points Setup object
    */
    global clcommon__Points_Setup__c genesis__Points_Setup__r;
    /* This field refers to Points Setup object
    */
    global Id genesis__Points_Setup__c;
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
    global List<clcommon__Points__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Points__c () 
    {
    }
}