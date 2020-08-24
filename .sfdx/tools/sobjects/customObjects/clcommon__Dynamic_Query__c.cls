// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Dynamic_Query__c {
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
    global String clcommon__From_Object__c;
    global String clcommon__Group_By__c;
    global String clcommon__Order_By__c;
    /* Json format to capture query. This is for internal use only
    */
    global String clcommon__Query_Json__c;
    global String clcommon__Query_Name__c;
    global Double clcommon__Record_Limit__c;
    global clcommon__Dynamic_Query_Data__c clcommon__Where_Clause__r;
    global Id clcommon__Where_Clause__c;
    /* Used in Hierarchical Queries.It specifies the relationship between parent rows and child rows of the hierarchy.
    */
    global clcommon__Dynamic_Query_Data__c clcommon__Connect_By__r;
    /* Used in Hierarchical Queries.It specifies the relationship between parent rows and child rows of the hierarchy.
    */
    global Id clcommon__Connect_By__c;
    global String clcommon__External_Id__c;
    /* Used in Hierarchical Query. It specifies root record(s) query condition.
    */
    global clcommon__Dynamic_Query_Data__c clcommon__Start_With__r;
    /* Used in Hierarchical Query. It specifies root record(s) query condition.
    */
    global Id clcommon__Start_With__c;
    /* If the query JSON is provided, then it will be directly used while executing query. Otherwise, query JSON will be constructed first.
    */
    global Boolean clcommon__Is_Query_JSON_provided__c;
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
    global List<clcommon__Dynamic_Query_Data__c> clcommon__Dynamic_Query_Data__r;
    global List<clcommon__Dynamic_Query_Parameter__c> clcommon__Dynamic_Query_Parameters1__r;
    global List<clcommon__Dynamic_Query__Share> Shares;
    global List<clcommon__Mapping_Header__c> clcommon__Mapping_Headers__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Dynamic_Query__c () 
    {
    }
}