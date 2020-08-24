// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Rate_Card_Setup_Header__c {
    global Id Id;
    global SObject Owner;
    global Id OwnerId;
    global Boolean IsDeleted;
    global String Name;
    global RecordType RecordType;
    global Id RecordTypeId;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global clcommon__CL_Product__c genesis__CL_Product__r;
    global Id genesis__CL_Product__c;
    global genesis__Company__c genesis__Company__r;
    global Id genesis__Company__c;
    /* Description of Rate Card.
    */
    global String genesis__Description__c;
    global Boolean genesis__Enabled_Flag__c;
    /* End Date of Rate card
    */
    global Date genesis__End_Date__c;
    /* If checked, Credit rating will be considered while filtering the available pricing options else not.
    */
    global Boolean genesis__Filter_By_Credit_Rating__c;
    /* If checked, Payment Frequency will be considered while filtering the available pricing options else not.
    */
    global Boolean genesis__Filter_By_Frequency__c;
    /* If checked, Loan Amount will be considered while filtering the available pricing options else not.
    */
    global Boolean genesis__Filter_By_Loan_Amount__c;
    /* If checked, Term will be considered while filtering the available pricing options else not.
    */
    global Boolean genesis__Filter_By_Term__c;
    global String genesis__Product_Type__c;
    /* Start date of the rate card.
    */
    global Date genesis__Start_Date__c;
    /* Transaction date of the rate card.
    */
    global Date genesis__Transaction_Date__c;
    global Double genesis__Additional_Determining_Factors_Count__c;
    global String External_Id__c;
    global clcommon__Company__c genesis__CL_Company__r;
    global Id genesis__CL_Company__c;
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
    global List<clcommon__Agreement__c> Program_Agreements__r;
    global List<genesis__Additional_Determining_Factor__c> genesis__Additional_Determining_Factor__r;
    global List<genesis__Product_Rate_Card_Association__c> genesis__Product_Rate_Card_Association__r;
    global List<genesis__Program_Vendor_Rate_Card_Association__c> genesis__Program_Vendor_Rate_Card_Associations__r;
    global List<genesis__Purpose_Rate_Card_Association__c> genesis__Purpose_Rate_Card_Associations__r;
    global List<genesis__Rate_Card_Setup_Detail__c> genesis__Rate_Card_Setup_Details__r;
    global List<genesis__Rate_Card_Setup_Header__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Rate_Card_Setup_Header__c () 
    {
    }
}