// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Contract_Equipment__c {
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
    global Double cllease__City_Surcharge__c;
    /* City Tax Rate, populated from setup
    */
    global Double cllease__City_Tax_Rate__c;
    global String cllease__City__c;
    global String cllease__Country__c;
    global Double cllease__County_Surcharge__c;
    /* County Tax Rate, populated from setup
    */
    global Double cllease__County_Tax_Rate__c;
    global String cllease__County__c;
    global String cllease__Dealer_Contact_Email__c;
    global String cllease__Dealer_Contact_Name__c;
    global Decimal cllease__Dealer_Fees__c;
    global Boolean cllease__Dealer_Funded__c;
    global Account cllease__Dealer_Name__r;
    global Id cllease__Dealer_Name__c;
    global cllease__Contract_Parties__c cllease__Dealer_Party__r;
    global Id cllease__Dealer_Party__c;
    global String cllease__Dealer_Phone_Number__c;
    /* This value is being used to calculate rate factor for calculating due detail line and used during termination
    */
    global Double cllease__Equipment_Calculated_Cost__c;
    /* Equipment_Cost
    */
    global Decimal cllease__Equipment_Cost__c;
    global String cllease__Equipment_Description__c;
    global String cllease__Equipment_Serial_Number__c;
    global String cllease__Equipment_Type__c;
    global Decimal cllease__Estimated_Selling_Price__c;
    global String cllease__Item_Code__c;
    global String cllease__LeaseApplicationNumber__c;
    global String cllease__LeaseApplication__c;
    global String cllease__Make__c;
    global String cllease__Model__c;
    global Decimal cllease__Other_Financed_Fees__c;
    /* If this flag is checked the system will use Override Tax Rate
    */
    global Boolean cllease__Override_Tax_Flag__c;
    /* Override Tax Rate,
    */
    global Double cllease__Override_Tax_Rate__c;
    /* Enter Total Residual Receivable.  If term residual =  number of rsd pmts x pmt amt.  If FMV = 10%xFinanced Amount
    */
    global Decimal cllease__Residual_Amount__c;
    global Boolean cllease__Select_Equipment__c;
    global String cllease__State_Province__c;
    global Double cllease__State_Surcharge__c;
    /* State Tax Rate, populated from setup
    */
    global Double cllease__State_Tax_Rate__c;
    global String cllease__Status__c;
    global String cllease__Street_Address__c;
    global Decimal cllease__Subvention__c;
    global Decimal cllease__Tax_Amount__c;
    global String cllease__Tax_Code__c;
    global String cllease__Tax_Depreciation_Method__c;
    global Decimal cllease__Tax_Residual_Value__c;
    global Boolean cllease__Tax_exemption__c;
    global Decimal cllease__Total_Dealer_Charges__c;
    global Decimal cllease__Total_Tax_Amount__c;
    /* This is not a formula column
    */
    global Double cllease__Total_Tax_Rate_Derived__c;
    global Double cllease__Total_Tax_Rate__c;
    global String cllease__Upfront_Tax_Basis__c;
    /* Is the tax charged upfront on this account.
    */
    global Boolean cllease__Upfront_Tax_Flag__c;
    global String cllease__VIN__c;
    global Decimal cllease__Warranty_Amount__c;
    global String cllease__Year__c;
    global String cllease__Zip_Code__c;
    global Double cllease__life_in_months__c;
    global String cllease__return_status__c;
    global String cllease__status1__c;
    global Boolean cllease__tax_financed__c;
    /* This amount is used to calculate Quote Purchase Amount for termination type with purchase
    */
    global Decimal Additional_Residual_Amount__c;
    global String Asset_ID__c;
    global String Asset_Type_ID__c;
    global String Asset_Type_Name__c;
    global Decimal Balance_Net_Trade_Up_Amount__c;
    global Decimal Bill_Residual_Amount__c;
    global String Business_Unit__c;
    global String Cost_Center__c;
    global Decimal Dealer_Charges__c;
    global String Department_Name__c;
    global Boolean Eligible_for_property_tax__c;
    global String Equipment_Description1__c;
    global String External_Id__c;
    global String GARD__c;
    global Account Install_Account__r;
    global Id Install_Account__c;
    global String Install_Address_Line_1__c;
    global String Install_Address_Line_2__c;
    global Address__c Install_Address__r;
    global Id Install_Address__c;
    global Date Install_Date__c;
    global Date Invoice_Date__c;
    global String Invoice_Number__c;
    global String Lessee_Code__c;
    global String Lessee_Company__c;
    global String Manufacturer__c;
    global String Master_Asset_Type_ID__c;
    global String Master_Asset_Type__c;
    global Decimal Net_Trade_Up_Amount__c;
    global String Object_Category_ID__c;
    global String Object_Category_Name__c;
    global String Owner_Class__c;
    global String Prior_Owner_Class__c;
    global String Product_Type__c;
    global Decimal Rent_Amount__c;
    global Double Residual_Percentage__c;
    global String Serial_Number__c;
    global String State_Code__c;
    global Date Termination_Date__c;
    global String State__c;
    global Decimal cllease__Subsidy__c;
    global Decimal Evergreen_Depreciable_Cost__c;
    global Double Evergreen_Depreciable_Life__c;
    global Date Last_Residual_Burndown_Date__c;
    global Decimal NBV__c;
    global Decimal Remaining_Evergreen_Depreciable_Cost__c;
    global Decimal Salvage_Value__c;
    global Decimal Oracle_Trade_Up_Amount__c;
    global Decimal Total_Equipment_Cost__c;
    global Account cllease__Account__r;
    global Id cllease__Account__c;
    /* This field should be specified only if invoices are to be generated for associated account
    */
    global clcommon__Bill_Group__c cllease__Bill_Group__r;
    /* This field should be specified only if invoices are to be generated for associated account
    */
    global Id cllease__Bill_Group__c;
    /* This field should be specified only if invoices are to be generated for associated account
    */
    global clcommon__Billing_Group__c cllease__Billing_Group__r;
    /* This field should be specified only if invoices are to be generated for associated account
    */
    global Id cllease__Billing_Group__c;
    global Boolean cllease__Created_Through_Contract__c;
    global String cllease__Depreciation_Basis__c;
    global Decimal cllease__Equipment_Book_Value__c;
    global String cllease__Equipment_External_Id__c;
    global clcommon__Equipment__c cllease__Equipment_Id__r;
    global Id cllease__Equipment_Id__c;
    global Decimal cllease__Equipment_Net_Book_Value__c;
    /* The amount at which the equipment will depreciate in the Evergreen state
    */
    global Decimal cllease__Evergreen_Depreciation_Amount__c;
    /* This flag will be set to true during restructure to highlight that during the restructure process corresponding equipment will be swapped/exchanged (Internal)
    */
    global Boolean cllease__Flag_To_Delete__c;
    global Boolean cllease__Generate_Book_Depreciation__c;
    /* Test
    */
    global Decimal cllease__New_Invoice_Price__c;
    /* The date when next charge will be generated
    */
    global Date cllease__Next_Variable_Rent_Due_Date__c;
    /* This is the contract equipment id in the original contract. We will use this id to identify the original equipment which need to replaced as part of restructure. (Internal)
    */
    global cllease__Contract_Equipment__c cllease__Original_Equipment_Id__r;
    /* This is the contract equipment id in the original contract. We will use this id to identify the original equipment which need to replaced as part of restructure. (Internal)
    */
    global Id cllease__Original_Equipment_Id__c;
    /* This contains the asset level rental amount
    */
    global Decimal cllease__Rent__c;
    global cllease__Tax_Depreciation_Setup__c cllease__Tax_Depreciation__r;
    global Id cllease__Tax_Depreciation__c;
    /* The frequency by which the charge will get created.
    */
    global String cllease__Variable_Rent_Frequency__c;
    /* The date from which usage based charge will start
    */
    global Date cllease__Variable_Rent_Start_Date__c;
    global clcommon__Collateral__c cllease__Warehouse_Equipment__r;
    global Id cllease__Warehouse_Equipment__c;
    global Decimal NPA_Amount__c;
    global Decimal NPBA_Amount__c;
    /* For internal use to check which split equipment this is
    */
    global String cllease__Asset_Split_Equipment__c;
    global String cllease__External_Id__c;
    global String cllease__History_Tracking_Id__c;
    global Decimal cllease__NBV_On_Restructure_Date__c;
    /* This field holds the New Rent after Restructure
    */
    global Decimal cllease__New_Rent__c;
    /* VAT Code If overridden
    */
    global clcommon__VAT_Rate_Setup__c cllease__Override_VAT_Code__r;
    /* VAT Code If overridden
    */
    global Id cllease__Override_VAT_Code__c;
    /* The number of equipments attached to this equipment
    */
    global Double cllease__Quantity__c;
    global String City_InstallAddress__c;
    global String County_InstallAddress__c;
    global String Country_InstallAddress__c;
    global String Zip_Code_InstallAddress__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Lease_Claim_Equipment__c> Lease_Claim_Equipment1__r;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<Property_Tax__c> Property_Taxes__r;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<clcommon__Equipment_Detail__c> cllease__Equipment_Details__r;
    global List<cllease__Asset_Return__c> cllease__asset_return__r;
    global List<cllease__Asset_workbench__c> cllease__Asset_workbenchs__r;
    global List<cllease__Asset_workbench__c> cllease__Asset_Workbenchs1__r;
    global List<cllease__Charge__c> Charges__r;
    global List<cllease__Charge__c> cllease__Charges__r;
    global List<cllease__Contract_Equipment__History> Histories;
    global List<cllease__Contract_Equipment__c> cllease__Contract_Equipment__r;
    global List<cllease__Contract_Fees__c> cllease__Fee_Schedule__r;
    global List<cllease__Dealer_Funding_Detail__c> cllease__Dealer_Equipment_details__r;
    global List<cllease__Debt_Detail__c> cllease__Debt_Details__r;
    global List<cllease__Due_Detail_Lines__c> cllease__Due_Detail_Lines__r;
    global List<cllease__Expense_Fee_Transaction__c> cllease__Expense_Fees__r;
    global List<cllease__Insurance_Policy_Equipment__c> cllease__Insurance_Policy_Equipments__r;
    global List<cllease__Other_Transaction__c> cllease__Other_Transactions__r;
    global List<cllease__Payment_Stream__c> cllease__Payment_Streams__r;
    global List<cllease__Repossession_Equipment__c> cllease__Repossession_Equipments__r;
    global List<cllease__Repossession__c> cllease__Repossessions__r;
    global List<cllease__Subsidy__c> cllease__Subsidy__r;
    global List<cllease__Tax_Dep_Stream__c> cllease__Tax_Dep_Streams__r;
    global List<cllease__Termination_Quote_Equipment__c> cllease__Termination_Quote_Equipments__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Contract_Equipment__c () 
    {
    }
}