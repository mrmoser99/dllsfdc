// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ints__Credit_Report__c {
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
    global Account ints__Account__r;
    global Id ints__Account__c;
    global Contact ints__Contact__r;
    global Id ints__Contact__c;
    global String ints__CreditBureauName__c;
    global String ints__CreditRatingCodeType__c;
    global Date ints__CreditReportFirstIssuedDate__c;
    global String ints__CreditReportIdentifier__c;
    global Date ints__CreditReportLastUpdatedDate__c;
    global String ints__CreditReportMergeType__c;
    global String ints__CreditReportType__c;
    global String ints__Credit_Report_Attachment__c;
    global String ints__Credit_Repository__c;
    global Datetime ints__ResponseDateTime__c;
    global genesis__Applications__c genesis__Applications__r;
    global Id genesis__Applications__c;
    /* Total Number of Bankrupties
    */
    global Double genesis__Bankruptcies__c;
    /* Total Number of Closed Accounts
    */
    global Double genesis__Closed_Accounts__c;
    /* Cumulative Charge Off Amount
    */
    global Decimal genesis__Cumulative_Charge_Off_Amount__c;
    /* Number of Delinquecies
    */
    global Double genesis__Delinquencies__c;
    /* 10.	Delinquent Child Support Amount (currently used)
    */
    global Decimal genesis__Delinquent_Child_Support_Amount__c;
    /* Dismissed Bankruptcy (currently used)
    */
    global Decimal genesis__Dismissed_Bankruptcy_Currently_Used__c;
    /* Dismissed Bankruptcy Date
    */
    global Date genesis__Dismissed_Bankruptcy_Date__c;
    /* Fico Score
    */
    global Double genesis__Fico_Score__c;
    /* Involuntary Repossession (currently used)
    */
    global Decimal genesis__Involuntary_Repossession__c;
    /* Number of Total Open Accounts
    */
    global Double genesis__Open_Accounts__c;
    /* Open Bankruptcy (currently used)
    */
    global Decimal genesis__Open_Bankruptcy_Currently_Used__c;
    /* Open Bankruptcy Date
    */
    global Date genesis__Open_Bankruptcy_Date__c;
    /* Vehicle Charge Off(currently used)
    */
    global Decimal genesis__Vehicle_Charge_Off_Currently_Used__c;
    global Double genesis__FICO__c;
    global Double ints__Age_of_Credit_History_Months__c;
    global Double ints__Charge_Off__c;
    global Double ints__Collections__c;
    global Double ints__Enquiry_Count_in_Last_6_Months__c;
    global Double ints__Number_of_Tradelines__c;
    global Double ints__Number_of_Tradelines_open_longer_than_12__c;
    /* Total of Unpaid Balance from Liabilities.
    */
    global Decimal ints__Total_Debt__c;
    /* Total Monthly Payment Amount from Liabilities.
    */
    global Decimal ints__Total_Monthly_Payment__c;
    global Double genesis__Applicants_Debt_to_Income__c;
    /* Balance Available on Major Credit Cards
    */
    global Decimal genesis__Balance_Available_Major_Cards__c;
    /* Balance on Instalment  Accounts (Mortgages Excluded)
    */
    global Decimal genesis__Balance_on_Instalment_Accounts__c;
    /* Credit Counseling on Open Account
    */
    global Boolean genesis__Credit_Counseling_on_Open_Account__c;
    /* Credit Depth (Date of Oldest Trade Line)
    */
    global Date genesis__Credit_Depth__c;
    /* Discharged Bankruptcy Date
    */
    global Date genesis__Discharged_Bankruptcy_Date__c;
    /* Discharged Bankruptcy
    */
    global Decimal genesis__Discharged_Bankruptcy__c;
    /* Credit Available on Major Credit Cards
    */
    global Decimal genesis__High_Credit_Available_Major_Cards__c;
    /* High Credit on Instalment Accounts (Mortgages Excluded)
    */
    global Decimal genesis__High_Credit_on_Instalment_Accounts__c;
    /* Is there a Voluntary Repossession?
    */
    global Boolean genesis__Is_Voluntary_Repossession__c;
    /* Mortgage Balance
    */
    global Decimal genesis__Mortgage_Balance__c;
    /* Number of Charge Off Accounts
    */
    global Double genesis__Number_of_Charge_Off_Accounts__c;
    /* Number of Inquiries in the past 6 Months
    */
    global Double genesis__Number_of_Inquiries_in_past_6_Months__c;
    /* Number of Major Credit Cards (AMEX, Mastercard, Visa, Discover)
    */
    global Double genesis__Number_of_Major_Credit_Cards__c;
    /* Number of Now Derogatory Trade Lines
    */
    global Double genesis__Number_of_Now_Derogatory_Trade_Lines__c;
    /* Number of Open Instalment Accounts (Mortgages Excluded)
    */
    global Double genesis__Number_of_Open_Instalment_Accounts__c;
    /* Number of Open Satisfactory Accounts
    */
    global Double genesis__Number_of_Open_Satisfactory_Accounts__c;
    /* Original Mortgage Balance
    */
    global Decimal genesis__Original_Mortgage_Balance__c;
    /* Revolving  % Available
    */
    global Double genesis__Reveolving_Percent_Available__c;
    /* Revolving Total $$
    */
    global Decimal genesis__Revolving_Total__c;
    /* Total Balance on Open Accounts
    */
    global Decimal genesis__Total_Balance_on_Open_Accounts__c;
    /* Total Monthly Payment on Open Accounts
    */
    global Decimal genesis__Total_Monthly_Payment_on_Open_Accounts__c;
    /* Total Number of Trade Lines
    */
    global Double genesis__Total_Number_of_Trade_Lines__c;
    /* Total Unpaid Judgement(s) Amount
    */
    global Decimal genesis__Total_Unpaid_Judgement_s_Amount__c;
    /* Total Unpaid Lien(s) Amount
    */
    global Decimal genesis__Total_Unpaid_Lien_s_Amount__c;
    global Double genesis__Public_Record_Count__c;
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
    global List<clcommon__Party__c> genesis__Parties__r;
    global List<genesis__Application_Parties__c> genesis__Party_s_Credit_report__r;
    global List<ints__Credit_File__c> ints__Credit_Files1__r;
    global List<ints__Credit_Public_Record__c> ints__CreditPublicRecord__r;
    global List<ints__Credit_Regulatory_Product__c> ints__Regulatory_Products__r;
    global List<ints__Credit_Report_Inquiry__c> ints__CreditReportInquiry__r;
    global List<ints__Credit_Report_Key__c> ints__CreditRecordKey__r;
    global List<ints__Credit_Report_Liability__c> ints__CreditReportLiability__r;
    global List<ints__Credit_Report_Score__c> ints__CreditReportScore__r;
    global List<ints__Credit_Report__Share> Shares;
    global List<ints__Credit_Summary__c> ints__CreditSummary__r;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global ints__Credit_Report__c () 
    {
    }
}