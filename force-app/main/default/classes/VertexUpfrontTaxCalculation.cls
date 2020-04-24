/**
 * Author: Cloud Lending Solutions
 * Description: Following  Class helps in calculating  the Upfront Tax for Application Equipment at Generate Price
**/
/*
 Change log:

    3/27/2020 - MRM fixed cloud lending upfront tax call
*/

global class VertexUpfrontTaxCalculation {

    /**
     *  Following method helps in accepting calls from SkuId (Pricing page) for Upfront Tax Calculation
     *  and following method can request upfront taxation for one Application at a time, but accepting List
     */
    webService static String VertexGetUpfrontTax(String applicationName) {
       
         system.debug('************************ upfront tax calc routine *************************************');
        // Creating Instance Variables for holding the object details
        Map<Id, Address__c> genAddrsMap = new Map<Id,Address__c>();
        Map<Id, List<genesis__Application_Equipment__c>> appToappEqpMap     = new Map<Id, List<genesis__Application_Equipment__c>>();
        List<genesis__Application_Equipment__c> eqpListToUpdate;
        HttpResponse res;
        Integer responseCode = 0;
        VertexApi__c vertexConfig   = CLSCustomUtil.getVertexConfiguration();
        Vertex_Log__c vertexLog     = new Vertex_Log__c(); 
            
        // 1. Creating http request for the Due Detail Lines & Do Callout
        try {
            // query the Application Equipmetns for taxation
            eqpListToUpdate = [Select Id, Name,
                                    Serial_Number__c,
                                    genesis__Tax_Amount__c,
                                    genesis__Estimated_Selling_Price__c,
                                    Install_Address1__c,Install_Address1__r.City__c,
                                    Install_Address1__r.State__c, 
                                    Install_Address1__r.Zip_Code__c,
                                    genesis__Application__c,
                                    genesis__Application__r.name,
                                    genesis__Application__r.genesis__Expected_Start_Date__c,
                                    genesis__Application__r.genesis__Expected_Close_Date__c,
                                    genesis__Application__r.genesis__Account__c,
                                    genesis__Application__r.genesis__Expected_First_Payment_Date__c,
                                    genesis__Application__r.genesis__Payment_Frequency__c,
                                    genesis__Application__r.genesis__Term__c,
                                    genesis__Application__r.Purchase_Option__c,
                                    genesis__Application__r.genesis__Account__r.Tax_Exempt__c,
                                    genesis__Application_Equipment__c.Tax_Exempt__c,
                                    gard_code__c,
                                    gard__c
                                   
                                From genesis__Application_Equipment__c 
                                Where genesis__Application__r.Name = :applicationName];

            // do validate Application Equipments before taxation & Configuration
            validateEquipment(eqpListToUpdate);
            Dom.document methoddoc      = VertexUtil.getUpfrontXml(eqpListToUpdate); 
            VertexUtil.validateVertexConfig(vertexConfig);

            // Send http request to Vertex for taxation
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(vertexConfig.End_Point__c);
            req.setHeader('Content-Type', 'text/xml');
            req.setBody(methoddoc.toXMlString());

            Http http = new Http();
            // if (actual response ) else (test mock response)
            if(!System.Test.isRunningTest()) {
                res = http.send(req);
            } else {
                res = VertexHttpResponseGenerator.vertexUpfrontHTTPResponse(eqpListToUpdate);
            }
            System.debug(LoggingLevel.ERROR, ' Response Code: '+res.getStatusCode());
            responseCode = res.getStatusCode();

            // Recording Vertex Request XML & Response XML
            if(!System.Test.isRunningTest() && vertexConfig.Enable_Vertex_Xml_Logging__c) {
                vertexLog.Request_XML__c  = methoddoc.toXMlString();
                vertexLog.Response_XML__c = res.getBody();
            }

            if (responseCode == 500){
                throw new CLSCustomException('Upfront Tax Calculations failed, please verify logs for more details');
            
            }

            

        } catch(Exception e) {
            // A. Insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name='VertexUpfrontTaxCalculation: ', cllease__Date__c=system.today(), 
            cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
            // B. Skip the process in case of any exception during initial Callout Exception
            throw new CLSCustomException('Upfront Tax Calculations failed, please contact support!');

        } finally {
            // Logging the Vertex Request
            if(!System.Test.isRunningTest() && vertexConfig.Enable_Vertex_Xml_Logging__c
                && vertexLog.Request_XML__c != null && vertexLog.Response_XML__c != null) {
                vertexLog.Contract_Names__c = applicationName;
                vertexLog.Category__c       = 'UPFRONT-VERTEX TAX CALL v2';
                insert vertexLog;
            }

        }

        // 2. Processing Vertex Response SOAP only incase No HTTP Failures from 1.
        Savepoint sp = Database.setsavepoint();
        Map<String, Decimal> eqpToTaxMap = new Map<String, Decimal>();
        try {
            // Processing Response using DOM model 
            Dom.Document doc1 = new Dom.Document();
            doc1.load(res.getbody());
            // Extracting Required info from Response Dom "<soapenv:Envelope>"
            DOM.XMLNode root = doc1.getRootElement(); 
            // Processing the element "<soapenv:Body>"
            for (Dom.XMLNode child: root.getChildren()) {
                 // Processing the element "<VertexEnvelope>"
                for (Dom.XMLNode grandchild: child.getChildren()) {
                     // Processing the element "<InvoiceResponse>"
                    for (Dom.XMLNode grandchild1: grandchild.getChildren()) {
                         // Processing the element "<LineItem>"
                        for (Dom.XMLNode grandchild2: grandchild1.getChildren()) {
                             // Processing the element Child elements and extracting specific required item "TotalTax"
                            for (Dom.XMLNode grandchild3: grandchild2.getChildren()) {
                                if(grandchild2.getName()=='LineItem' && grandchild3.getName()=='TotalTax') {
                                    String eqpId            = grandchild2.getAttributeValue(grandchild2.getAttributeKeyAt(0), grandchild2.getAttributeKeyNsAt(0));
                                    Decimal eqpUpfrontTax   = Decimal.valueOf(grandchild3.getText().trim());
                                    eqpToTaxMap.put(eqpId, eqpUpfrontTax);
                                }
                            }
                        }
                    }  
                }
            } 

            // Update Equipment Tax values if details are available in response
            if(eqpToTaxMap.size() > 0) {
                Map<Id, genesis__Applications__c> appToUpdateMap = new Map<Id, genesis__Applications__c>();
                // Update the Equipment Details with Equipment's Upfront Tax
                for(genesis__Application_Equipment__c appEqp : eqpListToUpdate) {
                    Decimal eqpTaxAmount = eqpToTaxMap.get(appEqp.Id);
                    appEqp.genesis__Tax_Amount__c = eqpTaxAmount;
                    if (appEqp.genesis__Tax_Amount__c > 0){
                        appEqp.Upfront_Tax_Flag__c = true;
                        appEqp.tax_financed__c = true;
                    } 

                    // updating the tax amount in Application
                    genesis__Applications__c appToUpdate = appToUpdateMap.get(appEqp.genesis__Application__c);
                    if(appToUpdate == null) {
                        appToUpdate = new genesis__Applications__c(Id = appEqp.genesis__Application__c, genesis__Tax_Amount__c = 0);
                    }
                    system.debug('****** updating app with a tax amount');
                    system.debug('equipment tax is: ' + eqpTaxAmount);

                    appToUpdate.genesis__Tax_Amount__c += eqpTaxAmount;
                    appToUpdateMap.put(appToUpdate.Id, appToUpdate);
                }

                if(eqpListToUpdate.size() > 0) {
                    update eqpListToUpdate;
                }

                if(appToUpdateMap.size() > 0) {
                    system.debug('****** app to update' + appToUpdateMap);
                    update appToUpdateMap.values();
                }
            }

        } catch(exception e){           
            Database.rollback(sp);
            //A. insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name='VertexUpfrontTaxCalculation: ', cllease__Date__c=system.today(), 
            cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
       }

       return 'Upfront Taxation completed Successfully';
       
    }

    /**
     * Validate the Application Equipment Details 
     */
    private static void validateEquipment(List<genesis__Application_Equipment__c> appEqpList) {
        // validate app equipments availability
        if(appEqpList == null || appEqpList.size() == 0) {
            throw new CLSCustomException('Application Equipments are not available for Upfront Taxation, Please verify Application');
        }

        // Valiate the installation address details
        for(genesis__Application_Equipment__c appEqp : appEqpList) {
            if(appEqp.Install_Address1__c == null) {
                throw new CLSCustomException('Installation address is missing on Application Equipment: '+appEqp.Name);
            }
        }
    }

    public static String VertexGetUpfrontTaxBook(String applicationName) {
       
        system.debug('************************ upfront tax calc routine for booking *************************************');
       // Creating Instance Variables for holding the object details
       Map<Id, Address__c> genAddrsMap = new Map<Id,Address__c>();
       Map<Id, List<genesis__Application_Equipment__c>> appToappEqpMap     = new Map<Id, List<genesis__Application_Equipment__c>>();
       List<genesis__Application_Equipment__c> eqpListToUpdate;
       HttpResponse res;
       Integer responseCode = 0;
       VertexApi__c vertexConfig   = CLSCustomUtil.getVertexConfiguration();
       Vertex_Log__c vertexLog     = new Vertex_Log__c(); 
           
       // 1. Creating http request for the Due Detail Lines & Do Callout
       try {
           // query the Application Equipmetns for taxation
           eqpListToUpdate = [Select Id, Name,
                                   Serial_Number__c,
                                   genesis__Tax_Amount__c,
                                   genesis__Estimated_Selling_Price__c,
                                   Install_Address1__c,Install_Address1__r.City__c,
                                   Install_Address1__r.State__c, 
                                   Install_Address1__r.Zip_Code__c,
                                   genesis__Application__c,
                                   genesis__Application__r.Lease_Number__r.name,
                                   genesis__Application__r.name,
                                   genesis__Application__r.genesis__Expected_Start_Date__c,
                                   genesis__Application__r.genesis__Expected_Close_Date__c,
                                   genesis__Application__r.genesis__Account__c,
                                   genesis__Application__r.genesis__Expected_First_Payment_Date__c,
                                   genesis__Application__r.genesis__Payment_Frequency__c,
                                   genesis__Application__r.genesis__Term__c,
                                   genesis__Application__r.Purchase_Option__c,
                                   genesis__Application__r.genesis__Account__r.Tax_Exempt__c,
                                   genesis__Application_Equipment__c.Tax_Exempt__c,
                                   gard_code__c
                                  
                                   
                                  
                               From genesis__Application_Equipment__c 
                               Where genesis__Application__r.Name = :applicationName];

           // do validate Application Equipments before taxation & Configuration
           validateEquipment(eqpListToUpdate);
           Dom.document methoddoc      = VertexUtil.getUpfrontXmlBook(eqpListToUpdate); 
           if (methoddoc == null){
                system.debug('doc returned is: ' + methoddoc);
                return null;
           } 

           VertexUtil.validateVertexConfig(vertexConfig);

           // Send http request to Vertex for taxation
           HttpRequest req = new HttpRequest();
           req.setMethod('POST');
           req.setEndpoint(vertexConfig.End_Point__c);
           req.setHeader('Content-Type', 'text/xml');
           req.setBody(methoddoc.toXMlString());

           Http http = new Http();
           // if (actual response ) else (test mock response)
           if(!System.Test.isRunningTest()) {
               res = http.send(req);
           } else {
               //res = VertexHttpResponseGenerator.vertexBillHTTPResponse(dueDetailLines);
           }
           System.debug(LoggingLevel.ERROR, ' Response Code: '+res.getStatusCode());
           responseCode = res.getStatusCode();

           // Recording Vertex Request XML & Response XML
           if(!System.Test.isRunningTest() && vertexConfig.Enable_Vertex_Xml_Logging__c) {
               vertexLog.Request_XML__c  = methoddoc.toXMlString();
               vertexLog.Response_XML__c = res.getBody();
           }

       } catch(Exception e) {
           // A. Insert batch process log for exceptions
           insert new cllease__Batch_Process_Log__c(Name='VertexUpfrontTaxCalculation: ', cllease__Date__c=system.today(), 
           cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
           // B. Skip the process in case of any exception during initial Callout Exception
           throw new CLSCustomException('Upfront Tax Booking failed, please verify logs for more details');

       } finally {
           // Logging the Vertex Request
           if(!System.Test.isRunningTest() && vertexConfig.Enable_Vertex_Xml_Logging__c
               && vertexLog.Request_XML__c != null && vertexLog.Response_XML__c != null) {
               vertexLog.Contract_Names__c = applicationName;
               vertexLog.Category__c       = 'UPFRONT-VERTEX TAX CALL BOOKING v1';
               insert vertexLog;
           }

       }

       // 2. Processing Vertex Response SOAP only incase No HTTP Failures from 1.
       Savepoint sp = Database.setsavepoint();
       Map<String, Decimal> eqpToTaxMap = new Map<String, Decimal>();
       try {
           // Processing Response using DOM model 
           Dom.Document doc1 = new Dom.Document();
           doc1.load(res.getbody());
           // Extracting Required info from Response Dom "<soapenv:Envelope>"
           DOM.XMLNode root = doc1.getRootElement(); 
           // Processing the element "<soapenv:Body>"
           for (Dom.XMLNode child: root.getChildren()) {
                // Processing the element "<VertexEnvelope>"
               for (Dom.XMLNode grandchild: child.getChildren()) {
                    // Processing the element "<InvoiceResponse>"
                   for (Dom.XMLNode grandchild1: grandchild.getChildren()) {
                        // Processing the element "<LineItem>"
                       for (Dom.XMLNode grandchild2: grandchild1.getChildren()) {
                            // Processing the element Child elements and extracting specific required item "TotalTax"
                           for (Dom.XMLNode grandchild3: grandchild2.getChildren()) {
                               if(grandchild2.getName()=='LineItem' && grandchild3.getName()=='TotalTax') {
                                   String eqpId            = grandchild2.getAttributeValue(grandchild2.getAttributeKeyAt(0), grandchild2.getAttributeKeyNsAt(0));
                                   Decimal eqpUpfrontTax   = Decimal.valueOf(grandchild3.getText().trim());
                                   eqpToTaxMap.put(eqpId, eqpUpfrontTax);
                               }
                           }
                       }
                   }  
               }
           } 

           // Update Equipment Tax values if details are available in response
           if(eqpToTaxMap.size() > 0) {
               Map<Id, genesis__Applications__c> appToUpdateMap = new Map<Id, genesis__Applications__c>();
               // Update the Equipment Details with Equipment's Upfront Tax
               for(genesis__Application_Equipment__c appEqp : eqpListToUpdate) {
                   Decimal eqpTaxAmount = eqpToTaxMap.get(appEqp.Id);
                   appEqp.genesis__Tax_Amount__c = eqpTaxAmount;

                   // updating the tax amount in Application
                   genesis__Applications__c appToUpdate = appToUpdateMap.get(appEqp.genesis__Application__c);
                   if(appToUpdate == null) {
                       appToUpdate = new genesis__Applications__c(Id = appEqp.genesis__Application__c, genesis__Tax_Amount__c = 0);
                   }
                   appToUpdate.genesis__Tax_Amount__c += eqpTaxAmount;
                   appToUpdateMap.put(appToUpdate.Id, appToUpdate);
               }

               if(eqpListToUpdate.size() > 0) {
                   update eqpListToUpdate;
               }

               if(appToUpdateMap.size() > 0) {
                   update appToUpdateMap.values();
               }
           }

       } catch(exception e){           
           Database.rollback(sp);
           //A. insert batch process log for exceptions
           insert new cllease__Batch_Process_Log__c(Name='VertexUpfrontTaxCalculation: ', cllease__Date__c=system.today(), 
           cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
      }

      return 'Upfront Taxation completed Successfully';
      
   }

}