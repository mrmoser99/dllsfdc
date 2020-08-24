// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Equipment_Transaction__c {
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
    global Decimal clcommon__Adjusted_Book_Value__c;
    global Decimal clcommon__Adjusted_Net_Book_Value__c;
    global Decimal clcommon__Adjusted_Salvage_Value__c;
    /* This field represents the Bill of Equipment Sale as part of which this transaction is created.
    */
    global clcommon__Due_Details__c clcommon__Bill__r;
    /* This field represents the Bill of Equipment Sale as part of which this transaction is created.
    */
    global Id clcommon__Bill__c;
    global clcommon__Book_Value_Adjustment__c clcommon__Book_Value_Adjustment__r;
    global Id clcommon__Book_Value_Adjustment__c;
    global Decimal clcommon__Book_Value__c;
    global Decimal clcommon__Collateral_Book_Value__c;
    global Decimal clcommon__Collateral_Purchase_Price__c;
    global Decimal clcommon__Collateral_Salvage_Value__c;
    global clcommon__Collateral__c clcommon__Collateral__r;
    global Id clcommon__Collateral__c;
    /* This field represents cost incurred during Selling of Equipment
    */
    global Decimal clcommon__Cost_of_Sale__c;
    global clcommon__Dealer_Funding_Detail__c clcommon__Dealer_Funding_Detail__r;
    global Id clcommon__Dealer_Funding_Detail__c;
    global Decimal clcommon__Depreciation_Basis_Amount__c;
    /* This field represents the Sale Quote as part of which this transaction is created.
    */
    global clcommon__Equipment_Sale_Quote__c clcommon__Equipment_Sale_Quote__r;
    /* This field represents the Sale Quote as part of which this transaction is created.
    */
    global Id clcommon__Equipment_Sale_Quote__c;
    global clcommon__Equipment_Values_Adjustment__c clcommon__Equipment_Values_Adjustment__r;
    global Id clcommon__Equipment_Values_Adjustment__c;
    global clcommon__Equipment__c clcommon__Equipment__r;
    global Id clcommon__Equipment__c;
    global Boolean clcommon__GL_Posted__c;
    global Date clcommon__GL_Process_Date__c;
    global String clcommon__GL_Processing_Message__c;
    global Boolean clcommon__GL_Transaction__c;
    global Decimal clcommon__Loss__c;
    /* This field represents the Payment Transaction of Equipment Sale as part of which this transaction is created.
    */
    global clcommon__Payment_Transaction__c clcommon__Payment_Transaction__r;
    /* This field represents the Payment Transaction of Equipment Sale as part of which this transaction is created.
    */
    global Id clcommon__Payment_Transaction__c;
    global Decimal clcommon__Profit_Loss__c;
    global Decimal clcommon__Profit_Loss_del__c;
    global Decimal clcommon__Profit__c;
    global Decimal clcommon__Purchase_Price__c;
    global Decimal clcommon__Salvage_Value__c;
    global clcommon__Sell_Equipment__c clcommon__Sell_Equipment__r;
    global Id clcommon__Sell_Equipment__c;
    /* This field represents the tax component
    */
    global Decimal clcommon__Tax_Amount__c;
    global Decimal clcommon__Transaction_Amount__c;
    global Date clcommon__Transaction_Date__c;
    global String clcommon__Transaction_Type__c;
    global Boolean cllease__GL_Posted__c;
    global Date cllease__GL_Process_Date__c;
    global String cllease__GL_Processing_Message__c;
    global Boolean cllease__GL_Transaction__c;
    /* Details related to the Equipment Transaction
    */
    global String clcommon__Equipment_Transaction_Details__c;
    /* This field represents the VAT Code used for the particular transaction. The VAT Rate is derived based on the VAT Rate Setup.
    */
    global clcommon__VAT_Rate_Setup__c clcommon__VAT_Code__r;
    /* This field represents the VAT Code used for the particular transaction. The VAT Rate is derived based on the VAT Rate Setup.
    */
    global Id clcommon__VAT_Code__c;
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
    global List<clcommon__Dealer_Funding_Detail__c> clcommon__Dealer_Funding_Details__r;
    global List<clcommon__Equipment_Transaction__Share> Shares;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Equipment_Txn_Entries__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Equipment_Transaction__c () 
    {
    }
}