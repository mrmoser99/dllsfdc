// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Collateral__c {
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
    global Date clcommon__Acceptance_Date__c;
    global String clcommon__Account_Number__c;
    global String clcommon__Acknowledgement_Type__c;
    global String clcommon__Address__c;
    global Boolean clcommon__Agricultural_Use__c;
    global String clcommon__Airport__c;
    global String clcommon__Block__c;
    global Boolean clcommon__Book_Entry__c;
    global String clcommon__CUSIP_Number__c;
    global Boolean clcommon__Certificated__c;
    global String clcommon__City__c;
    global Boolean clcommon__Collateral_Affixed_to_Site__c;
    global clcommon__Collateral_Category__c clcommon__Collateral_Category__r;
    global Id clcommon__Collateral_Category__c;
    global String clcommon__Collateral_Code__c;
    global Boolean clcommon__Collateral_Insurance_Required__c;
    global String clcommon__Collateral_Name__c;
    global String clcommon__Collateral_Secures__c;
    global clcommon__Collateral_Type__c clcommon__Collateral_Type__r;
    global Id clcommon__Collateral_Type__c;
    global Decimal clcommon__Collateral_Value_Limit__c;
    global Boolean clcommon__Commercial_Use__c;
    global Boolean clcommon__Condo__c;
    global Date clcommon__Contract_Date__c;
    global String clcommon__Contract_Number__c;
    global String clcommon__Contracting_Party__c;
    global Date clcommon__Delivery_Date__c;
    global String clcommon__Describe_Log_Books__c;
    global String clcommon__Description__c;
    global Boolean clcommon__Dwelling__c;
    global Boolean clcommon__Existing_Beneficiaries__c;
    global Boolean clcommon__Existing_Lien__c;
    global Boolean clcommon__FAA_Cover_Letter__c;
    global String clcommon__FAA_Number__c;
    global Boolean clcommon__First_Lien__c;
    global Double clcommon__Gross_Tonnage__c;
    global String clcommon__Held_By__c;
    global Boolean clcommon__Homestead_Property__c;
    global Boolean clcommon__IDERA__c;
    global Boolean clcommon__Include_Collateral_Receipt__c;
    global Boolean clcommon__Include_Land__c;
    global Boolean clcommon__Inspection_Report__c;
    global Decimal clcommon__Insurance_Amount__c;
    global String clcommon__Insurance_Company_Name__c;
    global Boolean clcommon__Is_UCC__c;
    global String clcommon__Issued_By__c;
    global Boolean clcommon__Leasehold__c;
    global Date clcommon__Letter_of_Credit_Date__c;
    global String clcommon__Lot__c;
    global String clcommon__Make__c;
    global Boolean clcommon__Manufactured_Home__c;
    global String clcommon__Manufacturer__c;
    global Decimal clcommon__Market_Value_Limit__c;
    global String clcommon__Model__c;
    global String clcommon__Name_of_Insured__c;
    global String clcommon__Name_of_Vessel__c;
    global Double clcommon__Net_Tonnage__c;
    global Double clcommon__Number_of_Shares__c;
    global Double clcommon__Number_of_Units__c;
    global String clcommon__Official_Number__c;
    global Boolean clcommon__Owner_Occupied__c;
    global String clcommon__Owners_Interest__c;
    global String clcommon__Parcel_Number__c;
    global String clcommon__Policy_Number__c;
    global String clcommon__Policy_Return_Address__c;
    global String clcommon__Port_Name__c;
    global Decimal clcommon__Possessory_Current_Balance__c;
    global String clcommon__Possessory_Type__c;
    global String clcommon__Postal_Code__c;
    global Boolean clcommon__Principal_Dwelling__c;
    global String clcommon__Property_Tax_ID_Number__c;
    global String clcommon__Property_Type__c;
    global Boolean clcommon__Purchase_Money__c;
    global String clcommon__Range__c;
    global Boolean clcommon__Record_Financial_Statement__c;
    global Boolean clcommon__Refinance__c;
    global String clcommon__Registration_State__c;
    global Boolean clcommon__Residential_Property__c;
    global String clcommon__Restriction_on_Sale__c;
    global String clcommon__Section__c;
    global Boolean clcommon__Secure_Future_Advances__c;
    global Boolean clcommon__Secured_By_Interest_In_Property__c;
    global Boolean clcommon__Seller_Financed_Transaction__c;
    global String clcommon__State__c;
    global String clcommon__Status__c;
    global String clcommon__Style__c;
    global Boolean clcommon__Timeshare__c;
    global String clcommon__Township__c;
    global Boolean clcommon__UCC_Financing_Statement__c;
    global Date clcommon__Value_Date__c;
    global String clcommon__Value_Source__c;
    global Decimal clcommon__Value__c;
    global String clcommon__Vehicle_Color__c;
    global String clcommon__Vehicle_ID_Number__c;
    global String clcommon__Vehicle_Serial_Number__c;
    global String clcommon__Year__c;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global Boolean genesis__Primary__c;
    global genesis__Property__c genesis__Property__r;
    global Id genesis__Property__c;
    /* Initially it will be same as purchased price and on equipment depreciation this field will be updated to ending NBV
    */
    global Decimal clcommon__Book_Value__c;
    /* The Company to which the Collateral belongs.
    */
    global clcommon__Company__c clcommon__Company__r;
    /* The Company to which the Collateral belongs.
    */
    global Id clcommon__Company__c;
    global String clcommon__Current_Mileage__c;
    global String clcommon__Dealer_Funding_Status__c;
    global Boolean clcommon__Depreciate_Leased_Equipment__c;
    global Decimal clcommon__Depreciation_Basis_Amount__c;
    /* From this date onward the equipment will start depreciating. If empty will be defaulted to purchased date.
    */
    global Date clcommon__Depreciation_Start_Date__c;
    global Decimal clcommon__Depreciation_Value__c;
    global Decimal clcommon__Down_Payment__c;
    /* Can be used to store information about the equipment
    */
    global String clcommon__Equipment_Description__c;
    global String clcommon__Equipment_Id__c;
    /* e.g if an equipment life time is for an year then user should record it as 12 (months count)
    */
    global Double clcommon__Equipment_Life_in_Months__c;
    global Decimal clcommon__Equipment_NBV__c;
    global String clcommon__Equipment_Type__c;
    global String clcommon__Fuel_Type__c;
    global Boolean clcommon__Generate_Book_Depreciation__c;
    global String clcommon__Hull_Type__c;
    global Decimal clcommon__Left_Over_Depreciation_Value__c;
    global Double clcommon__Length_in_Feet__c;
    global String clcommon__Lien_Holder__c;
    global clcommon__Collateral__c clcommon__Master_Equipment__r;
    global Id clcommon__Master_Equipment__c;
    global String clcommon__Motor_Type__c;
    global Date clcommon__Next_Depreciation_Date__c;
    global Double clcommon__Number_of_Axles__c;
    global Double clcommon__Number_of_Motors__c;
    global Decimal clcommon__Prorated_Depreciation_Balance__c;
    global String clcommon__Purchase_Name__c;
    global Date clcommon__Purchased_Date__c;
    global Decimal clcommon__Purchased_Price__c;
    global String clcommon__Purchasing_From__c;
    global String clcommon__RV_Body_Style__c;
    global Decimal clcommon__Salvage_Value__c;
    global Decimal clcommon__Subsidy__c;
    global Decimal clcommon__Subvention__c;
    global Decimal clcommon__Trade_In_Amount_Owed__c;
    global String clcommon__Trade_In_Value__c;
    global Boolean clcommon__Trade_In__c;
    global String clcommon__Trailer_Body_Style__c;
    global String clcommon__Vehicle_Identification_Number__c;
    global String clcommon__Vehicle_Type__c;
    global String clcommon__Vessel_Type__c;
    global clcommon__Warehouse_Depreciation_Setup__c clcommon__Warehouse_Depreciation_Setup__r;
    global Id clcommon__Warehouse_Depreciation_Setup__c;
    global Double clcommon__Weight_in_Lbs__c;
    global Boolean cllease__In_Partial_Contract__c;
    /* This field is to be added to capture the additional address line.
    */
    global String clcommon__Address_Line_2__c;
    /* This will display the age of vehicle in Years
    */
    global Double clcommon__Age__c;
    /* This is the date when the copy of appraisal report was shared with the customer
    */
    global Date clcommon__Appraisal_Disclosure_Date__c;
    /* This is the checkbox to indicate if the borrower has waived the right to receive an appraisal report copy
    */
    global Boolean clcommon__Appraisal_Waiver__c;
    global Decimal clcommon__Available_Amount__c;
    /* Census tract number for the real estate property
    */
    global String clcommon__Census_Tract_Number__c;
    /* Stores the value of the equipment Id of copied equipment
    */
    global clcommon__Collateral__c clcommon__Copy_From_Equipment__r;
    /* Stores the value of the equipment Id of copied equipment
    */
    global Id clcommon__Copy_From_Equipment__c;
    /* This checkbox will be set to true if a single collateral is linked to multiple applications as a collateral.
    */
    global Boolean clcommon__Cross_Collateralised__c;
    global Decimal clcommon__Estimated_Value__c;
    global String clcommon__External_Id__c;
    global clcommon__Financial_Statement_Template__c clcommon__Financial_Statement_Template__r;
    global Id clcommon__Financial_Statement_Template__c;
    /* This field will store the flood insurance amount that is required for that collateral
    */
    global Double clcommon__Flood_Insurance_Amount_Required__c;
    global clcommon__Industry_Classification_Code__c clcommon__Industry_Classification_Code__r;
    global Id clcommon__Industry_Classification_Code__c;
    /* This field will store the Insurance Company Information associated with the Insurance linked to the Collateral
    */
    global Account clcommon__Insurance_Company__r;
    /* This field will store the Insurance Company Information associated with the Insurance linked to the Collateral
    */
    global Id clcommon__Insurance_Company__c;
    /* This checkbox is to indicate of there any current or proposed improvements on this land. This checkbox must be enabled only if the "Include Land" field is true.
    */
    global Boolean clcommon__Land_Improvements__c;
    /* Select the lender's lien position on the collateral.
    */
    global Double clcommon__Lien_Position__c;
    /* This field will store the name of the beneficiary of the Life Insurance. This is an Account Lookup.
    */
    global Boolean clcommon__Life_Insurance_Beneficiary_Name__c;
    /* This field will store the name of the beneficiary of the Life Insurance. This is an Account Lookup.
    */
    global Account clcommon__Life_Insurance_Beneficiary__r;
    /* This field will store the name of the beneficiary of the Life Insurance. This is an Account Lookup.
    */
    global Id clcommon__Life_Insurance_Beneficiary__c;
    /* Indicate if the secured property is located in a special flood hazard area.
    */
    global Boolean clcommon__Located_in_Flood_Area__c;
    /* This checkbox will indicate if the property is a planned unit development
    */
    global Boolean clcommon__PUD__c;
    /* Last 4 digits or delivery route information of the postal code
    */
    global String clcommon__Postal_Code_Last_4__c;
    /* Block number for the real estate property
    */
    global String clcommon__Property_Block_Number__c;
    /* County name for the real estate property
    */
    global String clcommon__Property_County__c;
    /* Any other legal description for the real estate property
    */
    global String clcommon__Property_Legal_Description__c;
    /* Lot number for the real estate property
    */
    global String clcommon__Property_Lot_Number__c;
    /* Metro division for the metro statistical area for the real estate property.
    */
    global String clcommon__Property_Metro_Division__c;
    /* The metropolitan statistical area for the real estate property
    */
    global String clcommon__Property_Metro_Statistical_Area__c;
    /* Parcel number for the real estate property
    */
    global String clcommon__Property_Parcel_Number__c;
    global String clcommon__Property_Range__c;
    /* Property section for the real estate property
    */
    global String clcommon__Property_Section__c;
    /* Subdivision phase for the real estate property
    */
    global String clcommon__Property_Subdivision_Phase__c;
    /* Subdivision number for the property
    */
    global String clcommon__Property_Subdivision__c;
    /* Township in which the real estate property is situated
    */
    global String clcommon__Property_Township__c;
    /* Unit number for the real estate property
    */
    global String clcommon__Property_Unit_Number__c;
    /* Signifies the quantity of Collaterals to be assigned.
    */
    global Double clcommon__Quantity__c;
    global Decimal clcommon__Total_Lien_Placed__c;
    global Decimal clcommon__Trade_Value__c;
    /* This field is to be added to capture the US Territory.
    */
    global String clcommon__US_Territory__c;
    global genesis__Equipment_Master__c genesis__Equipment_Master__r;
    global Id genesis__Equipment_Master__c;
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
    global List<clcommon__Book_Value_Adjustment__c> clcommon__Book_Value_Adjustments__r;
    global List<clcommon__CollateralLien__c> clcommon__CollateralLiens__r;
    global List<clcommon__Collateral_Insurance__c> clcommon__Collateral_Insurance__r;
    global List<clcommon__Collateral_Location__c> clcommon__Collateral_Locations__r;
    global List<clcommon__Collateral_Owner__c> clcommon__Collateral_Owner__r;
    global List<clcommon__Collateral_Registration__c> clcommon__Collateral_Registration__r;
    global List<clcommon__Collateral_Valuation__c> clcommon__Collateral_Valuation__r;
    global List<clcommon__Collateral__Share> Shares;
    global List<clcommon__Collateral__c> clcommon__Collaterals__r;
    global List<clcommon__Collateral__c> clcommon__Child_Equipments__r;
    global List<clcommon__Dealer_Funding_Detail__c> clcommon__Dealer_Funding_Details__r;
    global List<clcommon__Depreciation_Stream__c> clcommon__Depreciation_Streams__r;
    global List<clcommon__Disbursement_Transaction__c> clcommon__Expense_Transactions__r;
    global List<clcommon__Document_Category__c> clcommon__Document_Category__r;
    global List<clcommon__Equipment_Fees__c> clcommon__Equipment_Fees__r;
    global List<clcommon__Equipment_Sale_Quote_Line__c> clcommon__Equipment_Sale_Quote_Lines__r;
    global List<clcommon__Equipment_Transaction__c> clcommon__Collateral_Transactions__r;
    global List<clcommon__Equipment_Values_Adjustment__c> clcommon__Equipment_Values_Adjustments__r;
    global List<clcommon__Financial_Statement__c> clcommon__Financial_Statements__r;
    global List<clcommon__Sample_Contract__c> clcommon__Sample_Contracts__r;
    global List<clcommon__Sell_Equipment__c> clcommon__Sell_Equipments__r;
    global List<clcommon__Statement_Analysis__c> clcommon__Statement_Analysis__r;
    global List<clcommon__Template_Detail__c> clcommon__Template_Details__r;
    global List<clcommon__Variable_Rent_Rate__c> clcommon__Variable_Rent_Rate__r;
    global List<cllease__Asset_workbench__c> cllease__Asset_Workbenchs__r;
    global List<cllease__Charge__c> cllease__Income_Transactions__r;
    global List<cllease__Contract_Equipment__c> cllease__Warehouse_Equipment__r;
    global List<cllease__Debt_Detail__c> cllease__Debt_Details__r;
    global List<cllease__Expense_Fee_Transaction__c> cllease__Expense_Transactions__r;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Accounting_Entries__r;
    global List<genesis__Application_Collateral__c> genesis__Application_Collaterals__r;
    global List<genesis__Quick_Quote_Equipment__c> genesis__Quick_Quote_Collaterals__r;
    global List<genesis__Rent_Roll__c> genesis__Rent_Rolls__r;
    global List<genesis__Tenant__c> genesis__Tenant_Rent_Roll__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Collateral__c () 
    {
    }
}