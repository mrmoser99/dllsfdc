// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Insurance_Definition__c {
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
    /* This field captures the information whether the insurance premium amount needs to be added to loan amount or not.
    */
    global Boolean clcommon__Add_To_Loan_Amount__c;
    /* This field is used for selecting the expressions for a particular insurance definition. Different insurance definitions can have different formula to calculate premium amount.
    */
    global clcommon__Calculation_Set__c clcommon__Calculation_Set__r;
    /* This field is used for selecting the expressions for a particular insurance definition. Different insurance definitions can have different formula to calculate premium amount.
    */
    global Id clcommon__Calculation_Set__c;
    /* This field stores the information for object type on which Insurance needs to be defined
    */
    global String clcommon__Object_Type__c;
    /* This field is used to identify whether the premium is calculated for single borrower or for combination of borrowers
    */
    global String clcommon__Premium_Type__c;
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
    global List<clcommon__Insurance_Definition__Share> Shares;
    global List<clcommon__Product_Insurance_Association__c> clcommon__Product_Insurance_Associations__r;
    global List<genesis__Insurance__c> genesis__Insurances__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Insurance_Definition__c () 
    {
    }
}