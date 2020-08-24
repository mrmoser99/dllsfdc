// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Termination_Quote_Header__c {
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
    global Boolean cllease__Contract_Status_Check__c;
    global Boolean cllease__Early_Termination__c;
    global Date cllease__Effective_From__c;
    global Date cllease__Effective_To__c;
    global Boolean cllease__Full_Termination__c;
    global Decimal cllease__Quote_Amount__c;
    global String cllease__Quote_Reason__c;
    global String cllease__Quote_Type__c;
    global String cllease__Status__c;
    global Boolean cllease__Termination_With_Purchase__c;
    global Decimal Equipment_Price__c;
    global Decimal Less_Discount__c;
    global Decimal Outstanding_Charges__c;
    global Decimal Remaining_Payments__c;
    /* This checkbox helps in finding termination on Equipment level or Equipment Details level.
    */
    global Boolean cllease__is_Equipment_Termination__c;
    /* Part of 'Sale Amount' from the Asset Sale to a Third Party to be used as a Rebate against the Termination Bill / Quote Amount.
    */
    global Decimal cllease__Rebate_Amount__c;
    /* Percentage of 'Sale Amount' from the Asset Sale to a Third Party to be used as a Rebate against the Termination Bill / Quote Amount.
    */
    global Double cllease__Rebate_Percentage__c;
    global Date cllease__Requested_Termination_Date__c;
    global Date cllease__Termination_Date__c;
    /* This field represents the total Sale Amount from the Third Party Asset Sale for the selected equipment.
    */
    global Decimal cllease__Third_Party_Sale_Amount__c;
    /* This flag will be selected when performing a 'Third Party Sale' i.e. Equipment getting sold to a Third Party.
    */
    global Boolean cllease__Third_Party_Sale__c;
    global Double Ending_Net_Investment__c;
    global Decimal Billed_not_Paid_Charges__c;
    global Decimal QUOTE_DISCOUNT__c;
    global Decimal QUOTE_ESTIMATED_PROPERTY_TAX__c;
    global Decimal QUOTE_ESTIMATED_SALES_TAX__c;
    global Decimal QUOTE_FEE__c;
    global Decimal QUOTE_PURCHASE_AMOUNT__c;
    global Decimal QUOTE_ROLLOVER_INCENTIVE__c;
    global Decimal QUOTE_SERVICE_AND_MAINTENANCE__c;
    global Decimal QUOTE_UNBILLED_RECEIVABLE__c;
    /* No Accrual - System will not accelerate the accrual
Partial Accrual - System will partially accrue based on the rate factor of terminated equipment
Full Accrual - System will accrue entire income and will not rate factor based on terminated equipment
    */
    global String cllease__Accelerated_Accrual_Option__c;
    /* To cancel a contract this flag needs to be checked. System will default termination dates to contract start dates
    */
    global Boolean cllease__Cancel_Contract__c;
    /* Based on this rate system will compute PV of feature rent. In order to compute this we need to add termination config line of Quote Type 'PV OF FUTURE RENT'
    */
    global Double cllease__Discount_Rate__c;
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
    global List<Termination_Detail__c> Termination_Details__r;
    global List<Termination_Equipment_Quote__c> Termination_Equipment_Quotes__r;
    global List<TopicAssignment> TopicAssignments;
    global List<cllease__Asset_Return__c> cllease__Asset_Returns__r;
    global List<cllease__Charge__c> cllease__Charges__r;
    global List<cllease__Lease_account_Due_Details__c> cllease__Bills__r;
    global List<cllease__Other_Transaction__c> Other_Transactions__r;
    global List<cllease__Other_Transaction__c> cllease__Other_Transactions__r;
    global List<cllease__Termination_Quote_Equipment__c> cllease__Termination_Quote_Equipments__r;
    global List<cllease__Termination_Quote_Line__c> cllease__Termination_Quote_Lines__r;
    global List<genesis__Applications__c> Applications__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Termination_Quote_Header__c () 
    {
    }
}