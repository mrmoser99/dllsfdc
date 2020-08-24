// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class cllease__Avalara_API_Credential__mdt {
    global Id Id;
    global String DeveloperName;
    global String MasterLabel;
    global String Language;
    global String NamespacePrefix;
    global String Label;
    global String QualifiedApiName;
    /* This field stores the API Endpoint URL for Avalara Batch File Fetch HTTP Request
    */
    global String cllease__Avalara_Batch_File_Fetch_Request_URL__c;
    /* This value stores the Avalara Batch SVC Request End point URL
    */
    global String cllease__Avalara_Batch_Save_Request_URL__c;
    /* Company code of the created company in Avalara
    */
    global String cllease__Avalara_Company_Code__c;
    /* Company ID present in Avalara
    */
    global String cllease__Avalara_Company_ID__c;
    /* ID of the user created in Avalara
    */
    global String cllease__Avalara_Created_User_ID__c;
    /* This field carries the User Password / License Key provided by Avalara
    */
    global String cllease__Avalara_Password__c;
    /* This field stores the avalara request Client Software Package Name
    */
    global String cllease__Avalara_Request_Client__c;
    /* Account ID provided by Avalara
    */
    global String cllease__Avalara_User_Account_ID__c;
    /* Username or Account number from Avalara
    */
    global String cllease__Avalara__c;

    global cllease__Avalara_API_Credential__mdt () 
    {
    }
}