// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Treasury_Criteria_Results__c {
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
    global Account genesis__Account__r;
    global Id genesis__Account__c;
    /* Flag to determine whether the criteria result is active or not
    */
    global Boolean genesis__Active__c;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    /* Bi_Weekly limit
    */
    global Decimal genesis__Bi_Weekly__c;
    global clcommon__CL_Product__c genesis__CL_Product__r;
    global Id genesis__CL_Product__c;
    /* Service's cheque name
    */
    global String genesis__Cheque_Issue_File_Name__c;
    /* Provide service's cheque file type
    */
    global String genesis__Cheque_Issue_File_Type__c;
    /* DDA port number associated with Sweep services
    */
    global String genesis__DDA_Port__c;
    /* Daily transaction limit
    */
    global Decimal genesis__Daily__c;
    /* Flag to validate second level approval
    */
    global Boolean genesis__Dua_Approval__c;
    /* Exception Target Balance limit
    */
    global Decimal genesis__Exception_Target_Balance__c;
    /* Captures total number of  expected wires on daily basis
    */
    global Double genesis__Expected_Wires_Per_Day__c;
    global genesis__Financial_Account_Applications__c genesis__Financial_Account_Applications__r;
    global Id genesis__Financial_Account_Applications__c;
    global staging__Interface_Bank_Account__c genesis__Interface_Bank_Account__r;
    global Id genesis__Interface_Bank_Account__c;
    /* Loan port number associated with Sweep services
    */
    global String genesis__Loan_Port__c;
    /* Master DDA port number for Sweep services
    */
    global String genesis__Master_DDA_Port__c;
    /* Monthly transaction Limit
    */
    global Decimal genesis__Monthly__c;
    global clcommon__Party__c genesis__Party__r;
    global Id genesis__Party__c;
    /* Document name associated with Positive pay service
    */
    global String genesis__Positive_Pay_Document__c;
    /* Flag to determine whether  pre funding is available or not
    */
    global Boolean genesis__Pre_Funding__c;
    /* Quarterly transaction limit
    */
    global Decimal genesis__Quarterly__c;
    /* Single Transaction limit
    */
    global Decimal genesis__Single_Transaction_Limit__c;
    /* Single Transaction limit
    */
    global Decimal genesis__Single_Transaction__c;
    /* Sub DDA port number for Sweep services
    */
    global String genesis__Sub_DDA_Port__c;
    /* Transaction limit for Sweep services
    */
    global Decimal genesis__Target_Balance__c;
    /* DDA Account number from where the amount is transferred
    */
    global String genesis__Transfer_From_DDA_Account__c;
    /* Master Account number from where the amount is transferred
    */
    global String genesis__Transfer_From_Master_Account__c;
    /* Line of credit account number to which the transfer is made
    */
    global String genesis__Transfer_To_LOC_Account__c;
    /* Repository account number to which the transfer is made
    */
    global String genesis__Transfer_To_Repo_Account__c;
    /* Sub account number to which the transfer is made
    */
    global String genesis__Transfer_To_Sub_Account__c;
    global genesis__Treasury_Services__c genesis__Treasury_Services__r;
    global Id genesis__Treasury_Services__c;
    /* Weekly limit
    */
    global Decimal genesis__Weekly__c;
    /* Yearly limit
    */
    global Decimal genesis__Yearly__c;
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
    global List<genesis__Treasury_Criteria_Results__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Treasury_Criteria_Results__c () 
    {
    }
}