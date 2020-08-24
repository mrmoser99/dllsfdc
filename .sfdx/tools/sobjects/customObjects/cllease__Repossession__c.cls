// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Repossession__c {
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
    global Account cllease__Agent__r;
    global Id cllease__Agent__c;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Account cllease__Customer__r;
    global Id cllease__Customer__c;
    global String cllease__Delivery_Location_Type__c;
    global String cllease__Delivery_Location__c;
    /* Repossession Agent Email ID
    */
    global String cllease__Email_ID__c;
    global cllease__Contract_Equipment__c cllease__Equipment__r;
    global Id cllease__Equipment__c;
    global String cllease__Information_to_Lessor__c;
    global String cllease__LeaseApplicationNumber__c;
    global Contact cllease__Repossession_Agent__r;
    global Id cllease__Repossession_Agent__c;
    /* Date of Creation of Repossession request
    */
    global Date cllease__Request_Date__c;
    /* Date of Response by Agent
    */
    global Date cllease__Response_Date__c;
    /* Response from Repossession agent about asset repossession
    */
    global String cllease__Response__c;
    /* Repossession status
    */
    global String cllease__Status__c;
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
    global List<cllease__Repossession_Equipment__c> cllease__Repossession_Equipments__r;
    global List<cllease__Repossession__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Repossession__c () 
    {
    }
}