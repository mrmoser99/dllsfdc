/*********************************************************************************************
*	Description     :   Utility class for callout the asset-programs models details
*   Name            :   AssetUtility
*   10/13-2020 MRM Created
************************************************************************************************/
public class AssetUtility {
    
    public static Map<Integer, Integer> mapModelsListCode2Id= new  Map<Integer, Integer>();
    public static Map<Integer,ModelsDetailsJSON2Apex.Data> mapModelsDetails= new Map<Integer,ModelsDetailsJSON2Apex.Data>();
    public static List<genesis__Equipment_Master__c> lstEquipmentMasterRecords=new  List<genesis__Equipment_Master__c>();
    
    public static String strAccessToken=''; 

    public class MyException extends Exception {

    }
    /************************************************************************************************    
    * Description :   The getAccessToken method will be utilized to get the Asset access token from external system 
    *************************************************************************************************/       
    public static string getAccessToken(){   
            String tempMessage;
            if (Test.isRunningTest()){
                return string.valueOf(system.now());
            }

            String client = System.Label.Ratecard_Client;  
            String secret = System.Label.Ratecard_Client_Secret;  
            String tokenEndpoint = System.Label.ICV_tokenendpoint;
            String access_token='';
            HttpRequest req_token = new HttpRequest();        
            
            req_token.setEndpoint(tokenEndpoint);
            req_token.setMethod('POST');        
            req_token.setHeader('content-type', 'application/x-www-form-urlencoded');
            req_token.setHeader('cache-control', 'no-cache');              
            req_token.setBody('client_id='+client+'&client_secret='+secret+'&grant_type=client_credentials');
            //req_token.setBody('client_id='+'0c9b112a-c10c-4ac9-8233-2509d2a41572'+'&client_secret='+ 'ada7fccb-1be1-4464-a2a3-dd5d89ccc567' +'&grant_type=client_credentials');
            Http http = new Http(); 
            try{
            HTTPResponse res = http.send(req_token);           
            
            if(res.getStatusCode()==200 ){
                //system.debug('Get Access Token *+*+* \n Response status: '+res.getStatus()+'\n Response body: '+res.getBody());
                
                //parse the body 
                JSONParser parser = JSON.createParser(res.getBody());
                //Extract the access token string  from the body
                while (parser.nextToken() != null) {
                    if (parser.getCurrentName() == 'access_token') {
                        access_token = parser.getText();
                    }
                }
            }else{
                tempMessage ='Callout failed \n status: '  +res.getStatus() + '\n status code: ' + res.getStatusCode() +'\n Body: '+res.getBody();
                throw new MyException(tempMessage);
            }
        }catch(Exception ex){
            cllease__Batch_Process_Log__c bchLog = new cllease__Batch_Process_Log__c();
            bchLog.name = 'AssetUtility';
            bchLog.cllease__Message__c ='Exception : '+ tempMessage + '-' +       ex.getMessage() + '  - ' + ex.getStackTraceString();
            insert bchLog;
            
        }
        
        strAccessToken=access_token;
        return access_token;
            
    }
    /************************************************************************************************    
    * Description :   The makeCallout  method will be used to make a callout to asset-programs resources 
    *************************************************************************************************/ 
    public static HttpResponse makeCallout(String url){ 
        
        HttpResponse returnResponse;
        string acssToken;
        String instanceName=System.Label.ICVDomain;
        String assetprogram=System.Label.Asset_Program;
        string endpoint = 'https://'+instanceName+'.dllgroup.com/vf/us/v1/asset-programs/'+assetprogram+'/';
        String customErrorMessage;
        endpoint+=url;

        if(String.isBlank(strAccessToken) ) {
            strAccessToken= getAccessToken();
            acssToken=strAccessToken; 

        }else{
            acssToken=strAccessToken; 
        }       
        
        //Create a new HttpRequest and specify the required parameters
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');   
        request.setHeader('originatorId', 'MOSAIC');    
        request.setHeader('messageId', 'test');   
        request.setHeader('Accept', 'application/json');
        request.setHeader('Charset', 'UTF-8');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer '+ acssToken);
        request.setTimeout(120000);
        request.setEndpoint(endpoint); 
        
        try{
           
            // Create a new http object to send the request 
            Http http = new Http();

            //Assign the resut to the response 
            HttpResponse response;
            
            response = http.send(request);
            //if the request returns status code 200 (Ok ) assign the response to the return value
            if (response.getStatusCode() == 200) {
                returnResponse=response;
            }else{
                try{
                    response = http.send(request);
                    if (response.getStatusCode() == 200) {
                        returnResponse=response;
                    }
                    else{
                        customErrorMessage='Exception'+ url + response.getStatusCode();
                        throw new MyException (customErrorMessage);
                    }
                }
                catch(Exception ex){
                    cllease__Batch_Process_Log__c bchLog = new cllease__Batch_Process_Log__c();
                    bchLog.name = 'AssetUtility';
                    bchLog.cllease__Message__c ='Exception : '+customErrorMessage+'\n '+ ex.getMessage() + '  - ' + ex.getStackTraceString();
                    insert bchLog;
                }
            }
            
        }catch(Exception ex){
            cllease__Batch_Process_Log__c bchLog = new cllease__Batch_Process_Log__c();
            bchLog.name = 'AssetUtility';
            bchLog.cllease__Message__c ='Exception : '+customErrorMessage+'\n '+ ex.getMessage() + '  - ' + ex.getStackTraceString();
            insert bchLog;
        }
        return returnResponse;
        
    }
    /************************************************************************************************    
    * Description :   The getModels method will be used to convert the model details data to genesis__Equipment_Master__c records   
    *************************************************************************************************/ 
    public Static List<genesis__Equipment_Master__c> getModels( Integer page){   
        HttpResponse response;
        Savepoint sp ;
        String sizeString=System.Label.Asset_Page_Size;
        //Build the part of relative url string Ex. models?Page=233&Size=20
        String urlPostfix=  'models?page='+string.valueOf(page)+'&size='+sizeString;
        List<Integer> lstCode =new List<Integer>();
        try{           
            //#. Make Callout to get  get the response with url string  urlPostfix
            response=makeCallout(urlPostfix);
        
            if(response!= null){
                    
                String strResponse=String.valueOf( response.getBody());
                ModelsJSON2Apex parsedResult=ModelsJSON2Apex.parse(strResponse);
                for(ModelsJSON2Apex.Data modelData: parsedResult.data){
                    mapModelsListCode2Id.put(modelData.code,modelData.Id);
                }
                
                //Create list of  Records to save 
                if(mapModelsListCode2Id.size()>0){
      
                    mapModelsDetails.putAll(callModelsDetails(mapModelsListCode2Id.keySet()));
                    for( Integer cod:mapModelsDetails.keySet()){
                        genesis__Equipment_Master__c eq= new genesis__Equipment_Master__c();
                        eq.MSRP__c=mapModelsDetails.get(cod).referencePrice.setscale(2);
                        if(eq.MSRP__c ==0 ) {
                            continue;
                        } 
                        eq.genesis__Model__c=mapModelsDetails.get(cod).name;
                        eq.Asset_Type_ID__c=String.valueOf(mapModelsDetails.get(cod).assetType.code);
                        eq.Asset_Type_Name__c=mapModelsDetails.get(cod).assetType.name;
                        eq.Manufacturer__c=mapModelsDetails.get(cod).brand.name;
                        eq.Master_Asset_Type_ID__c=String.valueOf(mapModelsDetails.get(cod).masterAssetType.code);
                        eq.Master_Asset_Type__c=mapModelsDetails.get(cod).masterAssetType.name;
                        eq.Object_Category_ID__c=String.valueOf(mapModelsDetails.get(cod).objectCategory.code);
                        eq.Object_Category_Name__c=mapModelsDetails.get(cod).objectCategory.name;
                        eq.Economic_Life__c=Decimal.valueOf(64);
                        eq.Composite_Key__c=String.valueOf(mapModelsDetails.get(cod).assetType.code)+'-'+mapModelsDetails.get(cod).brand.name+'-'+mapModelsDetails.get(cod).name;
                        eq.Gard_External_Id__c=String.valueOf(mapModelsListCode2Id.get(cod));
                        eq.Model_Code__c=String.valueOf(cod);//mapModelsDetails.get(cod).code
                        lstEquipmentMasterRecords.add(eq);
                    }
                }
            }
        } catch(Exception ex){
            cllease__Batch_Process_Log__c bchLog = new cllease__Batch_Process_Log__c();
            bchLog.name = 'AssetUtility';
            bchLog.cllease__Message__c = 'Exception : '+ex.getMessage() + '  - ' + ex.getStackTraceString();
            insert bchLog;
        }
        
        return lstEquipmentMasterRecords;
        
    }
    /************************************************************************************************    
    * Description :   The callModelsDetails is used to get the ModelDetails 
    *************************************************************************************************/ 
    public static Map<Integer,ModelsDetailsJSON2Apex.Data> callModelsDetails(Set<integer> modelCode){
        
        Map<Integer,ModelsDetailsJSON2Apex.Data> mapDetailsDataToReturn= new Map<Integer,ModelsDetailsJSON2Apex.Data>();
        // make callouts for each model details
        for(Integer mcode:modelCode){

            String urlPostfixD=  'models/';
            urlPostfixD+=string.valueOf(mcode) +'/details';
            HttpResponse htpResponse= makeCallout(urlPostfixD);
            String strDetailResponse=String.valueOf( htpResponse.getBody());
            mapDetailsDataToReturn.putAll(getModelsDetailsData(strDetailResponse));
            
        }
        return mapDetailsDataToReturn;
    }
    /************************************************************************************************    
    * Description :   The  getModelsDetailsData returns the parsed model details data as a map 
    *************************************************************************************************/ 
    public static Map<Integer,ModelsDetailsJSON2Apex.Data>  getModelsDetailsData(String dtlResponse){ 
        
        Map<Integer,ModelsDetailsJSON2Apex.Data> mapToReturnData= new Map<Integer,ModelsDetailsJSON2Apex.Data>();
        ModelsDetailsJSON2Apex parsedResultDetails= ModelsDetailsJSON2Apex.parse(dtlResponse);
        ModelsDetailsJSON2Apex.Data dtl=parsedResultDetails.data;
        mapToReturnData.put(dtl.code, dtl);
        return mapToReturnData;
    } 
    
}