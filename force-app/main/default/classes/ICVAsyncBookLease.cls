/*******************************************************************************************************************
*   This service is used to process the workflow for booking a lease.
*	1.  Add Party (Lease Number)
*	2.  Add Commitment (Lease Number)
	3.  Put sic code on account level
*	4. 	Delete Quick Quote Commitment
*	5.  Delete Quick Quote Party
*	6.  Book Upfront Tax
*	
*	Change Log:
*	10/1/18 - MRM Created
*   3/31/2020 - MRM added book upfront tax
*   
********************************************************************************************************************/
public class ICVAsyncBookLease implements Queueable, Database.AllowsCallouts  {
     
    private String leaseId;
	
	//Constructor   
    public  ICVAsyncBookLease(String leaseId) 
    {
        this.leaseId = leaseId;
    }
    //Execute
    public void execute(QueueableContext context) {
    	
    	
    	cllease__Lease_Account__c  l = [select 
    									 application_number__c
    									,cllease__Account__c
    									from cllease__Lease_Account__c 
    									where id = :leaseId	
    									];
    	
    	genesis__Applications__c app = [ 
    								Select
    								  Name
    								, genesis__quick_quote__c
    								, genesis__quick_quote__r.name
    								, genesis__quick_quote__r.with_account__c
    								From genesis__Applications__c g
    								where name = :l.application_number__c
    								];				
    	system.debug('Execute Add Party Performed for ' + system.now());
    	
    	/* update the sic code on the account */
    	 
    	Map<String,String> lMap = new Map<String,String>();
    	lMap.put('leaseid',leaseId);
    	
    	 
    	
    	
    	system.debug('************ ready to add party - l');
    	system.debug('app with account:' + app.genesis__quick_quote__r.with_account__c);
    	
    	if (app.genesis__quick_quote__r.with_account__c == false){ //if with account then proper party was already added
    		system.debug('adding party for the lease');
    	 	ICVUtility.addParty(leaseId,'L');
    	}

		/* call supertrump */
		Map<ID,String> leaseMap = new Map<ID,String>();
        leasemap.put(leaseId,'hello');
        supertrumputil.sendRequest(leaseMap);
    	
		system.debug('made it to here'); 
    	if (!Test.isRunningTest()){ 
    		ICVAsyncAddCommitment job = new ICVAsyncAddCommitment(leaseId);
        	System.enqueueJob(job);
    	} 	
		
		
    	
    	ICVUtility.setSICCode(lMap);   
    }
    
}