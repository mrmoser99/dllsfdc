@isTest(SeeALLData=true)
public class TestPMCalloutUtility {
    
	  public static testMethod void test1() {
	  	
	  		
          PM_Controller.searchPortfolio(''
                                    , ''
                                    , ''
                                    , 20
                                    , ''
                                    , true
                                    , 1
                                    , false  
        );

	  }
      public static testMethod void test2() {
          
        List<PMUtility.Data>  dataList = new List<PMUtility.Data>();
        PMUtility.Data data = new PMUtility.Data();

        PMUtility.ServiceContractData scd = new PMUtility.ServiceContractData();
        scd.data = new List<PMUtility.Data>();
        data.contractNumber = '1234544';
        scd.data.add(data);

        PM_Controller.getLeaseDetailsLeaseFirst(JSON.serialize(scd));
        PM_Controller.getLeaseDetails(JSON.serialize(scd));

	  }

    public static testMethod void test3() {

        User u = [select id,contactId, contact.accountId from User where contactId != null and isactive = true limit 1];

        System.runAs(u) {
            
           PMUtility.getAccessToken();

        }


    }

    public static testMethod void test4() {

       PM_Controller.generateQuotes('lease');
       PMCalloutUtility.generateQuoteByType('Lease','TRADEUP_WITHOUT_PURCHASE');

       PMUtility.TerminationQuoteResponse qResponse = new PMUtility.TerminationQuoteResponse();
       PMUtility.Quote q = new PMUtility.Quote();
               
       q.quoteCalculationDescription = 'test';
       q.quoteNumber = '1';
       q.terminationQuoteType = 'none';
       q.quoteValidityDate = '2023-10-10';
       q.quoteMessage = 'none';
       q.remainingRentalPayments = '0';
       q.discount = '0';
       q.equipmentPrice = '0';
       q.salesTax ='0';
       q.propertyTax= '0';      
       q.leaseCharges ='0';
       q.securityDeposit ='0' ;
       q.amount= '0';
       q.pastDueService= '0';
       qResponse.quotes = new List<PMUtility.Quote>();
       qResponse.quotes.add(q);
       Lease_OLM_Quote__c l = PMCalloutUtility.popluateLeaseQuote(qResponse);
    }
	  
	
}