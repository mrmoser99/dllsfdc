// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__NPA_History__c {
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
    global cllease__Lease_Account__c cllease__LS_Contract__r;
    global Id cllease__LS_Contract__c;
    /* This field indicates that all previous NPA accruals have been caught up for this change in status of the lease contract.
    */
    global Boolean cllease__NPA_Catch_up_Complete_Flag__c;
    /* This field indicates that appropriate accrual transactions have been reversed to create NPA accruals for this change is status of lease contract.
    */
    global Boolean cllease__NPA_Reversal_Complete_Flag__c;
    global String cllease__New_NPA_Status__c;
    global String cllease__Old_NPA_Status__c;
    global Date cllease__Transaction_Date__c;
    /* This represents the reason for which this NPA History got created during a Manual NPA.
    */
    global String cllease__Manual_NPA_Reason__c;
    /* This represents the NPA Header under which this NPA History got created during a Manual NPA.
    */
    global cllease__NPA_Header__c cllease__NPA_Header__r;
    /* This represents the NPA Header under which this NPA History got created during a Manual NPA.
    */
    global Id cllease__NPA_Header__c;
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

    global cllease__NPA_History__c () 
    {
    }
}