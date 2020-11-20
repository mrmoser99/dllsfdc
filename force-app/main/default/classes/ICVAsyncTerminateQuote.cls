/*******************************************************************************************************************
*   Terminate Old Lease for a particular tradeup quote
*	Change Log:
*	11/16/2020 - MRM Created
*   
*   
********************************************************************************************************************/
public class ICVAsyncTerminateQuote implements Queueable, Database.AllowsCallouts  {
     
    private String tradeUpQuoteName;
	
	//Constructor   
    public  ICVAsyncTerminateQuote(String tradeUpQuoteName) 
    {
        this.tradeUpQuoteName = tradeUpQuoteName;
    }
    //Execute
    public void execute(QueueableContext context) {
        system.debug('Terminating lease for quote: ' + tradeUpQuoteName);

        cllease__Termination_Quote_Header__c h = [select id
                                                from cllease__Termination_Quote_Header__c 
                                                where name = :tradeUpQuoteName];
        h.cllease__Status__c = 'Accepted';

        update h;

        CLLeaseTerminationQuoteServices.processTerminationQuote(h.id);

    }
}