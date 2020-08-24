// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Template_Configuration__c {
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
    global String clcommon__CallbackCallerClass__c;
    global String clcommon__Custom_Class__c;
    global String clcommon__Message__c;
    global String clcommon__Object_API_Name__c;
    global String clcommon__Reply_To__c;
    global Double clcommon__Retry_Count__c;
    global Boolean clcommon__Send_Notification_Message__c;
    global String clcommon__Sender_Address__c;
    global String clcommon__Subject__c;
    global String clcommon__Template_Type__c;
    global clcommon__Template__c clcommon__Template__r;
    global Id clcommon__Template__c;
    global String clcommon__To__c;
    global String clcommon__Salesforce_Email_Template__c;
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
    global List<clcommon__Delivery_Detail__c> clcommon__Delivery_Details__r;
    global List<clcommon__Event_Configuration__c> clcommon__Event_Configurations1__r;
    global List<clcommon__Gateway__c> clcommon__Gateways__r;
    global List<clcommon__Request__c> clcommon__Requests__r;
    global List<clcommon__Template_Configuration__Share> Shares;
    global List<collect__Collection_Activity__c> collect__Collection_Activities_common__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Template_Configuration__c () 
    {
    }
}