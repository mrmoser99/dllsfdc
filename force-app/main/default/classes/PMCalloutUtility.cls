/*******************************************************************************************************************
*   PM CALLOUT UTILITY
*
* 
*   Change Log: 
*   5/14/19 - Created
*   5/31/19 - completed upgrade to use callouts
*   6/7/19 - removed the delete of old quotes
*   6/28/19 - added a new service call that does search and get lease details to correct asset error on tearsheet
*   7/11/19 - mrm added customer name to lease olm quote
********************************************************************************************************************/
public with sharing class PMCalloutUtility {

    public class myException extends Exception {}
    
    /********************************************************************************************
    * Search Portfolio
    * 
    ********************************************************************************************/
    public static  PMUtility.ServiceContractData searchPortfolio(String customerName
                                    , String contractNumber
                                    , String assetSerialNumber
                                    , Integer size
                                    , String sortOrder
                                    , Boolean assetDetail
                                    , Integer page
                                    , Boolean disableLogging){
        Boolean jsonError = false;
        
        PMUtility.ServiceContractData myResponse = new PMUtility.ServiceContractData();
        if (disableLogging == null)
            disableLogging = false;

        System.HttpResponse response;
        System.HttpRequest request = new System.HttpRequest();
        
        request.setTimeout(120000);
        
        //assetDetail = false;
        
        String requestParms = 'xxassetDetail=TRUE';
        
        if (assetDetail == false)
            requestParms = 'xxassetDetail=FALSE';
        
        system.debug('contractNumber' + contractNumber);    

        if (customerName != null)
            customerName = customerName.trim();
        if (contractNumber != null)
            contractNumber = contractNumber.trim();
        if (assetSerialNumber != null)
            assetSerialNumber = assetSerialNumber.trim();
        
        sortOrder = sortOrder.trim();

        if (customerName != null && customerName != ''){
            customerName = '*' + customerName + '*';
            customerName = customerName.replace(' ','*');
            requestParms +=  '&customerName=' +  customerName;
        }
        
        if (contractNumber != null && contractNumber != '')
            requestParms +='&contractNumber=' + contractNumber;                   
        

        if (assetSerialNumber != null && assetSerialNumber != '')
            requestParms +='&assetSerialNumber=' + assetSerialNumber;     
        
         
        if (sortOrder !=null && sortOrder != '')
            requestParms += '&sort=' + sortOrder;
        else {
            requestParms += '&sort=' + 'numberOfRemainingPayments,customerName';
        }

        if (page != null)
            requestParms += '&page=' + page;

        if (size != null)
            requestParms += '&size=' + size;

        
        request.setEndpoint(System.Label.PM_Endpoint + '/americas/v1/partnerportfolio' + requestParms);
        request.setHeader('Content-Type', 'application/json'); 
        request.setHeader('Authorization', 'Bearer '+ PMUtility.getAccessToken());
        request.setMethod('GET');
        
        Decimal dt1Long;
        Decimal dt2Long;
        Decimal milliseconds;
        Decimal seconds;
         

        PM_Log__c l = new PM_Log__c();
        try{
            dt1Long = DateTime.now().getTime();
            l.user__c = userInfo.getUserid();
            l.service__c = 'partnerportfolio';
           
            response = new System.Http().send(request); 
            system.debug('response is: ' + response);
            if (response.getStatusCode() == 200 || response.getStatusCode() == 404){ 

                myResponse = (PMUtility.ServiceContractData) System.JSON.deserialize(response.getBody(),PMUtility.ServiceContractData.class);
                system.debug('the response is: ' + myResponse);
                if (myResponse.data == null){
                    l.results__c = 'Success!';
                    myResponse.responseCode = string.valueOf(response.getStatusCode());
                }
                else{
                    for (PMUtility.Data d:myResponse.data){
                        d.newCoReady = 'true';
                        if (d.assetDetail == null){
                            d.nbrOfAssets = 'Excluded';
                        }
                        else{
                            if (d.assetDetail.size() == 1){
                                d.equipmentDescription = d.assetDetail.size() + ' Line of Equipment';
                                d.nbrOfAssets = '1';
                            }
                            else{
                                d.nbrOfAssets = string.valueOf(d.assetDetail.size());
                                d.equipmentDescription = d.assetDetail.size() + ' Lines of Equipment';
                            }
                        }
                        String periodocity = d.contractPeriodicity;
                        d.contractPeriodicity = getContractPeriodicity(periodocity);
                        
                    }
                    l.results__c = 'Success!';
                    myResponse.responseCode = string.valueOf(response.getStatusCode());
                    return myResponse; 
                }
            }     
            else{
                l.results__c = response.getStatusCode() + '-' + response.getBody();
                myResponse.responseCode = string.valueOf(response.getStatusCode());
                return myResponse; 
            } 
        }
        catch (JSONException e){
            system.debug('**************** json exception ******************' + e);
            jsonError = true;
            return PMCalloutUtility.searchPortfolio(customerName
                                    , contractNumber
                                    , assetSerialNumber
                                    , size
                                    , sortOrder
                                    , false
                                    , page
                                    , disableLogging);
        } 
        catch (Exception e){
            l.results__c = string.valueOf(e) + '-' + e.getMessage() + '-' + e.getStackTraceString() + '-' + e.getLineNumber();
            myResponse.responseCode = l.results__c;
            return myResponse; 
        }
        
        finally{
            if (!jsonError) {
                system.debug('Doing finally');
                dt2Long = DateTime.now().getTime();
           

                milliseconds = dt2Long - dt1Long;
                l.seconds__c = milliseconds / 1000;

                if (disableLogging == false) 
                    insert l;
            }
        }        
       
        return myResponse;
    }
    
    
    /************************************************************************************************************************************************************
    *  set the periodicy 
    *************************************************************************************************************************************************************/

    public static String  getContractPeriodicity(String p){

        String response = '';

        if (p == '1')
            response = 'Monthly';
        else
        if (p == '2')
            response = 'Bi-Monthly';
        else 
        if (p == '3')
            response = 'Quarterly';
        else
        if (p == '6')
            response = 'Semi-Annually';
        else
        if (p == '12')
           response = 'Annually';

        return response;

    }
    /************************************************************************************************************************************************************
    *   generateQuotes - message format
    *************************************************************************************************************************************************************/
    public static PMUtility.TerminationQuoteResponse generateQuotes(String leaseNumber){
        /*
        PMUtility.TerminationQuoteResponse qResponse = new PMUtility.TerminationQuoteResponse(); 
        PMUtility.TerminationQuoteResponse qResponse2 = new PMUtility.TerminationQuoteResponse(); 
        
        
        List<Lease_OLM_Quote__c> newQuotes = new List<Lease_OLM_Quote__c>();

        List<PMUtility.Quote> qList = new List<PMUtility.Quote>();
        String accessToken = PMUtility.getAccessToken();
        System.HttpResponse response;
        System.HttpRequest request = new System.HttpRequest();
        
        request.setTimeout(120000);
        request.setEndpoint(System.Label.PM_Endpoint + '/americas/v2/terminationquotexxmessageId=' + 'newco');
        request.setHeader('Content-Type', 'application/json'); 
        request.setHeader('Authorization', 'Bearer '+ accessToken);
        request.setMethod('POST');
        
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        Datetime dt = system.now();
        gen.writeStringField('transmissionDate', dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
        Integer randomNumber = Integer.valueof((Math.random() * 1000000));
        //System.debug('randomNumber is -'+randomNumber);
        gen.writeStringField('partnerOrderId', string.valueOf(randomNumber));
        gen.writeStringField('contractNumber', leaseNumber);
        gen.writeStringField('terminationQuoteType', 'TRADEUP_WITHOUT_PURCHASE');
        
        List<String> sList = new List<String>();
        sList.add('PAST_DUE');

        gen.writeObjectField('quoteCalculationOption', sList);
        gen.writeEndObject();
        List<PM_Log__c> iList = new List<PM_Log__c>();

        request.setBody(gen.getAsString());  
        PM_Log__c l = new PM_Log__c();
        Decimal dt1Long;
        Decimal dt2Long;
        Decimal milliseconds;
        Decimal seconds;
         

        try{
            dt1Long = DateTime.now().getTime();
            l.service__c = 'terminationquote';
            l.user__c = userInfo.getUserid();
            
            response = new System.Http().send(request); 
            
            if (response.getStatusCode() == 200){ 

                qResponse = (PMUtility.TerminationQuoteResponse) System.JSON.deserialize(response.getBody(),PMUtility.TerminationQuoteResponse.class);
                qResponse.quotes[0].quoteNumber =  qResponse.quoteNumber;
                qResponse.quotes[0].quoteCalculationDescription = 'Trade Up w/Equipment Return';
                qResponse.quotes[0].terminationQuoteType = qResponse.quotes[0].quoteCalculationDescription;
                qResponse.quotes[0].quoteValidityDate = qResponse.quoteValidityDate;
                qResponse.quotes[0].quoteMessage = qResponse.quoteMessage;
                qResponse.quoteMessage = null;
                qResponse.quoteNumber = null;
                qResponse.quoteValidityDate = null;
                qResponse.terminationQuoteType = null; 
                qResponse.responseCode = string.valueOf(response.getStatusCode());

                l.results__c = 'Success!';
            }
            else{  
                l.results__c = response.getStatusCode() + '-' + response.getBody();
                qResponse.responseCode = string.valueOf(response.getStatusCode());
                return qResponse;
            }
        }
        catch (Exception e) {
            l.results__c = string.valueOf(e) + '-' + e.getMessage() + '-' + e.getStackTraceString() + '-' + e.getLineNumber();
            qResponse.responseCode = l.results__c;
            return qResponse;
        }  
        finally{
            if (qResponse.quotes != null)
                l.quote__c = qResponse.quotes[0].quoteNumber;
            dt2Long = DateTime.now().getTime();
            milliseconds = dt2Long - dt1Long;
            l.seconds__c = milliseconds / 1000;
             
            iList.add(l);
            if (response != null)
                if (response.getStatusCode() <> 200){
                    insert iList;
                }
       
        }
        
        l = new PM_Log__c();
        try{
            dt1Long = DateTime.now().getTime();
            l.service__c = 'terminationquote';
            l.user__c = userInfo.getUserid();

            System.HttpResponse response2;
            System.HttpRequest request2 = new System.HttpRequest();
            JSONGenerator gen2 = JSON.createGenerator(true);
            gen2.writeStartObject();
            gen2.writeStringField('transmissionDate', dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
            randomNumber = Integer.valueof((Math.random() * 1000000));
            gen2.writeStringField('partnerOrderId', string.valueOf(randomNumber));
            gen2.writeStringField('contractNumber', leaseNumber);
            gen2.writeStringField('terminationQuoteType', 'TRADEUP_WITH_PURCHASE');
            gen2.writeObjectField('quoteCalculationOption', sList);
            gen2.writeEndObject();
            
            request2.setBody(gen2.getAsString()); 
            request2.setTimeout(120000);
            request2.setEndpoint(System.Label.PM_Endpoint + '/americas/v2/terminationquotexxmessageId=' + 'newco');
            request2.setHeader('Content-Type', 'application/json'); 
            request2.setHeader('Authorization', 'Bearer '+ accessToken);
            request2.setMethod('POST');
            response2 = new System.Http().send(request2); 

            if (response2.getStatusCode() == 200){ 
                    system.debug(response2.getStatusCode());

                    qResponse2 = (PMUtility.TerminationQuoteResponse) System.JSON.deserialize(response2.getBody(),PMUtility.TerminationQuoteResponse.class);
                    qResponse2.quotes[0].quoteNumber =  qResponse2.quoteNumber;
                    qResponse2.quotes[0].quoteCalculationDescription = 'Trade Up w/Equipment Purchase';
                    qResponse2.quotes[0].terminationQuoteType = qResponse2.quotes[0].quoteCalculationDescription;
                    qResponse2.quotes[0].quoteValidityDate = qResponse2.quoteValidityDate;
                    qResponse2.quotes[0].quoteMessage = qResponse2.quoteMessage;
                    qResponse2.quoteMessage = null;
                    qResponse2.quoteNumber = null;
                    qResponse2.quoteValidityDate = null;
                    qResponse2.terminationQuoteType = null;
                    qResponse.quotes.add(qResponse2.quotes[0]);
                    l.results__c = 'Success!';
                    qResponse.responseCode = string.valueOf(response2.getStatusCode());
            }
            else{
                l.results__c = response.getStatusCode() + '-' + response.getBody();
                return qResponse;
            }
        }
        catch (Exception e){
            l.results__c = string.valueOf(e) + '-' + e.getMessage() + '-' + e.getStackTraceString() + '-' + e.getLineNumber();
            qResponse.responseCode = l.results__c;
            return qResponse;
        } 
        finally{
            if (qResponse2.quotes != null)
                l.quote__c =  qResponse2.quotes[0].quoteNumber;
            dt2Long = DateTime.now().getTime();
            milliseconds = dt2Long - dt1Long;
            l.seconds__c = milliseconds / 1000;
             
            iList.add(l);

            if (response.getStatusCode() <> 200){
                insert iList;
            }

        }
        
        List< Lease_OLM_Quote__c> lList = new List< Lease_OLM_Quote__c>();
        lList = [select id from  Lease_OLM_Quote__c  where contract_number__c = :leaseNumber];
        
        Lease_OLM_Quote__c lq = new Lease_OLM_Quote__c();
        lq.quote_calculation_description__c = qResponse.quotes[0].quoteCalculationDescription;
        lq.name = qResponse.quotes[0].quoteNumber;
        lq.termination_quote_type__c = qResponse.quotes[0].terminationQuoteType;
        lq.quote_validity_date__c = date.valueOf(qResponse.quotes[0].quoteValidityDate);
        lq.quote_message__c = qResponse.quotes[0].quoteMessage;
        lq.remaining_rental_payments__c = decimal.valueOf(qResponse.quotes[0].remainingRentalPayments);
        lq.discount__c = decimal.valueOf(qResponse.quotes[0].discount);
        lq.equipment_price__c = decimal.valueOf(qResponse.quotes[0].equipmentPrice);
        lq.sales_tax__c = decimal.valueOf(qResponse.quotes[0].salesTax);
        lq.property_tax__c = decimal.valueOf(qResponse.quotes[0].propertyTax);      
        lq.lease_charges__c = decimal.valueOf(qResponse.quotes[0].leaseCharges);
        lq.security_deposit__c = decimal.valueOf(qResponse.quotes[0].securityDeposit);
        lq.amount__c = decimal.valueOf(qResponse.quotes[0].amount);
        lq.contract_number__c =qResponse.contractNumber;
        lq.past_due_service__c = decimal.valueOf(qResponse.quotes[0].pastDueService);
        newQuotes.add(lq);

        lq = new Lease_OLM_Quote__c();
        lq.quote_calculation_description__c = qResponse.quotes[1].quoteCalculationDescription;
        lq.name = qResponse.quotes[1].quoteNumber;
        lq.termination_quote_type__c = qResponse.quotes[1].terminationQuoteType;
        lq.quote_validity_date__c = date.valueOf(qResponse.quotes[1].quoteValidityDate);
        lq.quote_message__c = qResponse.quotes[1].quoteMessage;
        lq.remaining_rental_payments__c = decimal.valueOf(qResponse.quotes[1].remainingRentalPayments);
        lq.discount__c = decimal.valueOf(qResponse.quotes[1].discount);
        lq.equipment_price__c = decimal.valueOf(qResponse.quotes[1].equipmentPrice);
        lq.sales_tax__c = decimal.valueOf(qResponse.quotes[1].salesTax);
        lq.property_tax__c = decimal.valueOf(qResponse.quotes[1].propertyTax);      
        lq.lease_charges__c = decimal.valueOf(qResponse.quotes[1].leaseCharges);
        lq.security_deposit__c = decimal.valueOf(qResponse.quotes[1].securityDeposit);
        lq.amount__c = decimal.valueOf(qResponse.quotes[1].amount);
        lq.contract_number__c =qResponse.contractNumber;
        lq.past_due_service__c = decimal.valueOf(qResponse.quotes[1].pastDueService);
        newQuotes.add(lq);

        insert newQuotes;
       
        insert iList;

        return qResponse;
        */
        return null;
    }

    /************************************************************************************************************************************************************
    *   generateQuotesbyType - message format

        type   'TRADEUP_WITHOUT_PURCHASE'
               'TRADEUP_WITH_PURCHASE'
    *************************************************************************************************************************************************************/
    public static PMUtility.TerminationQuoteResponse generateQuoteByType(String leaseNumber,String type, String customerName){
        

       
         
        PMUtility.TerminationQuoteResponse qResponse = new PMUtility.TerminationQuoteResponse(); 
        
        List<Lease_OLM_Quote__c> newQuotes = new List<Lease_OLM_Quote__c>();

        List<PMUtility.Quote> qList = new List<PMUtility.Quote>();
        String accessToken = PMUtility.getAccessToken();
        if (accessToken == '500') //retry
            accessToken = PMUtility.getAccessToken();
        if (accessToken == '500') //retry
            accessToken = PMUtility.getAccessToken();

        System.HttpResponse response;
        System.HttpRequest request = new System.HttpRequest();
        
        request.setTimeout(120000);
        request.setEndpoint(System.Label.PM_Endpoint + '/americas/v2/terminationquotexxmessageId=' + 'newco');
        request.setHeader('Content-Type', 'application/json'); 
        request.setHeader('Authorization', 'Bearer '+ accessToken);
        request.setMethod('POST');
        
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        Datetime dt = system.now();
        gen.writeStringField('transmissionDate', dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
        Integer randomNumber = Integer.valueof((Math.random() * 1000000));
        
        gen.writeStringField('partnerOrderId', string.valueOf(randomNumber));
        gen.writeStringField('contractNumber', leaseNumber);
        gen.writeStringField('terminationQuoteType', type);
        
        List<String> sList = new List<String>();
        sList.add('PAST_DUE');

        gen.writeObjectField('quoteCalculationOption', sList);
        gen.writeEndObject();
        List<PM_Log__c> iList = new List<PM_Log__c>();

        request.setBody(gen.getAsString());  
        PM_Log__c l = new PM_Log__c();
        Decimal dt1Long;
        Decimal dt2Long;
        Decimal milliseconds;
        Decimal seconds;
         

        try{
            dt1Long = DateTime.now().getTime();
            l.service__c = 'terminationquote' + '-' + type;
            l.user__c = userInfo.getUserid();
            
            response = new System.Http().send(request); 
            
            if (response.getStatusCode() == 200){ 

                qResponse = (PMUtility.TerminationQuoteResponse) System.JSON.deserialize(response.getBody(),PMUtility.TerminationQuoteResponse.class);
                qResponse.quotes[0].quoteNumber =  qResponse.quoteNumber;
                if (type == 'TRADEUP_WITHOUT_PURCHASE')
                    qResponse.quotes[0].quoteCalculationDescription = 'Trade Up w/Equipment Return';
                else
                    qResponse.quotes[0].quoteCalculationDescription = 'Trade Up w/Equipment Purchase';
                qResponse.quotes[0].terminationQuoteType = qResponse.quotes[0].quoteCalculationDescription;
                qResponse.quotes[0].quoteValidityDate = qResponse.quoteValidityDate;
                qResponse.quotes[0].quoteMessage = qResponse.quoteMessage;
                qResponse.quoteMessage = null;
                qResponse.quoteNumber = null;
                qResponse.quoteValidityDate = null;
                qResponse.terminationQuoteType = null; 

                l.results__c = 'Success!';
                qResponse.responseCode = string.valueOf(response.getStatusCode());
            }
            else{  
                l.results__c = response.getStatusCode() + '-' + response.getBody();
                qResponse.responseCode = string.valueOf(response.getStatusCode());
                return qResponse;
            }
        }
        catch (Exception e) {
            l.results__c = string.valueOf(e) + '-' + e.getMessage() + '-' + e.getStackTraceString() + '-' + e.getLineNumber();
            qResponse.responseCode = l.results__c;
            return qResponse;
        }  
        finally{
            if (qResponse.quotes != null)
                l.quote__c = qResponse.quotes[0].quoteNumber;
            dt2Long = DateTime.now().getTime();
            milliseconds = dt2Long - dt1Long;
            l.seconds__c = milliseconds / 1000;

            if (!Test.isRunningTest())
                if (response.getStatusCode() == 400) 
                    l.results__c = 'Success!';

            iList.add(l);
            if (response != null)
                if (response.getStatusCode() <> 200 ){
                    insert iList;
                }
        }
        
        
        //List< Lease_OLM_Quote__c> lList = new List< Lease_OLM_Quote__c>();
        //lList = [select id from  Lease_OLM_Quote__c  where contract_number__c = :leaseNumber];
        
        Lease_OLM_Quote__c lq = PMCalloutUtility.popluateLeaseQuote(qResponse);
       
        lq.customer_name__c = customerName;

        newQuotes.add(lq);

        insert newQuotes; 
      
        insert iList;

        return qResponse;
    }


    /************************************************************************************************************************************************************
    *   populate the lease quote info
    *************************************************************************************************************************************************************/

    public static Lease_OLM_Quote__c popluateLeaseQuote(PMUtility.TerminationQuoteResponse qResponse){
        
        
        Lease_OLM_Quote__c lq = new Lease_OLM_Quote__c();
        
        lq.quote_calculation_description__c = qResponse.quotes[0].quoteCalculationDescription;
        lq.name = qResponse.quotes[0].quoteNumber;
        lq.termination_quote_type__c = qResponse.quotes[0].terminationQuoteType;
        lq.quote_validity_date__c = date.valueOf(qResponse.quotes[0].quoteValidityDate);
        lq.quote_message__c = qResponse.quotes[0].quoteMessage;
        lq.remaining_rental_payments__c = decimal.valueOf(qResponse.quotes[0].remainingRentalPayments);
        lq.discount__c = decimal.valueOf(qResponse.quotes[0].discount);
        lq.equipment_price__c = decimal.valueOf(qResponse.quotes[0].equipmentPrice);
        lq.sales_tax__c = decimal.valueOf(qResponse.quotes[0].salesTax);
        lq.property_tax__c = decimal.valueOf(qResponse.quotes[0].propertyTax);      
        lq.lease_charges__c = decimal.valueOf(qResponse.quotes[0].leaseCharges);
        lq.security_deposit__c = decimal.valueOf(qResponse.quotes[0].securityDeposit);
        lq.amount__c = decimal.valueOf(qResponse.quotes[0].amount);
        lq.contract_number__c =qResponse.contractNumber;
        lq.past_due_service__c = decimal.valueOf(qResponse.quotes[0].pastDueService);
         
        return lq;

    }
        
    /************************************************************************************************************************************************************
    *   getLeaseDetailsFirst - this is for calling tearsheet when a serial number search is used.  it reloads the assest detail first
    *************************************************************************************************************************************************************/

    public static String getLeaseDetailsLeaseFirst(String leaseInfo){
        
        PM_Log__c l = new PM_Log__c();
        Decimal dt1Long;
        Decimal dt2Long;
        Decimal milliseconds;
        Decimal seconds;
        dt1Long = DateTime.now().getTime();
        l.service__c = 'serialnumberspecial';
        l.user__c = userInfo.getUserid();

        PMUtility.Data currentData = (PMUtility.Data) System.JSON.deserialize(leaseInfo,PMUtility.Data.class);

        PMUtility.ServiceContractData res1 =  PMCalloutUtility.searchPortfolio('', currentData.contractNumber,'',1,'', true, 1, true);
     
        String response;
        if (!Test.IsRunningTest())
            response = PMCalloutUtility.getLeaseDetails(JSON.serialize(res1.data[0])); 

        l.lease__c = currentData.contractNumber;
        dt2Long = DateTime.now().getTime();
        milliseconds = dt2Long - dt1Long;
        l.seconds__c = milliseconds / 1000;
        l.results__c = 'Success!';
        insert l;

        return response;


    }
    
   
    /************************************************************************************************************************************************************
    *   getLeaseDetails
    *************************************************************************************************************************************************************/

    public static String getLeaseDetails(String leaseInfo){
        
        PMUtility.Data currentData = (PMUtility.Data) System.JSON.deserialize(leaseInfo,PMUtility.Data.class);
        List<PM_Log__c> iList = new List<PM_Log__c>();

        System.HttpResponse response;
        System.HttpRequest request = new System.HttpRequest();
        String accessToken = PMUtility.getAccessToken();
        if (accessToken == '500') //retry
            accessToken = PMUtility.getAccessToken();
        if (accessToken == '500') //retry
            accessToken = PMUtility.getAccessToken();

        request.setTimeout(120000);
        request.setEndpoint(System.Label.PM_Endpoint + '/americas/v1/contractdetail');
        request.setHeader('Content-Type', 'application/json'); 
        request.setHeader('Authorization', 'Bearer '+ accessToken);
        if (Test.isRunningTest())
            currentData.contractNumber = '12345678';

        request.setHeader('dllContractNumber', currentData.contractNumber);
        request.setMethod('GET');
        
        PMUtility.contractDetail contractDetail;
        PM_Log__c l = new PM_Log__c();
        Decimal dt1Long;
        Decimal dt2Long;
        Decimal milliseconds;
        Decimal seconds;

        try{ 
            dt1Long = DateTime.now().getTime();
            l.service__c = 'contractdetail';
            l.user__c = userInfo.getUserid();

            response = new System.Http().send(request); 
            
            if (response.getStatusCode() == 200){ 
                contractDetail = (PMUtility.contractDetail) System.JSON.deserialize(response.getBody(),PMUtility.ContractDetail.class);
                l.results__c = 'Success!';
                currentData.responseCode = string.valueOf(response.getStatusCode());
            }
            else{
                l.results__c = response.getStatusCode() + '-' + response.getBody();
               
                return JSON.serialize(currentData);   
            }
        }
        catch (Exception e){
             l.results__c = string.valueOf(e) + '-' + e.getMessage() + '-' + e.getStackTraceString() + '-' + e.getLineNumber();
             currentData.responseCode = l.results__c;
             return JSON.serialize(currentData); 
        }
        finally{
            l.lease__c = currentData.contractNumber;
            dt2Long = DateTime.now().getTime();
            milliseconds = dt2Long - dt1Long;
            l.seconds__c = milliseconds / 1000;
             
            iList.add(l);
            if (response != null)
                if (response.getStatusCode() <> 200){
                    insert iList;
                }

        }

        /* add extra gathered data to currentdata */
        currentData.Cust_Legal_Name = contractDetail.customerLegalName;
        currentData.customerAccount = contractDetail.customerAccount;


        //find assets[i].serialNumber in data
        //then update
        system.debug('contract detail is: ' + contractDetail); 
        for (Integer i=0;i < contractDetail.assets.size(); i++){
           
            Boolean found = false;
            
            for (Integer j=0;j < currentData.assetDetail.size();j++){
               
                if (currentData.assetDetail[j].assetSerialNumber == contractDetail.assets[i].serialNumber){
                    found = true;
                    currentData.assetDetail[j].Billing_City = contractDetail.assets[i].billingCity;
                    currentData.assetDetail[j].Billing_Location = contractDetail.assets[i].billingLocation;
                    currentData.assetDetail[j].Billing_State = contractDetail.assets[i].billingState;
                    currentData.assetDetail[j].Billing_Zip = contractDetail.assets[i].billingPostalCode;

                    currentData.assetDetail[j].Install_City = contractDetail.assets[i].installCity;
                    currentData.assetDetail[j].Install_Location = contractDetail.assets[i].installLocation;
                    currentData.assetDetail[j].Install_State = contractDetail.assets[i].installState;
                    currentData.assetDetail[j].Install_Zip = contractDetail.assets[i].installPostalCode;

                     
                    currentData.assetDetail[j].Install_County = contractDetail.assets[i].installCounty;
                    if (contractDetail.assets[i].installDate != null){
                        List<String> sList = new List<String>();
                        sList = contractDetail.assets[i].installDate.split('T');
                        currentData.assetDetail[j].Install_Date = slist[0];
                    }
                    else
                        currentData.assetDetail[j].Install_Date = contractDetail.assets[i].installDate;

                }
            }

            
        } 

        System.HttpResponse response2;
        System.HttpRequest request2 = new System.HttpRequest();
        
        request2.setTimeout(120000);
        request2.setEndpoint(System.Label.PM_Endpoint + '/americas/v1/contractsummary');
        request2.setHeader('Content-Type', 'application/json'); 
        request2.setHeader('Authorization', 'Bearer '+ accessToken);
        request2.setHeader('dllContractNumber', currentData.contractNumber);
        request2.setMethod('GET');
        l = new PM_Log__c();

        try{
            dt1Long = DateTime.now().getTime();
            l.service__c = 'contractsummary';
            l.user__c = userInfo.getUserid();

            response2 = new System.Http().send(request2); 
        
            if (response2.getStatusCode() == 200){ 

                PMUtility.contractSummary contractSummary = (PMUtility.contractSummary) System.JSON.deserialize(response2.getBody(),PMUtility.ContractSummary.class);
     
                

                currentData  = addContractSummary(currentData,contractSummary);
               

                 l.results__c = 'Success!';
                 currentData.responseCode = string.valueOf(response2.getStatusCode());

            }
            else{
                l.results__c = response.getStatusCode() + '-' + response.getBody();
                currentData.responseCode = string.valueOf(response2.getStatusCode());
                
                return JSON.serialize(currentData);   
            }
        }
        catch (Exception e){
            l.results__c = string.valueOf(e) + '-' + e.getMessage() + '-' + e.getStackTraceString() + '-' + e.getLineNumber();
            currentData.responseCode = l.results__c;
            return JSON.serialize(currentData); 
        }
        finally{
            l.lease__c = currentData.contractNumber;
            dt2Long = DateTime.now().getTime();
            milliseconds = dt2Long - dt1Long;
            l.seconds__c = milliseconds / 1000;
             
            iList.add(l);
            if (response.getStatusCode() <> 200){
                insert iList;
            }

        }

        insert iList;
        system.debug(currentData);
        system.debug(JSON.serialize(currentData));
        return JSON.serialize(currentData); 

    }

    /************************************************************************************************************************************************************
    *   getLeaseDetails from newco data instead of junko portofolio system 
    *************************************************************************************************************************************************************/
    @AuraEnabled
    public static String getLeaseDetailsNewco(String leaseNumber){
    
        PMUtility.Data data = new PMUtility.Data();
        
        cllease__Lease_Account__c l = [Select cllease__Account__r.primary_address__r.Address_Line_1__c, cllease__Account__r.primary_address__r.Address_Line_2__c, cllease__Account__r.primary_address__r.Address_Line_3__c, cllease__Account__r.primary_address__r.Address_Line_4__c, cllease__Account__r.primary_address__r.city__c,cllease__Account__r.primary_address__r.state__c,  cllease__Account__r.primary_address__r.zip_code__c, cllease__Account__r.phone , Account_Number__c, Dealer_Program__r.name, equipment_count__c, cllease__Account__r.name, cllease__Account__r.account_number__c,Account_Salesperson__c, Additional_Residual_Amount__c, Allowable_Soft_Cost__c, Application_Number__c, Application__c, Applied_Amount_Conga__c, AutoCaluclate_Finance_Charge_Grace_Days__c, AutoCaluclate_Late_Charge_Grace_Days__c, Bill_Not_Paid_Estimated_Property_Tax__c, Bill_Not_Paid_Insurance_Fees__c, Bill_Not_Paid_Late_Fees__c, Bill_Not_Paid_Origination_Fees__c, Bill_Not_Paid_Rent__c, Bill_Not_Paid_Service_Pass_Through__c, Bill_Residual_Amount__c, Bill_To_Contact_Id__c, Bill_not_Paid_Finance_Fees__c, Billed_Not_Paid__c, Billed_Rent_Only_Not_Paid__c, Billed_Tax_Only_Not_Paid__c, Billing_Address_Line_1__c, Billing_Address_Line_2__c, Billing_Address__c, Billing_Email__c, Bokg_Yr_Mo__c, Booked_Residual__c, Booking_Date__c, Business_Unit_Name__c, Buyout_With_Purchase__c, Buyout_Without_Purchase__c, CTA_Booked_Date__c, Charges_Estimated_Property_Tax_Paid__c, City__c, Contract_Signer_Last_Name__c, Contract_Signer_Title__c, Contract_Signer__c, Cost_of_Funds__c, Country__c, County__c, Cr_Apl_Tp_Code__c, CreatedById, CreatedDate, Current_BranchSystemDate__c, Custom_Finance_Charge_Grace_Days__c, Custom_Late_Charge_Grace_Days__c, Customer_City__c, Customer_Number__c, Customer_Primary_Contact__c, Customer_Primary_Phone__c, Customer_State__c, Customer_Zip_Code__c, Customer__c, DLL_Reference_Number__c, Dealer_Approved_Date__c, Dealer_Email__c, Dealer_Name__c, Dealer_Oracle_Vendor_Id__c, Dealer_Party__c, Dealer_Program__c, Dealer_State__c, Default_State__c, Due_This_Period_Conga__c, EIN__c, Ending_Net_Investment_Last_Month__c, Equipment_Exempt_Count__c, Estimated_Property_Tax1__c, Estimated_Property_Tax__c, Evergreen_Eligibility__c, Exposure_Estimated_Property_Tax__c, Exposure__c, Fee_Schedule_Estimated_Property_Tax__c, Final_Letter_Sent__c, Final_Notice_Letter_Send__c, Final_Notice_Letter_Sent__c, Final_Notice_Letter__c, Hyp_Based_Ent__c, Id, InsuranceNotification_Sent__c, Insurance_Effective_date__c, Insurance_Fees1__c, Insurance_Fees__c, Interim_Rent__c, IsDeleted, KYC_Cleared__c, LastActivityDate, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Lease_Number__c, Lease_Type__c, Lessee_Company__c, NPA_Amount__c, NPA_Booking_Transaction_Amount__c, NPBA_Amount_Calculated_Date_Time__c, NPBA_Amount_Calculated__c, NPBA_Amount_Temp__c, NPBA_Amount__c, Name, Net_Dealer_Funding__c, Net_Trade_Up_Amount__c, New_Welcome_Packet__c, Next_Insurance_Fee__c, Number_of_Days_TO_Mature__c, Operating_Lease__c, Oracle_Trade_Up_Quote_Amount__c, Oracle_Trade_up_Lease_Number__c, Oracle_Trade_up_Quote_Expiration_Date__c, Oracle_Trade_up_Quote_Number__c, OwnerId, PO_Number__c, Payment_Amount_Conga__c, Payment_Stream__c, Primary_Customer_Address_2__c, Primary_Customer_Address__c, Prom_Code__c, Purchase_Option__c, Quote_Discount_Roll_over__c, Quote_Discount__c, RecordTypeId, Remaining_Amount_Due_Conga__c, Remaining_Payments1__c, Remaining_Payments__c, Rent_Amount__c, Rst_Residual__c, Rst_Total_Income__c, Rst_Total_Receivable__c, Rst_Total_Residual_Income__c, ST_Derived_Product_Name__c, ST_Lessee_Accounting_Method__c, ST_Lessor_Accounting_Method__c, ST_Tax_Classification__c, Sales_Rep_Name__c, Server_Url__c, Service_Fees1__c, Service_Fees__c, SessionId__c, Source_System__c, State__c, Sum_of_Equipment_Dealer_Charges__c, SystemModstamp, System_date__c, Tax_Conga__c, Termination_Date__c, Test_Welcome_Packet__c, Todaydate__c, Total_Amount_Conga__c, Total_Monthly_Payment__c, Trade_Up_Amount__c, Trade_Up_From__c, Trade_up_With_Purchase__c, Trade_up_Without_Purchase__c, Transaction_Code__c, Trigger_New_Packet_Workflow__c, Unbilled_Estimated_Property_Tax__c, Unbilled_Receivable__c, Unbilled_Rent__c, Unbilled_Service_and_Maintenance__c, Vertex_Tax_Amount__c, Welcome_Package_Requested__c, Welcome_Packet__c, Zero_Value__c, Zip_Code__c, cllease__ACH_Account_Number__c, cllease__ACH_Account_Type__c, cllease__ACH_Active__c, cllease__ACH_Bank_Name__c, cllease__ACH_Bank__c, cllease__ACH_Debit_Amount__c, cllease__ACH_Drawer_Name__c, cllease__ACH_End_Date__c, cllease__ACH_Frequency__c, cllease__ACH_Next_Debit_Date__c, cllease__ACH_Relationship_Type__c, cllease__ACH_Routing_Number__c, cllease__ACH_Start_Date__c, cllease__Account__c, cllease__Accrual_Streams__c, cllease__Accrue_Fee__c, cllease__Accrue_Lease_Income__c, cllease__Ach_Debit_Day__c, cllease__Active_flag__c, cllease__Address__c, cllease__Advance_Payments__c, cllease__Aging_History__c, cllease__Aging__c, cllease__Amort_Finance_Amount__c, cllease__Amort_Start_Date__c, cllease__Amortized_Yield__c, cllease__Amount_Due_at_Signing__c, cllease__Amount_to_Current__c, cllease__Application_Date__c, cllease__Approval_Date__c, cllease__Auto_Termination__c, cllease__Average_Monthly_Income__c, cllease__Balloon_Payment__c, cllease__Bill_Group__c, cllease__Bill_Rent__c, cllease__Billing_Group__c, cllease__Borrower_ACH__c, cllease__Branch__c, cllease__CL_Product__c, cllease__Calculation_Method__c, cllease__Cap_Reduction__c, cllease__Cash_Collected_By_Dealer__c, cllease__Charged_Off_Date__c, cllease__City_Surcharge_Amount__c, cllease__City_Tax_Amount__c, cllease__City_Tax_Rate__c, cllease__Closed_Date__c, cllease__Commencement_Date__c, cllease__Commission_Amount__c, cllease__Consider_Prebill_For_Evergreen__c, cllease__Consolidate_Invoice__c, cllease__Contact__c, cllease__Contract_Date__c, cllease__Contract_Restructured__c, cllease__County_Surcharge_Amount__c, cllease__County_Tax_Amount__c, cllease__County_Tax_Rate__c, cllease__Currency_Code__c, cllease__Current_Due_Day__c, cllease__Current_Evergreen_Term__c, cllease__Current_Payment_Amount__c, cllease__Current_Term_Rental_Payment__c, cllease__Current_Term_Surcharge_On_Stream__c, cllease__Current_Term_Tax_On_Stream__c, cllease__Current_Term_Total_Payment__c, cllease__Current_Term__c, cllease__Current_Yield__c, cllease__Days_Convention__c, cllease__Days_Past_Due__c, cllease__Dealer_Fees__c, cllease__Dealer_Funded__c, cllease__Dealer_Payment_Date__c, cllease__Dealer__c, cllease__Delinquency_Grace_Days__c, cllease__Delinquency_flag__c, cllease__Delinquent_Amount__c, cllease__Delivery_and_Acceptance_Date__c, cllease__Depreciate_Over_Asset_Life__c, cllease__Depreciation_Calculation_Basis__c, cllease__Depreciation_Expense_Flag__c, cllease__Depreciation_Method__c, cllease__Disbursement_File_To_Be_Generated__c, cllease__Documentation_Fees_Amount__c, cllease__Down_Payment__c, cllease__Due_Day__c, cllease__Early_Pre_Payment_Penalty_Indicator__c, cllease__Early_Termination_Fees__c, cllease__Effective_Date__c, cllease__Effective_End_Date__c, cllease__Effective_Term__c, cllease__Equipment_Cost__c, cllease__Equipment_Return_Fee__c, cllease__Equipment_Selling_Price__c, cllease__Equipment_returned_flag__c, cllease__Estimated_Selling_Price__c, cllease__Evergreen_Count__c, cllease__Evergreen_Current_Payment_Amount__c, cllease__Evergreen_Depreciation_Amount__c, cllease__Evergreen_Depreciation_Basis__c, cllease__Evergreen_Depreciation_Term__c, cllease__Evergreen_Due_Day__c, cllease__Evergreen_End_Date__c, cllease__Evergreen_Flag__c, cllease__Evergreen_Frequency__c, cllease__Evergreen_Last_Due_Date__c, cllease__Evergreen_Next_Due_Date__c, cllease__Evergreen_Next_Due_Generation_Date__c, cllease__Evergreen_Start_Date__c, cllease__Evergreen_Term__c, cllease__Excess__c, cllease__Fee_Set1__c, cllease__Fee_Set__c, cllease__Fees_Amount__c, cllease__Financed_Amount__c, cllease__First_Payment_Amount__c, cllease__First_Payment_Date__c, cllease__Fund_Date__c, cllease__GPS_Removal_Fee__c, cllease__Generating_Streams__c, cllease__Grace_Period_for_Repayments__c, cllease__Has_Asset_Level_Rent__c, cllease__Has_Changed__c, cllease__History_Tracking_Id__c, cllease__If_Other_Describe__c, cllease__Income_Accrual_Flag__c, cllease__Income_Accrual_Frequency__c, cllease__Initial_Direct_Cost_Amount1__c, cllease__Initial_Direct_Cost_Amount__c, cllease__Initial_Direct_Cost__c, cllease__Initial_Streams_Generated__c, cllease__Install_Date__c, cllease__Installation_Flag__c, cllease__Invalid_Data__c, cllease__Is_Rescheduled_For_Fee__c, cllease__Is_Rescheduled__c, cllease__Last_Current_To_NPA_Date__c, cllease__Last_Due_Date__c, cllease__Last_Due_Generation_Date__c, cllease__Last_Income_Accrual_Date__c, cllease__Last_NPA_To_Current_Date__c, cllease__Last_Payment_Amount__c, cllease__Last_Payment_Date__c, cllease__Last_Transaction_Timestamp__c, cllease__Last_Transaction_Type__c, cllease__Lease_Account_External_Id__c, cllease__Lease_Product_Name__c, cllease__Lease_Receivable_Amount__c, cllease__Lease_Status__c, cllease__Manually_Override_NPA_Status__c, cllease__Matured_flag__c, cllease__Maturity_Date_Current__c, cllease__Maturity_Date__c, cllease__Metro2_First_Delinquency_Date__c, cllease__Metro2_Payment_History__c, cllease__Metro2_Payment_Rating__c, cllease__Metro2_Portfolio_Type__c, cllease__Migration_Date__c, cllease__NPA_Status__c, cllease__Net_Balance_Amount__c, cllease__Net_Fee_Balance__c, cllease__Next_Commission_Payment_Date__c, cllease__Next_Due_Date__c, cllease__Next_Due_Generation_Date__c, cllease__Next_Income_Accrual_Date__c, cllease__Number_of_Pieces_of_Equipment__c, cllease__OT_ACH_Account_Number__c, cllease__OT_ACH_Account_Type__c, cllease__OT_ACH_Bank_Name__c, cllease__OT_ACH_Debit_Date__c, cllease__OT_ACH_Drawer_Address1__c, cllease__OT_ACH_Drawer_Address2__c, cllease__OT_ACH_Drawer_City__c, cllease__OT_ACH_Drawer_Name__c, cllease__OT_ACH_Drawer_State__c, cllease__OT_ACH_Drawer_Zip__c, cllease__OT_ACH_Fee_Amount__c, cllease__OT_ACH_Payment_Amount__c, cllease__OT_ACH_Relationship_Type__c, cllease__OT_ACH_Routing_Number__c, cllease__Oldest_Due_Date__c, cllease__Origin_Source__c, cllease__Other_Financed_Fees__c, cllease__Overdue_Amount_As_Of_Today__c, cllease__Override_Tax_Flag__c, cllease__Override_Tax_Rate__c, cllease__Override_VAT_Rate__c, cllease__PV_Rate__c, cllease__Payable_To_Dealer__c, cllease__Payment_Amount__c, cllease__Payment_Frequency__c, cllease__Payment_Method__c, cllease__Payment_Spread__c
            , cllease__Payment_Tolerance_End_Date__c, cllease__Payment_Tolerance_Rate__c, cllease__Payment_Tolerance_Start_Date__c, cllease__Payment_in_Arrears__c, cllease__Payoff_Fee_Indicator__c, cllease__Periodic_Fee__c, cllease__Periodic_Payment_Starts__c, cllease__Pre_Bill_Days__c, cllease__Prefund_Date__c, cllease__Prepayment_Method__c, cllease__Prepayment_Penalty_Indicator__c, cllease__Prepayment_Penalty_Periods__c, cllease__Prepayment_Value__c, cllease__Present_Value__c, cllease__Private_Label__c, cllease__Process_Fee__c, cllease__Product_Sub_Type__c, cllease__Product_Type__c, cllease__Referral_Category__c, cllease__Referral_Fee_Amount__c, cllease__Referral_Fee_Paid_On_Amount__c, cllease__Referral_Fee_Points_ReadOnly__c, cllease__Referral_Fee_Points__c, cllease__Referral_Fee__c, cllease__Referral_Payee__c, cllease__Rent_Maturity_Date__c, cllease__Rental_Accrual_Flag__c, cllease__Repayment_Billing_Method__c, cllease__Repayment_Procedure__c, cllease__Repayment_Term_Payment_Percent__c, cllease__Residual_Amount__c, cllease__Residual_Billed_At_Maturity__c, cllease__Residual_Owner__c, cllease__Residual_Type__c, cllease__Restructure_Date__c, cllease__Restructure_Reason__c, cllease__Restructured_Contract__c, cllease__Sales_Division__c, cllease__Sales_Rep__c, cllease__Secondary_Term__c, cllease__Security_Deposit_Amount__c, cllease__Set_Restructure_Yield__c, cllease__Skip_Child_Equip_Import__c, cllease__State_Surcharge_Amount__c, cllease__State_Tax_Amount__c, cllease__State_Tax_Rate__c, cllease__Status_Order__c, cllease__Stream_Generation_Required__c, cllease__Subsidized_Yield__c, cllease__Subsidy1__c, cllease__Subsidy__c, cllease__Subvention_Stream_Basis__c, cllease__Subvention__c, cllease__Tax_Amount__c, cllease__Tax_Exempt__c, cllease__Tax_Treatment__c, cllease__Tax_Upfront__c, cllease__Term_Residual_Frequency__c, cllease__Term_Residual_Months__c, cllease__Term__c, cllease__Termination_Discount_Rate__c, cllease__Termination_Quote_accepted_flag__c, cllease__Title_Transfer_Fee__c, cllease__Total_Amount_Paid__c, cllease__Total_Charges_Due__c, cllease__Total_Dealer_Charges__c, cllease__Total_Surcharge_Amount__c, cllease__Total_Tax_Amount__c, cllease__Total_Tax_Rate_Derived__c, cllease__Total_Tax_Rate__c, cllease__Upfront_Rental_Amount__c, cllease__Upfront_Tax_Basis__c, cllease__Upfront_Tax_Flag__c, cllease__Warranty_Amount__c, cllease__Who_remitted_Upfront_Tax__c, cllease__Write_off_Tolerance_Amount__c, cllease__Yield_Based_Payment__c, cllease__Yield__c, cllease__application_number__c, cllease__batch_job_completed__c, cllease__enable_calculation_setup_logs__c, cllease__generated_Streams_for_Restructure__c, cllease__isMigrated__c, cllease__needStreamRegenerated__c, cllease__sample__c, cllease__temp_payment__c 
            FROM cllease__Lease_Account__c 
            where name = :leaseNumber
        ];

        List<cllease__Contract_Equipment__c> eList = [Select Additional_Residual_Amount__c, Asset_ID__c, Asset_Type_ID__c, Asset_Type_Name__c, Balance_Net_Trade_Up_Amount__c, Bill_Residual_Amount__c, Business_Unit__c, City_InstallAddress__c, Cost_Center__c, Country_InstallAddress__c, County_InstallAddress__c, CreatedById, CreatedDate, Dealer_Charges__c, Department_Name__c, Eligible_for_property_tax__c, Equipment_Description1__c, Evergreen_Depreciable_Cost__c, Evergreen_Depreciable_Life__c, External_Id__c, GARD__c, Id, Install_Account__c, Install_Address_Line_1__c, Install_Address_Line_2__c, Install_Address__c, Install_Date__c, Invoice_Date__c, Invoice_Number__c, IsDeleted, LastModifiedById, LastModifiedDate, Last_Residual_Burndown_Date__c, Lessee_Code__c, Lessee_Company__c, Manufacturer__c, Master_Asset_Type_ID__c, Master_Asset_Type__c, NBV__c, NPA_Amount__c, NPBA_Amount__c, Name, Net_Trade_Up_Amount__c, Object_Category_ID__c, Object_Category_Name__c, Oracle_Trade_Up_Amount__c, Owner_Class__c, Prior_Owner_Class__c, Product_Type__c, Remaining_Evergreen_Depreciable_Cost__c, Rent_Amount__c, Residual_Percentage__c, Salvage_Value__c, Serial_Number__c, State_Code__c, State__c, SystemModstamp, Termination_Date__c, Total_Equipment_Cost__c, Zip_Code_InstallAddress__c, cllease__Account__c, cllease__Asset_Split_Equipment__c, cllease__Bill_Group__c, cllease__Billing_Group__c, cllease__City_Surcharge__c, cllease__City_Tax_Rate__c, cllease__City__c, cllease__Contract__c, cllease__Country__c, cllease__County_Surcharge__c, cllease__County_Tax_Rate__c, cllease__County__c, cllease__Created_Through_Contract__c, cllease__Dealer_Contact_Email__c, cllease__Dealer_Contact_Name__c, cllease__Dealer_Fees__c, cllease__Dealer_Funded__c, cllease__Dealer_Name__c, cllease__Dealer_Party__c, cllease__Dealer_Phone_Number__c, cllease__Depreciation_Basis__c, cllease__Equipment_Book_Value__c, cllease__Equipment_Calculated_Cost__c, cllease__Equipment_Cost__c, cllease__Equipment_Description__c, cllease__Equipment_External_Id__c, cllease__Equipment_Id__c, cllease__Equipment_Net_Book_Value__c, cllease__Equipment_Serial_Number__c, cllease__Equipment_Type__c, cllease__Estimated_Selling_Price__c, cllease__Evergreen_Depreciation_Amount__c, cllease__External_Id__c, cllease__Flag_To_Delete__c, cllease__Generate_Book_Depreciation__c, cllease__History_Tracking_Id__c, cllease__Item_Code__c, cllease__LeaseApplicationNumber__c, cllease__LeaseApplication__c, cllease__Make__c, cllease__Model__c, cllease__NBV_On_Restructure_Date__c, cllease__New_Invoice_Price__c, cllease__New_Rent__c, cllease__Next_Variable_Rent_Due_Date__c, cllease__Original_Equipment_Id__c, cllease__Other_Financed_Fees__c, cllease__Override_Tax_Flag__c, cllease__Override_Tax_Rate__c, cllease__Override_VAT_Code__c, cllease__Quantity__c, cllease__Rent__c, cllease__Residual_Amount__c, cllease__Select_Equipment__c, cllease__State_Province__c, cllease__State_Surcharge__c, cllease__State_Tax_Rate__c, cllease__Status__c, cllease__Street_Address__c, cllease__Subsidy__c, cllease__Subvention__c, cllease__Tax_Amount__c, cllease__Tax_Code__c, cllease__Tax_Depreciation_Method__c, cllease__Tax_Depreciation__c, cllease__Tax_Residual_Value__c, cllease__Tax_exemption__c, cllease__Total_Dealer_Charges__c, cllease__Total_Tax_Amount__c, cllease__Total_Tax_Rate_Derived__c, cllease__Total_Tax_Rate__c, cllease__Upfront_Tax_Basis__c, cllease__Upfront_Tax_Flag__c, cllease__VIN__c, cllease__Variable_Rent_Frequency__c, cllease__Variable_Rent_Start_Date__c, cllease__Warehouse_Equipment__c, cllease__Warranty_Amount__c, cllease__Year__c, cllease__Zip_Code__c, cllease__life_in_months__c, cllease__return_status__c, cllease__status1__c, cllease__tax_financed__c 
        FROM cllease__Contract_Equipment__c where cllease__Contract__c = :l.id];

        data.responseCode = 'OK' ;
        data.contractNumber = l.name;
        data.contractType = 'STD';
        data.contractTerm = string.valueOf(l.cllease__Term__c);
        data.contractPeriodicity = l.cllease__Payment_Frequency__c;
        data.contractPurchaseOption = l.Purchase_Option__c;
        data.contractProgramId = ' xx ' ;
        data.contractProgramName = l.Dealer_Program__r.name;
        data.contractStartDate = string.valueOf(l.cllease__Commencement_Date__c);
        data.contractExpireDate = string.valueOf(l.cllease__Maturity_Date__c);
        data.contractOriginalCost = string.valueOf(l.cllease__Financed_Amount__c);
        data.contractPayment = string.valueOf(l.cllease__Current_Payment_Amount__c);
        data.contractAverageDaysToPay = ' xx ' ;
        data.contractSigner =  l.Contract_Signer__c + ' ' + l.Contract_Signer_last_name__c;
        data.contractSignerTitle = l.Contract_Signer_Title__c;
        data.contractService = string.valueOf(l.Service_Fees__c);
        data.daysPastDue = string.valueOf(l.cllease__Days_Past_Due__c);
        data.equipmentDescription = ' xx ' ;  //fill with nbr of pieces of equipment
        data.nbrOfAssets = string.valueOf(l.Equipment_Count__c);
        data.leaseSignerTitle = l.Contract_Signer_Title__c;
        data.numberOfRemainingPayments = string.valueOf(l.Unbilled_Rent__c);
        data.lastPaymentReceivedDate = string.valueOf(l.cllease__Last_Payment_Date__c);
        data.businessSegment = null;
        data.subBusinessSegment = null;
        data.customerName = l.cllease__Account__r.name;
        data.olmCustomerNumber = l.cllease__Account__r.account_number__c;
        data.customerNumber = l.cllease__Account__r.account_number__c;
        data.customerAccount = l.cllease__Account__r.account_number__c;
        data.customerPhoneNumber = l.cllease__Account__r.phone;
        data.customerAddressLine1 = l.cllease__Account__r.primary_address__r.Address_Line_1__c; 
        data.customerAddressline2 = l.cllease__Account__r.primary_address__r.Address_Line_2__c;
        data.customerCity = l.cllease__Account__r.primary_address__r.City__c ;
        data.customerState = l.cllease__Account__r.primary_address__r.state__c;
        data.customerZipCode =  l.cllease__Account__r.primary_address__r.zip_code__c;
        
        data.billingAddressLine1 = l.cllease__Account__r.primary_address__r.Address_Line_1__c; 
        data.billingAddresslilne2 =l.cllease__Account__r.primary_address__r.Address_Line_2__c;
        data.billingCity = l.cllease__Account__r.primary_address__r.City__c ;
        data.billingState = l.cllease__Account__r.primary_address__r.state__c;
        data.billingZipCode = l.cllease__Account__r.primary_address__r.zip_code__c;
        data.vendorSiteCode = l.Dealer_Oracle_Vendor_Id__c; 
        data.vendorNumber1 = ' xx ' ;
        data.vendorNumber2 = ' xx ' ;
        data.vendorNumber3 = ' xx ' ;
        data.vendorName = l.Dealer_Name__c;
        data.vendorAddressLine1 = ' xx ' ;
        data.vendorAddressLine2 = ' xx ' ;
        data.vendorCity = ' xx ' ;
        data.vendorState = ' xx ' ;
        data.vendorZipCode = ' xx ' ;
        data.newcoReady = ' xx ' ;
        
        data.Arrears = l.cllease__Payment_Method__c;
        data.Assignable_Yn = 'N' ;
        data.Bank_Account_Num = ' xx ' ;
        data.Billing_Group_Id = ' xx ' ;
        data.Billing_Group_Name = ' xx ' ;
        data.Billing_Group_Number = ' xx ' ;
        data.Code_Sales_Rep = l.Account_Salesperson__c;
        data.Contract_Number = l.name;
        data.Contract_Status = l.cllease__Lease_Status__c;
        data.Contract_Application_Number = ' xx ' ;
        data.x_Currency = 'USD' ;
        data.Cust_Address = l.cllease__Account__r.primary_address__r.address_line_1__c;
        data.Cust_City = l.cllease__Account__r.primary_address__r.City__c ;
        data.Cust_Country = ' xx ' ;
        data.Cust_County = ' xx ' ;
        data.Cust_First_Name = ' xx ' ;
        data.Cust_Last_Name = ' xx ' ;
        data.Cust_Legal_Name = l.cllease__account__r.name;
        data.Cust_Middle_Name = ' xx ' ;
        data.Cust_Postal_Code =  l.cllease__Account__r.primary_address__r.zip_code__c ;
        data.Cust_State =  l.cllease__Account__r.primary_address__r.state__c ;
        data.Cust_Title = ' xx ' ;
        data.Customer_Id = l.cllease__account__r.account_number__c;
        data.Customer_Name = l.cllease__account__r.name;
        data.Customer_Number = ' xx ' ;
        data.Description = ' xx ' ;
        data.Discount_Rate = ' xx ' ;
        data.Effective_Date = ' xx ' ;
        data.Email_Address = ' xx ' ;
        data.End_Date = ' xx ' ;
        data.External_Contract_Number = ' xx ' ;
        data.Implicit_Rate = ' xx ' ; //rate factor from applicaiton...todo
        data.Lp_Program = ' xx ' ;
        data.Maximum_Due_Date = ' xx ' ;
        data.Number_Unbilled_Streams = string.valueOf(l.Unbilled_Rent__c);
        data.Olm_Program = ' xx ' ;
        data.Op_Unit = ' xx ' ;
        data.Party_Id = ' xx ' ;  
        data.Passive_Rate = ' xx ' ;
        data.Payment_Method = ' xx ' ; //sample auto ach - payment mode
        data.Periodicity = l.cllease__Payment_Frequency__c;
        data.Print_Lead_Days = string.valueOf(l.cllease__Pre_Bill_Days__c);
        data.Product = l.Dealer_Program__r.name;
        data.Reference_Lessee = ' xx ' ;
        data.Remaining_Pymnts =  string.valueOf(l.Unbilled_Rent__c);
        data.Sb_Unit = ' xx ' ;
        data.Start_Date =  string.valueOf(l.cllease__Commencement_Date__c);
        data.Syndicated_Flag = ' xx ' ;
        data.Term =  string.valueOf(l.cllease__Term__c);
        data.Termination_Date = string.valueOf(l.Termination_Date__c);
        data.Total_Fin_Amnt = string.valueOf(l.cllease__Financed_Amount__c);
        
        data.Financialproduct = l.cllease__Lease_Product_Name__c;
        data.Purchaseoption = l.Purchase_Option__c;
        data.Numberofassets = string.valueOf(l.Equipment_Count__c);
        data.Statetax = ' xx ' ;
        data.Countytax = ' xx ' ;
        data.Citytax = ' xx ' ;
        data.Districttax = ' xx ' ;
        data.Totalassetpayment = ' xx ' ;
        data.Paymentfrequency = l.cllease__Residual_Type__c;
        data.Dayspastdue = string.valueOf(l.cllease__Days_Past_Due__c);
        
        data.PaymentReceivedDate = string.valueOf(l.cllease__Last_Payment_Date__c);
        data.PaymentAmountReceived = string.valueOf(l.cllease__Last_Payment_Amount__c);
        data.PaymentNumber = ' xx ' ;
        

        List<PMUtility.assetDetail> assetList = new List<PMUtility.assetDetail>();
        
        /* List<cllease__Contract_Equipment__c> eList = [Select Additional_Residual_Amount__c
         , Asset_ID__c, Asset_Type_ID__c
         , Asset_Type_Name__c
         , Balance_Net_Trade_Up_Amount__c
         , Bill_Residual_Amount__c
         , Business_Unit__c
         , City_InstallAddress__c
         , Cost_Center__c
         , Country_InstallAddress__c
         , County_InstallAddress__c
         , CreatedById, CreatedDate
         , Dealer_Charges__c
         , Department_Name__c
         , Eligible_for_property_tax__c
         , Equipment_Description1__c
         , Evergreen_Depreciable_Cost__c
         , Evergreen_Depreciable_Life__c
         , External_Id__c
         , GARD__c
         , Id
         , Install_Account__c
         , Install_Address_Line_1__c
         , Install_Address_Line_2__c
         , Install_Address__c
         , Install_Date__c
         , Invoice_Date__c
         , Invoice_Number__c
         , IsDeleted, LastModifiedById, LastModifiedDate
         , Last_Residual_Burndown_Date__c
         , Lessee_Code__c
         , Lessee_Company__c
         , Manufacturer__c
         , Master_Asset_Type_ID__c
         , Master_Asset_Type__c
         , NBV__c, NPA_Amount__c
         , NPBA_Amount__c
         , Name
         , Net_Trade_Up_Amount__c
         , Object_Category_ID__c
         , Object_Category_Name__c
         , Oracle_Trade_Up_Amount__c
         , Owner_Class__c
         , Prior_Owner_Class__c
         , Product_Type__c
         , Remaining_Evergreen_Depreciable_Cost__c
         , Rent_Amount__c
         , Residual_Percentage__c
         , Salvage_Value__c
         , Serial_Number__c
         , State_Code__c
         , State__c
         , SystemModstamp
         , Termination_Date__c
         , Total_Equipment_Cost__c
         , Zip_Code_InstallAddress__c
         , cllease__Account__c
         , cllease__Asset_Split_Equipment__c
         , cllease__Bill_Group__c
         , cllease__Billing_Group__c
         , cllease__City_Surcharge__c
         , cllease__City_Tax_Rate__c
         , cllease__City__c
         , cllease__Contract__c
         , cllease__Country__c
         , cllease__County_Surcharge__c
         , cllease__County_Tax_Rate__c, cllease__County__c, cllease__Created_Through_Contract__c, cllease__Dealer_Contact_Email__c, cllease__Dealer_Contact_Name__c, cllease__Dealer_Fees__c, cllease__Dealer_Funded__c, cllease__Dealer_Name__c, cllease__Dealer_Party__c, cllease__Dealer_Phone_Number__c, cllease__Depreciation_Basis__c, cllease__Equipment_Book_Value__c, cllease__Equipment_Calculated_Cost__c, cllease__Equipment_Cost__c, cllease__Equipment_Description__c, cllease__Equipment_External_Id__c, cllease__Equipment_Id__c, cllease__Equipment_Net_Book_Value__c, cllease__Equipment_Serial_Number__c, cllease__Equipment_Type__c, cllease__Estimated_Selling_Price__c, cllease__Evergreen_Depreciation_Amount__c, cllease__External_Id__c, cllease__Flag_To_Delete__c, cllease__Generate_Book_Depreciation__c, cllease__History_Tracking_Id__c, cllease__Item_Code__c, cllease__LeaseApplicationNumber__c, cllease__LeaseApplication__c
         , cllease__Make__c
         , cllease__Model__c, cllease__NBV_On_Restructure_Date__c, cllease__New_Invoice_Price__c, cllease__New_Rent__c, cllease__Next_Variable_Rent_Due_Date__c
         , cllease__Original_Equipment_Id__c
         , cllease__Other_Financed_Fees__c
         , cllease__Override_Tax_Flag__c
         , cllease__Override_Tax_Rate__c
         , cllease__Override_VAT_Code__c
         , cllease__Quantity__c
         , cllease__Rent__c
         , cllease__Residual_Amount__c
         , cllease__Select_Equipment__c
         , cllease__State_Province__c
         , cllease__State_Surcharge__c
         , cllease__State_Tax_Rate__c, cllease__Status__c, cllease__Street_Address__c, cllease__Subsidy__c, cllease__Subvention__c
         , cllease__Tax_Amount__c, cllease__Tax_Code__c, cllease__Tax_Depreciation_Method__c
         , cllease__Tax_Depreciation__c, cllease__Tax_Residual_Value__c, cllease__Tax_exemption__c
         , cllease__Total_Dealer_Charges__c, cllease__Total_Tax_Amount__c, cllease__Total_Tax_Rate_Derived__c
         , cllease__Total_Tax_Rate__c, cllease__Upfront_Tax_Basis__c, cllease__Upfront_Tax_Flag__c
         , cllease__VIN__c, cllease__Variable_Rent_Frequency__c, cllease__Variable_Rent_Start_Date__c, cllease__Warehouse_Equipment__c
         , cllease__Warranty_Amount__c, cllease__Year__c, cllease__Zip_Code__c, cllease__life_in_months__c, cllease__return_status__c, cllease__status1__c
         , cllease__tax_financed__c 
        */
        Integer i=1;
        for (cllease__Contract_Equipment__c e:eList ){
            PMUtility.assetDetail a =  new PMUtility.assetDetail();

            a.assetSequenceNumber = string.valueOf(i);  //m-26
            i++;
            a.assetDescription = e.Equipment_Description1__c; //m-29
            a.assetManufacturer = e.Manufacturer__c;
            a.assetMake = e.cllease__Make__c; //m-27
            a.assetModel = e.cllease__Model__c;  //m-28
            a.assetSerialNumber = e.Serial_Number__c; //m-30
            a.assetAddressLine1 = e.Install_Address_Line_1__c; 
            a.assetAddressLine2 =  e.Install_Address_Line_2__c;
            a.assetCity = e.City_InstallAddress__c;
            a.assetState= e.State__c;
            a.assetZipCode = e.Zip_Code_InstallAddress__c;
            a.assetPayment = string.valueOf(e.cllease__Rent__c);
        

        /* XXD_ASSET_TBL_TYPE in Select Inquiry */
            a.Asset_Category = null;
            a.Asset_Cndtn = null;
            a.Asset_Number= null;
            a.Asset_Status= null;
            a.Billing_City= null;
            a.Billing_Country= null;
            a.Billing_County= null;
            a.Billing_Group_Id= null;
            a.Billing_Location= null; //m-38
            a.Billing_State= null;
            a.Billing_Zip= null;
            a.Calc_Residual_Amnt= null;
            a.Calc_Residual_Prcnt= null;
            a.Cost_Center= null; //m-37 missing
            a.Description = e.Equipment_Description1__c;
            a.First_Payment_Date =null;
            a.Guaranteed_Amount = null;
            a.Guarantor_Name = null;
            a.Install_City = e.City_InstallAddress__c;
            a.Install_Country = e.Country_InstallAddress__c;
            a.Install_County = e.County_InstallAddress__c; // 6/19 new field
            a.Install_Date = string.valueOf(e.Install_Date__c);  // 6/19 new field
            a.Install_Location = e.Install_Address_Line_1__c; //m-39
            a.Install_Site_Id = null;
            a.Install_Site_Id = null;
            a.Install_State = null;
            a.Install_Zip = e.Zip_Code_InstallAddress__c;
            a.Install_Site_Id = null;
            a.Install_Site_Id = null;
            a.Install_Site_Id = null;
            a.Inventory_Item_Id= null;
            a.Install_Site_Id = null;
            a.Item= null;
            a.Install_Site_Id = null;
            a.Install_Site_Id = null;
            a.Licence_Number= null;
            a.Manufacturer= null;
            a.Modal = null;
            a.Mtp_Rep_Ven_Site= null;
            a.Mtp_Rep_Vendor= null;
            a.Number_Of_Assets= null;
            a.Organization_Id= null;
            a.Parent_Asset_Num= null;
            a.Payment_Amount = null;
            a.Po_Number = null;  //m-36 missing
            a.Residual_Amnt = null;
            a.Residual_Prcnt= null;
            a.Uba_Flag= null;
            a.Unit_Cost= null;
            a.Units= null;

            assetList.add(a);
        }
        
        
        /* end asset extension */
        data.assetDetail = assetList;
        system.debug(JSON.serialize(data));

        return JSON.serialize(data); 

    }


    
    /************************************************************************************************************************************************************
    *   add contract summary to the current data
    *************************************************************************************************************************************************************/


    public static PMUtility.Data addContractSummary(PMUtility.Data currentData, PMUtility.ContractSummary contractSummary){
         
        currentData.Contract_Status = contractSummary.contractStatus;
        currentData.Contract_Application_Number = contractSummary.creditApplicationNumber;
        currentData.Product = contractSummary.financialProduct;
        currentData.Financialproduct = contractSummary.financialProduct;
        currentData.PurchaseOption = contractSummary.purchaseOption;
        currentData.Statetax = contractSummary.stateTax;
        currentData.CityTax = contractSummary.cityTax;
        currentData.DistrictTax = contractSummary.districtTax;
        currentData.Totalassetpayment = contractSummary.contractRent;
        currentData.PaymentFrequency = contractSummary.paymentFrequency;
        currentData.Dayspastdue = contractSummary.dayspastDue;
        currentData.PaymentReceivedDate = contractSummary.paymentAppliedDate;
        currentData.PaymentAmountReceived = contractSummary.lastPaymentAmount;
        currentData.PaymentNumber = contractSummary.lastPaymentNumber;
        currentData.contractService = contractSummary.contractService;
        currentData.Citytax = contractSummary.cityTax;

        return currentData;
    }

}