// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Termination_Quote_Line__c {
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
    global cllease__Termination_Quote_Header__c cllease__Quote_Header__r;
    global Id cllease__Quote_Header__c;
    global String cllease__Account_Balance_Type__c;
    global Boolean cllease__Add_To_Quote_Amount__c;
    global String cllease__Amount_Type__c;
    global Decimal cllease__Amount__c;
    global String cllease__Bill_Field_API_Name__c;
    global Boolean cllease__Billable__c;
    global clcommon__Fee_Definition__c cllease__Fee_Definition__r;
    global Id cllease__Fee_Definition__c;
    /* Please use Fee Definition field that references Fee Definition from CL Common.
    */
    global cllease__Fee__c cllease__Fee__r;
    /* Please use Fee Definition field that references Fee Definition from CL Common.
    */
    global Id cllease__Fee__c;
    global String cllease__Field_API_Name__c;
    global Boolean cllease__Is_Account_Balancable__c;
    global String cllease__Line_Type__c;
    /* System displays quote config line name in the termination quote page
    */
    global String cllease__Quote_Description__c;
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
    global List<Termination_Equipment_Quote__c> Termination_Equipment_Quotes__r;
    global List<TopicAssignment> TopicAssignments;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Termination_Quote_Line__c () 
    {
    }
}