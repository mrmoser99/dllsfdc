// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Application_Equipment__c {
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
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global Decimal genesis__Collateral_Value__c;
    /* Deselect if you DO NOT  want to copy the equipment details fetched from source to Internal database.
    */
    global Boolean genesis__Copy_data_to_VehicleValuation__c;
    global Decimal genesis__Dealer_Fees__c;
    global genesis__Equipment_Master__c genesis__Equipment__r;
    global Id genesis__Equipment__c;
    global Decimal genesis__Estimated_Selling_Price__c;
    global Decimal genesis__Finance_Advance_Adjusted__c;
    global Decimal genesis__Finance_Advance_Base__c;
    global Decimal genesis__Finance_Advance_Mileage_Adjustment__c;
    global Decimal genesis__Other_Financed_Fees__c;
    global Decimal genesis__Residual_Value__c;
    global Decimal genesis__Retail_Average_Adjusted_Amount__c;
    global Decimal genesis__Retail_Average_Base_Amount__c;
    global Decimal genesis__Retail_Average_Mileage_Adjustment__c;
    /* Please select a particular source from where vehicle valuation data needs to be fetched in case the data is not found in internal records.
    */
    global String genesis__Select_Souce__c;
    global Decimal genesis__Tax_Amount__c;
    global Decimal genesis__Total_Dealer_Charges__c;
    global genesis__Vehicle_Valuation__c genesis__Vehicle_Valuation__r;
    global Id genesis__Vehicle_Valuation__c;
    global Decimal genesis__Warranty_Amount__c;
    global Decimal genesis__Wholesale_Average_Adjusted_Amount__c;
    global Decimal genesis__Wholesale_Average_Base_Amount__c;
    global Decimal genesis__Wholesale_Average_Mileage_Adjustment__c;
    global Decimal genesis__Wholesale_Rough_Adjusted_Amount__c;
    global Decimal genesis__Wholesale_Rough_Base_Amount__c;
    global Decimal genesis__Wholesale_Rough_Mileage_Adjustment__c;
    global String Asset_ID__c;
    global String Asset_Type_ID__c;
    global String Asset_Type_Name__c;
    global String City__c;
    global Decimal Dealer_Charges1__c;
    global Date Dealer_Invoice_Date__c;
    global String Dealer_Invoice_Number__c;
    global String Description__c;
    global String Equip_ID__c;
    global Account Install_Account__r;
    global Id Install_Account__c;
    global Address__c Install_Address1__r;
    global Id Install_Address1__c;
    global String Install_Address__c;
    global String Install_City__c;
    global Date Install_Date_Max__c;
    global Address_Usage__c Install_Location__r;
    global Id Install_Location__c;
    global String Install_Zip_Code__c;
    global Date Installation_Date__c;
    global Decimal MSRP__c;
    global String Make__c;
    global String Manufacturer1__c;
    global String Manufacturer__c;
    global String Master_Asset_Type_ID__c;
    global String Master_Asset_Type__c;
    global String Model1__c;
    global String Model_Number__c;
    global String Object_Category_ID__c;
    global String Object_Category_Name__c;
    global String Override_Upfront_Tax_Flag__c;
    global String Product_Type1__c;
    global Double Quantity__c;
    global Decimal Residual_Amount__c;
    global String Serial_Number__c;
    global Double Soft_Costs__c;
    global String State__c;
    global Boolean Tax_Exempt__c;
    global String Tax_Payment_Type__c;
    global Decimal Upfront_Tax_Amount__c;
    global String Upfront_Tax_Basis__c;
    global Boolean Upfront_Tax_Processed__c;
    global String Zipcode__c;
    global String Install_State__c;
    global String Vertex_State__c;
    global Decimal Remaining_Residual_Amount_Copy__c;
    global Decimal Remaining_Residual_Amount__c;
    global Decimal Salvage_Value1__c;
    global Double Asset_Life_in_Months__c;
    global Decimal Oracle_Trade_Up_Amount__c;
    global String GARD__c;
    global String Gard_Code__c;
    global Boolean Tax_Financed__c;
    global Boolean Upfront_Tax_Flag__c;
    global Decimal NPA_Amount__c;
    global List<Application_Fee__c> Application_Fees__r;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Equipment_Funding_Detail__c> Equipment_Funding_Detail__r;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<clcommon__Equipment_Detail__c> genesis__Equipment_Details__r;
    global List<genesis__Applications__c> Applications__r;
    global List<ints__Blackbook_Result__c> genesis__Blackbook_Result__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Application_Equipment__c () 
    {
    }
}