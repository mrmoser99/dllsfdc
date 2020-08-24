// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class staging__Interface_Party__c {
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
    global String staging__Account_External_ID__c;
    global Account staging__Account__r;
    global Id staging__Account__c;
    global String staging__Contact_External_ID__c;
    global Double staging__Contingent_Liability__c;
    global String staging__Contract_External_ID__c;
    global String staging__External_Contract_ID__c;
    global String staging__External_ID__c;
    global staging__Interface_Contract__c staging__Interface_Contract__r;
    global Id staging__Interface_Contract__c;
    global String staging__Party_External_ID__c;
    global String staging__Party_Type__c;
    global String staging__Signer_Capacity__c;
    global String staging__Source_Name__c;
    global Boolean staging__Sync_Processed__c;
    global String staging__Type__c;
    global Boolean staging__isPrimary__c;
    global staging__Interface_Bank_Account__c staging__Interface_Bank_Account__r;
    global Id staging__Interface_Bank_Account__c;
    global Boolean staging__Active__c;
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
    global List<genesis__Financial_Account_Applications__c> genesis__Financial_Account_Applications__r;
    global List<staging__Interface_Party__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global staging__Interface_Party__c () 
    {
    }
}