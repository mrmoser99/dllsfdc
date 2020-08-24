// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Application_Business_Information__c {
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
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    /* ABA_Routing_Number_Business
    */
    global String genesis__ABA_Routing_Number_Business__c;
    /* ABA_Routing_Number_Personal
    */
    global String genesis__ABA_Routing_Number_Personal__c;
    /* Account Number (Business)
    */
    global String genesis__Account_Number_Business__c;
    /* Account Number (Personal)
    */
    global String genesis__Account_Number_Personal__c;
    /* Address for Credit Card
    */
    global String genesis__Address_for_Credit_Card__c;
    /* Authority
    */
    global String genesis__Authority__c;
    /* Authorization Form on File
    */
    global Boolean genesis__Authorization_Form_on_File__c;
    /* Average Bank Balance (Business)
    */
    global Decimal genesis__Average_Bank_Balance_Business__c;
    /* Average Bank Balance (Personal)
    */
    global Decimal genesis__Average_Bank_Balance_Personal__c;
    /* Business Bank Name
    */
    global String genesis__Business_Bank_Name__c;
    /* Credit Card CVV Code
    */
    global String genesis__CVV_Code__c;
    /* Carrier / Borker
    */
    global String genesis__Carrier_Borker__c;
    /* Contract Details
    */
    global String genesis__Contract_Details__c;
    /* Credit Card Expiration Date
    */
    global Date genesis__Credit_Card_Expiration_Date__c;
    global String genesis__Credit_Card_Number__c;
    /* Credit Card Type
    */
    global String genesis__Credit_Card_Type__c;
    /* Current Balance (Business)
    */
    global Decimal genesis__Current_Balance_Business__c;
    /* Current Balance (Personal)
    */
    global Decimal genesis__Current_Balance_Personal__c;
    /* Current Monthly Vehicle Cost
    */
    global Decimal genesis__Current_Monthly_Vehicle_Cost__c;
    /* Do you have a Contract
    */
    global Boolean genesis__Do_you_have_a_Contract__c;
    /* Driver Name
    */
    global String genesis__Driver_Name__c;
    /* Driver Relationship to Owner
    */
    global String genesis__Driver_Relationship_to_Owner__c;
    /* Experience as Owner Operator (In Years)
    */
    global Double genesis__Experience_as_Owner_Operator__c;
    /* How Long Driving for Carrier
    */
    global Double genesis__How_Long_Driving_for_Carrier__c;
    /* How often does driver get paid
    */
    global String genesis__How_often_does_driver_get_paid__c;
    /* If Driver Relationship to Owner is Other, then please describe
    */
    global String genesis__If_Other_describe__c;
    /* If paid frequency is not provided then describe
    */
    global String genesis__If_paid_in_others_freq_describe__c;
    global Double genesis__Industry_Experience__c;
    /* Is Driver same as Owner?
    */
    global Boolean genesis__Is_Driver_same_as_Owner__c;
    /* Monthly revenue from Equipment
    */
    global Decimal genesis__Monthly_revenue_from_Equipment__c;
    /* Name on Account (Business)
    */
    global String genesis__Name_on_Account_Business__c;
    /* Name on Account (Personal)
    */
    global String genesis__Name_on_Account_Personal__c;
    /* Name on Credit Card
    */
    global String genesis__Name_on_Credit_Card__c;
    /* Number of Trucks in Fleet
    */
    global Double genesis__Number_of_Trucks_in_Fleet__c;
    /* Owner Operator
    */
    global String genesis__Owner_Operator__c;
    /* Personal Bank Name
    */
    global String genesis__Personal_Bank_Name__c;
    /* 3 Month Average Difference (Business)
    */
    global Decimal genesis__Three_Month_Average_Difference_Business__c;
    /* 3 Month Average Difference (Personal)
    */
    global Decimal genesis__Three_Month_Average_Difference_Personal__c;
    /* 3 Month Average Withdrawals (Business)
    */
    global Decimal genesis__Three_Month_Average_Withdrawals_Business__c;
    /* 3 Month Average Withdrawals (Personal)
    */
    global Decimal genesis__Three_Month_Average_Withdrawals_Personal__c;
    /* 3 Month Average Deposits (Business)
    */
    global Decimal genesis__Three_Months_Average_Deposits_Business__c;
    /* 3 Month Average Deposits (Personal)
    */
    global Decimal genesis__Three_Months_Average_Deposits_Personal__c;
    global Double genesis__Time_in_Business__c;
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

    global genesis__Application_Business_Information__c () 
    {
    }
}