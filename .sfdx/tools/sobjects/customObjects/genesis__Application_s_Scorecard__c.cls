// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Application_s_Scorecard__c {
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
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global String genesis__Actual_Value__c;
    /* This flag indicates whether the application matches this rule's criteria. In other words, did this rule contribute to the application's total score.
    */
    global Boolean genesis__Criteria_Match__c;
    global String genesis__Field_API_Name__c;
    global String genesis__Field_Name__c;
    global String genesis__Field_Type__c;
    global Double genesis__Input_Value__c;
    global String genesis__Matching_Type__c;
    global String genesis__Matching_Value__c;
    global String genesis__Maximun_Value__c;
    global String genesis__Minimum_Value__c;
    global String genesis__Related_Object__c;
    global Double genesis__Score__c;
    global genesis__Scorecard_Criteria__c genesis__Scorecard_Criteria__r;
    global Id genesis__Scorecard_Criteria__c;
    global genesis__Scorecard__c genesis__Scorecard__r;
    global Id genesis__Scorecard__c;
    global Double genesis__Weight__c;
    global Double genesis__Weighted_Score__c;
    global clcommon__Party__c genesis__Party__r;
    global Id genesis__Party__c;
    /* This field stores the Field API Name for related criteria
    */
    global String genesis__New_Field_API_Name__c;
    /* This field stores the Field Name for related criteria
    */
    global String genesis__New_Field_Name__c;
    /* This field stores the Field Type for related criteria
    */
    global String genesis__New_Field_Type__c;
    /* This field stores the Matching Type for related criteria
    */
    global String genesis__New_Matching_Type__c;
    /* This field stores the Matching Value for related criteria
    */
    global String genesis__New_Matching_Value__c;
    /* This field stores the Maximum Value for related criteria object
    */
    global String genesis__New_Maximum_Value__c;
    /* This field stores the Minimum Value for related criteria
    */
    global String genesis__New_Minimum_Value__c;
    /* This field stores the Score for related criteria
    */
    global String genesis__New_Score__c;
    /* This field stores the Weight for related criteria
    */
    global String genesis__New_Weight__c;
    /* This field tracks the parent scorecard rule for which the application scorecard result was created
    */
    global clcommon__Rule__c genesis__Rule__r;
    /* This field tracks the parent scorecard rule for which the application scorecard result was created
    */
    global Id genesis__Rule__c;
    /* This field shows the field used for score card computation
    */
    global String genesis__Use_Input_Field_As_Score__c;
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
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Application_s_Scorecard__c () 
    {
    }
}