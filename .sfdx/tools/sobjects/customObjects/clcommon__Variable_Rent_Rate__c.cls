// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Variable_Rent_Rate__c {
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
    /* The equipment to which this Variable Rent Rate should be attached
    */
    global clcommon__Collateral__c clcommon__Equipment__r;
    /* The equipment to which this Variable Rent Rate should be attached
    */
    global Id clcommon__Equipment__c;
    /* The latest Variable Rent Rate reading
    */
    global Double clcommon__Current_Variable_Rent_Rate_Reading__c;
    /* Next usage generation date for this Variable Rent Rate
    */
    global Date clcommon__Next_Usage_Generation_Date__c;
    /* Active - Charge has to be created against this Variable Rent Rate .
Inactive - Charge will not be created against this Variable Rent Rate.
    */
    global String clcommon__Status__c;
    /* Enter the unit upto which the usage will be free
    */
    global Double clcommon__Usage_Allowance__c;
    /* Count – Every time the actual count of units used between the last charged period and current is entered.
Total – Every time the total meter reading is entered.
    */
    global String clcommon__Variable_Rent_Basis__c;
    /* This signifies which rate card is attached
    */
    global clcommon__Variable_Rent_Rate_Card__c clcommon__Variable_Rent_Rate_Card__r;
    /* This signifies which rate card is attached
    */
    global Id clcommon__Variable_Rent_Rate_Card__c;
    global String clcommon__External_Id__c;
    /* This amount will be applied, instead of using the one from Rate Card
    */
    global Decimal clcommon__Override_Amount_Per_Unit__c;
    /* If this flag is checked, then the override value is used for charge calculation
    */
    global Boolean clcommon__Override_Rate__c;
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
    global List<clcommon__Meter_Reading__c> clcommon__Meter_Reading__r;
    global List<cllease__Charge__c> cllease__Charges__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Variable_Rent_Rate__c () 
    {
    }
}