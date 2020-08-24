// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__VAT_Rate_Setup__c {
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
    global String clcommon__Description__c;
    global Double clcommon__Tax_Rate__c;
    global String clcommon__External_Id__c;
    /* The unique VAT Code specified per entity or object
    */
    global String clcommon__VAT_Code__c;
    /* The validity starting Date for the VAT Code
    */
    global Date clcommon__Valid_From__c;
    /* The Validity End Date for the given VAT Code
    */
    global Date clcommon__Valid_To__c;
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
    global List<clcommon__Equipment_Sale_Quote_Line__c> clcommon__Equipment_Sale_Quote_Lines__r;
    global List<clcommon__Equipment_Sale_Quote__c> clcommon__Equipment_Sale_Quotes__r;
    global List<clcommon__Equipment_Transaction__c> clcommon__Equipment_Transactions__r;
    global List<clcommon__Fee_Definition__c> clcommon__Fee_Definition__r;
    global List<clcommon__VAT_Rate_Setup__Share> Shares;
    global List<cllease__Charge__c> cllease__Charge_VAT_Code__r;
    global List<cllease__Contract_Equipment__c> cllease__Equipment_VAT_Code__r;
    global List<cllease__Contract_Fees__c> cllease__VAT_Rate__r;
    global List<cllease__Due_Detail_Lines__c> cllease__VAT_Due_Detail_Lines__r;
    global List<cllease__Expense_Fees__c> cllease__Contract_Fees__r;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Accounting_Entry_VAT_Code__r;
    global List<cllease__Lease_Account__c> cllease__Override_VAT_Rate__r;
    global List<cllease__Lease_account_Due_Details__c> cllease__VAT_Code_Bills__r;
    global List<cllease__Office_Name__c> cllease__VAT_Code__r;
    global List<cllease__Payment_Schedule__c> cllease__Payment_Schedule__r;
    global List<cllease__Payment_Stream__c> cllease__Payment_Streams_VAT_Code__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__VAT_Rate_Setup__c () 
    {
    }
}