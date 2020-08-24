// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__NPA_Detail__c {
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
    /* Represents the header under which the NPA Status of this Contract will be changed
    */
    global cllease__NPA_Header__c cllease__NPA_Header__r;
    /* Represents the header under which the NPA Status of this Contract will be changed
    */
    global Id cllease__NPA_Header__c;
    /* Account whose Contracts' NPA Status needs to be changed
    */
    global Account cllease__Account__r;
    /* Account whose Contracts' NPA Status needs to be changed
    */
    global Id cllease__Account__c;
    /* Contracts (belonging to the selected Account) whose NPA Status needs to be changed
    */
    global cllease__Lease_Account__c cllease__LS_Contract__r;
    /* Contracts (belonging to the selected Account) whose NPA Status needs to be changed
    */
    global Id cllease__LS_Contract__c;
    /* Reason for under which the NPA Status needs to be changed for the particular Contract
    */
    global String cllease__Manual_NPA_Reason__c;
    /* If this flag is checked, then system will not pick the Contract for rule-based NPA
    */
    global Boolean cllease__Manually_Override_NPA_Status__c;
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

    global cllease__NPA_Detail__c () 
    {
    }
}