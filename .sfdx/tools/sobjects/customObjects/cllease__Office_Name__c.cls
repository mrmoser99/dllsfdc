// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Office_Name__c {
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
    global String cllease__Branch_External_Id__c;
    global cllease__Bank__c cllease__Branch_s_Bank__r;
    global Id cllease__Branch_s_Bank__c;
    global cllease__Calendar__c cllease__Calendar__r;
    global Id cllease__Calendar__c;
    global Date cllease__Current_System_Date__c;
    global cllease__Payment_Mode__c cllease__Default_Payment_Mode__r;
    global Id cllease__Default_Payment_Mode__c;
    global Boolean cllease__Is_Branch__c;
    global Boolean cllease__Lease_Schedule_tied_to_Meeting_Schedule__c;
    global Double cllease__Mark_Suspended_After_Days__c;
    global cllease__Branch_Location__c cllease__Office_Location__r;
    global Id cllease__Office_Location__c;
    /* Company ID
    */
    global String cllease__Office_Name_ID__c;
    /* Office Short Name
    */
    global String cllease__Office_Short_Name__c;
    global cllease__Office_Type__c cllease__Office_Type__r;
    global Id cllease__Office_Type__c;
    /* Parent Office
    */
    global cllease__Office_Name__c cllease__Parent_Office__r;
    /* Parent Office
    */
    global Id cllease__Parent_Office__c;
    /* This field is used to specify the number of days of prior period income to be reversed on contract getting set as Non Performing Asset.
    */
    global Double cllease__Prior_Period_Income_Reversal_Days__c;
    /* This field is used to indicate the number of days past due when a contract belonging to this company becomes NPA.
    */
    global Double cllease__Set_Current_to_NPA_After_Days__c;
    /* This field is used to indicate the number of days past due when a contract belonging to this company becomes Current, if already NPA.
    */
    global Double cllease__Set_NPA_to_Current_After_Days__c;
    global String cllease__State__c;
    global String cllease__Tax_Basis__c;
    global String cllease__Tax_Calculation_Source__c;
    global String cllease__Tax_Method__c;
    global String cllease__Transfer_Bill_Transactions__c;
    global String cllease__Transfer_Charge_Transactions__c;
    global Double cllease__Vat_Rate__c;
    global Double cllease__Write_Off_Suggestion_Days__c;
    global String Dll_Seg1_Company__c;
    global String Dll_Seg2_Business_Unit__c;
    global String Dll_Seg3_Department__c;
    global String Dll_Seg6__c;
    global String Dll_Seg7__c;
    /* Value from this field will be consumed during calculation and will rounded to given value.
    */
    global Double cllease__Currency_Precision__c;
    global String cllease__Equipment_To_Equipment_Detail_Mapping__c;
    /* If checked, system will keep generating the Equipment Charges (Disbursement / Expense Transactions) even when the Equipment gets Leased.
    */
    global Boolean cllease__Create_Equipment_Charge_When_Leased__c;
    global Boolean cllease__Manual_NPA_Income_Reversal__c;
    /* Indicates whether contracts in this org can be restructured to a date in the past or not.
    */
    global Boolean cllease__Restructure_In_The_Past__c;
    global Boolean cllease__Use_Equipment_Details__c;
    /* VAT Code lookup
    */
    global clcommon__VAT_Rate_Setup__c cllease__VAT_Code__r;
    /* VAT Code lookup
    */
    global Id cllease__VAT_Code__c;
    /* The field is the write-off threshold for payments against charges and bills
    */
    global Decimal cllease__Writeoff_Threshold__c;
    global List<Account> cllease__Accounts__r;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<Contact> cllease__Contacts__r;
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
    global List<cllease__Accounting_Template_Header__c> cllease__Accounting_Rule_Headers1__r;
    global List<cllease__Accounting_Template_Header__c> cllease__Accounting_Rule_Headers__r;
    global List<cllease__Batch_Process_Log__c> cllease__Batch_Process_Log__r;
    global List<cllease__Branch_Lease_Product__c> cllease__Branch_s_Lease_Products__r;
    global List<cllease__Day_Process__c> cllease__Day_Processes__r;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Transaction_Detail__r;
    global List<cllease__Lease_Account__c> cllease__Lease_Accounts__r;
    global List<cllease__Month_Process__c> cllease__Month_Process__r;
    global List<cllease__Office_Name__History> Histories;
    global List<cllease__Office_Name__Share> Shares;
    global List<cllease__Office_Name__c> cllease__Offices__r;
    global List<cllease__Search__c> cllease__Search__r;
    global List<cllease__Tax_API_Status__c> cllease__Tax_API_Status__r;
    global List<cllease__User_Branch_Info__c> cllease__User_Branch_Info__r;
    global List<cllease__Yield_Configuration__c> cllease__Yield_Configurations__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Office_Name__c () 
    {
    }
}