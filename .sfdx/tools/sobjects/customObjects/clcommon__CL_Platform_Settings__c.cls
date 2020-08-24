// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__CL_Platform_Settings__c {
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
    global String clcommon__Namespace_Prefix__c;
    global String clcommon__PortalJS_Source__c;
    global String clcommon__Theme_Name__c;
    global Double clcommon__Batch_Size__c;
    global Date clcommon__Bill_Consolidation_Start_Date__c;
    /* This field indicates no of days after which Cash Receipts will be auto applied if not applied manually
    */
    global Double clcommon__Days_After_Auto_Apply_Cash_Receipts__c;
    /* If this field is checked then CLS products will use cash receipts.
    */
    global Boolean clcommon__Enable_Cash_Receipts__c;
    /* If this field is checked then the query in the DAG jobs will not be validated.
    */
    global Boolean clcommon__Skip_Query_Validation_For_DAG__c;
    global Boolean clcommon__Copy_Common_Address_To_Standard_Address__c;
    global Boolean clcommon__Disable_Triggers__c;
    /* If checked "Disburse" button will be enabled for Cash Receipt to disburse Cash Receipt Refunds
    */
    global Boolean clcommon__Enable_Cash_Receipt_Refund_Disbursement__c;
    /* If checked, then disbursement transactions will be created for cash receipt refunds instantly.
    */
    global Boolean clcommon__Instant_Disburse_Cash_Receipt_Refunds__c;
    global Boolean clcommon__Lock_Feature_Enabled__c;
    global String clcommon__Portal_State_Validator_Classname__c;
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

    global clcommon__CL_Platform_Settings__c () 
    {
    }
}