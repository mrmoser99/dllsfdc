// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Int_OLMN_GL__c {
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
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global String ACCOUNTING_MONTH__c;
    global String ACCOUNTING_YEAR__c;
    global String ACCOUNT__c;
    global Double AMOUNT__c;
    global Boolean Committed__c;
    global String Company__c;
    global String Currency__c;
    global String FOREIGN_SUBSYSTEM_ID__c;
    global String JOURNAL_CATEGORY__c;
    global String JOURNAL_CURRENCY__c;
    global String JOURNAL_DATE__c;
    global String JOURNAL_DESCRIPTION__c;
    global Double JOURNAL_ENTRY_LINE_NUMBER__c;
    global Double JOURNAL_ENTRY_NUMBER__c;
    global String JOURNAL_REFERENCE__c;
    global String JOURNAL_SOURCE_CODE__c;
    /* This field helps in storing grouping criteria for record on GL Accounting Entries Consolidation
    */
    global String Movement_Code__c;
    global String Report_Period__c;
    global String SIGN__c;
    global String TRANSACTION_DESCRIPTION__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Int_OLMN_GL__Share> Shares;
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

    global Int_OLMN_GL__c () 
    {
    }
}