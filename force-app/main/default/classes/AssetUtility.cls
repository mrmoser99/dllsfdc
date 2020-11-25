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
            
            if (!Test.isRunningTest())
                response=makeCallout(urlPostfix);
        
            String strResponse;
            if (Test.isRunningTest()){
                strResponse = '{"meta":{"page":1,"size":20,"sort":"name:a","itemCount":4714},"data":[{"id":9152,"code":31009977,"name":"100mm Master Macro","isActive":true,"titling":false,"serialized":false,"referencePrice":40190.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9166,"code":31009991,"name":"100mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":35690.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9149,"code":31009974,"name":"100mm Master Prime Anamorphic","isActive":true,"titling":false,"serialized":false,"referencePrice":52755.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9181,"code":31010006,"name":"100mm R Ultra Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":21415.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9153,"code":31009978,"name":"12mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":47945.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9170,"code":31009995,"name":"12mm R Ultra Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":32430.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9167,"code":31009992,"name":"135mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":39570.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9150,"code":31009975,"name":"135mm Master Prime Anamorphic","isActive":true,"titling":false,"serialized":false,"referencePrice":60515.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9182,"code":31010007,"name":"135mm R Ultra Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":25450.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9154,"code":31009979,"name":"14mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":38635.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9171,"code":31009996,"name":"14mm R Ultra Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":26845.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":8352,"code":31009180,"name":"1501X Auto folder","isActive":true,"titling":false,"serialized":true,"referencePrice":1555.0,"brandCode":30002005,"masterAssetTypeCode":107,"assetTypeCode":40000910,"programCode":53},{"id":9168,"code":31009993,"name":"150mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":44845.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9155,"code":31009980,"name":"16mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":34605.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9172,"code":31009997,"name":"16mm R Ultra Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":21415.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":3232,"code":31004110,"name":"1711","isActive":true,"titling":false,"serialized":true,"referencePrice":3970.0,"brandCode":30002005,"masterAssetTypeCode":107,"assetTypeCode":40000686,"programCode":53},{"id":9151,"code":31009976,"name":"180mm Master Prime Anamorphic","isActive":true,"titling":false,"serialized":false,"referencePrice":66720.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":9183,"code":31010008,"name":"180mm R Ultra Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":27775.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53},{"id":11931,"code":31012864,"name":"1812","isActive":true,"titling":false,"serialized":true,"referencePrice":2527.0,"brandCode":30002005,"masterAssetTypeCode":107,"assetTypeCode":40000686,"programCode":53},{"id":9156,"code":31009981,"name":"18mm Master Prime","isActive":true,"titling":false,"serialized":false,"referencePrice":32585.0,"brandCode":30001940,"masterAssetTypeCode":107,"assetTypeCode":40000931,"programCode":53}],"links":{"self":"http://assetstst1.waynemo.dll.corp:10400/api/v1/programs/53/models?page=1"}}';
            }
            else{
                strResponse = String.valueOf( response.getBody());
            }
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
            String strDetailResponse;
            if (!Test.isRunningTest()){
                HttpResponse htpResponse= makeCallout(urlPostfixD); 
                strDetailResponse = String.valueOf( htpResponse.getBody());
            }
            else{
                strDetailResponse = '{"meta":{"itemCount":1},"data":{"code":31012133,"name":"AltaLink B8165","referencePrice":25245,"isActive":true,"isTitled":false,"isSerialized":true,"program":{"code":53,"name":"Generic OE US"},"masterAssetType":{"code":107,"name":"Office Equipment"},"objectCategory":{"code":800101,"name":"Multifunctionals"},"assetType":{"code":40000667,"name":"W Multifunctionals"},"brand":{"code":30001418,"name":"Xerox"}},"links":{"self":"http://assetstst1.waynemo.dll.corp:10400/api/v1/programs/53/models/31012133/details"}}';
            }

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