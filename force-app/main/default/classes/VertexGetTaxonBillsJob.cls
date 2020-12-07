/**
 * Author: Cloud Lending Solutions
 * Description: Following  job helps in calculating  the Tax for Bills
 * 
 * Change Log:
 * 
 * 12/2/2020 - MRM made document date on getXMLBills to utilize transaction date on due details
 **/
global class VertexGetTaxonBillsJob extends clcommon.DynamicJob implements Database.AllowsCallouts {  
 
    private static String query;
    private static final String JOB_NAME = 'Vertex Tax on Bills Job';

    global VertexGetTaxonBillsJob() {
        super(JOB_NAME, initialize(null));
        doInitialize();
    }
    
    global VertexGetTaxonBillsJob(List<String> contractNames) {
        super(JOB_NAME, initialize(contractNames));
        doInitialize();
    }
    
    global virtual override String getRuntimeQuery() {
        System.debug(LoggingLevel.ERROR, 'VertexGetTaxonBillsJob query in getRuntimeQuery : ' + query);
        return query; 
    }

    public static String initialize(List<String> contractNames) {

        query = ' SELECT Id, Name, cllease__Lease_Status__c '+
                ' FROM cllease__Lease_Account__c '+
                ' WHERE cllease__Lease_Status__c in (\'ACTIVE - GOOD STANDING\',\'ACTIVE - BAD STANDING\',\'TERMINATED\')';

        if(contractNames!=null && contractNames.size() > 0) {
            String contractNamesStr = '';
            for (String contractName : contractNames) {
              contractNamesStr = contractNamesStr + '\'' + String.escapeSingleQuotes(contractName) + '\'' + ',';
            }
            contractNamesStr = contractNamesStr.substring(0, contractNamesStr.length() - 1);
            query += ' AND Name in ('+ contractNamesStr + ')';
        }
        
        System.debug(LoggingLevel.ERROR, 'VertexGetTaxonBillsJob Query: '+query);       
        return query;
    }

    private static List<sObject> getRecords(List<String> contractNames, Boolean isTerminationTaxCall) {
        // Creating Query using ObjectCache
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache dueDetailOC = ec.getObject('DueDetailLines');
        if(dueDetailOC != null) {
           ec.deleteObject('DueDetailLines');
        }        
        dueDetailOC = ec.createObject('DueDetailLines', 'cllease__Due_Detail_Lines__c');

        //Query all SetupAuditTrail records.
        String fields = CLSCustomUtil.fetchAllCustomFields('cllease__Due_Detail_Lines__c') +', '+
                        + 'cllease__Contract__r.cllease__Lease_Product_Name__c, '
                        + 'cllease__Contract_Equipment__r.Name, '
                        + 'cllease__Contract_Equipment__r.GARD__c, '
                        + 'cllease__Contract_Equipment__r.Install_Address__c, '
                        + 'cllease__Contract_Equipment__r.cllease__Tax_exemption__c, '
                        + 'cllease__Bill__r.Name, '
                        + 'cllease__Bill__r.cllease__Due_Type_Description__c, '
                        + 'cllease__Bill__r.cllease__Total_Due_Amount__c, '
                        + 'cllease__Bill__r.cllease__Balance_Amount__c, '
                        + 'cllease__Bill__r.cllease__Tax_Due_Amount__c, '
                        + 'cllease__Bill__r.cllease__Lease_Account__r.Name, '
                        + 'cllease__Bill__r.cllease__Tax_Processed__c, '
                        + 'cllease__Bill__r.cllease__Lease_Account__r.cllease__Contract_Date__c, '
                        + 'cllease__Bill__r.cllease__Lease_Account__r.cllease__Term__c, '
                        + 'cllease__Bill__r.cllease__Lease_Account__r.cllease__First_Payment_Date__c, '
                        + 'cllease__Bill__r.cllease__Lease_Account__r.cllease__Maturity_Date__c, '
                        + 'cllease__Bill__r.cllease__Lease_Account__r.cllease__Account__r.Tax_Exempt__c, '
                        + 'cllease__Transaction_Date__c ';
                        
        
        dueDetailOC.addFields(fields); 

        dueDetailOC.addNamedParameter('vertexTaxStatus', 'NO'); //we looking for this
        String whereClause = '(cllease__Bill__r.cllease__Status__c != \'Tax Calculated\') ';
        whereClause += ' AND Vertex_Tax_Processed__c = :vertexTaxStatus';

        if(contractNames != null && contractNames.size() > 0) {
            dueDetailOC.addNamedParameter('contractNames', contractNames);
            whereClause += ' AND cllease__Bill__r.cllease__Lease_Account__r.Name IN :contractNames ';
            // make sure retrieve termination related due detail lines for Termination Taxation.
            if(isTerminationTaxCall) {
                whereClause += ' AND cllease__Bill__r.cllease__Due_Type_Description__c = \'TERMINATION\'';
            }
        }

        dueDetailOC.setWhereClause(whereClause);
        dueDetailOC.setOrderClause('cllease__Bill__r.cllease__Lease_Account__r.Name asc');
        dueDetailOC.buildQuery();
        dueDetailOC.executeQuery();
        
        System.debug(LoggingLevel.ERROR, 'VertexGetTaxonBillsJob Query: '+dueDetailOC.getQuery());    
        return dueDetailOC.getRecords();
    }
    
    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {

        List<cllease__Lease_Account__c> contracts = (List<cllease__Lease_Account__c>)scope;
        List<String> contractNames = new List<String>();
        Set<String> contractIds = new Set<String>();
        Boolean isTerminationTaxCall = false;
        for(cllease__Lease_Account__c contract : contracts) {
            contractNames.add(contract.Name);
            if(contract.cllease__Lease_Status__c == 'TERMINATED') {
                isTerminationTaxCall = true;
                contractIds.add(contract.Id);
            }
        }

        System.debug(LoggingLevel.ERROR, ' Processing contract: '+contractNames); 
        List<cllease__Due_Detail_Lines__c> dueDetailLines = (List<cllease__Due_Detail_Lines__c>) getRecords(contractNames, isTerminationTaxCall);
        System.debug(LoggingLevel.ERROR, ' dueDetailLines: '+dueDetailLines);
        // Skip the process in case of due detail lines size = 0
        if(dueDetailLines == null || dueDetailLines.size() == 0) {
            return;
        }

        List<cllease__Due_Detail_Lines__c> validDueDetailsToUpdate = new List<cllease__Due_Detail_Lines__c>();
        List<cllease__Due_Detail_Lines__c> invalidDueDetailsToUpdate = new List<cllease__Due_Detail_Lines__c>();
        HttpResponse res;
        Integer responseCode = 0;

        VertexApi__c vertexConfig = CLSCustomUtil.getVertexConfiguration();
        // Logging Vertex Request and Response XML Files
        Vertex_Log__c vertexLog = new Vertex_Log__c();

        // 1. Creating http request for the Due Detail Lines & Do Callout
        try {
            // A. Following  method separates the valid and invalid list based on address validation
            validateAddress(dueDetailLines, validDueDetailsToUpdate, invalidDueDetailsToUpdate);

            // B. Proceed with Vertex Call only for Valid DueDetailLines
            if(validDueDetailsToUpdate.size() > 0) {
                Dom.document methoddoc;
                if(isTerminationTaxCall) {
                    methoddoc = VertexUtil2.getTerminationBillXml(validDueDetailsToUpdate);
                } else {
                    methoddoc = VertexUtil.getBillsXml(validDueDetailsToUpdate);
                }
                 
                VertexUtil.validateVertexConfig(vertexConfig);
                
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
                if(!System.Test.isRunningTest()) {
                    res = http.send(req);
                } else {
                    res = VertexHttpResponseGenerator.vertexBillHTTPResponse(dueDetailLines);
                }
                System.debug(LoggingLevel.ERROR, ' Response Code: '+res.getStatusCode());
                responseCode = res.getStatusCode();

                // Recording Vertex Request XML & Response XML
                if(!System.Test.isRunningTest() && vertexConfig.Enable_Vertex_Xml_Logging__c) {
                    vertexLog.Request_XML__c  = methoddoc.toXMlString();
                    vertexLog.Response_XML__c = res.getBody();
                }

            } else {
                // incase of no valid Due Detail Lines, throw exception to check valid address linked.
                throw new CLSCustomException('Address (City/State/Zipcode) is not valid. Skipping Vertex Tax Computation...');
            
            }

        } catch(Exception e) {
            // A. Insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name='VertexGetTaxonBillsJob: ',
            cllease__Date__c=system.today(), cllease__Message__c='Error is '+e.getmessage()
            +' in line number: '+ e.getlinenumber());

            // B. Record Exception in  All DueDetails lines for failure
            for(cllease__Due_Detail_Lines__c dueDetailLine : dueDetailLines) {
                dueDetailLine.cllease__Remarks__c = 'Vertex Tax Batch failed. Please Check Batch log for more details';
            }
            update dueDetailLines;

            // C. Skip the process in case of any exception during initial Callout Exception
            return; 

        } finally {
            // Logging the Vertex Request
            if(!System.Test.isRunningTest() && vertexConfig.Enable_Vertex_Xml_Logging__c
                && vertexLog.Request_XML__c != null && vertexLog.Response_XML__c != null) {
                vertexLog.Contract_Names__c = CLSCustomUtil.getStringsFromList(contractNames);
                vertexLog.Category__c = 'BILL-VERTEX TAX CALL';
                insert vertexLog;
            }
        }
        
        // 2. Processing Vertex Response SOAP only incase No HTTP Failures from 1.
        Savepoint sp = Database.setsavepoint();
        try {
            cllease__Termination_Config__c quoteConfig;
            Boolean isRollOverTermination = false;
            // Processing Vertex Response SOAP
            if(responseCode == 200) {
                // Process Successful Response
                Dom.Document responseDom = new Dom.Document();
                responseDom.load(res.getbody());
                DOM.XMLNode root = responseDom.getRootElement();

                Map<String, String> calculatedTax   = new Map<String,String>();
                Map<String, Decimal> valuesMap      = new Map<String, Decimal>();
                Map<Id, Decimal> billsTaxDueMap     = new Map<Id, Decimal>();
                Map<Id, Decimal> billsTotalDueMap   = new Map<Id, Decimal>();
                String jur, attr, taxComp = '', totalTaxComp = '', dueDetailName = '', calTax, taxRate;
                Map<String, Decimal> taxRatesMap;
                Map<String, Decimal> taxValuesMap;
                Map<String, Map<String, Decimal>> ddlTaxRatesMap = new Map<String, Map<String, Decimal>>();
                Map<String, Map<String, Decimal>> ddlTaxValuesMap = new Map<String, Map<String, Decimal>>();
                Map<String, Map<String, Decimal>> ddlToQuoteLineTaxAmountsMap = new Map<String, Map<String, Decimal>>();
                //System.debug(LoggingLevel.ERROR, ' root: '+root.getName());
                
                // A. Extracting Required info from Response Dom 
                for(Dom.XMLNode soapBodyChild : root.getChildren()) {
                    //System.debug(LoggingLevel.ERROR, ' processing node: '+soapBodyChild.getName());
                    if(soapBodyChild.getName() == 'Body') {
                        for(Dom.XMLNode vertexEnvelope : soapBodyChild.getChildren()) {
                            if(vertexEnvelope.getName() == 'VertexEnvelope') {
                                //System.debug(LoggingLevel.ERROR, ' inside processing vertexEnvelope');
                                // Process the Vertex Envelope
                                for(DOM.XMLNode child1 : vertexEnvelope.getChildren()) {
                                    if(child1.getName() == 'InvoiceResponse') {
                                        //System.debug(LoggingLevel.ERROR, ' inside processing InvoiceResponse');
                                        taxRatesMap  = new Map<String, Decimal>();
                                        taxValuesMap = new Map<String, Decimal>();

                                        for(DOM.XMLNode child2 :child1.getChildren()) {
                                            String quoteLineType = '';
                                            Decimal quoteLineTotalTaxAmount = 0.00;
                                            if(child2.getName() == 'LineItem') {
                                                //System.debug(LoggingLevel.ERROR, ' inside processing LineItem');
                                                // Extracting Charge
                                                dueDetailName = child2.getAttributeValue('lineItemId', null); 
                                                taxComp = '';

                                                for(DOM.XMLNode child3 :child2.getChildren()) {
                                                    // Extracting Taxes Jurisdiction & TotalTax Details
                                                    if(child3.getName() == 'Taxes') {
                                                        for(DOM.XMLNode child4 :child3.getChildren()) {
                                                            // Extracting Calculating Tax Rate
                                                            if(child4.getName() == 'CalculatedTax') {
                                                                calTax = child4.getText();
                                                            }
                                                            // Extracting Calculating Tax Rate
                                                            if(child4.getName() == 'EffectiveRate') {
                                                                taxRate = child4.getText();
                                                                //System.debug(LoggingLevel.ERROR, ' TaxRate taxRate: '+taxRate);
                                                            }
                                                            // Extracting Jurisdiction        
                                                            if(child4.getName() == 'Jurisdiction') {
                                                                jur = child4.getText();
                                                                attr = child4.getAttributeValue('jurisdictionLevel', null);
                                                            }
                                                            // Tax Related Components Updates for Jursdictions
                                                            if(attr != null && jur != null && calTax != null && taxRate != null) {
                                                                taxComp = taxComp + ('(' + attr + ' ' + jur + ' ' + calTax + ' '+taxRate+' )' + '\n');
                                                                totalTaxComp = taxComp;
                                                                // Retrieving existing value from same Jurisdiction Level if any totalling Tax Rates and Values
                                                                Decimal totalTaxRate =  taxRatesMap.containsKey(attr) ? taxRatesMap.get(attr) : 0.0;
                                                                totalTaxRate += Decimal.valueOf(taxRate);

                                                                Decimal totalTaxValue =  taxValuesMap.containsKey(attr) ? taxValuesMap.get(attr) : 0.0;
                                                                totalTaxValue += Decimal.valueOf(calTax);

                                                                // adding logic to add up old values
                                                                Decimal tempTaxRate     = taxRatesMap.get(attr);
                                                                if(tempTaxRate == null) {
                                                                    tempTaxRate = 0.00;
                                                                }
                                                                tempTaxRate += totalTaxRate;

                                                                Decimal tempTaxValue     = taxValuesMap.get(attr);
                                                                if(tempTaxValue == null) {
                                                                    tempTaxValue = 0.00;
                                                                }
                                                                tempTaxValue += totalTaxValue;

                                                                taxRatesMap.put(attr, tempTaxRate);
                                                                taxValuesMap.put(attr, tempTaxValue);
                                                                calTax = null;
                                                                taxRate = null;
                                                                break;
                                                            }
                                                        }
                                                        
                                                    } else if(child3.getName() == 'TotalTax') {
                                                        Decimal currentTotalTaxValue = decimal.valueOf(child3.getText().trim());
                                                        Decimal totalTaxValue = valuesMap.get(dueDetailName);
                                                        if(totalTaxValue == null) {
                                                            totalTaxValue = 0.00;
                                                        }
                                                        totalTaxValue += currentTotalTaxValue;
                                                        valuesMap.put(dueDetailName, totalTaxValue);
                                                        quoteLineTotalTaxAmount = currentTotalTaxValue;

                                                    } else if(child3.getName() == 'FlexibleFields') { // Extracting Quote Line Details
                                                        for(DOM.XMLNode child4 :child3.getChildren()) {
                                                            if(child4.getName() == 'FlexibleCodeField') {
                                                                String attr1 = child4.getAttributeValue('fieldId', null);
                                                                if(attr1 == '15') {
                                                                    quoteLineType = child4.getText();
                                                                }
                                                            }
                                                        }

                                                    }
                                                }

                                                // Updating Tax AMount details per Due Detail Line
                                                Map<String, Decimal> tempTaxMap = ddlToQuoteLineTaxAmountsMap.get(dueDetailName);
                                                if(tempTaxMap == null) {
                                                    tempTaxMap = new Map<String, Decimal>();
                                                }
                                                tempTaxMap.put(quoteLineType, quoteLineTotalTaxAmount);
                                                ddlToQuoteLineTaxAmountsMap.put(dueDetailName, tempTaxMap);

                                                System.debug('dueDetailName: '+dueDetailName);
                                                System.debug('quoteLineType: '+quoteLineType);
                                                System.debug('quoteLineTotalTaxAmount: '+quoteLineTotalTaxAmount);
                                                System.debug('ddlToQuoteLineTaxAmountsMap: '+ddlToQuoteLineTaxAmountsMap);

                                                // Other tax values updates
                                                calculatedTax.put(dueDetailName, totalTaxComp);
                                                ddlTaxRatesMap.put(dueDetailName, taxRatesMap);
                                                ddlTaxValuesMap.put(dueDetailName, taxValuesMap);
                                                System.debug(LoggingLevel.ERROR, ' calculatedTax: '+calculatedTax);
                                                System.debug(LoggingLevel.ERROR, ' valuesMap: '+valuesMap);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                Map<String, String> taxRateFieldJurisdictionMap = VertexUtil.taxRateFieldJurisdictionMap;
                Map<String, String> taxValueFieldJurisdictionMap = VertexUtil.taxValueFieldJurisdictionMap;
                List<cllease__Due_Detail_Lines__c> dueDetailLineToUpdate = new List<cllease__Due_Detail_Lines__c>();
                Map<String, String> quoteDLLTaxFieldAPINameMap = new Map<String, String>();

                if(isTerminationTaxCall) {
                    String quoteType, quoteReason, productId; 
                    for(cllease__Due_Detail_Lines__c dueDetailLine : validDueDetailsToUpdate) {
                        if(dueDetailLine.Termination_Quote_Reason__c == 'ROLL-OVER') {
                            isRollOverTermination = true;
                        }
                        // extracting the details from due detail line.
                        quoteType   = dueDetailLine.Termination_Quote_Type__c;
                        quoteReason = dueDetailLine.Termination_Quote_Reason__c;
                        productId   = dueDetailLine.cllease__Contract__r.cllease__Lease_Product_Name__c;
                    }
                    // Extracting the Quote Configuration
                    quoteConfig = CLSTerminationUtil.getTerminationConfiguration(quoteType, quoteReason, productId);

                    if(quoteConfig != null) {
                        List<cllease__Termination_Config_Line__c> quoteConfigLines = quoteConfig.cllease__Termination_Config_Lines__r;
                        // Creating Map for Vertex Taxable Line Map.
                        for(cllease__Termination_Config_Line__c quoteConfigLine : quoteConfigLines) {
                            if(quoteConfigLine.Consider_for_Vertex_Tax__c && quoteConfigLine.DDL_Quote_Line_Tax_Field_API_Name__c != null) {
                                quoteDLLTaxFieldAPINameMap.put(quoteConfigLine.cllease__Quote_Line__c, quoteConfigLine.DDL_Quote_Line_Tax_Field_API_Name__c);
                            }
                        }
                    }
                    
                }

                // Updating the TaxValue and TaxComponent in Due Detail lines
                for(cllease__Due_Detail_Lines__c dueDetailLine : validDueDetailsToUpdate) {
                    if(valuesMap.containsKey(dueDetailLine.Name) 
                        && calculatedTax.containsKey(dueDetailLine.Name)) {
                        Decimal taxAmount   = valuesMap.get(dueDetailLine.Name);
                        String taxComponent = calculatedTax.get(dueDetailLine.name);
                        dueDetailLine.cllease__Tax_Due_Amount__c    = taxAmount;
                        dueDetailLine.cllease__Total_Due_Amount__c += taxAmount;
                        dueDetailLine.Tax_Component__c              = taxComponent;                
                        dueDetailLine.cllease__Tax_Processed__c     = true;
                        dueDetailLine.Vertex_Tax_Processed__c       = 'YES';
                        
                        Decimal billedTaxAmount = billsTaxDueMap.get(dueDetailLine.cllease__Bill__c);
                        if(billedTaxAmount == null) {
                            billedTaxAmount = 0.0;
                        }
                        billsTaxDueMap.put(dueDetailLine.cllease__Bill__c, billedTaxAmount + taxAmount);
                        dueDetailLine.cllease__Remarks__c = 'Successfully Processed Vertex Tax...';
                        // Updating tax Rates and Tax values @ Jurisdiction level
                        if(ddlTaxRatesMap.containsKey(dueDetailLine.Name)) {
                            Map<String, Decimal> taxRatesMapTemp = ddlTaxRatesMap.get(dueDetailLine.Name);
                            for(String jurisdiction: taxRatesMapTemp.keySet()) {
                                //System.debug(LoggingLevel.ERROR, ' Processing:'+jurisdiction);
                                String ddlTaxFieldName = taxRateFieldJurisdictionMap.get(jurisdiction);
                                //System.debug(LoggingLevel.ERROR, ' tax Rates Field: '+chargeTaxFieldName+ 'Value: '+taxRatesMapTemp.get(jurisdiction));
                                dueDetailLine.put(ddlTaxFieldName, taxRatesMapTemp.get(jurisdiction)*100);
                            }
                        }
                        if(ddlTaxValuesMap.containsKey(dueDetailLine.Name)) {
                            Map<String, Decimal> taxValuesMapTemp = ddlTaxValuesMap.get(dueDetailLine.Name);
                            for(String jurisdiction: taxValuesMapTemp.keySet()) {
                                String ddlTaxValueName = taxValueFieldJurisdictionMap.get(jurisdiction);
                                //System.debug(LoggingLevel.ERROR, ' tax values Field: '+chargeTaxValueName+ 'Value: '+taxValuesMapTemp.get(jurisdiction));
                                dueDetailLine.put(ddlTaxValueName, taxValuesMapTemp.get(jurisdiction));
                            }
                        }
                        dueDetailLineToUpdate.add(DueDetailLine);
                    } 
                    // Updating tax amounts per Quote line
                    if(quoteDLLTaxFieldAPINameMap.size() > 0) {
                        Map<String, Decimal> dueDetailLineQuoteTaxMap = ddlToQuoteLineTaxAmountsMap.get(dueDetailLine.Name);
                        for(String quoteLineType : quoteDLLTaxFieldAPINameMap.keySet()) {
                            String ddlTaxFieldAPIName = quoteDLLTaxFieldAPINameMap.get(quoteLineType);
                            Decimal ddlTaxAmount      = dueDetailLineQuoteTaxMap.get(quoteLineType);
                            dueDetailLine.put(ddlTaxFieldAPIName, ddlTaxAmount);
                        }
                    }              
                }

                if(dueDetailLineToUpdate.size() > 0) {
                    System.debug(LoggingLevel.INFO, ' dueDetailLineToUpdate: '+valuesMap);
                    update dueDetailLineToUpdate;
                }

                if(billsTaxDueMap.size() > 0) {
                    // Querying Updating the Bills with with tax details 
                    List<cllease__Lease_account_Due_Details__c> billsList = [SELECT Id, Name,
                                                                                    cllease__Total_Due_Amount__c,
                                                                                    cllease__Tax_Due_Amount__c,
                                                                                    cllease__Duelines_Items_Count__c,
                                                                                    VertexTax_Computed_DDL_Count__c 
                                                                             FROM cllease__Lease_account_Due_Details__c 
                                                                             WHERE Id IN :billsTaxDueMap.keyset()];

                    List<cllease__Lease_account_Due_Details__c> billsToUpdate = new List<cllease__Lease_account_Due_Details__c>();
                
                    for(cllease__Lease_account_Due_Details__c bill : billsList) {
                        Decimal taxAmount = billsTaxDueMap.get(bill.Id);
                        bill.cllease__Tax_Due_Amount__c   = (bill.cllease__Tax_Due_Amount__c!= null ? bill.cllease__Tax_Due_Amount__c : 0);
                        bill.cllease__Total_Due_Amount__c = (bill.cllease__Total_Due_Amount__c!= null ? bill.cllease__Total_Due_Amount__c : 0);
                        bill.cllease__Tax_Due_Amount__c  += taxAmount;
                        bill.cllease__Total_Due_Amount__c+= taxAmount;
                        //System.debug('bill due-detail lines count = ' + bill.cllease__Duelines_Items_Count__c);
                        //System.debug('bill due-detai lines tax computed count = ' + bill.VertexTax_Computed_DDL_Count__c);
                        if(bill.cllease__Duelines_Items_Count__c == bill.VertexTax_Computed_DDL_Count__c) {
                            bill.cllease__Status__c = 'Tax Calculated'; 
                            bill.cllease__Tax_Processed__c = true;
                        }
                        billsToUpdate.add(bill);
                    }

                    // Updating Bills.
                    if(billsToUpdate.size() > 0) {
                        update billsToUpdate;
                    }
                }

            } else if(responseCode == 500){
                // Process the response for Error message
                Dom.Document responseDom = new Dom.Document();
                responseDom.load(res.getbody());
                DOM.XMLNode root = responseDom.getRootElement();
                for(Dom.XMLNode soapBodyChild : root.getChildren()) {
                    System.debug(LoggingLevel.ERROR, ' processing node: '+soapBodyChild.getName());
                    if(soapBodyChild.getName() == 'Body') {
                        for(Dom.XMLNode fault : soapBodyChild.getChildren()) {
                            if(fault.getName() == 'Fault') {
                                for(Dom.XMLNode faultString : fault.getChildren()) {
                                    if(faultString.getName() == 'faultstring') {
                                        throw new CLSCustomException(faultString.getText().trim());
                                    }
                                }
                            }
                        }
                    }
                }

            } else {
                // For any other responses apart from 200, 500
                throw new CLSCustomException('Unknown Vertex API Response Code: '+responseCode +' Please check with Vertex.');
            
            }

            if(invalidDueDetailsToUpdate.size() > 0) {
                update invalidDueDetailsToUpdate;

            }

            // Do post Termination updates to Create 1. Invoice Creation, 2. Disbursements Creation 3. Payment Creation & Apply
            // do Actions only if Rollover (auto tradeup) terminated contracts
            
            if(isRollOverTermination) {
                CLSTerminationUtil.doPostTerminationUpdates(contractIds, quoteConfig);
            }
            
			
        } catch(exception e){           
            Database.rollback(sp);   
            System.debug('ERROR: '+e.getMessage());
            System.debug('ERROR trace: '+e.getStackTraceString());
            //A. insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name='VertexGetTaxonBillsJob: ',
            cllease__Date__c=system.today(), cllease__Message__c='Error is '+e.getmessage()
            +' in line number: '+ e.getlinenumber());

            //B. Updating All DueDetails lines for failure
            for(cllease__Due_Detail_Lines__c dueDetailLine : dueDetailLines) {
                dueDetailLine.cllease__Remarks__c = 'Vertex Tax Batch failed. Please Check Batch log for more details';
            }
            update dueDetailLines;
       }
    }

    // Validation: Separates the invalid Due Detail lines with dueDetailLines
    private void validateAddress(List<cllease__Due_Detail_Lines__c> dueDetailLines, List<cllease__Due_Detail_Lines__c> validDueDetailsToUpdate, List<cllease__Due_Detail_Lines__c> invalidDueDetailsToUpdate) {
        
        // Looping all Due detail lines for Equipment Install Address Ids.
        Set<Id> addressIds = new Set<Id>();
        for(cllease__Due_Detail_Lines__c dueDetailLine : dueDetailLines) {
            if(dueDetailLine.cllease__Contract_Equipment__c != null
                && dueDetailLine.cllease__Contract_Equipment__r.Install_Address__c != null) {
                addressIds.add(dueDetailLine.cllease__Contract_Equipment__r.Install_Address__c);
            }
        }

        String EXPERIAN_VALIDATION_STATUS   = DLLNewCoConstants.EXPERIAN_VALIDATION_STATUS;
        String USER_PREFERED_STATUS         = DLLNewCoConstants.USER_PREFERED_STATUS;

        Map<Id, Address__c> addressMap = new Map<Id, Address__c>(
                                            [SELECT Id, Name, Validation_Status__c
                                            FROM Address__c
                                            WHERE Id IN :addressIds]);


        // Only Addresses which are validated by Experian are considering as Valid Records.
        for(cllease__Due_Detail_Lines__c dueDetailLine : dueDetailLines) {
            if(dueDetailLine.cllease__Contract_Equipment__c != null
                && dueDetailLine.cllease__Contract_Equipment__r.Install_Address__c != null
                && addressMap.containsKey(dueDetailLine.cllease__Contract_Equipment__r.Install_Address__c)
                && (addressMap.get(dueDetailLine.cllease__Contract_Equipment__r.Install_Address__c).Validation_Status__c == EXPERIAN_VALIDATION_STATUS
                    || addressMap.get(dueDetailLine.cllease__Contract_Equipment__r.Install_Address__c).Validation_Status__c == USER_PREFERED_STATUS)) {
                validDueDetailsToUpdate.add(dueDetailLine);
            
            } else {
                dueDetailLine.cllease__Remarks__c = 'Linked Address not validated by Experian. Skipping Vertex Tax Computation...';
                invalidDueDetailsToUpdate.add(dueDetailLine);
            
            }
        }

        // TODO: Only take due detail lines for Contract where address validated by Experian

    }
   
    public override void doInitialize() { }
    public override void doStart(Database.BatchableContext bc) { }   
    public override void doFinish(Database.BatchableContext bc) { }
     
}