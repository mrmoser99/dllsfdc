// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Interest_Component__c {
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
    /* Check this if you want interest to be added to the bill. When payments are coming in towards this interest type it will satisfy any unpaid bills irrespective of this flag.
    */
    global Boolean clcommon__Add_Interest_To_Bill__c;
    /* This refers to the principal value it should consider when calculating interest.
    */
    global String clcommon__Interest_Calculation_Method__c;
    /* Rate of interest for this component at the time of creation.
    */
    global Double clcommon__Interest_Rate__c;
    /* This field refers to the type of interest.
    */
    global String clcommon__Interest_Type__c;
    /* Days counting method for interest accrual.
    */
    global String clcommon__Time_Counting_Method__c;
    /* Indicate if interest should be calculated for next period in advance.
    */
    global Boolean clcommon__Advance_Interest__c;
    /* This decides the frequency at which compounding will be done. When this is selected, Interest Calculation Type should be Future Value Based.
    */
    global String clcommon__Compounding_Frequency__c;
    global String clcommon__External_Id__c;
    /* This refers to the adjustment method to be used when interest in advance differ from the interest for that period. When None is selected, there won't be any adjustments.
    */
    global String clcommon__Interest_Adjustment_Method__c;
    /* This refers to the formula to be used for interest calculation.
    */
    global String clcommon__Interest_Calculation_Type__c;
    /* User defined name For Interest Component
    */
    global String clcommon__Interest_Comp_Name__c;
    /* Indicate if advance interest should be collected at time of disbursal.
    */
    global Boolean clcommon__Part_Of_Disbursal__c;
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
    global List<clcommon__Interest_Component__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Interest_Component__c () 
    {
    }
}