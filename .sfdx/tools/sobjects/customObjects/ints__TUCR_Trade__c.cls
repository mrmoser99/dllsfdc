// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__TUCR_Trade__c {
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
    global ints__TransUnion_Credit_Report__c ints__TransUnion_Credit_Report__r;
    global Id ints__TransUnion_Credit_Report__c;
    global String ints__Account__c;
    global Double ints__Balance__c;
    global Double ints__CreditLimit__c;
    global String ints__DateLastActivity__c;
    global String ints__DateOpened__c;
    global String ints__DateRevised__c;
    global String ints__Frequency__c;
    global Double ints__HighCredit__c;
    global String ints__Joint__c;
    global Double ints__MOP__c;
    global String ints__MemberCode__c;
    global String ints__MemberName__c;
    global Double ints__MonthsReviewed__c;
    global String ints__Narrative1__c;
    global String ints__Narrative2__c;
    global Double ints__PastDue__c;
    global String ints__PaymentPatternStartDate__c;
    global String ints__PaymentPattern__c;
    global Double ints__Payment__c;
    global Double ints__Plus30__c;
    global Double ints__Plus60__c;
    global Double ints__Plus90__c;
    global String ints__Type__c;
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
    global List<ints__TUCR_Trade__History> Histories;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global ints__TUCR_Trade__c () 
    {
    }
}