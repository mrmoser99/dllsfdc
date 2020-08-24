// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__Equipment__c {
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
    /* Initially it will be same as purchased price and on equipment depreciation this field will be updated to ending NBV
    */
    global Decimal clcommon__Book_Value__c;
    global String clcommon__Dealer_Funding_Status__c;
    global Decimal clcommon__Depreciation_Basis_Amount__c;
    global clcommon__Warehouse_Depreciation_Setup__c clcommon__Depreciation_Method__r;
    global Id clcommon__Depreciation_Method__c;
    /* From this date onward the equipment will start depreciating. If empty will be defaulted to purchased date.
    */
    global Date clcommon__Depreciation_Start_Date__c;
    global Decimal clcommon__Depreciation_Value__c;
    /* Can be used to store information about the equipment
    */
    global String clcommon__Equipment_Description__c;
    /* e.g if an equipment life time is for an year then user should record it as 12 (months count)
    */
    global Double clcommon__Equipment_Life_in_Months__c;
    global Decimal clcommon__Equipment_NBV__c;
    global String clcommon__Equipment_Name__c;
    global String clcommon__Equipment_Type__c;
    global Boolean clcommon__Generate_Book_Depreciation__c;
    global Decimal clcommon__Left_Over_Depreciation_Value__c;
    global Date clcommon__Next_Depreciation_Date__c;
    global Decimal clcommon__Prorated_Depreciation_Balance__c;
    global Date clcommon__Purchased_Date__c;
    global Decimal clcommon__Purchased_Price__c;
    global Decimal clcommon__Salvage_Value__c;
    global String clcommon__Serial_Number__c;
    global String clcommon__Status__c;
    global Decimal clcommon__Subsidy__c;
    global Decimal clcommon__Subvention__c;
    global String clcommon__Vehicle_Identification_Number__c;
    global Boolean cllease__In_Partial_Contract__c;
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
    global List<clcommon__Book_Depreciation_Stream__c> clcommon__Book_Depreciation_Streams__r;
    global List<clcommon__Dealer_Funding_Detail__c> clcommon__Dealer_Funding_Details__r;
    global List<clcommon__Depreciation_Stream__c> clcommon__Depreciation_Streams__r;
    global List<clcommon__Equipment_Transaction__c> clcommon__Equipment_Transactions__r;
    global List<clcommon__Equipment_Values_Adjustment__c> clcommon__Equipment_Values_Adjustments__r;
    global List<clcommon__Equipment__History> Histories;
    global List<clcommon__Equipment__Share> Shares;
    global List<clcommon__Sell_Equipment__c> clcommon__Sell_Equipments__r;
    global List<cllease__Contract_Equipment__c> cllease__Equipment__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global clcommon__Equipment__c () 
    {
    }
}