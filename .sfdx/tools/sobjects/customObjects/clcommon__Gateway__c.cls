// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Gateway__c {
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
    global String clcommon__Content__c;
    global String clcommon__Error_Message__c;
    global String clcommon__From__c;
    global String clcommon__Is_Active__c;
    global Double clcommon__Max_Retry__c;
    global String clcommon__Mode_Of_Communication__c;
    global String clcommon__Offline__c;
    global clcommon__Request__c clcommon__Request_ID__r;
    global Id clcommon__Request_ID__c;
    global Datetime clcommon__Request_Time__c;
    global Double clcommon__Retry_Attempt__c;
    global clcommon__MapRequestToSalesforce__c clcommon__Salesforce_ID__r;
    global Id clcommon__Salesforce_ID__c;
    global String clcommon__Status__c;
    global String clcommon__Subject__c;
    global clcommon__Template_Configuration__c clcommon__Template_Name__r;
    global Id clcommon__Template_Name__c;
    global String clcommon__To__c;
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global Contact clcommon__Contact__r;
    global Id clcommon__Contact__c;
    global String clcommon__Contract_Id__c;
    global String clcommon__Delivery_Status__c;
    global Boolean clcommon__Generated__c;
    global String clcommon__Merged_Object_Id__c;
    global String clcommon__Message_Sid__c;
    global String clcommon__Salesforce_Email_Template__c;
    global Datetime clcommon__Sent_Date__c;
    global String clcommon__Target_Object_Id__c;
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
    global List<clcommon__Gateway__Share> Shares;
    global List<clcommon__Notification_Log__c> clcommon__Logs__r;
    global List<clcommon__Notification_Log__c> clcommon__Logs1__r;
    global List<clcommon__Response__c> clcommon__ResponseObjects__r;
    global List<clcommon__Response__c> clcommon__ResponseObjects1__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Gateway__c () 
    {
    }
}