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
                            ,Insurance_Fees1__c
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

    @AuraEnabled
	public static String createClaim(String recordId, Lease_Claims__c claim, List<String> eList, String notes ){
		
        Map<String,String> response = new Map<String,String>();

         cllease__Lease_Account__c l = [select id
                            ,Name
                            ,cllease__Account__c
                            from cllease__Lease_Account__c
                            where id = :recordid
                            ];

        system.debug(claim);
        Lease_Claims__c c = new Lease_Claims__c();
        c = claim;
        c.lease__c = l.id;
        c.Account__c = l.cllease__account__c;
        c.Claim_Status__c = 'New';
        insert c;

        system.debug('elist is: ' + eList);

        List<Lease_Claim_Equipment__c> newEList = new List<Lease_Claim_Equipment__c>();
        for (String s: eList){
            Lease_Claim_Equipment__c e = new Lease_Claim_Equipment__c(contract_equipment__c = s, ls_contract__c = recordId);
            e.Lease_Claim__c = c.id;
            newElist.add(e);
        }
        insert newEList;

        c.Claim_status__c = 'Submitted';
        update c;

        ContentNote cn = new ContentNote();
        cn.Title = 'Initial Note'; 
        String body = notes;
        cn.Content = Blob.valueOf(body.escapeHTML4());
        insert cn;

        ContentDocumentLink link2 = new ContentDocumentLink();
        link2.ContentDocumentId = cn.id;
        link2.LinkedEntityId = c.id;
        link2.ShareType = 'V';
        link2.Visibility = 'AllUsers';
        insert link2;

        Note n = new Note();
        n.body = notes;
        n.parentId = c.id;
        n.title = 'Initial Note';
        n.isPrivate = false;
        
        system.debug('notes:' + notes);
       
        String tempName = 'temp_' + recordId + '_%';

        system.debug('looking for =' + tempName);
		List<Attachment> documents = [
				SELECT Id, Name, CreatedDate, Description, Body, contenttype, ownerid
				FROM Attachment
				WHERE ParentId = :recordId
                and name like :tempName
				ORDER BY CreatedDate DESC
		];
        
        List<Attachment> newAttachments = new List<Attachment>();

    
        for (Attachment attach:documents){
            //Get attachment

 
    //Insert ContentVersion
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cVersion.PathOnClient = attach.Name;//File name with extention
            cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
            cVersion.OwnerId = attach.OwnerId;//Owner of the file
            String tempName2 = attach.name;
            tempName2 = tempName2.replace('temp_' + recordId + '_', '');
            cVersion.Title = tempName2;//Name of the file
            cVersion.VersionData = attach.Body;//File content
            Insert cVersion;
 
            //After saved the Content Verison, get the ContentDocumentId
            Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
 
            //Insert ContentDocumentLink
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
            cDocLink.LinkedEntityId = c.id;//Add attachment parentId
            cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
            //cDocLink.Visibility = 'InternalUsers';//AllUsers, InternalUsers, SharedUsers
            Insert cDocLink;
        }
        
        
        delete documents;
        insert n;

        return c.id;
    }

   
}