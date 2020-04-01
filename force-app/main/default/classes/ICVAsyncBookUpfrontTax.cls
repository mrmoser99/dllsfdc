/*******************************************************************************************************************
*   Book Upfront Tax
*	Change Log:
*	10/1/18 - MRM Created
*   3/31/2020 - MRM added book upfront tax call
*   
********************************************************************************************************************/
public class ICVAsyncBookUpfrontTax implements Queueable, Database.AllowsCallouts  {
     
    private String quoteId;
	
	//Constructor   
    public  ICVAsyncBookUpfrontTax(String quoteId) 
    {
        this.quoteId = quoteId;
    }
    //Execute
    public void execute(QueueableContext context) {
        
        system.debug('*** quote Id is: ' + quoteId);

        genesis__Quick_Quotes__c q = [
    								Select
    								  Name
    								  ,genesis__Application__c
    								From genesis__Quick_Quotes__c
    								where id = :quoteId
                                    ];
                                    
        genesis__Applications__c app = [ 
    								Select
    								  Name
    								From genesis__Applications__c g
    								where id = :q.genesis__Application__c
                                    ];			
                                    	
    	VertexUpfrontTaxCalculation.VertexGetUpfrontTaxBook(app.name);
    	
    }
    
}