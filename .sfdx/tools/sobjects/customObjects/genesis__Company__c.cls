// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Company__c {
    global Id Id;
    global SObject Owner;
    global Id OwnerId;
    global Boolean IsDeleted;
    global String Name;
    global RecordType RecordType;
    global Id RecordTypeId;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    /* Company ID
    */
    global String genesis__Company_ID__c;
    /* Default company, this will be populated for all records
    */
    global Boolean genesis__Default__c;
    global Boolean genesis__Enabled_Flag__c;
    global genesis__Branch_Location__c genesis__Location__r;
    global Id genesis__Location__c;
    /* This is the company that owns enough voting stock in another firm to control management and operations by influencing or electing its board of directors.
    */
    global genesis__Company__c genesis__Parent_Company__r;
    /* This is the company that owns enough voting stock in another firm to control management and operations by influencing or electing its board of directors.
    */
    global Id genesis__Parent_Company__c;
    /* Short Name
    */
    global String genesis__Short_Name__c;
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
    global List<genesis__Applications__c> genesis__Applications__r;
    global List<genesis__Batch_Process_Log__c> genesis__Batch_Process_Log__r;
    global List<genesis__Company__Share> Shares;
    global List<genesis__Company__c> genesis__Companies__r;
    global List<genesis__Quick_Quotes__c> genesis__Quick_Quotes__r;
    global List<genesis__Rate_Card_Setup_Header__c> genesis__Rate_Card_Setup__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Company__c () 
    {
    }
}