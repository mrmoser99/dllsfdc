// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__ACH_Specification__c {
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
    global Boolean cllease__Active__c;
    global String cllease__Company_Discretionary_Data__c;
    global String cllease__Company_Entry_Description__c;
    global String cllease__Company_Identification__c;
    global String cllease__Company_Name__c;
    global String cllease__Custom_File_Gen_Class__c;
    global Double cllease__Days_in_advance_to_create_file__c;
    global Boolean cllease__Debit_Pmt_on_Previous_Working_Day__c;
    global String cllease__File_Format__c;
    global String cllease__File_Type__c;
    global String cllease__Folder_Name__c;
    global String cllease__Immediate_Destination_Name__c;
    global String cllease__Immediate_Destination__c;
    global String cllease__Immediate_Origin_Name__c;
    global String cllease__Immediate_Origin__c;
    global Double cllease__Lock_Period_for_Payments__c;
    global String cllease__Org_Bank_Account__c;
    global String cllease__Origination_DFI_identification__c;
    global String cllease__Reference_Code__c;
    global String cllease__Return_File_Parser_ClassName__c;
    global String cllease__Standard_Entry_class_code__c;
    global String cllease__Trace_Number_Prefix__c;
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
    global List<cllease__ACH_Specification__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__ACH_Specification__c () 
    {
    }
}