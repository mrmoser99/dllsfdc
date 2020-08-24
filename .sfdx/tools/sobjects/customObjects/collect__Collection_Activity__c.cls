// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class collect__Collection_Activity__c {
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
    global Date LastActivityDate;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global String collect__Account_Email__c;
    global User collect__Account_Manager__r;
    global Id collect__Account_Manager__c;
    global Account collect__Account__r;
    global Id collect__Account__c;
    global String collect__Action__c;
    /* The date on which the activity is to be performed.
    */
    global Datetime collect__Activity_Date__c;
    global collect__Collection_Configuration_Actions__c collect__Collection_Configuration_Action__r;
    global Id collect__Collection_Configuration_Action__c;
    global collect__Collection_Configuration__c collect__Collection_Configuration__r;
    global Id collect__Collection_Configuration__c;
    global Boolean collect__Completed__c;
    /* Date on which the activity is completed.
    */
    global Datetime collect__Completion_Date__c;
    global cnotify__Configuration__c collect__Configuration__r;
    global Id collect__Configuration__c;
    global clcommon__Event_Configuration__c collect__Configuration_common__r;
    global Id collect__Configuration_common__c;
    global Contact collect__Contact__r;
    global Id collect__Contact__c;
    global Double collect__Days_Past_Due__c;
    global Double collect__Delinquent_Amount__c;
    global collect__Loan_Account__c collect__Dev_Contract__r;
    global Id collect__Dev_Contract__c;
    global String collect__Dunning_Letter_Id__c;
    global Boolean collect__Exclusion_Applied__c;
    global String collect__Execution_Failure_Reason__c;
    global Decimal collect__Fees_Due__c;
    global String collect__Lease_Account_Id__c;
    global String collect__Loan_Account_Id__c;
    global String collect__Loan_Account_Name__c;
    global Date collect__Oldest_Due_Date__c;
    global Decimal collect__Principal_Interest_Due__c;
    global collect__Promise_To_Pay__c collect__Promise_To_Pay__r;
    global Id collect__Promise_To_Pay__c;
    global Double collect__Reminder_Day__c;
    global cnotify__Template_Configuration__c collect__Template_Configuration__r;
    global Id collect__Template_Configuration__c;
    global clcommon__Template_Configuration__c collect__Template_Configuration_common__r;
    global Id collect__Template_Configuration_common__c;
    global collect__Action_Configuration__c collect__Action_Configuration__r;
    global Id collect__Action_Configuration__c;
    global String Billing_Email_Address__c;
    global cllease__Lease_Account__c LS_Contract__r;
    global Id LS_Contract__c;
    global String collect__Description__c;
    global String collect__Failure_Reason__c;
    global Boolean collect__Send_Communication_To_All__c;
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Event> Events;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OpenActivity> OpenActivities;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<clcommon__Notification__c> collect__commonNotifications__r;
    global List<cnotify__Notification__c> collect__Notifications__r;
    global List<collect__Collection_Activity__Share> Shares;
    global List<collect__Dunning_Letter_Content__c> collect__Dunning_Letter_Content__r;
    global List<collect__Interaction_Log__c> collect__Interaction_Logs__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global collect__Collection_Activity__c () 
    {
    }
}