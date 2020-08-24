// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Quick_Quote_Option__c {
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
    global Double genesis__Assumed_Interest_Rate__c;
    global Double genesis__Debt_to_Income__c;
    /* Setup for the documentation fees when the quote is originated by a Broker.
    */
    global Decimal genesis__Documentation_Fees_Originated_Broker__c;
    /* Setup for the documentation fees when the quote is originated by a Dealer.
    */
    global Decimal genesis__Documentation_Fees_Originated_Dealer__c;
    /* Setup for the documentation fees when the quote is originated by an Internal Sales Representative.
    */
    global Decimal genesis__Documentation_Fees_Originated_Direct__c;
    global Boolean genesis__Enabled_Flag__c;
    /* End Date of the Rate card
    */
    global Date genesis__End_Date__c;
    /* Maximum finance percentage of Dealer price/collateral Value for Broker Deal.
    */
    global Double genesis__Maximum_Financed_Percent_Broker__c;
    /* Maximum finance percentage of Dealer price/collateral Value for Dealer Deal.
    */
    global Double genesis__Maximum_Financed_Percent_Dealer__c;
    /* Maximum finance percentage of Dealer price/collateral Value for Direct Deal.
    */
    global Double genesis__Maximum_Financed_Percent_Direct__c;
    /* Minimum percentage of cash required from the customer.
    */
    global Double genesis__Minimum_Cash_Percent_Customer__c;
    /* Start date of the rate card.
    */
    global Date genesis__Start_Date__c;
    global Decimal genesis__Term_Extension_Fees__c;
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
    global List<genesis__Quick_Quote_Option__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Quick_Quote_Option__c () 
    {
    }
}