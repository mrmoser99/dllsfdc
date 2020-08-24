// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Int_OFAC_FINCEN__c {
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
    global String Additional_Info_1__c;
    global String Additional_Info_2__c;
    global String Additional_Info_3__c;
    global String Billing_Address_Line_1__c;
    global String Billing_Address_Line_2__c;
    global String Billing_Building_Number__c;
    global String Billing_City__c;
    global String Billing_Country__c;
    global String Billing_Postal_Code__c;
    global String Billing_State_Province__c;
    global String Billing_Street_Name__c;
    global String Billing_Unit_Suite_Apt__c;
    global String Business_Number__c;
    global String CCAN__c;
    global String CCVAN_VL__c;
    global Boolean Committed__c;
    global String Country__c;
    global String DLL_Legal_Entity_Name__c;
    global String EIN__c;
    global String Equipment_Address_Line_1__c;
    global String Equipment_Address_Line_2__c;
    global String Equipment_Building_Number__c;
    global String Equipment_City__c;
    global String Equipment_Country__c;
    global String Equipment_Postal_Code__c;
    global String Equipment_State_Province__c;
    global String Equipment_Street_Name__c;
    global String Equipment_Unit_Suite_Apt__c;
    global String First_Name__c;
    global String Gender__c;
    global String Generation__c;
    global String Is_Active__c;
    global String Last_Name__c;
    global String Middle_Name__c;
    global String Primary_Address_Line_1__c;
    global String Primary_Address_Line_2__c;
    global String Primary_Building_Number__c;
    global String Primary_City__c;
    global String Primary_Country__c;
    global String Primary_Postal_Code__c;
    global String Primary_State_Province__c;
    global String Primary_Street_Name__c;
    global String Primary_Unit_Suite_Apt__c;
    global String Roles__c;
    global String Row_Type_Code__c;
    global String Source_System__c;
    global String System_Id_Type__c;
    global String System_Id_Value__c;
    global String Unique_Id__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Int_OFAC_FINCEN__Share> Shares;
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

    global Int_OFAC_FINCEN__c () 
    {
    }
}