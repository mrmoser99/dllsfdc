global class CLLeaseTerminationQuoteServices {
    
    Private static List<String> quoteTypeList=new List<String>();
    Private static String quoteReason;
    Private static Set<String> equipNames =new Set<String>();
    Private static String conName;
    Private static Date terminationDate;
    Private static String quoteStatus;
    Private static Set<String> quoteHeaderIdsSet=new Set<String>(); 
    Private static Map<String,Object> returnResultMap;
    Private static String JOB_NAME = 'CLLeaseTerminationQuoteServices';
    
    
    // Create Termination Quote.
    public static Map<String,Object> createTerminationQuotes(Id ContrtactId){
        Savepoint sp = Database.setSavepoint();
        try{
            List<cllease__Contract_Equipment__c> equipmList = [select id,name,cllease__Contract__c,cllease__Contract__r.name from cllease__Contract_Equipment__c 
                                                                  where cllease__Contract__c=:ContrtactId];
            
            for(cllease__Contract_Equipment__c equip : equipmList){ 
               equipNames.add(equip.name); 
            }
            
            conName = equipmList[0].cllease__Contract__r.name; 
            terminationDate = System.today();
            quoteStatus = 'GENERATED';
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
                gen.writeFieldName('Quote Summary');
                gen.writeStartArray();
                for(cllease__Termination_Quote_Header__c quoteHedr :quoteHeaderList){
                    gen.writeStartObject();
                    gen.writeStringField('QuoteNumber', (quoteHedr.name!=null)?quoteHedr.name:'');
                    gen.writeDateField('QuoteExpirationDate', (quoteHedr.cllease__Effective_From__c!=null)?quoteHedr.cllease__Effective_From__c:null);
                    gen.writeStringField('QuoteType', (quoteHedr.cllease__Quote_Type__c!=null)?quoteHedr.cllease__Quote_Type__c:'');
                    gen.writeNumberField('QuoteAmount', (quoteHedr.cllease__Quote_Amount__c!=null)?quoteHedr.cllease__Quote_Amount__c:0);
                    gen.writeStringField('QuoteStatus', (quoteHedr.cllease__Status__c!=null)?quoteHedr.cllease__Status__c:'');
                    gen.writeStringField('ContractNumber', (quoteHedr.cllease__Contract__r.Name!=null)?quoteHedr.cllease__Contract__r.Name:'');
                    gen.writeNumberField('RemainingLeasePayments', (lsContractList[0].Unbilled_Receivable__c==null)?0:lsContractList[0].Unbilled_Receivable__c);
                    gen.writeNumberField('TradeupDiscountwithPurchase', (lsContractList[0].Zero_Value__c!=null)?lsContractList[0].Zero_Value__c:0);
                    gen.writeNumberField('EquipmentPrice', (lsContractList[0].Bill_Residual_Amount__c!=null)?lsContractList[0].Bill_Residual_Amount__c:0);
                    gen.writeNumberField('SalesTax', (lsContractList[0].Zero_Value__c!=null)?lsContractList[0].Zero_Value__c:0); 
                    gen.writeNumberField('PropertyTaxReimbursement', (lsContractList[0].Unbilled_Estimated_Property_Tax__c==null)?0:lsContractList[0].Unbilled_Estimated_Property_Tax__c);
                    gen.writeNumberField('PastDueServiceAndMeterCoverage', (lsContractList[0].Bill_Not_Paid_Service_Pass_Through__c!=null)?lsContractList[0].Bill_Not_Paid_Service_Pass_Through__c:0); 
                    gen.writeNumberField('OutstandingLeaseCharges', totalLeaseCharge);
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
                String StringQuoteHeader = gen.getAsString();
                
                returnResultMap = (Map<String,Object>)JSON.deserializeUntyped(StringQuoteHeader);
                
                for(String key : returnResultMap.keySet()){
                    system.debug(key + ' : ' + returnResultMap.get(key));
                }
                /*List<Object> quoteSummary =(List<Object>)returnResultMap.get('Quote Summary'); 
                for(Object obj : quoteSummary){
                   //System.debug('quoteSummary  =' + obj);
                }*/
                
            }
            return returnResultMap;
        }catch(Exception ex){
            Database.rollback(sp);
            JSONGenerator gen = JSON.createGenerator(false); 
            gen.writeStartObject(); 
            gen.writeStringField('ResponseMessage', 'Quote Creation Failed, Error Message: '+ex.getMessage()+', LineNumber : '+ex.getLineNumber()); 
            gen.writeEndObject();
            
            returnResultMap = (Map<String,Object>)JSON.deserializeUntyped(gen.getAsString());
            System.debug('returnResultMap = ' + returnResultMap);
            
            Exception_Log__c log = new Exception_Log__c();
            log.Name = JOB_NAME;
            log.Date__c = System.now();
            log.Message__c = String.valueOf(returnResultMap.get('ResponseMessage'));
            log.Line_Number__c = String.valueOf(ex.getLineNumber());
            log.Stack_Trace__c = ex.getStackTraceString();
            log.Type_Name__c = ex.getTypeName();
            
            insert log;
           
            return returnResultMap;
        }   
        
    }
    
    // Update Termination Quote
    public static Map<String,Object> updateTerminationQuote(Id quoteHeaderId, Map<String,Decimal> quoteLine){
        Savepoint sp = Database.setSavepoint();
        try{
            
            List<cllease__Termination_Quote_Line__c> quoteLinesDetails = [select id,name,cllease__Quote_Header__c,cllease__Line_Type__c,cllease__Amount__c from cllease__Termination_Quote_Line__c 
                                                                          where cllease__Quote_Header__c=:quoteHeaderId];
            
            
            Map<String,Object> QuoteTypeAndAmountMapCopy =new Map<String,Object>();
            Map<String,Decimal> inputQuoteLineMap =new Map<String,Decimal>();
            for(cllease__Termination_Quote_Line__c quotLine : quoteLinesDetails){
               String stringQuoteLine = JSON.serialize(quotLine);
               Map<String,Object> QuoteTypeAndAmountMap=(Map<String,Object>)JSON.deserializeUntyped(stringQuoteLine);
               QuoteTypeAndAmountMap.remove('attributes');
               QuoteTypeAndAmountMapCopy.put(String.valueOf(QuoteTypeAndAmountMap.get('cllease__Line_Type__c')),QuoteTypeAndAmountMap.get('cllease__Amount__c'));
            }
            
            //If quote line type is not correct
            for(String quoteType : quoteLine.keySet()){
                if(QuoteTypeAndAmountMapCopy.containsKey(quoteType)){  
                    inputQuoteLineMap.Put(quoteType,quoteLine.get(quoteType)); 
                }else{
                    JSONGenerator gen = JSON.createGenerator(false);
                    gen.writeStartObject();
                    gen.writeStringField('ResponseMessage', 'This Quote Line Type: '+quoteType+' is not correct!!');   
                    gen.writeEndObject(); 
                    String returnResponse = gen.getAsString();
                    returnResultMap = (Map<String,Object>)JSON.deserializeUntyped(returnResponse);
                    System.debug('returnResultMap =' +returnResultMap);
                    
                    Exception_Log__c log = new Exception_Log__c();
                    log.Name = JOB_NAME;
                    log.Date__c = System.now();
                    log.Message__c = String.valueOf(returnResultMap.get('ResponseMessage'));
 
                    insert log;
                    
                    return returnResultMap;
                }
            }
            
            if(!inputQuoteLineMap.isEmpty()){  
               cllease.TerminationQuoteAPI  termQuoteAPI = new cllease.TerminationQuoteAPI(quoteHeaderId,inputQuoteLineMap); 
               termQuoteAPI.recalculateQuote(); 
            }  
            
            List<cllease__Termination_Quote_Header__c> quoteHeaderList=[select id,name,cllease__Contract__r.Name,Equipment_Price__c,cllease__Quote_Reason__c,cllease__Quote_Type__c,cllease__Termination_Date__c,
                                                                   cllease__Status__c,cllease__Effective_From__c,cllease__Quote_Amount__c from cllease__Termination_Quote_Header__c
                                                                   where id=:quoteHeaderId];  
            
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
          
            
            System.debug('equipmentList =' + equipmentList); 
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
            
            String returnResponse;
            if(!quoteHeaderList.isEmpty()){
                JSONGenerator gen = JSON.createGenerator(false);
                gen.writeStartObject();
                gen.writeFieldName('Quote Summary');
                gen.writeStartArray();
                for(cllease__Termination_Quote_Header__c quoteHedr :quoteHeaderList){
                    gen.writeStartObject();
                    gen.writeStringField('QuoteNumber', (quoteHedr.name!=null)?quoteHedr.name:'');
                    gen.writeDateField('QuoteExpirationDate', (quoteHedr.cllease__Effective_From__c!=null)?quoteHedr.cllease__Effective_From__c:null);
                    gen.writeStringField('QuoteType', (quoteHedr.cllease__Quote_Type__c!=null)?quoteHedr.cllease__Quote_Type__c:'');
                    gen.writeNumberField('QuoteAmount', (quoteHedr.cllease__Quote_Amount__c!=null)?quoteHedr.cllease__Quote_Amount__c:0);
                    gen.writeStringField('QuoteStatus', (quoteHedr.cllease__Status__c!=null)?quoteHedr.cllease__Status__c:'');
                    gen.writeStringField('ContractNumber', (quoteHedr.cllease__Contract__r.Name!=null)?quoteHedr.cllease__Contract__r.Name:'');
                    gen.writeNumberField('RemainingLeasePayments', (lsContractList[0].Unbilled_Receivable__c==null)?0:lsContractList[0].Unbilled_Receivable__c); 
                    gen.writeNumberField('TradeupDiscountwithPurchase', (lsContractList[0].Zero_Value__c!=null)?lsContractList[0].Zero_Value__c:0);
                    gen.writeNumberField('EquipmentPrice', (lsContractList[0].Bill_Residual_Amount__c!=null)?lsContractList[0].Bill_Residual_Amount__c:0); 
                    gen.writeNumberField('SalesTax', (lsContractList[0].Zero_Value__c!=null)?lsContractList[0].Zero_Value__c:0);
                    gen.writeNumberField('PropertyTaxReimbursement', (lsContractList[0].Unbilled_Estimated_Property_Tax__c==null)?0:lsContractList[0].Unbilled_Estimated_Property_Tax__c);
                    gen.writeNumberField('PastDueServiceAndMeterCoverage', (lsContractList[0].Bill_Not_Paid_Service_Pass_Through__c!=null)?lsContractList[0].Bill_Not_Paid_Service_Pass_Through__c:0);
                    gen.writeNumberField('OutstandingLeaseCharges', totalLeaseCharge);
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
            returnResultMap = (Map<String,Object>)JSON.deserializeUntyped(returnResponse);
            
            for(String key : returnResultMap.keySet()){
               system.debug(key + ' : ' + returnResultMap.get(key));
            }
            return returnResultMap;
            
        }catch(Exception ex){
            Database.rollback(sp);
            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeStringField('ResponseMessage', 'Quote Id: '+quoteHeaderId+' Termination Quote Failed to Update, Error Message: '+ex.getMessage()+' LineNumber: '+ex.getLineNumber());
            gen.writeEndObject(); 
            String jsonBody=gen.getAsString(); 
            returnResultMap = (Map<String,Object>)JSON.deserializeUntyped(jsonBody);
            system.debug('returnResultMap =' +returnResultMap);
            
            Exception_Log__c log = new Exception_Log__c();
            log.Name = JOB_NAME;
            log.Date__c = System.now();
            log.Message__c = String.valueOf(returnResultMap.get('ResponseMessage'));
            log.Line_Number__c = String.valueOf(ex.getLineNumber());
            log.Stack_Trace__c = ex.getStackTraceString();
            log.Type_Name__c = ex.getTypeName();
            
            insert log;
            
            return returnResultMap;  
        }
        
    }
    
    // Process termination Quote.
    public static Map<String,String> processTerminationQuote(Id quoteHeaderId){
        String returnResponse;
        Map<String,String> returnMap = new Map<String,String>();
        Savepoint sp = Database.setSavepoint();
        try{
             //call product API
            cllease.TerminationQuoteAPI  termQuoteAPI = new cllease.TerminationQuoteAPI(quoteHeaderId); 
            termQuoteAPI.processQuote();
             
            returnMap.put('ResponseMessage ', 'Termination Quote for Quote Id: '+quoteHeaderId+' Successfully Processed.');
            System.debug('returnMap=' +returnMap);
            return returnMap;
            
        }catch(Exception ex){
            Database.rollback(sp);
            
            returnMap.put('ResponseMessage ', 'Quote Id: '+quoteHeaderId+' Termination Quote Failed to Process, Error Message: '+ex.getMessage()+' LineNumber: '+ex.getLineNumber());
            System.debug('returnMap=' +returnMap); 
            
            Exception_Log__c log = new Exception_Log__c();
            log.Name = JOB_NAME;
            log.Date__c = System.now();
            log.Message__c = String.valueOf(returnResultMap.get('ResponseMessage'));
            log.Line_Number__c = String.valueOf(ex.getLineNumber());
            log.Stack_Trace__c = ex.getStackTraceString();
            log.Type_Name__c = ex.getTypeName();
            
            insert log;
            
            return returnMap;
        }
        
        
    }
     
}