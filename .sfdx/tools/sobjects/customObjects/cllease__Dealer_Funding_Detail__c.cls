// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Dealer_Funding_Detail__c {
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
    global cllease__Contract_Equipment__c cllease__Contract_Equipment__r;
    global Id cllease__Contract_Equipment__c;
    global Decimal cllease__Dealer_Charges__c;
    global cllease__Other_Transaction__c cllease__Dealer_Funding_Transaction__r;
    global Id cllease__Dealer_Funding_Transaction__c;
    global cllease__Contract_Parties__c cllease__Dealer__r;
    global Id cllease__Dealer__c;
    global Decimal cllease__Referral_Fee__c;
    global String cllease__Remark__c;
    global Boolean cllease__dealer_funded__c;
    global Date Date_Funded__c;
    global String Dealer_Address__c;
    global String Dealer_City__c;
    global String Dealer_ID__c;
    global String Dealer_Name__c;
    global String Dealer_Number__c;
    global String Dealer_Zip_Code__c;
    global String Dealer_State__c;
    global cllease__Disbursement_Transaction__c cllease__Disbursement_Transaction__r;
    global Id cllease__Disbursement_Transaction__c;
    global clcommon__Disbursement_Transaction__c cllease__Disbursement_Txn__r;
    global Id cllease__Disbursement_Txn__c;
    global Decimal cllease__Balance_Payable__c;
    global cllease__Dealer_Funding_Header__c cllease__Dealer_Funding_Header__r;
    global Id cllease__Dealer_Funding_Header__c;
    /* If checked, Dealer Funding Detail is reversed or canceled. If a disbursement transaction is already generated, it is also reversed.
    */
    global Boolean cllease__Reversed__c;
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

    global cllease__Dealer_Funding_Detail__c () 
    {
    }
}