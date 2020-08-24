// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Task_Setup__c {
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
    /* If a task is a parallel task, then who should it be assigned to initially?
    */
    global User genesis__Assign_Parallel_Task_To__r;
    /* If a task is a parallel task, then who should it be assigned to initially?
    */
    global Id genesis__Assign_Parallel_Task_To__c;
    /* false if type = " MANUAL", otherwise true.
    */
    global Boolean genesis__Auto_Close__c;
    /* Detailed description for the task. This field is mapped to “Description” field of the task.
    */
    global String genesis__Description__c;
    global String genesis__Evaluation_Expression_For_Execution__c;
    /* Is it a parallel task?
    */
    global Boolean genesis__Is_Parallel__c;
    /* Determines if the task created from this setup needs to be completed before the user can submit the application to next department
    */
    global Boolean genesis__Mandatory__c;
    /* Name of the task which should be created after this task is closed. Required in cases such as LOI
    */
    global String genesis__Next_Task_Name__c;
    global String genesis__Object_Type__c;
    /* Priority of the task
    */
    global String genesis__Priority__c;
    /* A short name of the task. This is copied to “Subject” field of task
    */
    global String genesis__Task_Name__c;
    /* Tasks can be manual or auto close depending on the type.Select "MANUAL" for manual tasks and rest for auto close
    */
    global String genesis__Type__c;
    /* Number of days to close this tasks either from present date(+ve number) or number of days before which the task needs to be closed from the expected close date on application(-ve number)
    */
    global Double genesis__days_until_due_date__c;
    global String genesis__External_ID__c;
    global String Dept_Type__c;
    /* This field is used as configuration to retain completed tasks on backward movement of stages. If its value is unchecked then completed tasks will be archived. Incomplete tasks will always be deleted.
    */
    global Boolean genesis__Retain_Completed_Task__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<LookedUpFromActivity> genesis__Activities__r;
    global List<NetworkActivityAudit> ParentEntities;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<clcommon__Execution_Criteria__c> genesis__Execution_Criteria__r;
    global List<genesis__Document_Category__c> genesis__Document_Categories__r;
    global List<genesis__Document_Config_for_Category__c> genesis__Document_Configs_for_Categories__r;
    global List<genesis__ProductDepartment_Task_Junction__c> genesis__ProductDepartment_Task_Junctio__r;
    global List<genesis__Task_Setup__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Task_Setup__c () 
    {
    }
}