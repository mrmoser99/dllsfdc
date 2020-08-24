// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Statement_Analysis__c {
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
    /* Reference to the account whose financial statement's will be used for financial statement analysis
    */
    global Account clcommon__Account__r;
    /* Reference to the account whose financial statement's will be used for financial statement analysis
    */
    global Id clcommon__Account__c;
    /* Base financial statement to be used for analysis
    */
    global clcommon__Financial_Statement__c clcommon__Base_Financial_Statement__r;
    /* Base financial statement to be used for analysis
    */
    global Id clcommon__Base_Financial_Statement__c;
    /* Field to store any comment regarding financial statement analysis
    */
    global String clcommon__Comment__c;
    /* Parameters for statement analysis to be stored in JSON form
    */
    global String clcommon__Parameters__c;
    /* Type of the Statement which can be INCOME, BALANCESHEET
    */
    global String clcommon__Statement_Type__c;
    /* Target financial statement for the statement analysis
    */
    global clcommon__Financial_Statement__c clcommon__Target_Financial_Statement__r;
    /* Target financial statement for the statement analysis
    */
    global Id clcommon__Target_Financial_Statement__c;
    /* Type of the statement analysis
    */
    global String clcommon__Type__c;
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
    global List<clcommon__Statement_Analysis_Detail__c> clcommon__Statement_Analysis_Detail__r;
    global List<clcommon__Statement_Analysis__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Statement_Analysis__c () 
    {
    }
}