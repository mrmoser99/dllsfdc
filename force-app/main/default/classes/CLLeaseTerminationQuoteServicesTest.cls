@isTest
public class CLLeaseTerminationQuoteServicesTest { 
    private static String jsonString='';
    
    @isTest
    public static void testHttpPost(){
        // Creating Contract through Util
        Testhelper.getVertexCustomSettings();
        // Creating Contract using TestHelper     
        cllease__Lease_Account__c leaseContract = createContract();
        system.debug('Contract Created: '+leaseContract.Name);
        
        // Create Termination Configuration
        List<cllease__Termination_Config__c> configList = new List<cllease__Termination_Config__c>();
        cllease__Termination_Config__c config = new cllease__Termination_Config__c();
        config.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
        config.cllease__Enable__c           = true;
        configList.add(config);
        
        cllease__Termination_Config__c config1 = new cllease__Termination_Config__c();
        config1.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config1.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config1.cllease__Quote_Type__c       = 'TERMINATION WITHOUT PURCHASE';
        config1.cllease__Enable__c           = true;
        configList.add(config1);
        
        insert configList;
        
        List<cllease__Termination_Config_Line__c> configLines = new List<cllease__Termination_Config_Line__c>();
        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE UNBILLED RECEIVABLES',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE UNBILLED RECEIVABLE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Receivable__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Unbilled_Receivable__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Unbilled_Receivable_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Service_and_Maintenance__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Service_and_Maintainence__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Service_and_Maintenance_TAX__c',
                                                                Do_Passthrough__c               = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Rollover_Incentive__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Rollover_Incentive_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Field_API_Name__c      = 'Booked_Residual__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Purchase_Amount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Purchase_Amount_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE FEE',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE FEE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Fee__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Fee_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Add_To_Quote_Amount__c = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Estimated_Property_Tax__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Estimated_Property_Tax__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Estimated_Property_Tax_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE DISCOUNT',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE DISCOUNT',
                                                                cllease__Field_API_Name__c      = 'Quote_Discount_Roll_over__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Discount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Discount_TAX__c'
                                                                ));
        insert configLines;
        
        List<cllease__Contract_Equipment__c> equipList = [select id,name,cllease__Contract__c,cllease__Equipment_Serial_Number__c,cllease__Make__c,cllease__Model__c,Install_Date__c,Install_Address__r.name,
                                                                Install_Address__r.Address_Line_1__c, Install_Address__r.City__c,Install_Address__r.State__c,Install_Address__r.Zip_Code__c
                                                                from cllease__Contract_Equipment__c where cllease__Contract__c=:leaseContract.id];
        system.debug('equipList=' +equipList);
            
        
        JSONGenerator gen = JSON.createGenerator(false); 
        gen.writeStartObject(); 
        gen.writeStringField('Contract Name',(leaseContract.name!=null)?leaseContract.name:'');
        gen.writeFieldName('Equipments');
        gen.writeStartArray();
        for(cllease__Contract_Equipment__c equip : equipList){
            gen.writeStartObject();
            gen.writeStringField('equipName', (equip.name!=null)?equip.name:'');
            gen.writeEndObject();
        }
          gen.writeEndArray();
            
         gen.writeStringField('Quote Type','TERMINATION WITH PURCHASE');
         gen.writeDateField('Termination Date',System.today());
         gen.writeStringField('Quote Status','ACCEPTED');
           
         gen.writeEndObject();
         jsonString = gen.getAsString();
        system.debug('jsonString=' +jsonString);
        
        RestRequest request = new RestRequest(); 
        RestResponse res = new RestResponse();             
        request.requestUri ='https://newco--dev.my.salesforce.com/services/apexrest/CreateTerminationQouteCopy/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json'); 
        request.requestBody = Blob.valueof(jsonString); 
        RestContext.request = request;
        RestContext.response= res;
        system.debug('ResBody =' +res.responseBody);
        
        System.Test.startTest();
        String resBody =CLLeaseTerminationQuoteServices.generateTerminationQuotes();
        System.debug('resBody==' +resBody); 
        System.Test.stopTest();
    }
    
    @isTest
    public static void testHttpPatch(){
        // Creating Contract through Util
        Testhelper.getVertexCustomSettings();
        // Creating Contract using TestHelper     
        cllease__Lease_Account__c leaseContract = createContract();
        system.debug('Contract Created: '+leaseContract.Name);
        
        // Create Termination Configuration
        List<cllease__Termination_Config__c> configList = new List<cllease__Termination_Config__c>();
        cllease__Termination_Config__c config = new cllease__Termination_Config__c();
        config.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
        config.cllease__Enable__c           = true;
        configList.add(config);
        
        cllease__Termination_Config__c config1 = new cllease__Termination_Config__c();
        config1.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config1.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config1.cllease__Quote_Type__c       = 'TERMINATION WITHOUT PURCHASE';
        config1.cllease__Enable__c           = true;
        configList.add(config1);
        
        insert configList;
        
        List<cllease__Termination_Config_Line__c> configLines = new List<cllease__Termination_Config_Line__c>();
        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE UNBILLED RECEIVABLES',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE UNBILLED RECEIVABLE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Receivable__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Unbilled_Receivable__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Unbilled_Receivable_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Service_and_Maintenance__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Service_and_Maintainence__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Service_and_Maintenance_TAX__c',
                                                                Do_Passthrough__c               = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Rollover_Incentive__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Rollover_Incentive_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Field_API_Name__c      = 'Booked_Residual__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Purchase_Amount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Purchase_Amount_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE FEE',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE FEE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Fee__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Fee_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Add_To_Quote_Amount__c = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Estimated_Property_Tax__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Estimated_Property_Tax__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Estimated_Property_Tax_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE DISCOUNT',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE DISCOUNT',
                                                                cllease__Field_API_Name__c      = 'Quote_Discount_Roll_over__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Discount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Discount_TAX__c'
                                                                ));
         insert configLines;
         
        cllease__Termination_Quote_Header__c quoteHeader = new cllease__Termination_Quote_Header__c();
        quoteHeader.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
        quoteHeader.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader.cllease__Status__c                      = 'GENERATED';
        quoteHeader.cllease__Contract__c                    = leaseContract.Id;
        quoteHeader.cllease__Requested_Termination_Date__c  = System.today();
        quoteHeader.cllease__Termination_Date__c            = System.today();
        quoteHeader.cllease__Effective_From__c              = System.today();
        quoteHeader.cllease__Effective_To__c                = System.today().addDays(30);
        insert quoteHeader;
        
        // Creating Termination Quote Lines
        List<cllease__Termination_Quote_Line__c> quoteLines = new List<cllease__Termination_Quote_Line__c>();
        for(cllease__Termination_Config_Line__c configLine : configLines) {
            quoteLines.add(new cllease__Termination_Quote_Line__c(cllease__Amount__c                    = 100, 
                                                                     cllease__Line_Type__c               = configLine.cllease__Quote_Line__c,
                                                                     cllease__Amount_Type__c             = 'LINE',
                                                                     cllease__Billable__c                = true,
                                                                     cllease__Account_Balance_Type__c    = configLine.cllease__Account_Balance_Type__c,
                                                                     cllease__Is_Account_Balancable__c   = false,
                                                                     cllease__Add_To_Quote_Amount__c     = true,
                                                                     cllease__Bill_Field_API_Name__c     = configLine.cllease__Bill_Field_API_Name__c,
                                                                     cllease__Quote_Header__c            = quoteHeader.Id));
        }
        insert quoteLines;
        
        List<cllease__Contract_Equipment__c> equipList = [select id,name,cllease__Contract__c,cllease__Equipment_Serial_Number__c,cllease__Make__c,cllease__Model__c,Install_Date__c,Install_Address__r.name,
                                                                Install_Address__r.Address_Line_1__c, Install_Address__r.City__c,Install_Address__r.State__c,Install_Address__r.Zip_Code__c
                                                                from cllease__Contract_Equipment__c where cllease__Contract__c=:leaseContract.id];
        system.debug('equipList=' +equipList);
        
        // Creatign Termination QUote Equipment
        List<cllease__Termination_Quote_Equipment__c> termQuoteEqpList = new List<cllease__Termination_Quote_Equipment__c>();
        for(cllease__Contract_Equipment__c eqp : equipList) {
            termQuoteEqpList.add(new cllease__Termination_Quote_Equipment__c(cllease__Contract_Equipment__c = eqp.Id, cllease__Termination_Quote_Header__c = quoteHeader.Id));
        }
        insert termQuoteEqpList;
        
         JSONGenerator gen = JSON.createGenerator(false);  
         gen.writeStartObject(); 
         gen.writeStringField('QuoteNumber',(quoteHeader.id!=null)?quoteHeader.id:'');
         gen.writeFieldName('QuoteLines');
         gen.writeStartArray();
         for(cllease__Termination_Quote_Line__c quoteLine : quoteLines){
              gen.writeStartObject();
              gen.writeNumberField(((quoteLine.cllease__Line_Type__c!=null)?quoteLine.cllease__Line_Type__c:''), 550); 
              gen.writeEndObject();
         }
             gen.writeEndArray();
             gen.writeEndObject();
             jsonString = gen.getAsString();
             //System.debug('Response : ' + gen.getAsString());  
             System.debug('Input jsonString : ' + jsonString); 
        
        RestRequest request = new RestRequest(); 
        RestResponse res = new RestResponse();             
        request.requestUri ='https://newco--dev.my.salesforce.com/services/apexrest/CreateTerminationQouteCopy/';
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json'); 
        request.requestBody = Blob.valueof(jsonString); 
        RestContext.request = request;
        RestContext.response= res;
        system.debug('ResBody =' +res.responseBody);
        
        System.Test.startTest();
        String resBody =CLLeaseTerminationQuoteServices.updateTerminationQuote();
        System.debug('resBody==' +resBody); 
        System.Test.stopTest();
        
      }
    
    @isTest
    public static void testHttpPatchWithoutQuoteLine(){
        // Creating Contract through Util
        Testhelper.getVertexCustomSettings();
        // Creating Contract using TestHelper     
        cllease__Lease_Account__c leaseContract = createContract();
        system.debug('Contract Created: '+leaseContract.Name);
        
        // Create Termination Configuration
        List<cllease__Termination_Config__c> configList = new List<cllease__Termination_Config__c>();
        cllease__Termination_Config__c config = new cllease__Termination_Config__c();
        config.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
        config.cllease__Enable__c           = true;
        configList.add(config);
        
        cllease__Termination_Config__c config1 = new cllease__Termination_Config__c();
        config1.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config1.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config1.cllease__Quote_Type__c       = 'TERMINATION WITHOUT PURCHASE';
        config1.cllease__Enable__c           = true;
        configList.add(config1);
        
        insert configList;
        
        List<cllease__Termination_Config_Line__c> configLines = new List<cllease__Termination_Config_Line__c>();
        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE UNBILLED RECEIVABLES',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE UNBILLED RECEIVABLE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Receivable__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Unbilled_Receivable__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Unbilled_Receivable_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Service_and_Maintenance__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Service_and_Maintainence__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Service_and_Maintenance_TAX__c',
                                                                Do_Passthrough__c               = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Rollover_Incentive__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Rollover_Incentive_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Field_API_Name__c      = 'Booked_Residual__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Purchase_Amount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Purchase_Amount_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE FEE',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE FEE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Fee__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Fee_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Add_To_Quote_Amount__c = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Estimated_Property_Tax__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Estimated_Property_Tax__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Estimated_Property_Tax_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE DISCOUNT',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE DISCOUNT',
                                                                cllease__Field_API_Name__c      = 'Quote_Discount_Roll_over__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Discount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Discount_TAX__c'
                                                                ));
         insert configLines;
         
        cllease__Termination_Quote_Header__c quoteHeader = new cllease__Termination_Quote_Header__c();
        quoteHeader.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
        quoteHeader.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader.cllease__Status__c                      = 'GENERATED';
        quoteHeader.cllease__Contract__c                    = leaseContract.Id;
        quoteHeader.cllease__Requested_Termination_Date__c  = System.today();
        quoteHeader.cllease__Termination_Date__c            = System.today();
        quoteHeader.cllease__Effective_From__c              = System.today();
        quoteHeader.cllease__Effective_To__c                = System.today().addDays(30);
        insert quoteHeader;
        
        // Creating Termination Quote Lines
        List<cllease__Termination_Quote_Line__c> quoteLines = new List<cllease__Termination_Quote_Line__c>();
        for(cllease__Termination_Config_Line__c configLine : configLines) {
            quoteLines.add(new cllease__Termination_Quote_Line__c(cllease__Amount__c                    = 100, 
                                                                     cllease__Line_Type__c               = configLine.cllease__Quote_Line__c,
                                                                     cllease__Amount_Type__c             = 'LINE',
                                                                     cllease__Billable__c                = true,
                                                                     cllease__Account_Balance_Type__c    = configLine.cllease__Account_Balance_Type__c,
                                                                     cllease__Is_Account_Balancable__c   = false,
                                                                     cllease__Add_To_Quote_Amount__c     = true,
                                                                     cllease__Bill_Field_API_Name__c     = configLine.cllease__Bill_Field_API_Name__c,
                                                                     cllease__Quote_Header__c            = quoteHeader.Id));
        }
        insert quoteLines;
        
        JSONGenerator gen = JSON.createGenerator(false);  
        gen.writeStartObject(); 
        gen.writeStringField('QuoteNumber', (quoteHeader.id!=null)?quoteHeader.id:'');
        gen.writeEndObject();
        jsonString = gen.getAsString();
        //System.debug('Response : ' + gen.getAsString());  
        System.debug('Input jsonString : ' + jsonString); 
        
        RestRequest request = new RestRequest(); 
        RestResponse res = new RestResponse();             
        request.requestUri ='https://newco--dev.my.salesforce.com/services/apexrest/CreateTerminationQouteCopy/';
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json'); 
        request.requestBody = Blob.valueof(jsonString); 
        RestContext.request = request;
        RestContext.response= res;
        system.debug('ResBody =' +res.responseBody);
        
        System.Test.startTest();
        String resBody =CLLeaseTerminationQuoteServices.updateTerminationQuote();
        System.debug('resBody==' +resBody); 
        System.Test.stopTest();
                       
    }
    
    
    //Create Contract
    public static cllease__Lease_Account__c createContract() {
        cllease.TestHelper.createSeedDataForTesting();
        // Setting Current System Date in Test Context
        Date currentSystemDate = Date.newInstance(2018, 03, 31);
        // 1. Pre-Setup
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        dummyFee.clcommon__Amount__c            = 100;
        dummyFee.clcommon__Amortization_Method__c  = 'Income Basis';
        update dummyFee;
        clcommon__Fee_Set__c  dummyFeeSet       = cllease.Testhelper.createLeaseFeeSet();
        insert new clcommon__Fee_Junction__c( clcommon__Fee__c = dummyFee.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);

        clcommon__Fee_Definition__c  dummyFee2   = cllease.Testhelper.createLeaseFee();
        dummyFee2.clcommon__Type__c              = 'NSF Fees';
        dummyFee2.clcommon__Amount__c            = 100;
        dummyFee2.clcommon__Amortization_Method__c  = 'Income Basis';
        update dummyFee2;

        insert new clcommon__Fee_Junction__c(clcommon__Fee__c = dummyFee2.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);
        insert new cllease__Transaction_Sub_Type__c(Name = 'NSF Fees');

        clcommon__Fee_Definition__c  latefee   = cllease.Testhelper.createLeaseFee();
        latefee.clcommon__Type__c              = 'Late Fees';
        latefee.clcommon__Calculation_Method__c= 'AMOUNT CALCULATED AS % OF RENT DUE';
        latefee.clcommon__Amount__c            = 25;
        update latefee;

        insert new clcommon__Fee_Junction__c(clcommon__Fee__c = latefee.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);
        insert new cllease__Transaction_Sub_Type__c(Name = 'Late Fees');

        cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office', true);
        dummyOffice.cllease__Current_System_Date__c = currentSystemDate;
        dummyOffice.Dll_Seg1_Company__c         = '00101';
        dummyOffice.Dll_Seg2_Business_Unit__c   = '02';
        dummyOffice.Dll_Seg3_Department__c      = '3030';
        dummyOffice.Dll_Seg6__c                 = '00000';
        dummyOffice.Dll_Seg7__c                 = '0000';
        update dummyOffice;

        TestData.createPeriodsFor2018(dummyOffice.cllease__Calendar__c);
        
        // Creating Default bill group
        clcommon__Billing_Group__c billGroup = new clcommon__Billing_Group__c(Name = 'Default Bill Group');
        insert billGroup;
        
        //Create payment clcommon payment spread
        clcommon__Payment_Spread__c paymentSpread = new clcommon__Payment_Spread__c(clcommon__Spread_Description__c = 'Default Spread', clcommon__Enabled__c = 'Yes', clcommon__Tax_Configuration__c = 'DISTRIBUTE');
        insert paymentSpread; 
        
        // Create GL Account
        cllease__GL_Account__c account = new cllease__GL_Account__c(Name = 'On Account', cllease__Account_Code__c = '5007');
        insert account;
        
        List<clcommon__Payment_Spread_Detail__c> spreadList = new List<clcommon__Payment_Spread_Detail__c>();
        spreadList.add(new clcommon__Payment_Spread_Detail__c(clcommon__Contract_Management_System__c = 'CL-Lease', clcommon__Sequence_Number__c = 1,
                                                              clcommon__Balance_Type__c = 'LEASE RECEIVABLE', clcommon__Enabled__c = 'Yes',
                                                              clcommon__Payment_Spread__c = paymentSpread.Id));
        spreadList.add(new clcommon__Payment_Spread_Detail__c(clcommon__Contract_Management_System__c = 'CL-Lease', clcommon__Sequence_Number__c = 2,
                                                              clcommon__Balance_Type__c = 'FEES', clcommon__Enabled__c = 'Yes',
                                                              clcommon__Payment_Spread__c = paymentSpread.Id));
        insert spreadList;

        Account dummyAccount = new Account(Name = 'Sample Account', clcommon__Generate_Invoice_Letter__c = true);
        insert dummyAccount;
        
        // Creating 'ON ACCOUNT' 
        cllease__Transaction_Sub_Type__c onAcc = new cllease__Transaction_Sub_Type__c(Name = 'ON ACCOUNT');
        insert onAcc;
        
        // Creating 'ON ACCOUNT PAYMENT MODE' 
        clcommon__Payment_Mode__c onAccPmtMode = new clcommon__Payment_Mode__c(Name = 'ON ACCOUNT');
        insert onAccPmtMode;

        // 2. Creating Sample Product with rental and Dep Streams enabled
        cllease__Lease_Product__c dummyLP    = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        dummyLP.cllease__Use_Open_Acct_Period__c = true;
        update dummyLP;

        clcommon__Agreement__c dealerProgram =new clcommon__Agreement__c(Name='NewCo');
        insert dealerProgram;

        Address__c address = new Address__c (
        Address_Line_1__c   = '123 Main Street',
        City__c             = 'Morristown',
        State__c            = 'NJ',
        County__c           = 'Morris',
        Country__c          = 'USA',
        Account__c          = dummyAccount.Id,
        Bill_To_Usage__c    = true,
        Install_At__c       = true,
        Validation_Status__c = DLLNewCoConstants.EXPERIAN_VALIDATION_STATUS,
        Zip_Code__c         = '95307-7506'
       );
       insert address;

        // 3.Creating Contract
        Date currentDate = currentSystemDate;
        cllease__Lease_Account__c leaseAccount      = new cllease__Lease_Account__c();
        leaseaccount.cllease__Account__c            = dummyAccount.Id;
        leaseAccount.cllease__Lease_Product_Name__c = dummyLP.Id;
        leaseAccount.cllease__Contract_Date__c      = currentDate;
        leaseaccount.cllease__Financed_Amount__c    = 10000;
        //leaseaccount.cllease__Residual_Amount__c    = 1000;
        leaseAccount.cllease__Term__c               = 12;
        leaseaccount.Dealer_Program__c              = dealerProgram.Id;

        // 3.a Adding Equipments to Contract
        List<cllease__Contract_Equipment__c> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c   = 10000,
                                                                    Evergreen_Depreciable_Cost__c       = 950,
                                                                    Remaining_Evergreen_Depreciable_Cost__c = 950,
                                                                    Salvage_Value__c                    = 50,
                                                                    cllease__life_in_months__c          = 14,
                                                                    cllease__Status__c                  = 'LEASED',
                                                                    Install_Address__c                  = address.Id,
                                                                    Install_Account__c                  = dummyAccount.Id,
                                                                    cllease__Equipment_Type__c='TRUCK',
                                                                    cllease__Equipment_Serial_Number__c='SFKLJADK',
                                                                    cllease__Equipment_Description__c='',
                                                                    cllease__Equipment_Cost__c=10000,
                                                                    cllease__Model__c='WC8473',
                                                                    Install_Date__c=System.today()));
        
        contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c   = 15000,
                                                                    Evergreen_Depreciable_Cost__c       = 950,
                                                                    Remaining_Evergreen_Depreciable_Cost__c = 950,
                                                                    Salvage_Value__c                    = 50,
                                                                    cllease__life_in_months__c          = 14,
                                                                    cllease__Status__c                  = 'LEASED',
                                                                    Install_Address__c                  = address.Id,
                                                                    Install_Account__c                  = dummyAccount.Id,
                                                                    cllease__Equipment_Type__c='CAR',
                                                                    cllease__Equipment_Serial_Number__c='SFKLJADKY',
                                                                    cllease__Equipment_Description__c='',
                                                                    cllease__Equipment_Cost__c=15000,
                                                                    cllease__Model__c='WC8473',                                                              
                                                                    Install_Date__c=System.today()));
      
        // 3.b Adding Payment Schedules to Contract
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 1, cllease__Number_Of_Payments__c = 12,
                           cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                           cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = currentDate,
                           cllease__Total_Payment__c = 1200));

        // 4. Calling ContractBuilder for Contract Creation
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        System.debug(LoggingLevel.ERROR, ' Response from Contract Creation: '+response);
        // Validating Contract Activation
        System.assert(response.containsIgnoreCase('Contract Creation Successful'));
        
        List<cllease__Contract_Equipment__c> equipments = [select id,name from cllease__Contract_Equipment__c];
        system.debug('equipments=' +equipments);
        return builder.getContract();
    }
    
    @isTest
    public static void tryCatchException(){
        // Creating Contract through Util
        Testhelper.getVertexCustomSettings();
        // Creating Contract using TestHelper     
        cllease__Lease_Account__c leaseContract = createContract();
        system.debug('Contract Created: '+leaseContract.Name);
        
        // Create Termination Configuration
        List<cllease__Termination_Config__c> configList = new List<cllease__Termination_Config__c>();
        cllease__Termination_Config__c config = new cllease__Termination_Config__c();
        config.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
        config.cllease__Enable__c           = true;
        configList.add(config);
        
        cllease__Termination_Config__c config1 = new cllease__Termination_Config__c();
        config1.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config1.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config1.cllease__Quote_Type__c       = 'TERMINATION WITHOUT PURCHASE';
        config1.cllease__Enable__c           = true;
        configList.add(config1);
        
        insert configList;
        
        List<cllease__Termination_Config_Line__c> configLines = new List<cllease__Termination_Config_Line__c>();
        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE UNBILLED RECEIVABLES',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE UNBILLED RECEIVABLE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Receivable__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Unbilled_Receivable__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Unbilled_Receivable_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Service_and_Maintenance__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Service_and_Maintainence__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Service_and_Maintenance_TAX__c',
                                                                Do_Passthrough__c               = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Rollover_Incentive__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Rollover_Incentive_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Termination_Config__c  = configList[0].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Field_API_Name__c      = 'Booked_Residual__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Purchase_Amount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Purchase_Amount_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE FEE',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE FEE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Fee__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Fee_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = DLLNewCoConstants.QUOTE_ESTIMATED_SALES_TAX,
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Add_To_Quote_Amount__c = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ESTIMATED PROPERTY TAX  ',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Estimated_Property_Tax__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Estimated_Property_Tax__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Estimated_Property_Tax_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE DISCOUNT',
                                                                cllease__Termination_Config__c  = configList[1].Id,
                                                                cllease__Quote_Line__c          = 'QUOTE DISCOUNT',
                                                                cllease__Field_API_Name__c      = 'Quote_Discount_Roll_over__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Discount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Discount_TAX__c'
                                                                ));
        insert configLines;
        
        List<cllease__Contract_Equipment__c> equipList = [select id,name from cllease__Contract_Equipment__c where cllease__Contract__c=:leaseContract.id];
                                                                
        system.debug('equipList=' +equipList);
        
        System.Test.startTest();
        String resBody =  CLLeaseTerminationQuoteServices.generateTerminationQuotes();
        String resBody1 = CLLeaseTerminationQuoteServices.updateTerminationQuote();
        System.debug('resBody==' +resBody); 
        System.Test.stopTest();
    }

}