// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Application_Decisions__c {
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
    /* Number of Months used for Average cash Flow.
    */
    global Double genesis__Average_Cash_Flow_Basis__c;
    /* Average cash flow
    */
    global Decimal genesis__Average_Cash_Flow__c;
    global String genesis__Decision_Status__c;
    /* Delinquent child support amount
    */
    global Decimal genesis__Delinquent_Child_Support_Amount__c;
    /* check dismissed bankruptcy
    */
    global Boolean genesis__Dismissed_Bankruptcy__c;
    /* Number of Driving experience.
    */
    global Double genesis__Driving_Experience__c;
    global String genesis__Driving_Experience_based_on__c;
    /* Expected income
    */
    global Decimal genesis__Expected_Income__c;
    global String genesis__Healthcare_procedures__c;
    global Boolean genesis__Involuntary_Repossession__c;
    /* Check open bankruptcy
    */
    global Boolean genesis__Open_Bankruptcy__c;
    global Boolean genesis__Trigger_Decision_WorkFlow__c;
    /* Vehicle charge off
    */
    global Boolean genesis__Vehicle_Charge_Off__c;
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
    global List<genesis__Application_Decisions__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Application_Decisions__c () 
    {
    }
}