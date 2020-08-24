// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Lease_Trx_Header__c {
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
    global Decimal cllease__Amount__c;
    /* This flag indicates if this accrual transaction was created due to the contract coming back to Current status from NPA status.
    */
    global Boolean cllease__Catch_up_Flag__c;
    global Date cllease__GL_Date__c;
    global Date cllease__GL_Process_Date__c;
    global Boolean cllease__GL_Reversal_Posted_Flag__c;
    global Date cllease__GL_Reversal_Process_date__c;
    global Boolean cllease__GL_Transaction_Flag__c;
    global Boolean cllease__GL_posted_Flag__c;
    global String cllease__GL_processing_Message__c;
    global String cllease__ID__c;
    /* This field indicates that this NPA Accrual has been caught-up after the contract status changes from NPA to Current. This is only applicable for Lease Accrual Transactions where NPA Flag is true.
    */
    global Boolean cllease__NPA_Catch_up_Complete_Flag__c;
    /* This flag indicates if this transaction was accrued due to the contract in NPA status.
    */
    global Boolean cllease__NPA_Flag__c;
    /* This field indicates that this transaction is the result of an NPA Reversal.
    */
    global Boolean cllease__NPA_Reversal_Flag__c;
    global Boolean cllease__Reversed_Flag__c;
    global Date cllease__Transaction_Date__c;
    global Double cllease__Transaction_Number__c;
    global String cllease__Transaction_Type__c;
    /* Indicates if this accrual transaction has been restructured as a part of an overall contract restructure.
    */
    global Boolean cllease__Restructured__c;
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
    global List<cllease__Lease_Trx_Lines__c> cllease__Lease_Transaction_Line__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Lease_Trx_Header__c () 
    {
    }
}