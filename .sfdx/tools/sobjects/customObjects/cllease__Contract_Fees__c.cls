// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Contract_Fees__c {
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
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Decimal cllease__Amount__c;
    global Boolean cllease__Capitalize__c;
    global cllease__Contract_Equipment__c cllease__Contract_Equipment__r;
    global Id cllease__Contract_Equipment__c;
    global Double cllease__Due_Day__c;
    global cllease__Expense_Fees__c cllease__Expense_Fee__r;
    global Id cllease__Expense_Fee__c;
    global clcommon__Fee_Definition__c cllease__Fee_Definition__r;
    global Id cllease__Fee_Definition__c;
    global String cllease__Fee_Type__c;
    /* Please use Fee Definition field that references Fee Definition from CL Common.
    */
    global cllease__Fee__c cllease__Fee__r;
    /* Please use Fee Definition field that references Fee Definition from CL Common.
    */
    global Id cllease__Fee__c;
    global String cllease__Frequency__c;
    global String cllease__LeaseApplicationNumber__c;
    global Double cllease__Number_of_Periods__c;
    global Decimal cllease__Total_Payment_Amount__c;
    global Decimal cllease__VAT__c;
    global Boolean cllease__net_termination_quote__c;
    global Boolean cllease__one_time__c;
    global Date cllease__start_date__c;
    global String Contract_Fee_Name__c;
    global String Equipment_External_Id__c;
    global String External_Id__c;
    global Date cllease__Disbursement_Date__c;
    global String cllease__Equipment_External_Id__c;
    /* This is the contract fee id in the original contract. We need this to remap the fee in the temporary contract to the original fee in the restructured contract once the it is approved. (Internal)
    */
    global cllease__Contract_Fees__c cllease__Original_Fee_Id__r;
    /* This is the contract fee id in the original contract. We need this to remap the fee in the temporary contract to the original fee in the restructured contract once the it is approved. (Internal)
    */
    global Id cllease__Original_Fee_Id__c;
    /* Internal field.
    */
    global Boolean cllease__Primary_Flag__c;
    /* If Fee is amortized, the amortization will start from this date.
    */
    global Date cllease__Amort_Start_Date__c;
    /* The amortization month from where the Fee Amortization will start.
    */
    global String cllease__Amort_Start_Month__c;
    /* The amortization year from where the Fee Amortization will start.
    */
    global Double cllease__Amort_Start_Year__c;
    /* If Fee is amortized, the amortization will happen for these many periods.
    */
    global Double cllease__Amort_Term__c;
    global Boolean cllease__Disabled__c;
    /* In order to use the universal search on this object we need to hold the equipment name in this field
    */
    global String cllease__Equipment_Name__c;
    global Boolean cllease__Modified__c;
    global Date cllease__Next_Evergreen_Due_Date__c;
    /* Override VAT flag
    */
    global Boolean cllease__Override_VAT__c;
    /* Tax Exemption flag for the individual fee
    */
    global Boolean cllease__Tax_Exempt__c;
    /* VAT Code look up from the VAT Table
    */
    global clcommon__VAT_Rate_Setup__c cllease__VAT_Rate__r;
    /* VAT Code look up from the VAT Table
    */
    global Id cllease__VAT_Rate__c;
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
    global List<clcommon__Disbursement_Transaction__c> cllease__Disbursement_Transactions__r;
    global List<cllease__Charge__c> cllease__Charges__r;
    global List<cllease__Contract_Fees__c> cllease__Fee_Schedule1__r;
    global List<cllease__Expense_Fee_Transaction__c> cllease__Expense_Fee_Txns__r;
    global List<cllease__Fee_Stream__c> cllease__Fee_Streams__r;
    global List<cllease__Payment_Stream__c> cllease__Payment_Streams__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Contract_Fees__c () 
    {
    }
}