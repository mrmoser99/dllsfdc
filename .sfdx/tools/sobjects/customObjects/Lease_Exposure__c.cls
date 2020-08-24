// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Lease_Exposure__c {
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
    global Date LastActivityDate;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global Decimal Asset_Sale__c;
    global Decimal Estimated_Property_Tax__c;
    global Decimal Evergreen_Billed_Not_Paid__c;
    global Decimal Evergreen_Billed__c;
    global Decimal Exposure__c;
    global Decimal Finance_Fees__c;
    global String Formula__c;
    global Decimal Insurance_Fees__c;
    global cllease__Lease_Account__c LS_Contract__r;
    global Id LS_Contract__c;
    global Decimal Late_Fees__c;
    global Decimal NSF_Fees__c;
    global Decimal Origination_Fees__c;
    global Decimal Outstanding_Rent__c;
    global Decimal Rent_Accrual__c;
    global Decimal Rent_Billed_Not_Paid__c;
    global Decimal Rent_Billed__c;
    /* Total of all rent
    */
    global Decimal Rent__c;
    global Decimal Residual_Amount__c;
    global Decimal Sales_Tax_on_Property_Tax__c;
    global Decimal Service_Fees__c;
    global Decimal Termination_Quote_Fees__c;
    global Decimal Total_Amount_Paid__c;
    global Decimal Total_Other__c;
    global Decimal Unearned_Income__c;
    global Decimal Unearned_Residual__c;
    global Decimal Net_Investment__c;
    global Decimal Tax_on_Evergreen_Billed_Not_Paid__c;
    global Decimal Tax_on_Rent_Billed_Not_Paid__c;
    global Decimal Est_Property_Tax__c;
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Event> Events;
    global List<Lease_Exposure__History> Histories;
    global List<Lease_Exposure__Share> Shares;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OpenActivity> OpenActivities;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global Lease_Exposure__c () 
    {
    }
}