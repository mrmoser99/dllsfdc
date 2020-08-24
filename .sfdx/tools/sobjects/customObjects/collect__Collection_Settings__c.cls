// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class collect__Collection_Settings__c {
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
    global Boolean collect__Activate_Broken_Promise_Alerts__c;
    /* Batch size for CreateActivity, ProcessActivity, and PromiseToPay jobs
    */
    global Double collect__Batch_Size__c;
    global Boolean collect__Charge_Debt_Collection_Fee_Loan__c;
    /* The number of days after which data in the Interface Objects will be deleted with respect to CreatedDate, provided they are processed and moved to CL Collection objects.
    */
    global Double collect__Days_To_Delete_Interface_Records__c;
    /* When Checked , all the related contracts will be assigned to single user and single queue.
    */
    global Boolean collect__Enable_Customer_Centric_Collection__c;
    global Boolean collect__Enable_Lease_Integration__c;
    global Boolean collect__Enable_Loan_Integration__c;
    global Boolean collect__Enable_Notify__c;
    /* When checked, strategies and queues will pick first applicable strategy or queue based on priority. Else, multiple strategies and queues may be applicable to a contract.
    */
    global Boolean collect__Enable_Priority_Behavior__c;
    global Boolean collect__Enable_Third_Party_Integration__c;
    /* If selected, system continues to process collection strategy actions (SMS, Email, Letters & Dialer) even after collections metrics threshold is reached.
    */
    global Boolean collect__Ignore_Collections_Metrics_Threshold__c;
    global String collect__Namespace_Prefix_Collections__c;
    global Boolean collect__Save_Dunning_Letters__c;
    global Boolean collect__Create_Automated_Payment_Setup__c;
    global Double collect__Activity_Completion_MaxRetries__c;
    /* Check this to enable Salesforce Task integration
    */
    global Boolean collect__Enable_Salesforce_Task_Integration__c;
    global Boolean collect__Location_Based_Collection_Metrics__c;
    /* Provide location fields in a comma separated format for Account and Contact respectively. 
Ex: BillingState,MailingState
If nothing is provided here, BillingState field is considered for Account and MailingState field is considered for Contact.
    */
    global String collect__Location_Field__c;
    global Boolean collect__Track_Borrower_Schedule_for_Notification__c;
    global String collect__API_URL__c;
    global Boolean collect__Borrower_Contact_Metrics__c;
    /* This field contains the template configuration name that need to be selected to send email to notify the borrower about the contract collection status changes.
    */
    global String collect__Collection_Status_Template_For_Email__c;
    /* This field contains the template configuration name that need to be selected to send SMS to notify the borrower about the contract collection status changes.
    */
    global String collect__Collection_Status_Template_For_SMS__c;
    global Boolean collect__Enable_Enhanced_Strategies__c;
    global Boolean collect__Hardship_Collections__c;
    global String collect__External_ID__c;
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

    global collect__Collection_Settings__c () 
    {
    }
}