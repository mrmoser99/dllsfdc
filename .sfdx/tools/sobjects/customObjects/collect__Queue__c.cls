// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class collect__Queue__c {
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
    global User collect__Approver__r;
    global Id collect__Approver__c;
    global Boolean collect__Enabled__c;
    global String collect__Evaluation_Rule__c;
    global Boolean collect__Permanent__c;
    global Double collect__Priority__c;
    global String collect__Product_Type__c;
    /* Source System for which we are configuring the queue.
    */
    global collect__Source_System__c collect__Source_System__r;
    /* Source System for which we are configuring the queue.
    */
    global Id collect__Source_System__c;
    global Boolean collect__Third_Party_Transfer__c;
    global Double collect__Number_Of_Collectors__c;
    global Double collect__Open_Queue_Contract_Records__c;
    global String collect__External_ID__c;
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
    global List<collect__Collection_Configuration_Actions__c> collect__Strategy_Actions__r;
    global List<collect__Queue_Contract__c> collect__Queue_Contracts__r;
    global List<collect__Queue_Criteria__c> collect__Queue_Criteria__r;
    global List<collect__Queue_User__c> collect__Queue_Users__r;
    global List<collect__Queue__Share> Shares;
    global List<collect__User_Assignment_Detail__c> collect__User_Assignment_Details__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global collect__Queue__c () 
    {
    }
}