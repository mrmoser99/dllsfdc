/**
 * Author: Cloud Lending Solutions
 * Description: Following  job helps in calculating  the Tax for Charges
 **/
global class VertexGetTaxonChargesJob extends clcommon.DynamicJob implements Database.AllowsCallouts {  
 
    private static String query;
    private static final String JOB_NAME = 'Vertex Tax on Charges Job';

    global VertexGetTaxonChargesJob() {
        super(JOB_NAME, initialize(null));
        doInitialize();
    }
    
    global VertexGetTaxonChargesJob(List<String> contractNames) {
        super(JOB_NAME, initialize(contractNames));
        doInitialize();
    }
    
    global virtual override String getRuntimeQuery() {
        System.debug(LoggingLevel.ERROR, 'VertexGetTaxonChargesJob query in getRuntimeQuery : ' + query);
        return query; 
    }

    public static String initialize(List<String> contractNames) {

        query = ' SELECT Id, Name '+
                ' FROM cllease__Lease_Account__c '+
                ' WHERE cllease__Lease_Status__c in (\'ACTIVE - GOOD STANDING\',\'ACTIVE - BAD STANDING\')';

        if(contractNames!=null && contractNames.size() > 0) {
            String contractNamesStr = '';
            for (String contractName : contractNames) {
              contractNamesStr = contractNamesStr + '\'' + String.escapeSingleQuotes(contractName) + '\'' + ',';
            }
            contractNamesStr = contractNamesStr.substring(0, contractNamesStr.length() - 1);
            query += ' AND Name in ('+ contractNamesStr + ')';
        }
        
        System.debug(LoggingLevel.ERROR, 'VertexGetTaxonChargesJob Query: '+query);       
        return query;
    }

    private static List<sObject> getRecords(List<String> contractNames) {
        // Creating Query using ObjectCache
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache taxChargeOC = ec.getObject('clleaseCharge');
        if(taxChargeOC != null) {
            ec.deleteObject('clleaseCharge');      
        }        
        taxChargeOC = ec.createObject('clleaseCharge', 'cllease__Charge__c');
        
        String fields = 'Tax_Processed__c, '
                       + 'DestinationCity__c, '
                       + 'DestinationZipCode__c, '
                       + 'DestinationState__c, '
                       + 'Transaction_Code__c, '
                       + 'LeaseType__c, '
                       + 'cllease__Remarks__c, '
                       + 'Contract_Type__c, '
                       + 'Tax_Payment_Type__c, '
                       + 'Taxbasis__c, '
                       + 'cllease__Tax_Processed__c, '
                       + 'cllease__Original_Amount__c, '
                       + 'cllease__Principal_Due__c, '
                       + 'cllease__Tax_Due__c, '
                       + 'cllease__Fee_Definition__r.name, '
                       + 'cllease__Contract_Equipment__c, '
                       + 'cllease__Contract_Equipment__r.Install_Address__c, '
                       + 'cllease__Contract_Equipment__r.Name, '
                       + 'cllease__Contract_Equipment__r.GARD__c, '
                       + 'cllease__Contract_Equipment__r.cllease__Tax_exemption__c, '
                       + 'cllease__Contract_Equipment__r.Asset_Type_ID__c, '
                       + 'cllease__Contract_Equipment__r.Asset_Type_Name__c, '
                       + 'cllease__Contract_Equipment__r.Asset_ID__c, '
                       + 'cllease__Contract_Equipment__r.Master_Asset_Type__c, '
                       + 'cllease__Contract_Equipment__r.Master_Asset_Type_ID__c, '
                       + 'cllease__Lease_Account__r.Name, '
                       + 'cllease__Lease_Account__r.cllease__Account__r.Tax_Exempt__c, '
                       + 'cllease__Lease_Account__r.cllease__Contract_Date__c, '
                       + 'cllease__Lease_Account__r.cllease__Term__c, '
                       + 'cllease__Lease_Account__r.cllease__First_Payment_Date__c, '
                       + 'cllease__Lease_Account__r.cllease__Maturity_Date__c, '
                       + 'cllease__Lease_Account__r.cllease__Lease_Status__c,'
            		   + 'cllease__Lease_Account__r.cllease__application_number__c,'
                       + 'cllease__Lease_Account__c, '
                       + 'cllease__Lease_Account__r.Billing_Address__c, '
                       + 'cllease__Fee_Definition__r.clcommon__Fee_Type__c ';

        // Tax Rate and Tax Values fields : 32 fields: so adding  in different string for tracking.
        String taxFields = 'Tax_APO__c, Tax_BOROUGH__c, Tax_CITY__c, Tax_COUNTRY__c, Tax_COUNTY__c, Tax_DISTRICT__c, Tax_FPO__c,'+
                            'Tax_LOCAL_IMPROVEMENT_DISTRICT__c, Tax_PARISH__c, Tax_PROVINCE__c, Tax_SPECIAL_PURPOSE_DISTRICT__c,'+
                            'Tax_STATE__c, Tax_TERRITORY__c, Tax_TOWNSHIP__c, Tax_TRADE_BLOCK__c, Tax_TRANSIT_DISTRICT__c,'+
                            'Tax_Rate_APO__c, Tax_Rate_BOROUGH__c, Tax_Rate_CITY__c, Tax_Rate_COUNTRY__c, Tax_COUNTY__c,'+
                            'Tax_Rate_DISTRICT__c, Tax_Rate_FPO__c, Tax_Rate_LOCAL_IMPROVEMENT_DISTRICT__c, Tax_Rate_PARISH__c,'+
                            'Tax_Rate_PROVINCE__c, Tax_Rate_SPECIAL_PURPOSE_DISTRICT__c, Tax_Rate_STATE__c, Tax_Rate_TERRITORY__c,'+
                            'Tax_Rate_TOWNSHIP__c, Tax_Rate_TRADE_BLOCK__c, Tax_Rate_TRANSIT_DISTRICT__c';


        taxChargeOC.addFields(fields + ', ' + taxFields);
        taxChargeOC.addNamedParameter('taxProcessedStatus', 'Tax Not Calculated'); 
        String whereClause = ' (cllease__Tax_Processed__c =  :taxProcessedStatus)';

        if(contractNames != null && contractNames.size() > 0) {
            taxChargeOC.addNamedParameter('contractNames', contractNames);
            whereClause += ' AND cllease__Lease_Account__r.Name IN :contractNames ';
        }

        taxChargeOC.setWhereClause(whereClause);
        taxChargeOC.setOrderClause('cllease__Lease_Account__r.Name asc');
        taxChargeOC.buildQuery();
        taxChargeOC.executeQuery();
        
        System.debug(LoggingLevel.ERROR, 'VertexGetTaxonChargesJob Query: '+taxChargeOC.getQuery());
        return taxChargeOC.getRecords();
    }
   
    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {

        List<cllease__Lease_Account__c> contracts = (List<cllease__Lease_Account__c>)scope;
        List<String> contractNames = new List<String>();
        for(cllease__Lease_Account__c contract : contracts) {
            contractNames.add(contract.Name);
        }

        List<cllease__Charge__c> charges = (List<cllease__Charge__c>) getRecords(contractNames);

        // Skip the process in case of due detail lines size = 0
        if(charges == null || charges.size() == 0) {
            return;
        }

        List<cllease__Charge__c> invalidChargesToUpdate = new List<cllease__Charge__c>();
        List<cllease__Charge__c> validChargesToUpdate = new List<cllease__Charge__c>();
        HttpResponse res;
        Integer responseCode = 0;

        VertexApi__c vertexConfig = CLSCustomUtil.getVertexConfiguration();
        // Logging Vertex Request and Response XML Files
        Vertex_Log__c vertexLog = new Vertex_Log__c();
        // 1. Creating http request for the Due Detail Lines & Do Callout 
        try {
            // A. following  method separates the valid and invalid list based on address
            validateAddress(charges, validChargesToUpdate, invalidChargesToUpdate);

            // B. Proceed with Vertex Call only for Valid Charges
            if(validChargesToUpdate.size() > 0) {
                Dom.document methoddoc = VertexUtil.getChargesXml(validChargesToUpdate);  
                VertexUtil.validateVertexConfig(vertexConfig);

                ////System.debug(LoggingLevel.ERROR, '=================================');
                System.debug(LoggingLevel.ERROR,'methoddoccc'+methoddoc.toXmlString());
                ////System.debug(LoggingLevel.ERROR, '=================================');

                // 1.a Creating Http Request
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
                    res = VertexHttpResponseGenerator.vertexChargeHTTPResponse(charges);
                }

                ////System.debug(LoggingLevel.ERROR, ' Response Code: '+res.getStatusCode());
                responseCode = res.getStatusCode();
                System.debug('responseeee'+res.getBody());
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
            insert new cllease__Batch_Process_Log__c(Name='VertexGetTaxonChargesJob: ',
            cllease__Date__c=system.today(), cllease__Message__c='Error is '+e.getmessage()
            +' in line number: '+ e.getlinenumber());

            // B. Updating All DueDetails lines for failure
            for(cllease__Charge__c charge : charges) {
                charge.cllease__Remarks__c = 'Vertex Tax Batch failed. Please Check Batch log for more details';
            }
            update charges;

            // Skip the process in case of any exception during initial Callout Exception
            return;

        } finally {
            // Logging the Vertex Request
            if(!System.Test.isRunningTest() && vertexConfig.Enable_Vertex_Xml_Logging__c
                && vertexLog.Request_XML__c != null && vertexLog.Response_XML__c != null) {
                vertexLog.Contract_Names__c = CLSCustomUtil.getStringsFromList(contractNames);
                vertexLog.Category__c = 'CHARGE-VERTEX TAX CALL';
                insert vertexLog;
            }
        }
        
        // 2. Processing Vertex Response SOAP
        Savepoint sp = Database.setsavepoint();
        try {
            if(responseCode == 200) {
                // Process Successful Response
                Dom.Document responseDom = new Dom.Document();
                responseDom.load(res.getbody());
                DOM.XMLNode root = responseDom.getRootElement();

                ////System.debug(LoggingLevel.ERROR, ' Charge Response: '+ res.getbody());

                Map<String, String> calculatedTax   = new Map<String,String>();
                Map<String, Decimal> valuesmap      = new Map<String, Decimal>();
                String jur, attr, taxComp = '', totalTaxComp = '', chargeName = '', calTax, taxRate;
                Map<String, Decimal> taxRatesMap;
                Map<String, Decimal> taxValuesMap;
                Map<String, Map<String, Decimal>> chargeTaxRatesMap = new Map<String, Map<String, Decimal>>();
                Map<String, Map<String, Decimal>> chargeTaxValuesMap = new Map<String, Map<String, Decimal>>();
                // Checking for VertexEnvelope
                for(Dom.XMLNode soapBodyChild : root.getChildren()) {
                    ////System.debug(LoggingLevel.ERROR, ' processing node: '+soapBodyChild.getName());
                    if(soapBodyChild.getName() == 'Body') {
                        for(Dom.XMLNode vertexEnvelope : soapBodyChild.getChildren()) {
                            if(vertexEnvelope.getName() == 'VertexEnvelope') {
                                ////System.debug(LoggingLevel.ERROR, ' inside processing vertexEnvelope');
                                // Process the Vertex Envelope
                                for(DOM.XMLNode child1 : vertexEnvelope.getChildren()) {
                                    if(child1.getName() == 'InvoiceResponse') {
                                        ////System.debug(LoggingLevel.ERROR, ' inside processing InvoiceResponse');
                                        for(DOM.XMLNode child2 :child1.getChildren()) {
                                            if(child2.getName() == 'LineItem') {
                                                ////System.debug(LoggingLevel.ERROR, ' inside processing LineItem');
                                                // Extracting Charge
                                                chargeName = child2.getAttributeValue('lineItemId', null); 
                                                taxComp = '';
                                                taxRatesMap  = new Map<String, Decimal>();
                                                taxValuesMap = new Map<String, Decimal>();

                                                for(DOM.XMLNode child3 :child2.getChildren()) {
                                                    // Extracting Taxes Jurisdiction & TotalTax Details
                                                    if(child3.getName() == 'Taxes') {
                                                        for(DOM.XMLNode child4 :child3.getChildren()) {
                                                            // Extracting Calculating Tax Value
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
                                                                taxComp = taxComp + ('(' + attr + ' ' + jur + ' ' + calTax + ')' + '\n');
                                                                totalTaxComp = taxComp;
                                                                //System.debug(LoggingLevel.ERROR, '---------------------------- '+taxComp);
                                                                //System.debug(LoggingLevel.ERROR, ' attr: '+attr+' calTax: '+calTax+ ' taxRate: '+taxRate); 
                                                               // Retrieving existing value from same Jurisdiction Level if any totalling Tax Rates and Values
                                                                Decimal totalTaxRate =  taxRatesMap.containsKey(attr) ? taxRatesMap.get(attr) : 0.0;
                                                                totalTaxRate += Decimal.valueOf(taxRate);

                                                                Decimal totalTaxValue =  taxValuesMap.containsKey(attr) ? taxValuesMap.get(attr) : 0.0;
                                                                totalTaxValue += Decimal.valueOf(calTax);

                                                                taxRatesMap.put(attr, totalTaxRate);
                                                                taxValuesMap.put(attr, totalTaxValue);
                                                                //System.debug(LoggingLevel.ERROR, ' taxRatesMap: '+taxRatesMap);
                                                                //System.debug(LoggingLevel.ERROR, ' taxValuesMap: '+taxValuesMap);
                                                                calTax = null;
                                                                taxRate = null;
                                                                break;
                                                            }
                                                        }
                                                    } else if(child3.getName() == 'TotalTax') {
                                                        valuesMap.put(chargeName, decimal.valueOf(child3.getText().trim()));
                                                    }
                                                }
                                                calculatedTax.put(chargeName, totalTaxComp);
                                                chargeTaxRatesMap.put(chargeName, taxRatesMap);
                                                chargeTaxValuesMap.put(chargeName, taxValuesMap);
                                                //System.debug(LoggingLevel.ERROR, ' chargeTaxRatesMap: '+chargeTaxRatesMap);
                                                //System.debug(LoggingLevel.ERROR, ' chargeTaxValuesMap: '+chargeTaxValuesMap);
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

                List<cllease__Charge__c> chargeList = new List<cllease__Charge__c>();
                for(cllease__Charge__c charge : charges) {
                    if(valuesmap.containsKey(charge.Name) 
                        && calculatedTax.containsKey(charge.Name)) {
                        Decimal taxAmount   = valuesmap.get(charge.Name);
                        String taxComponent = calculatedTax.get(charge.name);
                        charge.cllease__Tax_Due__c = taxAmount;
                        //charge.cllease__Principal_Due__c += taxAmount;
                        charge.Tax_Component__c = taxComponent;
                        charge.cllease__Tax_Processed__c = 'Tax Calculated';
                        charge.cllease__Remarks__c = 'Successfully Processed Vertex Tax...';
                        // Updating tax Rates and Tax values @ Jurisdiction level
                        if(chargeTaxRatesMap.containsKey(charge.Name)) {
                            Map<String, Decimal> taxRatesMapTemp = chargeTaxRatesMap.get(charge.Name);
                            for(String jurisdiction: taxRatesMapTemp.keySet()) {
                                //System.debug(LoggingLevel.ERROR, ' Processing:'+jurisdiction);
                                String chargeTaxFieldName = taxRateFieldJurisdictionMap.get(jurisdiction);
                                //System.debug(LoggingLevel.ERROR, ' tax Rates Field: '+chargeTaxFieldName+ 'Value: '+taxRatesMapTemp.get(jurisdiction));
                                charge.put(chargeTaxFieldName, taxRatesMapTemp.get(jurisdiction)*100);
                            }
                        }
                        if(chargeTaxValuesMap.containsKey(charge.Name)) {
                            Map<String, Decimal> taxValuesMapTemp = chargeTaxValuesMap.get(charge.Name);
                            for(String jurisdiction: taxValuesMapTemp.keySet()) {
                                String chargeTaxValueName = taxValueFieldJurisdictionMap.get(jurisdiction);
                                //System.debug(LoggingLevel.ERROR, ' tax values Field: '+chargeTaxValueName+ 'Value: '+taxValuesMapTemp.get(jurisdiction));
                                charge.put(chargeTaxValueName, taxValuesMapTemp.get(jurisdiction));
                            }
                        }
                        chargeList.add(charge);
                    }
                }
                // Updating Charge processing.
                if(chargeList.size() > 0) {
                    //////System.debug(LoggingLevel.ERROR, '---chargeList: '+chargeList);
                    update chargeList;   
                }                     
            
            } else if(responseCode == 500){ 
                // Process the response for Error message
                Dom.Document responseDom = new Dom.Document();
                responseDom.load(res.getbody());
                DOM.XMLNode root = responseDom.getRootElement();
                for(Dom.XMLNode soapBodyChild : root.getChildren()) {
                    //////System.debug(LoggingLevel.ERROR, ' processing node: '+soapBodyChild.getName());
                    if(soapBodyChild.getName() == 'Body') {
                        for(Dom.XMLNode fault : soapBodyChild.getChildren()) {
                            if(fault.getName() == 'Fault') {
                                //////System.debug(LoggingLevel.ERROR, ' Fault: '+fault.getName());
                                for(Dom.XMLNode faultString : fault.getChildren()) {
                                    ////System.debug(LoggingLevel.ERROR, ' FaultChild: '+faultString.getName());
                                    if(faultString.getName() == 'faultstring') {
                                        //////System.debug(LoggingLevel.ERROR, ' faultString.getText(): '+faultString.getText());
                                        throw new CLSCustomException(faultString.getText().trim());
                                    }
                                }
                            }
                        }
                    }
                }

            } else {
                // For any other responses apart from 200, 500
                throw new CLSCustomException(   'Unknown Vertex API Response Code: '+responseCode +' Please check with Vertex.');
            
            }

            if(invalidChargesToUpdate.size() > 0) {
                update invalidChargesToUpdate;

            }
            
        } catch(Exception e) {
            Database.rollback(sp);   
            ////System.debug(LoggingLevel.ERROR, '---Exception: '+e.getMessage());
            ////System.debug(LoggingLevel.ERROR, '---Exception stack trace: '+e.getStackTraceString());
            //insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name='VertexGetTaxonChargesJob: ',
            cllease__Date__c=system.today(), cllease__Message__c='Error is '+e.getmessage()
            +' in line number: '+ e.getlinenumber());

            // Updating All DueDetails lines for failure
            for(cllease__Charge__c charge : charges) {
                charge.cllease__Remarks__c = 'Vertex Tax Batch failed. Please Check Batch log for more details';
            }
            update charges;
        }                     
    }

    // Separates the invalid Due Detail lines with dueDetailLines
    private void validateAddress(List<cllease__Charge__c> charges, List<cllease__Charge__c> validChargesToUpdate, List<cllease__Charge__c> invalidChargesToUpdate) {
        // Validate Address details beforce proceeding
        // Looping all Due detail lines for Equipment Install Address Ids.
        Set<Id> addressIds = new Set<Id>();
        for(cllease__Charge__c charge : charges) {
            if(charge.cllease__Contract_Equipment__c != null
                && charge.cllease__Contract_Equipment__r.Install_Address__c != null) {
                addressIds.add(charge.cllease__Contract_Equipment__r.Install_Address__c);

            } else if(charge.cllease__Lease_Account__c != null
                && charge.cllease__Lease_Account__r.Billing_Address__c != null){
                addressIds.add(charge.cllease__Lease_Account__r.Billing_Address__c);

            }
        }

        String EXPERIAN_VALIDATION_STATUS   = DLLNewCoConstants.EXPERIAN_VALIDATION_STATUS;
        String USER_PREFERED_STATUS         = DLLNewCoConstants.USER_PREFERED_STATUS;
        Map<Id, Address__c> addressMap = new Map<Id, Address__c>(
                                            [SELECT Id, Name, Validation_Status__c
                                            FROM Address__c
                                            WHERE Id IN :addressIds]);

        // Looping through all charges to separate valid and invalid based on address validated by Experian
        for(cllease__Charge__c charge : charges) {
            if(charge.cllease__Contract_Equipment__c != null
                && charge.cllease__Contract_Equipment__r.Install_Address__c != null
                && addressMap.containsKey(charge.cllease__Contract_Equipment__r.Install_Address__c)
                && (addressMap.get(charge.cllease__Contract_Equipment__r.Install_Address__c).Validation_Status__c == EXPERIAN_VALIDATION_STATUS
                    || addressMap.get(charge.cllease__Contract_Equipment__r.Install_Address__c).Validation_Status__c == USER_PREFERED_STATUS)) {
                validChargesToUpdate.add(charge);

            } else if(charge.cllease__Lease_Account__c != null
                && charge.cllease__Lease_Account__r.Billing_Address__c != null
                && addressMap.containsKey(charge.cllease__Lease_Account__r.Billing_Address__c)
                && (addressMap.get(charge.cllease__Lease_Account__r.Billing_Address__c).Validation_Status__c == EXPERIAN_VALIDATION_STATUS
                    || addressMap.get(charge.cllease__Lease_Account__r.Billing_Address__c).Validation_Status__c == USER_PREFERED_STATUS)) {
                validChargesToUpdate.add(charge);

            } else {
                charge.cllease__Remarks__c = 'Linked Address not validated by Experian. Skipping Vertex Tax Computation...';
                invalidChargesToUpdate.add(charge);

            }
        }
    }
   
    public override void doInitialize() { }
    public override void doStart(Database.BatchableContext bc) { }   
    public override void doFinish(Database.BatchableContext bc) { }
}