// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class dsfs__DocuSign_Envelope_Document__c {
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
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    /* DocuSign Envelope ID
    */
    global dsfs__DocuSign_Envelope__c dsfs__DocuSign_EnvelopeID__r;
    /* DocuSign Envelope ID
    */
    global Id dsfs__DocuSign_EnvelopeID__c;
    /* Attachment ID
    */
    global String dsfs__Attachment_ID__c;
    global String dsfs__Attachment_NameEx__c;
    /* Attachment Name
    */
    global String dsfs__Attachment_Name__c;
    /* Document ID
    */
    global String dsfs__Document_ID__c;
    global String dsfs__Document_Name__c;
    /* Document Order
    */
    global Double dsfs__Document_Order__c;
    /* Document Extension
    */
    global String dsfs__Extension__c;
    global String dsfs__External_Document_Id__c;
    /* Saleforce Document Type
    */
    global String dsfs__SFDocument_Type__c;
    /* Document Size
    */
    global Double dsfs__Size__c;
    /* Validation Message
    */
    global String dsfs__Validation_Message__c;
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

    global dsfs__DocuSign_Envelope_Document__c () 
    {
    }
}