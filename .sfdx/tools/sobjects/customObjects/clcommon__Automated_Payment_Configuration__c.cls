// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Automated_Payment_Configuration__c {
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
    global Boolean clcommon__Active__c;
    /* Select attempt number/s on which NSF is to be charged.
    */
    global String clcommon__Apply_NSF_on_Attempt__c;
    global clcommon__Bank_Account__c clcommon__Bank_Account__r;
    global Id clcommon__Bank_Account__c;
    global Double clcommon__BatchId__c;
    global String clcommon__Company_Entry_Description__c;
    global String clcommon__Company_Identification__c;
    global String clcommon__Company_Name__c;
    global String clcommon__Entry_Code__c;
    global String clcommon__Event__c;
    global String clcommon__File_Type__c;
    global String clcommon__Filegen_Class__c;
    global String clcommon__Folder_Name__c;
    global String clcommon__Immediate_Destination_Name__c;
    global String clcommon__Immediate_Destination__c;
    global String clcommon__Immediate_Origin_Name__c;
    global String clcommon__Immediate_Origin__c;
    /* Transactions for this event type are cleared only after the lock period number of business days have passed since creation. Till then the funds remain in an uncleared state.
    */
    global Double clcommon__Lock_Period__c;
    global String clcommon__Memo__c;
    global String clcommon__Merchant_ID__c;
    /* How many times a payment should be retried.
    */
    global Double clcommon__Number_of_Retry_Attempts__c;
    global String clcommon__Originating_DFI_Identification__c;
    global clcommon__Payment_Mode__c clcommon__Payment_Mode__r;
    global Id clcommon__Payment_Mode__c;
    global String clcommon__Product_Description__c;
    global String clcommon__Reference_Code__c;
    global Double clcommon__Retry_Attempt_Interval__c;
    /* If enabled, we will retry a rejected payment as per the retry configuration.
    */
    global String clcommon__Retry__c;
    /* Select the return codes for which we want to retry payments.
    */
    global String clcommon__Return_Codes_for_Retry__c;
    global String clcommon__Support_Phone_Number__c;
    global String clcommon__Trace_Number_Prefix__c;
    /* Value should be Numeric
    */
    global String cllease__Batch_Number__c;
    global String cllease__Company_Discretionary_Data__c;
    global String cllease__Company_Entry_Description__c;
    global String cllease__Service_Class_Code__c;
    global String cllease__Standard_Entry_Class_Code__c;
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
    global List<clcommon__Automated_Payment_Configuration__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Automated_Payment_Configuration__c () 
    {
    }
}