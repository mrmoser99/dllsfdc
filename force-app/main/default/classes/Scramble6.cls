/*******************************************************************************************************************
*   Scramble5 - This kicks of the scramble process for refresh
* 
*	Change Log: 
*	7/21/2020 - MRM Created
* 
********************************************************************************************************************/
public class Scramble6 implements Queueable, Database.AllowsCallouts {
    
    
    public  Scramble6()
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

        List <ICS_Application__c>  aList = [select id from ICS_Application__c	];
   
        delete aList;
    	
	   
			   
    } 
    
}