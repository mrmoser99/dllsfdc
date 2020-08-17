/*******************************************************************************************************************
*   Scramble2 - This kicks of the scramble process for refresh
* 
*	Change Log: 
*	7/21/2020 - MRM Created
* 
********************************************************************************************************************/
public class Scramble2 implements Queueable, Database.AllowsCallouts {
    
    
    public  Scramble2()
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
    	
        List<Contact>  cList = [select id, firstname, lastname from Contact 	];
        
        Integer firstNameCount = 0;
        Integer lastNameCount = 0;
        
        if (System.Label.Environment == 'PROD') 
            return;  //no accidental prod scramble
        
        Set <ID>  contactSet= new Set<ID>();

        for (Contact c:cList)
            contactSet.add(c.id);

        Map<ID,User> userMap = new Map<ID,User>();

        List<User> uList = [SELECT Email
                , FirstName
                , Id
                , LastName
                , Username
                , ContactId
                FROM User
                where contactId in :contactSet];

        for (User u:uLIst)
            userMap.put(u.contactid,u);
        
      

        List<User> uUpdateList = new List<User>();

 
        for (Contact c:cList){
            c.phone = '8004441212';
            c.fax = '8182221111';
            c.mobilePhone = '7178881111';

            if (c.firstname == 'Docusign'){
                if (System.Label.Environment == 'ACC')
                    c.email = 'newcodocusignacc@dllgroup.com';
                else 
                    c.email = 'newcodocusigndev@dllgroup.com';
            }    
            else
                c.email = 'test@test.com.invalid';


            if (c.firstname == 'System' || c.firstname == 'Docusign')
               continue;
            else{
                c.firstname = 'TestFirst' + firstnameCount;
                firstnameCount++;
                c.lastname = 'TestLast' + lastnameCount;
                lastnameCount++;
                User u = userMap.get(c.id);
                if (U != null) {
                    u.firstname = c.firstname;
                    u.lastname = c.lastname;
                    u.email = 'test@test.com';
                    u.username = c.firstname + c.lastname + '@test.com.invalid';
                    uUpdateList.add(u);
                    system.debug('user: ' + u);
                }
            }
        }

        update cList;
        
        
    	
        if (!test.isRunningTest()){
           Scramble2a job = new Scramble2a();
           System.enqueueJob(job);	   
        }
			   
    } 
    
}