// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__TransUnion_Credit_Report__c {
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
    global Contact ints__Contact__r;
    global Id ints__Contact__c;
    global String ints__DOB__c;
    global String ints__File__c;
    global String ints__FirstName__c;
    global String ints__LastName__c;
    global String ints__OnFileDate__c;
    global String ints__SIN__c;
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
    global List<ints__TUCR_Address__c> ints__TUCR_Addresses__r;
    global List<ints__TUCR_Banking__c> ints__TUCR_Bankings__r;
    global List<ints__TUCR_ConsumerStatement__c> ints__Consumer_Statements__r;
    global List<ints__TUCR_CreditSummaryDetail__c> ints__TUCR_Credit_Summary_Details__r;
    global List<ints__TUCR_CreditSummary__c> ints__TURC_Credit_Summary__r;
    global List<ints__TUCR_Employment__c> ints__TUCR_Employments__r;
    global List<ints__TUCR_Error__c> ints__TUCR_Errors__r;
    global List<ints__TUCR_Inquiry__c> ints__Inquiries__r;
    global List<ints__TUCR_Legal__c> ints__Legals__r;
    global List<ints__TUCR_Message__c> ints__TUCR_Messages__r;
    global List<ints__TUCR_ScoreProduct__c> ints__TUCR_Score_ProductS__r;
    global List<ints__TUCR_Trade__c> ints__Trades__r;
    global List<ints__TUCR_TransAlert__c> ints__TUCR_TransAlerts__r;
    global List<ints__TransUnion_Credit_Report__History> Histories;
    global List<ints__TransUnion_Credit_Report__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global ints__TransUnion_Credit_Report__c () 
    {
    }
}