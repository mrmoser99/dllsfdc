// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Deposit__c {
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
    /* This field shows the owner (Account) of deposit
    */
    global Account clcommon__Account__r;
    /* This field shows the owner (Account) of deposit
    */
    global Id clcommon__Account__c;
    /* This field shows the owner (Contact) of deposit
    */
    global Contact clcommon__Contact__r;
    /* This field shows the owner (Contact) of deposit
    */
    global Id clcommon__Contact__c;
    /* This contains the current deposit amount.
    */
    global Double clcommon__Current_Deposit_Amount__c;
    /* The contains the current deposit rate for the deposit.
    */
    global Double clcommon__Current_Deposit_Rate__c;
    /* This field shows the current amount available for a particular deposit.
    */
    global Double clcommon__Deposit_Amount__c;
    /* This field stores the value of interest accrued for a particular deposit from previous accrual date.
    */
    global Double clcommon__Deposit_Interest_Accrued__c;
    /* This field stores the value of interest paid for a particular deposit till current system date.
    */
    global Double clcommon__Deposit_Interest_Paid__c;
    /* This field stores the value of interest posted for a particular deposit till current system date.
    */
    global Double clcommon__Deposit_Interest_Posted__c;
    /* This field stores the value of interest remaining for a particular deposit till previous accrual date.
    */
    global Double clcommon__Deposit_Interest_Remaining__c;
    /* This field shows the current rate of interest for this deposit
    */
    global Double clcommon__Deposit_Rate__c;
    /* This field stores the external reference number for this record.
    */
    global String clcommon__External_Reference_Number__c;
    /* It refers to the parent deposit record.
    */
    global clcommon__Deposit__c clcommon__Parent_Deposit__r;
    /* It refers to the parent deposit record.
    */
    global Id clcommon__Parent_Deposit__c;
    /* This field represents the priority for a deposit among multiple deposits attached to the same contract
    */
    global Double clcommon__Priority__c;
    /* This flag indicates that the corresponding transaction has been reversed.
    */
    global Boolean clcommon__Reversed__c;
    global Double clcommon__Sequence__c;
    /* The system date of deposit creation.
    */
    global Datetime clcommon__Transaction_Creation_Date__c;
    /* The date of deposit adjustment action or date of payment that caused this deposit to be created.
    */
    global Date clcommon__Transaction_Date__c;
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
    global List<clcommon__Deposit__Share> Shares;
    global List<clcommon__Deposit__c> clcommon__Deposits__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Deposit__c () 
    {
    }
}