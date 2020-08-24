// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class clcommon__External_Batch_Job_Settings__mdt {
    global Id Id;
    global String DeveloperName;
    global String MasterLabel;
    global String Language;
    global String NamespacePrefix;
    global String Label;
    global String QualifiedApiName;
    /* The environment name for the tenant
    */
    global String clcommon__Environment_Name__c;
    /* Indicates if this is a production or a sandbox environment
    */
    global Boolean clcommon__Production_Environment__c;
    /* The name of the tenant running the external batch job
    */
    global String clcommon__Tenant_Name__c;

    global clcommon__External_Batch_Job_Settings__mdt () 
    {
    }
}