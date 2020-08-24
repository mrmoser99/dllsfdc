// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Accounting_Template_Line__c {
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
    global cllease__Accounting_Template_Header__c cllease__Accounting_Template_Header__r;
    global Id cllease__Accounting_Template_Header__c;
    global String cllease__Amount_Object_Column__c;
    global String cllease__Amount_Object__c;
    /* Use this field in Accounting setup when Bill as invoice in accounting configuration
    */
    global Boolean cllease__Bill_As_Invoice__c;
    global cllease__GL_Account__c cllease__Credit_GL_Account__r;
    global Id cllease__Credit_GL_Account__c;
    global cllease__GL_Account__c cllease__Debit_GL_Account__r;
    global Id cllease__Debit_GL_Account__c;
    global String cllease__Description__c;
    global Boolean cllease__Enabled__c;
    /* Valid only for "Bill as invoice"
    */
    global String cllease__Item_Id__c;
    /* Valid only for "Bill as invoice"
    */
    global String cllease__Item_Name__c;
    global String cllease__Sub_Type__c;
    global cllease__Transaction_Sub_Type__c cllease__Transaction_Sub_Type__r;
    global Id cllease__Transaction_Sub_Type__c;
    global String cllease__Transaction_Type__c;
    global String cllease__UniqueKey_Formula__c;
    global String cllease__Unique_RuleLine_Key__c;
    global String Credit_Account_Number__c;
    global String Debit_Account_Number__c;
    global String cllease__Field_Api_Name__c;
    global String cllease__External_Id__c;
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
    global List<cllease__Accounting_Template_Line__History> Histories;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Accounting_Template_Line__c () 
    {
    }
}