// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Cash_Receipt__c {
    global Id Id;
    global SObject Owner;
    global Id OwnerId;
    global Boolean IsDeleted;
    global String Name;
    global RecordType RecordType;
    global Id RecordTypeId;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global String clcommon__ACH_Filename__c;
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global Contact clcommon__Contact__r;
    global Id clcommon__Contact__c;
    global Datetime clcommon__Creation_Date_Time__c;
    global Date clcommon__Creation_Date__c;
    global Time clcommon__Creation_Time__c;
    global Boolean clcommon__Migrated__c;
    global clcommon__Payment_Mode__c clcommon__Payment_Mode__r;
    global Id clcommon__Payment_Mode__c;
    global Decimal clcommon__Receipt_Amount__c;
    /* this can be the cheque date or transfer date
    */
    global Date clcommon__Receipt_Date__c;
    /* a.	Null to Created
b.	Created to Cancelled
c.	Created to Applied
d.	Created to partially Applied
e.	Partially applied to applied
f.	Applied to partially applied
g.	Applied to Created
h.	Partially Applied to Created
i.	Created to Refunded
    */
    global String clcommon__Receipt_Status__c;
    global Decimal clcommon__Refunded_Amount__c;
    global Date clcommon__Sent_To_ACH_On__c;
    global Boolean clcommon__Sent_To_ACH__c;
    global Decimal clcommon__Unused_Amount__c;
    global Int_PX_Remit__c Int_PX_Remit__r;
    global Id Int_PX_Remit__c;
    global cllease__Lease_Payment_Transaction__c Payment_Transaction__r;
    global Id Payment_Transaction__c;
    global String clcommon__Credit_Invoice_Id__c;
    global String clcommon__Description__c;
    global String cllease__Description__c;
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
    global List<clcommon__Cash_Receipt_Application__c> clcommon__Cash_Receipt_Applications__r;
    global List<clcommon__Cash_Receipt_Transaction__c> clcommon__Cash_Receipt_Transactions__r;
    global List<clcommon__Cash_Receipt__Share> Shares;
    global List<clcommon__Disbursement_Transaction__c> clcommon__Disbursement_Transactions__r;
    global List<clcommon__Payment_Transaction__c> clcommon__Payment_Transactions__r;
    global List<cllease__Asset_workbench__c> cllease__Asset_Workbenchs__r;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Accounting_Entries__r;
    global List<cllease__Invoice_Credit__c> cllease__Invoice_Credit__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Cash_Receipt__c () 
    {
    }
}