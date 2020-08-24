// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__Integration_Configuration__c {
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
    /* Field stores rest url of an api selected in Type field. For example: In D & B system, 'Cleanse & Match' REST API endpoint is '/V6.0/organizations'.
    */
    global String ints__API_Endpoint__c;
    /* Field stores developer API name of named credential record being used for storing external system login credentials.
    */
    global String ints__API_Named_Credential__c;
    global Boolean ints__Active__c;
    /* This field stores class name (custom implementation) of third-party system. If left blank system will use default implementation provided system provides support for external system.
    */
    global String ints__Adaptor_Class__c;
    /* This stores information about named credential used to configure third-party system login credentials
    */
    global String ints__Authorization_Named_Credential__c;
    global Double ints__Execution_Priority__c;
    global String ints__HTTP_Method__c;
    /* Field stores key-value pairs which are to be passed to HTTP Request header. JSON format should be used for key-value pair.
    */
    global String ints__Header_Parameters__c;
    /* Field stores type of integration service external system falls in. For ex: Credit Check, Bank Verification etc.
    */
    global String ints__Integration_Service__c;
    global String ints__Request_Mapping__c;
    global String ints__Response_Mapping__c;
    /* Select name of third-party system to be used for selected Integration Service.
    */
    global String ints__Third_Party_System__c;
    global String ints__Type__c;
    global Boolean ints__Use_Mocker__c;
    global String ints__External_ID__c;
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
    global List<ints__Additional_Parameters__c> ints__Additional_Parameters__r;
    global List<ints__Integration_Configuration__Share> Shares;
    global List<ints__MockObject__c> ints__MockObjects__r;
    global List<ints__Mocker__c> ints__Mocker__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global ints__Integration_Configuration__c () 
    {
    }
}