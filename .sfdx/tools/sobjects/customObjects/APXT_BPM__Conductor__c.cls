// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class APXT_BPM__Conductor__c {
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
    global String APXT_BPM__Conductor_Environment__c;
    /* Combine PDFs into a single file when scheduling a consolidated Conductor routine and delivering to a Content Workspace.
    */
    global Boolean APXT_BPM__Consolidated_PDF_Output_File__c;
    /* The ID of a Content Library where files from a scheduled Conductor process will be stored when the output mode is set to download.
    */
    global String APXT_BPM__Content_Workspace_Id__c;
    global String APXT_BPM__Description__c;
    global Double APXT_BPM__Has_Query_Id__c;
    global Double APXT_BPM__Has_Record_Id__c;
    global Double APXT_BPM__Has_Report_Id__c;
    /* Automatically populated by the Conductor schedule.
    */
    global Datetime APXT_BPM__Next_Run_Date_Display__c;
    /* Determined by "Schedule" button.  Do not edit this field manually.
    */
    global Datetime APXT_BPM__Next_Run_Date__c;
    /* The ID of a Conga Query record that returns the list of Master Object record IDs. Optionally, the query may include other fields.
    */
    global String APXT_BPM__Query_Id__c;
    /* An individual Salesforce record ID to use as a Master Object ID.
    */
    global String APXT_BPM__Record_Id__c;
    /* The ID of a Salesforce Report that contains the list of Master Object IDs. Optionally, the report may include other columns.
    */
    global String APXT_BPM__Report_Id__c;
    /* Automatically populated by the Conductor schedule.
    */
    global String APXT_BPM__Schedule_Description_Display__c;
    /* Determined by "Schedule" button.  Do not edit this field manually.
    */
    global String APXT_BPM__Schedule_Description__c;
    global String APXT_BPM__Title__c;
    /* The API name of the formula field that contains the converted Conga Composer button / link URL.
    */
    global String APXT_BPM__URL_Field_Name__c;
    global String APXT_BPM__Version__c;
    global List<APXT_BPM__Conductor__Share> Shares;
    global List<APXT_BPM__Scheduled_Conductor_History__c> APXT_BPM__Scheduled_Conductor_History__r;
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

    global APXT_BPM__Conductor__c () 
    {
    }
}