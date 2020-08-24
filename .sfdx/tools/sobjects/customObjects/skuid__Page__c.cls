// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class skuid__Page__c {
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
    global String skuid__Composer_Settings__c;
    global Boolean skuid__IsMaster__c;
    global Datetime skuid__Last_Modified_Date_Check__c;
    global String skuid__Layout2__c;
    global String skuid__Layout3__c;
    global String skuid__Layout4__c;
    global String skuid__Layout5__c;
    global String skuid__Layout__c;
    global skuid__Page__c skuid__MasterPage__r;
    global Id skuid__MasterPage__c;
    /* The maximum number of automatically-saved Page Versions Skuid will create for this Page before it will start deleting the oldest Auto-Saves.
    */
    global Double skuid__Max_Auto_Saves__c;
    /* Which module is this Page included in?
    */
    global String skuid__Module__c;
    global String skuid__Type__c;
    global String skuid__UniqueId__c;
    global Double skuid__Count_Auto_Saved_Versions__c;
    global String skuid__API_Version__c;
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
    global List<skuid__Feedback__c> skuid__Feedback__r;
    global List<skuid__Page_Assignment__c> skuid__Page_Assignments__r;
    global List<skuid__Page_Interaction__c> skuid__Page_Interactions__r;
    global List<skuid__Page_Version__c> skuid__Page_Versions__r;
    global List<skuid__Page__History> Histories;
    global List<skuid__Page__Share> Shares;
    global List<skuid__Page__c> skuid__Pages__r;
    global List<skuid__Personalization_Settings__c> skuid__Personalization_Settings__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global skuid__Page__c () 
    {
    }
}