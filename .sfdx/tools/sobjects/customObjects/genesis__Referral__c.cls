// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Referral__c {
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
    /* Account for which this referral shall be associated with
    */
    global Account genesis__Account__r;
    /* Account for which this referral shall be associated with
    */
    global Id genesis__Account__c;
    /* Captures the Application status.
    */
    global String genesis__Application_Creation_Status__c;
    /* Application for which this referral shall be associated with
    */
    global genesis__Applications__c genesis__Application__r;
    /* Application for which this referral shall be associated with
    */
    global Id genesis__Application__c;
    /* Asset Class for which this referral shall be associated with
    */
    global clcommon__Asset_Class__c genesis__Asset_Class__r;
    /* Asset Class for which this referral shall be associated with
    */
    global Id genesis__Asset_Class__c;
    /* User for which this Referral shall be associated with
    */
    global User genesis__Assigned_To__r;
    /* User for which this Referral shall be associated with
    */
    global Id genesis__Assigned_To__c;
    /* CL Product for which this Referral shall be associated with
    */
    global clcommon__CL_Product__c genesis__CL_Product__r;
    /* CL Product for which this Referral shall be associated with
    */
    global Id genesis__CL_Product__c;
    /* Deadline date to take an action on the Referral.
    */
    global Date genesis__Due_Date__c;
    /* This will have the values for Customer's Interest Level in the Referral. Eg: High,Medium,Low
    */
    global String genesis__Interest_Level__c;
    /* Notes/Comments for the Referral.
    */
    global String genesis__Notes__c;
    /* Parent referral for which this Referral shall be associated with
    */
    global genesis__Referral__c genesis__Parent_Referral__r;
    /* Parent referral for which this Referral shall be associated with
    */
    global Id genesis__Parent_Referral__c;
    /* Point of Contact for further communication regarding referral
    */
    global Contact genesis__Point_Of_Contact__r;
    /* Point of Contact for further communication regarding referral
    */
    global Id genesis__Point_Of_Contact__c;
    /* Indicates Product name
    */
    global String genesis__Product_Name__c;
    /* Bonus amount for the Referral.
    */
    global Decimal genesis__Referral_Bonus__c;
    /* Captures the Referral status.
    */
    global String genesis__Status__c;
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
    global List<genesis__Referral__Share> Shares;
    global List<genesis__Referral__c> genesis__Referral_Opportunities__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Referral__c () 
    {
    }
}