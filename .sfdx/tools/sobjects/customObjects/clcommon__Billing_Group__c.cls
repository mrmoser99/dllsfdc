// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Billing_Group__c {
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
    /* Account associated with the Bill Group
    */
    global Account clcommon__Account__r;
    /* Account associated with the Bill Group
    */
    global Id clcommon__Account__c;
    /* The address used as the grouping criterion for the bill group
    */
    global clcommon__Address__c clcommon__Address__r;
    /* The address used as the grouping criterion for the bill group
    */
    global Id clcommon__Address__c;
    /* Contact associated with the Bill Group
    */
    global Contact clcommon__Contact__r;
    /* Contact associated with the Bill Group
    */
    global Id clcommon__Contact__c;
    global List<Account> clcommon__Accounts__r;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<Contact> clcommon__Contacts__r;
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
    global List<clcommon__Billing_Group__Share> Shares;
    global List<clcommon__Consolidated_Invoice__c> clcommon__Consolidated_Invoices__r;
    global List<cllease__Contract_Equipment__c> cllease__Contract_Equipment__r;
    global List<cllease__Lease_Account__c> cllease__LS_Contracts__r;
    global List<cllease__Lease_account_Due_Details__c> cllease__Bills__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Billing_Group__c () 
    {
    }
}