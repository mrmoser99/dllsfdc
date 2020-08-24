// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Execution_Criteria__c {
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
    global String clcommon__Field_API_Name__c;
    global String clcommon__Field_Name__c;
    global String clcommon__Field_Type__c;
    global String clcommon__Matching_Type__c;
    global String clcommon__Matching_Value__c;
    global String clcommon__Maximum_Value__c;
    global String clcommon__Minimum_Value__c;
    global String clcommon__Related_Object__c;
    global Double clcommon__Sequence__c;
    global String genesis__Scorecard_Object_Reference__c;
    global genesis__Scorecard__c genesis__Scorecard__r;
    global Id genesis__Scorecard__c;
    global String genesis__Task_Setup_Object_Reference__c;
    global genesis__Task_Setup__c genesis__Task_Setup__r;
    global Id genesis__Task_Setup__c;
    global String genesis__Policy_Condition_Definition_Reference__c;
    global genesis__Policy_Exception_Definition__c genesis__Policy_Condition_Definition__r;
    global Id genesis__Policy_Condition_Definition__c;
    global clcommon__Approval_Definition__c clcommon__Approval_Definition__r;
    global Id clcommon__Approval_Definition__c;
    global clcommon__Execution_Criteria__c clcommon__Matching_Value_Dynamic__r;
    global Id clcommon__Matching_Value_Dynamic__c;
    global String clcommon__Primary_Object_Reference__c;
    global String clcommon__External_ID__c;
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
    global List<clcommon__Execution_Criteria__Share> Shares;
    global List<clcommon__Execution_Criteria__c> clcommon__Dynamic_Matching_Values__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Execution_Criteria__c () 
    {
    }
}