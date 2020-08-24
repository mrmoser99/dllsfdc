// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Fee_Stream__c {
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
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Boolean cllease__Accrued__c;
    global Boolean cllease__Active__c;
    global Decimal cllease__Beginning_Balance__c;
    global cllease__Contract_Fees__c cllease__Contract_Fee__r;
    global Id cllease__Contract_Fee__c;
    global Date cllease__Date_Accrued__c;
    global Date cllease__Date__c;
    global Decimal cllease__Ending_Balance__c;
    global cllease__Expense_Fees__c cllease__Expense_Fee__r;
    global Id cllease__Expense_Fee__c;
    global Decimal cllease__Fee_Amount__c;
    global clcommon__Fee_Definition__c cllease__Fee_Definition__r;
    global Id cllease__Fee_Definition__c;
    /* Please use Fee Definition field that references Fee Definition from CL Common.
    */
    global cllease__Fee__c cllease__Fee_Name__r;
    /* Please use Fee Definition field that references Fee Definition from CL Common.
    */
    global Id cllease__Fee_Name__c;
    global String cllease__Fee_Type__c;
    global Decimal cllease__Tax__c;
    global cllease__Transaction_Sub_Type__c cllease__Transaction_Sub_Type__r;
    global Id cllease__Transaction_Sub_Type__c;
    global String cllease__comment__c;
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
    global List<cllease__Accrual_Transactions__c> cllease__Accrual_Transactions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Fee_Stream__c () 
    {
    }
}