// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Commission_Plan__c {
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
    /* Percentage Rate for Commission
    */
    global Double cllease__Buy_Rate__c;
    /* Method of how commission will be calculated.
    */
    global String cllease__Calculation_Method__c;
    /* Method how commission will be disbursed to broker.
    */
    global String cllease__Commission_Disbursement_Method__c;
    /* If the commission plan enabled.
    */
    global Boolean cllease__Enabled__c;
    /* If the calculation method is percentage of lease amount or spread, then this will be used while calculating the commission amount
    */
    global Double cllease__Factor__c;
    /* Flat Amount which gives as commission for lease
    */
    global Decimal cllease__Flat_Amount__c;
    /* The maximum percentage of commission can be given
    */
    global Double cllease__Maximum_Commission_Percentage__c;
    /* Description of Commission Plan
    */
    global String cllease__Plan_Description__c;
    /* Percentage of commission which will be disbursed to broker upfront.
    */
    global Double cllease__Upfront_Percentage__c;
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
    global List<cllease__Broker__c> cllease__Brokers__r;
    global List<cllease__Commission_Plan__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Commission_Plan__c () 
    {
    }
}