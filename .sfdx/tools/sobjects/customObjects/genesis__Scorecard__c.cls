// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Scorecard__c {
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
    /* Is the scorecard active?
    */
    global Boolean genesis__Enabled__c;
    global String genesis__Evaluation_Expression__c;
    global String genesis__Object_Type__c;
    /* Total weight that is distributed in the criterias
    */
    global Double genesis__Total_Weight__c;
    /* Do you want to use Input value of a field as score
    */
    global Boolean genesis__Use_Input_as_Score__c;
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
    global List<clcommon__Execution_Criteria__c> genesis__Execution_Criteria__r;
    global List<genesis__Account_Scorecard_Result__c> genesis__Account_Scorecard_Result__r;
    global List<genesis__Application_Scorecard__c> genesis__Application_Scorecards__r;
    global List<genesis__Application_s_Scorecard__c> genesis__Application_s_Scorecard__r;
    global List<genesis__Product_Scorecard_Junction__c> genesis__Scorecard_Junction__r;
    global List<genesis__Purpose_ScoreCard_Association__c> genesis__Purpose_ScoreCard_Association__r;
    global List<genesis__Scorecard_Criteria__c> genesis__Scorecard_Criteria__r;
    global List<genesis__Scorecard__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Scorecard__c () 
    {
    }
}