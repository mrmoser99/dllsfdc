// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Expense_Fees__c {
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
    global Account cllease__Account__r;
    global Id cllease__Account__c;
    global Decimal cllease__Amount__c;
    global String cllease__Apply_Pre_Bill_Days__c;
    /* If fee is of type Evergreen, this field specifies the fee amount for evergreen term.
    */
    global Decimal cllease__Evergreen_Amount__c;
    /* Fee Name
    */
    global clcommon__Fee_Definition__c cllease__Fee_Definition__r;
    /* Fee Name
    */
    global Id cllease__Fee_Definition__c;
    /* Please use Fee Definition field that references Fee Definition from CL Common.
    */
    global cllease__Fee__c cllease__Fee__r;
    /* Please use Fee Definition field that references Fee Definition from CL Common.
    */
    global Id cllease__Fee__c;
    global String cllease__Frequency__c;
    global Double cllease__Number_of_Periods__c;
    global String cllease__Passthrough_Event__c;
    global String cllease__Payment_Method__c;
    global Double cllease__Referral_Points__c;
    /* Select this check box to exempt tax on the fee.
    */
    global Boolean cllease__Tax_Exempt__c;
    /* This tax rate overrides the tax setup defined at the company level.
    */
    global Double cllease__Tax_Rate__c;
    global cllease__Transaction_Sub_Type__c cllease__Transaction_Sub_Type__r;
    global Id cllease__Transaction_Sub_Type__c;
    /* Describes the method for collecting the fee on the contract
    */
    global String cllease__Type__c;
    global String cllease__Withhold_Basis__c;
    global Double cllease__Withhold_Value__c;
    global Boolean cllease__disabled__c;
    global Boolean cllease__Tax_Override__c;
    global clcommon__VAT_Rate_Setup__c cllease__VAT_Rate__r;
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
    global List<cllease__Charge__c> cllease__Charges__r;
    global List<cllease__Contract_Fee_Payment__c> cllease__Contract_Fee_Payments__r;
    global List<cllease__Contract_Fees__c> cllease__Fee_Schedule__r;
    global List<cllease__Fee_Stream__c> cllease__Fee_Streams__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Expense_Fees__c () 
    {
    }
}