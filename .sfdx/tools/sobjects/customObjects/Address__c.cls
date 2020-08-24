// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Address__c {
    global Id Id;
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
    global Date LastActivityDate;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global Account Account__r;
    global Id Account__c;
    global String Address_Line_1__c;
    global String Address_Line_2__c;
    global String Address_Line_3__c;
    global String Address_Line_4__c;
    global String Address_Validation__c;
    global Boolean Bill_To_Usage__c;
    global String City__c;
    global String Country__c;
    global String County__c;
    global String Email_Address__c;
    global Boolean Install_At__c;
    global Boolean Marketing__c;
    global String Oracle_Site_ID__c;
    global Boolean Pay_To__c;
    global Boolean Primary_Address__c;
    global Boolean Ship_To__c;
    global String State__c;
    global String Usage__c;
    global String Validation_Status__c;
    global Datetime Validation_Time_Stamp__c;
    global String Zip_Code__c;
    global String All_Address__c;
    global String Account_Name__c;
    global String Account_Number__c;
    global List<Account> Accounts__r;
    global List<ActivityHistory> ActivityHistories;
    global List<Address_Usage__c> Address_Usages__r;
    global List<Address__History> Histories;
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
    global List<clcommon__Party__c> Parties__r;
    global List<cllease__Contract_Equipment__c> Contract_Equipments__r;
    global List<cllease__Lease_Account__c> LS_Contracts__r;
    global List<genesis__Application_Equipment__c> Equipments__r;
    global List<genesis__Applications__c> Applications1__r;
    global List<genesis__Quick_Quotes__c> Credit_Approvals__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global Address__c () 
    {
    }
}