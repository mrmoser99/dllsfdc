// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Due_Details__c {
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
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global Boolean clcommon__Bill_Satisfied__c;
    global clcommon__Company__c clcommon__Company__r;
    global Id clcommon__Company__c;
    global Decimal clcommon__Due_Amount__c;
    global Date clcommon__Due_Date__c;
    global String clcommon__Due_Type__c;
    global clcommon__Equipment_Sale_Quote__c clcommon__Equipment_Sale_Quote__r;
    global Id clcommon__Equipment_Sale_Quote__c;
    global Date clcommon__Payment_Date__c;
    global Boolean clcommon__Reversed__c;
    global String clcommon__Status__c;
    global Decimal clcommon__Tax_Amount__c;
    global Decimal clcommon__Total_Due_Amount__c;
    global Date clcommon__Transaction_Date__c;
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
    global List<clcommon__Due_Details__Share> Shares;
    global List<clcommon__Equipment_Sale_Quote_Line__c> clcommon__Equipment_Sale_Quote_Lines__r;
    global List<clcommon__Equipment_Transaction__c> clcommon__Equipment_Transactions__r;
    global List<clcommon__Payment_Transaction__c> clcommon__Payment_Transactions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Due_Details__c () 
    {
    }
}