// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Agreement__c {
    global Id Id;
    global SObject Owner;
    global Id OwnerId;
    global Boolean IsDeleted;
    global String Name;
    global RecordType RecordType;
    global Id RecordTypeId;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global String clcommon__Auto_Renewal_Frequency__c;
    global String clcommon__Customer_Code__c;
    global String clcommon__Interim_Rent__c;
    global Double clcommon__Lessee_Notification_Terms__c;
    global Double clcommon__Lessor_Notification_Terms__c;
    global String clcommon__Over_Usage__c;
    global Double clcommon__Payment_Due_Net__c;
    global String clcommon__Payment_Frequency__c;
    global String clcommon__Serial_Number_Substitution__c;
    global String clcommon__Shipping_Mileage_Limit__c;
    global String clcommon__Shipping_Terms__c;
    global String Allowable_Condition__c;
    global Double Allowable_Soft_Cost__c;
    /* How many days approval last before expired
    */
    global String Approval_Validity__c;
    global String Asset_Repair_Cost__c;
    global String Asset_Return_Cost__c;
    global clcommon__CL_Product__c CL_Product__r;
    global Id CL_Product__c;
    global Boolean Evergreen_Eligible__c;
    global String Evergreen_Term__c;
    global clcommon__Fee_Set__c Fee_Set_1__r;
    global Id Fee_Set_1__c;
    global cllease__Fee_Set__c Fee_Set__r;
    global Id Fee_Set__c;
    /* Created by Aniroodha
    */
    global String Formula__c;
    global Decimal Insurance_Flat_Fee__c;
    global Double Insurance_Rate_Adder__c;
    /* Created by Aniroodha
    */
    global String LookupObject__c;
    global Decimal Maximum_Financed_Amount__c;
    global Double Maximum_Term__c;
    global Decimal Minimum_Financed_Amount__c;
    global Double Minimum_Term__c;
    global Boolean Pass_Through_Eligibility__c;
    global String Payment_Term__c;
    global String Private_Label__c;
    global genesis__Rate_Card_Setup_Header__c Rate_Card__r;
    global Id Rate_Card__c;
    global String Residual_Sharing__c;
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
    global List<clcommon__Agreement__Share> Shares;
    global List<cllease__Lease_Account__c> LS_Contracts__r;
    global List<genesis__Applications__c> Applications__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Agreement__c () 
    {
    }
}