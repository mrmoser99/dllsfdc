// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Contract_Parties__c {
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
    global String cllease__LeaseApplicationNumber__c;
    global Account cllease__Party_Account_Name__r;
    global Id cllease__Party_Account_Name__c;
    global Contact cllease__Party_Name__r;
    global Id cllease__Party_Name__c;
    global String cllease__Party_Type__c;
    global Date End_Date__c;
    global String External_Id__c;
    global Date Start_Date__c;
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
    global List<cllease__Contract_Equipment__c> cllease__Contract_Equipments__r;
    global List<cllease__Contract_Fee_Payment__c> cllease__Contract_Fee_Payments__r;
    global List<cllease__Dealer_Funding_Detail__c> cllease__Dealer_Equipment_details__r;
    global List<cllease__Dealer_Funding_Header__c> cllease__Dealer_Funding_Header__r;
    global List<cllease__Debt_Detail__c> cllease__Debt_Details__r;
    global List<cllease__Other_Transaction__c> cllease__Other_Transactions__r;
    global List<cllease__Subsidy__c> cllease__Subsidy__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Contract_Parties__c () 
    {
    }
}