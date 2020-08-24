// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Covenant_Definition__c {
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
    global Boolean clcommon__Active__c;
    global String clcommon__Covenant_Description__c;
    /* This field is used to evaluate the financial covenant. It is only applicable if the Financial Operator is Between.
    */
    global Double clcommon__Financial_Indicator_High_Value__c;
    /* This field is used to evaluate the financial covenant. It is only applicable if the Financial Operator is Between.
    */
    global Double clcommon__Financial_Indicator_Low_Value__c;
    /* This field is used to evaluate the financial covenant.
    */
    global Double clcommon__Financial_Indicator__c;
    global String clcommon__Financial_Operator__c;
    global String clcommon__Frequency__c;
    global clcommon__Legal_Entity__c clcommon__Legal_Entity_Type__r;
    global Id clcommon__Legal_Entity_Type__c;
    global Double clcommon__Notification_Days__c;
    global String clcommon__Product_Name__c;
    global clcommon__CL_Product__c clcommon__Product__r;
    global Id clcommon__Product__c;
    global clcommon__Party_Type__c clcommon__Relationship_Type__r;
    global Id clcommon__Relationship_Type__c;
    global String clcommon__Type__c;
    /* This checkbox indicates if the financial covenant is related to the net cashflow of the borrowing entity.
    */
    global Boolean clcommon__Net_Cashflow_Covenant__c;
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
    global List<clcommon__Covenant_Definition__Share> Shares;
    global List<clcommon__Covenant__c> clcommon__Covenants__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Covenant_Definition__c () 
    {
    }
}