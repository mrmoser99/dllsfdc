// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class APXTConga4__Conga_Template__c {
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
    global String APXTConga4__Description__c;
    /* For Conga Mail Merge Label Templates Only.  This setting indicates to use ReportData (or QueryData) as the data source for Labels
    */
    global Boolean APXTConga4__Label_Template_Use_Detail_Data__c;
    /* Enter the API field name, an equals sign, and the value to set (with spaces replaced with plus signs). 

Examples: 
Status__c=Completed 
Status_Date__c=Today 
Stage__c=In Progress
    */
    global String APXTConga4__Master_Field_to_Set_1__c;
    global String APXTConga4__Master_Field_to_Set_2__c;
    global String APXTConga4__Master_Field_to_Set_3__c;
    global String APXTConga4__Name__c;
    global String APXTConga4__Template_Extension__c;
    /* Identify the group name to which this template belongs. Used in conjunction with the "&TemplateGroup=" parameter in PointMerge.
    */
    global String APXTConga4__Template_Group__c;
    global String APXTConga4__Template_Type__c;
    global List<APXTConga4__Conga_Solution_Template__c> APXTConga4__Conga_Solution_Templates__r;
    global List<APXTConga4__Conga_Template__Share> Shares;
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
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global APXTConga4__Conga_Template__c () 
    {
    }
}