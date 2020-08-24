// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Due_Detail_Lines__c {
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
    global cllease__Lease_account_Due_Details__c cllease__Bill__r;
    global Id cllease__Bill__c;
    global Decimal cllease__City_Surcharge__c;
    global Double cllease__City_Tax_Rate__c;
    global Decimal cllease__City_Tax__c;
    global cllease__Contract_Equipment__c cllease__Contract_Equipment__r;
    global Id cllease__Contract_Equipment__c;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Decimal cllease__County_Surcharge__c;
    global Double cllease__County_Tax_Rate__c;
    global Decimal cllease__County_Tax__c;
    /* Due Date of the Due
    */
    global Date cllease__Due_Date__c;
    global String cllease__Id__c;
    global Decimal cllease__Other_Due_Amount__c;
    global Double cllease__Other_Tax1_Rate__c;
    global Decimal cllease__Other_Tax1__c;
    global Double cllease__Other_Tax2_Rate__c;
    global Decimal cllease__Other_Tax2__c;
    global Double cllease__Other_Tax3_Rate__c;
    global Decimal cllease__Other_Tax3__c;
    global Double cllease__Other_Tax4_Rate__c;
    global Decimal cllease__Other_Tax4__c;
    global Decimal cllease__Other_Tax__c;
    global String cllease__Remarks__c;
    global Decimal cllease__Rental_Due_Amount__c;
    global Decimal cllease__State_Surcharge__c;
    global Double cllease__State_Tax_Rate__c;
    global Decimal cllease__State_Tax__c;
    global Decimal cllease__Tax_Due_Amount__c;
    global Boolean cllease__Tax_Processed__c;
    global Decimal cllease__Total_Due_Amount__c;
    global Double cllease__Total_Tax_Rate__c;
    /* Date on which the transaction got created.
    */
    global Date cllease__Transaction_Date__c;
    global Decimal cllease__VAT_Amount__c;
    global String BillingType__c;
    global String CompanyCode__c;
    global String Contract_Type__c;
    global String DestinationCity__c;
    global String DestinationCounty__c;
    global String DestinationZipCode__c;
    global Decimal Estimated_Property_Tax_Fee_Amount__c;
    global Decimal Estimated_Property_Tax_Tax_Amount__c;
    global String LeaseType__c;
    global String MessageS__c;
    global Decimal Payment_Amount__c;
    global Decimal Payment_Sales_Use_Tax__c;
    global Decimal Payment_Total_Amount__c;
    global Decimal Service_Fee_Fee_Amount__c;
    global Decimal Service_Fee_Tax_Amount__c;
    global Decimal Tax_APO__c;
    global Decimal Tax_BOROUGH__c;
    global Decimal Tax_CITY__c;
    global Decimal Tax_COUNTRY__c;
    global Decimal Tax_COUNTY__c;
    global String Tax_Component__c;
    global Decimal Tax_DISTRICT__c;
    global Decimal Tax_FPO__c;
    global Decimal Tax_LOCAL_IMPROVEMENT_DISTRICT__c;
    global Decimal Tax_PARISH__c;
    global Decimal Tax_PROVINCE__c;
    global String Tax_Payment_Type__c;
    global Double Tax_Rate_APO__c;
    global Double Tax_Rate_BOROUGH__c;
    global Double Tax_Rate_CITY__c;
    global Double Tax_Rate_COUNTRY__c;
    global Double Tax_Rate_COUNTY__c;
    global Double Tax_Rate_DISTRICT__c;
    global Double Tax_Rate_FPO__c;
    global Double Tax_Rate_LOCAL_IMPROVEMENT_DISTRICT__c;
    global Double Tax_Rate_PARISH__c;
    global Double Tax_Rate_PROVINCE__c;
    global Double Tax_Rate_SPECIAL_PURPOSE_DISTRICT__c;
    global Double Tax_Rate_STATE__c;
    global Double Tax_Rate_TERRITORY__c;
    global Double Tax_Rate_TOWNSHIP__c;
    global Double Tax_Rate_TRADE_BLOCK__c;
    global Double Tax_Rate_TRANSIT_DISTRICT__c;
    global Decimal Tax_SPECIAL_PURPOSE_DISTRICT__c;
    global Decimal Tax_STATE__c;
    global Decimal Tax_TERRITORY__c;
    global Decimal Tax_TOWNSHIP__c;
    global Decimal Tax_TRADE_BLOCK__c;
    global Decimal Tax_TRANSIT_DISTRICT__c;
    global String Taxbasis__c;
    global Decimal Total_Amount_Conga__c;
    global String Transaction_Code__c;
    global String Vertex_Tax_Processed__c;
    global String DestinationState__c;
    global String Equipment__c;
    global Invoice__c Invoice__r;
    global Id Invoice__c;
    global clcommon__Consolidated_Invoice__c Consolidated_Invoice__r;
    global Id Consolidated_Invoice__c;
    global Decimal Dll_Service_Tax__c;
    global Decimal Dll_Service__c;
    global Decimal Dll_Tax_Total__c;
    global Decimal Dll_Total__c;
    global Decimal Quote_Discount_TAX__c;
    global Decimal Quote_Discount__c;
    global Decimal Quote_Estimated_Property_TAX__c;
    global Decimal Quote_Estimated_Property_Tax_TAX__c;
    global Decimal Quote_Fee_TAX__c;
    global Decimal Quote_Fee__c;
    global Decimal Quote_Purchase_Amount_Tax__c;
    global Decimal Quote_Purchase_Amount__c;
    global Decimal Quote_Rollover_Incentive_TAX__c;
    global Decimal Quote_Rollover_Incentive__c;
    global Decimal Quote_Service_and_Maintainence__c;
    global Decimal Quote_Service_and_Maintenance_TAX__c;
    global Decimal Quote_Unbilled_Receivable_TAX__c;
    global Decimal Quote_Unbilled_Receivable__c;
    global String Termination_Quote_Reason__c;
    global String Termination_Quote_Type__c;
    /* To signify tax exemption
    */
    global Boolean cllease__Tax_Exempt__c;
    /* To signify tax override
    */
    global Boolean cllease__Tax_Override__c;
    /* Link to the applied VAT code
    */
    global clcommon__VAT_Rate_Setup__c cllease__VAT_Code__r;
    /* Link to the applied VAT code
    */
    global Id cllease__VAT_Code__c;
    global List<Adjustment__c> Adjustments__r;
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
    global List<cllease__Tax_API_Due_Detail_Error_Log__c> cllease__Tax_API_Due_Detail_Error_Logs__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Due_Detail_Lines__c () 
    {
    }
}