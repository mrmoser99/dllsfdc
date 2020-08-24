// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Payment_Schedule__c {
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
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Boolean cllease__Contractual_Payments_Flag__c;
    global Double cllease__Due_Day__c;
    /* This will be checked if the payment is created because the contract has moved to evergreen term.
    */
    global Boolean cllease__Evergreen_Flag__c;
    global String cllease__Frequency__c;
    global String cllease__LeaseApplicationNumber__c;
    global Double cllease__Number_Of_Payments__c;
    global Decimal cllease__Payment_Amount__c;
    global Date cllease__Payment_Date__c;
    global Boolean cllease__Primary_Flag__c;
    global Double cllease__Sequence__c;
    global Decimal cllease__Total_Payment__c;
    global Decimal cllease__VAT__c;
    /* Internal field used to keep track of the original payment date
    */
    global Date cllease__Original_Payment_Date__c;
    /* Tax Exemption flag. Borrowed from the Contract VAT Hierarchy. Not to be used from the app
    */
    global Boolean cllease__Tax_Exempt__c;
    /* A flag to indicate if the Payment schedule has inherited an overridden VAT Rate
    */
    global Boolean cllease__Tax_Override__c;
    /* VAT Rate lookup for VAT Stamping and reporting
    */
    global clcommon__VAT_Rate_Setup__c cllease__VAT_Code__r;
    /* VAT Rate lookup for VAT Stamping and reporting
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
    global List<cllease__Payment_Schedule__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Payment_Schedule__c () 
    {
    }
}