public class ICVAsyncRemoveParty implements Queueable, Database.AllowsCallouts {
    
    private String myISODateTime = string.valueOf(json.serialize(datetime.now()));
    private String quoteId,reason;
    public  ICVAsyncRemoveParty(String quoteId, String reason) 
    {
        this.quoteId = quoteId;
        this.reason = reason;
    }
    
    public void execute(QueueableContext context) {
    	
    								
		ICVUtility.removeParty(quoteId,reason);				
    	
    	system.debug('Execute Remove Party Performed for ' + system.now());
    	
    	if (!Test.isRunningTest()){ 

    		ICVAsyncBookUpfrontTax job = new ICVAsyncBookUpfrontTax(quoteId);
        	System.enqueueJob(job);
    	} 	
    }
    
}