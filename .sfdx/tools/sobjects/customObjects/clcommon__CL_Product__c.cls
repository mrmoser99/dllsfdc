// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__CL_Product__c {
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
    global clcommon__Asset_Class__c clcommon__Asset_Class__r;
    global Id clcommon__Asset_Class__c;
    global String clcommon__Class__c;
    global clcommon__Collateral_Type__c clcommon__Primary_Collateral_Type__r;
    global Id clcommon__Primary_Collateral_Type__c;
    global String clcommon__Product_Name__c;
    global clcommon__Collateral_Type__c clcommon__Secondary_Collateral_Type__r;
    global Id clcommon__Secondary_Collateral_Type__c;
    /* Allow Sublimts on Applications
    */
    global Boolean genesis__Allow_SubLimits__c;
    /* Allow this product to be used while creating complex deal package application
    */
    global Boolean genesis__Use_As_Package_Product__c;
    /* Allow this product to be used when creating SubLimits
    */
    global Boolean genesis__Use_As_SubLimit_Product__c;
    global clcommon__CL_Product__c genesis__Annual_Review_Product__r;
    global Id genesis__Annual_Review_Product__c;
    global BusinessHours genesis__Bank_Hours__r;
    global Id genesis__Bank_Hours__c;
    global Double genesis__Digits_After_Decimal__c;
    global String genesis__External_ID__c;
    global Boolean genesis__Move_Across_Month__c;
    global String genesis__Rounding_Method__c;
    global String genesis__Schedule_Adjustment_Method__c;
    global String genesis__Interest_Period_Calculation__c;
    global Boolean clcommon__Covered_under_MLA__c;
    global String clcommon__External_Id__c;
    global clcommon__Fee_Set__c clcommon__Fee_Set__r;
    global Id clcommon__Fee_Set__c;
    global Boolean clcommon__HMDA_Loan__c;
    /* This field defines the short form of product name
    */
    global String clcommon__Product_Abbreviation__c;
    /* This field if checked enable the status and the document comments to be tracked at the File level
    */
    global Boolean clcommon__Status_Tracking_At_Document_File_Level__c;
    global Boolean genesis__TRID_Loan__c;
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
    global List<clcommon__Accounting_Rule_Header__c> clcommon__Accounting_Rule_Header__r;
    global List<clcommon__Agreement__c> Dealer_Programs__r;
    global List<clcommon__CL_Product__Share> Shares;
    global List<clcommon__CL_Product__c> genesis__CL_Products__r;
    global List<clcommon__Company_Product_Assignment__c> clcommon__Company_Product_Assignments__r;
    global List<clcommon__Covenant_Definition__c> clcommon__Covenant_Template__r;
    global List<clcommon__Loan_Account_Document_Documents__c> clcommon__CL_Product_Document_Definitions__r;
    global List<clcommon__Product_Insurance_Association__c> clcommon__Product_Insurance_Associations__r;
    global List<clcommon__Product_Purpose_Association__c> clcommon__Product_Purpose_Associations__r;
    global List<clcommon__Program_Or_Product_Points_Association__c> clcommon__Program_Or_Product_Points_Associations__r;
    global List<clcommon__Promotion_Setup__c> clcommon__Promotion_Setup__r;
    global List<cllease__Lease_Account__c> cllease__LS_Contracts__r;
    global List<cllease__Lease_Product__c> cllease__Lease_Products__r;
    global List<genesis__Application_Alternate_Product__c> genesis__Application_Alternate_Products__r;
    global List<genesis__Applications__c> genesis__Applications__r;
    global List<genesis__Policy_Condition_Product_Association__c> genesis__Policy_Condition_Product_Association__r;
    global List<genesis__Product_Department_Junction__c> genesis__Product_Junction__r;
    global List<genesis__Product_Document_Category_Junction__c> genesis__Product_Document_Category_Junctio_del1__r;
    global List<genesis__Product_Rate_Card_Association__c> genesis__Product_Rate_Card_Association__r;
    global List<genesis__Product_Rule_Association__c> genesis__Product_Rule_Association__r;
    global List<genesis__Product_Scorecard_Junction__c> genesis__Product_Scorecard_Junction__r;
    global List<genesis__Product_Service_Validation_Config__c> genesis__Product_Service_Validation_Config__r;
    global List<genesis__Product_Yield_Definition_Association__c> genesis__Product_Yield_Definition_Association__r;
    global List<genesis__Quick_Quotes__c> Credit_Approvals__r;
    global List<genesis__Quick_Quotes__c> genesis__Quick_Quotes__r;
    global List<genesis__Rate_Card_Setup_Header__c> genesis__Rate_Card_Setup__r;
    global List<genesis__Referral__c> genesis__Referral_Opportunities__r;
    global List<genesis__SubLimit__c> genesis__SubLimits__r;
    global List<genesis__Treasury_Criteria_Results__c> genesis__Treasury_Criteria_Results__r;
    global List<genesis__Treasury_Product_Service_Criteria_Config__c> genesis__Treasury_Product_Service_Criteria_Config__r;
    global List<genesis__Treasury_Services__c> genesis__Treasury_Services__r;
    global List<staging__Interface_Contract__c> genesis__Interface_Contract__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__CL_Product__c () 
    {
    }
}