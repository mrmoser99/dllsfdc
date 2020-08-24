// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Termination_Quote__c {
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
    global Boolean cllease__All_Equipment__c;
    global Decimal cllease__Billed_Paid_Not_Due__c;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Decimal cllease__Early_Termination_Fee__c;
    global Date cllease__Effective_Date__c;
    global Decimal cllease__Equipment_Return_Fee__c;
    global Decimal cllease__Estimated_Taxes_On_Future_Rent__c;
    global Decimal cllease__Future_Rent__c;
    global Decimal cllease__GPS_Removal_Fee__c;
    global String cllease__LeaseApplicationNumber__c;
    global Boolean cllease__Purchase_Equipment__c;
    global Decimal cllease__Purchase_Option__c;
    global Decimal cllease__Quote_Amount__c;
    global String cllease__Quote_Reason__c;
    global String cllease__Quote_Status__c;
    global Double cllease__Remaining_Term__c;
    global Decimal cllease__Title_Transfer_Fee__c;
    global Decimal cllease__Total_Payable__c;
    global Decimal cllease__Total_Quote_Amount__c;
    global Decimal cllease__Unbilled_Due__c;
    global Decimal cllease__Unpaid_Charges_Due__c;
    global Decimal cllease__Unpaid_Rent_Due__c;
    global Decimal cllease__Unpaid_Tax_Amount__c;
    global Date cllease__Valid_Till_Date__c;
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
    global List<cllease__Lease_account_Due_Details__c> cllease__Bills__r;
    global List<cllease__Termination_Quote_Transaction__c> cllease__Termination_Quote_Transactions__r;
    global List<cllease__Termination_Quote__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Termination_Quote__c () 
    {
    }
}