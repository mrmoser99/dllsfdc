// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class CongaURL_Settings__c {
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
    global String AD__c;
    global String CreditQryID__c;
    global String CreditTmpID__c;
    global String DandAEQID__c;
    global String DandAQryID__c;
    global String DandATmpID__c;
    global String DetailwithTempId__c;
    global String DetailwithoutTempId__c;
    global String DueDetailsLines__c;
    global String Equipment_contact__c;
    global String FinanceFee__c;
    global String INSFEE__c;
    global String INV__c;
    global String InterimRent__c;
    global String InvTempId__c;
    global String LateFee__c;
    global String LeaseEQID__c;
    global String LeaseQryID__c;
    global String LeaseTmpID__c;
    global String OrigFee__c;
    global String Quote_Equipment__c;
    global String Quote_Header__c;
    global String Summary_Quote__c;
    global String SumwithTempID__c;
    global String SumwithoutTempID__c;
    global String BillofSaleTemplate__c;
    global String BillofSale__c;
    global String BoSAdd__c;
    global String FinalNoticeLetterCongQueryID__c;
    global String FinalNoticeLetterCongaEmailTemplateID__c;
    global String FinalNoticeLetterCongaFromID__c;
    global String FinalNoticeLetterCongaTemplateID__c;
    global String Comm_TempID__c;
    global Double Days_Prior_to_Maturity_120__c;
    global Double Days_Prior_to_Maturity_60__c;
    global String InvoiceEverGreenTempID__c;
    global String MutipleStatesCommTempID__c;
    global String Specific_RI_TempID__c;
    global String States_Prior_to_Maturity_120__c;
    global String States_Prior_to_Maturity_RI_120__c;
    global String Charges__c;
    global String Adjustment__c;
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

    global CongaURL_Settings__c () 
    {
    }
}