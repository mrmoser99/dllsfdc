// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Application_Status_History__c {
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
    /* DateTime on which the application status is changed
    */
    global Datetime genesis__Changed_On__c;
    /* If the application is being process, then how much time in minutes elapsed between NOW and the when the application status was changed, else this will be 0
    */
    global Double genesis__Current_Status_Duration__c;
    /* If the application is being processes and it is the most recent status change record, then its true else false. This value is set based on the values provided in Closed Status in Org Parameters.
    */
    global Boolean genesis__Is_Latest_Status__c;
    /* New Status of application
    */
    global String genesis__New_Value__c;
    /* Old Status of application
    */
    global String genesis__Old_value__c;
    /* Stage of application
    */
    global String genesis__Stage__c;
    /* If it is not the most recent status change record, then the time elapsed between the status change( that is time when the new record is created minus changed on date/time value) is calculated in minutes and recorded in this field.
    */
    global Double genesis__Time_spent_in_new_status__c;
    /* Represents the total time an applications spends in a particular status(that is, the new status value on the record). It is the sum of Total time spent in new status + current status duration.
    */
    global Double genesis__Total_Time__c;
    global String genesis__New_Queue__c;
    global User genesis__New_User__r;
    global Id genesis__New_User__c;
    global String genesis__Old_Queue__c;
    global User genesis__Old_User__r;
    global Id genesis__Old_User__c;
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
    global List<genesis__Application_Status_History__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Application_Status_History__c () 
    {
    }
}