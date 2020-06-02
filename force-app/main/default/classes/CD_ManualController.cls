/***********************************************************************************************************************
*
* change log:
*
* 2/7/19 - MRM - Class to help make credit decision app a lightning applicaiton;approve,decline,rescore actions
* 
*
*
*
*************************************************************************************************************************/
global with sharing class CD_ManualController {
	public static final String RESPONSE_KEYWORD_STATUS = 'Status';
    public static final String RESPONSE_KEYWORD_MESSAGE = 'Message';
    public static final String STATUS_ERROR = 'ERROR';
    public static final String STATUS_SUCCESS = 'SUCCESS';
    
    @AuraEnabled
    /*********************************************************************************************************
    *
    * This is the code to approve a credit application
    *
    **********************************************************************************************************/
    public static String approveApplication(Id applicationId) {
        
          	ICS_Application__c	 a = [select name 
    				,kyc_reason__c
    				,kyc_source__c
    				,status__c
    				,message_id__c
    				,quick_quote__c
    				,transaction_id__c
    				,quick_quote__r.estimated_financed_amount__c
    				,system_approval_limit__c
    				,manual_approval_limit__c
    				,kyc__c
					,error__c
					,legal_name__c
					,cre_status__c
			
    		from ICS_Application__c		
    		where id = :applicationId
    		];
    		
    	genesis__Quick_Quotes__c q = [select id  
    			,name  
    			,genesis__State__c
    			,genesis__Last_Name__c
    			,genesis__First_Name__c
    			,genesis__Business_Name__c
    			,genesis__Address_Line_1__c
    			,genesis__City__c
    			,genesis__Postal_Code__c
    			,Dealer__r.Name
    			,Dealer__r.Id
    			,dealer__r.account_number__c
    			,genesis__account__r.account_Number__c
    			,genesis__account__c
    			,Primary_Phone_number__c
    			,Estimated_Financed_Amount__c
				,genesis__Account__r.Id 
			
    		from genesis__Quick_Quotes__c
			where id = :a.quick_quote__c];
			
		List<Account> acctList = [select id from Account where id = :q.genesis__account__c];
		
    	ICS_Application__c temp = 
    		[ Select i.Name
    		, (Select Id, IsDeleted, LinkedEntityId, ContentDocumentId, Title, CreatedById, CreatedDate
				, LastModifiedById, LastModifiedDate, FileType, ContentSize, FileExtension, TextPreview From AttachedContentNotes)
    		, (Select Id, IsDeleted, LinkedEntityId, ContentDocumentId, Title, CreatedById, CreatedDate
			, LastModifiedById, LastModifiedDate, FileType, ContentSize, FileExtension
			, ContentUrl, ExternalDataSourceName, ExternalDataSourceType, SharingOption From AttachedContentDocuments) 
    		From ICS_Application__c i
    		where id = :applicationId];
	
		system.debug('hello	');
		List<AttachedContentNote> nList = new List<AttachedContentNote>();
		nList = temp.AttachedContentNotes;
		system.debug(temp);
		system.debug('nlist is:	' + nList);
		List<AttachedContentDocument> aList = new List<AttachedContentDocument>();
		aList = temp.AttachedContentDocuments;
		system.debug('alist is: ' + aList);
			
		Boolean error=false;
    	Map<String,String> response = new Map<String,String>();
		
		if (a.status__c == 'CRE Rating Required'){
			if (a.CRE_Status__c == 'EXPIRED'){
				response.put(RESPONSE_KEYWORD_MESSAGE,'Manual decision is not allowed if CRE status is expired (do this in ICV)!');
    			error=true;

			}
			else{
				if  (a.CRE_Status__c == 'NOT AVAILABLE'){
					response.put(RESPONSE_KEYWORD_MESSAGE,'Manual decision is not allowed if CRE status is not available (do this in ICV)!');
    				error=true;
				}
			}
		}

    	if (a.status__c != 'Manual Review' && a.status__c != 'CRE Rating Required'){
    		response.put(RESPONSE_KEYWORD_MESSAGE,'Status must be Manual Review to approve!');
 			error=true;
    	}
    	else{
    		if (a.manual_approval_limit__c == 0 || a.manual_approval_limit__c == null) {
    			response.put(RESPONSE_KEYWORD_MESSAGE,'Enter a manual approval amount before approving!');
    			error=true;
    		} 
    		if (a.manual_approval_limit__c != decimal.valueOf(a.quick_quote__r.estimated_financed_amount__c)){
    			response.put(RESPONSE_KEYWORD_MESSAGE,'Manual approval amount must equal quick quote estimated financed amount!');
    			error=true;
    		}  
    		if (aList.size() ==0 && nList.size() == 0){
    			response.put(RESPONSE_KEYWORD_MESSAGE,'A note or attachment as backup for manual approval is required!');
    			error=true;
    		}  
    		if (a.kyc__c == true && a.kyc_reason__c == null){
    			response.put(RESPONSE_KEYWORD_MESSAGE,'KYC Reason is required!');
 				error=true;
    		} 
    		if (a.kyc__c == true && a.kyc_source__c == null){
				response.put(RESPONSE_KEYWORD_MESSAGE,'KYC Source(s) are required!');
				error=true;
    		} 
    	}
    	  
   		if (error){
   	 		a.error__c = true;
    		update a;
			if (!test.isRunningTest())
    			return JSON.serialize(response);
     	}
    	
    	List<Group> gList = [Select Id
								,developername
								 From
								 Group g 
								 where type = 'QUEUE' and developerName in ('Credit','Past_Credit','Waiting_for_Credit')
								 ];

		system.debug('glist size: 	' + glist.size());
		Map<String,ID> gMap = new Map<String,ID>();
		for (Group g:gList)
			gMap.put(g.developername, g.id);
			
    	a.status__c = 'Credit Analyst Approved';
    	a.ownerid = gmap.get('Past_Credit');
    	q.genesis__status__c = 'CREDIT APPROVED';
    	q.Credit_Approval_Date__c = date.today();
		q.Approved_Credit_Amount__c = a.Manual_Approval_Limit__c;
		q.ATS_Reference_Number__c = a.message_id__c;	
		q.Credit_Approval_Expiration_Date__c =  date.today().addDays(90);		
	
		q.genesis__Business_Name__c = a.legal_name__c;
		
		if (!acctList.isEmpty()){
			if (a.legal_name__c != null){ 
				acctList[0].name = a.legal_name__c;
				update acctList;
			}
		}
		
		update a;
    	update q;
    	
    	/* call the service to register manaul decline with ICS */
    	Map<String,String> md = new Map<String,String>();
    	
    	md.put('decision','ACCEPT');
    	String myISODateTime = string.valueOf(json.serialize(datetime.now()));
		md.put('decisionDate', myISODateTime.replace('Z',''));		
		md.put('decisionAmount', string.valueOf(q.Approved_Credit_Amount__c ));	
		md.put('decisionReasonCode','MAPPR');
		md.put('decisionReasonDesc', 'Manual Approval');
		md.put('decisionReasonUserName', userInfo.getUserName());	
	 
	 	ICSUtility.updateICSManualDecision(a.id,md);
    	
    	ICSUtility.manualCreditApproval(a.id);   
    	
    	
        return JSON.serialize(response);
    }

	 @AuraEnabled
    /*********************************************************************************************************
    *
    * This is the code to decline a credit application
    *
    **********************************************************************************************************/
    public static String declineApplication(Id applicationId) {
    	Map<String,String> response = new Map<String,String>();
    	
    	ICS_Application__c	 a = [select name 
    				,kyc_reason__c
    				,kyc_source__c
    				,status__c
    				,message_id__c
    				,quick_quote__c
    				,transaction_id__c
    				,quick_quote__r.estimated_financed_amount__c
    				,system_approval_limit__c
    				,manual_approval_limit__c
    				,kyc__c
					,error__c
					,CRE_Status__c
    		from ICS_Application__c		
    		where id = :applicationId
    		];
    		
    	genesis__Quick_Quotes__c q = [select id  
    			,name  
    			,genesis__State__c
    			,genesis__Last_Name__c
    			,genesis__First_Name__c
    			,genesis__Business_Name__c
    			,genesis__Address_Line_1__c
    			,genesis__City__c
    			,genesis__Postal_Code__c
    			,Dealer__r.Name
    			,Dealer__r.Id
    			,dealer__r.account_number__c
    			,genesis__account__r.account_Number__c
    			,genesis__account__c
    			,Primary_Phone_number__c
    			,Estimated_Financed_Amount__c
    			,genesis__Account__r.Id 
    		from genesis__Quick_Quotes__c
    		where id = :a.quick_quote__c];
    	
    	ICS_Application__c temp = 
    		[ Select i.Name
    		, (Select Id, IsDeleted, LinkedEntityId, ContentDocumentId, Title, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, FileType, ContentSize, FileExtension, TextPreview From AttachedContentNotes)
    		, (Select Id, IsDeleted, LinkedEntityId, ContentDocumentId, Title, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, FileType, ContentSize, FileExtension, ContentUrl, ExternalDataSourceName, ExternalDataSourceType, SharingOption From AttachedContentDocuments) 
    		From ICS_Application__c i
    		where id = :applicationId];
	
		List<AttachedContentNote> nList = new List<AttachedContentNote>();
		nList = temp.AttachedContentNotes;
		
		List<AttachedContentDocument> aList = new List<AttachedContentDocument>();
		aList = temp.AttachedContentDocuments;	
				
		Boolean error=false;
		
		if (a.status__c == 'CRE Rating Required'){
			if (a.CRE_Status__c == 'EXPIRED'){
				response.put(RESPONSE_KEYWORD_MESSAGE,'Manual decision is not allowed if CRE status is expired (do this in ICV)! ');
    			error=true;

			}
			else{
				if  (a.CRE_Status__c == 'NOT AVAILABLE'){
					response.put(RESPONSE_KEYWORD_MESSAGE,'Manual decision is not allowed if CRE status is not available (do this in ICV)!');
    				error=true;
				}
			}
		}

    	if (a.status__c != 'Manual Review' && a.status__c != 'CRE Rating Required' ){
    		response.put(RESPONSE_KEYWORD_MESSAGE,'Status must be Manual Review to decline!');
    		error=true;
    	}
    	
    	if (aList.size() ==0 && nList.size() == 0){
    		response.put(RESPONSE_KEYWORD_MESSAGE,'A note or attachment as backup for manual decline is required!');
    		error=true;
    	}
    	
    	if (error){
    		a.error__c = true;
    		update a;
			if (!test.isRunningTest())
    			return JSON.serialize(response);
     	}
     	
     	
     	
    	List<Group> gList = [Select Id
								,developername
								 From
								 Group g 
								 where type = 'QUEUE' and developerName in ('Credit','Past_Credit','Waiting_for_Credit')
								 ];
		Map<String,ID> gMap = new Map<String,ID>();
		for (Group g:gList)
			gMap.put(g.developername, g.id);
			
    	a.status__c = 'Credit Analyst Declined';
    	a.ownerid = gmap.get('Past_Credit');
    	q.genesis__status__c = 'CREDIT DECLINED';
    	q.Credit_Approval_Date__c = date.today(); 
		q.Approved_Credit_Amount__c = 0;
		q.ATS_Reference_Number__c = a.message_id__c;	
		q.Credit_Approval_Expiration_Date__c =  null;
    	update a;
    	update q;
    	
    	system.debug('Calling manual decision');
    	
    	/* call the service to register manaul decline with ICS */
    	Map<String,String> md = new Map<String,String>();
    	
    	md.put('decision','DECLINE');
    	String myISODateTime = string.valueOf(json.serialize(datetime.now()));
		md.put('decisionDate', myISODateTime.replace('Z',''));		
		md.put('decisionAmount', '0.00');	
		md.put('decisionReasonCode','MD');
		md.put('decisionReasonDesc', 'Manual Decline');
		md.put('decisionReasonUserName', userInfo.getUserName());	
	 
	 	ICSUtility.updateICSManualDecision(a.id,md);
	 	
	 	if (!Test.isRunningTest()){
	 		ICVAsyncRemoveCommitment job = new ICVAsyncRemoveCommitment(q.id,'Decline');
        	System.enqueueJob(job);	 
	 	}
	 	 
    	return JSON.serialize(response);
    }
     @AuraEnabled
    /*********************************************************************************************************
    *
    * This is the code to rescore a credit application
    *
    **********************************************************************************************************/
    public static String rescoreApplication(Id applicationId) {
    	Map<String,String> response = new Map<String,String>();
    	
    	ICS_Application__c	 a = [select name 
    				,kyc_reason__c
    				,kyc_source__c
    				,status__c
    				,message_id__c
    				,quick_quote__c
    				,transaction_id__c
    				,quick_quote__r.estimated_financed_amount__c
    				,system_approval_limit__c
    				,manual_approval_limit__c
    				,kyc__c
    				,error__c
    		from ICS_Application__c		
    		where id = :applicationId
    		];
    		
    	genesis__Quick_Quotes__c q = [select id  
    			,name  
    			,genesis__State__c
    			,genesis__Last_Name__c
    			,genesis__First_Name__c
    			,genesis__Business_Name__c
    			,genesis__Address_Line_1__c
    			,genesis__City__c
    			,genesis__Postal_Code__c
    			,Dealer__r.Name
    			,Dealer__r.Id
    			,dealer__r.account_number__c
    			,genesis__account__r.account_Number__c
    			,genesis__account__c
    			,Primary_Phone_number__c
    			,Estimated_Financed_Amount__c
    			,genesis__Account__r.Id 
    		from genesis__Quick_Quotes__c
    		where id = :a.quick_quote__c];
    	
    	ICS_Application__c temp = 
    		[ Select i.Name
    		, (Select Id, IsDeleted, LinkedEntityId, ContentDocumentId, Title, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, FileType, ContentSize, FileExtension, TextPreview From AttachedContentNotes)
    		, (Select Id, IsDeleted, LinkedEntityId, ContentDocumentId, Title, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, FileType, ContentSize, FileExtension, ContentUrl, ExternalDataSourceName, ExternalDataSourceType, SharingOption From AttachedContentDocuments) 
    		From ICS_Application__c i
    		where id = :applicationId];
	
		List<AttachedContentNote> nList = new List<AttachedContentNote>();
		nList = temp.AttachedContentNotes;
		
		List<AttachedContentDocument> aList = new List<AttachedContentDocument>();
		aList = temp.AttachedContentDocuments;	
    	Boolean error=false;
    		
    	if (aList.size() ==0 && nList.size() == 0){
    		response.put(RESPONSE_KEYWORD_MESSAGE,'A note or attachment as backup for re-score is required!');
    		error=true;
    	}
    	  
      
   		if (error){
  	 		a.error__c = true;
    		update a;
			if (!test.isRunningTest())
	    		return JSON.serialize(response);
     	}
     	
    	List<Group> gList = [Select Id
								,developername
								 From
								 Group g 
								 where type = 'QUEUE' and developerName in ('Credit','Past_Credit','Waiting_for_Credit')
								 ];
		Map<String,ID> gMap = new Map<String,ID>();
		for (Group g:gList)
			gMap.put(g.developername, g.id);
			
    	a.status__c = 'Credit Analyst Rescored';
    	a.ownerid = gmap.get('Past_Credit');
    	
    	
    	q.genesis__status__c = 'CREDIT SUBMITTED';
    	q.Credit_Approval_Date__c = null;
		q.Approved_Credit_Amount__c = null;
		q.ATS_Reference_Number__c = null;
		q.Credit_Approval_Expiration_Date__c =  null;
    	update a;
    	update q;
    	 
    	ICSUtility.score(q,'Re-Score',null);   
    	return JSON.serialize(response);
    }
    
     @AuraEnabled
    /*********************************************************************************************************
    *
    * This is the code to rescore a credit application
    *
    **********************************************************************************************************/
    public static String rejectLOS(Id applicationId) {
   		
   		Map<String,String> response = new Map<String,String>();
   		
   		Boolean error=false;
    	
    	ICS_Application__c	 a = [select name 
    				,kyc_reason__c
    				,kyc_source__c
    				,status__c
    				,message_id__c
    				,quick_quote__c
    				,transaction_id__c
    				,quick_quote__r.estimated_financed_amount__c
    				,system_approval_limit__c
    				,manual_approval_limit__c
    				,kyc__c
    				,error__c
    		from ICS_Application__c		
    		where id = :applicationId
    		];
    		
    	genesis__Quick_Quotes__c q = [select id  
    			,name  
    			,genesis__State__c
    			,genesis__Last_Name__c
    			,genesis__First_Name__c
    			,genesis__Business_Name__c
    			,genesis__Address_Line_1__c
    			,genesis__City__c
    			,genesis__Postal_Code__c
    			,Dealer__r.Name
    			,Dealer__r.Id
    			,dealer__r.account_number__c
    			,genesis__account__r.account_Number__c
    			,genesis__account__c
    			,Primary_Phone_number__c
    			,Estimated_Financed_Amount__c
    			,genesis__Account__r.Id 
    		from genesis__Quick_Quotes__c
    		where id = :a.quick_quote__c];
    	
    	ICS_Application__c temp = 
    		[ Select i.Name
    		, (Select Id, IsDeleted, LinkedEntityId, ContentDocumentId, Title, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, FileType, ContentSize, FileExtension, TextPreview From AttachedContentNotes)
    		, (Select Id, IsDeleted, LinkedEntityId, ContentDocumentId, Title, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, FileType, ContentSize, FileExtension, ContentUrl, ExternalDataSourceName, ExternalDataSourceType, SharingOption From AttachedContentDocuments) 
    		From ICS_Application__c i
    		where id = :applicationId];
	
		List<AttachedContentNote> nList = new List<AttachedContentNote>();
		nList = temp.AttachedContentNotes;
		
		List<AttachedContentDocument> aList = new List<AttachedContentDocument>();
		aList = temp.AttachedContentDocuments;
			
    	if (a.status__c != 'List Of Similars'){
    		response.put(RESPONSE_KEYWORD_MESSAGE,'Application status must be List of Similars to reject LOS!');
    		error=true;
    	}
    	  
    	if (error){
  	 		a.error__c = true;
    		update a;
			if (!test.isRunningTest())
    			return JSON.serialize(response);
     	}
     	
    	List<Group> gList = [Select Id
								,developername
								 From
								 Group g 
								 where type = 'QUEUE' and developerName in ('Credit','Past_Credit','Waiting_for_Credit')
								 ];
		Map<String,ID> gMap = new Map<String,ID>();
		for (Group g:gList)
			gMap.put(g.developername, g.id);
			
    	a.status__c = 'Credit Analyst Rejected LOS';
    	a.ownerid = gmap.get('Past_Credit');
    	
    	
    	q.genesis__status__c = 'CREDIT REFERRED';
    	q.Credit_Approval_Date__c = null;
		q.Approved_Credit_Amount__c = null;
		q.ATS_Reference_Number__c = null;
		q.Credit_Approval_Expiration_Date__c =  null;
    	update a;
    	update q;
    	
    	ICSUtility.rejectLOS(a.id);   
    	return JSON.serialize(response);
    } 
     @AuraEnabled
     /******************************************************************************************
    * CHOOSE
    *******************************************************************************************/
    public static String chooseLOS(Id leId){
    	
    	Map<String,String> response = new Map<String,String>();
    	
    	ICS_External_Legal_Entity__c
    	 	s = [Select id
    				,Legal_Name__c
    				,Address_Line__c
    				,City__c
    				,Phone__c
    				,State_Province_Code__c
    				,Postal_Code__c
    				,Country_Code__c
    				,ICS_Application_Request__c
    				from ICS_External_Legal_Entity__c
    				where id = :leId
    				];
    				
    	ICS_Application__c	 a = [select name 
    				,kyc_reason__c
    				,kyc_source__c
    				,status__c
    				,message_id__c
    				,quick_quote__c
    				,transaction_id__c
    				,quick_quote__r.estimated_financed_amount__c
    				,system_approval_limit__c
    				,manual_approval_limit__c
    				,kyc__c
    				,error__c
    		from ICS_Application__c		
    		where id = :s.ics_application_request__c
    		];
    	
    		
    	genesis__Quick_Quotes__c q = [select id  
    			,name  
    			,genesis__State__c
    			,genesis__Last_Name__c
    			,genesis__First_Name__c
    			,genesis__Business_Name__c
    			,genesis__Address_Line_1__c
    			,genesis__City__c
    			,genesis__Postal_Code__c
    			,Dealer__r.Name
    			,Dealer__r.Id
    			,dealer__r.account_number__c
    			,genesis__account__r.account_Number__c
    			,genesis__account__c
    			,Primary_Phone_number__c
    			,Estimated_Financed_Amount__c
    			,genesis__Account__r.Id 
    		from genesis__Quick_Quotes__c
    		where id = :a.quick_quote__c];	
    		
    	if (a.status__c != 'List of Similars'){
    		response.put(RESPONSE_KEYWORD_MESSAGE,'Application status must be List of Similars!');
    		return JSON.serialize(response);
    	}
    	
    	List<Group> gList = [Select Id
								,developername
								 From
								 Group g 
								 where type = 'QUEUE' and developerName in ('Credit','Past_Credit','Waiting_for_Credit')
								 ];
		Map<String,ID> gMap = new Map<String,ID>();
		for (Group g:gList)
			gMap.put(g.developername, g.id);
			
    	a.ownerid = gmap.get('Past_Credit');
    	a.status__c = 'Similar Chosen by CA';
   		q.genesis__status__c = 'CREDIT SUBMITTED';
    	q.Credit_Approval_Date__c = null;
		q.Approved_Credit_Amount__c = null;
		q.ATS_Reference_Number__c = null;
		q.Credit_Approval_Expiration_Date__c =  null;
		
    	update a;
    	update q;
    	
    	ICSUtility.acceptLOS(q.id,a.id,s.id);     
    	
    	return JSON.serialize(response);
    }
}