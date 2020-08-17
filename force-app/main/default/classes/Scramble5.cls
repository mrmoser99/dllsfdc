/*******************************************************************************************************************
*   Scramble5 - This kicks of the scramble process for refresh
* 
*	Change Log: 
*	7/21/2020 - MRM Created
* 
********************************************************************************************************************/
public class Scramble5 implements Queueable, Database.AllowsCallouts {
    
    
    public  Scramble5()
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
    	
        List<cllease__Lease_Account__c>  cList = [select id from cllease__Lease_Account__c	];
        
        Integer firstNameCount = 0;
        Integer lastNameCount = 0;
        
        								
        if (System.Label.Environment == 'PROD') 
            return;  //no accidental prod scramble

            
        for (cllease__Lease_Account__c c:cList){
            c.Contract_Signer__c = 'First Name ' + firstNameCount;
            c.Contract_Signer_Last_Name__c = 'Last Name ' + lastNameCount;
            firstnameCount++;
            lastnameCount++;
        } 
 
        update cList;  
        
        if (!test.isRunningTest()){
	        Scramble6 job = new Scramble6();
            System.enqueueJob(job);	   
        }	   
    } 
    
}