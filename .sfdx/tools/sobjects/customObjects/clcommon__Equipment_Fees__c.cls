// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Equipment_Fees__c {
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
    global Boolean clcommon__Active__c;
    global Date clcommon__Disbursement_Date__c;
    global Double clcommon__Due_Day__c;
    global Date clcommon__End_Date__c;
    global clcommon__Collateral__c clcommon__Equipment_Id__r;
    global Id clcommon__Equipment_Id__c;
    global Decimal clcommon__Fee_Amount__c;
    global clcommon__Fee_Definition__c clcommon__Fee__r;
    global Id clcommon__Fee__c;
    global String clcommon__Frequency__c;
    global Date clcommon__Next_Generation_Date__c;
    global Double clcommon__No_Of_Schedules__c;
    /* This field will contain the overridden value for Tax Amount.
However, if 'Override Tax Rate' is also provided, then effective 'Tax Amount' will be calculated based on that only.
    */
    global Decimal clcommon__Override_Tax_Amount__c;
    /* This field will contain the overridden value for Tax Rate
    */
    global Double clcommon__Override_Tax_Rate__c;
    global Date clcommon__Start_Date__c;
    /* This field represents the Tax Component
    */
    global Decimal clcommon__Tax_Amount__c;
    /* This field represents the Total Amount including Tax
    */
    global Decimal clcommon__Total_Amount__c;
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
    global List<clcommon__Equipment_Fees__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Equipment_Fees__c () 
    {
    }
}