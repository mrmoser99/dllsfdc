// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class SAI_Application__c {
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
    global Date Agreement_Activation_Date__c;
    global Date Agreement_End_Date__c;
    global Double Agreement_Original_Duration__c;
    global Double Agreement_Rate_Percentage__c;
    global Date Agreement_Start_Date__c;
    global String Application_Entry_System_Code__c;
    global String Application_Internal_Status_Code__c;
    global Date Application_Internal_Status_Date__c;
    global String Application_Internal_Status_Detail_Code__c;
    global Date Application_Internal_Status_Detail_Date__c;
    global Date Application_Lost_Date__c;
    global String Application_Lost_Reason_Code__c;
    global String Application_Number__c;
    global String Application_Raised_Code__c;
    global Date Application_Registration_Date__c;
    global String Application_Source_System__c;
    global Decimal Base_Payment_Amount__c;
    global Double Cost_of_funds_Percentage__c;
    global String Currency_Code__c;
    global String External_Application_Number__c;
    global String External_Product_Description__c;
    global String External_Segment_Description__c;
    global String External_Segment_Number__c;
    global String Facility_Number__c;
    global String Facility_Source_System__c;
    global String Fee_For_Service_Indicator__c;
    global Double Grace_Period__c;
    global Decimal Gross_Principal_Amount__c;
    global String Hyperion_Base_Entity__c;
    global Date Issued_PO_Date__c;
    global String Leading_Application_Indicator__c;
    global Decimal Net_Principal_Amount__c;
    global String Opportunity_Name__c;
    global String Payment_Frequency_Code__c;
    global String Payment_Method_Code__c;
    global Decimal Residual_Value_Amount__c;
    global String Sales_Representative_Name__c;
    global String Sales_Representative_Number__c;
    global String Seasonality_Indicator__c;
    global String System_Program_Description__c;
    global String System_Program_Number__c;
    global String System_Selling_Party_Description__c;
    global String System_Selling_Party_Number__c;
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
    global List<SAI_Application__Share> Shares;
    global List<TopicAssignment> TopicAssignments;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global SAI_Application__c () 
    {
    }
}