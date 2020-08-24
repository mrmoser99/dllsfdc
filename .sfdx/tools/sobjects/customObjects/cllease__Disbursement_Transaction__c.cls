// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Disbursement_Transaction__c {
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
    global String cllease__ACH_Filename__c;
    global Date cllease__ACH_Sent_Date__c;
    global Account cllease__Account__r;
    global Id cllease__Account__c;
    global Decimal cllease__Amount__c;
    global cllease__Charge__c cllease__Charge__r;
    global Id cllease__Charge__c;
    global Date cllease__Due_Date__c;
    global Date cllease__GL_Date__c;
    global Boolean cllease__GL_Posted_Flag__c;
    global Date cllease__GL_Process_Date__c;
    global Boolean cllease__GL_Transaction_Flag__c;
    global String cllease__GL_processing_Message__c;
    global String cllease__Name__c;
    global Boolean cllease__Sent_To_ACH__c;
    global Date cllease__Transaction_Date__c;
    global cllease__Transaction_Sub_Type__c cllease__Transaction_Sub_Type__r;
    global Id cllease__Transaction_Sub_Type__c;
    global String cllease__Transaction_Type__c;
    global Boolean cllease__is_dealer_funding_txn__c;
    global String AP_Processing_Status__c;
    global Decimal Fee_Amount_To_Dealer__c;
    global String Int_OLMN_AP_link__c;
    global Date Payment_Date__c;
    global String Payment_Reference__c;
    global String Remark__c;
    global String Vendor_ID__c;
    global Decimal cllease__Accrue_Subvention__c;
    global Decimal cllease__Dealer_Payable_Amount__c;
    global clcommon__Disbursement_Transaction__c cllease__New_Disbursement_Txn__r;
    global Id cllease__New_Disbursement_Txn__c;
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
    global List<cllease__Dealer_Funding_Detail__c> cllease__Dealer_Funding_Details__r;
    global List<cllease__Debt_Schedule__c> cllease__Debt_Schedule__r;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Transaction_Details__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Disbursement_Transaction__c () 
    {
    }
}