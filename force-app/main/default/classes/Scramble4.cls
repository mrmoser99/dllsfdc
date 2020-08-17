/*******************************************************************************************************************
*   Scramble3 - This kicks of the scramble process for refresh
* 
*	Change Log: 
*	7/21/2020 - MRM Created
* 
********************************************************************************************************************/
public class Scramble4 implements Queueable, Database.AllowsCallouts {
    
    
    public  Scramble4()
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
        
        								
        if (System.Label.Environment == 'PROD') 
            return;  //no accidental prod scramble

        
        List<genesis__Applications__c>  aList;
        
        if (!test.isRunningTest())
            aList = [select id from genesis__Applications__c	];
        else {
            aList = [select id from genesis__Applications__c	limit 1];
        }
        
        Integer firstNameCount = 0; 
        Integer lastNameCount = 0;
         
        for (genesis__Applications__c a:aList){
            a.Contract_Signer__c = 'First Name ' + firstNameCount;
            a.Contract_Signer_Last_Name__c = 'Last Name ' + lastNameCount;
            firstnameCount++;
            lastnameCount++;
        }

        update aList;
        
        if (!test.isRunningTest()){
	        Scramble5 job = new Scramble5();
            System.enqueueJob(job);	   
        }
			   
    } 
    
}