// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Sample_Contract__c {
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
    global String clcommon__Other_PE_Action__c;
    global String clcommon__Process_Enforcement_Action__c;
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global Double clcommon__Balance_Due_Amount__c;
    global Double clcommon__Balance_Tax_Amount__c;
    global clcommon__Cash_Receipt_Application__c clcommon__Cash_Receipt_Application__r;
    global Id clcommon__Cash_Receipt_Application__c;
    global clcommon__Consolidated_Invoice__c clcommon__Consolidated_Invoice__r;
    global Id clcommon__Consolidated_Invoice__c;
    global Contact clcommon__Contact__r;
    global Id clcommon__Contact__c;
    global Date clcommon__Due_Date__c;
    global clcommon__Collateral__c clcommon__Equipment__r;
    global Id clcommon__Equipment__c;
    global Double clcommon__Excess_Amount__c;
    global clcommon__Invoice__c clcommon__Invoice__r;
    global Id clcommon__Invoice__c;
    global String clcommon__Object_Type__c;
    global Double clcommon__Original_Due_Amount__c;
    global Double clcommon__Original_Tax_Amount__c;
    global clcommon__Sample_Contract__c clcommon__Parent_Object__r;
    global Id clcommon__Parent_Object__c;
    global String clcommon__Remarks__c;
    global String clcommon__Sample_Namespace__c;
    global String clcommon__Status__c;
    global Double clcommon__Transaction_Amount__c;
    global Date clcommon__Transaction_Date__c;
    global String clcommon__Summary_Record_Id__c;
    global Boolean clcommon__Summary__c;
    global Boolean clcommon__archived__c;
    global Boolean clcommon__master_archive_object__c;
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
    global List<clcommon__Sample_Contract__Share> Shares;
    global List<clcommon__Sample_Contract__c> clcommon__Children_Objects__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Sample_Contract__c () 
    {
    }
}