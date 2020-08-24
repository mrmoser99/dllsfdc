// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Int_Agreement_Line__c {
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
    global Date Agreement_Line_Maturity_Date__c;
    global String Agreement_Line_Number__c;
    global Date Agreement_Line_Start_Date__c;
    global String Agreement_Line_Status_Code__c;
    global Int_Agreement__c Agreement_Name__r;
    global Id Agreement_Name__c;
    global String Agreement_Number__c;
    global String Agreement_Source_System__c;
    global Boolean Committed__c;
    global Decimal Hard_Costs_Amount__c;
    global Decimal Net_Principal_Amount__c;
    global Decimal Net_Principal_Balance_Amount__c;
    global Decimal Net_Residual_Value__c;
    global String Purchase_Type_Code__c;
    global Decimal Residual_Value_Booked__c;
    global Decimal Soft_Costs_Amount__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Int_Agreement_Line_Asset__c> Int_Agreement_Line_Assets__r;
    global List<Int_Agreement_Line_Feature__c> Int_Agreement_Line_Features__r;
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

    global Int_Agreement_Line__c () 
    {
    }
}