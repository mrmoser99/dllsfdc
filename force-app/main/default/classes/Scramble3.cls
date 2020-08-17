/*******************************************************************************************************************
*   Scramble3 - This kicks of the scramble process for refresh
* 
*	Change Log: 
*	7/21/2020 - MRM Created
* 
********************************************************************************************************************/
public class Scramble3 implements Queueable, Database.AllowsCallouts {
    
    public Static Boolean isRunning = false;

    public  Scramble3()
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
        
        isRunning= true;

        List<Address__c>  aList = [select id from Address__c	];
        
        								
        if (System.Label.Environment == 'PROD') 
            return;  //no accidental prod scramble

         
        for (Address__c a:aList){
            a.Email_Address__c = 'test@test.com.invalid';
        
        }

        update aList;
        
        if (!test.isRunningTest()){
	        Scramble4 job = new Scramble4();
            System.enqueueJob(job);	   
        }
			   
    } 
    
}