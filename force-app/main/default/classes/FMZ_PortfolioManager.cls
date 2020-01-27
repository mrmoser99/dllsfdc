/*****************************************************************************************************

Change Log:

1/27/20 - Removed email from going to sam at fortimize.  Added orgwide email id


***************************************************************************************************** */

public class FMZ_PortfolioManager {
    @AuraEnabled 
     public static PMUtility.ServiceContractData getData (String customerName
                                    , String contractNumber
                                    , String assetSerialNumber
                                    , Integer size
                                    , String sortOrder
                                    , Boolean assetDetail
                                    , Integer page
                                    , Boolean disableLogging) {
        PMUtility.ServiceContractData response = new PMUtility.ServiceContractData();

        response = PMCalloutUtility.searchPortfolio(customerName, contractNumber, assetSerialNumber, size, sortOrder, assetDetail, page, disableLogging);
        
        return response;

    }
    // Tear Sheet
    @AuraEnabled 
     public static String getLeaseDetails (String leaseNumber) {
        System.Debug('LEASE DETAILS');
        System.Debug(leaseNumber);
        String response;

        response = PMCalloutUtility.getLeaseDetails(leaseNumber);
        
        return response;

    }

    // Generate Quote by type
    @AuraEnabled
    public static PMUtility.TerminationQuoteResponse generateQuoteByType (String leaseNumber, String type, String customerName) {
        PMUtility.TerminationQuoteResponse response = new PMUtility.TerminationQuoteResponse();

        response = PMCalloutUtility.generateQuoteByType(leaseNumber, type, customerName);

        return response;
    }

    // Quote Details
   @AuraEnabled
    public static Lease_OLM_Quote__c getQuoteDetails (String quoteNumber) {
       // Lease_OLM_Quote__c response = Lease_OLM_Quote__c();

       Lease_OLM_Quote__c quote = [SELECT Id, Amount__c, Remaining_Rental_Payments__c, Discount__c, Equipment_Price__c, Sales_Tax__c, Property_Tax__c, Past_Due_Service__c, Lease_Charges__c, Security_Deposit__c, Quote_Validity_Date__c FROM Lease_OLM_Quote__c WHERE Name =: quoteNumber];

       return quote;

   }

   // Email TearSheet or Quote
   @AuraEnabled
   public static void emailTearSheetOrQuote (String subject, String body) {
        Id userId = UserInfo.getUserId();
        List<User> userList = [SELECT Name, Email FROM User WHERE Id =: userId];
       
        List<String> emailTo = new List<String>();
        List<String> emailCc = new List<String>();

        OrgWideEmailAddress ow = [select id
                                ,Address
                                ,DisplayName
                                from OrgWideEmailAddress 
                                where DisplayName = 'NewCo Customer Service'
                                ];

       


        //MRM removed this
        //emails.add('samantha.kemme@fortimize.com');

        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        emailTo.add(userList[0].Email);
        emailCc.add(ow.Address);
       
        mail.setCcAddresses(emailCc);
        mail.setToAddresses(emailTo);
        mail.setOrgWideEmailAddressId(ow.id);
        mail.setSubject(subject);
        mail.setHtmlBody(body);

        mails.add(mail);

        Messaging.sendEmail(mails);
   }

   // Email Support
   @AuraEnabled
   public static void emailSupport (String subject, String body) {
       Id userId = UserInfo.getUserId();
       List<User> userList = [SELECT Name, Email FROM User WHERE Id =: userId];
       FMZ_ENV_Variables__c supportEmails = [SELECT Support_Contacts__c FROM FMZ_ENV_Variables__c WHERE name = 'default'];
       List<String> emails = supportEmails.Support_Contacts__c.split(',');
       emails.add(userList[0].Email);

       List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();

       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       mail.setToAddresses(emails);
       mail.setReplyTo(userList[0].Email);
       mail.setSenderDisplayName(userList[0].Name);
       mail.setSubject(subject);
       mail.setHtmlBody(body);

       mails.add(mail);

       Messaging.sendEmail(mails);
   }

   // Requote Application
   @AuraEnabled
   public static void requoteApplication(Id applicationId, String leaseNumber, Decimal quoteAmount, String quoteNumber, Date quoteExpirationDate) {
    genesis__Applications__c app = [SELECT Id, genesis__Quick_Quote__r.Oracle_Trade_Up_Quote_Amount__c, genesis__Quick_Quote__r.Oracle_Trade_up_Quote_Expiration_Date__c, genesis__Quick_Quote__r.Oracle_Trade_up_Quote_Number__c, genesis__Quick_Quote__r.Name FROM genesis__Applications__c WHERE Id =: applicationId LIMIT 1];

    app.Oracle_Trade_up_Lease_Number__c = leaseNumber;
    app.Oracle_Trade_Up_Amount__c = quoteAmount;
    app.genesis__Other_Financed_Fees__c = quoteAmount;
    app.Oracle_Trade_up_Quote_Number__c = quoteNumber;
    app.Oracle_Trade_up_Quote_Expiration_Date__c = quoteExpirationDate;

    app.genesis__Quick_Quote__r.Oracle_Trade_Up_Quote_Amount__c = quoteAmount;
    app.genesis__Quick_Quote__r.Oracle_Trade_up_Quote_Expiration_Date__c = quoteExpirationDate;
    app.genesis__Quick_Quote__r.Oracle_Trade_up_Quote_Number__c = quoteNumber;

    update app;

    Lease_OLM_Quote__c quote = [SELECT Id FROM Lease_OLM_Quote__c WHERE Name =: quoteNumber LIMIT 1];
    quote.Quick_Quote_Number__c = app.genesis__Quick_Quote__r.Name;

    update quote;
   }

   // Get Settings
   @AuraEnabled
   public static FMZ_ENV_Variables__c getEnvVariables() {
    FMZ_ENV_Variables__c settings = [SELECT URL__c, Community_URL__c FROM FMZ_ENV_Variables__c WHERE Name = 'default'];

    return settings;
   }

   // Quote History
   @AuraEnabled
   public static List<Lease_OLM_Quote__c> getQuoteHistory(Integer pageSize, Integer offset, String customerName, String leaseNumber) {
       List<Lease_OLM_Quote__c> quoteList = new List<Lease_OLM_Quote__c>();

       Id userId = UserInfo.getUserId();
       User userInfo = [SELECT AccountId FROM User WHERE Id =: userId LIMIT 1];

       if (leaseNumber != '' && leaseNumber != null && customerName != '' && customerName != null) {
           String customerNameFilter = '%' + customerName + '%';
           quoteList = [SELECT Id, Name, Amount__c, Quick_Quote_Number__c, Contract_Number__c, Customer_Name__c, CreatedDate, Property_Tax__c, Discount__c, Equipment_Price__c, Lease_Charges__c, LS_Contract__c, Past_Due_Service__c, Quote_Message__c, Quote_Validity_Date__c, Remaining_Rental_Payments__c, Sales_Tax__c, Security_Deposit__c, Termination_Quote_Type__c FROM Lease_OLM_Quote__c WHERE Contract_Number__c =: leaseNumber AND Customer_Name__c LIKE: customerNameFilter AND (Account__c =: userInfo.AccountId OR OwnerId =: userId) ORDER BY CreatedDate DESC LIMIT :pageSize OFFSET :offset];
       }
       else if (customerName != '' && customerName != null) {
            String customerNameFilter = '%' + customerName + '%';
            quoteList = [SELECT Id, Name, Amount__c, Quick_Quote_Number__c, Contract_Number__c, Customer_Name__c, CreatedDate, Property_Tax__c, Discount__c, Equipment_Price__c, Lease_Charges__c, LS_Contract__c, Past_Due_Service__c, Quote_Message__c, Quote_Validity_Date__c, Remaining_Rental_Payments__c, Sales_Tax__c, Security_Deposit__c, Termination_Quote_Type__c FROM Lease_OLM_Quote__c WHERE Customer_Name__c LIKE: customerNameFilter AND (Account__c =: userInfo.AccountId OR OwnerId =: userId) ORDER BY CreatedDate DESC LIMIT :pageSize OFFSET :offset];
       }
        else if (leaseNumber != '' && leaseNumber != null) {
            quoteList = [SELECT Id, Name, Amount__c, Quick_Quote_Number__c, Contract_Number__c, Customer_Name__c, CreatedDate, Property_Tax__c, Discount__c, Equipment_Price__c, Lease_Charges__c, LS_Contract__c, Past_Due_Service__c, Quote_Message__c, Quote_Validity_Date__c, Remaining_Rental_Payments__c, Sales_Tax__c, Security_Deposit__c, Termination_Quote_Type__c FROM Lease_OLM_Quote__c WHERE Contract_Number__c =: leaseNumber AND (Account__c =: userInfo.AccountId OR OwnerId =: userId) ORDER BY CreatedDate DESC LIMIT :pageSize OFFSET :offset];
       } else {
            quoteList = [SELECT Id, Name, Amount__c, Quick_Quote_Number__c, Contract_Number__c, Customer_Name__c, CreatedDate, Property_Tax__c, Discount__c, Equipment_Price__c, Lease_Charges__c, LS_Contract__c, Past_Due_Service__c, Quote_Message__c, Quote_Validity_Date__c, Remaining_Rental_Payments__c, Sales_Tax__c, Security_Deposit__c, Termination_Quote_Type__c FROM Lease_OLM_Quote__c WHERE Account__c =: userInfo.AccountId OR OwnerId =: userId ORDER BY CreatedDate DESC LIMIT :pageSize OFFSET :offset];
       }

       return quoteList;
   }

   // Select Application from Trade Up Quote
   @AuraEnabled
   public static genesis__Quick_Quotes__c getQuickQuote(String leaseNumber) {
       List<genesis__Quick_Quotes__c> quote = [SELECT Id, Name, Quick_Quote_Number__c, Oracle_Trade_up_Quote_Expiration_Date__c, Oracle_Trade_up_Quote_Number__c FROM genesis__Quick_Quotes__c WHERE Oracle_Trade_up_Lease_Number__c =: leaseNumber LIMIT 1];

        if (quote.size() > 0) {
            return quote[0];
        }
        else {
            return null;
        }
   }
}