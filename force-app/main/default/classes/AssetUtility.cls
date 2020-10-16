public with sharing class AssetUtility {
    
    public static Map<Integer,ModelsListJSON2Apex.Data> mapModelsList = new Map<Integer,ModelsListJSON2Apex.Data>();
    Public static Map<Integer, Integer> mapModelsListCode2Id= new  Map<Integer, Integer>();
    public static Map<Integer,ModelsModelCodeDetailsJSON2Apex.Data> mapModelsModelCodeDetails= new Map<Integer,ModelsModelCodeDetailsJSON2Apex.Data>();
    
    public static string getAccessToken(){     
    	
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
        String access_token;

		JSONParser parser = JSON.createParser(res.getBody());
            
        while (parser.nextToken() != null) {
        	if (parser.getCurrentName() == 'access_token') {
            	access_token = parser.getText();
            	}
        }
       return access_token;
         
    }
    public static HttpResponse makeCallout( String url){ 

        HttpResponse returnResponse;
        string endpoint = 'http://assetsdev4.waynemo.dll.corp:9400/api/v1/programs/53/';
       //  endpoint= url;
       // http://assetsdev4.waynemo.dll.corp:9400/api/v1/programs/53/models
        //http://assetsdev4.waynemo.dll.corp:9400/api/v1/programs/53/models/31001310
        //http://assetsdev4.waynemo.dll.corp:9400/api/v1/programs/53/models/31001310/details
       
        endpoint+=url;
                
        string strAccessToken = getAccessToken();          
        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setMethod('GET');   
        request.setHeader('originatorId', 'MOSAIC');    
        request.setHeader('messageId', 'Test');   
        request.setHeader('Accept', 'application/json');
        request.setHeader('Charset', 'UTF-8');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer '+ strAccessToken);

        request.setEndpoint(endpoint); 
        try{

            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {

                returnResponse=response;
            }else{
                returnResponse=null;

            }

        }catch(Exception ex){
             //Add Error log record
             cllease__Batch_Process_Log__c bchLog = new cllease__Batch_Process_Log__c();
             bchLog.name = 'AssetUtility';
             bchLog.cllease__Message__c = ex.getMessage() + '  - ' + ex.getStackTraceString();
             insert bchLog;
             system.debug('Error Messge: '+ex.getMessage() +'\n Stack: '+ex.getStackTraceString());

        }
        return returnResponse;

    }

    public static Boolean getModels( Integer page){  
        
        Boolean returnValue= false;

        String urlPostfix=  'models';
        HttpResponse response;
        try{
      //#. Make Call out  and get the response  with url postfix 
      //  response=makeCallout(urlPostfix);

      //#.  While endpoint is not exposed use data from StaticResource

      StaticResource sr=[select id, Name, body from StaticResource Where name='ModelList' limit 1];
      String fakeResponse=sr.body.tostring();// ==> String.valueOf( response.getBody())

      //#.  parse the JSON body 
      ModelsListJSON2Apex parsedResult=ModelsListJSON2Apex.parse(fakeResponse);
          
     //#. collect the  Model code and Id in the map
            for(ModelsListJSON2Apex.Data modelData: parsedResult.data){
                mapModelsListCode2Id.put(modelData.code,modelData.Id);
            }
        //for each  Brand code in the set  call Models  detail and get data to  populate the map
           mapModelsModelCodeDetails.putAll(callModelsDetails(mapModelsListCode2Id.keySet()));

          // create list of EquipmentMasterWrapper
          List<genesis__Equipment_Master__c> lstEquipmentMasterToSave=new  List<genesis__Equipment_Master__c>();
         //Populate EquipmentMasterWrapper with the data
          for( Integer cod:mapModelsModelCodeDetails.keySet()){

            genesis__Equipment_Master__c eq= new genesis__Equipment_Master__c();

            eq.genesis__Model__c=mapModelsModelCodeDetails.get(cod).name;
            eq.Asset_Type_ID__c=String.valueOf(mapModelsModelCodeDetails.get(cod).assetType.code);
            eq.Asset_Type_Name__c=mapModelsModelCodeDetails.get(cod).assetType.name;
            eq.MSRP__c=mapModelsModelCodeDetails.get(cod).referencePrice;
            eq.Manufacturer__c=mapModelsModelCodeDetails.get(cod).brand.name;
            eq.Master_Asset_Type_ID__c=String.valueOf(mapModelsModelCodeDetails.get(cod).masterAssetType.code);
            eq.Master_Asset_Type__c=mapModelsModelCodeDetails.get(cod).masterAssetType.name;
            eq.Object_Category_ID__c=String.valueOf(mapModelsModelCodeDetails.get(cod).objectCategory.code);
            eq.Object_Category_Name__c=mapModelsModelCodeDetails.get(cod).objectCategory.name;
            eq.Economic_Life__c=64;
            eq.Composite_Key__c=mapModelsModelCodeDetails.get(cod).brand.name+'-'+mapModelsModelCodeDetails.get(cod).name;
            eq.Gard_External_Id__c=String.valueOf(mapModelsListCode2Id.get(cod));
            //add records into the list
            System.debug(eq);
            lstEquipmentMasterToSave.add(eq);

          }
          System.debug('Nr of records to upsert :' + lstEquipmentMasterToSave.size());
      //  upsert lstEquipmentMasterToSave;
      
        // System.debug('record to upsert'+lstEquipmentMasterToSave);
        // Save the data
        List<Database.UpsertResult> upResults= Database.upsert(lstEquipmentMasterToSave, false);
        for(Database.UpsertResult rslt:upResults){
            if(rslt.isSuccess() && rslt.isCreated()){
                System.debug(upResults.size()+ ' Items upserted Successfuly');
            }
        }

        returnValue=true;

        } catch(Exception ex){
            //Add Error log record
            cllease__Batch_Process_Log__c bchLog = new cllease__Batch_Process_Log__c();
            bchLog.name = 'EquipmentMasterUtility';
            bchLog.cllease__Message__c = ex.getMessage() + '  - ' + ex.getStackTraceString();
          //  insert bchLog;
            system.debug('Error Messge: '+ex.getMessage() +'\n Stack: '+ex.getStackTraceString());
        }
        return returnValue;
     }
     public static Map<Integer,ModelsListJSON2Apex.Data>  getModelsData(String uResponse){  
         //public static Map<Integer,ModelsListJSON2Apex.Data>  getModelsData(HttpResponse uResponse){ 
        Map<Integer,ModelsListJSON2Apex.Data> mapModelsData = new Map<Integer,ModelsListJSON2Apex.Data>();
    
       // ModelsListJSON2Apex parsedResult=ModelsListJSON2Apex.parse(String.valueOf( uResponse.getBody()));
        ModelsListJSON2Apex parsedResult=ModelsListJSON2Apex.parse(uResponse);
        if(parsedResult==null){
            return null;
        } else {
           
           for(ModelsListJSON2Apex.Data d:parsedResult.data){
              
            mapModelsData.put(d.code, d);              
            
            }          
        } 
        return   mapModelsData;     
    }
    public static Map<Integer,ModelsModelCodeDetailsJSON2Apex.Data> callModelsDetails(Set<integer> modelCode){
  
        ///api/v1/programs/53/models/31001310/details
        Map<Integer,ModelsModelCodeDetailsJSON2Apex.Data> mapDetailsDataToReturn= new Map<Integer,ModelsModelCodeDetailsJSON2Apex.Data>();
        String urlPostfixD=  'models';
  //      for(Integer mcode:modelCode){
      //      urlPostfixD+=string.valueOf(mcode) +'details';
       //     HttpResponse detailResponse= makeCallout(urlPostfixD);

           // String srModelList='ModelList';
            String srModelsModelCodeDetails='ModelsModelCodeDetails';
            
            StaticResource sr=[select id, Name, body from StaticResource Where name='ModelsModelCodeDetails' ];
            String detailResponse=sr.body.tostring();
            //system.debug(detailResponse);

            mapDetailsDataToReturn.putAll(getModelsDetailsData(detailResponse));

     //   }
        
        return mapDetailsDataToReturn;
    }
    public static Map<Integer,ModelsModelCodeDetailsJSON2Apex.Data>  getModelsDetailsData(String dtlResponse){ 
       // public static Map<Integer,ModelsModelCodeDetailsJSON2Apex.Data>  getModelsDetailsData(HttpResponse dtlResponse){ 
        
        Map<Integer,ModelsModelCodeDetailsJSON2Apex.Data> mapToReturnData= new Map<Integer,ModelsModelCodeDetailsJSON2Apex.Data>();
       // ModelsModelCodeDetailsJSON2Apex parsedResultDetails= ModelsModelCodeDetailsJSON2Apex.parse(String.valueOf(dtlResponse.getBody()));
        
       //here use the Static resource for test
        ModelsModelCodeDetailsJSON2Apex parsedResultDetails= ModelsModelCodeDetailsJSON2Apex.parse(dtlResponse);
        
        ModelsModelCodeDetailsJSON2Apex.Data dtl=parsedResultDetails.data;
         mapToReturnData.put(dtl.code, dtl);
       
         return mapToReturnData;
    } 

}