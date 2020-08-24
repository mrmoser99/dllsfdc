// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Employee_FinAccount_Transaction_Access__c {
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
    /* Flag to determine whether this Employee Financial Account Transaction Access is active or not.
    */
    global Boolean genesis__Active__c;
    /* Flag to determine whether the Approval access is active or not.
    */
    global Boolean genesis__Approval__c;
    /* Reference to Financial account application for which this Employee Financial Account Transaction Access shall be associated.
    */
    global genesis__Financial_Account_Applications__c genesis__Financial_Account_Applications__r;
    /* Reference to Financial account application for which this Employee Financial Account Transaction Access shall be associated.
    */
    global Id genesis__Financial_Account_Applications__c;
    /* Flag to determine whether the transaction access is at employee level or at financial account  level.
    */
    global Boolean genesis__Global_Transaction_Access__c;
    /* Reference to clcommon Party for which this Employee Financial Account Transaction Access shall be associated.
    */
    global clcommon__Party__c genesis__Party__r;
    /* Reference to clcommon Party for which this Employee Financial Account Transaction Access shall be associated.
    */
    global Id genesis__Party__c;
    /* Flag to determine whether the Transact access is active or not.
    */
    global Boolean genesis__Transact__c;
    /* Flag to determine whether the view access is active or not.
    */
    global Boolean genesis__View__c;
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
    global List<genesis__Employee_FinAccount_Transaction_Access__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Employee_FinAccount_Transaction_Access__c () 
    {
    }
}