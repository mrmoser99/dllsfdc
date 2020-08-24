// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class staging__Interface_Bank_Account__c {
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
    global String staging__ACH_Code__c;
    global String staging__Account_External_ID__c;
    global String staging__Account_Type__c;
    global String staging__Account_Usage__c;
    global Account staging__Account__r;
    global Id staging__Account__c;
    global Decimal staging__Accrued_Interest__c;
    global Boolean staging__Active__c;
    global Decimal staging__Available_Balance__c;
    global String staging__Bank_Account_Number__c;
    global String staging__Bank_Name__c;
    global String staging__Class_Code__c;
    global String staging__Contact_External_ID__c;
    global Decimal staging__Current_Balance__c;
    global Boolean staging__Employee_Account__c;
    global String staging__External_ID__c;
    global Double staging__Interest_Rate__c;
    global Decimal staging__Ledger_Balance__c;
    global Date staging__Maturity_Date__c;
    global Date staging__Opened_Date__c;
    global Decimal staging__Opening_Balance__c;
    global Decimal staging__Principal_Balance__c;
    global String staging__Routing_Number__c;
    global String staging__Source_ID__c;
    global String staging__Source_Name__c;
    global Boolean staging__Sync_Processed__c;
    global Double staging__Times_NSF__c;
    global Decimal staging__Average_Monthly_Balance__c;
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
    global List<genesis__Financial_Account_Applications__c> genesis__Financial_Account_Applications__r;
    global List<genesis__Treasury_Criteria_Results__c> genesis__Treasury_Criteria_Results__r;
    global List<staging__Interface_Bank_Account__History> Histories;
    global List<staging__Interface_Bank_Account__Share> Shares;
    global List<staging__Interface_Party__c> staging__Bank_Account_Members__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global staging__Interface_Bank_Account__c () 
    {
    }
}