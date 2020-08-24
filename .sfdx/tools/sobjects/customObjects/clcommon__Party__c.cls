// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Party__c {
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
    global Account clcommon__Account__r;
    global Id clcommon__Account__c;
    global Contact clcommon__Contact__r;
    global Id clcommon__Contact__c;
    global Double clcommon__Contingent_Liability__c;
    global String clcommon__External_Id__c;
    global String clcommon__Party_Type__c;
    global String clcommon__Signer_Capacity__c;
    global Account clcommon__Signing_on_Behalf_of__r;
    global Id clcommon__Signing_on_Behalf_of__c;
    global clcommon__Party_Type__c clcommon__Type__r;
    global Id clcommon__Type__c;
    global User clcommon__User__r;
    global Id clcommon__User__c;
    global Boolean clcommon__isPrimary__c;
    global collect__Loan_Account__c collect__CL_Contract__r;
    global Id collect__CL_Contract__c;
    global Contract collect__Contract__r;
    global Id collect__Contract__c;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global ints__Credit_Report__c genesis__Credit_Report__r;
    global Id genesis__Credit_Report__c;
    global Boolean genesis__Is_Internal_User__c;
    global String genesis__Party_Name__c;
    global Address__c Address__r;
    global Id Address__c;
    global String Party_Type_Name__c;
    /* Consent to receive documents/disclosures electronically
    */
    global Boolean clcommon__Electronic_Consent__c;
    global Boolean clcommon__Joint_Consent__c;
    /* This field stores the Back End DTI ratio for a party
    */
    global Double genesis__Back_End_Debt_To_Income_Ratio__c;
    /* This field stores the Front End DTI ratio for a party
    */
    global Double genesis__Front_End_Debt_To_Income_Ratio__c;
    global Boolean clcommon__Active__c;
    /* It is to identify the party types who are a part of customer identification program.
    */
    global Boolean clcommon__Is_Customer_Identification_Program__c;
    /* This field is used to indicate that the organization seal is required for the business entity.
    */
    global Boolean clcommon__Is_Organization_Seal_Required__c;
    /* This checkbox will identify the GRANTOR as a Mortgagor. Mortgagor is the owner of the collateral of type "real estate" that has a senior lien.
    */
    global Boolean clcommon__Mortgagor__c;
    /* This field is created to pop up relationship with power of attorney.
    */
    global Contact clcommon__Related_Individual__r;
    /* This field is created to pop up relationship with power of attorney.
    */
    global Id clcommon__Related_Individual__c;
    /* This field is created to pop up relationship with power of attorney.
    */
    global Account clcommon__Related_NonIndividual__r;
    /* This field is created to pop up relationship with power of attorney.
    */
    global Id clcommon__Related_NonIndividual__c;
    /* This is field is to store the trust account linked to the trustee.
    */
    global Account clcommon__Trustee_Of__r;
    /* This is field is to store the trust account linked to the trustee.
    */
    global Id clcommon__Trustee_Of__c;
    /* This checkbox will record consent to use the party's electronic signatures in the closing documents.
    */
    global Boolean clcommon__Use_Electronic_Signature__c;
    /* Flag to determine whether the employee is an administrator.
    */
    global Boolean genesis__Administrator__c;
    /* I hereby authorize you to check my credit and employment history and to answer permissible questions, under the Fair Credit Reporting Act, others may ask you about my credit record with you.
    */
    global Boolean genesis__Credit_Check_Consent__c;
    /* Flag to determine whether the employee is an active employee of the company or not.
    */
    global Boolean genesis__Enabled__c;
    /* Reference to account which is assigned as parent company to this party.
    */
    global Account genesis__Parent_Company__r;
    /* Reference to account which is assigned as parent company to this party.
    */
    global Id genesis__Parent_Company__c;
    global List<ActivityHistory> ActivityHistories;
    global List<Application_Fee_Payment__c> Application_Fee_Payment__r;
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
    global List<Equipment_Funding_Detail__c> Equipment_Funding_Detail__r;
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
    global List<clcommon__Collateral_Category__c> genesis__Collateral_Categories__r;
    global List<clcommon__Execution_Criteria_Result__c> genesis__Execution_Criteria_Result__r;
    global List<clcommon__Party__Share> Shares;
    global List<clcommon__Questionnaire_Instance__c> genesis__Questionnaire_Instances_Party__r;
    global List<cllease__Lease_Account__c> LS_Contracts__r;
    global List<collect__Contact_Preference__c> collect__Contact_Preferences__r;
    global List<genesis__Application_Document_Category__c> genesis__Application_Document_Category__r;
    global List<genesis__Application_s_Scorecard__c> genesis__Application_Scorecard_Result__r;
    global List<genesis__Employee_FinAccount_Transaction_Access__c> genesis__Employee_FinAccount_Transaction_Access__r;
    global List<genesis__Insurance__c> genesis__Insurances__r;
    global List<genesis__Treasury_Criteria_Results__c> genesis__Treasury_Criteria_Results__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global clcommon__Party__c () 
    {
    }
}