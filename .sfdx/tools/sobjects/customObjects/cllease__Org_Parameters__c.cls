// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Org_Parameters__c {
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
    /* This field to limit no. of contracts needs to consider for batch execution as batch job
    */
    global Double cllease__Batch_job_limit__c;
    global String cllease__Custom_Fee_Calculator_Class__c;
    /* Organization wide tolerance value for lease repayments.
    */
    global Double cllease__Default_Tolerance_Rate__c;
    /* Digits are decimals for rounding.
    */
    global Double cllease__Digits_After_Decimals__c;
    /* This option disables all triggers. It is only to be used while migrating data into the system. At all other times, it must be disabled.
    */
    global Boolean cllease__Disable_Triggers__c;
    global Boolean cllease__Enable_Fractionalization__c;
    global Boolean cllease__Integrate_Salesforce_CRM__c;
    /* The loggin level of the application. Valid options are:
DEBUG, ERROR, NONE
    */
    global String cllease__Log_Level__c;
    /* This is MFiFlex internal. Do not delete/edit this value.
    */
    global String cllease__Namespace_Prefix__c;
    global String cllease__Rounding_Mode__c;
    /* When multiple companies are set up, you can run batch jobs for "All" companies or only the user's "Current Company". If no value is provided, batch jobs are run for all companies.
    */
    global String cllease__Run_Batch_Job_for_Companies__c;
    global Boolean cllease__Skip_equipment_master_selection__c;
    global String cllease__Statments_Logo_File_Name__c;
    /* 4 Field API names in order and format :  <totaldealercharges>, <capreduction>, <payabletodealer>,<financedAmount>
    */
    global String cllease__pricing_fields__c;
    /* If checked, all past dated receivables will be consolidated in single invoice irrespective of due dates otherwise consolidated based on their due dates
    */
    global Boolean cllease__Invoice_Due_on_Receivable_Due_Date__c;
    global Boolean cllease__Payment_On_Account_Mode__c;
    /* This option disables all triggers. It is only to be used while migrating data into the system. At all other times, it must be disabled.
    */
    global Boolean cllease__Tax_On_Charges_Accouting__c;
    /* Can be checked to use Transaction Date for creating GL Entries for Bills and Charges
    */
    global Boolean cllease__Use_Transaction_Date_For_GL_Entries__c;
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

    global cllease__Org_Parameters__c () 
    {
    }
}