// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Payment_Stream__c {
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
    global Boolean cllease__Active__c;
    global Decimal cllease__Beginning_Receivable__c;
    global Boolean cllease__Billed__c;
    global String cllease__Comment__c;
    global cllease__Contract_Equipment__c cllease__Contract_Equipment__r;
    global Id cllease__Contract_Equipment__c;
    global cllease__Contract_Fees__c cllease__Contract_Fee__r;
    global Id cllease__Contract_Fee__c;
    global Date cllease__Date_Billed__c;
    global Date cllease__Date__c;
    global Decimal cllease__Ending_Receivable__c;
    global String cllease__Frequency__c;
    global Date cllease__Payment_Date__c;
    global String cllease__Payment_Type__c;
    global Date cllease__Period_End_Date__c;
    global Date cllease__Period_Start_Date__c;
    global Decimal cllease__Rental_Amount__c;
    global Double cllease__Schedule_Sequence__c;
    global Decimal cllease__Tax__c;
    global cllease__Transaction_Sub_Type__c cllease__Transaction_Sub_Type__r;
    global Id cllease__Transaction_Sub_Type__c;
    global Decimal Old_Amount__c;
    global Boolean Data_Fix_Done__c;
    global Boolean Estimated_Property_Tax_Unpaid_Flag__c;
    global Boolean Service_Fee_Unpaid_Flag__c;
    /* Field to indicate if the lease payable is tax exempt
    */
    global Boolean cllease__Tax_Exempt__c;
    /* Field to indicate if the lease payable has a tax override
    */
    global Boolean cllease__Tax_Override__c;
    /* The lookup for the VAT Code used in the payable
    */
    global clcommon__VAT_Rate_Setup__c cllease__VAT_Code__r;
    /* The lookup for the VAT Code used in the payable
    */
    global Id cllease__VAT_Code__c;
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
    global List<cllease__Lease_Account__c> LS_Contracts__r;
    global List<cllease__Lease_Payment_Transaction__c> cllease__Payment_Transactions__r;
    global List<cllease__Lease_account_Due_Details__c> cllease__Bills__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Payment_Stream__c () 
    {
    }
}