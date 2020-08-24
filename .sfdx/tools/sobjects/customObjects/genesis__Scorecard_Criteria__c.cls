// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Scorecard_Criteria__c {
    global Id Id;
    global Boolean IsDeleted;
    global String Name;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global genesis__Scorecard__c genesis__Scorecard__r;
    global Id genesis__Scorecard__c;
    global String genesis__Field_API_Name__c;
    global String genesis__Field_Name__c;
    global String genesis__Field_Relation__c;
    global String genesis__Field_Type__c;
    global String genesis__Matching_Type__c;
    global String genesis__Matching_Value__c;
    global String genesis__Maximum_Value__c;
    global String genesis__Minimum_Value__c;
    global String genesis__Related_Object__c;
    global Double genesis__Score__c;
    global String genesis__Scorecard_ObjectType__c;
    global String genesis__Scorecard_Object_Reference__c;
    global Boolean genesis__Use_Input_as_Score__c;
    global Double genesis__Weight__c;
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
    global List<genesis__Account_Scorecard_Result__c> genesis__Account_Scorecard_Result__r;
    global List<genesis__Application_s_Scorecard__c> genesis__Application_s_Scorecard__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Scorecard_Criteria__c () 
    {
    }
}