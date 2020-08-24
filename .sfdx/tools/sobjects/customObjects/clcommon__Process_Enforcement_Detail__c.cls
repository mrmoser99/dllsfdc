// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Process_Enforcement_Detail__c {
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
    /* Name of Process Enforcement
    */
    global clcommon__Process_Enforcement__c clcommon__Process_Enforcement__r;
    /* Name of Process Enforcement
    */
    global Id clcommon__Process_Enforcement__c;
    /* Account on which Process Enforcement is applied
    */
    global Account clcommon__Account__r;
    /* Account on which Process Enforcement is applied
    */
    global Id clcommon__Account__c;
    /* Process Enforcement active status
    */
    global Boolean clcommon__Active__c;
    /* Contact on which Process Enforcement needs to be applied
    */
    global Contact clcommon__Contact__r;
    /* Contact on which Process Enforcement needs to be applied
    */
    global Id clcommon__Contact__c;
    /* Process Enforcement Expired?
    */
    global Boolean clcommon__Expired__c;
    global Date clcommon__Expiry_Date__c;
    global Date clcommon__Revoked_On__c;
    /* Process Enforcement Revoked?
    */
    global Boolean clcommon__Revoked__c;
    /* Process Enforcement start Date
    */
    global Date clcommon__Start_Date__c;
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
    global List<clcommon__Process_Enforcement_Action_Results__c> clcommon__Process_Enforcement_Details__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Process_Enforcement_Detail__c () 
    {
    }
}