@RestResource(urlMapping ='/CreateTerminationQouteCopy/')  
global class CLLeaseTerminationQuoteServicesCopy {  
    
    global static List<String> quoteTypeList=new List<String>();
    global static Set<String> quoteHeaderIdsSet=new Set<String>(); 
    global static String returnResponse;
    global static String returnRes;
    global static String fieldValue;
    global static String fieldName;
    
    global static String conName; 
    global static Set<String> equipNames=new Set<String>(); 
    global static String equipname;
    global static String quoteReason;
    global static Date terminationDate;
    global static String quoteStatus;
    
    global static Map<String,Object> QuoteTypeAndAmountMap;
    global static Map<String,Object> QuoteTypeAndAmountMapCopy =new Map<String,Object>();
    global static Map<String,Decimal> inputQuoteLineMap =new Map<String,Decimal>();
    
    /************** 1. Quote Generation API: *********************/  
     
    @HttpPost
    global static string generateTerminationQuotes(){
        
        try{ 
            RestRequest req=RestContext.request;
            RestResponse res=RestContext.response;
            RestContext.response.addHeader('Content-Type', 'application/json');
        
            //System.debug('requestBody=' +req.requestBody.toString()); 
            String resBody=req.requestBody.toString();
            equipNames=readEquipmentValues(resBody);
            JSONParser parser=JSON.createParser(resBody);
            while(parser.nextToken()!=null){
                if(parser.getCurrentToken()!=JSONToken.END_OBJECT){ 
                    parser.nextValue();
                    fieldName=parser.getCurrentName();
                    fieldValue=parser.getText(); 
                    
                    if(fieldName=='Contract Name'){
                        conName=parser.getText();
                    }else if(fieldName=='Termination Date'){
                        terminationDate=parser.getDateValue();  
                    }else if(fieldName=='Quote Status'){
                        quoteStatus=parser.getText();
                    } 
                }
            }
            quoteReason='ROLL-OVER';
            quoteTypeList.add('TERMINATION WITH PURCHASE');
            quoteTypeList.add('TERMINATION WITHOUT PURCHASE');
            cllease__Termination_Quote_Header__c quoteHeader;
            for(String quoteType : quoteTypeList){  
                cllease.TerminationQuoteAPI  termQuoteAPI = new cllease.TerminationQuoteAPI(conName,equipNames,quoteReason,quoteType,terminationDate,quoteStatus); 
                quoteHeader = termQuoteAPI.createTerminationQuote();  
                quoteHeaderIdsSet.add(quoteHeader.Id);
            }
            
            List<cllease__Termination_Quote_Header__c> quoteHeaderList=[select id,name,cllease__Contract__r.Name,cllease__Quote_Reason__c,cllease__Quote_Type__c,cllease__Termination_Date__c,
                                                                       cllease__Status__c,cllease__Effective_From__c,cllease__Quote_Amount__c from cllease__Termination_Quote_Header__c
                                                                       where id IN : quoteHeaderIdsSet];  
            
            List<cllease__Termination_Quote_Equipment__c> terminateQuotEquipmentList=[select id,name,cllease__Contract_Equipment__c,cllease__Equipment_Detail__c,
                                                                                     cllease__Termination_Quote_Header__c from cllease__Termination_Quote_Equipment__c where 
                                                                                     cllease__Termination_Quote_Header__c IN : quoteHeaderIdsSet];
            
            Set<String> equipIdsSet=new Set<String>();
            for(cllease__Termination_Quote_Equipment__c quoteEquip : terminateQuotEquipmentList){
               equipIdsSet.add(quoteEquip.cllease__Contract_Equipment__c);
            }


            List<cllease__Contract_Equipment__c> equipmentList=[select id,name,cllease__Equipment_Serial_Number__c,cllease__Make__c,cllease__Model__c,Install_Date__c,Install_Address__r.name,
                                                                Install_Address__r.Address_Line_1__c, Install_Address__r.City__c,Install_Address__r.State__c,Install_Address__r.Zip_Code__c
                                                                from cllease__Contract_Equipment__c where id IN : equipIdsSet]; 
            
              
            List<cllease__Lease_Account__c> lsContractList=[select id,name,Unbilled_Receivable__c,Bill_Residual_Amount__c,Bill_Not_Paid_Service_Pass_Through__c,Quote_Discount__c,
                                                            Zero_Value__c,Unbilled_Estimated_Property_Tax__c,cllease__Security_Deposit_Amount__c,Bill_Not_Paid_Late_Fees__c,Bill_Not_Paid_Estimated_Property_Tax__c,
                                                            Bill_Not_Paid_Rent__c,Bill_Not_Paid_Insurance_Fees__c,Bill_not_Paid_Finance_Fees__c,Bill_Not_Paid_Origination_Fees__c,
                                                           Net_Trade_Up_Amount__c from cllease__Lease_Account__c where name=:conName]; 
            
            
            Decimal totalLeaseCharge=0;
            totalLeaseCharge = ((lsContractList[0].Bill_Not_Paid_Late_Fees__c!=null)?lsContractList[0].Bill_Not_Paid_Late_Fees__c:0)+
                               ((lsContractList[0].Bill_Not_Paid_Estimated_Property_Tax__c!=null)?lsContractList[0].Bill_Not_Paid_Estimated_Property_Tax__c:0)+
                               ((lsContractList[0].Bill_Not_Paid_Rent__c!=null)?lsContractList[0].Bill_Not_Paid_Rent__c:0)+
                               ((lsContractList[0].Bill_Not_Paid_Insurance_Fees__c!=null)?lsContractList[0].Bill_Not_Paid_Insurance_Fees__c:0)+
                               ((lsContractList[0].Bill_not_Paid_Finance_Fees__c!=null)?lsContractList[0].Bill_not_Paid_Finance_Fees__c:0)+
                               ((lsContractList[0].Bill_Not_Paid_Origination_Fees__c!=null)?lsContractList[0].Bill_Not_Paid_Origination_Fees__c:0);  
            
            if(!quoteHeaderList.isEmpty()){
                JSONGenerator gen = JSON.createGenerator(false);
                gen.writeStartObject();
                gen.writeStringField('ResponseMessage', 'Successfully Created Quotes');
                gen.writeFieldName('Quote Summary');
                gen.writeStartArray();
                for(cllease__Termination_Quote_Header__c qouteHedr :quoteHeaderList){
                    gen.writeStartObject();
                    gen.writeStringField('QuoteNumber', (qouteHedr.name!=null)?qouteHedr.name:'');
                    gen.writeDateField('QuoteExpirationDate', (qouteHedr.cllease__Effective_From__c!=null)?qouteHedr.cllease__Effective_From__c:null);
                    gen.writeStringField('QuoteType', (qouteHedr.cllease__Quote_Type__c!=null)?qouteHedr.cllease__Quote_Type__c:'');
                    gen.writeNumberField('QuoteAmount', (qouteHedr.cllease__Quote_Amount__c!=null)?qouteHedr.cllease__Quote_Amount__c:0);
                    gen.writeStringField('QuoteStatus', (qouteHedr.cllease__Status__c!=null)?qouteHedr.cllease__Status__c:'');
                    gen.writeStringField('ContractNumber', (qouteHedr.cllease__Contract__r.Name!=null)?qouteHedr.cllease__Contract__r.Name:'');
                    gen.writeNumberField('RemainingLeasePayments', (lsContractList[0].Unbilled_Receivable__c==null)?0:lsContractList[0].Unbilled_Receivable__c);
                    gen.writeNumberField('TradeupDiscountwithPurchase', (lsContractList[0].Zero_Value__c!=null)?lsContractList[0].Zero_Value__c:0);
                    gen.writeNumberField('EquipmentPrice', (lsContractList[0].Bill_Residual_Amount__c!=null)?lsContractList[0].Bill_Residual_Amount__c:0);
                    gen.writeNumberField('SalesTax', (lsContractList[0].Zero_Value__c!=null)?lsContractList[0].Zero_Value__c:0); 
                    gen.writeNumberField('PropertyTaxReimbursement', (lsContractList[0].Unbilled_Estimated_Property_Tax__c==null)?0:lsContractList[0].Unbilled_Estimated_Property_Tax__c);
                    gen.writeNumberField('PastDueServiceAndMeterCoverage', (lsContractList[0].Bill_Not_Paid_Service_Pass_Through__c!=null)?lsContractList[0].Bill_Not_Paid_Service_Pass_Through__c:0); 
                    gen.writeNumberField('OutstandingLeaseCharges', totalLeaseCharge);
                    //gen.writeNumberField('SecurityDeposit', (lsContractList[0].cllease__Security_Deposit_Amount__c==null)?0:lsContractList[0].cllease__Security_Deposit_Amount__c);
                    gen.writeNumberField('NetTradeupAmount', (lsContractList[0].Net_Trade_Up_Amount__c==null)?0:lsContractList[0].Net_Trade_Up_Amount__c);
                    gen.writeEndObject();
                    
                }
                gen.writeEndArray();
                
                //start Equipment Summary 
                gen.writeFieldName('Equipment Summary');
                gen.writeStartArray();
                for(cllease__Contract_Equipment__c equip : equipmentList){
                    gen.writeStartObject();
                    gen.writeStringField('EquipmentNumber', (equip.name!=null)?equip.name:'');
                    gen.writeStringField('SerialNumber', (equip.cllease__Equipment_Serial_Number__c!=null)?equip.cllease__Equipment_Serial_Number__c:'');
                    gen.writeStringField('Make', (equip.cllease__Make__c!=null)?equip.cllease__Make__c:'');
                    gen.writeStringField('Model', (equip.cllease__Model__c!=null)?equip.cllease__Model__c:'');
                    gen.writeDateField('InstallDate', (equip.Install_Date__c!=null)?equip.Install_Date__c:null);
                    gen.writeStringField('InstallAddress', (((equip.Install_Address__r.Address_Line_1__c!=null)?equip.Install_Address__r.Address_Line_1__c.remove(','):'') 
                                                            +','+((equip.Install_Address__r.City__c!=null)?equip.Install_Address__r.City__c:'')
                                                            +','+((equip.Install_Address__r.Zip_Code__c!=null)?equip.Install_Address__r.Zip_Code__c:''))); 
                    gen.writeEndObject();
                }
                gen.writeEndArray();
                gen.writeEndObject();
          
                returnResponse = gen.getAsString();  
                
            }
            return returnResponse;
            
        }catch(Exception ex){
            System.debug('Exception : '+ ex.getMessage());
            JSONGenerator gen = JSON.createGenerator(false); 
            gen.writeStartObject(); 
            gen.writeStringField('ResponseMessage', 'Quote Creation Failed, Error Message <<'+ex.getMessage()+', LineNumber : '+ex.getLineNumber()+ ' >>'); 
            gen.writeFieldName('terminationQuotes');
            gen.writeStartArray();
            gen.writeEndArray();
            gen.writeEndObject();
            System.debug('Error Response : ' + gen.getAsString());  
              
            return gen.getAsString(); 
        }
        
    }
    
    global static Set<String> readEquipmentValues(String equip){
        Map<String,Object> equipMap;
        Set<String> equipmentSet=new Set<String>();
        List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
        Map<String, Object> equipNameMap = (Map<String, Object>) JSON.deserializeUntyped(equip);
        List<Object> myMapObjects = (List<Object>) equipNameMap.get('Equipments');
        for (Object obj : myMapObjects) {
            myMaps.add((Map<String, Object>)obj);  
        }
        for(integer i=0;i<myMaps.size();i++){
            equipMap=(Map<String,Object>)myMaps.get(i);  
            equipmentSet.add(String.valueOf(equipMap.get('equipName'))); 
        }
        return equipmentSet; 
    }
    
    /************** 2. Quote Update API *********************/
    @HttpPatch
    global static String updateTerminationQuote(){
        Map<String,Decimal> quoteLines =new Map<String,Decimal>();
        String quoteId; 
        
      try{ 
        RestRequest request = RestContext.request; 
        RestResponse res=RestContext.response;
        
        String resBody=request.requestBody.toString(); 
        quoteLines=arrayOfQuoteLines(resBody);
        
        if(!quoteLines.isEmpty()){
            System.debug('**************Quote Update Successfully *******************');
            
            JSONParser parser=JSON.createParser(resBody);  
            while(parser.nextToken()!=null){
                if(parser.getCurrentToken()!=JSONToken.END_OBJECT){ 
                    parser.nextValue();
                    fieldName=parser.getCurrentName();
                    fieldValue=parser.getText(); 
                    if(fieldName=='QuoteNumber'){
                        quoteId=parser.getText();
                        
                    }
                }
            }
            List<cllease__Termination_Quote_Line__c> quoteLinesDetails = [select id,name,cllease__Quote_Header__c,cllease__Line_Type__c,cllease__Amount__c from cllease__Termination_Quote_Line__c where cllease__Quote_Header__r.id=:quoteId];
     
            for(cllease__Termination_Quote_Line__c quotLine : quoteLinesDetails){
               String stringQuoteLine = JSON.serialize(quotLine);
               QuoteTypeAndAmountMap=(Map<String,Object>)JSON.deserializeUntyped(stringQuoteLine);
               QuoteTypeAndAmountMap.remove('attributes');
               QuoteTypeAndAmountMapCopy.put(String.valueOf(QuoteTypeAndAmountMap.get('cllease__Line_Type__c')),QuoteTypeAndAmountMap.get('cllease__Amount__c'));
            }
            for(String quoteType : quoteLines.keySet()){
                if(QuoteTypeAndAmountMapCopy.containsKey(quoteType)){  
                    inputQuoteLineMap.Put(quoteType,quoteLines.get(quoteType)); 
                }else{
                    JSONGenerator gen = JSON.createGenerator(false);
                    gen.writeStartObject();
                    gen.writeStringField('ResponseMessage', 'This Quote Line Type: '+quoteType+' is not correct!!');   
                    gen.writeEndObject(); 
                    String returnResponse = gen.getAsString();
                    return returnResponse;
                }
           }
        
            if(!inputQuoteLineMap.isEmpty()){  
               cllease.TerminationQuoteAPI  termQuoteAPI = new cllease.TerminationQuoteAPI(quoteId,inputQuoteLineMap); 
               termQuoteAPI.recalculateQuote(); 
            
            }  

            List<cllease__Termination_Quote_Header__c> quoteHeaderList=[select id,name,cllease__Contract__r.Name,Equipment_Price__c,cllease__Quote_Reason__c,cllease__Quote_Type__c,cllease__Termination_Date__c,
                                                                   cllease__Status__c,cllease__Effective_From__c,cllease__Quote_Amount__c from cllease__Termination_Quote_Header__c
                                                                   where id=:quoteId];  
        
            
            List<cllease__Termination_Quote_Line__c> quoteLinesList=[select id,name,cllease__Quote_Header__c,cllease__Line_Type__c,cllease__Amount__c from cllease__Termination_Quote_Line__c
                                                                      where cllease__Quote_Header__r.id=:quoteHeaderList[0].id];
            
              
            List<cllease__Termination_Quote_Equipment__c> terminateQuoteEquipList=[select id,name,cllease__Contract_Equipment__c,cllease__Equipment_Detail__c,cllease__Termination_Quote_Header__c from
                                                                                    cllease__Termination_Quote_Equipment__c where cllease__Termination_Quote_Header__c=:quoteHeaderList[0].id];
            
            Set<String> equipIdsSet=new Set<String>();
            for(cllease__Termination_Quote_Equipment__c quoteEquip : terminateQuoteEquipList){
                equipIdsSet.add(quoteEquip.cllease__Contract_Equipment__c);
            }
            
            List<cllease__Contract_Equipment__c> equipmentList=[select id,name,cllease__Equipment_Serial_Number__c,cllease__Make__c,cllease__Model__c,Install_Date__c,Install_Address__r.name,
                                                                Install_Address__r.Address_Line_1__c, Install_Address__r.City__c,Install_Address__r.State__c,Install_Address__r.Zip_Code__c
                                                                from cllease__Contract_Equipment__c where id IN :equipIdsSet]; 
          
            
             
            List<cllease__Lease_Account__c> lsContractList=[select id,name,Unbilled_Receivable__c,Bill_Residual_Amount__c,Bill_Not_Paid_Service_Pass_Through__c,Quote_Discount__c,
                                                            Zero_Value__c,Unbilled_Estimated_Property_Tax__c,cllease__Security_Deposit_Amount__c,Bill_Not_Paid_Late_Fees__c,
                                                            Bill_Not_Paid_Estimated_Property_Tax__c,
                                                            Bill_Not_Paid_Rent__c,Bill_Not_Paid_Insurance_Fees__c,Bill_not_Paid_Finance_Fees__c,Bill_Not_Paid_Origination_Fees__c,
                                                            Net_Trade_Up_Amount__c from cllease__Lease_Account__c where name=:quoteHeaderList[0].cllease__Contract__r.Name];
            
            

            Decimal totalLeaseCharge=0;
            totalLeaseCharge = ((lsContractList[0].Bill_Not_Paid_Late_Fees__c!=null)?lsContractList[0].Bill_Not_Paid_Late_Fees__c:0)+
                               ((lsContractList[0].Bill_Not_Paid_Estimated_Property_Tax__c!=null)?lsContractList[0].Bill_Not_Paid_Estimated_Property_Tax__c:0)+
                               ((lsContractList[0].Bill_Not_Paid_Rent__c!=null)?lsContractList[0].Bill_Not_Paid_Rent__c:0)+
                               ((lsContractList[0].Bill_Not_Paid_Insurance_Fees__c!=null)?lsContractList[0].Bill_Not_Paid_Insurance_Fees__c:0)+
                               ((lsContractList[0].Bill_not_Paid_Finance_Fees__c!=null)?lsContractList[0].Bill_not_Paid_Finance_Fees__c:0)+
                               ((lsContractList[0].Bill_Not_Paid_Origination_Fees__c!=null)?lsContractList[0].Bill_Not_Paid_Origination_Fees__c:0);  
          
            if(!quoteHeaderList.isEmpty()){
                JSONGenerator gen = JSON.createGenerator(false);
                gen.writeStartObject();
                gen.writeStringField('ResponseMessage', 'Successfully Updaetd Quote');
                gen.writeFieldName('Quote Summary');
                gen.writeStartArray();
                for(cllease__Termination_Quote_Header__c qouteHedr :quoteHeaderList){
                    gen.writeStartObject();
                    gen.writeStringField('QuoteNumber', (qouteHedr.name!=null)?qouteHedr.name:'');
                    gen.writeDateField('QuoteExpirationDate', (qouteHedr.cllease__Effective_From__c!=null)?qouteHedr.cllease__Effective_From__c:null);
                    gen.writeStringField('QuoteType', (qouteHedr.cllease__Quote_Type__c!=null)?qouteHedr.cllease__Quote_Type__c:'');
                    gen.writeNumberField('QuoteAmount', (qouteHedr.cllease__Quote_Amount__c!=null)?qouteHedr.cllease__Quote_Amount__c:0);
                    gen.writeStringField('QuoteStatus', (qouteHedr.cllease__Status__c!=null)?qouteHedr.cllease__Status__c:'');
                    gen.writeStringField('ContractNumber', (qouteHedr.cllease__Contract__r.Name!=null)?qouteHedr.cllease__Contract__r.Name:'');
                    gen.writeNumberField('RemainingLeasePayments', (lsContractList[0].Unbilled_Receivable__c==null)?0:lsContractList[0].Unbilled_Receivable__c); 
                    gen.writeNumberField('TradeupDiscountwithPurchase', (lsContractList[0].Zero_Value__c!=null)?lsContractList[0].Zero_Value__c:0);
                    gen.writeNumberField('EquipmentPrice', (lsContractList[0].Bill_Residual_Amount__c!=null)?lsContractList[0].Bill_Residual_Amount__c:0); 
                    gen.writeNumberField('SalesTax', (lsContractList[0].Zero_Value__c!=null)?lsContractList[0].Zero_Value__c:0);
                    gen.writeNumberField('PropertyTaxReimbursement', (lsContractList[0].Unbilled_Estimated_Property_Tax__c==null)?0:lsContractList[0].Unbilled_Estimated_Property_Tax__c);
                    gen.writeNumberField('PastDueServiceAndMeterCoverage', (lsContractList[0].Bill_Not_Paid_Service_Pass_Through__c!=null)?lsContractList[0].Bill_Not_Paid_Service_Pass_Through__c:0);
                    gen.writeNumberField('OutstandingLeaseCharges', totalLeaseCharge);
                    //gen.writeNumberField('SecurityDeposit', (lsContractList[0].cllease__Security_Deposit_Amount__c==null)?0:lsContractList[0].cllease__Security_Deposit_Amount__c);
                    gen.writeNumberField('NetTradeupAmount', (lsContractList[0].Net_Trade_Up_Amount__c==null)?0:lsContractList[0].Net_Trade_Up_Amount__c);
                    gen.writeEndObject();
                    
                }
                gen.writeEndArray();
                
                //start Equipment Summary 
                gen.writeFieldName('Equipment Summary');
                gen.writeStartArray();
                for(cllease__Contract_Equipment__c equip : equipmentList){
                    gen.writeStartObject();
                    gen.writeStringField('EquipmentNumber', (equip.name!=null)?equip.name:'');
                    gen.writeStringField('SerialNumber', (equip.cllease__Equipment_Serial_Number__c!=null)?equip.cllease__Equipment_Serial_Number__c:'');
                    gen.writeStringField('Make', (equip.cllease__Make__c!=null)?equip.cllease__Make__c:'');
                    gen.writeStringField('Model', (equip.cllease__Model__c!=null)?equip.cllease__Model__c:'');
                    gen.writeDateField('InstallDate', (equip.Install_Date__c!=null)?equip.Install_Date__c:null);
                    gen.writeStringField('InstallAddress', (((equip.Install_Address__r.Address_Line_1__c!=null)?equip.Install_Address__r.Address_Line_1__c.remove(','):'') 
                                                            +','+((equip.Install_Address__r.City__c!=null)?equip.Install_Address__r.City__c:'')
                                                            +','+((equip.Install_Address__r.Zip_Code__c!=null)?equip.Install_Address__r.Zip_Code__c:'')));
                    gen.writeEndObject();
                }
                gen.writeEndArray();
                gen.writeEndObject();
                returnResponse = gen.getAsString();
                
            }
         
        }else{ // Accepted Termination quote
            System.debug('**************Quote Process Successfully *******************');
            
            JSONParser parser=JSON.createParser(resBody);  
            while(parser.nextToken()!=null){
                if(parser.getCurrentToken()!=JSONToken.END_OBJECT){ 
                    parser.nextValue();
                    fieldName=parser.getCurrentName();
                    fieldValue=parser.getText(); 
                    if(fieldName=='QuoteNumber'){
                        quoteId=parser.getText(); 
                    }
                }
            }
            
            //call product API
            cllease.TerminationQuoteAPI  termQuoteAPI = new cllease.TerminationQuoteAPI(quoteId); 
            termQuoteAPI.processQuote();
            
            List<cllease__Termination_Quote_Header__c> quoteHeaderList=[select id,name,cllease__Contract__r.Name,cllease__Quote_Reason__c,cllease__Quote_Type__c,cllease__Termination_Date__c,
                                                                   cllease__Status__c,cllease__Effective_From__c,cllease__Quote_Amount__c from cllease__Termination_Quote_Header__c
                                                                   where id=:quoteId];
            System.debug('quoteHeaderList size=' +quoteHeaderList.size());
            
            if(quoteHeaderList.size()>0){
                JSONGenerator gen = JSON.createGenerator(false);
                gen.writeStartObject();
                gen.writeStringField('ResponseMessage', 'Termination Quote Successfully Processed');
                gen.writeFieldName('Quote Summary');
                gen.writeStartArray();
                for(cllease__Termination_Quote_Header__c qouteHedr :quoteHeaderList){
                    gen.writeStartObject();
                    gen.writeStringField('QuoteNumber', (qouteHedr.name!=null)?qouteHedr.name:'');
                    gen.writeStringField('Quote Status', (qouteHedr.cllease__Status__c!=null)?qouteHedr.cllease__Status__c:'');
                    gen.writeEndObject();
                }
                gen.writeEndArray();
                gen.writeEndObject();
                returnResponse = gen.getAsString();  
            }
             
        }
            return returnResponse;
            
        }catch(Exception ex){
            
            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeStringField('ResponseMessage', 'Quote Id '+quoteId+' Termination Quote Failed to process, Error Message <<'+ex.getMessage()+' LineNumber '+ex.getLineNumber()+' >>');
            gen.writeEndObject(); 
            String jsonBody=gen.getAsString(); 
            //jsonBody.unescapeJava();
            return jsonBody;     
        }
        
    }
    
    global static Map<String,Decimal> arrayOfQuoteLines(String quoteLine) { 
        Map<String,Decimal> quotIdAndQuotAmountMap = new Map<String,Decimal>();
        Map<String,Object> qtLineMap;
        List<Map<String, Object>> myMaps = new List<Map<String, Object>>(); 
        Map<String, Object> equipNameMap = (Map<String, Object>) JSON.deserializeUntyped(quoteLine);
        if(equipNameMap.get('QuoteLines')!=null){
            List<Object> myMapObjects = (List<Object>) equipNameMap.get('QuoteLines');            
            for (Object obj : myMapObjects) {
                myMaps.add((Map<String, Object>)obj); 
            } 
            for(integer i=0;i<myMaps.size();i++){
                qtLineMap=(Map<String,Object>)myMaps.get(i);
            }
            for(String key : qtLineMap.keySet()){ 
                quotIdAndQuotAmountMap.put(key,double.valueOf(qtLineMap.get(key)));
            }  
        }
            
            return quotIdAndQuotAmountMap; 
    }  
}