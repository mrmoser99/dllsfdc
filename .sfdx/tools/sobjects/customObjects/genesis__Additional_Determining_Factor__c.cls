// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Additional_Determining_Factor__c {
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
    /* Tick, if this determining factor is applicable for evaluating rate card for Application
    */
    global Boolean genesis__Applicable_for_Application__c;
    /* Tick, if this determining factor is applicable for evaluating rate card for Quick Quotes
    */
    global Boolean genesis__Applicable_for_Quick_Quote__c;
    global String genesis__Application_Field_API_Name__c;
    global String genesis__Application_Field_Name__c;
    global String genesis__Application_Field_Type__c;
    global String genesis__Application_Object_API_Name__c;
    global String genesis__Application_Object_Name__c;
    global String genesis__Evaluation_Operator__c;
    global String genesis__Quick_Quote_Field_API_Name__c;
    global String genesis__Quick_Quote_Field_Name__c;
    global String genesis__Quick_Quote_Field_Type__c;
    global String genesis__Quick_Quote_Object_API_Name__c;
    global String genesis__Quick_Quote_Object_Name__c;
    global Boolean genesis__Required_for_Evaluation__c;
    /* This field when checked, then value of determining factor will be applied to all rate card details.
    */
    global Boolean genesis__Apply_to_all_Rate_Card_Details__c;
    global String genesis__External_ID__c;
    /* This field captures the value of determining factor applied to all rate card details.
    */
    global String genesis__Field_Value__c;
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

    global genesis__Additional_Determining_Factor__c () 
    {
    }
}