// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Asset_Return__c {
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
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global cllease__Contract_Equipment__c cllease__Contract_Equipment__r;
    global Id cllease__Contract_Equipment__c;
    global Double cllease__Current_Mileage__c;
    global Date cllease__Date_Return_Due__c;
    global String cllease__Equipment_Make__c;
    global String cllease__Equipment_Model__c;
    global String cllease__Equipment_Type__c;
    global String cllease__LeaseApplicationNumber__c;
    global String cllease__Make__c;
    global String cllease__Model__c;
    global Account cllease__Remarketer__r;
    global Id cllease__Remarketer__c;
    global String cllease__Serial_VIN_Number__c;
    global String cllease__VIN_Identification__c;
    global Boolean cllease__processed__c;
    global Date cllease__return_date__c;
    global Account cllease__return_location_account__r;
    global Id cllease__return_location_account__c;
    global String cllease__return_location_type__c;
    global String cllease__return_status__c;
    global String Asset_Manager_ID__c;
    global User Asset_Manager__r;
    global Id Asset_Manager__c;
    global String City__c;
    global String Country__c;
    global String County__c;
    /* The date the customer was notified the Shipping Company has been dispatched to recover the equipment.
    */
    global Date Customer_Notified_of_Shipping__c;
    global Boolean Customer_Returned__c;
    global String Equipment_Description__c;
    global String Equipment_Manufacturer__c;
    global String Equipment_Serial_Number__c;
    /* Date the return location was notified that the equipment is in route.
    */
    global Date Return_Location_Notified__c;
    global Account Return_Location__r;
    global Id Return_Location__c;
    global String Shipping_Co_E_mail__c;
    global String Shipping_Company_Phone__c;
    global Account Shipping_Company__r;
    global Id Shipping_Company__c;
    /* Date logistics was notified to recover the equipment.
    */
    global Date Shipping_Notified__c;
    /* Date the logistics company picked up the equipment.
    */
    global Date Shipping_Received__c;
    global String Street_Address__c;
    global String Zip_Code__c;
    global String State_Province__c;
    global clcommon__Equipment_Detail__c cllease__Equipment_Detail__r;
    global Id cllease__Equipment_Detail__c;
    global cllease__Termination_Quote_Header__c cllease__Quote_Header__r;
    global Id cllease__Quote_Header__c;
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
    global List<cllease__Asset_Condition__c> cllease__Asset_Conditions__r;
    global List<cllease__Asset_Return__History> Histories;
    global List<cllease__Asset_workbench__c> Asset_workbenchs__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Asset_Return__c () 
    {
    }
}