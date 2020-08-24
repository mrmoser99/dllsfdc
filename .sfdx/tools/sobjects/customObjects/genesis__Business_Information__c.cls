// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Business_Information__c {
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
    global String genesis__Business_Category__c;
    global String genesis__Business_City__c;
    global String genesis__Business_Country__c;
    global String genesis__Business_Description__c;
    global String genesis__Business_Legal_Name__c;
    global String genesis__Business_State__c;
    global String genesis__Business_Street__c;
    global String genesis__Business_Zipcode__c;
    global String genesis__Customer_Number__c;
    global String genesis__DBA_Name__c;
    global Date genesis__Date_Business_Established__c;
    global String genesis__Email__c;
    global String genesis__Entity_Type__c;
    global String genesis__Mailing_City__c;
    global String genesis__Mailing_Country__c;
    global String genesis__Mailing_State__c;
    global String genesis__Mailing_Street__c;
    global String genesis__Mailing_Zipcode__c;
    global String genesis__NAICS_Code__c;
    global String genesis__NAICS_Description__c;
    global Boolean genesis__Non_Profit_Organization__c;
    global String genesis__Organization_ID_Number__c;
    global Double genesis__Required_Number_of_Signers__c;
    global String genesis__State_of_Incorporation__c;
    global String genesis__Tax_ID__c;
    global Double genesis__Tax_I_D__c;
    global String genesis__Telephone__c;
    /* This checkbox is to identify the Account is exempt from beneficial owner requirements.
    */
    global Boolean genesis__Beneficial_Owner_Exempt__c;
    global Date genesis__Business_Filing_Date__c;
    /* User will input the State where the business was registered.
    */
    global String genesis__Business_Registration_State__c;
    /* This is the completed resolution date for the business relationship.
    */
    global Date genesis__Completed_Resolution_Date__c;
    /* This field stores the date when the current owner took over this business.
    */
    global String genesis__Control_Ownership_Date__c;
    /* Data Universal Numbering System
    */
    global String genesis__DUNS_Number__c;
    /* This field will identify the federal classification of the legal entity.
    */
    global String genesis__Federal_Tax_Classification__c;
    /* This field store the Financial Period Duration
    */
    global String genesis__Financial_Period_Duration__c;
    /* This field store the Financial Statement Date.
    */
    global Date genesis__Financial_Statement_Date__c;
    /* This checkbox identifies if the Account is a IRS tax payer.
    */
    global Boolean genesis__IRS_Taxpayer__c;
    /* This pick list is to capture additional information on business entities.
    */
    global String genesis__Management_Type__c;
    /* This field store the operating status of the business.
    */
    global String genesis__Operating_Status__c;
    /* This field stores optional/additional customer identification program information for an Account
    */
    global String genesis__Optional_CIP_Information__c;
    /* These are the options that indicate whether the financial institution possesses a valid and up-to-date resolution for the commercial account owner, or if a resolution needs to be included in the transaction workflow.
    */
    global String genesis__Resolution_Type__c;
    /* This is an identification number used for tax purposes.
    */
    global String genesis__Tax_Identification_Number__c;
    global List<Account> genesis__Accounts__r;
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
    global List<genesis__Business_Information__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Business_Information__c () 
    {
    }
}