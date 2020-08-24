// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class dsfs__EnvelopeConfiguration__c {
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
    global Boolean dsfs__Active__c;
    global String dsfs__CEM__c;
    global String dsfs__CES__c;
    global Double dsfs__ExpireAfter__c;
    global Boolean dsfs__ExpireEnabled__c;
    global Double dsfs__ExpireWarn__c;
    global Boolean dsfs__Expires__c;
    global Boolean dsfs__LA__c;
    global Boolean dsfs__LF__c;
    global Boolean dsfs__LoadDefaultContacts__c;
    global String dsfs__OCO__c;
    global String dsfs__Object_Type__c;
    global Double dsfs__ReminderDelay__c;
    global Boolean dsfs__ReminderEnabled__c;
    global Double dsfs__ReminderFrequency__c;
    global Boolean dsfs__SAA__c;
    global Boolean dsfs__SCS__c;
    global Boolean dsfs__SEM__c;
    global Boolean dsfs__SES__c;
    global Boolean dsfs__SRS__c;
    global Boolean dsfs__SSB__c;
    global Boolean dsfs__STB__c;
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
    global List<dsfs__CustomParameterMap__c> dsfs__CustomParameterMaps__r;
    global List<dsfs__DocuSign_Envelope__c> dsfs__DocuSign_Envelopes__r;
    global List<dsfs__DocuSign_Status__c> dsfs__DocuSign_Status__r;
    global List<dsfs__EnvelopeConfiguration__History> Histories;
    global List<dsfs__EnvelopeConfiguration__Share> Shares;
    global List<dsfs__Recipient__c> dsfs__Recipients__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global dsfs__EnvelopeConfiguration__c () 
    {
    }
}