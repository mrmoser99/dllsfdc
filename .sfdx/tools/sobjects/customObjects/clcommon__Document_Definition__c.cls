// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Document_Definition__c {
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
    global Boolean clcommon__Active__c;
    global String clcommon__Child_Object_API_Name__c;
    global String clcommon__Description__c;
    /* Status in which the document category should be applied. If blank, then the category is created by default.
    */
    global String clcommon__Generation_Status__c;
    global String clcommon__Priority__c;
    global Boolean clcommon__Required__c;
    /* Should an already existing document in the system be reused or not?
    */
    global Boolean clcommon__Reuse_Document__c;
    /* Should the document category be visible as documents that the portal user needs to upload or internal documents that the user can view or not be visible at all.
    */
    global String clcommon__Show_In_Portal__c;
    global String genesis__External_ID__c;
    global clcommon__Document_Definition__c clcommon__Parent_Document_Definition__r;
    global Id clcommon__Parent_Document_Definition__c;
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
    global List<clcommon__Collateral_Type_Documents__c> clcommon__CollateralType_Document_Definition__r;
    global List<clcommon__Document_Category__c> clcommon__Document_Category__r;
    global List<clcommon__Document_Definition__Share> Shares;
    global List<clcommon__Document_Definition__c> clcommon__Document_Definitions__r;
    global List<clcommon__Loan_Account_Document_Documents__c> clcommon__Document_Definition_Associations__r;
    global List<clcommon__Rule__c> clcommon__Rules__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Document_Definition__c () 
    {
    }
}