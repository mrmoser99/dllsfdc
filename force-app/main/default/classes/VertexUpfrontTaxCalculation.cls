/**
 * Author: Cloud Lending Solutions
 * Description: Following  Class helps in calculating  the Upfront Tax for Application Equipment at Generate Price
**/

Global class VertexUpfrontTaxCalculation
{
    WebService static string VertexGetUpfrontTax(list<string> applicationid)
    {
       
        Map<id,list<genesis__Application_Equipment__c>> genAppPD = new Map<id,list<genesis__Application_Equipment__c>>();
        Map<id,Address__c> genAddrsMap = new Map<id,Address__c>();
        list<genesis__Application_Equipment__c> ToUpdateAppPD = new list<genesis__Application_Equipment__c>();
    
        
        boolean equpmentAddress = False ;
        
        for(genesis__Application_Equipment__c pd:[select id,name,Serial_Number__c,Upfront_Tax_Amount__c,genesis__Estimated_Selling_Price__c,genesis__Application__c,
                                                            Install_Address1__c,Install_Address1__r.City__c,Install_Address1__r.State__c, Install_Address1__r.Zip_Code__c,
                                                            genesis__Application__r.name,genesis__Application__r.genesis__Expected_Start_Date__c,
                                                            genesis__Application__r.genesis__Expected_Close_Date__c,
                                                            genesis__Application__r.genesis__Account__c,
                                                            genesis__Application__r.genesis__Expected_First_Payment_Date__c,
                                                            genesis__Application__r.genesis__Payment_Frequency__c,
                                                            genesis__Application__r.genesis__Term__c,
                                                            GARD__c 
                                                        from genesis__Application_Equipment__c where genesis__Application__c IN : applicationid])
        {
            System.debug('**for loop frequency***'+pd.genesis__Application__r.genesis__Payment_Frequency__c); 
            if(pd.Install_Address1__c != null)
                ToUpdateAppPD.add(pd);
            else
             equpmentAddress = True ;
            }
        
        if(equpmentAddress) 
        {
            return 'false' ; // 'Tax Calculation Not Processed because one or more Equipments No Address ';
        }
        else
        {
        VertexApi__c vertexConfig = CLSCustomUtil.getVertexConfiguration();
        Vertex_Log__c vertexLog = new Vertex_Log__c(); 
        Dom.document methoddoc = VertexUtil.getUpfrontXml(ToUpdateAppPD); 
        VertexUtil.validateVertexConfig(vertexConfig);
        
        HttpResponse res;
        Integer responseCode = 0 ;
                
                System.debug(LoggingLevel.ERROR, '=================================');
                System.debug(LoggingLevel.ERROR,'methoddoccc'+methoddoc.toXmlString());
                System.debug(LoggingLevel.ERROR, '=================================');
        // B.1 Creating Http Request
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                req.setEndpoint(vertexConfig.End_Point__c);
                req.setHeader('Content-Type', 'text/xml');
                req.setBody(methoddoc.toXMlString());

                Http http = new Http();
                // if (actual response ) else (test mock response)
                if(!System.Test.isRunningTest() && vertexConfig.Enable_Vertex_Xml_Logging__c) {
                    res = http.send(req);
                    system.debug('ressssssssss'+res);
                    vertexLog.Request_XML__c  = methoddoc.toXMlString();
                    vertexLog.Response_XML__c = res.getBody();
                    vertexLog.Contract_Names__c=ToUpdateAppPD[0].genesis__Application__r.Name;
                    vertexLog.Category__c='UPFRONT_TAX-VERTEX TAX CALL';
                    insert vertexLog;
                } 
                /*else {
                    res = VertexHttpResponseGenerator.vertexUpFrontApplicationHTTPResponse(applicationid);
                }
                */
                       
                string resString = res.getbody() ;
                System.debug(' Response Code: '+resString);
                //System.debug(LoggingLevel.ERROR, ' Response Code: '+res.getbody());
                responseCode = res.getStatusCode();
                
                system.debug('*** responseCode ****'+responseCode);

                      
        map<id,decimal> upfronttaxduemap = new map<id,decimal>();

        map<string,decimal>valuesmap = new map<string,decimal>();
        
        string responsedocumentnumber;
        Dom.Document doc1 = new Dom.Document();
        doc1.load(res.getbody());
        DOM.XMLNode root = doc1.getRootElement(); 
           for (Dom.XMLNode child: root.getChildren()) {
            for (Dom.XMLNode grandchild: child.getChildren()) {
              for (Dom.XMLNode grandchild1: grandchild.getChildren()) {
               for (Dom.XMLNode grandchild2: grandchild1.getChildren()) {
                  for (Dom.XMLNode grandchild3: grandchild2.getChildren()) {
                       if(grandchild2.getName()=='LineItem' && grandchild3.getName()=='TotalTax')
                              {
                              valuesmap.put(grandchild2.getAttributeValue(grandchild2.getAttributeKeyAt(0), grandchild2.getAttributeKeyNsAt(0)),decimal.valueOf(grandchild3.getText().trim()));
                              system.debug('Mappppppppppp' + valuesmap);
                              }
                             }
                           }
                         }  
                       }
                     }  
                     
            for(genesis__Application_Equipment__c apd:ToUpdateAppPD) 
            {
                apd.Upfront_Tax_Amount__c = valuesmap.get(apd.id);
            }
                
             update ToUpdateAppPD ;
             
             system.debug('**** update Equipment details ******'+ToUpdateAppPD);       
                    
               
            return 'true' ; // 'Tax Calculation Processed Successfully';   
              
        
                 }   
    }
}