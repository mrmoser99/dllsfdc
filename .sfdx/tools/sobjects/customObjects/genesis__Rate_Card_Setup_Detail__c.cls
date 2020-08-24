// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Rate_Card_Setup_Detail__c {
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
    global genesis__Rate_Card_Setup_Header__c genesis__Rate_Card_Setup_Header__r;
    global Id genesis__Rate_Card_Setup_Header__c;
    global Boolean genesis__Arrears__c;
    /* Credit Grade of customer.
    */
    global String genesis__Credit_Grade__c;
    global genesis__Credit_Rating_Matrix__c genesis__Credit_Rating__r;
    global Id genesis__Credit_Rating__c;
    global String genesis__Days_Convention__c;
    global String genesis__Determining_Factor_Key_Value__c;
    global Boolean genesis__Enabled_Flag__c;
    /* Equipment class.
    */
    global String genesis__Equipment_Class__c;
    /* Condition of equipment.
    */
    global String genesis__Equipment_Condition__c;
    /* Interest Rate for the Rate Card Setup
    */
    global Double genesis__Interest_Rate__c;
    global Double genesis__Max_Term__c;
    global Decimal genesis__Maximum_Financed_Amount__c;
    global Double genesis__Min_Term__c;
    global Decimal genesis__Minimum_Financed_Amount__c;
    /* Total rental payment made by customer per period.
    */
    global Decimal genesis__Payment_Amount_Per_Period__c;
    /* Payment frequency.
    */
    global String genesis__Payment_Frequency__c;
    global String genesis__Pricing_Method__c;
    global String genesis__Product_Type__c;
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
    /* Source for the lead.
    */
    global String genesis__Source__c;
    global Double genesis__Term__c;
    /* Sum of all the rental payments made by customer.
    */
    global Decimal genesis__Total_Payments__c;
    global String genesis__Usage_Of_Equipment__c;
    /* Tick, if additional determining factors are required for evaluation criteria
    */
    global Boolean genesis__Use_Additional_Determining_Factors__c;
    /* Year in which equipment is manufactured.
    */
    global String genesis__Year_Of_Manufacture__c;
    /* The yield which this pricing will be generating.
    */
    global Double genesis__Yield_Percent__c;
    global String genesis__External_ID__c;
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
    global List<genesis__Application_Pricing_Detail__c> genesis__Pricing_Details__r;
    global List<genesis__Rate_Schedule_Setup__c> genesis__Rate_Schedule_Setup__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Rate_Card_Setup_Detail__c () 
    {
    }
}