// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class dsfs__DocuSign_Recipient_Status__c {
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
    global dsfs__DocuSign_Status__c dsfs__Parent_Status_Record__r;
    global Id dsfs__Parent_Status_Record__c;
    global Account dsfs__Account__r;
    global Id dsfs__Account__c;
    global Contact dsfs__Contact__r;
    global Id dsfs__Contact__c;
    global Datetime dsfs__Date_Declined__c;
    global Datetime dsfs__Date_Delivered__c;
    global Datetime dsfs__Date_Sent__c;
    global Datetime dsfs__Date_Signed__c;
    global String dsfs__Decline_Reason_Extended__c;
    global String dsfs__Decline_Reason__c;
    global String dsfs__DocuSign_Recipient_Company__c;
    global String dsfs__DocuSign_Recipient_Email__c;
    global String dsfs__DocuSign_Recipient_Id__c;
    global String dsfs__DocuSign_Recipient_Title__c;
    global Double dsfs__DocuSign_Routing_Order__c;
    global String dsfs__Envelope_Id__c;
    global Lead dsfs__Lead__r;
    global Id dsfs__Lead__c;
    global String dsfs__Recipient_Status__c;
    global Date Equipment_Install_Date__c;
    global Boolean Release_Equipment_Signature__c;
    global Boolean Install_Dates_Assigned__c;
    global Date Release_Equipment_Signature_Date__c;
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
    global List<dsfs__DocuSign_Recipient_Status__History> Histories;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global dsfs__DocuSign_Recipient_Status__c () 
    {
    }
}