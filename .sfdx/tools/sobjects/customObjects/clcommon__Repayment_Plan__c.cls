// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Repayment_Plan__c {
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
    /* The day of every cycle on which the payment is expected. This is to capture if the due day is different from the payment start date
    */
    global Double clcommon__Due_Day__c;
    /* Effective start date for the repayment plan
    */
    global Date clcommon__Effective_Date__c;
    /* A number to multiply with the frequency interval to get the effective frequency
    */
    global Double clcommon__Frequency_Multiplier__c;
    /* Base frequency of payments during the plan period, this combined with frequency multiplier will indicate the effective frequency
    */
    global String clcommon__Frequency__c;
    /* Number of installments for the plan period
    */
    global Double clcommon__Number_Of_Payments__c;
    /* The expected payment amount per installment for the plan period
    */
    global Double clcommon__Payment_Amount__c;
    /* The date of first installment for the plan period
    */
    global Date clcommon__Payment_Start_Date__c;
    /* Type of the installment
    */
    global String clcommon__Payment_Type__c;
    /* A number used to order repayment plans as needed
    */
    global Double clcommon__Sequence_Number__c;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    /* Lease debt information
    */
    global cllease__Debt_Detail__c cllease__Lease_Debt_Detail__r;
    /* Lease debt information
    */
    global Id cllease__Lease_Debt_Detail__c;
    global String clcommon__External_Id__c;
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
    global List<clcommon__Repayment_Plan__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Repayment_Plan__c () 
    {
    }
}