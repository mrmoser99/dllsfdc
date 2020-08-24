// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Lease_Trx_Lines__c {
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
    global cllease__Lease_Trx_Header__c cllease__Trx_Header__r;
    global Id cllease__Trx_Header__c;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Boolean cllease__Accounted_YN__c;
    global Decimal cllease__Amount__c;
    global String cllease__Branch__c;
    global String cllease__Contract_Status__c;
    global Boolean cllease__GL_Posted_Flag__c;
    global Date cllease__GL_Process_Date__c;
    global String cllease__GL_Processing_Message__c;
    global String cllease__ID__c;
    global Date cllease__Maturity_Date__c;
    global Date cllease__Start_Date__c;
    global Date cllease__Transaction_Date__c;
    global Double cllease__Transaction_Number__c;
    global cllease__Transaction_Sub_Type__c cllease__Transaction_Sub_Type__r;
    global Id cllease__Transaction_Sub_Type__c;
    /* This field represents the 'Capital Recovery' component of the corresponding only for lines with Transaction Sub Type as 'LEASE INCOME ACCRUAL'
    */
    global Decimal cllease__Capital_Recovery__c;
    /* Indicates if this accrual transaction detail has been restructured as a part of an overall contract restructure.
    */
    global Boolean cllease__Restructured__c;
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
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Transaction_Details__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Lease_Trx_Lines__c () 
    {
    }
}