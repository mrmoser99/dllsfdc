// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class collect__Promise_To_Pay__c {
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
    global Contact collect__Contact__r;
    global Id collect__Contact__c;
    global String collect__Contract_Name__c;
    global Boolean collect__Create_Payment_Plan_Task__c;
    global Double collect__Days_Past_Due__c;
    global collect__Loan_Account__c collect__Dev_Contract__r;
    global Id collect__Dev_Contract__c;
    global collect__Interaction_Log__c collect__Interaction_Log__r;
    global Id collect__Interaction_Log__c;
    global String collect__Lease_Account_Id__c;
    global String collect__Loan_Account_Id__c;
    global String collect__Mode_of_Payment__c;
    global collect__Payment_Arrangement__c collect__Payment_Arrangement__r;
    global Id collect__Payment_Arrangement__c;
    global String collect__Payment_Mode__c;
    global Boolean collect__Promise_Broken__c;
    global Boolean collect__Promise_Kept__c;
    global Date collect__Promise_Made_On__c;
    global Date collect__Promise_Met_Date__c;
    global Double collect__Promise_To_Pay_Amount__c;
    global Date collect__Promise_To_Pay_Date__c;
    global Double collect__Tolerance_Amount__c;
    global Double collect__Tolerance_Days__c;
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
    global List<collect__Collection_Activity__c> collect__Collection_Activities__r;
    global List<collect__Payment_Transaction_Reversal_Record__c> collect__Payment_Transaction_Reversal_Records__r;
    global List<collect__Promise_To_Pay__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global collect__Promise_To_Pay__c () 
    {
    }
}