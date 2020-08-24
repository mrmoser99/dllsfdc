// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Insurance__c {
    global Id Id;
    global Boolean IsDeleted;
    global String Name;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    /* This field is a reference to corresponding Application
    */
    global genesis__Applications__c genesis__Application__r;
    /* This field is a reference to corresponding Application
    */
    global Id genesis__Application__c;
    global Double genesis__A_Factor__c;
    global Boolean genesis__Added_to_Loan_Amount__c;
    /* This field is a reference to corresponding Application Collateral
    */
    global genesis__Application_Collateral__c genesis__Application_Collateral__r;
    /* This field is a reference to corresponding Application Collateral
    */
    global Id genesis__Application_Collateral__c;
    global Double genesis__Compounding_Rate_Factor__c;
    /* Internal Field
    */
    global Double genesis__Health_Premium_Mid_Calculation__c;
    /* This field is a reference to Insurance definition
    */
    global clcommon__Insurance_Definition__c genesis__Insurance_Definition__r;
    /* This field is a reference to Insurance definition
    */
    global Id genesis__Insurance_Definition__c;
    /* This field shows the number of terms for any insurance
    */
    global Double genesis__Insurance_Term__c;
    global Double genesis__Life_Premium_Mid_Calculation__c;
    global Double genesis__Monthly_Interest_Rate__c;
    global Double genesis__ODF__c;
    global Double genesis__Odd_Days__c;
    /* This field is a reference to corresponding Party
    */
    global clcommon__Party__c genesis__Party__r;
    /* This field is a reference to corresponding Party
    */
    global Id genesis__Party__c;
    /* This field captures the calculated value of premium amount based on Insurance configuration
    */
    global Decimal genesis__Premium_Amount__c;
    global Double genesis__S_Factor__c;
    /* This field stores the value of one time premium disability rate for the term of health insurance per $100 of initial insured indebtedness
    */
    global Double genesis__Single_Premium_Disability_Rate__c;
    /* This field stores the value of one time premium life rate for the term of life insurance per $100 of initial insured indebtedness
    */
    global Double genesis__Single_Premium_Life_Rate__c;
    /* One time premium rate per $100 per annum of initial insured indebtedness
    */
    global Double genesis__Single_Premium_Rate__c;
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

    global genesis__Insurance__c () 
    {
    }
}