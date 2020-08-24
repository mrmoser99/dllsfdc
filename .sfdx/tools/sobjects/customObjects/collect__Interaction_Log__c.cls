// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class collect__Interaction_Log__c {
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
    global Account collect__Account__r;
    global Id collect__Account__c;
    global collect__Action_Code__c collect__Action__r;
    global Id collect__Action__c;
    global Boolean collect__Activity_Completed__c;
    /* Activity for contacting borrower on next follow up date.
    */
    global collect__Collection_Activity__c collect__Collection_Activity__r;
    /* Activity for contacting borrower on next follow up date.
    */
    global Id collect__Collection_Activity__c;
    /* Collector who created this interaction log.
    */
    global User collect__Collector__r;
    /* Collector who created this interaction log.
    */
    global Id collect__Collector__c;
    global String collect__Comments__c;
    global Contact collect__Contact__r;
    global Id collect__Contact__c;
    global String collect__Contract_Name__c;
    global String collect__Description__c;
    global collect__Loan_Account__c collect__Dev_Contract__r;
    global Id collect__Dev_Contract__c;
    /* Date-time on which collector needs to follow up with the borrower/other party
    */
    global Datetime collect__Follow_Up_Date_Time__c;
    global Date collect__Follow_Up_Date__c;
    global Date collect__Interaction_Date__c;
    global String collect__Lease_Account_Id__c;
    global String collect__Loan_Account_Id__c;
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
    global List<collect__Interaction_Log__Share> Shares;
    global List<collect__Promise_To_Pay__c> collect__Promise_To_Pay__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global collect__Interaction_Log__c () 
    {
    }
}