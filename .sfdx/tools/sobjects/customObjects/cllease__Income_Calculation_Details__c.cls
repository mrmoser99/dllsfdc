// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Income_Calculation_Details__c {
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
    global Decimal cllease__Beginning_Net_Book_Value__c;
    global Decimal cllease__Capital_Recovery__c;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global String cllease__Days_Convention__c;
    global Date cllease__End_Date__c;
    global Decimal cllease__Ending_Net_Book_Value__c;
    global Decimal cllease__Income_Per_Day__c;
    global Decimal cllease__Income__c;
    global Double cllease__No_of_Days__c;
    global Decimal cllease__Payment_Amount__c;
    global Decimal cllease__Residual_Beginning_Value__c;
    global Decimal cllease__Residual_Ending_Value__c;
    global Decimal cllease__Residual_Income_Per_Day__c;
    global Decimal cllease__Residual_Income__c;
    global Date cllease__Start_Date__c;
    global Double cllease__Yield__c;
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
    global List<cllease__Income_Calculation_Details__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Income_Calculation_Details__c () 
    {
    }
}