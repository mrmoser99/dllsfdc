// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class collect__Collection_Configuration_Actions__c {
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
    global collect__Collection_Configuration__c collect__Collection_Configuration__r;
    global Id collect__Collection_Configuration__c;
    global String collect__Action__c;
    /* If checked, contact preference is checked first and applied for customer communication. If contact preference is not available, then action as per this action record is applied.
    */
    global Boolean collect__Apply_Contact_Preference__c;
    global String collect__Comments__c;
    global cnotify__Configuration__c collect__Configuration__r;
    global Id collect__Configuration__c;
    global clcommon__Event_Configuration__c collect__Configuration_common__r;
    global Id collect__Configuration_common__c;
    global Date collect__Date__c;
    global Double collect__Days_in_Arrear__c;
    global String collect__Dunning_Letter_Id__c;
    global String collect__Event__c;
    global String collect__Field_API_Name__c;
    global String collect__Field_Label__c;
    global String collect__Field_Type__c;
    global Boolean collect__Manual_Activity__c;
    global String collect__Object_API_Name__c;
    global String collect__Object_Label__c;
    global String collect__Operator__c;
    global collect__Queue__c collect__Queue__r;
    global Id collect__Queue__c;
    global cnotify__Template__c collect__Template__r;
    global Id collect__Template__c;
    global clcommon__Template__c collect__Template_common__r;
    global Id collect__Template_common__c;
    global String collect__Value__c;
    global collect__Action_Configuration__c collect__Action_Configuration__r;
    global Id collect__Action_Configuration__c;
    global Date collect__Action_Date__c;
    global String collect__Action_Details__c;
    global String collect__External_ID__c;
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
    global List<collect__Collection_Activity__c> collect__Collection_Activities__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global collect__Collection_Configuration_Actions__c () 
    {
    }
}