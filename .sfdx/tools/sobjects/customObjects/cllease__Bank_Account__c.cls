// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Bank_Account__c {
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
    global String cllease__ACH_Code__c;
    global String cllease__Account_Type__c;
    global String cllease__Account_Usage__c;
    global Account cllease__Account__r;
    global Id cllease__Account__c;
    global Boolean cllease__Active__c;
    global String cllease__Bank_Account_Number__c;
    global cllease__Branch_Location__c cllease__Bank_Location__r;
    global Id cllease__Bank_Location__c;
    global String cllease__Bank_Name__c;
    global Contact cllease__Contact__r;
    global Id cllease__Contact__c;
    global String cllease__Relationship_Type__c;
    global String cllease__Routing_Number__c;
    global List<Account> cllease__Accounts__r;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<Contact> cllease__Contacts__r;
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
    global List<cllease__Bank_Account__Share> Shares;
    global List<cllease__Contract_ACH_Setup__c> cllease__Contract_ACH_Setup__r;
    global List<cllease__Lease_Account__c> cllease__Contracts__r;
    global List<cllease__Other_Transaction__c> cllease__Other_Transactions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Bank_Account__c () 
    {
    }
}