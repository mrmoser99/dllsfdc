// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Delinquency_Details__c {
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
    /* Account of the Borrower which has delinquent Contract
    */
    global Account clcommon__Account__r;
    /* Account of the Borrower which has delinquent Contract
    */
    global Id clcommon__Account__c;
    /* Aging History of delinquent Contracts
    */
    global String clcommon__Aging__c;
    /* Contact of the Borrower which has delinquent Contract
    */
    global Contact clcommon__Contact__r;
    /* Contact of the Borrower which has delinquent Contract
    */
    global Id clcommon__Contact__c;
    /* Days overdue of maximum Delinquent Contract of the borrower
    */
    global Double clcommon__Max_Days_Overdue__c;
    /* Unpaid Due Date of maximum Delinquent Contract of the borrower
    */
    global Date clcommon__Oldest_Unpaid_Due_Date__c;
    /* Delinquent Status of the borrower
    */
    global String clcommon__Status__c;
    /* Sum of delinquent amount of all Delinquent Contracts of the borrower
    */
    global Double clcommon__Total_Delinquent_Amount__c;
    /* Loan Type of Delinquent Contract
    */
    global String clcommon__Type__c;
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
    global List<clcommon__Delinquency_Details__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Delinquency_Details__c () 
    {
    }
}