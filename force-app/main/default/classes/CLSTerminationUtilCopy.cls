/**
 * Owner: Cloud Lending Solutions
 * Usage: Following class created as part of Termination Functionality customization
 * Note: Code needs to retire on Upgrading latest versions where Multiple Termination Quotes can be created through API      
 **/
public with sharing class CLSTerminationUtilCopy {
    
    public static void inititeVertexTerminationQuotation(String quoteHeaderId) {
        // 1. Query Termination Details
        List<cllease__Termination_Quote_Header__c> quoteHeaders = queryTerminationQuoteDetails(quoteHeaderId);

        if(quoteHeaders.size() > 1 || quoteHeaders.size() == 0) {
            throw new CLSCustomException('Invalid no of Termination Quotes created...');
        } 

        // 2. Create Terminaton QUote Equipment (junction object for Termination Quote lines Proration)
        createTerminationEqpQuoteObjects(quoteHeaders[0]);

        // 3. Call Vertex Termination QUote Taxation
        getTerminationQuoteTax(quoteHeaders[0].Id);
    }

    /**
     * Following method helps in Calculating the Tax for Termination Quote
     **/
    //@future(callout=true)
    public static void getTerminationQuoteTax(String quoteHeaderId) {

        VertexApi__c vertexConfig = CLSCustomUtil.getVertexConfiguration();
        Vertex_Log__c vertexLog = new Vertex_Log__c();
        cllease__Termination_Quote_Line__c vertexTaxQuoteLine;

        List<cllease__Termination_Quote_Header__c> quoteHeaders = queryTerminationQuoteDetails(quoteHeaderId);
        cllease__Termination_Quote_Header__c quoteHeader = quoteHeaders[0];

        HttpResponse res;
        Integer responseCode = 0; 
        try {

            // Validation on Quote Lines
            // 2. Create XML Request
            Map<String, Termination_Equipment_Quote__c> quoteLinesToProcessForTaxMap = new Map<String, Termination_Equipment_Quote__c>();
            Map<String, Termination_Equipment_Quote__c> quoteLinesMap = new Map<String, Termination_Equipment_Quote__c>();
            //2020-12-14 By CKB
            List<cllease__Termination_Config_Line__c> configLineList = [select id,name,cllease__Termination_Config__c,cllease__Quote_Line__c,cllease__Field_API_Name__c,
                                                                cllease__Bill_Field_API_Name__c,Consider_for_Vertex_Tax__c,cllease__Add_To_Quote_Amount__c,DDL_Quote_Line_Tax_Field_API_Name__c 
                                                                from cllease__Termination_Config_Line__c where cllease__Termination_Config__c='a733u000000bxIV' and Consider_for_Vertex_Tax__c=true];
            
            for(Termination_Equipment_Quote__c eqpQuoteLine : quoteHeader.Termination_Equipment_Quotes__r) {
                for(cllease__Termination_Config_Line__c config : configLineList){//2020-12-14 By CKB
                    if(eqpQuoteLine.Termination_Quote_Line__r.cllease__Line_Type__c == config.cllease__Quote_Line__c && config.Consider_for_Vertex_Tax__c==true) {
                        vertexTaxQuoteLine = new cllease__Termination_Quote_Line__c(Id = eqpQuoteLine.Termination_Quote_Line__c, cllease__Quote_Header__c = quoteHeader.Id);
                    }
                }
                
            }
            //System.debug(LoggingLevel.ERROR, '--- quoteLinesToProcessForTaxMap: '+quoteLinesToProcessForTaxMap.values());

            // 3. Send HTTP Rquest 
            Dom.document methoddoc = VertexUtil2.getTerminationQuoteReqXml(quoteHeader, quoteHeader.Termination_Equipment_Quotes__r);
            System.debug(LoggingLevel.ERROR, '=================================');
            System.debug(LoggingLevel.ERROR,'request: '+methoddoc.toXmlString());
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
                res = VertexHttpResponseGenerator.generateQuoteResponse(quoteHeader.Termination_Equipment_Quotes__r);
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
            insert new cllease__Batch_Process_Log__c(Name='Termination Quote Request: ', cllease__Date__c=system.today(), 
            cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
            // C. Skip the process in case of any exception during initial Callout Exception
            return; 

        } finally {
            // Logging the Vertex Request
            if(!System.Test.isRunningTest() && vertexConfig.Enable_Vertex_Xml_Logging__c
                && vertexLog.Request_XML__c != null && vertexLog.Response_XML__c != null) {
                vertexLog.Contract_Names__c = CLSCustomUtil.getStringsFromList(new List<String> {quoteHeader.cllease__Contract__r.Name});
                vertexLog.Category__c = 'TERMINATION QUOTE-VERTEX TAX CALL';
                insert vertexLog;
            }
        }

        // 2. Processing Vertex Response SOAP only incase No HTTP Failures from 1.
        Savepoint sp = Database.setsavepoint();
        try {
            // Process Successful Response
            Dom.Document responseDom = new Dom.Document();
            responseDom.load(res.getbody());

            System.debug(LoggingLevel.ERROR, '=================================');
            System.debug(LoggingLevel.ERROR,'response: '+responseDom.toXmlString());
            System.debug(LoggingLevel.ERROR, '=================================');

            // Processing Vertex Response SOAP
            if(responseCode == 200) {
                DOM.XMLNode root = responseDom.getRootElement();
                Boolean foundProduct = false, foundTotalTax = false;
                String lineType; 
                Decimal taxAmount = 0;
                // 4. Process the response and update the tax amounts in Quote Line.
                for(Dom.XMLNode soapBodyChild : root.getChildren()) {
                    //System.debug(LoggingLevel.ERROR, ' processing node: '+soapBodyChild.getName());
                    if(soapBodyChild.getName() == 'Body') {
                        for(Dom.XMLNode vertexEnvelope : soapBodyChild.getChildren()) {
                            if(vertexEnvelope.getName() == 'VertexEnvelope') {
                                System.debug(LoggingLevel.ERROR, ' inside processing vertexEnvelope');
                                // Process the Vertex Envelope
                                for(DOM.XMLNode child1 : vertexEnvelope.getChildren()) {
                                    if(child1.getName() == 'QuotationResponse') {
                                        System.debug(LoggingLevel.ERROR, ' inside processing QuotationResponse');
                                        /*for(DOM.XMLNode child2 :child1.getChildren()) {
                                            // Resetting the flag for each item iteration
                                            //foundProduct = false;
                                            foundTotalTax = false;
                                            if(child2.getName() == 'LineItem') {
                                                for(DOM.XMLNode child3 :child2.getChildren()) {
                                                    // Check for Product and Tax Amounts from Node.

                                                    if(child3.getName() == 'TotalTax') {
                                                        taxAmount = Decimal.valueOf(child3.getText());

                                                        //foundTotalTax = true;
                                                    }
                                                }
                                            }

                                        }*/

                                        // Getting Total Estimated Tax for Quote level
                                        for(DOM.XMLNode child2 :child1.getChildren()) {
                                            if(child2.getName() == 'TotalTax') {
                                                taxAmount = Decimal.valueOf(child2.getText());
                                                //foundTotalTax = true;
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                } 

                System.debug(LoggingLevel.ERROR, ' Updated Vertex QUoteline record:taxAmount  '+taxAmount);
                // Updating the Tax Amount in VERTEX TAX quote line
                vertexTaxQuoteLine.cllease__Amount__c =  taxAmount;
                update vertexTaxQuoteLine;

                 // Updating the Termination Quote Amount
                Decimal totalAmount = 0;

                // adding Tax Value 
                totalAmount = taxAmount;
                // Update the QUote Header value including the Tax Value
                for(cllease__Termination_Quote_Line__c eqpQuoteLine : quoteHeader.cllease__Termination_Quote_Lines__r) {
                    if(eqpQuoteLine.cllease__Add_To_Quote_Amount__c || eqpQuoteLine.cllease__Amount_Type__c == 'FEE' ) {
                        totalAmount += eqpQuoteLine.cllease__Amount__c;
                    }
                }

                quoteHeader.cllease__Quote_Amount__c = totalAmount;
                update quoteHeader;


                // ReSetting Vertex calculated flag = false after processing
                //TerminationUtil.updateQuoteVertexFlag(quoteHeader.Id, false);

            } else if(responseCode == 500){
                // Process the response for Error message
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
            
        } catch(exception e){           
            Database.rollback(sp);   
            insert new cllease__Batch_Process_Log__c(Name='Termination Quote Request: ', cllease__Date__c=system.today(), 
            cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
       }  
    }

    /**
     * 1. Creating Invoice Credit for unpaid bills & Chargess in system , 
     * 2. Creating Payments instantly
     * 3. Creating Disbursement Transactions for Service Fee from Bill. 
     */
    public static void doPostTerminationUpdates(cllease__Lease_Account__c contract, cllease__Termination_Config__c quoteConfig) {
        // Create 1. Invoice Credit 2. Payments for each unpaid bill & Charges (which has tax calculated)
        // 3. Create Disbursements for service Fee of termination 
        List<cllease__Invoice_Credit__c> creditInvoiceList              = new List<cllease__Invoice_Credit__c>();
        List<cllease__Lease_Payment_Transaction__c> paymentTxnsList     = new List<cllease__Lease_Payment_Transaction__c>();
        List<clcommon__Disbursement_Transaction__c> disbursementTxnList = new List<clcommon__Disbursement_Transaction__c>();
        List<clcommon__Cash_Receipt__c> cashReceipts = new List<clcommon__Cash_Receipt__c>();

        Map<String, clcommon__Cash_Receipt__c> cashReceiptMap                   = new Map<String, clcommon__Cash_Receipt__c>();
        Map<String, clcommon__Cash_Receipt_Application__c> cashReceiptAppMap    = new Map<String, clcommon__Cash_Receipt_Application__c>();
        Map<String, cllease__Lease_Payment_Transaction__c> paymentTxnMap        = new Map<String, cllease__Lease_Payment_Transaction__c>();

        List<cllease__Lease_account_Due_Details__c> billList    = contract.cllease__Dues_Details__r;
        List<cllease__Charge__c> chargeList                     = contract.cllease__Charges__r;
        List<cllease__Due_Detail_Lines__c> dueDetailList        = contract.cllease__Due_Detail_Lines__r;

        Date currentSysDate = cllease.SystemDateUtil.getCurrentSystemDate();
        cllease__Payment_Mode__c paymentMode    = [SELECT Id, Name FROM cllease__Payment_Mode__c WHERE Name = 'Invoice Credit' LIMIT 1];
        clcommon__Payment_Mode__c clcpmtMode    = [SELECT Id, Name FROM clcommon__Payment_Mode__c WHERE Name = 'Invoice Credit' LIMIT 1];

        List<String> disbTxnFieldAPINameList = new List<String>();
        if(quoteConfig != null) {
            List<cllease__Termination_Config_Line__c> quoteConfigLines = quoteConfig.cllease__Termination_Config_Lines__r;
            // Creating Map for Vertex Taxable Line Map.
            for(cllease__Termination_Config_Line__c quoteConfigLine : quoteConfigLines) {
                if(quoteConfigLine.Do_Passthrough__c && quoteConfigLine.cllease__Bill_Field_API_Name__c != null) {
                    disbTxnFieldAPINameList.add(quoteConfigLine.cllease__Bill_Field_API_Name__c);
                }
            }
        }
 
        Set<String> contractIdSet = new Set<String>();
        for(cllease__Lease_account_Due_Details__c bill : billList) {
            contractIdSet.add(bill.cllease__Lease_Account__c);
        }

        List<cllease__Contract_Fee_Payment__c> contractParties = [SELECT Id, Name, cllease__Pay_To__c, cllease__Pay_To__r.cllease__Party_Account_Name__c, cllease__Contract__c
                                                                FROM cllease__Contract_Fee_Payment__c 
                                                                WHERE cllease__Contract__c IN :contractIdSet 
                                                                    AND cllease__Contract_Fee__r.cllease__Fee_Definition__r.Name = 'Service Fees'];

        Map<Id, Id> contractDealerMap = new Map<Id, Id>();
        for(cllease__Contract_Fee_Payment__c contractParty : contractParties) {
            if(contractParty.cllease__Pay_To__c != null && contractParty.cllease__Pay_To__r.cllease__Party_Account_Name__c != null) {
                contractDealerMap.put(contractParty.cllease__Contract__c, contractParty.cllease__Pay_To__r.cllease__Party_Account_Name__c);
            }
        }

        // pre-processing Due Details lines for Map Creation
        Map<Id, List<cllease__Due_Detail_Lines__c>> billDueDetailLineMap = new Map<Id, List<cllease__Due_Detail_Lines__c>>();
        for(cllease__Due_Detail_Lines__c dueDetailLine: dueDetailList) {
            List<cllease__Due_Detail_Lines__c> tempDueList = billDueDetailLineMap.get(dueDetailLine.cllease__Bill__c);
            if(tempDueList == null) {
                tempDueList = new List<cllease__Due_Detail_Lines__c>();
            }
            tempDueList.add(dueDetailLine);
            billDueDetailLineMap.put(dueDetailLine.cllease__Bill__c, tempDueList);
        }

        if(billList.size() > 0) {
            for(cllease__Lease_account_Due_Details__c bill : billList) {
                String contractId   = bill.cllease__Lease_Account__c;
                if( bill.cllease__Status__c == 'Tax Calculated' && (bill.cllease__Balance_Amount__c > 0) ) {
                    Decimal dueAmount   = bill.cllease__Balance_Amount__c;
                    String LesseeAccId  = bill.cllease__Account__c;
                    String billNumber   = bill.Name;
                    // 1. Creating Invoice Credit
                    cllease__Invoice_Credit__c invCrdTmp = new cllease__Invoice_Credit__c();
                    invCrdTmp.cllease__Status__c                    = 'Fully Applied';
                    invCrdTmp.cllease__Original_Credit_Amount__c    = dueAmount;
                    invCrdTmp.cllease__Credit_Balance__c            = dueAmount;
                    invCrdTmp.cllease__Account__c                   = LesseeAccId;
                    invCrdTmp.cllease__Contract__c                  = contractId;
                    invCrdTmp.Is_Auto_Rollover__c                   = true;
    
                    creditInvoiceList.add(invCrdTmp);

                    // 2. Creation of cash receipt
                    clcommon__Cash_Receipt__c cashReceipt = new clcommon__Cash_Receipt__c();
                    cashReceipt.clcommon__Account__c        = LesseeAccId;
                    cashReceipt.clcommon__Payment_Mode__c   = clcpmtMode.Id;
                    cashReceipt.clcommon__Receipt_Date__c   = currentSysDate;
                    cashReceipt.clcommon__Receipt_Amount__c = dueAmount;
                    cashReceipt.clcommon__Creation_Date__c  = currentSysDate;
                    cashReceipt.clcommon__Unused_Amount__c  = dueAmount;
                    cashReceipt.clcommon__Receipt_Status__c = 'CREATED';
                    cashReceipts.add(cashReceipt);

                    cashReceiptMap.put(billNumber, cashReceipt);
    
                    // 3. . Creating Payment Transaction
                    cllease__Lease_Payment_Transaction__c pmtTxn = new cllease__Lease_Payment_Transaction__c();
                    pmtTxn.cllease__Contract__c             = contractId;                  
                    pmtTxn.cllease__Bills__c                = billNumber;
                    pmtTxn.cllease__Transaction_Amount__c   = dueAmount;
                    pmtTxn.cllease__Payment_Mode__c         = paymentMode.Id;
                    pmtTxn.cllease__Transaction_Date__c     = currentSysDate;
                    pmtTxn.cllease__Receipt_Date__c         = currentSysDate;
                    pmtTxn.cllease__Remarks__c              = 'Payment Created from Invoice Credit from AutoTradeup Process...';
    
                    paymentTxnsList.add(pmtTxn);

                    paymentTxnMap.put(billNumber, pmtTxn);
                }
                // Creating Disbursments transactions for passhrough as specified in termination config Lines
                cllease__Transaction_Sub_Type__c txnSubType = [SELECT Id FROM cllease__Transaction_Sub_Type__c WHERE Name = 'Termination Service Passthrough' LIMIT 1];
                if(disbTxnFieldAPINameList.size() > 0) {
                    for(String disbBillAPIName: disbTxnFieldAPINameList) {
                        if(billDueDetailLineMap.containsKey(bill.Id)) {
                            List<cllease__Due_Detail_Lines__c> dueDetailLineList = billDueDetailLineMap.get(bill.Id);
                            Decimal serviceAmount = 0;
                            // Summing up the passthrough amount from DUe Detail Line for disbursement transaction creation
                            for(cllease__Due_Detail_Lines__c ddl : dueDetailLineList) {
                                serviceAmount += (ddl.get(disbBillAPIName) != null ? (Decimal) ddl.get(disbBillAPIName) : 0.00 );
                            }
                            // Creating disbursemnt transaction if service amount > 0 
                            // Disbursement Transaction Creation.
                            if(serviceAmount > 0) {
                                // Extracting Service Fees's PayTo Details for Disbursement.
                                Id serverFeesPayToId = contractDealerMap.get(contractId);
            
                                clcommon__Disbursement_Transaction__c disb = new clcommon__Disbursement_Transaction__c();
                                //Disbursement Transaction Creation
                                disb.clcommon__Amount__c            = serviceAmount;
                                disb.cllease__Contract__c           = contractId;
                                disb.clcommon__Due_Date__c          = currentSysDate;
                                disb.cllease__Expense_Date__c       = currentSysDate;
                                disb.clcommon__Account__c           = serverFeesPayToId;
                                disb.clcommon__Transaction_Date__c  = currentSysDate;
                                disb.cllease__Transaction_Sub_Type__c  = txnSubType.Id;
                                disb.clcommon__Transaction_Type__c  = 'DISBURSEMENT';
                                disb.clcommon__Net_Amount__c        = serviceAmount;
                                disb.clcommon__Tax_Amount__c        = 0;
                                disb.clcommon__GL_Transaction_Flag__c = true;
                                disb.Remark__c                      = 'Disbursement creation for Passthrough amount from Termination Bill :'+bill.name;
            
                                disbursementTxnList.add(disb);
                            }
                        }
                    }
                }
            }
        }
        
        if(chargeList.size() > 0) {
            for(cllease__Charge__c charge : chargeList) {
                if((charge.cllease__Tax_Processed__c == 'Tax Calculated') && (charge.cllease__Total_Due_Amount__c > 0) ) {
                    Decimal dueAmount   = charge.cllease__Total_Due_Amount__c;
                    String contractId   = charge.cllease__Lease_Account__c;
                    String LesseeAccId  = charge.cllease__Lease_Account__r.cllease__Account__c;
                    String chargeNumber = charge.Name;
                    // 1. Creating Invoice Credit
                    cllease__Invoice_Credit__c invCrdTmp = new cllease__Invoice_Credit__c();
                    invCrdTmp.cllease__Status__c                    = 'Fully Applied';
                    invCrdTmp.cllease__Original_Credit_Amount__c    = dueAmount;
                    invCrdTmp.cllease__Credit_Balance__c            = dueAmount;
                    invCrdTmp.cllease__Account__c                   = LesseeAccId;
                    invCrdTmp.cllease__Contract__c                  = contractId;
                    invCrdTmp.Is_Auto_Rollover__c                   = true;
    
                    creditInvoiceList.add(invCrdTmp);

                    // 2. Creation of cash receipt
                    clcommon__Cash_Receipt__c cashReceipt = new clcommon__Cash_Receipt__c();
                    cashReceipt.clcommon__Account__c        = LesseeAccId;
                    cashReceipt.clcommon__Payment_Mode__c   = clcpmtMode.Id;
                    cashReceipt.clcommon__Receipt_Date__c   = currentSysDate;
                    cashReceipt.clcommon__Receipt_Amount__c = dueAmount;
                    cashReceipt.clcommon__Creation_Date__c  = currentSysDate;
                    cashReceipt.clcommon__Unused_Amount__c  = dueAmount;
                    cashReceipt.clcommon__Receipt_Status__c = 'CREATED';
                    cashReceipts.add(cashReceipt);

                    cashReceiptMap.put(chargeNumber, cashReceipt);
    
                    // 3. Creating Payment Transaction
                    cllease__Lease_Payment_Transaction__c pmtTxn = new cllease__Lease_Payment_Transaction__c();
                    pmtTxn.cllease__Contract__c             = contractId;                    
                    pmtTxn.cllease__Charges__c              = chargeNumber;
                    pmtTxn.cllease__Transaction_Amount__c   = dueAmount;
                    pmtTxn.cllease__Payment_Mode__c         = paymentMode.Id;
                    pmtTxn.cllease__Transaction_Date__c     = currentSysDate;
                    pmtTxn.cllease__Receipt_Date__c         = currentSysDate;
                    pmtTxn.cllease__Remarks__c              = 'Payment Created from Invoice Credit from AutoTradeup Process...';
    
                    paymentTxnsList.add(pmtTxn);

                    paymentTxnMap.put(chargeNumber, pmtTxn);
                    
                }
            }
        }
        

        if(creditInvoiceList.size() > 0) {
            insert creditInvoiceList;
        }

        if(disbursementTxnList.size() > 0) {
            insert disbursementTxnList;
        }

        // D. DML Operations on New Payments
        if(cashReceipts.size() > 0) {
            insert cashReceipts;
        }
        
        // Creating transaction for created cash receipt
        List<clcommon__Cash_Receipt_Transaction__c> accountingTxns = new List<clcommon__Cash_Receipt_Transaction__c>();
        List<clcommon__Cash_Receipt_Application__c> cashApplications = new List<clcommon__Cash_Receipt_Application__c>();

        for(String billChargeNumber : cashReceiptMap.keySet()) {
            clcommon__Cash_Receipt__c cashReceipt = cashReceiptMap.get(billChargeNumber);
            // Creating Cash Transaction
            clcommon__Cash_Receipt_Transaction__c accountingTxn = new clcommon__Cash_Receipt_Transaction__c();
            accountingTxn.clcommon__Cash_Receipt__c         = cashReceipt.Id;
            accountingTxn.clcommon__Transaction_Amount__c   = cashReceipt.clcommon__Receipt_Amount__c;
            accountingTxn.clcommon__Transaction_Date__c     = cashReceipt.clcommon__Creation_Date__c;
            accountingTxn.clcommon__New_Receipt_Date__c     = cashReceipt.clcommon__Receipt_Date__c;
            accountingTxn.clcommon__New_Account__c          = cashReceipt.clcommon__Account__c;
            accountingTxn.clcommon__Transaction_Sub_Type__c = 'CREATED_WITH_BORROWER';
            accountingTxns.add(accountingTxn);

            // Creating Cash Application
            clcommon__Cash_Receipt_Application__c cashApplication = new clcommon__Cash_Receipt_Application__c();
            cashApplication.clcommon__Cash_Receipt__c       = cashReceipt.Id;
            cashApplication.clcommon__Creation_Date__c      = cashReceipt.clcommon__Creation_Date__c;
            cashApplication.clcommon__Allocated_Amount__c   = cashReceipt.clcommon__Receipt_Amount__c;
            cashApplication.clcommon__Receipt_Application_Status__c   = 'CREATED';
            cashApplication.clcommon__Unused_Amount__c      = cashReceipt.clcommon__Receipt_Amount__c;
            cashApplications.add(cashApplication);

            cashReceiptAppMap.put(billChargeNumber, cashApplication);
        }
        
        if(accountingTxns.size() > 0){
            insert accountingTxns;
        }
        
        if(cashApplications.size() > 0){
            insert cashApplications;
        }

        for(String billChargeNumber : paymentTxnMap.keySet()) {
            clcommon__Cash_Receipt_Application__c cashReceiptApp = cashReceiptAppMap.get(billChargeNumber);
            cllease__Lease_Payment_Transaction__c pmtTxn = paymentTxnMap.get(billChargeNumber);
            pmtTxn.cllease__Cash_Application__c = cashReceiptApp.Id;
        }

        if(paymentTxnsList.size() > 0) {
            insert paymentTxnsList;
        }

        // Apply created payment 
        Set<Id> pmtIds = new Set<Id>();
        for(cllease__Lease_Payment_Transaction__c pmt : paymentTxnsList) {
            pmtIds.add(pmt.Id);
        }

        // 2. Querying all payments with required details
        List<cllease__Lease_Payment_Transaction__c> paymentTransactionList = 
                        [SELECT id, name,
                                cllease__Contract__c,
                                cllease__Contract__r.Id,
                                cllease__Contract__r.Name,
                                cllease__Contract__r.cllease__Lease_Status__c,
                                cllease__Contract__r.cllease__Lease_Product_Name__c,
                                cllease__Contract__r.cllease__Lease_Product_Name__r.cllease__Lease_Product_Type__c,
                                cllease__Contract__r.cllease__Payment_Frequency__c,
                                cllease__Contract__r.cllease__current_payment_amount__c,
                                cllease__Contract__r.cllease__Next_Due_Date__c ,
                                cllease__Contract__r.cllease__Term__c,
                                cllease__Contract__r.cllease__Payment_Spread__c,
                                cllease__Contract__r.cllease__Termination_Quote_accepted_flag__c,
                                cllease__Lease_Snapshot__c,
                                cllease__Fee_Snapshot__c,
                                cllease__Dues_Snapshot__c,
                                cllease__Cash_Balances_Snapshot__c,
                                cllease__Balance_s_Snapshot__c,
                                cllease__Custom_Logic__c,
                                cllease__Receipt_Id__c,
                                cllease__Transaction_Date__c,
                                cllease__Transaction_Time__c,
                                cllease__Early_Total_Repayment_of_the_Lease__c,
                                cllease__Write_Off_Recovery_Payment__c,
                                cllease__Payment_Mode__c,
                                cllease__Payment_Mode__r.Name,
                                cllease__Transaction_Amount__c,
                                cllease__Cleared__c,
                                cllease__Manual_Payment__c,
                                cllease__Fees__c,
                                cllease__Receivable_Billed__c,
                                cllease__Evergreen_Receivable_Billed__c,
                                cllease__Tax_Billed__c,
                                cllease__Excess__c,
                                cllease__Total_Charges_Principal__c,
                                cllease__Other_Charges_Principal__c,
                                cllease__Late_Charge_Principal__c,
                                cllease__Charge__c,
                                cllease__Bill__c,
                                cllease__Cash_Application__c 
                            FROM cllease__Lease_Payment_Transaction__c
                            WHERE Id IN :pmtIds
                            order by cllease__Transaction_Date__c]; 
        
        // 3. Calling CL Lease Global API to Apply Payments
        Savepoint sp = database.setsavepoint();
        try{
            cllease.BulkLeasePaymentAction dAction = new cllease.BulkLeasePaymentAction(paymentTransactionList);
            dAction.postPayments();
        } catch(Exception e){
            database.rollback(sp);   
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());
            throw e;
        }

    }

    /**
     * Query the contracts and do postTerminationUdpates
     */
    public static void doPostTerminationUpdates(Set<String> terminatedeContactIdSet, cllease__Termination_Config__c quoteConfig) {
        // Create Credit Invoice , for unpaid bills and charges
        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache contractObject = ec.getObject('contractRecords');
        if(contractObject != null) {
           ec.deleteObject('contractRecords');
        }  

        //String fields = 'Id, Name '; //CLSCustomUtil.fetchAllCustomFields('cllease__Due_Detail_Lines__c');
        contractObject = ec.createObject('contractRecords', 'cllease__Lease_Account__c');
        contractObject.addFields('Id, Name ');
        contractObject.addNamedParameter('terminatedeContactIdSet', terminatedeContactIdSet); //we looking for this
        contractObject.setWhereClause('Id IN :terminatedeContactIdSet');

        // Adding Billing Query Details
        mfiflexUtil.ObjectCache billOC = ec.createRelationship('cllease__Dues_Details__r');
        contractObject.addRelationship(billOC);
        billOC.addFields(CLSCustomUtil.fetchAllCustomFields('cllease__Lease_account_Due_Details__c'));
        billOC.setWhereClause('cllease__Status__c = \'Tax Calculated\'');

        // Adding Billing Query Details
        mfiflexUtil.ObjectCache ddlOC = ec.createRelationship('cllease__Due_Detail_Lines__r');
        contractObject.addRelationship(ddlOC);
        ddlOC.addFields(CLSCustomUtil.fetchAllCustomFields('cllease__Due_Detail_Lines__c'));
        ddlOC.setWhereClause('cllease__Bill__r.cllease__Status__c = \'Tax Calculated\' AND Vertex_Tax_Processed__c = \'YES\'');

        // adding Charges query Details
        mfiflexUtil.ObjectCache chargeOC = ec.createRelationship('cllease__Charges__r');
        contractObject.addRelationship(chargeOC);
        chargeOC.addFields(CLSCustomUtil.fetchAllCustomFields('cllease__Charge__c') +', cllease__Lease_Account__r.cllease__Account__c');
        chargeOC.setWhereClause('cllease__Tax_Processed__c = \'Tax Calculated\' AND cllease__Total_Due_Amount__c > 0');

        contractObject.buildQuery();
        contractObject.executeQuery();
        
        System.debug(LoggingLevel.ERROR, 'Contract Query: '+contractObject.getQuery());    
        List<cllease__Lease_Account__c> contractList = contractObject.getRecords();

        // Ideally following will be called once. 
        for(cllease__Lease_Account__c contract : contractList) {
            doPostTerminationUpdates(contract, quoteConfig);
        }
            
    }

    /**
     * Following method helps in Creating Termination Equipment Quotes
     **/
    public static void createTerminationEqpQuoteObjects(cllease__Termination_Quote_Header__c quoteHeader) {
        // 1. Creating instance variables
        System.debug(LoggingLevel.ERROR, ' quoteHeader eqps: '+quoteHeader.cllease__Termination_Quote_Equipments__r);
        System.debug(LoggingLevel.ERROR, ' quoteHeader lines: '+quoteHeader.cllease__Termination_Quote_Lines__r);
        
        // 2. Delete existing termination Equipment Quotes and create new ones for changed amounts
        if(quoteHeader != null && quoteHeader.Termination_Equipment_Quotes__r != null) {
            delete quoteHeader.Termination_Equipment_Quotes__r;
        }

        // 3. Creating Termination Equipment Quotes for Proration
        // 3.1 Calculate Prorated amounts for Termination Equipment Quotes and calculate tax per Equipment level in Termination.
        Decimal totalEquipmentCost = 0;
        for(cllease__Termination_Quote_Equipment__c quoteEqp : quoteHeader.cllease__Termination_Quote_Equipments__r) {
            totalEquipmentCost += quoteEqp.cllease__Contract_Equipment__r.cllease__Estimated_Selling_Price__c;
        }
        System.debug(LoggingLevel.ERROR, ' totalEquipmentCost: '+totalEquipmentCost);
        
        // 3.2 Calculate the Proration for each Equipments for amount split up for Contract Level
        String contractId = quoteHeader.cllease__Contract__c;
        
        // 3.3 Create Map of Payment Streams of FEES type with Equipments <Contract Equipment> wll be linked only to SERVICE FEE
        AggregateResult[] unEarnedChargesList = [SELECT sum(cllease__Rental_Amount__c) unbilledCharge, cllease__Contract_Equipment__c equipId
                                                    FROM  cllease__Payment_Stream__c
                                                    WHERE cllease__Contract__c = :contractId
                                                       AND Service_Fee_Unpaid_Flag__c = true
                                                    GROUP BY cllease__Contract_Equipment__c];

        Map<Id, Decimal> eqpToUnbilledChargesMap = new Map<Id, Decimal>();
        Decimal totalQuoteServiceAmount = 0;

        for (AggregateResult r : unEarnedChargesList) {
            Decimal amount  = (Decimal)r.get('unbilledCharge');
            Id eqpId    = (Id)r.get('equipId');
            eqpToUnbilledChargesMap.put(eqpId, amount);
            totalQuoteServiceAmount += amount;
        }

        System.debug(LoggingLevel.ERROR, ' totalQuoteServiceAmount: '+totalQuoteServiceAmount);
        System.debug(LoggingLevel.ERROR, ' eqpToUnbilledChargesMap: '+eqpToUnbilledChargesMap);

        // Create Termination Equipment Quotes & Updating the QUote Service & Maintainnce fee updates.
        List<Termination_Equipment_Quote__c> eqpQuoteLines;
        if(quoteHeader != null) {
            eqpQuoteLines = new List<Termination_Equipment_Quote__c>();
            // Looping through QUote Equipments
            for(cllease__Termination_Quote_Equipment__c quoteEqp : quoteHeader.cllease__Termination_Quote_Equipments__r) {
                Decimal prorated = (quoteEqp.cllease__Contract_Equipment__r.cllease__Estimated_Selling_Price__c) / totalEquipmentCost;
                // Looping through Quote Lines
                for(cllease__Termination_Quote_Line__c quoteLine : quoteHeader.cllease__Termination_Quote_Lines__r) {
                    System.debug(LoggingLevel.ERROR, ' processing quote Line '+ quoteLine.cllease__Line_Type__c);
                    // Creating junction object
                    Termination_Equipment_Quote__c termEqpQuote = new Termination_Equipment_Quote__c();
                    termEqpQuote.Termination_Quote__c           = quoteHeader.Id;
                    termEqpQuote.Termination_Quote_Equipment__c = quoteEqp.Id;
                    termEqpQuote.Termination_Quote_Line__c      = quoteLine.Id;
                    // Custom Calculations for Service & Maintainnce Fee (TODO: corrections for 12 months)
                    if(quoteLine.cllease__Line_Type__c == 'QUOTE SERVICE AND MAINTENANCE') {
                        System.debug('Equipment Processing: '+eqpToUnbilledChargesMap.get(quoteEqp.cllease__Contract_Equipment__c));
                        if(eqpToUnbilledChargesMap.get(quoteEqp.cllease__Contract_Equipment__c) != null) {
                            termEqpQuote.Amount__c = (Decimal)eqpToUnbilledChargesMap.get(quoteEqp.cllease__Contract_Equipment__c).setScale(2);
                        }
                    } else {
                        Decimal amountSplit = prorated * quoteLine.cllease__Amount__c;
                        termEqpQuote.Amount__c = (amountSplit).setScale(2);
                    }
                    eqpQuoteLines.add(termEqpQuote);
                }
            }
            
        }

        // 1. If no records available, create new records for Equipments and Quotes and return.
        if(eqpQuoteLines.size() > 0) {
            insert eqpQuoteLines;
            System.debug(LoggingLevel.ERROR, ' Equipment Quote lines created: '+eqpQuoteLines);
        }  
    }

    /**
     *  Following method helps in querying the Termination Details with its child object
     */
    public static List<cllease__Termination_Quote_Header__c> queryTerminationQuoteDetails(String quoteHeaderId) {
        // 1. Retrieving the Quote details with equipment Quote
        List<cllease__Termination_Quote_Header__c> quoteHeaders = [SELECT Id, Name, cllease__Contract__r.Name,
                                                                cllease__Contract__r.cllease__First_Payment_Date__c,
                                                                cllease__Contract__r.cllease__Maturity_Date__c,
                                                                cllease__Contract__r.cllease__Lease_Product_Name__c,
                                                                cllease__Quote_Type__c, cllease__Quote_Reason__c, 
                                                            (SELECT Id, Name,
                                                                cllease__Contract_Equipment__c, 
                                                                cllease__Contract_Equipment__r.cllease__Estimated_Selling_Price__c 
                                                            FROM cllease__Termination_Quote_Equipments__r ),
                                                            (SELECT Id, Name,
                                                                cllease__Amount__c,
                                                                cllease__Line_Type__c,
                                                                cllease__Add_To_Quote_Amount__c,
                                                                cllease__Amount_Type__c
                                                            FROM cllease__Termination_Quote_Lines__r),
                                                            (SELECT Id, Name,
                                                                Amount__c,
                                                                Tax_Exempt__c,
                                                                Termination_Quote_Line__c,
                                                                Termination_Quote_Line__r.cllease__Amount__c,
                                                                Termination_Quote_Line__r.cllease__Line_Type__c,
                                                                Termination_Quote_Line__r.cllease__Add_To_Quote_Amount__c,
                                                                Termination_Quote_Equipment__c,
                                                                Termination_Quote_Equipment__r.cllease__Contract_Equipment__r.Name,
                                                                Termination_Quote_Equipment__r.cllease__Contract_Equipment__r.GARD__c,
                                                                DestinationCity__c,
                                                                DestinationCounty__c,
                                                                DestinationState__c,
                                                                DestinationZipCode__c
                                                            FROM Termination_Equipment_Quotes__r )
                                                        FROM cllease__Termination_Quote_Header__c
                                                        WHERE Id = :quoteHeaderId];
        return quoteHeaders;
    }

    /**
     * Following method helps in retrieving the termination configuration details based on the Quote Type & Quote Reason
     */
    public static cllease__Termination_Config__c getTerminationConfiguration(String quoteType, String quoteReason, string productId) {
        // 
        List<cllease__Termination_Config__c> quoteConfigList = [SELECT Id, Name, cllease__Quote_Reason__c, cllease__Quote_Type__c,
                                                                    (SELECT Id, Name,
                                                                        cllease__Quote_Line__c, 
                                                                        cllease__Bill_Field_API_Name__c, 
                                                                        Consider_for_Vertex_Tax__c, 
                                                                        Do_Passthrough__c,
                                                                        DDL_Quote_Line_Tax_Field_API_Name__c
                                                                    FROM cllease__Termination_Config_Lines__r )
                                                                FROM cllease__Termination_Config__c
                                                                WHERE cllease__Quote_Type__c = :quoteType
                                                                    AND cllease__Quote_Reason__c = :quoteReason
                                                                    AND cllease__Lease_Product__c = :productId];

        return quoteConfigList[0];
    }
}