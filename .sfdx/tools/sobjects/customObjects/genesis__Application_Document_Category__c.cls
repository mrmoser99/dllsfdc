// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Application_Document_Category__c {
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
    global Date LastActivityDate;
    global Boolean genesis__Active__c;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global String genesis__Description__c;
    global genesis__Document_Category__c genesis__Document_Category__r;
    global Id genesis__Document_Category__c;
    global String genesis__Email__c;
    global String genesis__Id__c;
    global genesis__Application_Document_Category__c genesis__Parent_Application_Document_Category__r;
    global Id genesis__Parent_Application_Document_Category__c;
    global String genesis__Parent_Id__c;
    global clcommon__Party_Type__c genesis__Party_Type__r;
    global Id genesis__Party_Type__c;
    global clcommon__Party__c genesis__Party__r;
    global Id genesis__Party__c;
    global String genesis__Priority__c;
    global Boolean genesis__Required__c;
    global User genesis__Review_Assigned_To__r;
    global Id genesis__Review_Assigned_To__c;
    global String genesis__Review_Comments__c;
    global User genesis__Reviewed_By__r;
    global Id genesis__Reviewed_By__c;
    global Boolean genesis__Send_Notification__c;
    global String genesis__Status__c;
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Event> Events;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OpenActivity> OpenActivities;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<genesis__AppDocCatAttachmentJunction__c> genesis__AppDocCatAttachmentJunctions__r;
    global List<genesis__Application_Document_Category__Feed> Feeds;
    global List<genesis__Application_Document_Category__History> Histories;
    global List<genesis__Application_Document_Category__Share> Shares;
    global List<genesis__Application_Document_Category__c> genesis__Application_Document_Category__r;
    global List<genesis__Letter_of_Intent__c> genesis__Letters_of_Intent__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global genesis__Application_Document_Category__c () 
    {
    }
}