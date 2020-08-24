// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Fee__c {
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
    /* This is the date from which the interest on the fee will be calculated. If this is not mentioned interest will be calculated from the date the fee was incurred.
    */
    global Date clcommon__Accrue_Interest_From__c;
    /* This field contains the principal balance on the loan after the charge has been applied.
    */
    global Double clcommon__Balance__c;
    /* This is the date the fee was incurred.
    */
    global Date clcommon__Date__c;
    global clcommon__Fee_Definition__c clcommon__Fee_Definition__r;
    global Id clcommon__Fee_Definition__c;
    /* Check this option if the fee is interest bearing.
    */
    global Boolean clcommon__Interest_Bearing__c;
    global Double clcommon__Interest_Due__c;
    /* This is the interest rate to be applied on the fee (if applicable)
    */
    global Double clcommon__Interest_Rate__c;
    /* The date when the last interest accrual was processed
    */
    global Date clcommon__Last_Accrual_Date__c;
    /* The original amount of the fee.
    */
    global Double clcommon__Original_Amount__c;
    /* The amount that has been paid.
    */
    global Double clcommon__Paid_Amount__c;
    global Boolean clcommon__Paid__c;
    /* This field contains the balance needed to payoff the loan after this fee has been applied.
    */
    global Double clcommon__Payoff_Balance__c;
    global Double clcommon__Principal_Due__c;
    global String clcommon__Reason_Waived__c;
    /* This text can be used to provide additional information about the fee.
    */
    global String clcommon__Reference__c;
    global Double clcommon__Total_Waived_Amount__c;
    global String clcommon__Type__c;
    /* This flag is set when the fee is fully waived.
    */
    global Boolean clcommon__Waive__c;
    global Double clcommon__Waived_Interest__c;
    global Double clcommon__Waived_Principal__c;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global Boolean clcommon__Approval_Process__c;
    global Boolean clcommon__Capitalize__c;
    global Boolean clcommon__Discount_Fee_By_Percentage__c;
    global Boolean clcommon__Discount_Fee__c;
    global Decimal clcommon__Discounted_Fee_Amount__c;
    global Double clcommon__Discounted_Fee_Percentage__c;
    /* This field identifies the party responsible for paying the fee.
    */
    global String clcommon__Fee_Paid_By__c;
    /* This field identifies the method in which the fee will be collected (e.g. fee amount to be deducted from loan proceeds or paid with borrower’s funds).
    */
    global String clcommon__Fee_Payment_Method__c;
    /* This field identifies the timing of fee payment either at the time of closing or before closing.
    */
    global String clcommon__Fee_Payment_Timing__c;
    global String clcommon__Frequency__c;
    global Boolean clcommon__Include_in_APR__c;
    global Boolean clcommon__Include_in_Dues__c;
    global Decimal clcommon__Maximum_Discount_Amount__c;
    global Decimal clcommon__Maximum_Waiver_Amount__c;
    global Double clcommon__No_of_Payments__c;
    global Boolean clcommon__Override_Fee__c;
    global Boolean clcommon__Partial_Fee_Waiver__c;
    global Decimal clcommon__Tax_Amount__c;
    global Boolean clcommon__Taxable__c;
    global Decimal clcommon__Waive_Amount__c;
    global genesis__Treasury_Services__c genesis__Treasury_Services__r;
    global Id genesis__Treasury_Services__c;
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
    global List<clcommon__Fee_Tax_Config__c> clcommon__Fee_Tax_Config__r;
    global List<clcommon__Fee__History> Histories;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Fee__c () 
    {
    }
}