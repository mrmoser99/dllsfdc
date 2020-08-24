// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Int_OLMN_Accounting_Entry__c {
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
    global Double Accounted_Cr__c;
    global Double Accounted_Dr__c;
    global String Accounting_Date__c;
    global String Asset_Number__c;
    global String Batch_Description__c;
    global String Batch_Name__c;
    global Boolean Committed__c;
    global String Concatenated_Segments__c;
    global String Contract_Number__c;
    global String Fin_Product__c;
    global String Foreign_SubSystem_Id__c;
    global String GL_Entry_Id__c;
    global String Journal_Category_Desc__c;
    global String Journal_Category__c;
    global Double Journal_Entry_Number__c;
    global String Journal_Source__c;
    global String Period_Name__c;
    global String Posting_Date__c;
    global String Transaction_Number__c;
    /* This field helps in storing Fee's name when type is charge.This is interface table mapping field.
    */
    global String Transaction_Sub_Type__c;
    global String Vendor_Program__c;
    global Double Month__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Int_OLMN_Accounting_Entry__Share> Shares;
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

    global Int_OLMN_Accounting_Entry__c () 
    {
    }
}