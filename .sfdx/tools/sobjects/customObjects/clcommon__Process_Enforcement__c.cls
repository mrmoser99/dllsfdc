// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Process_Enforcement__c {
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
    /* Process Enforcement active status
    */
    global Boolean clcommon__Active__c;
    /* Select this field to enforce this Process Enforcement when updating any existing contract
    */
    global Boolean clcommon__Apply_On_Contract_Update__c;
    /* Select this field to enforce this Process Enforcement at the creation of new contract when active on any account/contact
    */
    global Boolean clcommon__Apply_On_New_Contracts__c;
    global Double clcommon__Priority__c;
    /* Type the name of Process Enforcement to be applied on Contact or Account
    */
    global String clcommon__Process_Enforcement_Name__c;
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
    global List<clcommon__Process_Enforcement_Action__c> clcommon__Process_Enforcement_Actions__r;
    global List<clcommon__Process_Enforcement_Constraint__c> clcommon__Process_Enforcement_Constraints__r;
    global List<clcommon__Process_Enforcement_Detail__c> clcommon__Process_Enforcement_Details__r;
    global List<clcommon__Process_Enforcement__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Process_Enforcement__c () 
    {
    }
}