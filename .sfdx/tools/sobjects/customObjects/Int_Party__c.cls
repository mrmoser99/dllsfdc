// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Int_Party__c {
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
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global String Applicable_Default_Reason_Code__c;
    global Decimal Basel_Classification_Amount__c;
    global String Basel_Classification__c;
    global Boolean Committed__c;
    global Decimal Consolidated_Turnover_Amount__c;
    global String Default_Determination_Code__c;
    global String Delinquency_Reason_Code__c;
    global String Individual_Indicator__c;
    global String Industry_Code__c;
    global String Industry_Type_Code__c;
    global String LE_Size__c;
    global String Legal_Form_Code__c;
    global Date Legal_Proceedings_Initiation_Date__c;
    global String Legal_Proceedings_Status_Code__c;
    global String Loan_Quality_Classification_Code__c;
    global String PD_LookupType__c;
    global Double PD_Percentage__c;
    global String PD_Rating_Model__c;
    global Date PD_Rating_Score_Date__c;
    global String PD_Rating_Score__c;
    global Date PD_Review_Date__c;
    global String Party_Contract_Name__c;
    global String Party_Name__c;
    global String Party_Number__c;
    global String Party_Source_System__c;
    global String Rabobank_Risk_Rating__c;
    global List<ActivityHistory> ActivityHistories;
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
    global List<Event> Events;
    global List<Int_Agreement_Party__c> Int_Agreements_Parties__r;
    global List<Int_Collateral_Party__c> Int_Collaterals_Parties__r;
    global List<Int_Facility_Party__c> Int_Facility_Parties__r;
    global List<Int_Party_External_Reference__c> Int_Party_External_References__r;
    global List<Int_Party_Feature__c> Int_Party_Features__r;
    global List<Int_Party_Street_Address__c> Int_Party_Street_Addresses__r;
    global List<Int_Party__History> Histories;
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
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskChangeEvent> What;

    global Int_Party__c () 
    {
    }
}