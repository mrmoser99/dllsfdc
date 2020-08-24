// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Mapping_Header__c {
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
    /* If active, batch job will pick this record for processing.
    */
    global Boolean clcommon__Active__c;
    /* Size of a batch to be used by each header job thread.
    */
    global Double clcommon__Batch_Size__c;
    /* Source Criteria query which will be used to form a source record set to perform Data Mapping.
    */
    global clcommon__Dynamic_Query__c clcommon__Dynamic_Query__r;
    /* Source Criteria query which will be used to form a source record set to perform Data Mapping.
    */
    global Id clcommon__Dynamic_Query__c;
    /* Salesforce API name of a field, present on source object, which should be used as identifier for data mapping process completion. This field will be updated by batch job as to denote record mapping is done for source record.
    */
    global String clcommon__Process_Completion_Identifier_Field__c;
    /* API name of lookup field that defines a relation between source object and target object.
    */
    global String clcommon__Relationship_Field_API_Name__c;
    /* API name of source object to be mapped into target object.
    */
    global String clcommon__Source_Object_API_Name__c;
    /* API name of target object in which Source object records will be mapped.
    */
    global String clcommon__Target_Object_API_Name__c;
    /* Field stores functional category to which record belongs to. For ex: Accounting, Data Migration etc.
    */
    global String clcommon__Category__c;
    global String clcommon__Class_Name__c;
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
    global List<clcommon__Mapping_Group__c> clcommon__Mapping_Header_Groups__r;
    global List<clcommon__Mapping_Header__History> Histories;
    global List<clcommon__Mapping_Header__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Mapping_Header__c () 
    {
    }
}