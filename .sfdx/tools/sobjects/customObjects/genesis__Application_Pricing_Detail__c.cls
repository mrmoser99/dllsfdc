// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Application_Pricing_Detail__c {
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
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global Boolean genesis__Arrears__c;
    /* Credit Grade of customer.
    */
    global String genesis__Credit_Grade__c;
    global genesis__Credit_Rating_Matrix__c genesis__Credit_Rating__r;
    global Id genesis__Credit_Rating__c;
    global String genesis__Days_Convention__c;
    global Boolean genesis__Enabled_Flag__c;
    /* Equipment class.
    */
    global String genesis__Equipment_Class__c;
    /* Condition of equipment.
    */
    global String genesis__Equipment_Condition__c;
    global Double genesis__Interest_Rate__c;
    global Decimal genesis__Maximum_Financed_Amount__c;
    /* Total rental payment made by customer per period.
    */
    global Decimal genesis__Payment_Amount_Derived__c;
    /* Total rental payment made by customer per period.
    */
    global Decimal genesis__Payment_Amount_Per_Period__c;
    /* Payment frequency.
    */
    global String genesis__Payment_Frequency__c;
    global genesis__Rate_Card_Setup_Detail__c genesis__Rate_Card_Setup_Detail__r;
    global Id genesis__Rate_Card_Setup_Detail__c;
    /* Amount on which rent factor is based on.
    */
    global Decimal genesis__Rate_Factor_Based_On_Amount__c;
    global Double genesis__Rate_Factor__c;
    global Decimal genesis__Residual_Amount__c;
    /* Residual Percent, applicable only when the residual type is Fair Market Value.
    */
    global Double genesis__Residual_Percent__c;
    /* Applicable only when the residual type is "Term Residual"
    */
    global Double genesis__Residual_Term__c;
    /* Type of residual associated with this pricing.
    */
    global String genesis__Residual_Type__c;
    /* This is the pricing user selected for the loan application.
    */
    global Boolean genesis__Selected__c;
    global Double genesis__Term__c;
    /* Sum of all the rental payments made by customer.
    */
    global Decimal genesis__Total_Payments_Derived__c;
    /* Sum of all the rental payments made by customer.
    */
    global Decimal genesis__Total_Payments__c;
    global String genesis__Usage_Of_Equipment__c;
    /* Year in which equipment is manufactured.
    */
    global String genesis__Year_Of_Manufacture__c;
    /* The maximum percentage to which the asset can be financed.
    */
    global Double genesis__Yield_Percent__c;
    global Decimal Payment_Amount1__c;
    global String Payment_Frequency1__c;
    global Double Payment_Sequence__c;
    global Date Payment_Start_Date1__c;
    global Date Payment_Start_Date__c;
    global Decimal Tax__c;
    global Double Term1__c;
    /* Defines the type of pricing override action
    */
    global String genesis__Override_Type__c;
    /* This field represents the interest accrued on the application.
    */
    global Double genesis__Total_Interest__c;
    /* This field captures how pricing would be applied to the application. Supported values are Rate Card, Manual and Override
    */
    global String genesis__Type__c;
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
    global List<genesis__Applications__c> Applications__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Application_Pricing_Detail__c () 
    {
    }
}