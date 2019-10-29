/*******************************************************************************************************************
*   OFACCall - made this into a queable since cams need to be called in sequence
* 
*	Change Log: 
*	9/25/19 - MRM Created
*   10/14/19 - MRM added call to cams
* 
********************************************************************************************************************/
public class OFACCall implements Queueable, Database.AllowsCallouts {
    
    
    private Map<ID,String> applicationMap;

    public  OFACCall(Map<ID,String> applicationMap)
    {
        this.applicationMap = applicationMap;
    }
    
    public void execute(QueueableContext context) {
    	
    	genesis__Applications__c app = new genesis__applications__c(); 
    	Bridger.bridgerInput input1 = new Bridger.bridgerInput();
    	Bridger.bridgerInput input2 = new Bridger.bridgerInput();
		Bridger.bridgerInput input3 = new Bridger.bridgerInput();
    	Boolean businessHit = false;
    	Boolean individualHit = false;
		Boolean pepHit = false;
    	bridger.bridgerResult IndividualResult = new Bridger.bridgerResult();
        bridger.bridgerResult businessResult = new Bridger.bridgerResult();
		bridger.bridgerResult pepResult = new Bridger.bridgerResult();
    	
    	try{
			
    		app = [select genesis__account__r.name
    					,billing_address1__r.address_line_1__c
    					,billing_address1__r.address_line_2__c
    					,billing_address1__r.city__c
    					,billing_address1__r.county__c
    					,billing_address1__r.country__c
    					,billing_address1__r.zip_code__c
    					,billing_address1__r.state__c
    					,genesis__account__r.EIN__c
    					,contract_signer__c
    					,contract_signer_last_name__c
    					,contract_signer_title__c
						,genesis__Status__c
    				from genesis__applications__c
    				where id in :applicationMap.keySet()
    				limit 1	
    		];

			if (app.genesis__Status__c <> 'OFAC APPROVED'){
			 
    			/* business */
    			input1.requestType = 'Business'; 
    			input1.street1 = app.billing_address1__r.address_line_1__c;
    			input1.street2 = app.billing_address1__r.address_line_2__c;
    			input1.city = app.billing_address1__r.city__c;
    			input1.stateprovincedistrict = app.billing_address1__r.state__c;
    			input1.postalcode = app.billing_address1__r.zip_code__c;
    			input1.addresstype = 'Current';
    			input1.county = app.billing_address1__r.county__c;
    			input1.fullname = app.genesis__account__r.name;
    			input1.ein = app.genesis__account__r.ein__c;  
    		 
    			system.debug('************ input1: ' + input1);
    			/* individual */
    			input2.requestType = 'Individual';
    			input2.title = app.Contract_Signer_Title__c;
    			input2.last = app.contract_signer_last_name__c;
    			input2.first = app.contract_signer__c;
    			system.debug('************ input2: ' + input2);
    		
    		
    			businessResult = bridger.bridgerSearch(input1,false);//business
    			individualResult = bridger.bridgerSearch(input2,false);//individual

				if (!businessResult.hit && !individualResult.hit){
					if (system.label.cams_check == 'True'){
						pepResult = bridger.bridgerSearch(input1,true);//pep 
					}
				}

				NewCoUtility.skipApplicationTrigger = true;
				
				if (businessResult.hit || individualResult.hit){
	   				app.genesis__Status__c = 'OFAC DECLINED';
				}
    			else{
					if (pepResult.hit != null){
						if (pepResult.hit){
							app.genesis__Status__c = 'OFAC DECLINED - PEP';
						}
						else
    						app.genesis__Status__c = 'OFAC APPROVED';
					}
					else {
						app.genesis__Status__c = 'OFAC APPROVED';
					}
				}
    			update app;

			}
			CAMS_Check__c cc;
			
			if (system.label.cams_check == 'True'){
				List<CAMS_Check__c> ccList = [SELECT Account_Number__c
                                    ,Application__c
                                    ,Application__r.name
                                    ,Confirmed_PEP__c
                                    ,Customer_LE_Type__c
                                    ,Customer_Name__c
                                    ,Product_Risk__c
                                    ,Customer_Type__c
                                    ,Distribution_Channel__c
                                    ,Dll_Country__c
                                    ,Geography__c
                                    ,Lease_Signer_First_Name__c
                                    ,Lease_Signer_Last_Name__c
                                    ,Lease_Signer_Title__c
                                    ,LS_Contract__c
                                    ,NAICS__c 
                                    ,Name
                                    ,OwnerId
                                    ,Publicly_Traded_Full_Subsidiary__c
                                    ,Publicly_Traded__c
                                    ,Quick_Quote__c
                                    ,Response_Case_Number__c
                                    ,Response_Diligence__c
                                    ,Response_Risk_Rating__c
                                    ,Source_System__c
                                    ,Status__c
                                    ,Transaction_Amount__c
                                    ,Trust__c 
                                    ,missing_data__c
                                    FROM CAMS_Check__c
                     		        where application__c in :applicationMap.keySet()
							        ];
				if (ccList.size() == 0){
       				cc = CAMSUtility.createCamsCheckRecord(applicationMap,'CAMS CHECK',individualResult.hit);
				}
				else
					cc = ccList[0];
			}
			system.debug('app status is:' + app.genesis__status__c);

			if (app.genesis__Status__c == 'OFAC APPROVED' && system.label.cams_check == 'True'){
				system.debug('Submitting CAMS Call now.....');
            	CAMSCall job = new CAMSCall(applicationMap);
        		System.enqueueJob(job);	   
			}
	
			if (app.genesis__Status__c == 'OFAC DECLINED - PEP'){
				cc.status__c = 'Held - PEP Hit';
				update cc;
			}
			 
    	}
    	catch (Exception e){
    		system.debug('***** Exception: ' + e);
    		ofac_log__c o1 = new ofac_log__c();
    		o1.result__c = string.valueOf(e);
    		o1.application__c = app.id;
			insert o1;
			
			app.genesis__Status__c = 'OFAC FATAL';
    		NewCoUtility.skipApplicationTrigger = true;
    		update app;
			    		
    	}	
    	finally {
    		system.debug(app.billing_address1__r.address_line_1__c);
			List<OFAC_Log__c> oList = new List<OFAC_Log__c>();
			
			system.debug(input1);
			ofac_log__c o1 = new ofac_log__c();
    		o1.input__c = string.valueOf(input1);
    		o1.application__c = app.id;
    		o1.result__c =  businessResult.result;
    		olist.add(o1);
			
			system.debug(input2);
			ofac_log__c o2 = new ofac_log__c();
    		o2.input__c = string.valueOf(input2);
    		o2.result__c = individualResult.result;
    		o2.application__c = app.id;
    		oList.add(o2);
    		
			if (!olist.isEmpty())
				insert oList;
    	} 
    	
    }

}