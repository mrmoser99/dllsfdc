// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Application_Fee__c {
    global Id Id;
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
    global genesis__Applications__c Application__r;
    global Id Application__c;
    global clcommon__Fee_Definition__c Fee__r;
    global Id Fee__c;
    global Decimal Amount__c;
    global genesis__Application_Equipment__c Equipment__r;
    global Id Equipment__c;
    global Decimal Fee_Amount__c;
    global String Fee_Name__c;
    global String Fee_Type__c;
    global String Frequency__c;
    global Double Number_of_Payments__c;
    /* First Payment Due Date
    */
    global Date Start_Date__c;
    global Decimal Total_Payment_Amount__c;
    global Decimal VAT__c;
    global Service_Fee_Escalation_Config__c Service_Fee_Escalation_Config__r;
    global Id Service_Fee_Escalation_Config__c;
    global String Equipment_List__c;
    global String Escalate_Service_On__c;
    global String Escalation_Frequency__c;
    global String Service_Escalate__c;
    global List<ActivityHistory> ActivityHistories;
    global List<Application_Fee_Payment__c> Application_Fee_Payment__r;
    global List<Application_Fee__History> Histories;
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
    global List<Service_Fee_Escalation_Config__c> Service_Fee_Escalation_Configs__r;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<genesis__Applications__c> Applications__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global Application_Fee__c () 
    {
    }
}