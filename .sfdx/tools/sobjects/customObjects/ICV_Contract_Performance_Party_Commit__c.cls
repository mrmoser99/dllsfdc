// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ICV_Contract_Performance_Party_Commit__c {
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
    global ICV_Contract_Performance_Party__c ICV_Contract_Performance_Party__r;
    global Id ICV_Contract_Performance_Party__c;
    global String Active_Indicator__c;
    global Double Average_Days_To_Pay__c;
    global String Commitment_Id__c;
    global String Commitment_Type__c;
    global String Currency_Code__c;
    global Date End_Date__c;
    global Date Inactivation_Date__c;
    global String Line_Of_Business__c;
    global Decimal Original_Amount__c;
    global Double Payments_0_30__c;
    global Double Payments_121_Over__c;
    global Double Payments_31_60__c;
    global Double Payments_61_90__c;
    global Double Payments_91_120__c;
    global Double Remaining_Payments__c;
    global String Source_System__c;
    global Date Start_Date__c;
    global String Status__c;
    global Double Term__c;
    global Decimal Write_Off_Amount__c;
    global Date Write_Off_Date__c;
    global String Write_Off_Reason__c;
    global String Write_Off__c;
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

    global ICV_Contract_Performance_Party_Commit__c () 
    {
    }
}