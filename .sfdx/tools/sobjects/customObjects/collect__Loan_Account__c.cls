// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class collect__Loan_Account__c {
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
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global Boolean collect__ACH_On__c;
    global Account collect__Account__r;
    global Id collect__Account__c;
    global String collect__Aging__c;
    global Double collect__Amount_to_Current__c;
    global collect__Contract_Status__c collect__Collection_Status__r;
    global Id collect__Collection_Status__c;
    global Contact collect__Contact__r;
    global Id collect__Contact__c;
    global Double collect__Current_Payment_Amount__c;
    global Double collect__Days_Past_Due__c;
    global Double collect__Delinquent_Amount__c;
    global String collect__External_ID__c;
    global collect__Fee_Set__c collect__Fee_Set__r;
    global Id collect__Fee_Set__c;
    global Double collect__Fees_Remaining__c;
    global Boolean collect__Invalid_Data__c;
    global Double collect__Last_Payment_Amount__c;
    global Date collect__Last_Payment_Date__c;
    global collect__Loan_Product__c collect__Loan_Product_Name__r;
    global Id collect__Loan_Product_Name__c;
    global String collect__Loan_Status__c;
    global Double collect__Number_of_Days_Overdue__c;
    global Date collect__OT_ACH_Debit_Date__c;
    global Double collect__OT_ACH_Debit_Day__c;
    global Date collect__OT_ACH_End_Date__c;
    global Double collect__OT_ACH_Fee_Amount__c;
    global Date collect__OT_ACH_Next_Debit_Date__c;
    global Double collect__OT_ACH_Payment_Amount__c;
    global Date collect__OT_ACH_Start_Date__c;
    global collect__Bank_Account__c collect__OT_Borrower_ACH__r;
    global Id collect__OT_Borrower_ACH__c;
    global Date collect__Oldest_Due_Date__c;
    global Double collect__Pay_Off_Amount_As_Of_Today__c;
    global Double collect__Pmt_Amt_Cur__c;
    global Date collect__Previous_Installment_Date__c;
    global collect__Source_System__c collect__Source_System__r;
    global Id collect__Source_System__c;
    global Double collect__Tolerance_Amount__c;
    global Double collect__Tolerance_Days__c;
    global Double collect__Tolerance_Percentage__c;
    global String collect__Account_Name__c;
    global String collect__Contact_Name__c;
    global String collect__Source_System_name__c;
    global Boolean collect__Write_Off__c;
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
    global List<clcommon__Party__c> collect__Parties__r;
    global List<collect__Charge__c> collect__Charges__r;
    global List<collect__Collection_Activity__c> collect__Collection_Activities__r;
    global List<collect__Contract_Collections_Metrics__c> collect__Contract_Collections_Metrics__r;
    global List<collect__Dunning_Letter_Content__c> collect__Dunning_Letter_Content__r;
    global List<collect__Hardship__c> collect__Hardship__r;
    global List<collect__Interaction_Log__c> collect__Interaction_Logs__r;
    global List<collect__Loan_Account__Share> Shares;
    global List<collect__Loan_Payment_Transaction__c> collect__Contract_Payment_Transactions__r;
    global List<collect__Loan_Payment_Transaction__c> collect__Loan_Payment_Transactions__r;
    global List<collect__Loan_account_Due_Details__c> collect__Dues_Details__r;
    global List<collect__One_Time_Transaction__c> collect__One_Time_Transactions__r;
    global List<collect__Payment_Arrangement__c> collect__Payment_Arrangement__r;
    global List<collect__Promise_To_Pay__c> collect__Promise_To_Pay__r;
    global List<collect__Queue_Contract__c> collect__Queue_Contracts__r;
    global List<collect__Repayment_Schedule__c> collect__Dev_Repayment_Schedule__r;
    global List<collect__Repossession__c> collect__Repossessions__r;
    global List<collect__Settlements_Configuration__c> collect__Settlement_Configurations__r;
    global List<collect__User_Assignment_Detail__c> collect__User_Assignment_Details__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global collect__Loan_Account__c () 
    {
    }
}