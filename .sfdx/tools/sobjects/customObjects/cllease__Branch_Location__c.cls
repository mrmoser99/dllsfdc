// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Branch_Location__c {
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
    /* Address Line 1
    */
    global String cllease__Address_Line_1__c;
    /* Address Line 2
    */
    global String cllease__Address_Line_2__c;
    /* Address Line 3
    */
    global String cllease__Address_Line_3__c;
    global String cllease__City__c;
    /* Country
    */
    global String cllease__Country__c;
    /* Email
    */
    global String cllease__Email__c;
    global Double cllease__Fax__c;
    /* Location ID
    */
    global String cllease__LOC_ID__c;
    /* Phone
    */
    global String cllease__Phone__c;
    /* State
    */
    global String cllease__State__c;
    /* Zip Code
    */
    global Double cllease__Zip_Code__c;
    global Double cllease__Zip_Extension__c;
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
    global List<cllease__Bank_Account__c> cllease__Bank_Accounts__r;
    global List<cllease__Bank__c> cllease__Banks__r;
    global List<cllease__Branch_Location__Share> Shares;
    global List<cllease__Office_Name__c> cllease__Offices__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Branch_Location__c () 
    {
    }
}