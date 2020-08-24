// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Rental_Stream__c {
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
    /* This flag indicates if this particular record is already accrued or not.
    */
    global Boolean cllease__Accrued_Flag__c;
    global Boolean cllease__Active__c;
    global Decimal cllease__Beginning_Lease_Receivable__c;
    global Decimal cllease__Beginning_Net_Book_Value__c;
    global Decimal cllease__Beginning_Net_Investment__c;
    global Decimal cllease__Beginning_Unearned_Income__c;
    global Decimal cllease__Capital_Recovery__c;
    global String cllease__Comment__c;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Date cllease__Date_Accrued__c;
    /* Date.
    */
    global Date cllease__Date__c;
    global Decimal cllease__Ending_Lease_Receivable__c;
    global Decimal cllease__Ending_Net_Book_Value__c;
    global Double cllease__Ending_Net_Investment__c;
    global Decimal cllease__Ending_Unearned_Income__c;
    /* This is the interest on net investment, it is for informational purpose only and not used in any calculation.
    */
    global Double cllease__Investment_Income__c;
    global String cllease__LeaseApplicationNumber__c;
    global Decimal cllease__Lease_Income__c;
    global Decimal cllease__Payment_Amount__c;
    global Double cllease__Payment_Number__c;
    global Decimal cllease__Pro_Rated_Income__c;
    global cllease__Transaction_Sub_Type__c cllease__Transaction_Sub_Type__r;
    global Id cllease__Transaction_Sub_Type__c;
    global String cllease__Year_Of_Stream__c;
    global Decimal cllease__Monthly_Income__c;
    global String cllease__Stream_Type__c;
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
    global List<cllease__Accrual_Transactions__c> cllease__Accrual_Transactions__r;
    global List<cllease__Rental_Stream__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Rental_Stream__c () 
    {
    }
}