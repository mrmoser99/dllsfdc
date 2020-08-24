// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__Microbilt_Information__c {
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
    global Boolean ints__ACHIn__c;
    global Boolean ints__ACHOut__c;
    global String ints__AccountName__c;
    global Boolean ints__AccountNumberMatches__c;
    global Double ints__AccountNumber__c;
    global String ints__AccountOwnerFirstName__c;
    global String ints__AccountOwnerLastName__c;
    global Boolean ints__AccountOwnerMatches__c;
    global Boolean ints__AccountTypeMatches__c;
    global String ints__AccountType__c;
    global Double ints__AvailableBalance__c;
    global Double ints__AverageBalanceLast30Days__c;
    global Double ints__AverageBalance__c;
    global Double ints__Balance__c;
    global Contact ints__Contact__r;
    global Id ints__Contact__c;
    global String ints__CurrencyType__c;
    global Double ints__CurrentBalance__c;
    global Datetime ints__DateTime__c;
    global Double ints__DaysActive__c;
    global Double ints__DirectDepositAmountDiff__c;
    global Double ints__DirectDepositAmount__c;
    global Boolean ints__DirectDepositPayCycleMatches__c;
    global String ints__DirectDepositPayCycle__c;
    global String ints__DirectDepositor__c;
    global Double ints__GrossIncome__c;
    global Boolean ints__InstitutionNameMatches__c;
    global String ints__InstitutionName__c;
    global Double ints__MostRecentDirectDeposit__c;
    global Double ints__NSFCount14days__c;
    global Double ints__NSFCount30days__c;
    global Double ints__NSFCount60days__c;
    global Double ints__NSFCount90days__c;
    global Double ints__NSFCount__c;
    global String ints__Reference__c;
    global Boolean ints__RoutingNumberMatches__c;
    global String ints__RoutingNumber__c;
    global Double ints__Score__c;
    global String ints__Success__c;
    global Double ints__TotalDeposits__c;
    global Double ints__TotalWithdrawals__c;
    global String ints__Account_Number__c;
    /* Contains Most Recent Direct Deposit Information
    */
    global Datetime ints__Most_Recent_Direct_Deposit__c;
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
    global List<ints__Account_Details__c> ints__Account_Details__r;
    global List<ints__Indicators__c> ints__Indicators__r;
    global List<ints__Microbilt_Information__Share> Shares;
    global List<ints__Transaction__c> ints__Transactions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global ints__Microbilt_Information__c () 
    {
    }
}