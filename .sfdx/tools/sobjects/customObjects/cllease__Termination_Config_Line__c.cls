// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Termination_Config_Line__c {
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
    global cllease__Termination_Config__c cllease__Termination_Config__r;
    global Id cllease__Termination_Config__c;
    global String cllease__Account_Balance_Type__c;
    /* True in case if amount adds to Termination Quote Amount , 
false to subtract from termination Quote amount
    */
    global Boolean cllease__Add_To_Quote_Amount__c;
    global String cllease__Bill_Field_API_Name__c;
    global String cllease__Field_API_Name__c;
    global Boolean cllease__Is_Account_Balancable__c;
    global Boolean cllease__Is_Billable__c;
    global String cllease__Object_API_Name__c;
    global String cllease__Quote_Line__c;
    global Boolean Consider_for_Vertex_Tax__c;
    /* This field holds the Field API Name from Due Detail Line for Termination Quote Line level Tax Details.
    */
    global String DDL_Quote_Line_Tax_Field_API_Name__c;
    global Boolean Do_Passthrough__c;
    /* Checking this flag will make sure the system consider entire fee amount for the selected fee during termination.
    */
    global Boolean cllease__Consider_Full_Fee_Amount__c;
    global String cllease__External_Id__c;
    global clcommon__Fee_Definition__c cllease__Fee__r;
    global Id cllease__Fee__c;
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

    global cllease__Termination_Config_Line__c () 
    {
    }
}