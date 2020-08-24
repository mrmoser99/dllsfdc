// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Equipment_Detail__c {
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
    global Decimal clcommon__Dealer_Fees__c;
    global String clcommon__Equipment_Serial_Number__c;
    global Decimal clcommon__Estimated_Selling_Price__c;
    global Decimal clcommon__Other_Financed_Fees__c;
    global Decimal clcommon__Residual_Amount__c;
    global String clcommon__Status__c;
    global Decimal clcommon__Subsidy__c;
    global Decimal clcommon__Subvention__c;
    global cllease__Contract_Equipment__c cllease__Contract_Equipment__r;
    global Id cllease__Contract_Equipment__c;
    global genesis__Application_Equipment__c genesis__Equipment__r;
    global Id genesis__Equipment__c;
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
    global List<clcommon__Equipment_Detail__Share> Shares;
    global List<cllease__Asset_Return__c> cllease__Asset_Returns__r;
    global List<cllease__Asset_workbench__c> cllease__Asset_Workbenchs__r;
    global List<cllease__Other_Transaction__c> cllease__Other_Transactions__r;
    global List<cllease__Termination_Quote_Equipment__c> cllease__Termination_Quote_Equipment__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Equipment_Detail__c () 
    {
    }
}