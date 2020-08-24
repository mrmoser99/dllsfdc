// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class genesis__Employment_Information__c {
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
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global Contact genesis__Contact__r;
    global Id genesis__Contact__c;
    global String genesis__Employer_City__c;
    global String genesis__Employer_Country__c;
    global String genesis__Employer_State__c;
    global String genesis__Employer_Street__c;
    global String genesis__Employer_Zipcode__c;
    global String genesis__Name_of_employer__c;
    global Double genesis__Number_of_years_on_job__c;
    global String genesis__Phone__c;
    global String genesis__Position__c;
    global Boolean genesis__Self_Employed__c;
    global String genesis__Type_of_business__c;
    global Decimal genesis__Average_Monthly_Income__c;
    global Date genesis__End_Date__c;
    global Boolean genesis__Is_Current_Employer__c;
    global String genesis__Occupation__c;
    global Date genesis__Start_Date__c;
    /* This will store the address line 2 of the Employer's address.
    */
    global String genesis__Address_Line_2__c;
    /* This will capture the postal code of the employer, if the employer is not a local address.
    */
    global String genesis__Foriegn_City_Postal_Code__c;
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
    global List<genesis__Employment_Information__Share> Shares;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global genesis__Employment_Information__c () 
    {
    }
}