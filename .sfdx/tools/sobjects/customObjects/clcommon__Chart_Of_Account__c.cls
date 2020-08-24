// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Chart_Of_Account__c {
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
    /* Should the amount captured against this chart of account be stored as a negative balance?
    */
    global Boolean clcommon__Has_Negative_Value__c;
    global clcommon__Chart_Of_Account__c clcommon__Parent_Account__r;
    global Id clcommon__Parent_Account__c;
    global String clcommon__Type__c;
    /* This is a unique code which is used by system for accounting operations.
    */
    global String clcommon__Chart_of_Account_Code__c;
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
    global List<clcommon__Accounting_Entry__c> clcommon__Accounting_Entries_Credit__r;
    global List<clcommon__Accounting_Entry__c> clcommon__Accounting_Entries__r;
    global List<clcommon__Chart_Of_Account__Share> Shares;
    global List<clcommon__Chart_Of_Account__c> clcommon__Chart_of_Accounts__r;
    global List<clcommon__Statement_Detail__c> clcommon__Financial_Statement_Record_Details__r;
    global List<clcommon__Template_Detail__c> clcommon__Template_Details__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Chart_Of_Account__c () 
    {
    }
}