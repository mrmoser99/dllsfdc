// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Covenant__c {
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
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global Boolean clcommon__Active__c;
    global clcommon__Covenant_Definition__c clcommon__Covenant_Definition__r;
    global Id clcommon__Covenant_Definition__c;
    global String clcommon__Covenant_Description__c;
    global Date clcommon__Expiration_Date__c;
    /* This field is used to evaluate the financial covenant. It is only applicable if the Financial Operator is Between.
    */
    global Double clcommon__Financial_Indicator_High_Value__c;
    /* This field is used to evaluate the financial covenant. It is only applicable if the Financial Operator is Between.
    */
    global Double clcommon__Financial_Indicator_Low_Value__c;
    /* This field is used to evaluate the financial covenant.
    */
    global Double clcommon__Financial_Indicator__c;
    global String clcommon__Financial_Operator__c;
    global String clcommon__Frequency__c;
    /* This is the date on which the covenant will be evaluated next. For a new covenant, this is used as the start date.
    */
    global Date clcommon__Next_Evaluation_Date__c;
    global Double clcommon__Next_Evaluation_Day__c;
    /* This is the date on which the next notification will be generated for the concerned parties. A Covenant Evaluation Record is also generated on this day.
    */
    global Date clcommon__Next_Notification_Date__c;
    global Double clcommon__Next_Notification_Day__c;
    /* This is the number of days before the next evaluation date when a notification is created for concerned parties. A Covenant Evaluation History record is also created at the same time as the notification.
    */
    global Double clcommon__Notification_Days__c;
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
    global List<clcommon__Covenant_Association__c> clcommon__Covenant_Associations__r;
    global List<clcommon__Covenant_Evaluation__c> clcommon__Covenant_Evaluations__r;
    global List<clcommon__Covenant__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Covenant__c () 
    {
    }
}