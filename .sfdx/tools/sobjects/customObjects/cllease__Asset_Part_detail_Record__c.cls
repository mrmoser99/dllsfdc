// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Asset_Part_detail_Record__c {
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
    global cllease__Asset_workbench__c cllease__Asset_workbench__r;
    global Id cllease__Asset_workbench__c;
    global Decimal cllease__Actual_Repair_Cost__c;
    global String cllease__Condition_Status__c;
    global String cllease__Condition_Type__c;
    global String cllease__Damage_Description__c;
    global String cllease__Damage_Type__c;
    global Decimal cllease__Estimated_Repair_Cost__c;
    global String cllease__Part__c;
    global String cllease__Recommended_Repair__c;
    global String cllease__Repair_Description__c;
    global String cllease__Repair_Type__c;
    global Date cllease__Reported_on__c;
    /* Company who will repair the equipment.
    */
    global Account Repair_Company__r;
    /* Company who will repair the equipment.
    */
    global Id Repair_Company__c;
    global String Repair_E_mail__c;
    global String Repair_Phone__c;
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

    global cllease__Asset_Part_detail_Record__c () 
    {
    }
}