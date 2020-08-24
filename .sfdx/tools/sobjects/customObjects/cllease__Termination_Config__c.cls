// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Termination_Config__c {
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
    global Boolean cllease__Default__c;
    /* true for enable configuration for product, false for disable
    */
    global Boolean cllease__Enable__c;
    global cllease__Lease_Product__c cllease__Lease_Product__r;
    global Id cllease__Lease_Product__c;
    global String cllease__Quote_Reason__c;
    global String cllease__Quote_Type__c;
    /* Set this flag if it is a equipment purchase configuration.
    */
    global Boolean cllease__Termination_With_Purchase__c;
    global String External_Id__c;
    /* If checked, the Pre-bill days will be considered in computing the Effective Termination Date.
    */
    global Boolean cllease__Consider_Pre_Bill_Days__c;
    /* Select this flag when performing a 'Third Party Sale' i.e. Equipment getting sold to a Third Party.
    */
    global Boolean cllease__Third_Party_Sale__c;
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
    global List<cllease__Termination_Config_Fee__c> cllease__Termination_Config_Fees__r;
    global List<cllease__Termination_Config_Line__c> cllease__Termination_Config_Lines__r;
    global List<cllease__Termination_Config__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Termination_Config__c () 
    {
    }
}