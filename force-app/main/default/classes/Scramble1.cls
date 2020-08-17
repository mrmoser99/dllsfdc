/*******************************************************************************************************************
*   Scramble1 - This kicks of the scramble process for refresh
* 
*	Change Log: 
*	7/21/2020 - MRM Created
* 
********************************************************************************************************************/
public class Scramble1 implements Queueable, Database.AllowsCallouts {
    
    private String myISODateTime = string.valueOf(json.serialize(datetime.now()));
    private String leaseId;
    public  Scramble1()
    {
       
    }

    /*
    In all Newco/CLS non-production environments - please obfuscate the following:
	Remove or scramble all Lease Signer Names
	Remove or scramble all First Names
	Remove or scramble all Last Names
	Remove or scramble all email addresses so they are invalid and undeliverable (Company or individual)
	Remove or scramble all phone numbers (000-000-0000) (company or individual)
	Remove or scramble all credit scoring fields (including Credit Rating, credit Score…and any other fields returned from scoring)
    */
    
    public void execute(QueueableContext context) {
    	
        List<Account>  aList = [select id from Account 	];
     
    									
        if (System.Label.Environment == 'PROD') 
            return;  //no accidental prod scramble

        for (Account a:aList){
            a.clcommon__Email__c = 'test@test.com.invalid';
            a.cnotify__email__c = 'test@test.com.invalid';
            a.ints__email__c = 'test@test.com.invalid';
            a.email_address__c = 'test@test.com.invalid';
            a.phone = '8005210001';
        }

        update aList;
    
       
       

        if (!test.isRunningTest()){
	        Scramble2 job = new Scramble2();
            System.enqueueJob(job);	 
        }  
			   
    } 
    
}