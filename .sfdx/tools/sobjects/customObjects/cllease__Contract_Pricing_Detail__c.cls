// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Contract_Pricing_Detail__c {
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
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Boolean cllease__Arrears__c;
    /* Credit Grade of customer.
    */
    global String cllease__Credit_Grade__c;
    global String cllease__Days_Convention__c;
    global Boolean cllease__Enabled_Flag__c;
    /* Equipment class.
    */
    global String cllease__Equipment_Class__c;
    /* Condition of equipment.
    */
    global String cllease__Equipment_Condition__c;
    global String cllease__LeaseApplicationNumber__c;
    global Decimal cllease__Maximum_Financed_Amount__c;
    /* Total rental payment made by customer per period.
    */
    global Decimal cllease__Payment_Amount_Derived__c;
    /* Total rental payment made by customer per period.
    */
    global Decimal cllease__Payment_Amount_Per_Period__c;
    /* Payment frequency.
    */
    global String cllease__Payment_Frequency__c;
    /* Amount on which rent factor is based on.
    */
    global Decimal cllease__Rate_Factor_Based_On_Amount__c;
    global Double cllease__Rate_Factor__c;
    global Decimal cllease__Residual_Amount__c;
    /* Residual Percent, applicable only when the residual type is Fair Market Value.
    */
    global Double cllease__Residual_Percent__c;
    /* Applicable only when the residual type is "Term Residual"
    */
    global Double cllease__Residual_Term__c;
    /* Type of residual associated with this pricing.
    */
    global String cllease__Residual_Type__c;
    /* This is the pricing user selected for the lease application.
    */
    global Boolean cllease__Selected__c;
    global Double cllease__Term__c;
    /* Sum of all the rental payments made by customer.
    */
    global Decimal cllease__Total_Payments_Derived__c;
    /* Sum of all the rental payments made by customer.
    */
    global Decimal cllease__Total_Payments__c;
    global String cllease__Usage_Of_Equipment__c;
    /* Year in which equipment is manufactured.
    */
    global String cllease__Year_Of_Manufacture__c;
    /* The maximum percentage to which the asset can be financed.
    */
    global Double cllease__Yield_Percent__c;
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

    global cllease__Contract_Pricing_Detail__c () 
    {
    }
}