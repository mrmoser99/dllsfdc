// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Variable_Rent_Rate_Card__c {
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
    /* The amount to be charged per unit when the Pricing method selected is FIXED.
    */
    global Double clcommon__Amount_Per_Unit__c;
    /* The amount to be charged when the calculated charged amount is more than this amount.
    */
    global Double clcommon__Maximum_Rent_Amount__c;
    /* The Measurement Unit for which the Variable Rent Rate Card is being created.
    */
    global String clcommon__Measurement_Unit__c;
    /* The amount to be charged when the calculated charged amount is less than this amount.
    */
    global Double clcommon__Minimum_Rent_Amount__c;
    /* The fee against which the usage based charge will be created
    */
    global clcommon__Fee_Definition__c clcommon__Variable_Rent_Fee__r;
    /* The fee against which the usage based charge will be created
    */
    global Id clcommon__Variable_Rent_Fee__c;
    /* There can be various methods on which the billing/charge creation will happen
    */
    global String clcommon__Variable_Rent_Method__c;
    global String clcommon__External_Id__c;
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
    global List<clcommon__Variable_Rent_Rate_Card_Details__c> clcommon__Variable_Rent_Rate_Card_Details__r;
    global List<clcommon__Variable_Rent_Rate_Card__Share> Shares;
    global List<clcommon__Variable_Rent_Rate__c> clcommon__Variable_Rent_Rate__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Variable_Rent_Rate_Card__c () 
    {
    }
}