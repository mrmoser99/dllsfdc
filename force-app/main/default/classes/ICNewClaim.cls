/*************************************************************************************************
 Change Log:

 12/16/19  MRM - created


 *********************************************************************************************************************/

global with sharing class ICNewClaim {

     
    @AuraEnabled
	public static cllease__Lease_Account__c getLease(String recordId){
		
        Map<String,String> response = new Map<String,String>();

        cllease__Lease_Account__c c = [select id
                            ,Name
                            ,cllease__Account__c
                            from cllease__Lease_Account__c
                            where id = :recordid
                            ];


        return c;
    }

    @AuraEnabled
	public static String save(String recordId, List<String> eList){
		
        Map<String,String> response = new Map<String,String>();
       
        return JSON.serialize(response);
    }

   
}