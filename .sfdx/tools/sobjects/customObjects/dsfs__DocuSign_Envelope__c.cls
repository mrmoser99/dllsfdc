// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class dsfs__DocuSign_Envelope__c {
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
    /* Bulk Send Error Message
    */
    global String dsfs__BulkSendErrorMessage__c;
    /* Bulk Send Error
    */
    global Boolean dsfs__BulkSendError__c;
    global String dsfs__ChatterEnvCompletedText__c;
    global Boolean dsfs__ChatterEnvCompleted__c;
    global String dsfs__ChatterEnvDeclinedText__c;
    global Boolean dsfs__ChatterEnvDeclined__c;
    global String dsfs__ChatterEnvDeliveredText__c;
    global Boolean dsfs__ChatterEnvDelivered__c;
    global String dsfs__ChatterEnvSentText__c;
    global Boolean dsfs__ChatterEnvSent__c;
    global String dsfs__ChatterEnvVoidedText__c;
    global Boolean dsfs__ChatterEnvVoided__c;
    global String dsfs__ChatterRecipCompletedText__c;
    global Boolean dsfs__ChatterRecipCompleted__c;
    global String dsfs__ChatterRecipDeclinedText__c;
    global Boolean dsfs__ChatterRecipDeclined__c;
    global String dsfs__ChatterRecipDeliveredText__c;
    global Boolean dsfs__ChatterRecipDelivered__c;
    global String dsfs__ChatterRecipSentText__c;
    global Boolean dsfs__ChatterRecipSent__c;
    global String dsfs__ChatterRecipSignedText__c;
    global Boolean dsfs__ChatterRecipSigned__c;
    /* Check to show chatter during DocuSign signature workflow.
    */
    global Boolean dsfs__ChatterUpdatesEnabled__c;
    /* Select a Contact from Salesforce to be a DocuSign Recipient/Signer.  Only Contacts with valid email addresses can be used as DocuSign Recipients.
    */
    global Contact dsfs__Contact2eSignDoc01__r;
    /* Select a Contact from Salesforce to be a DocuSign Recipient/Signer.  Only Contacts with valid email addresses can be used as DocuSign Recipients.
    */
    global Id dsfs__Contact2eSignDoc01__c;
    global String dsfs__Custom_Field_1_Name__c;
    global String dsfs__Custom_Field_1_Value__c;
    /* Custom Field to pass data via Envelope
    */
    global String dsfs__Custom_Field_1__c;
    global String dsfs__Custom_Field_2_Name__c;
    global String dsfs__Custom_Field_2_Value__c;
    /* Custom Field to pass data via Envelope
    */
    global String dsfs__Custom_Field_2__c;
    global String dsfs__Custom_Field_3_Name__c;
    global String dsfs__Custom_Field_3_Value__c;
    /* Custom Field to pass data via Envelope
    */
    global String dsfs__Custom_Field_3__c;
    /* Indicate how many days prior to expiration you want an email message to alert recipients that a deadline approaches for completion. This is sent only to recipients who have not yet completed the transaction.
    */
    global Double dsfs__Day_Prior_to_Warn_of_expiration__c;
    /* Indicate the number of days until this transaction is expired.
    */
    global Double dsfs__Days_before_Envelope_is_Expired_Voided__c;
    /* Edit this Email Message Text (up to 2,000 characters) and it will appear in the notification to sign for your DocuSign Recipient.
    */
    global String dsfs__DocuSign_Email_Message__c;
    /* Change this default Email Subject text and it will appear as the Subject Line in the notification to Sign for your DocuSign Recipients.
    */
    global String dsfs__DocuSign_Email_Subject__c;
    /* DocuSign Envelope ID
    */
    global String dsfs__DocuSign_Envelope_ID__c;
    /* DocuSign Envelope Sent
    */
    global Datetime dsfs__DocuSign_Envelope_Sent__c;
    /* Document ID
    */
    global String dsfs__DocumentID__c;
    /* This is a list of PDF Documents located in your Organization's Salesforce "Documents Tab".  In order to send with DocuSign you must add a PDF to any of the folders within your Documents Tab in Salesforce.  To Send with other Formats click "Learn More'.
    */
    global String dsfs__Document_Name__c;
    /* The configuration used to generate this envelope.
    */
    global dsfs__EnvelopeConfiguration__c dsfs__EnvelopeConfiguration__r;
    /* The configuration used to generate this envelope.
    */
    global Id dsfs__EnvelopeConfiguration__c;
    /* At times, you may need to encourage your recipients to complete an envelope more rapidly. After an envelope expires, DocuSign eSignature for Salesforce voids the envelope and sends a notification to both sender and recipient.
    */
    global Boolean dsfs__Expire_Void_Envelope__c;
    /* I agree to Terms
    */
    global Boolean dsfs__I_agree_to_Terms__c;
    /* Click this checkbox if you would like to be added as an additional Recipient/Signer on this document.  If you leave this unchecked you will receive notification that the Contact has DocuSigned but will not be able to Sign it yourself.
    */
    global Boolean dsfs__I_will_Sign__c;
    /* Batch Job Id
    */
    global String dsfs__Job__c;
    /* Quick Lead to eSign Document
    */
    global Lead dsfs__Lead2eSignDoc01__r;
    /* Quick Lead to eSign Document
    */
    global Id dsfs__Lead2eSignDoc01__c;
    /* Indicate how many days should pass before the first reminder is sent
    */
    global Double dsfs__Reminder_Interval__c;
    /* Indicate how often (in days) the reminder should repeat until the transaction is complete.
    */
    global Double dsfs__Reminder_Repeat_Interval_in_Days__c;
    /* Check this box to have an email reminder sent to recipients of the envelope who have not yet completed their task.
    */
    global Boolean dsfs__Send_Reminder__c;
    /* This is the name of the Salesforce User who created this DocuSign transaction.
    */
    global String dsfs__Sender__c;
    global String dsfs__Source_Object_Parent__c;
    /* Source Object
    */
    global String dsfs__Source_Object__c;
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
    global List<dsfs__DocuSign_Envelope_Document__c> dsfs__DocuSign_Documents__r;
    global List<dsfs__DocuSign_Envelope_Recipient__c> dsfs__DocuSign_Envelope_Recipient__r;
    global List<dsfs__DocuSign_Envelope__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global dsfs__DocuSign_Envelope__c () 
    {
    }
}