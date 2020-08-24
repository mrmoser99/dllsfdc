// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class staging__Interface_Contract_Due_Details__c {
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
    global Double staging__Balance_Amount__c;
    global String staging__Contract_External_ID__c;
    global Boolean staging__DD_Primary_Flag__c;
    global Double staging__Due_Amt__c;
    global Date staging__Due_Date__c;
    global String staging__External_ID__c;
    global Boolean staging__Late_Charge_Applied__c;
    global Double staging__Payment_Amt__c;
    global Date staging__Payment_Date__c;
    global Boolean staging__Payment_Satisfied__c;
    global Double staging__Rental_Due_Amount__c;
    global String staging__Source_ID__c;
    global String staging__Source_Name__c;
    global Boolean staging__Sync_Processed__c;
    global Double staging__Tax_Due_Amount__c;
    global Double staging__Total_Due_Amount__c;
    global Double staging__Total_Paid_Amount__c;
    global Double staging__Transaction_Date__c;
    global Datetime staging__Transaction_Dt__c;
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
    global List<staging__Interface_Contract_Due_Details__History> Histories;
    global List<staging__Interface_Contract_Due_Details__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global staging__Interface_Contract_Due_Details__c () 
    {
    }
}