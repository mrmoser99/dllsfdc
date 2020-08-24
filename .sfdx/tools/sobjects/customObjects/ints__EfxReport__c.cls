// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__EfxReport__c {
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
    global String ints__BureauCode__c;
    global String ints__BureauContactInformation__c;
    global Contact ints__Contact__r;
    global Id ints__Contact__c;
    global String ints__DateOfBirth__c;
    global String ints__DateOfDeath__c;
    global String ints__DateOfLastActivity__c;
    global String ints__FileSinceDate__c;
    global String ints__FirstName__c;
    global String ints__HitStrengthIndicator_Code__c;
    global String ints__HitStrengthIndicator_Description__c;
    global String ints__Hit_Code__c;
    global String ints__Hit_Description__c;
    global String ints__LastName__c;
    global String ints__MiddleName__c;
    global String ints__UniqueNumber__c;
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
    global List<ints__EfxReport_Address__c> ints__EfxReport_Addresses__r;
    global List<ints__EfxReport_Bank_Account__c> ints__EfxReport_Bank_Accounts__r;
    global List<ints__EfxReport_Collection__c> ints__EfxReportCollections__r;
    global List<ints__EfxReport_Consumer_Statement__c> ints__EfxReport_Consumer_Statements__r;
    global List<ints__EfxReport_Data_Warning_Message__c> ints__EfxReport_Data_Warning_Messages__r;
    global List<ints__EfxReport_Employment__c> ints__EfxReport_Employments__r;
    global List<ints__EfxReport_Error__c> ints__EfxReport_Errors__r;
    global List<ints__EfxReport_ForeignInquiry__c> ints__EfxReport_ForeignInquiries__r;
    global List<ints__EfxReport_FraudWarning__c> ints__EfxReport_FraudWarnings__r;
    global List<ints__EfxReport_Garnishment__c> ints__Equifax_Garnishments__r;
    global List<ints__EfxReport_LegalItem__c> ints__EfxReport_LegalItems__r;
    global List<ints__EfxReport_Local_Inquiry__c> ints__EfxReport_Local_Inquiries__r;
    global List<ints__EfxReport_Other_Income__c> ints__EfxReport_Other_Incomes__r;
    global List<ints__EfxReport_Score__c> ints__EfxReport_Scores__r;
    global List<ints__EfxReport_SecuredLoan__c> ints__EfxReport_SecuredLoans__r;
    global List<ints__EfxReport_Trade__c> ints__EfxReport_Trades__r;
    global List<ints__EfxReport__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global ints__EfxReport__c () 
    {
    }
}