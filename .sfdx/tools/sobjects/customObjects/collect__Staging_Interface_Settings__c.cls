// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class collect__Staging_Interface_Settings__c {
    global Id Id;
    global Boolean IsDeleted;
    global String Name;
    global SObject SetupOwner;
    global Id SetupOwnerId;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    /* If checked, CL Collections will not process the staging interface data being received from this Source System.
    */
    global Boolean collect__Disable_Collection_Processing__c;
    /* Flag to indicate if the Name of the Source System should be included in the External ID maintained in CL Collections along with the Source ID.
    */
    global Boolean collect__Include_Name_As_External_ID__c;
    /* Flag to indicate if the Product Type of the Source System should be included in the External ID maintained in CL Collections along with the Source ID.
    */
    global Boolean collect__Include_Product_Type_As_External_ID__c;
    /* Flag to indicate if the Timestamp should be included in the External ID maintained in CL Collections along with the Source ID.
    */
    global Boolean collect__Include_Timestamp_As_External_ID__c;
    /* Indicates the product type of the data being pushing into CL Collections. For Example Loan, Lease, Mortgage, etc.
    */
    global String collect__Product_Type__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
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

    global collect__Staging_Interface_Settings__c () 
    {
    }
}