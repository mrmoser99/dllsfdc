// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Cash_Receipt_Application__c {
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
    global clcommon__Cash_Receipt__c clcommon__Cash_Receipt__r;
    global Id clcommon__Cash_Receipt__c;
    global Decimal clcommon__Allocated_Amount__c;
    global Datetime clcommon__Creation_Date_Time__c;
    global Date clcommon__Creation_Date__c;
    global Time clcommon__Creation_Time__c;
    global Boolean clcommon__Migrated__c;
    /* State Transition:
a.	Null to created (at the time of creation)
b.	Created to Cancelled. (if not applied)
c.	Created to Applied (when applied to receivables)
d.	Applied to Reversed (if application is reversed)
    */
    global String clcommon__Receipt_Application_Status__c;
    global Datetime clcommon__Status_Changed_SysDate__c;
    global Decimal clcommon__Unused_Amount__c;
    /* It signifies the reason for payment reversal
    */
    global String clcommon__Reason_Code__c;
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
    global List<clcommon__Payment_Transaction__c> clcommon__Payment_Transactions__r;
    global List<clcommon__Sample_Contract__c> clcommon__Payments__r;
    global List<cllease__Lease_Payment_Transaction__c> cllease__Lease_Payment_Transactions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Cash_Receipt_Application__c () 
    {
    }
}