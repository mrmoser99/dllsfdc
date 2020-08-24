// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Int_OLMN_AP__c {
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
    global String ACCTS_PAY_CODE_COMBINATION__c;
    global String Accounting_Date__c;
    global String Application_Branch__c;
    global String Approval_Company_Code__c;
    global String Check_Stock__c;
    global Boolean Committed__c;
    global String Company__c;
    global String Contract_Number__c;
    global String DIST_CODE_COMBINATION__c;
    global String Division__c;
    global Decimal Expense_Amount__c;
    global String Funding_Method__c;
    global String Funding_Source__c;
    global String Funding_Type__c;
    global String GL_Date__c;
    global String General_Ledger_Account_String__c;
    global String INVOICE_DESCRIPTION__c;
    global Decimal Invoice_Amount__c;
    global String Invoice_Currency_Code__c;
    global String Invoice_Date__c;
    global String Invoice_Number__c;
    global String Invoice_Type_Lookup_Code__c;
    global Decimal LINE_AMOUNT__c;
    global String LINE_DESCRIPTION__c;
    global String LINE_TYPE_LOOKUP_CODE__c;
    global Double Line_Number__c;
    global String PAY_GROUP_LOOKUP_CODE__c;
    global Date PO_Date__c;
    global Double PO_Number__c;
    global String Payment_Date__c;
    global String Payment_Message__c;
    global String Payment_Method__c;
    global String Payment_Reference__c;
    global String Related_record_id__c;
    global String Session_Reference__c;
    global String Single_Payment_Flag__c;
    global String Term_Name__c;
    global String Terms_Date__c;
    global String Vendor_Code__c;
    global Double X1099_Tax_Amount__c;
    global String X1099_Tax_Code__c;
    global Datetime Delay_Notice_Date_Time__c;
    /* Received a payment confirmation record from ap via the olm interface
    */
    global Boolean AP_Confirmed__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Int_OLMN_AP__History> Histories;
    global List<Int_OLMN_AP__Share> Shares;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global Int_OLMN_AP__c () 
    {
    }
}