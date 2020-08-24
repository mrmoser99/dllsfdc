// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Asset_workbench__c {
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
    global Contact cllease__Agent__r;
    global Id cllease__Agent__c;
    global String cllease__Asset_Condition__c;
    global String cllease__Comments__c;
    global cllease__Contract_Equipment__c cllease__Contract_Equipment__r;
    global Id cllease__Contract_Equipment__c;
    global cllease__Lease_Account__c cllease__Contract__r;
    global Id cllease__Contract__c;
    global Account cllease__Customer__r;
    global Id cllease__Customer__c;
    global Date cllease__Date_Returned__c;
    global Contact cllease__Inspector__r;
    global Id cllease__Inspector__c;
    global String cllease__LeaseApplicationNumber__c;
    global Date cllease__Reported_on__c;
    global String cllease__Return_Status__c;
    global String cllease__Seller_Email__c;
    global String cllease__Seller_Phone__c;
    global Contact cllease__Seller__r;
    global Id cllease__Seller__c;
    global String cllease__Serial_Number__c;
    global String cllease__Type__c;
    global Boolean cllease__Voluntary__c;
    global String Agent_E_mail__c;
    global String Agent_Phone__c;
    global String Asset_Manager__c;
    global String Buyer_Source__c;
    global String Contract_Equipment_Return_Status__c;
    /* Date the equipment was sold.
    */
    global Date Date_Sold__c;
    global String Equipment_Description__c;
    global String Equipment_Manufacturer__c;
    global String Equipment_Model__c;
    global String Equipment_Serial_Number__c;
    global String Inspector__c;
    /* Date the Inspector was notified to inspect the equipment.
    */
    global Date Notified_on__c;
    /* Check to process multiple assets at the same time.
    */
    global Boolean Process_Asset_Sale__c;
    global Account Repossession_Agent__r;
    global Id Repossession_Agent__c;
    global cllease__Asset_Return__c Return_ID__r;
    global Id Return_ID__c;
    global String Return_Location__c;
    global Date Returned_Date__c;
    /* Sale price of the equipment.
    */
    global Decimal Sale_Price__c;
    global String Seller_E_mail__c;
    global String Seller_Phone__c;
    global Account Seller__r;
    global Id Seller__c;
    /* Business or person who purchased the equipment.
    */
    global Account Sold_To__r;
    /* Business or person who purchased the equipment.
    */
    global Id Sold_To__c;
    global clcommon__Equipment_Detail__c cllease__Equipment_Detail__r;
    global Id cllease__Equipment_Detail__c;
    global clcommon__Cash_Receipt__c cllease__Cash_Receipt__r;
    global Id cllease__Cash_Receipt__c;
    global cllease__Contract_Equipment__c cllease__Equipment_Contract__r;
    global Id cllease__Equipment_Contract__c;
    global clcommon__Collateral__c cllease__Equipment__r;
    global Id cllease__Equipment__c;
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
    global List<cllease__Asset_Part_detail_Record__c> cllease__Asset_Part_detail_Record__r;
    global List<cllease__Asset_workbench__Share> Shares;
    global List<cllease__Other_Transaction__c> Other_Transactions__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global cllease__Asset_workbench__c () 
    {
    }
}