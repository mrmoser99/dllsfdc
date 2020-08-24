// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Application_Collateral__c {
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
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global clcommon__Collateral__c genesis__Collateral__r;
    global Id genesis__Collateral__c;
    global Decimal genesis__Pledge_Amount__c;
    global Decimal genesis__Collateral_Value__c;
    global Decimal genesis__Dealer_Fees__c;
    global Decimal genesis__Estimated_Selling_Price__c;
    global Decimal genesis__Other_Financed_Fees__c;
    global Decimal genesis__Tax_Amount__c;
    global Decimal genesis__Total_Dealer_Charges__c;
    global Decimal genesis__Warranty_Amount__c;
    global Boolean genesis__Active__c;
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
    global List<LookedUpFromActivity> genesis__Activities__r;
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
    global List<clcommon__Execution_Criteria_Result__c> genesis__Execution_Criteria_Result__r;
    global List<clcommon__Questionnaire_Instance__c> genesis__Questionnaire_Instances_Application_Coll__r;
    global List<genesis__Application_Collateral__Share> Shares;
    global List<genesis__Appraisal_Request__c> genesis__Appraisal_Request__r;
    global List<genesis__Insurance__c> genesis__Insurances__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global genesis__Application_Collateral__c () 
    {
    }
}