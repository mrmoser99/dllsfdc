// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class collect__Lease_Account__c {
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
    global Boolean collect__ACH_On__c;
    global Account collect__Account__r;
    global Id collect__Account__c;
    global String collect__Aging__c;
    global Double collect__Amount_to_Current__c;
    global Contact collect__Contact__r;
    global Id collect__Contact__c;
    global Double collect__Current_Payment_Amount__c;
    global Double collect__Days_Past_Due__c;
    global Double collect__Delinquent_Amount__c;
    global collect__Fee_Set__c collect__Fee_Set__r;
    global Id collect__Fee_Set__c;
    global Double collect__Fees_Remaining__c;
    global Boolean collect__Invalid_Data__c;
    global Double collect__Last_Payment_Amount__c;
    global Date collect__Last_Payment_Date__c;
    global collect__Lease_Product__c collect__Lease_Product_Name__r;
    global Id collect__Lease_Product_Name__c;
    global String collect__Lease_Status__c;
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
    global List<collect__Dev_Charge__c> collect__Charges__r;
    global List<collect__Lease_Account__Share> Shares;
    global List<collect__Lease_Payment_Transaction__c> collect__Contract_Payment_Transactions__r;
    global List<collect__Lease_Payment_Transaction__c> collect__Lease_Payment_Transactions__r;
    global List<collect__Lease_account_Due_Details__c> collect__Dues_Details__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global collect__Lease_Account__c () 
    {
    }
}