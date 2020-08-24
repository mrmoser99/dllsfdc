// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Data_Archive_Configuration__c {
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
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    /* To indicate whether to process this configuration or not automatically.
    */
    global Boolean clcommon__Active__c;
    /* This field is used to store the number of days beyond which records must be archived. In other words, if this field says 'n' days, any transaction older than 'n' days must be archived.
    */
    global Double clcommon__Archive_Data_Older_Than__c;
    /* Flag to indicate to archive the detail object records of for which this object is the master object. If the object is archived fully no summary records will be created.
    */
    global Boolean clcommon__Archive_Detail_Object_Fully__c;
    /* Batch Size for the Data Archival Job which is going to process this configuration.
    */
    global Double clcommon__Batch_Size__c;
    /* This field is used to indicate if a summary transaction must be created for the just archived transactions. Note that for any object only one summary transaction is maintained at any time. Only applicable where Is_Master_Object_Record__c is False
    */
    global Boolean clcommon__Create_Summary_Transaction__c;
    /* Fully Qualified class name to handle the summary record creation for archived record.
    */
    global String clcommon__Custom_Summary_Class__c;
    /* Field to indicate when was last time archiving for this configuration record was completed successfully.
    */
    global Datetime clcommon__Last_Processed_Date_Time__c;
    /* The API name of the object which need to be archived. If the name doesn't contain any namespace prefix then the namespace of the Org will be assumed.
    */
    global String clcommon__Object_Name__c;
    /* This field is used to store the reference to the parent configuration for handling master-detail relationships.
    */
    global clcommon__Data_Archive_Configuration__c clcommon__Parent_Configuration__r;
    /* This field is used to store the reference to the parent configuration for handling master-detail relationships.
    */
    global Id clcommon__Parent_Configuration__c;
    /* The field which points the parent record, this will useful to filter records belonging to same parent and attach summary record to that. Required if Is_Master_Object_Record__c is false and Create_Summary_Transaction__c is TRUE
    */
    global String clcommon__Parent_Relationship_Field_Name__c;
    /* The API name of the date field on the object to be archived which will be used for filtering the object records to be archived.
    */
    global String clcommon__Transaction_Date_Field_API_Name__c;
    /* A Rule set that contains the rules and criteria to filter out the records to be archived.
    */
    global String clcommon__Rule_Set_Name__c;
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
    global List<clcommon__Data_Archive_Configuration__Share> Shares;
    global List<clcommon__Data_Archive_Configuration__c> clcommon__Child_Configurations__r;
    global List<clcommon__Data_Archive_Summary_Field__c> clcommon__Data_Archive_Summary_Fields__r;
    global List<clcommon__Data_Mapping_Configuration__c> clcommon__Data_Mapping_Configurations__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Data_Archive_Configuration__c () 
    {
    }
}