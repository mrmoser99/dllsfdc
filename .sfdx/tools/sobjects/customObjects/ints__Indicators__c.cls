// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__Indicators__c {
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
    global ints__Microbilt_Information__c ints__Microbilt_Information__r;
    global Id ints__Microbilt_Information__c;
    global Boolean ints__ACHIn__c;
    global Boolean ints__ACHOut__c;
    global Double ints__AvailableBalance__c;
    global Double ints__AverageAmountOfWithdrawalsInLast14Days__c;
    global Double ints__AverageAmountOfWithdrawalsInLast30Days__c;
    global Double ints__AverageAmountOfWithdrawalsInLast60Days__c;
    global Double ints__AverageAmountOfWithdrawalsInLast90Days__c;
    global Double ints__AverageBalanceForLast14Days__c;
    global Double ints__AverageBalanceForLast30Days__c;
    global Double ints__AverageBalanceForLast60Days__c;
    global Double ints__AverageBalanceForLast90Days__c;
    global Double ints__AverageBalance__c;
    global Double ints__AverageDaysTo50Percent__c;
    global Double ints__AverageDaysTo75Percent__c;
    global Double ints__AverageDaysTo95Percent__c;
    global Double ints__AvgAmtOfDepositsInLast14Days__c;
    global Double ints__AvgAmtOfDepositsInLast30Days__c;
    global Double ints__AvgAmtOfDepositsInLast60Days__c;
    global Double ints__AvgAmtOfDepositsInLast90Days__c;
    global Double ints__BalanceBelow0Last30Days__c;
    global Double ints__BalanceBelow0Last60Days__c;
    global Double ints__BalanceBelow0Last90Days__c;
    global Double ints__BalanceBelow150Last30Days__c;
    global Double ints__BalanceBelow150Last60Days__c;
    global Double ints__BalanceBelow150Last90Days__c;
    global Double ints__BalanceBelow50Last30Days__c;
    global Double ints__BalanceBelow50Last60Days__c;
    global Double ints__BalanceBelow50Last90Days__c;
    global Double ints__BalanceFrom3DaysBefore__c;
    global Double ints__CurrentBalance__c;
    global Datetime ints__HighestDay__c;
    global Double ints__HighestWeek__c;
    global Datetime ints__LargestDepositDate__c;
    global Double ints__LargestDeposit__c;
    global Datetime ints__LargestWithdrawalDate__c;
    global Double ints__LargestWithdrawal__c;
    global Datetime ints__LowestDay__c;
    global Double ints__LowestWeek__c;
    global Double ints__MostRecentDirectDeposit__c;
    global Double ints__NegativeOccurences__c;
    global Double ints__NumberOfDepositsOver1000__c;
    global Double ints__NumberOfDepositsOver100__c;
    global Double ints__NumberOfDepositsOver500__c;
    global Double ints__NumberOfWithdrawalsOver1000__c;
    global Double ints__NumberOfWithdrawalsOver100__c;
    global Double ints__NumberOfWithdrawalsOver500__c;
    global Datetime ints__SecondLargestDepositDate__c;
    global Double ints__SecondLargestDeposit__c;
    global Datetime ints__SecondLargestWithdrawalDate__c;
    global Double ints__SecondLargestWithdrawal__c;
    global Datetime ints__ThirdLargestDepositDate__c;
    global Double ints__ThirdLargestDeposit__c;
    global Datetime ints__ThirdLargestWithdrawalDate__c;
    global Double ints__ThirdLargestWithdrawal__c;
    global Double ints__TotalAmountOfDepositsAsCashInLast30Days__c;
    global Double ints__TotalAmountOfDepositsAsCashInLast60Days__c;
    global Double ints__TotalAmountOfDepositsAsCashInLast90Days__c;
    global Double ints__TotalAmountOfDepositsInLast14Days__c;
    global Double ints__TotalAmountOfDepositsInLast30Days__c;
    global Double ints__TotalAmountOfDepositsInLast60Days__c;
    global Double ints__TotalAmountOfDepositsInLast90Days__c;
    global Double ints__TotalAmountOfDeposits__c;
    global Double ints__TotalAmountOfWithdrawalsInLast14Days__c;
    global Double ints__TotalAmountOfWithdrawalsInLast30Days__c;
    global Double ints__TotalAmountOfWithdrawalsInLast60Days__c;
    global Double ints__TotalAmountOfWithdrawalsInLast90Days__c;
    global Double ints__TotalAmountOfWithdrawals__c;
    global Double ints__TotalAmtOfDepositsAsCashInLast14Days__c;
    global Double ints__TotalAmtOfWdwlsAsCashInLast14Days__c;
    global Double ints__TotalAmtOfWdwlsAsCashInLast30Days__c;
    global Double ints__TotalAmtOfWdwlsAsCashInLast60Days__c;
    global Double ints__TotalAmtOfWdwlsAsCashInLast90Days__c;
    global Double ints__TotalNumberOfDeposits__c;
    global Double ints__TotalNumberOfWithdrawals__c;
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
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global ints__Indicators__c () 
    {
    }
}