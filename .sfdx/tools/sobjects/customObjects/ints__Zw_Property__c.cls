// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__Zw_Property__c {
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
    global Double ints__Area__c;
    global String ints__City__c;
    global Date ints__Last_Sold_Date__c;
    global Double ints__Last_Sold_Price__c;
    global Date ints__Last_Updated__c;
    global String ints__Latitude__c;
    global String ints__Longitude__c;
    global String ints__Neighborhood__c;
    /* Rent Zestimate amount received from Zillow
    */
    global Double ints__Rent_Zestimate_Amount__c;
    /* Rent Zestimate maximum value received from Zillow
    */
    global Double ints__Rent_Zestimate_Higher_Range__c;
    /* Lower range of rent Zestimate received from Zillow
    */
    global Double ints__Rent_Zestimate_Lower_Range__c;
    global String ints__State__c;
    global String ints__Street__c;
    global Double ints__Tax_Assessment_Amount__c;
    global String ints__Tax_Assessment_Year__c;
    global String ints__Year_Built__c;
    global String ints__ZPID__c;
    global Double ints__Zestimate_Percentile__c;
    global Double ints__Zetimate_Amount__c;
    global Double ints__Zetimate_Max_Value_Range__c;
    global Double ints__Zetimate_Min_Value_Range__c;
    global Double ints__Zetimate_Value_Change__c;
    global String ints__ZipCode__c;
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
    global List<ints__Property_Links_Images__c> ints__Zw_Property_Links_Images__r;
    global List<ints__Zw_Property__History> Histories;
    global List<ints__Zw_Property__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global ints__Zw_Property__c () 
    {
    }
}