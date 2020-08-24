// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class skuid__Preferences__c {
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
    global Boolean skuid__Auto_Assign_Licenses_on_Activation__c;
    global Boolean skuid__Auto_Assign_Perm_Sets_on_Activation__c;
    global Boolean skuid__Auto_Revoke_Licenses_on_Deactivation__c;
    global Boolean skuid__Auto_Revoke_Perm_Sets_on_Deactivation__c;
    global String skuid__Default_Builder_Theme__c;
    global String skuid__Default_Mobile_Builder_Theme__c;
    global String skuid__Default_Mobile_Theme__c;
    global String skuid__Default_Theme__c;
    global Boolean skuid__Disable_Collaboration_Polling__c;
    global Boolean skuid__Disable_Hotkeys_Skuid_App__c;
    global String skuid__Package_Names_For_Auto_Assignment__c;
    global String skuid__Package_Names_For_Auto_Revocation__c;
    global String skuid__Perm_Sets_For_Auto_Assignment__c;
    global String skuid__Perm_Sets_For_Auto_Revocation__c;
    global Boolean skuid__Show_SF_Header_Skuid_Core__c;
    global Boolean skuid__Use_Component_Packs__c;
    global Boolean skuid__Auto_Gen_Page_Support_File__c;
    global Boolean skuid__Global_Feedback_Enabled__c;
    global String skuid__Global_Feedback_Position__c;
    global String skuid__Loading_Page_Placeholder__c;
    global Boolean skuid__Offline_Mode__c;
    global Boolean skuid__Offline_Sync_Automatically__c;
    global Boolean skuid__Offline_Sync_Interaction__c;
    global Boolean skuid__Offline_Sync_Status_Bar__c;
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

    global skuid__Preferences__c () 
    {
    }
}