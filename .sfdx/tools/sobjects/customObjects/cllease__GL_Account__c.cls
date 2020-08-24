// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__GL_Account__c {
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
    global String cllease__Account_Code__c;
    global String cllease__External_GL_Account_Name__c;
    /* Flag TRUE or FALSE to indicate movement code eligibility.
 (TRUE= Yes, FALSE = No) Default = TRUE
    */
    global Boolean Is_Movement_Code_Eligible__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<GL_Transaction_Snapshot__c> GL_Transaction_Snapshot__r;
    global List<Movement_Code__c> Movement_Codes__r;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<cllease__Accounting_Template_Line__c> cllease__Accounting_Rule_Lines1__r;
    global List<cllease__Accounting_Template_Line__c> cllease__Accounting_Rule_Lines__r;
    global List<cllease__Cash_Account_Balance__c> cllease__Cash_Account_Balances__r;
    global List<cllease__GL_Account__Share> Shares;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Transaction_Details1__r;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Transaction_Details__r;
    global List<cllease__Non_Cash_Account_Balance__c> cllease__Non_Cash_Account_Balances__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__GL_Account__c () 
    {
    }
}