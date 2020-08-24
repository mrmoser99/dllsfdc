// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Fee__c {
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
    global String cllease__Amortization_Method__c;
    global String cllease__Amortization_Period__c;
    global Boolean cllease__Amortize__c;
    /* Number or %
Amount, is a flat amount. For other fee calculation methods, this is a % amount.
    */
    global Double cllease__Amount__c;
    global Boolean cllease__Capitalize__c;
    global Boolean cllease__Default_fees__c;
    /* Fee Calculation Method
    */
    global String cllease__Fee_Calculation_Method__c;
    global String cllease__Fee_Category__c;
    global String cllease__Fee_Type__c;
    global Boolean cllease__Interest_Bearing__c;
    global Double cllease__Interest_Rate__c;
    global String cllease__Maintenance_Fee_s_Frequency__c;
    global Double cllease__Maximum_Amount__c;
    global Double cllease__Minimum_Amount__c;
    global Boolean cllease__Refundable__c;
    /* State
    */
    global String cllease__State__c;
    global Boolean cllease__Taxable__c;
    /* Time of charge
    */
    global String cllease__Time_of_charge__c;
    global String cllease__Type_of_charge__c;
    global Double RateFactor__c;
    global Double clcommon_Amount__c;
    global String cllease__External_Id__c;
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
    global List<Property_Tax__c> Property_Taxes__r;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<cllease__Charge__c> cllease__Charges__r;
    global List<cllease__Contract_Fees__c> cllease__Contract_Fees__r;
    global List<cllease__Expense_Fees__c> cllease__Expense_Fees__r;
    global List<cllease__Fee_Junction__c> cllease__Fee_Junction__r;
    global List<cllease__Fee_Stream__c> cllease__Fee_Streams__r;
    global List<cllease__Fee__History> Histories;
    global List<cllease__Periodic_Fee_Setup__c> cllease__Periodic_Fee_Setup__r;
    global List<cllease__Spread_Detail__c> cllease__Spread_Details__r;
    global List<cllease__Termination_Config_Fee__c> cllease__Termination_Config_Fees__r;
    global List<cllease__Termination_Fee__c> cllease__Termination_Fees__r;
    global List<cllease__Termination_Quote_Line__c> cllease__Termination_Quote_Lines__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Fee__c () 
    {
    }
}