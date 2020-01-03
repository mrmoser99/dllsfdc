/*************************************************************************************************
 Change Log:

 12/16/19  MRM - created


 *********************************************************************************************************************/

global with sharing class ICNewEquipment {

     
    @AuraEnabled
	public static cllease__Lease_Account__c getLease(String recordId){
		
        Map<String,String> response = new Map<String,String>();

        Lease_Claims__c c = [select id, lease__c from Lease_Claims__c where id = :recordId];

        cllease__Lease_Account__c l= [select id
                            ,Name
                            ,cllease__Account__c
                            from cllease__Lease_Account__c
                            where id = :c.lease__c
                            ];


        return l;

    }

    @AuraEnabled
	public static String save(String recordId, List<String> eList){
		
        Map<String,String> response = new Map<String,String>();
        system.debug('elist is: '+ eList);
        Lease_Claims__c c = [select Lease__c from lease_Claims__c where id = :recordid];

        List<Lease_Claim_Equipment__c> equipmentAdd = new List<Lease_Claim_Equipment__c>();
        
        for (String s:eList){
            Lease_Claim_Equipment__c e = new Lease_Claim_equipment__c();
            e.lease_claim__c = recordId;
            e.ls_contract__c = c.lease__c;
            e.contract_equipment__c = s;
            system.debug('e is: ' + e);
            equipmentAdd.add(e);

        }

        if (!equipmentAdd.isEmpty())
             
           
            insert equipmentAdd;

        else
            response.put('Message','You must select at lease one piece of equipment!');
        
       

        return JSON.serialize(response);
    }

    @AuraEnabled
	public static List<cllease__Contract_Equipment__c> getEquipment(String recordId){
		
        Map<String,String> response = new Map<String,String>();

        Lease_Claims__c c = [select Lease__c from lease_Claims__c where id = :recordid];

        List<Lease_Claim_Equipment__c> sList = [select Contract_Equipment__c
                                                from Lease_Claim_equipment__c
                                                where lease_claim__c = :recordId
                                                ];
        Set<ID> alreadySelectedSet = new Set<ID>();

        for (Lease_Claim_Equipment__c e : sList)
            alreadySelectedSet.add(e.Contract_Equipment__c);


        List<cllease__Contract_Equipment__c> eList = [select cllease__make__c
                                            , cllease__model__c
                                            , Equipment_Description1__c
                                            , name
                                            , id
                                            , Install_Address_Line_1__c
                                            , City__c
                                            , State__c
                                            , Zip_Code__c
                                            , serial_number__c
                                            from cllease__Contract_Equipment__c
                                            where cllease__Contract__c = :c.lease__c
                                            and id not in :alreadySelectedSet
        ];

        
        return eList;
 

        
    }
}