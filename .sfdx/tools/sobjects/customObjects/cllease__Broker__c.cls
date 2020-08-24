// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Broker__c {
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
    global cllease__Lease_Account__c cllease__Lease_Contract__r;
    global Id cllease__Lease_Contract__c;
    /* Broker Account for this lease account.
    */
    global Account cllease__Account__r;
    /* Broker Account for this lease account.
    */
    global Id cllease__Account__c;
    /* Percent Rate for Commission
    */
    global Double cllease__Buy_Rate__c;
    global String cllease__Calculation_Method__c;
    /* Total Commission Amount
    */
    global Decimal cllease__Commission_Amount__c;
    /* Method how commission will be disbursed to broker.
    */
    global String cllease__Commission_Disbursement_Method__c;
    /* Commission Plan
    */
    global cllease__Commission_Plan__c cllease__Commission_Plan__r;
    /* Commission Plan
    */
    global Id cllease__Commission_Plan__c;
    /* Broker Contact for this lending account.
    */
    global Contact cllease__Contact__r;
    /* Broker Contact for this lending account.
    */
    global Id cllease__Contact__c;
    /* Check if the boker is enabled.
    */
    global Boolean cllease__Enabled__c;
    /* If the calculation method is percentage of lease amount, then this will be used while calculating the commission amount
    */
    global Double cllease__Factor__c;
    global Decimal cllease__Flat_Amount__c;
    /* Last Payment Date For Commission
    */
    global Date cllease__Last_Payment_Date__c;
    global String cllease__LeaseApplicationNumber__c;
    /* The maximum percentage of commission can be given
    */
    global Double cllease__Maximum_Commission_Percentage__c;
    /* Next Payment Date For Commission
    */
    global Date cllease__Next_Payment_Date__c;
    global String cllease__Plan_Description__c;
    /* Remaining Commission Amount
    */
    global Decimal cllease__Remaining_Commission_Amount_at_Funding__c;
    /* Commission Paid Amount
    */
    global Decimal cllease__Total_Commission_Paid_Amount__c;
    /* Upfront Commission Amount
    */
    global Decimal cllease__Upfront_Commission_Amount__c;
    /* Percentage of commission which will be disbursed to broker upfront.
    */
    global Double cllease__Upfront_Percentage__c;
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
    global List<cllease__Broker_Transactions__c> cllease__Broker_Transactions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Broker__c () 
    {
    }
}