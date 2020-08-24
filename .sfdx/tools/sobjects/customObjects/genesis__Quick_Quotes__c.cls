// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Quick_Quotes__c {
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
    global Account genesis__Account__r;
    global Id genesis__Account__c;
    global Decimal genesis__Additional_cash_required__c;
    /* Address Line 1
    */
    global String genesis__Address_Line_1__c;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global String genesis__Business_Name__c;
    global Decimal genesis__Cap_Reduction__c;
    global Decimal genesis__Cash_Collected_By_Dealer__c;
    global String genesis__City__c;
    global Decimal genesis__Collateral_Value__c;
    global genesis__Company__c genesis__Company__r;
    global Id genesis__Company__c;
    /* Name of the contact.
    */
    global Contact genesis__Contact__r;
    /* Name of the contact.
    */
    global Id genesis__Contact__c;
    /* Country
    */
    global String genesis__Country__c;
    global String genesis__Customer_Cash_Used_For__c;
    global Decimal genesis__Customer_cash_available__c;
    global Decimal genesis__Documentation_charges__c;
    global Decimal genesis__Down_Payment__c;
    global Decimal genesis__Estimated_Selling_Price__c;
    global Date genesis__Expected_Start_Date__c;
    global Decimal genesis__Fees_Amount__c;
    /* Financed Amount by lessor.
    */
    global Decimal genesis__Financed_Amount__c;
    global String genesis__First_Name__c;
    global String genesis__Last_Name__c;
    global genesis__Loan_Product__c genesis__Lending_Product__r;
    global Id genesis__Lending_Product__c;
    /* Minimum Cash Required from customer.
    */
    global Decimal genesis__Minimum_cash_Required__c;
    global Double genesis__Next_Step__c;
    global Double genesis__No_Of_Payments_Required_Upfront__c;
    global Double genesis__Number_of_Pieces_of_Equipment__c;
    global Decimal genesis__Other_Financed_Fees__c;
    global Decimal genesis__Payment_Amount__c;
    global String genesis__Payment_Frequency__c;
    global String genesis__Postal_Code__c;
    global String genesis__Pricing_Method__c;
    /* Type of quote.
    */
    global String genesis__Product_Type__c;
    global String genesis__Selected_Pricing_Option_Id__c;
    /* SSN format should be  999-99-9999
    */
    global String genesis__Social_Security_Number__c;
    /* The type of source from where the Quick Quote is generated.
    */
    global String genesis__Source__c;
    global String genesis__State__c;
    global String genesis__Status__c;
    global Decimal genesis__Tax_Amount__c;
    global String genesis__Terms_Selected__c;
    global Decimal genesis__Total_Cash_Due_from_Customer__c;
    global Decimal genesis__Total_Customer_Cash_Required__c;
    /* Total Amount Payable To Dealer by lessor.
    */
    global Decimal genesis__Total_Dealer_Payable__c;
    /* Total Dealer Price.
    */
    global Decimal genesis__Total_Dealer_Price__c;
    global Decimal genesis__Total_Upfront_Payments__c;
    /* This field will be set to true once the pricing has been generated, but any subsequent update on quick quote will set this to false and will force user to generate the pricing again.
    */
    global Boolean genesis__Valid_Pricing_Flag__c;
    global Decimal genesis__Warranty_Amount__c;
    global String ATS_Reference_Number__c;
    global Decimal Approved_Credit_Amount__c;
    global Address__c Billing_Address__r;
    global Id Billing_Address__c;
    global String Business_Contacts__c;
    global clcommon__CL_Product__c CL_Product__r;
    global Id CL_Product__c;
    global String County__c;
    global Date Credit_Approval_Date__c;
    global Date Credit_Approval_Expiration_Date__c;
    global String Credit_Approval__c;
    global String Days_Convention__c;
    global String Dealer_Name__c;
    global Account Dealer__r;
    global Id Dealer__c;
    global String Email_Address__c;
    global String Equipment_Description__c;
    global String Estimated_Financed_Amount__c;
    global Decimal Estimated_Monthly_Payment__c;
    global clcommon__Legal_Entity__c Legal_Entity__r;
    global Id Legal_Entity__c;
    global String Primary_Phone_number__c;
    global String Sales_Division__c;
    global String Status_Text__c;
    global Datetime Time_Trigger_05__c;
    global String Validation_Status__c;
    global Datetime Validation_Time_Stamp__c;
    global String View_Record__c;
    global String Est_Financed_Amt__c;
    /* Indicates if credit was applied for with an account.   The portal may include account number going forward.  CLS doesn't use account number in quick quotes.
    */
    global Boolean With_Account__c;
    global Decimal Oracle_Trade_Up_Quote_Amount__c;
    global String Oracle_Trade_up_Lease_Number__c;
    global String Oracle_Trade_up_Quote_Number__c;
    global Date Oracle_Trade_up_Quote_Expiration_Date__c;
    global String Quick_Quote_Number__c;
    global clcommon__Company__c genesis__CL_Company__r;
    global Id genesis__CL_Company__c;
    global clcommon__CL_Product__c genesis__CL_Product__r;
    global Id genesis__CL_Product__c;
    global Date Date_Created__c;
    global String Trade_Up_From__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CAMS_Check__c> CAMS_Checks__r;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<ICS_Application__c> ICSResponses__r;
    global List<ICS_Log__c> ICS_Logs__r;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<genesis__Applications__c> genesis__Applications_Quick_Quote__r;
    global List<genesis__Quick_Quote_Equipment__c> genesis__Quick_Quote_Equipments__r;
    global List<genesis__Quick_Quote_Pricing_Options__c> genesis__Pricing_Options__r;
    global List<genesis__Quick_Quotes__Feed> Feeds;
    global List<genesis__Quick_Quotes__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Quick_Quotes__c () 
    {
    }
}