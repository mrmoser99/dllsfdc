// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__Emailage__c {
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
    global String ints__EAAdviceID__c;
    global String ints__EAAdvice__c;
    global String ints__EAReasonID__c;
    global String ints__EAReason__c;
    global String ints__EARiskBandID__c;
    global String ints__EARiskBand__c;
    global String ints__EAScore__c;
    global String ints__EAStatusID__c;
    global String ints__Response_Status__c;
    global String ints__company__c;
    global String ints__country__c;
    global String ints__description__c;
    global String ints__dob__c;
    global String ints__domainAge__c;
    global String ints__domainExists__c;
    global String ints__domaincategory__c;
    global String ints__domaincompany__c;
    global String ints__domaincorporate__c;
    global String ints__domaincountryname__c;
    global String ints__domainname__c;
    global Double ints__domainrelevantinfoID__c;
    global String ints__domainrelevantinfo__c;
    global Double ints__domainrisklevelID__c;
    global String ints__domainrisklevel__c;
    global String ints__eName__c;
    global String ints__emailAge__c;
    global String ints__emailExists__c;
    global String ints__email__c;
    global String ints__errorCode__c;
    global String ints__firstVerificationDate__c;
    global String ints__fraudRisk__c;
    global String ints__gender__c;
    global String ints__imageurl__c;
    global String ints__ip_anonymousdetected__c;
    global String ints__ip_callingcode__c;
    global String ints__ip_city__c;
    global String ints__ip_continentCode__c;
    global String ints__ip_corporateProxy__c;
    global String ints__ip_countryCode__c;
    global String ints__ip_country__c;
    global String ints__ip_isp__c;
    global String ints__ip_latitude__c;
    global String ints__ip_longitude__c;
    global String ints__ip_map__c;
    global String ints__ip_metroCode__c;
    global String ints__ip_netSpeedCell__c;
    global String ints__ip_org__c;
    global String ints__ip_region__c;
    global String ints__ip_reputation__c;
    global String ints__ip_risklevel__c;
    global String ints__ip_risklevelid__c;
    global String ints__ip_riskreason__c;
    global String ints__ip_riskreasonid__c;
    global String ints__ip_userType__c;
    global String ints__ipaddress__c;
    global String ints__lastVerificationDate__c;
    global String ints__location__c;
    global String ints__smfriends__c;
    global String ints__smlinks__c;
    global String ints__status__c;
    global String ints__title__c;
    global String ints__totalhits__c;
    global String ints__uniquehits__c;
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
    global List<ints__Emailage__History> Histories;
    global List<ints__Emailage__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global ints__Emailage__c () 
    {
    }
}