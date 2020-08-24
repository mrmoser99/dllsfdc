// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Rate_Schedule_Setup__c {
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
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global Double genesis__Interest_Rate__c;
    global Date genesis__Rate_Change_Date_Next__c;
    global Double genesis__Sequence__c;
    global Date genesis__Start_Date__c;
    /* This field stores the applicable Index Rate at the time of pricing selection.
    */
    global Double genesis__Base_Rate__c;
    /* This field is a reference to index from which the rate schedule gets the interest rate
    */
    global clcommon__Floating_Rate_Index__c genesis__Index__r;
    /* This field is a reference to index from which the rate schedule gets the interest rate
    */
    global Id genesis__Index__c;
    /* This field captures the margin rate over the index rate
    */
    global Double genesis__Margin_Rate__c;
    /* This field is a reference to corresponding Rate Card Setup Detail record.
    */
    global genesis__Rate_Card_Setup_Detail__c genesis__Rate_Card_Setup_Detail__r;
    /* This field is a reference to corresponding Rate Card Setup Detail record.
    */
    global Id genesis__Rate_Card_Setup_Detail__c;
    /* This field represents the rate type for a rate schedule record whether it is fixed or floating.
    */
    global String genesis__Rate_Type__c;
    /* This field will specify how many units of the duration is applicable for this rate schedule record.
    */
    global Double genesis__Terms__c;
    /* This field will hold the unit of duration for which the rate schedule record will hold true.
    */
    global String genesis__Unit__c;
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
    global List<genesis__Rate_Schedule_Setup__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Rate_Schedule_Setup__c () 
    {
    }
}