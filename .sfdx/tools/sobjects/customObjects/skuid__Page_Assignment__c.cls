// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class skuid__Page_Assignment__c {
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
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    /* The Salesforce action type(s) to which this Page Assignment applies
    */
    global String skuid__Action_Type__c;
    /* The User that this Page Assignment is for, if any.
    */
    global User skuid__Assigned_To_User__r;
    /* The User that this Page Assignment is for, if any.
    */
    global Id skuid__Assigned_To_User__c;
    global String skuid__Context__c;
    global Boolean skuid__IsActive__c;
    global skuid__Page__c skuid__Page__r;
    global Id skuid__Page__c;
    /* The API / Developer Name of the Record Type to which this Page Assignment should apply
    */
    global String skuid__RecordTypeDeveloperName__c;
    /* Which SObject, or other scenario, will this Page Assignment be used for? Could also be an arbitrary name, such as "SiteHome", for running Skuid from the Visualforce Component.
    */
    global String skuid__SObject_Type__c;
    /* If checked, then standard layouts will be used instead of Skuid Pages for this Page Assignment.
    */
    global Boolean skuid__Use_Standard_Layouts__c;
    /* Describes the environment (e.g. Salesforce Classic, Lightning) in which the Page Assignment was designed to use
    */
    global String skuid__Environment_Type__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<skuid__Page_Assignment__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global skuid__Page_Assignment__c () 
    {
    }
}