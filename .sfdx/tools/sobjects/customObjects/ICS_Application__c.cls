// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ICS_Application__c {
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
    global Date LastActivityDate;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global String Address_Line__c;
    global String App_Scoring_Link__c;
    global String Applied_EAD_Treatment__c;
    global String CRE_Status__c;
    global Boolean Cherry_Picking_Flag__c;
    global String City__c;
    global String Commitment_Link__c;
    global String Country_Code__c;
    global Datetime Credit_Wait__c;
    global Boolean Currently_In_Default__c;
    global Date Default_Date__c;
    global Boolean Error__c;
    global String Exposure_Class__c;
    global Decimal Financed_Amount_EUR__c;
    global String Initial_Default_Reason__c;
    global String KYC_Code__c;
    global String KYC_Reason__c;
    global String KYC_Source__c;
    global Boolean KYC__c;
    global String Legal_Entity_Id__c;
    global String Legal_Entity_Link__c;
    global String Legal_Name__c;
    global Decimal Manual_Approval_Limit__c;
    global String Master_Scale_Rating__c;
    global String Message_Id__c;
    global String PD_Lookup_Type__c;
    global Boolean PD_Penalty_Flag__c;
    global Double PD_Percent__c;
    global Date PD_Rating_Date__c;
    global String PD_Rating_Model__c;
    global String PD_Rating_Score__c;
    global String PD_Required_Treatment__c;
    global Decimal PD_Treatment_Exposure_Amount_EUR__c;
    global String PD_Vintage__c;
    global String Phone_Type__c;
    global String Phone__c;
    global String Postal_Code__c;
    global String Quick_Quote_Name__c;
    global String Quick_Quote_Phone__c;
    global genesis__Quick_Quotes__c Quick_Quote__r;
    global Id Quick_Quote__c;
    global String Quote_Adddress_Line__c;
    global String Quote_City__c;
    global String Quote_Country_Code__c;
    global String Quote_Postal_Code__c;
    global String Quote_State_Province_Code__c;
    global String Rabobank_Masterscale_Rating__c;
    global String Risk_Grade_Rating__c;
    global String Score_Decision__c;
    global String State_Province_Code__c;
    global String Status__c;
    global Decimal System_Approval_Limit__c;
    global String System_Decision__c;
    global String Transaction_Id__c;
    global String E_Status_Error_Message__c;
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
    global List<ICS_Additional_History__c> ICS_Additional_History__r;
    global List<ICS_Application__History> Histories;
    global List<ICS_Decision_Reason__c> ICS_Decision_Reasons__r;
    global List<ICS_External_Legal_Entity__c> ICS_External_Legal_Entities__r;
    global List<ICS_Multiple_Year_EAD__c> ICS_Multiple_Year_EAD1__r;
    global List<ICS_Multiple_Year_EL__c> ICS_Multiple_Year_EL__r;
    global List<ICS_Multiple_Year_LGD__c> ICS_Multiple_Year_LGD__r;
    global List<ICS_Multiple_Year_PD__c> ICS_Multiple_Year_PD__r;
    global List<ICS_Scorecard_Result__c> ICS_Scorecard_Results__r;
    global List<ICV_Commitment_LE__c> ICV_Commitment_LEs__r;
    global List<ICV_Contract_Performance__c> ICV_Contract_Performance__r;
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

    global ICS_Application__c () 
    {
    }
}