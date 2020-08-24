// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Statement_Analysis_Detail__c {
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
    /* Reference to statement analysis
    */
    global clcommon__Statement_Analysis__c clcommon__Statement_Analysis__r;
    /* Reference to statement analysis
    */
    global Id clcommon__Statement_Analysis__c;
    /* Statement detail amount for the corresponding chart of account from the base statement
    */
    global Double clcommon__Base_Statement_Detail_Amount__c;
    /* Reference to base statement detail
    */
    global clcommon__Statement_Detail__c clcommon__Base_Statement_Detail__r;
    /* Reference to base statement detail
    */
    global Id clcommon__Base_Statement_Detail__c;
    /* Percent change from base statement
    */
    global Double clcommon__Percent_Change__c;
    /* Reference to template detail
    */
    global clcommon__Template_Detail__c clcommon__Template_Detail__r;
    /* Reference to template detail
    */
    global Id clcommon__Template_Detail__c;
    /* Used to store value. This will be change in amount in the case of trend analysis and actual value in case of sensitivity analysis
    */
    global Double clcommon__Value__c;
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

    global clcommon__Statement_Analysis_Detail__c () 
    {
    }
}