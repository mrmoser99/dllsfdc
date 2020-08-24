// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__Yodlee_Call__c {
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
    global Account ints__Account__r;
    global Id ints__Account__c;
    global String ints__Client_Id__c;
    global String ints__Client_Name__c;
    global Contact ints__Contact__r;
    global Id ints__Contact__c;
    global String ints__Container_Type__c;
    global String ints__Currency_Code__c;
    global Double ints__End_Number__c;
    global Date ints__From_Date__c;
    global Double ints__Higher_Fetch_Limit__c;
    global String ints__Ignore_User_Input__c;
    global Double ints__Lower_Fetch_Limit__c;
    global Double ints__Start_Number__c;
    global Date ints__To_Date__c;
    global String ints__Transaction_Split_Type__c;
    global Double ints__Loan_Payments__c;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global Decimal genesis__Average_Income__c;
    global Decimal genesis__Average_Savings__c;
    global Decimal genesis__Based_on_Net_Income__c;
    global Decimal genesis__Based_on_Total_Income__c;
    global Decimal genesis__Business_Expenses__c;
    global Decimal genesis__Business_Income__c;
    global Decimal genesis__Discretionary_Expenses__c;
    global Decimal genesis__Living_Expenses__c;
    global Decimal genesis__Other_Income_Sources__c;
    global Decimal genesis__Personal_Income__c;
    global Decimal genesis__Total_Deposits__c;
    global Decimal genesis__Total_Gasoline_Expenses__c;
    global Decimal genesis__Total_Insurance_Expenses__c;
    global Decimal genesis__Total_Restaurant_Expenses__c;
    global Decimal genesis__Total_Salary__c;
    global Decimal genesis__Total_Telecom_Expenses__c;
    global Decimal genesis__Total_Transfers__c;
    global Decimal genesis__Total_Utility_Expenses__c;
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
    global List<ints__Site_Account__c> ints__Site_Accounts__r;
    global List<ints__Yodlee_Call__Share> Shares;
    global List<ints__Yodlee_Transaction__c> ints__Yodlee_Bank_Transactions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global ints__Yodlee_Call__c () 
    {
    }
}