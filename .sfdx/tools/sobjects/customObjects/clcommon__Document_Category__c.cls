// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Document_Category__c {
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
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global Boolean clcommon__Active__c;
    /* Name of the document category
    */
    global String clcommon__Category_Name__c;
    global clcommon__Collateral__c clcommon__Collateral__r;
    global Id clcommon__Collateral__c;
    global String clcommon__Description__c;
    global clcommon__Document_Definition__c clcommon__Document_Definition__r;
    global Id clcommon__Document_Definition__c;
    global String clcommon__Generation_Status__c;
    global clcommon__Document_Category__c clcommon__Parent_Document_Category__r;
    global Id clcommon__Parent_Document_Category__c;
    global String clcommon__Priority__c;
    global Boolean clcommon__Required__c;
    global Boolean clcommon__Reuse_Document__c;
    /* Should the document category be visible as documents that the portal user needs to upload or internal documents that the user can view or not be visible at all.
    */
    global String clcommon__Show_In_Portal__c;
    global String clcommon__Status__c;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global String clcommon__DocumentCategoryList__c;
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
    global List<clcommon__Category_Attachment_Association__c> clcommon__DocCat_Attachment_Associations__r;
    global List<clcommon__Document_Category__History> Histories;
    global List<clcommon__Document_Category__Share> Shares;
    global List<clcommon__Document_Category__c> clcommon__Parent_Document_Category__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global clcommon__Document_Category__c () 
    {
    }
}