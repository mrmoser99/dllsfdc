// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Cash_Account_Balance__c {
    global Id Id;
    global Boolean IsDeleted;
    global String Name;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Decimal cllease__Adjusted_Negative_Amount__c;
    global Decimal cllease__Adjusted_Positive_Amount__c;
    global String cllease__Balance_Sub_Type__c;
    global String cllease__Balance_Type__c;
    global Decimal cllease__ChargedOff_Amount__c;
    global Decimal cllease__Closing_Balance_Amount__c;
    global String cllease__GL_Account_Code__c;
    global cllease__GL_Account__c cllease__GL_Account__r;
    global Id cllease__GL_Account__c;
    global String cllease__LeaseApplicationNumber__c;
    global Decimal cllease__Opening_Balance_Amount__c;
    global Decimal cllease__Paid_Amount__c;
    global Decimal cllease__Posted_Amount__c;
    global Decimal cllease__Waived_Amount__c;
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
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Cash_Account_Balance__c () 
    {
    }
}