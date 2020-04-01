public class ICVAsyncRemoveCommitment implements Queueable, Database.AllowsCallouts {
    
    private String myISODateTime = string.valueOf(json.serialize(datetime.now()));
    private String quoteId,reason;
    public  ICVAsyncRemoveCommitment(String quoteId,String reason) 
    {
        this.quoteId = quoteId; 
        this.reason = reason;
    }
    
    public void execute(QueueableContext context) {
    	 
    	
    	genesis__Quick_Quotes__c q = [
    								Select
    								  Name
    								  ,genesis__account__c
    								From genesis__Quick_Quotes__c
    								where id = :quoteId
    								];
    								
		ICVUtility.removeCommitment(q.name,reason);				
    	
    	system.debug('Execute Remove Commitment Performed for ' + system.now());
    	
    	//if remove is called from booking, and the account number is null that means that a QT-xxxx party was added; so remove it
    	
    	if (!Test.isRunningTest()){
    		if (reason == 'Book'){
    			if (q.genesis__account__c == null){
    				ICVAsyncRemoveParty job = new ICVAsyncRemoveParty(quoteId,reason);
        			System.enqueueJob(job);	
				}
				else{
					ICVAsyncBookUpfrontTax job = new ICVAsyncBookUpfrontTax(quoteId);
					System.enqueueJob(job);
				}
    		}
    		else{
    			if (q.genesis__account__c == null){
    				ICVAsyncRemoveParty job = new ICVAsyncRemoveParty(quoteId,reason);
        			System.enqueueJob(job);
				}
				else{
					ICVAsyncBookUpfrontTax job = new ICVAsyncBookUpfrontTax(quoteId);
					System.enqueueJob(job);
				
				}	
    		}
    		
		}
		
		
	}
    
}