// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class FMZ_CTA_Settings__c {
    global Id Id;
    global Boolean IsDeleted;
    global String Name;
    global SObject SetupOwner;
    global Id SetupOwnerId;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global String Complete_Apps_Action_Label__c;
    global String Complete_Apps_Call_to_Action__c;
    global String Complete_Apps_Complete_Message__c;
    global String Complete_Apps_Info_Column_Label__c;
    global String Complete_Apps_Label__c;
    global String Complete_Apps_Name_Column_Label__c;
    global String Convert_CC_Action_Label__c;
    global String Convert_CC_Call_to_Action__c;
    global String Convert_CC_Complete_Message__c;
    global String Convert_CC_Info_Column_Label__c;
    global String Convert_CC_Label__c;
    global String Convert_CC_Name_Column_label__c;
    global String Fund_Apps_Action_Label__c;
    global String Fund_Apps_Call_to_Action__c;
    global String Fund_Apps_Complete_Message__c;
    global String Fund_Apps_Info_Column_Label__c;
    global String Fund_Apps_Label__c;
    global String Fund_Apps_Name_Column_Label__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global FMZ_CTA_Settings__c () 
    {
    }
}