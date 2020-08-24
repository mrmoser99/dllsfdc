// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Accrual_Transactions__c {
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
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Decimal cllease__Dep_Accrued_Amount__c;
    global cllease__Dep_Streams__c cllease__Dep_Stream__r;
    global Id cllease__Dep_Stream__c;
    global Decimal cllease__Fee_Accrued_Amount__c;
    global cllease__Fee_Stream__c cllease__Fee_Stream__r;
    global Id cllease__Fee_Stream__c;
    global Boolean cllease__GL_Posted_Flag__c;
    /* Date on which the batch job processed this record for GL posting.
    */
    global Date cllease__GL_Process_Date__c;
    /* This field will be populated with any error/messages happened while gl processing.
    */
    global String cllease__GL_Processing_Message__c;
    /* This flag will be set to True, once the gl accounting entry reversal will be generated for the reversed transaction
    */
    global Boolean cllease__GL_Reversal_Posted_Flag__c;
    /* Date on which the batch job processed this record for GL Reversal posting.
    */
    global Date cllease__GL_Reversal_Process_Date__c;
    /* This flag will determine that gl entry will be generated for this transaction.
    */
    global Boolean cllease__GL_Transaction_Flag__c;
    global Decimal cllease__IDC_Accrued_Amount__c;
    global cllease__Initial_Direct_Cost_Stream__c cllease__IDC_Stream__r;
    global Id cllease__IDC_Stream__c;
    global Decimal cllease__Income_Accrued_Amount__c;
    global cllease__Rental_Stream__c cllease__Income_Stream__r;
    global Id cllease__Income_Stream__c;
    global String cllease__LeaseApplicationNumber__c;
    global cllease__Rental_Accrual_Stream1__c cllease__Rental_Accrual_Stream__r;
    global Id cllease__Rental_Accrual_Stream__c;
    global Decimal cllease__Rental_Accrued_Amount__c;
    global Decimal cllease__Residual_Accrued_Amount__c;
    global cllease__Residual_Stream__c cllease__Residual_Stream__r;
    global Id cllease__Residual_Stream__c;
    global Boolean cllease__Reversed_Flag__c;
    global Date cllease__Transaction_Date__c;
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
    global List<cllease__Accrual_Transactions__Share> Shares;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Transaction_Detail__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Accrual_Transactions__c () 
    {
    }
}