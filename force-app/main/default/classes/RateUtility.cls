/*********************************************************************************************
*
* NewCo Rate Utility - used to get rate cards from mosaic   
*
* Change Log:
*
* 9/4/2020 - MRM Created
* 9/14/2020 - MRM Reworked 
**********************************************************************************************/
global without sharing class RateUtility { 

    /*************************************************************************************************
    * 
    * dataForSave - structure to hold the information so database updates can be held until callouts 
    *               are done
 	*	
    *************************************************************************************************/
    public class dataForSave {
                             
        public genesis__Rate_Card_Setup_Header__c header;
        public Boolean headerIsUpdate;
        public clcommon__CL_Product__c product;
        public genesis__Product_Rate_Card_Association__c rca;
        public List<genesis__Rate_Card_Setup_Detail__c> detailList;
        public String returnCode;

        public dataForSave(genesis__Rate_Card_Setup_Header__c header, Boolean headerIsUpdate, clcommon__CL_Product__c product,genesis__Product_Rate_Card_Association__c rca, List<genesis__Rate_Card_Setup_Detail__c> detailList){

            this.header = header;
            this.headerIsUpdate = headerIsUpdate;
            this.product = product;
            this.rca = rca;
            this.detailList = detailList;
            this.returnCode = 'OK';
            
            /* save here */
        }

    } 

    /*************************************************************************************************
    * 
    * getProgram  - using an oracle vendor id you can get a program which contains rate cards
	*	
	*************************************************************************************************/
     
    public static String getProgram( String mosaicPrimaryId){    	
          
        String retCode = 'OK'; 
		try{ 
			string accessToken = getAccessToken();
			
			//system.debug('at:' + accessToken);
			
			HttpRequest reqAPI = new HttpRequest();  
			
            //https://apiacc.dllgroup.com/vf/us/v1/partner-insight/Details/0000102923-0004   //test with this one for now

            List<String> vList = mosaicPrimaryId.split('-');

            Integer vId = integer.valueOf(vList[0]);

            Account a = [select id from Account where mosaic_primary_id__c  = :mosaicPrimaryId];
            
            string endpoint = 'https://apiacc.dllgroup.com/vf/us/v1/partner-insight/Details/' + string.valueOf(vId) + '-' + string.valueOf(vList[1]);

            system.debug('endpoint is: ' + endpoint);
        	
        	reqAPI.setEndpoint(endpoint); 
            reqAPI.setMethod('GET');   
            reqAPI.setHeader('originatorId', 'MOSAIC');    
            reqAPI.setHeader('messageId', '11115');   
            reqAPI.setHeader('Accept', 'application/json');
            reqAPI.setHeader('Charset', 'UTF-8');
            reqAPI.setHeader('Content-Type', 'application/json');
            reqAPI.setHeader('Authorization', 'Bearer '+ accessToken);
        	reqAPI.setTimeout(120000);
        	
			Http http1 = new Http();
	    	HTTPResponse res1 = http1.send(reqAPI); 
            system.debug(res1.getStatus()  + '  ' + res1.getStatusCode());
            

            if (res1.getStatusCode() == 404){
                /*  don't get a transaction going here...
                cllease__Batch_Process_Log__c b = new cllease__Batch_Process_Log__c();
                b.name = 'RateUtility';
                b.cllease__Message__c = 'No rate cards found for Oracle Vendor Id: ' + mosaicPrimaryId;
                insert b;
                */
                return string.valueOf(res1.getStatusCode());
            }
            if (res1.getStatus() != 'OK' || res1.getStatusCode() != 200){
                retCode = res1.getStatus() + ' - ' + res1.getStatusCode();
                return retCode;
            }

            Map<String,List<RateCardAccountJSON2Apex.program>> vendorProgramMap = new Map<String,List<RateCardAccountJSON2Apex.program>>();
            List<dataForSave> saveList;

            if (test.isRunningTest()){
                Integer skip = 0;
            }
            else{
                vendorProgramMap  = getVendorProgramMap(res1,mosaicPrimaryId);
            
                system.debug('Program Map: ' + vendorProgramMap );
                
                saveList = new List<dataForSave>();

                for (RateCardAccountJSON2Apex.program p: vendorProgramMap.get(mosaicPrimaryId))
                    system.debug('>>>>>>>>>>>>>>>>>>>>>>>>  Program rateCardId: ' +  p.rateCardId + ' Program Name: ' + p.name);


                Set<String> noDupSet = new Set<String>();
                for (RateCardAccountJSON2Apex.program p: vendorProgramMap.get(mosaicPrimaryId)){
                    noDupSet.add(p.rateCardId);
                }  
                system.debug('NO DUP SET: ' + noDupSet);

                a.Mosaic_Rate_Card_Ids__c = string.valueOf(noDupSet);

                for (String r:noDupSet){
                    system.debug('         PROCESSING REGULAR ' + r);
                    saveList.addAll(getRateCardDetail(r,mosaicPrimaryId,'REGULAR',''));
                    //system.debug('         PROCESSING PROMOTION ');
                    //saveList.addAll(getRateCardDetail(p.rateCardId,mosaicPrimaryId,'PROMOTION',p.name));
                          
                }

                System.debug('Save list size is: ' +  saveList.size()) ; 
                
                system.debug('****************************************************************************');
                system.debug('*                                                                          *');
                system.debug('*                                                                          *');
                system.debug('*                                                                          *');
                system.debug('*                                                                          *');
                system.debug('******************* Saving to Database ' + saveLIst.size() + ' *************************************');
                system.debug('*                                                                          *');
                system.debug('*                                                                          *');
                system.debug('*                                                                          *');
                system.debug('*                                                                          *');
                system.debug('****************************************************************************');
                
                try { 
                    
                    //system.debug('Save list 0:'  + saveList[0]);
                    //system.debug('break');
                    //system.debug('Sae list 1:'  + saveList[1]);

                    for (dataForSave d:saveList){
                        System.debug('Trying to save this: ' + d);
                        storeDataInDB(d);
                    }
                }
                catch (exception e){
                    cllease__Batch_Process_Log__c b = new cllease__Batch_Process_Log__c();
                    b.name = 'RateUtility';
                    b.cllease__Message__c = e.getMessage() + '  - ' + e.getStackTraceString();
                    System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
                    System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());
                    insert b;
                    return  b.cllease__Message__c;
                 }
            }
            a.Mosaic_Rate_Return_Code__c = retCode + '-' + saveList.size();
            a.Mosaic_Rates_Last_Updated__c = datetime.now();
            update a;
            return retCode;
                 
        }
 		catch (exception e){
            cllease__Batch_Process_Log__c b = new cllease__Batch_Process_Log__c();
            b.name = 'RateUtility';
            b.cllease__Message__c = e.getMessage() + '  - ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());
            insert b;
            return  b.cllease__Message__c;
 		}
    }

    /*************************************************************************************************
    * 
    * getVendorProgramMap - returns a map of the ratecard and its program names
 	*	
    *************************************************************************************************/
    public static Map<String,List<RateCardAccountJSON2Apex.program>> getVendorProgramMap(HTTPResponse res1, String mosaicPrimaryId){     

        //system.debug('************ entering process results');

       
        Map<String,List<RateCardAccountJSON2Apex.program>> resultMap = new Map<String,List<RateCardAccountJSON2Apex.program>>();

        RateCardAccountJSON2Apex result = RateCardAccountJSON2Apex.parse(string.valueOf(res1.getBody()));

         RateCardAccountJSON2Apex result = RateCardAccountJSON2Apex.parse(string.valueOf(res1.getBody()));
        
        if (result == null)
            return null;
        else
        if (result.program == null)
            return null;

        //system.debug('Result Program is' + result.program);
        resultMap.put(mosaicPrimaryId,new List<RateCardAccountJSON2Apex.program>());

        for (RateCardAccountJSON2Apex.program p:result.program){
            List<RateCardAccountJSON2Apex.program> temp = resultMap.get(mosaicPrimaryId);
            temp.add(p);
            resultMap.put(mosaicPrimaryId,temp); 
        }
        //system.debug('returning...' + resultMap);
        return resultMap;

    }
    

    /*************************************************************************************************
    * 
    * getRateCardDetail - get the details for a specficd rate card 
	*************************************************************************************************/
    
    public static List<dataForSave> getRateCardDetail(String rateCard, String mosaicPrimaryId, String includeType, String programName){    	
         
        List<dataForSave> saveList = New List<dataForSave>();
        
		try{ 
            Account a = [select id, name from Account where Mosaic_Primary_Id__c = :mosaicPrimaryId];

			string accessToken = getAccessToken();
			
			//system.debug('at:' + accessToken);
			
			HttpRequest reqAPI = new HttpRequest();  
			
            string endpoint = 'https://apiacc.dllgroup.com/vf/us/v1/ratecards/' + rateCard + '/ratefactors';

            system.debug('endpoint is: ' + endpoint);
        	 
        	reqAPI.setEndpoint(endpoint); 
            reqAPI.setMethod('POST');   
            reqAPI.setHeader('originatorId', 'MOSAIC');    
            reqAPI.setHeader('messageId', '11115');   
            reqAPI.setHeader('Accept', 'application/json');
            reqAPI.setHeader('Charset', 'UTF-8');
            reqAPI.setHeader('Content-Type', 'application/json');
            reqAPI.setHeader('Authorization', 'Bearer '+ accessToken);
            reqAPI.setBody('{"data":' + 
                    ' {"effDate": "2020-10-02","excludeExpired": true,"includeRateFactorDetails": true,"includeType":' + 
                    '"' + includeType + '"' + 
            //       ',"paymentTiming": "ARREAR","rateType": "PRICING","softCostAllowancePct": 0}}');  
            //      ',"paymentFrequency": "M","paymentTiming": "ARREAR","rateType": "PRICING","softCostAllowancePct": 0}}');
                    ',"paymentFrequency": "M","paymentTiming": "ARREARS" ,"purchaseOption": "FMV","rateType": "PRICING"}}');
        	reqAPI.setTimeout(120000);
        	
			Http http1 = new Http();
            HTTPResponse res1 = http1.send(reqAPI); 
             
            if (res1.getStatus() != 'OK' || res1.getStatusCode() != 200){
                cllease__Batch_Process_Log__c b = new cllease__Batch_Process_Log__c();
                b.name = 'RateUtility';
                b.cllease__Message__c= res1.getStatus() + '  - ' + res1.getStatusCode();
                insert b;
            }
            else{
                //system.debug('Rate Card Detail: ' + res1.getBody());

                RateCardDetailsJSON2Apex result = RateCardDetailsJSON2Apex.parse(string.valueOf(res1.getBody()));
                saveList = saveRateCardData(result,a,programName);

                /*
                for (RateCardDetailsJSON2Apex.Data d:result.data){
                    system.debug('=================================>');
                    system.debug('Rate Card Id: ' + d.id + ' Rate Card Name: ' + d.name);
                    system.debug('Rate Card Details....' + d);
                    system.debug('*****************************************************************\n');
                    List<RateCardDetailsJSON2Apex.RateFactors> rateFactorList = d.rateFactors;
                    for (RateCardDetailsJSON2Apex.RateFactors f: rateFactorList){
                        system.debug('id: ' + f.id + ' term: ' + f.term + ' min: ' + f.minAmount + ' max: ' + f.maxAmount + ' actual factor: ' + f.rateFactorAmount);
                   
                    }
                    system.debug('*****************************************************************\n');
                }
                */
                 
            }

            return saveList;
        
        }
 		catch (exception e){
            cllease__Batch_Process_Log__c b = new cllease__Batch_Process_Log__c();
            b.name = 'RateUtility';
            b.cllease__Message__c= e.getMessage() + '  - ' + e.getStackTraceString() +  ' - ' + e.getLineNumber();   
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString() + e.getLineNumber());
            insert b;
            return saveList;
            
        }

    }
    /*************************************************************************************************
    * 
    * saveRateCardData - save the data in structures for later save event
    *                  - only adding of data is performed, no rate cards get replaced, with the exception
    *                    that the expiration of the rate card header is updated
 	*	
    *************************************************************************************************/
    public static List<dataForSave> saveRateCardData( RateCardDetailsJSON2Apex result, Account a,String programName){  
    
        List<dataForSave> saveList = new List<dataForSave>();

        genesis__Company__c c = [select id from genesis__Company__c where name = 'DeLage Landen'];

        List<genesis__Rate_Card_Setup_Header__c> hList = new List<genesis__Rate_Card_Setup_Header__c>();
       
        List<genesis__Rate_Card_Setup_Header__c> existingHeaderList = new List<genesis__Rate_Card_Setup_Header__c>();

       
        Map<String,Set<String>> rateMap = new Map<String,Set<String>>();
       
        Set<String> rateSet = new Set<String>();

        for (RateCardDetailsJSON2Apex.Data d:result.data){
            rateSet.add(d.rateCardId);
        }
 
        //get a list of rate cards for this dealear
        existingHeaderList = [select rate_id__c, rate_card_id__c, genesis__CL_Product__c, genesis__CL_Product__r.dealer__c
                            from genesis__Rate_Card_Setup_Header__c
                            where CL_Product__r.dealer__c = :a.id
                              
        ];

       
        for (genesis__Rate_Card_Setup_Header__c d:existingHeaderList){
            Set<String> temp = new Set<String>();

            if (rateMap.get(d.rate_card_id__c + '-' + d.rate_id__c + '-' + a.id) == null){
                temp.add(d.rate_id__c);
                rateMap.put(d.rate_card_id__c + '-' + d.rate_id__c + '-' + a.id,temp);
            }
            else{
                temp = rateMap.get(d.rate_card_id__c + '-' + d.rate_id__c + '-' + a.id);
                temp.add(d.rate_id__c);
                rateMap.put(d.rate_card_id__c + '-' + d.rate_id__c + '-' + a.id,temp);
            }
        }

        system.debug('This is what exists in db now: Rate map: ' + rateMap);

        // Result: 1080, [1340,1341,1342...]
        if (result.data.isEmpty()){
            /*  don't start transaction here....
            cllease__Batch_Process_Log__c b = new cllease__Batch_Process_Log__c();
            b.name = 'RateUtility';
            b.cllease__Message__c= 'No Rate Cards Found for Account: ' + a.name;
            insert b;
            */
        }

        

        for (RateCardDetailsJSON2Apex.Data d:result.data){

            system.debug('=============================================================================================');
            system.debug('=                                                                                           =');
            system.debug('=                                                                                           =');
            system.debug('=                                                                                           =');
            system.debug('=               Rate Id: ' + d.id + ' Rate Card Name: ' + d.name);
            system.debug('=                                                                                           =');
            system.debug('=                                                                                           =');
            system.debug('=                                                                                           =');
            system.debug('=============================================================================================');
            
            if (d.purchaseOption != 'FMV')  //skip all except FMV
                continue;

            dataForSave s = new dataForSave(null,null, null,null,null);    // header,  update, product,  rca,  detail 
            /*
             softCostAllowancePct;
            */
            // no inserts if already there 

            clcommon__CL_Product__c pr = new clcommon__CL_Product__c();
            //if ((rateMap.keySet().contains(d.rateCardId+a.id) && rateMap.get(d.rateCardId+a.id).contains(d.id))){
            List<clcommon__CL_Product__c> pList = new List<clcommon__CL_Product__c>();
            pList = [select id from clcommon__CL_Product__c where rate_card_id__c = :d.rateCardId and rate_id__c = :d.id and dealer__c = :a.id];
            ID existingProductId;
            if (pList.size() == 1){
                system.debug('***************** Skipping product insert: ' + d.rateCardId);
                //system.debug('select');
                
                s.product = pList[0];
                existingProductId = pList[0].id;
            }    
            else{
                system.debug('***************** Adding new product: ' + d.rateCardId);
                
                pr.rate_card_id__c = d.rateCardId;
                pr.rate_id__c = d.id;
                pr.dealer__c = a.id;
                pr.clcommon__Product_Name__c = a.name + ' (' + d.rateCardId + ')';
                //system.debug('select');
                pr.clcommon__Asset_Class__c = [select id from clcommon__asset_class__c where name = 'Office Equipment'].id;
                pr.clcommon__Class__c = 'Commercial';
                pr.program_name__c = programName;
                pr.active__c = false;
                //insert pr;
                s.product = pr;
                
            }
            
            genesis__Rate_Card_Setup_Header__c h = new genesis__Rate_Card_Setup_Header__c();
            
            //system.debug('rateMap: ' + rateMap + ' looking for ' + d.rateCardId) ;
            Boolean addHeader = false;
            if (rateMap.isEmpty())
                addHeader = true;
            else
            if (rateMap.get(d.rateCardId + '-' + d.Id + '-' + a.id) == null)
                addHeader = true;    
            //system.debug('add header is : ' + addHeader);
            if (addHeader){
                //system.debug('************* Inserting Rate Card Header');
                h.name = d.name;
                h.genesis__Product_Type__c = 'LEASE';
                 
                h.genesis__Company__c = c.id;
                h.genesis__Description__c = d.description;
                h.genesis__Enabled_Flag__c = true;
                h.Rate_Card_Id__c = d.rateCardId;
                h.Rate_Id__c = d.id;
                h.Rate_Card_Name__c = d.rateCardName;
                h.Subsidy_Id__c = d.subsidyId;
                h.Promotion_Id__c = d.promotionId;
                h.Payment_Frequency__c = d.paymentFrequency;
                h.Payment_Timing__c = d.paymentTiming;
                h.purchase_option__c = d.purchaseOption;
                h.No_Advance_Payments__c = d.noAdvancePayments;
                h.No_Deferred_Payments__c = d.noDeferredPayments;
                h.Rate_type__c = d.rateType;
                h.Soft_Cost_Allowance_Pct__c = d.softCostAllowancePct;
                h.no_security_deposits__c = d.noSecurityDeposits;
                h.fee_included__c = d.feeIncluded;
                if (d.grandFatherDate != null)
                    h.grandfather_date__c = date.valueOf(d.grandFatherDate);
                h.genesis__Start_Date__c = date.valueOf(d.effDate);
                h.genesis__End_Date__c = date.valueOf(d.expDate);
                h.genesis__Transaction_Date__c = date.today();

                //insert h;
                s.header = h;
                s.headerIsUpdate = false;

                //s.product.Rate_Card_Setup__c = h.id;

                //update pr;
            }
            else{
                system.debug('************* Not inserting header but updating dates.....' + ' d.id: ' + d.id); 
                h = [select id from genesis__Rate_Card_Setup_Header__c where Rate_Id__c = :d.id and Rate_Card_Id__c = :d.rateCardId and CL_Product__c = :existingProductId ] ;
                if (d.grandFatherDate != null)
                    h.grandfather_date__c = date.valueOf(d.grandFatherDate);
                h.genesis__Start_Date__c = date.valueOf(d.effDate);
                h.genesis__End_Date__c = date.valueOf(d.expDate);
                s.header = h;
                s.headerIsUpdate = true;
                //update h; 
            }

            List<genesis__Product_Rate_Card_Association__c> rcaList = new List<genesis__Product_Rate_Card_Association__c>();
            
            if (existingProductId != null & h.id != null){
                rcaLIst = [ select  id 
                            from genesis__Product_Rate_Card_Association__c
                            where 
                            genesis__CL_Product__c = :existingProductId
                            and genesis__Rate_Card_Setup__c = :h.id
                          ];
            }
            genesis__Product_Rate_Card_Association__c rca = new genesis__Product_Rate_Card_Association__c(); 
            if (rcaList.isEmpty()){
                //system.debug('*************** Rca insert');
                rca.genesis__CL_Product__c = pr.id;
                rca.genesis__Rate_Card_Setup__c = h.id;
                s.rca = rca;
                //insert rca;
            }
            else{
                system.debug('*************** Skipping rca insert' );
                rca = rcaLIst[0];
                s.rca = rca;
            }
           
            List<RateCardDetailsJSON2Apex.RateFactors> rateFactorList = d.rateFactors;

          
            List<genesis__Rate_Card_Setup_Detail__c> existingDetailList = new List<genesis__Rate_Card_Setup_Detail__c>();
            existingDetailList = [select id
                                ,rate_id__c
                                from genesis__Rate_Card_Setup_Detail__c 
                                where
                                genesis__Rate_Card_Setup_Header__c = :h.id
                                ];

            Set<String> existingDetailSet = new Set<String>();
            for (genesis__Rate_Card_Setup_Detail__c det: existingDetailList){
                    existingDetailSet.add(det.rate_id__c);
            }

            List<genesis__Rate_Card_Setup_Detail__c> insertRdList = new List<genesis__Rate_Card_Setup_Detail__c>();

            for (RateCardDetailsJSON2Apex.RateFactors f: rateFactorList){
                system.debug('f is: ' + f);
                system.debug('rate detail set: ' + existingDetailSet);
                if (existingDetailSet.contains(f.id)){
                    system.debug('************* Skipping rate id detail: ' +  f.id);
                }
                else{
                    //system.debug('************* Inserting rate id detail: ' +  f.id);
                    //system.debug('id: ' + f.id + ' term: ' + f.term + ' min: ' + f.minAmount + ' max: ' + f.maxAmount + ' actual factor: ' + f.rateFactorAmount);
                    genesis__Rate_Card_Setup_Detail__c rd = new genesis__Rate_Card_Setup_Detail__c();
                    rd.rate_id__c = f.id;
                    rd.genesis__Days_Convention__c = '30/360';  
                    rd.genesis__Maximum_Financed_Amount__c = decimal.valueOf(f.maxAmount);
                    rd.genesis__Minimum_Financed_Amount__c = decimal.valueOf(f.minAmount);
                    rd.genesis__Enabled_Flag__c = true;
                    rd.genesis__Rate_Factor__c = decimal.valueOf(f.rateFactorAmount);
                    rd.genesis__Term__c = decimal.valueOf(f.term);
                    rd.genesis__Rate_Factor_Based_On_Amount__c = 1000.00;
                    rd.group_id__c = f.groupId;
                    rd.genesis__Arrears__c = true;
                    rd.genesis__Use_Additional_Determining_Factors__c = true;
                    rd.genesis__Residual_Type__c = 'FAIR MARKET VALUE';
                    if (d.paymentFrequency == 'M')
                        rd.genesis__Payment_Frequency__c = 'MONTHLY';
                    else
                    if (d.paymentFrequency == 'Q')
                        rd.genesis__Payment_Frequency__c = 'QUARTERLY';
                    else
                    if (d.paymentFrequency == 'A')
                        rd.genesis__Payment_Frequency__c = 'ANNUALLY';
                    
                    insertRdList.add(rd);
                }
            }

            if (!insertRdList.isEmpty())
                s.detailList = insertRdList;

            //system.debug('*****************************************************************\n');
            //system.debug('*****************************************************************\n');
            system.debug('Rate Id: ' + d.id + ' Rate Card Name: ' + d.name);
            system.debug('=============END OF RATE CARD SAVING RESULTS IN SAVE LIST ====================>');
            
            

            saveList.add(s);

            //system.debug('save list size is: ' + saveList.size());
        }
        return saveList;
    }   

    /*************************************************************************************************
    * 
    * storeDataInDB - save the data in database
    *                   
    *************************************************************************************************/
    public static String storeDataInDB( dataForSave s){  

        Savepoint sp = Database.setSavepoint();

        system.debug('***** STORE IN DB *******************');

        system.debug('Header is: ' + s.header + ' headerIsUpdate: ' + s.headerIsUpdate);
        
        system.debug('Product is: ' + s.product );

        system.debug('RCA is: ' + s.rca );

        system.debug('Detail List is: ' + s.detailList );

        try { 

            system.debug( ' Data for Save is: ' + s);
            if (s.product.id == null)
                insert s.product;

            if (s.headerIsUpdate)
                update s.header;
            else{
                system.debug('s.product id is: ' + s.product.id);
                s.header.CL_Product__c = s.product.id;
                insert s.header;
            }

            s.product.Rate_Card_Setup__c = s.header.id;
            
            update s.product;
            
            if (s.rca.id == null){
                s.rca.genesis__CL_Product__c = s.product.id;
                s.rca.genesis__Rate_Card_Setup__c = s.header.id;
                insert s.rca;   
            }
            
            
           
            system.debug('genesis__Rate_Card_Setup_Detail__c: ' + s.detailList); 
            if (s.detailList != null){
                for (genesis__Rate_Card_Setup_Detail__c l:s.detailList){
                    system.debug('Detail header id is: ' + l.genesis__Rate_Card_Setup_Header__c);
                    if (l.genesis__Rate_Card_Setup_Header__c == null)
                        l.genesis__Rate_Card_Setup_Header__c = s.header.id;
                }

                if (!s.detailList.isEmpty())
                    insert s.detailList;
                
            }
        }
        catch (exception e){
            Database.rollback(sp);

            cllease__Batch_Process_Log__c b = new cllease__Batch_Process_Log__c();
            b.cllease__Message__c= e.getMessage() + '  - ' + e.getStackTraceString();
            b.name = 'RateUtility';
            b.cllease__Message__c= e.getMessage() + '  - ' + e.getStackTraceString() + e.getLineNumber();
            insert b;
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());
             
            
        }
        
        return 'OK';


    }

    /*************************************************************************************************
    * 
    * Ratecard Get Access Token - these are different than icv.
	*	
    *************************************************************************************************/
    public static string getAccessToken(){     
    	
    	//system.debug('******** getting access token');
    	if (Test.isRunningTest())
    		return string.valueOf(system.now());
    		
    	String client = System.Label.Ratecard_Client;  
    	String secret = System.Label.Ratecard_Client_Secret;  
		HttpRequest req_token = new HttpRequest();        
		
		String tokenEndpoint = System.Label.ICV_tokenendpoint;  
		req_token.setEndpoint(tokenEndpoint);
        req_token.setMethod('POST');        
        req_token.setHeader('content-type', 'application/x-www-form-urlencoded');
        req_token.setHeader('cache-control', 'no-cache');        
        req_token.setBody('client_id='+client+'&client_secret='+secret+'&grant_type=client_credentials');
      
        Http http = new Http(); 
        HTTPResponse res = http.send(req_token);
        //System.debug(string.valueOf(res));

		String access_token;

		JSONParser parser = JSON.createParser(res.getBody());
            
        while (parser.nextToken() != null) {
        	if (parser.getCurrentName() == 'access_token') {
            	access_token = parser.getText();
            	//system.debug(parser.getText());
            }
        }
        
       	//system.debug('******** returning access token');
        return access_token;
         
    }

    
    
    
}