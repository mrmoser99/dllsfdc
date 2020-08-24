// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Expense_Fee_Transaction__c {
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
    global Account cllease__Account__r;
    global Id cllease__Account__c;
    /* This field represents the Total Amount including Tax
    */
    global Decimal cllease__Amount__c;
    global cllease__Charge__c cllease__Charge__r;
    global Id cllease__Charge__c;
    /* This maps to contract equipment
    */
    global cllease__Contract_Equipment__c cllease__Contract_Equipment__r;
    /* This maps to contract equipment
    */
    global Id cllease__Contract_Equipment__c;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Decimal cllease__Dealer_Payable_Amount__c;
    global clcommon__Disbursement_Transaction__c cllease__Disbursement_Transaction__r;
    global Id cllease__Disbursement_Transaction__c;
    global Date cllease__Due_Date__c;
    global clcommon__Collateral__c cllease__Equipment_Id__r;
    global Id cllease__Equipment_Id__c;
    global clcommon__Fee_Definition__c cllease__Fee_Definition__r;
    global Id cllease__Fee_Definition__c;
    global String cllease__Fee_Name__c;
    global Date cllease__GL_Date__c;
    global Boolean cllease__GL_Posted_Flag__c;
    global Date cllease__GL_Process_Date__c;
    global String cllease__GL_Processing_Message__c;
    global Boolean cllease__GL_Transaction_Flag__c;
    global String cllease__Name__c;
    /* This field represents the Amount excluding Tax
    */
    global Decimal cllease__Net_Amount__c;
    /* This field represents the Tax Component
    */
    global Decimal cllease__Tax_Amount__c;
    global Date cllease__Transaction_Date__c;
    global cllease__Transaction_Sub_Type__c cllease__Transaction_Sub_Type__r;
    global Id cllease__Transaction_Sub_Type__c;
    global String cllease__Transaction_Type__c;
    global cllease__Contract_Fees__c cllease__Contract_Fee__r;
    global Id cllease__Contract_Fee__c;
    global Boolean cllease__Restructured__c;
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
    global List<cllease__Expense_Fee_Transaction__Share> Shares;
    global List<cllease__GL_Transaction_Detail__c> cllease__GL_Accounting_Entries__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Expense_Fee_Transaction__c () 
    {
    }
}