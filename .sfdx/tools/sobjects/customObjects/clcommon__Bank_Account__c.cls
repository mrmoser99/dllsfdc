// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Bank_Account__c {
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
    global String clcommon__ACH_Code__c;
    global String clcommon__Account_Type__c;
    global String clcommon__Account_Usage__c;
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global Boolean clcommon__Active__c;
    global String clcommon__Bank_Account_Name__c;
    global String clcommon__Bank_Account_Number__c;
    global String clcommon__Bank_Name__c;
    global Contact clcommon__Contact__r;
    global Id clcommon__Contact__c;
    global Boolean clcommon__Primary__c;
    global String clcommon__Routing_Number__c;
    global String clcommon__External_Id__c;
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
    global List<clcommon__Automated_Payment_Configuration__c> clcommon__Automated_Payment_Configuration__r;
    global List<clcommon__Automated_Payment_Setup__c> clcommon__ACH_Setup__r;
    global List<clcommon__Bank_Account__Share> Shares;
    global List<genesis__Funding_Schedule__c> genesis__Funding_Schedules__r;
    global List<genesis__Funding_Transaction__c> genesis__Funding_Transactions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Bank_Account__c () 
    {
    }
}