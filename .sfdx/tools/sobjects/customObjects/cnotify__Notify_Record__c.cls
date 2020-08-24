// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cnotify__Notify_Record__c {
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
    global Account cnotify__Account__r;
    global Id cnotify__Account__c;
    global Double cnotify__Amount_to_Current__c;
    global Contact cnotify__Borrower_Contact__r;
    global Id cnotify__Borrower_Contact__c;
    global Contact cnotify__Contact__r;
    global Id cnotify__Contact__c;
    global Double cnotify__Interest_Accrued_Not_Due__c;
    global Double cnotify__Interest_Remaining__c;
    global String cnotify__Loan_Account__c;
    global Date cnotify__Next_Installment_Date__c;
    global Double cnotify__Number_of_Days_Overdue__c;
    global Double cnotify__Payment_Amount__c;
    global Date cnotify__Previous_Installment_Date__c;
    global Double cnotify__Principal_Remaining__c;
    global String cnotify__Product_Type__c;
    global Double cnotify__Transaction_Amount__c;
    global Date cnotify__Transaction_Date__c;
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
    global List<cnotify__Notify_Record__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cnotify__Notify_Record__c () 
    {
    }
}