// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Automated_Payment_Setup__c {
    global Id Id;
    global SObject Owner;
    global Id OwnerId;
    global Boolean IsDeleted;
    global String Name;
    global RecordType RecordType;
    global Id RecordTypeId;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global Boolean clcommon__Active__c;
    global String clcommon__Amount_Type__c;
    /* Select attempt number/s on which NSF is to be charged
    */
    global String clcommon__Apply_NSF_on_Attempt__c;
    global clcommon__Bank_Account__c clcommon__Bank_Account__r;
    global Id clcommon__Bank_Account__c;
    global Date clcommon__Debit_Date__c;
    global Double clcommon__Debit_Day__c;
    global String clcommon__Event__c;
    global Double clcommon__Frequency_Cycle__c;
    global String clcommon__Frequency__c;
    /* How many times a payment should be retried.
    */
    global Double clcommon__Number_of_Retry_Attempts__c;
    global clcommon__Payment_Mode__c clcommon__Payment_Mode__r;
    global Id clcommon__Payment_Mode__c;
    global Boolean clcommon__Pending_Retry__c;
    global Date clcommon__Recurring_ACH_End_Date__c;
    global Date clcommon__Recurring_ACH_Start_Date__c;
    /* Number of days between two retry attempts. These number of days are considered after rejection date.
    */
    global Double clcommon__Retry_Attempt_Interval__c;
    /* If enabled, we will retry a rejected payment as per the retry configuration.
    */
    global String clcommon__Retry__c;
    /* Select the return codes for which we want to retry payments.
    */
    global String clcommon__Return_Codes_for_Retry__c;
    global Date clcommon__Second_Debit_Date__c;
    global Date clcommon__Setup_Date__c;
    global Double clcommon__Transaction_Amount__c;
    global String clcommon__Type__c;
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global String cllease__Addenda_Record_Indicator__c;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global String cllease__Event__c;
    global String clcommon__External_Id__c;
    /* Only selected due types will be considered for payment by this Automated Payment Setup
    */
    global String cllease__Due_Types__c;
    global String cllease__Fees__c;
    /* If checked, already ACHed receivables should not be considered.
    */
    global Boolean cllease__Skip_Already_ACHed_Receivables__c;
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
    global List<clcommon__Automated_Payment_Setup__Share> Shares;
    global List<cllease__Lease_Payment_Transaction__c> cllease__Automated_Payment_Setup__r;
    global List<collect__Payment_Arrangement__c> collect__Payment_Arrangements__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Automated_Payment_Setup__c () 
    {
    }
}