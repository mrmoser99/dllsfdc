/*********************************************************************************************
*	Description     :   Utility class for callout the asset-programs models details
*   Name            :   AssetUtility
*   Author          :   Teshale Zewdie Accenture
*   Created Date    :   10-13-2020  
*   User Story      :   US#...
*   Last Modified By : 
*   Last Modified Date : 
*
************************************************************************************************/
public class AssetUtility {
    
   // public static Map<Integer,ModelsJSON2Apex.Data> mapModelsList = new Map<Integer,ModelsJSON2Apex.Data>();
   public static Map<Integer, Integer> mapModelsListCode2Id= new  Map<Integer, Integer>();
   public static Map<Integer,ModelsDetailsJSON2Apex.Data> mapModelsDetails= new Map<Integer,ModelsDetailsJSON2Apex.Data>();
   public static List<genesis__Equipment_Master__c> lstEquipmentMasterRecords=new  List<genesis__Equipment_Master__c>();
    public static integer cnt =1; 
    public static integer cntCallout =1; 
    public static String strAccessToken='';  
    /************************************************************************************************    
    * @Description  :   The getAccessToken method will be utilized to get the Asset access token from external system 
    * @Parameter    :   
    * @Return type  :   String
    * @Created By   :   Teshale Zewdie Accenture
    * @Created Date :   10-13-2020  
    * @User Story   :   US..
    *************************************************************************************************/       
    public static string getAccessToken(){   
            
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
            
            if(res.getStatusCode()>=200 && res.getStatusCode()<300){
                system.debug('Get Access Token *+*+* \n Response status: '+res.getStatus()+'\n Response body: '+res.getBody());
                
                //parse the body 
                JSONParser parser = JSON.createParser(res.getBody());
                //Extract the access token string  from the body
                while (parser.nextToken() != null) {
                    if (parser.getCurrentName() == 'access_token') {
                        access_token = parser.getText();
                    }
                }
                
            }else{
                    system.debug('Callout failed \n status: '+res.getStatus() + '\n status code: '+res.getStatusCode() +'\n Body: '+res.getBody());
                //    access_token= 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJbaW52YWxpZCBmaWVsZF0iLCJzY3AiOiJhc3NldC1wcm9ncmFtcy5XUklURSBwYXJ0eS5hZGQgcGFydG5lcnBvcnRmb2xpby5SRUFEIGFzc2V0LXByb2dyYW1zLlJFQUQgY29udHJhY3RwZXJmb3JtYW5jZWRhdGEuUkVBRCByZXNvdXJjZS5XUklURSBwYXJ0eS51cGRhdGUgUGFydG5lcl9JbnNpZ2h0LlJFQUQgd3JpdGUuZ3VhcmFudGVlIHZpZXdfbWFpbnRhaW5Db21taXRtZW50IHJlc291cmNlLlJFQUQgcmVhZC5ndWFybnRlZSBjcmVhdGVfYW5kX21hbmFnZV9maW5hbmNpYWxfY29udHJhY3RzIGFzc2V0cy5SRUFEIHBhcnR5LmRlbGV0ZSByYXRlY2FyZGZhY3RvcnMuUkVBRCIsInZlciI6IjEuMCIsImlzcyI6ImV4dGVybmFsZ2F0ZXdheWFjYy5kbGwuY29ycCIsIm9pZCI6IltpbnZhbGlkIGZpZWxkXSIsImdpdmVuX25hbWUiOiJObyBMREFQIiwidGlkIjoiW2ludmFsaWQgZmllbGRdIiwiYXVkIjoiW2ludmFsaWQgZmllbGRdIiwiYWNyIjoiMSIsInVwbiI6Ik5vIExEQVAiLCJ1bmlxdWVfbmFtZSI6Ik5vIExEQVAiLCJuYmYiOjE2MDQzMzc1ODgsImFwcGlkYWNyIjoiMCIsImFwcGlkIjoiMGM5YjExMmEtYzEwYy00YWM5LTgyMzMtMjUwOWQyYTQxNTcyIiwiZXhwIjoxNjA0OTQyMzg4LCJpYXQiOjE2MDQzMzc1ODgsImZhbWlseV9uYW1lIjoiTm8gTERBUCJ9.etdITkYSGHW1i8Oa4MqbssOZ_d7_I22Vpr2GZFohjiSSJbMKPhIP5CyTLVbs6LoZ304tL96XYP4fUIA7S_4Q-PTWIxiOEewl3jbscY6zBinDEZLdQUgApAg9R4J4yfQKErTowjBm5VXahWxOpiwemAEsTp1nzgjrtE_J7f2r1wm6z0KTUTWfmtQXfOl9U2Mzf05LWNc-piJwC7DoNSRfdrOAd_0ZpgjF_AZJbW4PVmSClg3VH6etSfiUU10ZblI4UY18za_GSQOO-jN2mhNKJAsScMr6-PLFv33Ojk-Uo_OCa4YsKKNLx7bV0sAXgAxRGv54o68QHddl1_DGyUV6Zg';
                
            }
            
        }catch(Exception ex){
            //Add Error log record
            cllease__Batch_Process_Log__c bchLog = new cllease__Batch_Process_Log__c();
            bchLog.name = 'AssetUtility';
            bchLog.cllease__Message__c ='Exception : '+ ex.getMessage() + '  - ' + ex.getStackTraceString();
            insert bchLog;
            system.debug('Error Messge: '+ex.getMessage() +'\n Stack: '+ex.getStackTraceString());
            
        }
        //Assign the access_token to the static variable to minimize the number of callouts
            strAccessToken  =access_token;
            return access_token;
            
    }
    /************************************************************************************************    
    * @Description  :   The makeCallout  method will be used to make a callout to asset-programs resources 
    * @Parameter    :   String
    * @Return type  :   HttpResponse
    * @Created By   :   Teshale Zewdie Accenture
    * @Created Date :   10-13-2020  
    * @User Story   :   US..
    *************************************************************************************************/ 
    public static HttpResponse makeCallout(String url){ 
        
        HttpResponse returnResponse;
        string acssToken;
        String instanceName=System.Label.icvdomain;
        String assetprogram=System.Label.asset_program;
        string endpoint = 'https://'+instanceName+'.dllgroup.com/vf/us/v1/asset-programs/'+assetprogram+'/';
        
        //Build end point url 
        endpoint+=url;

        System.debug('MakeCallout CHK II  endpoint: '+endpoint);
        //get access token from the static variable named strAccessToken
        if(String.isBlank(strAccessToken) ) {
            //if strAccessToken is empty call the getAccessToken method and initalize strAccessToken
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
            HttpResponse response = http.send(request);
            //if the request returns status code 200 (Ok ) assign the response to the return value
            if (response.getStatusCode() == 200) {
                
                returnResponse=response;
                System.debug('MakeCallout CHK II.01 Callout Nr. '+cntCallout);
                cntCallout++;

            }else{
                returnResponse=null;
                
            }
            
        }catch(Exception ex){
            //Add Error log record
            cllease__Batch_Process_Log__c bchLog = new cllease__Batch_Process_Log__c();
            bchLog.name = 'AssetUtility';
            bchLog.cllease__Message__c ='Exception : '+ ex.getMessage() + '  - ' + ex.getStackTraceString();
            insert bchLog;
            system.debug('Error Messge: '+ex.getMessage() +'\n Stack: '+ex.getStackTraceString());
            
        }
        return returnResponse;
        
    }
    /************************************************************************************************    
    * @Description  :   The getModels method will be used to convert the model details data to genesis__Equipment_Master__c records   
    * @Parameter    :   Integer
    * @Return type  :   List<genesis__Equipment_Master__c>
    * @Created By   :   Teshale Zewdie Accenture
    * @Created Date :   10-13-2020  
    * @User Story   :   US..
    *************************************************************************************************/ 
    public Static List<genesis__Equipment_Master__c> getModels( Integer page){   
        
      //  Map<Integer,ModelsDetailsJSON2Apex.Data> mapModelsDetails= new Map<Integer,ModelsDetailsJSON2Apex.Data>();
      //  Map<Integer, Integer> mapModelsListCode2Id= new  Map<Integer, Integer>();

        HttpResponse response;
        Savepoint sp ;
        String sizeString=System.Label.Asset_Page_Size;
        //Build the part of relative url string Ex. models?Page=233&Size=20
        String urlPostfix=  'models?page='+string.valueOf(page)+'&size='+sizeString;

       // List<genesis__Equipment_Master__c> lstEquipmentMasterRecords=new  List<genesis__Equipment_Master__c>();
        try{           
            //#. Make Callout to get  get the response with url string  urlPostfix
            response=makeCallout(urlPostfix);
            System.debug(' CHK 1. urlPostfix: '+urlPostfix+'\n  Make Callout response: '+response.getBody());
                if(response!= null){
                    //Get string value of the respose body
                    
                    String strResponse=String.valueOf( response.getBody());
                    
                    //Parse the the response string                     
                    ModelsJSON2Apex parsedResult=ModelsJSON2Apex.parse(strResponse);

                    System.debug('CHK 2. Item counts '+parsedResult.meta.itemCount);
                    System.debug('CHK 3. Model counts '+parsedResult.data.size());
                    
                    // From each parsed data collect the  Model code and Id in the map Ex."code": 31009981,  "id": 9156
                    for(ModelsJSON2Apex.Data modelData: parsedResult.data){
                        mapModelsListCode2Id.put(modelData.code,modelData.Id);
                        System.debug('CHK 4. Name: '+modelData.name);
                    }
                    //Create list of  Records to save 
                    if(mapModelsListCode2Id.size()>0){
                        //To make a callout for each model code details, 
                        //pass the set of the model codes as a parameter to the callModelsDetails method 
                        //Collect all the returned data Maps in the mapModelsDetails
                        mapModelsDetails.putAll(callModelsDetails(mapModelsListCode2Id.keySet()));
                        
                        //Create the genesis__Equipment_Master__c records using mapModelsDetails
                        System.debug('CHK 5. print key set'+mapModelsDetails.keySet());
                       
                        for( Integer cod:mapModelsDetails.keySet()){
                            
                            genesis__Equipment_Master__c eq= new genesis__Equipment_Master__c();
                            
                            eq.genesis__Model__c=mapModelsDetails.get(cod).name;
                            eq.Asset_Type_ID__c=String.valueOf(mapModelsDetails.get(cod).assetType.code);
                            eq.Asset_Type_Name__c=mapModelsDetails.get(cod).assetType.name;
                            
                           // eq.MSRP__c=Decimal.valueOf(mapModelsDetails.get(cod).referencePrice).setscale(2);
                            eq.MSRP__c=mapModelsDetails.get(cod).referencePrice.setscale(2);
                            if(eq.MSRP__c<=0) continue; 
                            eq.Manufacturer__c=mapModelsDetails.get(cod).brand.name;
                            eq.Master_Asset_Type_ID__c=String.valueOf(mapModelsDetails.get(cod).masterAssetType.code);
                            eq.Master_Asset_Type__c=mapModelsDetails.get(cod).masterAssetType.name;
                            eq.Object_Category_ID__c=String.valueOf(mapModelsDetails.get(cod).objectCategory.code);
                            eq.Object_Category_Name__c=mapModelsDetails.get(cod).objectCategory.name;
                            eq.Economic_Life__c=Decimal.valueOf(64);
                            eq.Composite_Key__c=String.valueOf(mapModelsDetails.get(cod).assetType.code)+'-'+mapModelsDetails.get(cod).brand.name+'-'+mapModelsDetails.get(cod).name;
                            System.debug('CHK 101. Composite_Key__c'+eq.Composite_Key__c);
                            eq.Gard_External_Id__c=String.valueOf(mapModelsListCode2Id.get(cod));
                            eq.Model_Code__c=String.valueOf(cod);//mapModelsDetails.get(cod).code
                            System.debug('Record#'+ cnt+'. '+eq);
                            //add records into the list
                            lstEquipmentMasterRecords.add(eq);
                            
                            cnt++; //Only for debug purpose
                        }
                    }
                    
                 //   sp = Database.setSavepoint();
                    if(lstEquipmentMasterRecords.size()>0){          
                        System.debug('counter ' + cnt+'\n Nr of records to upsert :' + lstEquipmentMasterRecords.size());
                        // savedata(lstEquipmentMasterRecords);
                        
                    }
            }
        } catch(Exception ex){
           // if(Sp != null)
           //     Database.rollback(sp);
            
            //Add Error log record
            cllease__Batch_Process_Log__c bchLog = new cllease__Batch_Process_Log__c();
            bchLog.name = 'AssetUtility';
            bchLog.cllease__Message__c = 'Exception : '+ex.getMessage() + '  - ' + ex.getStackTraceString();
            insert bchLog;
            system.debug('Error Messge: '+ex.getMessage() +'\n Stack: '+ex.getStackTraceString());
        }
        // return returnValue;
        //Only for debug  purpose
        
        return lstEquipmentMasterRecords;
    }
    /************************************************************************************************    
    * @Description  :   The callModelsDetails is used to get the ModelDetails 
    * @Parameter    :   Set<integer>
    * @Return type  :   Map<Integer,ModelsDetailsJSON2Apex.Data>
    * @Created By   :   Teshale Zewdie Accenture
    * @Created Date :   10-13-2020  
    * @User Story   :   US..
    *************************************************************************************************/ 
    public static Map<Integer,ModelsDetailsJSON2Apex.Data> callModelsDetails(Set<integer> modelCode){
        
        Map<Integer,ModelsDetailsJSON2Apex.Data> mapDetailsDataToReturn= new Map<Integer,ModelsDetailsJSON2Apex.Data>();
        // make callouts for each model details
        for(Integer mcode:modelCode){

            String urlPostfixD=  'models/';
            System.debug('CHK 6. model Code '+mcode);
            //Build a relative url string Ex.models/31009180/details

            urlPostfixD+=string.valueOf(mcode) +'/details';
            System.debug('CHK 7. urlPostfixD  '+urlPostfixD);
            //Make callout and assigned the result to the HttpResponse object 
            HttpResponse htpResponse= makeCallout(urlPostfixD);
            //Get the sting value of the responce Body 
            String strDetailResponse=String.valueOf( htpResponse.getBody());
            
            //To get the models detail data from getModelsDetailsData()  
            //passing the the string values of responce body as aparameter
            //then put all the returned map into mapDetailsDataToReturn
            mapDetailsDataToReturn.putAll(getModelsDetailsData(strDetailResponse));
            
        }
        //return a collection of Model detail data as a Map
        return mapDetailsDataToReturn;
    }
    /************************************************************************************************    
    * @Description  :   The  getModelsDetailsData returns the parsed model details data as a map 
    * @Parameter    :   String
    * @Return type  :   Map<Integer,ModelsDetailsJSON2Apex.Data>
    * @Created By   :   Teshale Zewdie Accenture
    * @Created Date :   10-13-2020  
    * @User Story   :   US..
    *************************************************************************************************/ 
    public static Map<Integer,ModelsDetailsJSON2Apex.Data>  getModelsDetailsData(String dtlResponse){ 
        
        Map<Integer,ModelsDetailsJSON2Apex.Data> mapToReturnData= new Map<Integer,ModelsDetailsJSON2Apex.Data>();
        
        //Parse the string value of the reponce Body from callout models detail  
        ModelsDetailsJSON2Apex parsedResultDetails= ModelsDetailsJSON2Apex.parse(dtlResponse);
        //Get the parsed result data of model details 
        ModelsDetailsJSON2Apex.Data dtl=parsedResultDetails.data;
        //Populate the map with the model details code as a key and data as a value 
        mapToReturnData.put(dtl.code, dtl);
        
        return mapToReturnData;
    } 
    /************************************************************************************************    
    * @Description  :   The savedata method upserts the genesis__Equipment_Master__c records using the field Composite_Key__c   
    * @Parameter    :   void
    * @Return type  :   List<genesis__Equipment_Master__c>
    * @Created By   :   Teshale Zewdie Accenture
    * @Created Date :   10-13-2020  
    * @User Story   :   US..
    *************************************************************************************************/ 
    public static void savedata(List<genesis__Equipment_Master__c> equ){
        //Upsert the genesis__Equipment_Master__c records.
        upsert equ Composite_Key__c;
        // System.debug('Upsert chk. Id: '+equ[equ.size()-1].id);
    }
  //  Only for debug purpose
    public static String addAttachment(List<genesis__Equipment_Master__c> equList){
         //only for the test purpose!!!
         String bodyStr='genesis__Model__c,Asset_Type_ID__c,Asset_Type_Name__c,MSRP__c,Manufacturer__c,Master_Asset_Type_ID__c,Master_Asset_Type__c,Object_Category_Name__c,Economic_Life__c,Composite_Key__c,Gard_External_Id__c';
         for(genesis__Equipment_Master__c  e: equList){
            bodyStr+='\n '+e.genesis__Model__c+','+e.Asset_Type_ID__c+','+e.Asset_Type_Name__c+','+e.MSRP__c+','+e.Manufacturer__c+','+e.Master_Asset_Type_ID__c+','+e.Master_Asset_Type__c+','+e.Object_Category_Name__c+','+e.Economic_Life__c+','+e.Composite_Key__c+','+e.Gard_External_Id__c;
            System.debug(bodyStr);
        } 
         
        Attachment att=new Attachment();
        att.Body=Blob.valueOf(bodyStr);
        //att.Name='Debug_Note_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.csv';
        att.Name='Debug_Note_' + System.now().format('yyyy_mm_dd_hh_mm_ss') + '.csv';
        att.parentId='0035C00000OvhBwQAJ'; //Attach to Bob smith contact
        insert att;
        return 'OK';
    } 
    
}