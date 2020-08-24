// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Movement_Code__c {
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
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global String Billing_Tax_Eligible_GL_Account_Codes__c;
    global String CL_Lease_Transaction_Type__c;
    global String Contract_Install_State_Location__c;
    global String Movement_Code__c;
    global String Payment_Tax_Eligible_GL_Account_Codes__c;
    /* Eligible GL Account Codes for Transactions. (ACCRUAL, BILLING RENT, BOOKING, PAYMENT RENT, RESTRUCTURE, TAX, TERMINATION)
    */
    global String Transaction_Eligible_GL_Account_Codes__c;
    global String Transaction_Type_in_OLFM__c;
    /* Movement code might be different for credit and debit in case of On Account. Created to identify the type of accounting to place right movement code.
    */
    global String Account_Type__c;
    /* Based on account and type of transaction either debit or credit we need to have different move code for some specific transaction like payment.
    */
    global cllease__GL_Account__c GL_Account__r;
    /* Based on account and type of transaction either debit or credit we need to have different move code for some specific transaction like payment.
    */
    global Id GL_Account__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Movement_Code__Share> Shares;
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

    global Movement_Code__c () 
    {
    }
}