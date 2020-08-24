// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Appraisal_Request__c {
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
    global genesis__Application_Collateral__c genesis__Application_Collateral__r;
    global Id genesis__Application_Collateral__c;
    global User genesis__Appraisal_Ordered_By__r;
    global Id genesis__Appraisal_Ordered_By__c;
    global String genesis__City__c;
    global String genesis__Collateral_Category__c;
    global String genesis__Collateral_Description__c;
    global clcommon__Collateral_Valuation__c genesis__Collateral_Valuation__r;
    global Id genesis__Collateral_Valuation__c;
    global Date genesis__Due_Date__c;
    global String genesis__Postal_Code__c;
    global String genesis__State__c;
    global String genesis__Status__c;
    global String genesis__Street_Address__c;
    global Double genesis__Accepted_Bids__c;
    global Double genesis__Expired_Bids__c;
    global Double genesis__Pending_Bids__c;
    global Double genesis__Rejected_Bids__c;
    global Double genesis__Submitted_Bids__c;
    global Double genesis__Total_Bids__c;
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
    global List<genesis__Appraisal_Bid__c> genesis__Appraisal_Bid__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Appraisal_Request__c () 
    {
    }
}