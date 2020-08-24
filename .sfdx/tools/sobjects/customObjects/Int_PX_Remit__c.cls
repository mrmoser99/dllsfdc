// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Int_PX_Remit__c {
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
    global String Account_Num__c;
    global Boolean Committed__c;
    global Date Date__c;
    global Decimal Invoice_Amount_Paid__c;
    global String Invoice_Number__c;
    global String Line_Data__c;
    global Double Record_Number__c;
    /* This field track Status about Creating Payments processing .
    */
    global String Remark__c;
    global String Trans_Source__c;
    global String Trans_UID__c;
    global Decimal Transaction_Amount__c;
    global String Transaction_Type__c;
    global Invoice__c Invoice__r;
    global Id Invoice__c;
    global Decimal Invoice_Amount__c;
    global String Check_Number__c;
    global String Notes__c;
    global Boolean Void_in_PNC__c;
    global clcommon__Consolidated_Invoice__c Consolidated_Invoice__r;
    global Id Consolidated_Invoice__c;
    global String Old_Invoice_Number__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Int_PX_Remit__History> Histories;
    global List<Int_PX_Remit__Share> Shares;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<PNC_Recon_Detail__c> PNC_Recon_Details__r;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<clcommon__Cash_Receipt__c> Cash_Receipts__r;
    global List<cllease__Lease_Payment_Transaction__c> Payment_Transactions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global Int_PX_Remit__c () 
    {
    }
}