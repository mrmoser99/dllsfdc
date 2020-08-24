// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Task {
    global Id Id;
    global SObject Who;
    global Id WhoId;
    global SObject What;
    global Id WhatId;
    global String Subject;
    global Date ActivityDate;
    global String Status;
    global String Priority;
    global Boolean IsHighPriority;
    global User Owner;
    global Id OwnerId;
    global String Description;
    global String Type;
    global Boolean IsDeleted;
    global Account Account;
    global Id AccountId;
    global Boolean IsClosed;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global Boolean IsArchived;
    global Integer CallDurationInSeconds;
    global String CallType;
    global String CallDisposition;
    global String CallObject;
    global Datetime ReminderDateTime;
    global Boolean IsReminderSet;
    global Task RecurrenceActivity;
    global Id RecurrenceActivityId;
    global Boolean IsRecurrence;
    global Date RecurrenceStartDateOnly;
    global Date RecurrenceEndDateOnly;
    global String RecurrenceTimeZoneSidKey;
    global String RecurrenceType;
    global Integer RecurrenceInterval;
    global Integer RecurrenceDayOfWeekMask;
    global Integer RecurrenceDayOfMonth;
    global String RecurrenceInstance;
    global String RecurrenceMonthOfYear;
    global String RecurrenceRegeneratedType;
    global String TaskSubtype;
    global Datetime CompletedDateTime;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global Boolean genesis__Completion_Mandatory__c;
    global genesis__Department__c genesis__Department__r;
    global Id genesis__Department__c;
    global Boolean genesis__Is_Parallel__c;
    global genesis__Task_Setup__c genesis__Task_Setup__r;
    global Id genesis__Task_Setup__c;
    global genesis__Application_Collateral__c genesis__Application_Collateral__r;
    global Id genesis__Application_Collateral__c;
    global clcommon__Party__c genesis__Party__r;
    global Id genesis__Party__c;
    global Double genesis__Task_Order__c;
    global User genesis__User__r;
    global Id genesis__User__c;
    /* This field keeps track of completed tasks which are archived due to backward department movement or release application to queue. Tasks are archived when retention of task is disabled on Task Setup
    */
    global Boolean genesis__Is_Archived__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Task> RecurringTasks;
    global List<TaskFeed> Feeds;
    global List<TopicAssignment> TopicAssignments;
    global List<ContentVersion> FirstPublishLocation;
    global List<EmailMessage> Activity;
    global List<EmailStatus> Task;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> RecurrenceActivity;

    global Task () 
    {
    }
}