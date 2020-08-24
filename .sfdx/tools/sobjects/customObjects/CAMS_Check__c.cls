// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class CAMS_Check__c {
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
    global String Account_Number__c;
    global genesis__Applications__c Application__r;
    global Id Application__c;
    /* To clear a pep, the user needs to tell the system if the cams should be called with a pep indicator of true or false.
    */
    global String CAMS_PEP_Indicator__c;
    global Boolean Confirmed_PEP__c;
    global String Customer_LE_Type__c;
    global String Customer_Name__c;
    global String Customer_Type__c;
    global String Distribution_Channel__c;
    global String Dll_Country__c;
    global String Geography__c;
    global cllease__Lease_Account__c LS_Contract__r;
    global Id LS_Contract__c;
    global String Lease_Signer_First_Name__c;
    global String Lease_Signer_Last_Name__c;
    global String Lease_Signer_Title__c;
    global Boolean Missing_Data__c;
    global String NAICS__c;
    global String Product_Risk__c;
    global Boolean Publicly_Traded_Full_Subsidiary__c;
    global Boolean Publicly_Traded__c;
    global genesis__Quick_Quotes__c Quick_Quote__r;
    global Id Quick_Quote__c;
    global String Response_Case_Number__c;
    global String Response_Code__c;
    global Boolean Response_Diligence__c;
    global String Response_Risk_Rating__c;
    global String Source_System__c;
    global String Status__c;
    global Decimal Transaction_Amount__c;
    global Boolean Trust__c;
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CAMS_Check__History> Histories;
    global List<CAMS_Check__Share> Shares;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Event> Events;
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

    global CAMS_Check__c () 
    {
    }
}