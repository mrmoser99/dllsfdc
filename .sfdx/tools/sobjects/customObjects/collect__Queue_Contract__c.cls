// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class collect__Queue_Contract__c {
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
    global collect__Queue__c collect__Queue__r;
    global Id collect__Queue__c;
    global String collect__Collector__c;
    global String collect__Contract_Name__c;
    /* Lookup to Collections' contract
    */
    global collect__Loan_Account__c collect__Contract__r;
    /* Lookup to Collections' contract
    */
    global Id collect__Contract__c;
    global Date collect__Date_Closed__c;
    global Date collect__Date_Opened__c;
    global Double collect__Days_Past_Due__c;
    global Decimal collect__Delinquent_Amount__c;
    global Date collect__Follow_Up_Date__c;
    global String collect__Lease_Account_Id__c;
    global String collect__Loan_Account_Id__c;
    global Date collect__Oldest_Due_Date__c;
    global String collect__Status__c;
    global collect__User_Assignment_Detail__c collect__User_Assignment_Detail__r;
    global Id collect__User_Assignment_Detail__c;
    global User collect__User__r;
    global Id collect__User__c;
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

    global collect__Queue_Contract__c () 
    {
    }
}