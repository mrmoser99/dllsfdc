// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class collect__Payment_Arrangement__c {
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
    global Account collect__Account__r;
    global Id collect__Account__c;
    global Boolean collect__Active__c;
    global Double collect__Arrangement_Amount__c;
    global Contact collect__Contact__r;
    global Id collect__Contact__c;
    global String collect__Contract_Name__c;
    global collect__Loan_Account__c collect__Contract__r;
    global Id collect__Contract__c;
    global Date collect__End_Date__c;
    global Double collect__Frequency__c;
    global String collect__Lease_Account_Id__c;
    global String collect__Loan_Account_Id__c;
    global String collect__Mode_of_Payment__c;
    global String collect__Occurence__c;
    global String collect__Payment_Mode__c;
    global Date collect__Start_Date__c;
    global String collect__Status__c;
    global Double collect__Total_Arrangement_Amount__c;
    global clcommon__Automated_Payment_Setup__c collect__Automated_Payment_Setup__r;
    global Id collect__Automated_Payment_Setup__c;
    global Boolean collect__Generate_APS__c;
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
    global List<collect__Payment_Arrangement__Share> Shares;
    global List<collect__Promise_To_Pay__c> collect__Promise_To_Pay__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global collect__Payment_Arrangement__c () 
    {
    }
}