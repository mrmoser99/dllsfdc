// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Letter_of_Intent__c {
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
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global Double genesis__APR__c;
    global String genesis__Account_Name__c;
    global Boolean genesis__Active__c;
    global genesis__Application_Document_Category__c genesis__Application_Document_Category__r;
    global Id genesis__Application_Document_Category__c;
    global Decimal genesis__Application_Fee__c;
    global String genesis__Application_Id__c;
    global Double genesis__Attorney_Fee__c;
    global String genesis__Contact_Name__c;
    global String genesis__Contact__c;
    global Double genesis__Down_Payment__c;
    global Date genesis__Expected_Close_Date__c;
    global String genesis__First_Draw_Condition__c;
    global Double genesis__First_Funding_Amount__c;
    global String genesis__Fourth_Draw_Condition__c;
    global Double genesis__Fourth_Funding_Amount__c;
    global Double genesis__Funding_Amount_from_Second_Schedule__c;
    global String genesis__Guarantor_Name__c;
    global Double genesis__Interest_Rate__c;
    global Decimal genesis__Loan_Amount__c;
    global Double genesis__Monthly_Interest_Payment__c;
    global Double genesis__No_of_Funding_Schedules__c;
    global Double genesis__Origination_Fee_Points__c;
    global Double genesis__Origination_Fee__c;
    global Double genesis__Per_Diem_Amount__c;
    global String genesis__Property_Addresses__c;
    global String genesis__Property_Types__c;
    global Double genesis__Purchase_Price__c;
    global String genesis__Remaining_Draw_Conditions__c;
    global Double genesis__Remaining_Funding_Amount__c;
    global Double genesis__Reserve_Amount__c;
    global String genesis__Second_Draw_Condition__c;
    global Double genesis__Second_Funding_Amount__c;
    global Datetime genesis__Sent_At__c;
    global String genesis__Status__c;
    global Double genesis__Term__c;
    global String genesis__Third_Draw_Condition__c;
    global Double genesis__Third_Funding_Amount__c;
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

    global genesis__Letter_of_Intent__c () 
    {
    }
}