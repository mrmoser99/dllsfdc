// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class staging__Interface_Contract__c {
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
    global Date LastActivityDate;
    global Boolean staging__ACH_On__c;
    global String staging__Account_External_ID__c;
    global Account staging__Account__r;
    global Id staging__Account__c;
    global Decimal staging__Accrued_Interest__c;
    global String staging__Aging__c;
    global Double staging__Amount_to_Current__c;
    global String staging__Application_Number__c;
    global String staging__Class_Code__c;
    global String staging__Contact_External_ID__c;
    global String staging__Contract_Type__c;
    global Double staging__Current_Payment_Amount__c;
    global Double staging__Days_Past_Due__c;
    global Double staging__Delinquent_Amount__c;
    global Boolean staging__Employee_Account__c;
    global String staging__External_ID__c;
    global Double staging__Fees_Remaining__c;
    global Double staging__Interest_Rate__c;
    global Boolean staging__Invalid_Data__c;
    global Double staging__Last_Payment_Amount__c;
    global Date staging__Last_Payment_Date__c;
    global Double staging__Late_Payments__c;
    global String staging__Loan_Status__c;
    global Date staging__Maturity_Date__c;
    global Boolean staging__Non_Accural__c;
    global Double staging__Number_of_Days_Overdue__c;
    global Date staging__OT_ACH_Debit_Date__c;
    global Double staging__OT_ACH_Debit_Day__c;
    global Date staging__OT_ACH_End_Date__c;
    global Double staging__OT_ACH_Fee_Amount__c;
    global Date staging__OT_ACH_Next_Debit_Date__c;
    global Double staging__OT_ACH_Payment_Amount__c;
    global Date staging__OT_ACH_Start_Date__c;
    global String staging__OT_Borrower_ACH_External_ID__c;
    global Date staging__Oldest_Due_Date__c;
    global Date staging__Opened_Date__c;
    global Decimal staging__Original_Amount__c;
    global Double staging__Pay_Off_Amount_As_Of_Today__c;
    global String staging__Payment_Frequency__c;
    global Double staging__Pmt_Amt_Cur__c;
    global Date staging__Previous_Installment_Date__c;
    global Decimal staging__Principal_Balance__c;
    global String staging__Rate_Type__c;
    global String staging__Send_Email_To__c;
    global String staging__Send_Letter_To__c;
    global String staging__Send_Message_To__c;
    global String staging__Source_ID__c;
    global String staging__Source_Name__c;
    global Boolean staging__Sync_Processed__c;
    global Boolean staging__TDR__c;
    global Double staging__Tolerance_Amount__c;
    global Double staging__Tolerance_Days__c;
    global Double staging__Tolerance_Percentage__c;
    global clcommon__CL_Product__c genesis__CL_Product__r;
    global Id genesis__CL_Product__c;
    global String staging__Loan_Lease_Type__c;
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Event> Events;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OpenActivity> OpenActivities;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<staging__Interface_Charge__c> staging__Interface_Charges__r;
    global List<staging__Interface_Contract__History> Histories;
    global List<staging__Interface_Contract__Share> Shares;
    global List<staging__Interface_Party__c> staging__Interface_Party__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global staging__Interface_Contract__c () 
    {
    }
}