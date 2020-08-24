// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Int_Asset__c {
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
    global String Asset_Number__c;
    global String Asset_Recording_Method_Code__c;
    global String Asset_Source_System__c;
    global String Asset_Status_Code__c;
    global String Asset_Type_Number__c;
    global String Asset_Type__c;
    global Boolean Committed__c;
    global String Global_Master_Asset_Type_Code__c;
    global String Global_Master_Asset_Type__c;
    global Decimal Inventory_Book_Value__c;
    global Decimal Inventory_Sale_Amount__c;
    global String Make_Number__c;
    global String Make__c;
    global String Manufacturing_Year__c;
    global String Model_Number__c;
    global String Model__c;
    global String Number_Of_Units__c;
    global String Object_Category_Number__c;
    global String Object_Category__c;
    global Decimal Orderly_Liquidation_Value__c;
    global String Serial_Number__c;
    global String Used_Indicator__c;
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
    global List<Int_Agreement_Line_Asset__c> Int_Agreement_Line_Assets__r;
    global List<Int_Asset_Feature__c> Int_Asset_Features__r;
    global List<Int_Asset_Usage__c> Int_Asset_Usages__r;
    global List<Int_Asset__History> Histories;
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

    global Int_Asset__c () 
    {
    }
}