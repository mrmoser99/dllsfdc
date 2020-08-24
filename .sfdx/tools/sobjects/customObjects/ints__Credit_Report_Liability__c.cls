// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__Credit_Report_Liability__c {
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
    global ints__Credit_Report__c ints__CreditReport__r;
    global Id ints__CreditReport__c;
    global String ints__AccountClosedDate__c;
    global String ints__AccountIdentifier__c;
    global Date ints__AccountOpenDatee__c;
    global String ints__AccountOpenedDate__c;
    global String ints__AccountOwnershipType__c;
    global String ints__AccountPaidDate__c;
    global String ints__AccountReportedDate__c;
    global String ints__AccountStatusType__c;
    global String ints__AccountType__c;
    global String ints__BorrowerID__c;
    global String ints__ChargeOffAmount__c;
    global String ints__ConsumerDisputeIndicator__c;
    global String ints__CreditBusinessType__c;
    global String ints__CreditFileID__c;
    global String ints__CreditLiabilityID__c;
    global String ints__CreditLimitAmount__c;
    global String ints__CreditLoanType__c;
    global String ints__CreditTradeReferenceID__c;
    global String ints__Credit_Repository__c;
    global String ints__Creditor_City__c;
    global String ints__Creditor_Name__c;
    global String ints__Creditor_Phone__c;
    global String ints__Creditor_PostalCode__c;
    global String ints__Creditor_State__c;
    global String ints__Creditor_StreetAddress__c;
    global String ints__Current_Rating__c;
    global String ints__HighCreditAmount__c;
    global String ints__Highest_Adverse_Rating__c;
    global String ints__LastActivityDate__c;
    global String ints__Late_Count__c;
    global String ints__ManualUpdateIndicator__c;
    global String ints__MonthlyPaymentAmount__c;
    global String ints__MonthsRemainingCount__c;
    global String ints__MonthsReviewedCount__c;
    global String ints__Most_Recent_Adverse_Rating__c;
    global String ints__PastDueAmount__c;
    global String ints__Payment_Pattern__c;
    global String ints__Payment_Start_Date__c;
    global String ints__TermsDescription__c;
    global String ints__TermsMonthsCount__c;
    global String ints__TermsSourceType__c;
    global String ints__UnpaidBalanceAmount__c;
    global Decimal ints__Monthly_Payment_Amount__c;
    global Double ints__Tradeline_Open_Days_Formula__c;
    global Double ints__Tradeline_Open_Days__c;
    global Decimal ints__Unpaid_Balance_Amount__c;
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
    global List<ints__Credit_Report_Liability_Credit_Comment__c> ints__CreditReportLiabilityCreditComment__r;
    global List<ints__Credit_Report_Liability_PAR__c> ints__CreditReportLiabilityPAR__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global ints__Credit_Report_Liability__c () 
    {
    }
}