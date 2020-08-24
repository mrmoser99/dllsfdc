// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class dsfs__DocuSign_Envelope_Recipient__c {
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
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    /* DOCUSIGN ENVELOPE ID
    */
    global dsfs__DocuSign_Envelope__c dsfs__DocuSign_EnvelopeID__r;
    /* DOCUSIGN ENVELOPE ID
    */
    global Id dsfs__DocuSign_EnvelopeID__c;
    /* ACCESS CODE
    */
    global String dsfs__Access_Code__c;
    /* DOCUSIGN ENVELOPE RECIPIENT CONTACT ID
    */
    global Contact dsfs__DSER_ContactID__r;
    /* DOCUSIGN ENVELOPE RECIPIENT CONTACT ID
    */
    global Id dsfs__DSER_ContactID__c;
    global String dsfs__DSER_CustomFeaturesEx__c;
    global String dsfs__DSER_CustomFeatures__c;
    global String dsfs__DSER_CustomId__c;
    global String dsfs__DSER_CustomName__c;
    /* DOCUSIGN ENVELOPE RECIPIENT LEAD ID
    */
    global Lead dsfs__DSER_LeadID__r;
    /* DOCUSIGN ENVELOPE RECIPIENT LEAD ID
    */
    global Id dsfs__DSER_LeadID__c;
    /* DOCUSIGN ENVELOPE RECIPIENT USER ID
    */
    global User dsfs__DSER_UserID__r;
    /* DOCUSIGN ENVELOPE RECIPIENT USER ID
    */
    global Id dsfs__DSER_UserID__c;
    /* DOCUSIGN RECIPIENT ROLE
    */
    global String dsfs__DocuSign_Recipient_Role__c;
    /* DOCUSIGN SIGNATURE  NAME
    */
    global String dsfs__DocuSign_Signature_Name__c;
    /* DOCUSIGN SIGNER TYPE
    */
    global String dsfs__DocuSign_Signer_Type__c;
    global String dsfs__Email_Body__c;
    global String dsfs__Email_Subject__c;
    /* $ID CHECK
    */
    global Boolean dsfs__ID_Check__c;
    global String dsfs__LanguageCode__c;
    global String dsfs__Language__c;
    global String dsfs__Recipient_Email__c;
    global Double dsfs__Recipient_ID__c;
    /* Note for Recipient
    */
    global String dsfs__Recipient_Note_Long__c;
    /* NOTE FOR RECIPIENT
    */
    global String dsfs__Recipient_Note__c;
    global String dsfs__RoleName__c;
    /* VALUE ASSOCIATED WITH THE DOCUSIGN RECIPIENT ROLE. THIS VALUE IS USED TO MAP TO DEFAULT ANCHOR TAGS IN DOCUMENTS.
    */
    global Double dsfs__RoleValue__c;
    /* ROUTING ORDER
    */
    global Double dsfs__Routing_Order__c;
    global String dsfs__SMSAuthentication_PhoneNumber__c;
    /* SALESFORCE RECIPIENT TYPE
    */
    global String dsfs__Salesforce_Recipient_Type__c;
    global String dsfs__SignInPersonEmail__c;
    global String dsfs__SignInPersonName__c;
    global Boolean dsfs__SignNow__c;
    global String dsfs__SigningGroupId__c;
    /* VALIDATION MESSAGE
    */
    global String dsfs__Validation_Message__c;
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

    global dsfs__DocuSign_Envelope_Recipient__c () 
    {
    }
}