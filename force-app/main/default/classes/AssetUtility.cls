public with sharing class AssetUtility {
    
    public static Map<Integer,ModelsJSON2Apex.Data> mapModelsList = new Map<Integer,ModelsJSON2Apex.Data>();
    Public static Map<Integer, Integer> mapModelsListCode2Id= new  Map<Integer, Integer>();
    public static Map<Integer,ModelsDetailsJSON2Apex.Data> mapModelsDetails= new Map<Integer,ModelsDetailsJSON2Apex.Data>();
    Public static List<genesis__Equipment_Master__c> lstEquipmentMasterRecords=new  List<genesis__Equipment_Master__c>();
       
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
    
    public static HttpResponse makeCallout(String url){ 

        HttpResponse returnResponse;

        string endpoint = 'https://apiacc.dllgroup.com/vf/us/v1/asset-programs/53/';
       
        endpoint+=url;
                
        string strAccessToken = getAccessToken();          
        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setMethod('GET');   
        request.setHeader('originatorId', 'MOSAIC');    
        request.setHeader('messageId', 'test');   
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

   // public static Boolean getModels( Integer page){  
     public Static List<genesis__Equipment_Master__c> getModels( Integer page){   
        Boolean returnValue= false;
   ///     List<genesis__Equipment_Master__c> lstEquipmentMasterRecords=new  List<genesis__Equipment_Master__c>();
        EquipmentMasterForSave listForSave;//= new EquipmentMasterForSave();
        String urlPostfix=  'models';
        HttpResponse response;
       Savepoint sp = Database.setSavepoint();
        try{           

      //#. Make Call out  and get the response  with url postfix 
      response=makeCallout(urlPostfix);

      //#.  While endpoint is not exposed use data from StaticResource
     // StaticResource sr=[select id, Name, body from StaticResource Where name='ModelList' limit 1];
     // String fakeResponse=sr.body.tostring();// ==> 
      String strResponse=String.valueOf( response.getBody());
      system.debug('Models '+response.getStatus());
      //#.  parse the JSON body 
      //ModelsListJSON2Apex parsedResult=ModelsListJSON2Apex.parse(fakeResponse);
      ModelsJSON2Apex parsedResult=ModelsJSON2Apex.parse(strResponse);
      
          
     //#. collect the  Model code and Id in the map
            for(ModelsJSON2Apex.Data modelData: parsedResult.data){
                mapModelsListCode2Id.put(modelData.code,modelData.Id);
            }
        //for each  Brand code in the set  call Models  detail and get data to  populate the map
        mapModelsDetails.putAll(callModelsDetails(mapModelsListCode2Id.keySet()));

          // create list of EquipmentMasterWrapper
        //  List<genesis__Equipment_Master__c> lstEquipmentMasterRecords=new  List<genesis__Equipment_Master__c>();
         //Populate EquipmentMaster with the data
         integer cnt =1;
          for( Integer cod:mapModelsDetails.keySet()){

            genesis__Equipment_Master__c eq= new genesis__Equipment_Master__c();

            eq.genesis__Model__c=mapModelsDetails.get(cod).name;
            eq.Asset_Type_ID__c=String.valueOf(mapModelsDetails.get(cod).assetType.code);
            eq.Asset_Type_Name__c=mapModelsDetails.get(cod).assetType.name;

            eq.MSRP__c=Decimal.valueOf(mapModelsDetails.get(cod).referencePrice).setscale(2);
            eq.Manufacturer__c=mapModelsDetails.get(cod).brand.name;
            eq.Master_Asset_Type_ID__c=String.valueOf(mapModelsDetails.get(cod).masterAssetType.code);
            eq.Master_Asset_Type__c=mapModelsDetails.get(cod).masterAssetType.name;
            eq.Object_Category_ID__c=String.valueOf(mapModelsDetails.get(cod).objectCategory.code);
            eq.Object_Category_Name__c=mapModelsDetails.get(cod).objectCategory.name;
            eq.Economic_Life__c=64;
            eq.Composite_Key__c=mapModelsDetails.get(cod).brand.name+'-'+mapModelsDetails.get(cod).name;
            eq.Gard_External_Id__c=String.valueOf(mapModelsListCode2Id.get(cod));
            //add records into the list
            System.debug('Record#'+ cnt+'. '+eq);
            lstEquipmentMasterRecords.add(eq);
            listForSave=new EquipmentMasterForSave(eq);
           // Boolean saveresult =saveEquipmentMasterData(listForSave);
            cnt++;
          }
          //listForSave.addAll(lstEquipmentMasterRecords);
         
          System.debug('Nr of records to upsert :' + lstEquipmentMasterRecords.size());
          savedata(lstEquipmentMasterRecords);

       } catch(Exception ex){

       Database.rollback(sp);

            //Add Error log record
            cllease__Batch_Process_Log__c bchLog = new cllease__Batch_Process_Log__c();
            bchLog.name = 'EquipmentMasterUtility';
            bchLog.cllease__Message__c = ex.getMessage() + '  - ' + ex.getStackTraceString();
           insert bchLog;
            system.debug('Error Messge: '+ex.getMessage() +'\n Stack: '+ex.getStackTraceString());
        }
       // return returnValue;
       return lstEquipmentMasterRecords;
     }/*
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
    }*/
    public static Map<Integer,ModelsDetailsJSON2Apex.Data> callModelsDetails(Set<integer> modelCode){
  
        ///api/v1/programs/53/models/31001310/details
        Map<Integer,ModelsDetailsJSON2Apex.Data> mapDetailsDataToReturn= new Map<Integer,ModelsDetailsJSON2Apex.Data>();
       // String urlPostfixD=  'models/';
        for(Integer mcode:modelCode){
            String urlPostfixD=  'models/';
            System.debug('model Code '+mcode);
            urlPostfixD+=string.valueOf(mcode) +'/details';
            System.debug('urlPostfixD  '+urlPostfixD);
            HttpResponse htpResponse= makeCallout(urlPostfixD);

           // String srModelList='ModelList';
           // String srModelsModelCodeDetails='ModelsModelCodeDetails';
            
           // StaticResource sr=[select id, Name, body from StaticResource Where name='ModelsModelCodeDetails' ];
           // String detailResponse=sr.body.tostring();
            String strDetailResponse=String.valueOf( htpResponse.getBody());
            system.debug(htpResponse.getStatus());

            mapDetailsDataToReturn.putAll(getModelsDetailsData(strDetailResponse));

        }
        
        return mapDetailsDataToReturn;
    }

    public static Map<Integer,ModelsDetailsJSON2Apex.Data>  getModelsDetailsData(String dtlResponse){ 
       // public static Map<Integer,ModelsModelCodeDetailsJSON2Apex.Data>  getModelsDetailsData(HttpResponse dtlResponse){ 
        
        Map<Integer,ModelsDetailsJSON2Apex.Data> mapToReturnData= new Map<Integer,ModelsDetailsJSON2Apex.Data>();
       // ModelsModelCodeDetailsJSON2Apex parsedResultDetails= ModelsModelCodeDetailsJSON2Apex.parse(String.valueOf(dtlResponse.getBody()));
        
       //here use the Static resource for test
       ModelsDetailsJSON2Apex parsedResultDetails= ModelsDetailsJSON2Apex.parse(dtlResponse);
        
       ModelsDetailsJSON2Apex.Data dtl=parsedResultDetails.data;
         mapToReturnData.put(dtl.code, dtl);
       
         return mapToReturnData;
    } 
    public static void savedata(List<genesis__Equipment_Master__c> equ){
        upsert equ Composite_Key__c;
    }
    Public static Boolean saveEquipmentMasterData( EquipmentMasterForSave equipmentToSave){
        Boolean isSved=false;
        
            Savepoint sp = Database.setSavepoint();
            try{
                //upsert lstEquipmentMasterToSave Composite_Key__c;
                upsert equipmentToSave.EquipMaster Composite_Key__c;
                System.debug(' Records upserted successfully');
                isSved=true;
            }catch(exception e){
            //    Database.rollback(sp);

                cllease__Batch_Process_Log__c b = new cllease__Batch_Process_Log__c();
                b.cllease__Message__c= e.getMessage() + '  - ' + e.getStackTraceString();
                b.name = 'AssetUtility';
                b.cllease__Message__c= e.getMessage() + '  - ' + e.getStackTraceString() + e.getLineNumber();
                insert b;
                system.debug(e.getMessage());
            }
            
        
        return isSved;

    }
    public class EquipmentMasterForSave{
        
        public genesis__Equipment_Master__c EquipMaster {get;set;}

        public EquipmentMasterForSave(genesis__Equipment_Master__c equipment){
            this.EquipMaster=equipment;
        }
    }

}