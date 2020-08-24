// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Data_Mapping_Configuration__c {
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
    /* Custom class to write the logic of moving data from Org to an external source.
    */
    global String clcommon__Custom_Mapping_Class_Name__c;
    /* Source Object Data Archival configuration
    */
    global clcommon__Data_Archive_Configuration__c clcommon__Data_Archive_Configuration__r;
    /* Source Object Data Archival configuration
    */
    global Id clcommon__Data_Archive_Configuration__c;
    /* Delete the source object records once the mapping is done successfully.
    */
    global Boolean clcommon__Delete_Source_Object_Archived_Data__c;
    /* External Id
    */
    global String clcommon__External_ID__c;
    /* Only Active mapping configurations will be picked up for processing.
    */
    global Boolean clcommon__Is_Active__c;
    /* Last Successfully processed time, set by the system
    */
    global Datetime clcommon__Last_Successfully_Processed__c;
    /* Target Object Api Name
    */
    global String clcommon__Mapping_Object__c;
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
    global List<clcommon__Data_Mapping_Configuration__Share> Shares;
    global List<clcommon__Data_Mapping_Field_Configuration__c> clcommon__Data_Mapping_Field_Configurations__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Data_Mapping_Configuration__c () 
    {
    }
}