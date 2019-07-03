public class SetOracleTradeUpFieldsFromQuickQuotes {
    public static void setTradevalues(List<genesis__Applications__c> app)
    {
        List<id> Quoteids = new List<id>();
        for(genesis__Applications__c a:app){
           Quoteids.add(a.genesis__Quick_Quote__c); 
        }
        system.debug('Quote nameeeeee'+Quoteids);
        map<id,genesis__Quick_Quotes__c> relatedQuoteDetails = new map<id,genesis__Quick_Quotes__c>([select id,Oracle_Trade_up_Lease_Number__c,Oracle_Trade_up_Quote_Number__c,Oracle_Trade_Up_Quote_Amount__c from genesis__Quick_Quotes__c where id IN :Quoteids ]);
          system.debug('Quote nameeeeee'+relatedQuoteDetails);
        for(genesis__Applications__c a : app){
            genesis__Quick_Quotes__c quote = relatedQuoteDetails.get(a.genesis__Quick_Quote__c);
            if(quote.Oracle_Trade_up_Lease_Number__c != null && quote.Oracle_Trade_up_Quote_Number__c !=null && quote.Oracle_Trade_Up_Quote_Amount__c!=null){
                a.Oracle_Trade_Up_Amount__c=quote.Oracle_Trade_Up_Quote_Amount__c;
				a.Oracle_Trade_up_Lease_Number__c=quote.Oracle_Trade_up_Lease_Number__c;
				a.Oracle_Trade_up_Quote_Number__c=quote.Oracle_Trade_up_Quote_Number__c;
            }
             system.debug('Quote nameeeeee'+a.Oracle_Trade_Up_Amount__c);
            
        }
    }

}