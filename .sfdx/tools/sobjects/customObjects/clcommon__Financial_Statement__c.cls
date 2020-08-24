// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Financial_Statement__c {
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
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global String clcommon__Audit_Method__c;
    global Double clcommon__Months_Covered__c;
    global clcommon__Financial_Statement__c clcommon__Previous_Statement__r;
    global Id clcommon__Previous_Statement__c;
    global Date clcommon__Statement_Date__c;
    global String clcommon__Statement_Type__c;
    global clcommon__Financial_Statement_Template__c clcommon__Template__r;
    global Id clcommon__Template__c;
    /* Possible options for accounting basis are :  Cash or Accrual
    */
    global String clcommon__Accounting_Basis__c;
    /* Parameters to be used for projection will be stored in JSON form
    */
    global String clcommon__Parameters__c;
    /* Type of the statement analysis
    */
    global String clcommon__Statement_Analysis_Type__c;
    global clcommon__Collateral__c clcommon__Collateral__r;
    global Id clcommon__Collateral__c;
    global String clcommon__Statement_Year__c;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
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
    global List<clcommon__Financial_Statement__Share> Shares;
    global List<clcommon__Financial_Statement__c> clcommon__Financial_Statements__r;
    global List<clcommon__Statement_Analysis__c> clcommon__Statement_Analysis__r;
    global List<clcommon__Statement_Analysis__c> clcommon__Statement_Analysis1__r;
    global List<clcommon__Statement_Detail__c> clcommon__Financial_Statement__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Financial_Statement__c () 
    {
    }
}