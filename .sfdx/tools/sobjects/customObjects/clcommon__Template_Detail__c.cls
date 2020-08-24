// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Template_Detail__c {
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
    global clcommon__Financial_Statement_Template__c clcommon__Template__r;
    global Id clcommon__Template__c;
    global String clcommon__Alias__c;
    global clcommon__Chart_Of_Account__c clcommon__Chart_of_Account__r;
    global Id clcommon__Chart_of_Account__c;
    global clcommon__Template_Detail__c clcommon__Detail__r;
    global Id clcommon__Detail__c;
    /* Internal use only. This key is used to uniquely identify aliases for a given template. The value is equal to alias value, if alias is not null.
    */
    global String clcommon__Duplicate_Key__c;
    global String clcommon__Expression__c;
    global String clcommon__Level__c;
    global String clcommon__Statement_Type__c;
    global String clcommon__Type__c;
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global clcommon__Collateral__c clcommon__Collateral__r;
    global Id clcommon__Collateral__c;
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
    global List<clcommon__Industry_Average__c> clcommon__Industry_Average__r;
    global List<clcommon__Statement_Analysis_Detail__c> clcommon__Statement_Analysis_Detail__r;
    global List<clcommon__Statement_Detail__c> clcommon__Statement_Details__r;
    global List<clcommon__Template_Detail__c> clcommon__Template_Details__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Template_Detail__c () 
    {
    }
}