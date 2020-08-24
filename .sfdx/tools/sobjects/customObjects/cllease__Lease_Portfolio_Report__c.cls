// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Lease_Portfolio_Report__c {
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
    global Account cllease__Account__r;
    global Id cllease__Account__c;
    global Contact cllease__Contact__r;
    global Id cllease__Contact__c;
    global Date cllease__Contract_Date__c;
    global String cllease__Contract_ID__c;
    global String cllease__Contract_Type__c;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Date cllease__Creation_Date__c;
    global Decimal cllease__Documentation_Fees_Amount__c;
    global Decimal cllease__Equipment_Cost__c;
    global Decimal cllease__Initial_Direct_Cost__c;
    global Account cllease__Investor__r;
    global Id cllease__Investor__c;
    global String cllease__LeaseApplicationNumber__c;
    global cllease__Lease_Product__c cllease__Lease_Product_Name__r;
    global Id cllease__Lease_Product_Name__c;
    global Decimal cllease__Lease_Receivable_Amount__c;
    global Date cllease__Maturity_Date__c;
    global Decimal cllease__Residual_Amount__c;
    global Decimal cllease__Security_Deposit_Amount__c;
    global Double cllease__Term__c;
    global Decimal cllease__Unearned_Income_Lease__c;
    global Decimal cllease__Unearned_Residual_Income__c;
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
    global List<cllease__Lease_Portfolio_Report__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Lease_Portfolio_Report__c () 
    {
    }
}