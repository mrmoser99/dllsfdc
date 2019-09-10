@isTest(SeeALLData=true)
public with sharing class FMZ_PortfolioManagerTest {
    
    public static testMethod void getAccessTokenTest() {
        User u = [select id,contactId, contact.accountId from User where contactId != null and isactive = true limit 1];
        
        System.runAs(u) {
            
            PMUtility.getAccessToken();
            
        }       
    }
    
    public static testMethod void getDataTest() {
        PMUtility.ServiceContractData response = FMZ_PortfolioManager.getData('', '', '', 20, '', true, 1, false);
    }
    
    public static testMethod void getLeaseDetailsTest() {
        List<PMUtility.Data>  dataList = new List<PMUtility.Data>();
        PMUtility.Data data = new PMUtility.Data();
        PMUtility.ServiceContractData scd = new PMUtility.ServiceContractData();
        scd.data = new List<PMUtility.Data>();
        data.contractNumber = '1234544';
        scd.data.add(data);
        
        FMZ_PortfolioManager.getLeaseDetails(JSON.serialize(scd));
    }
    
    public static testMethod void generateQuoteTest() {
        PM_Controller.generateQuotes('123456');
        // FMZ_PortfolioManager.generateQuoteByType('123456','TRADEUP_WITHOUT_PURCHASE'); 
    }
    
    public static testMethod void emailTearSheetOrQuoteTest() {
        FMZ_PortfolioManager.emailTearSheetOrQuote('Subject', 'Body');
    }
    
    public static testMethod void emailSupportTest() {
        FMZ_PortfolioManager.emailSupport('Subject', 'Body');
    }
    
    //public static testMethod void requoteApplicationTest() {
    //    FMZ_PortfolioManager.requoteApplication('id', 'lease', 5000, 'quoteNumber', System.today());
    //}
    
    public static testMethod void getEnvVariablesTest() {       
        FMZ_PortfolioManager.getEnvVariables();
    }
    
    public static testMethod void getQuoteHistoryTest() {
        FMZ_PortfolioManager.getQuoteHistory(20, 0, '', '');
        FMZ_PortfolioManager.getQuoteHistory(20, 0, '', 'lease');
        FMZ_PortfolioManager.getQuoteHistory(20, 0, 'abc', 'lease');
        FMZ_PortfolioManager.getQuoteHistory(20, 0, 'abc', '');
    }
    
    public static testMethod void getQuickQuote() {
        FMZ_PortfolioManager.getQuickQuote('lease');
    }
}