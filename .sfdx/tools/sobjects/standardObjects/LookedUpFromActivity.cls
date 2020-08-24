// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class LookedUpFromActivity {
    global Id Id;
    global Account Account;
    global Id AccountId;
    global SObject Who;
    global Id WhoId;
    global SObject What;
    global Id WhatId;
    global String Subject;
    global Boolean IsTask;
    global Date ActivityDate;
    global Datetime ActivityDateTime;
    global SObject Owner;
    global Id OwnerId;
    global String Status;
    global String Priority;
    global Boolean IsHighPriority;
    global String ActivityType;
    global Boolean IsClosed;
    global Boolean IsAllDayEvent;
    global Boolean IsVisibleInSelfService;
    global Integer DurationInMinutes;
    global String Location;
    global String Description;
    global Boolean IsDeleted;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global Integer CallDurationInSeconds;
    global String CallType;
    global String CallDisposition;
    global String CallObject;
    global Datetime ReminderDateTime;
    global Boolean IsReminderSet;
    global Datetime EndDateTime;
    global Datetime StartDateTime;
    global String ActivitySubtype;
    global genesis__Applications__c genesis__Application__r;
    global Id genesis__Application__c;
    global Boolean genesis__Completion_Mandatory__c;
    global genesis__Department__c genesis__Department__r;
    global Id genesis__Department__c;
    global Boolean genesis__Is_Parallel__c;
    global genesis__Task_Setup__c genesis__Task_Setup__r;
    global Id genesis__Task_Setup__c;
    global genesis__Application_Collateral__c genesis__Application_Collateral__r;
    global Id genesis__Application_Collateral__c;
    global clcommon__Party__c genesis__Party__r;
    global Id genesis__Party__c;
    global Double genesis__Task_Order__c;
    global User genesis__User__r;
    global Id genesis__User__c;
    /* This field keeps track of completed tasks which are archived due to backward department movement or release application to queue. Tasks are archived when retention of task is disabled on Task Setup
    */
    global Boolean genesis__Is_Archived__c;

    global LookedUpFromActivity () 
    {
    }
}