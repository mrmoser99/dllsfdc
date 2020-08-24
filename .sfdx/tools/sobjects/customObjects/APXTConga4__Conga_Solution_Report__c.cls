// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class APXTConga4__Conga_Solution_Report__c {
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
    global APXTConga4__Conga_Solution__c APXTConga4__Conga_Solution__r;
    global Id APXTConga4__Conga_Solution__c;
    global String APXTConga4__Alias__c;
    global String APXTConga4__Comments__c;
    global String APXTConga4__Report_Id_Link__c;
    global String APXTConga4__Report_Id__c;
    global String APXTConga4__Report_Name__c;
    /* Automatically populated according to the field selected. This value will be dynamically passed to the first filter of the report. Using a plus sign (+) specifies that a blank value should be used.
    */
    global String APXTConga4__pv0__c;
    /* Automatically populated according to the field selected. This value will be dynamically passed to the second filter of the report. Using a plus sign (+) specifies that a blank value should be used.
    */
    global String APXTConga4__pv1__c;
    /* Automatically populated according to the field selected. This value will be dynamically passed to the third filter of the report. Using a plus sign (+) specifies that a blank value should be used.
    */
    global String APXTConga4__pv2__c;
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

    global APXTConga4__Conga_Solution_Report__c () 
    {
    }
}