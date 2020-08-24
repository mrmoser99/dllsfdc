// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Liability__c {
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
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global String genesis__Account_Number__c;
    global Double genesis__Amount_Owing__c;
    global String genesis__Comments__c;
    global Contact genesis__Contact__r;
    global Id genesis__Contact__c;
    global Boolean genesis__Debt_Consolidation__c;
    global Boolean genesis__Include_for_DTI__c;
    global Double genesis__Interest_Rate__c;
    global String genesis__Liability_Type__c;
    global String genesis__Name_of_Creditor__c;
    global Double genesis__Original_Amount__c;
    global String genesis__Ownership__c;
    global Double genesis__Payment_Amount__c;
    global String genesis__Payment_Frequency__c;
    global String genesis__Secured_by_Lien__c;
    /* Liability Information needs to have a lookup on Account.
    */
    global Account genesis__Account_Lookup_on_Liability_Object__r;
    /* Liability Information needs to have a lookup on Account.
    */
    global Id genesis__Account_Lookup_on_Liability_Object__c;
    global String genesis__Additional_Payoff_Information__c;
    global Boolean genesis__Verify_Liability__c;
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
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Liability__c () 
    {
    }
}