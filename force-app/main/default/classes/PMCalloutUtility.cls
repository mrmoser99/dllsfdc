/*******************************************************************************************************************
*   PM CALLOUT UTILITY
*
* 
*	Change Log: 
*	5/14/19 - Created
*   5/31/19 - completed upgrade to use callouts
*   6/7/19 - removed the delete of old quotes
* 
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
        
        PMUtility.ServiceContractData myResponse = new PMUtility.ServiceContractData();
        if (disableLogging == null)
            disableLogging = false;

        System.HttpResponse response;
        System.HttpRequest request = new System.HttpRequest();
        
        request.setTimeout(120000);
    	
  
        String requestParms = '?assetDetail=TRUE';
        
        if (assetDetail == false)
            requestParms = '?assetDetail=FALSE';

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
            if (response.getStatusCode() == 200){ 

                myResponse = (PMUtility.ServiceContractData) System.JSON.deserialize(response.getBody(),PMUtility.ServiceContractData.class);
                system.debug('the response is: ' + myResponse);
                for (PMUtility.Data d:myResponse.data){
                    d.newCoReady = 'true';

                    if (d.assetDetail.size() == 1){
                        d.equipmentDescription = d.assetDetail.size() + ' Line of Equipment';
                        d.nbrOfAssets = '1';
                    }
                    else{
                        d.nbrOfAssets = string.valueOf(d.assetDetail.size());
                        d.equipmentDescription = d.assetDetail.size() + ' Lines of Equipment';
                    }
                    String periodocity = d.contractPeriodicity;

                    if (periodocity == '1')
                        d.contractPeriodicity = 'Monthly';
                    else
                    if (periodocity == '2')
                        d.contractPeriodicity = 'Bi-Monthly';
                    else 
                    if (periodocity == '3')
                        d.contractPeriodicity = 'Quarterly';
                    else
                    if (periodocity == '6')
                        d.contractPeriodicity = 'Semi-Annually';
                    else
                    if (periodocity == '12')
                        d.contractPeriodicity = 'Annually';
                }

                 l.results__c = 'Success!';
            }     
            else{
                l.results__c = response.getBody();
            } 
        }
        catch (Exception e){
            l.results__c = string.valueOf(e) + '-' + e.getMessage() + '-' + e.getStackTraceString() + '-' + e.getLineNumber();
             
        } 
        finally{
            dt2Long = DateTime.now().getTime();
           

            milliseconds = dt2Long - dt1Long;
            l.seconds__c = milliseconds / 1000;

            if (disableLogging == false) 
                insert l;
        }
       
	    return myResponse;
   	}

    /************************************************************************************************************************************************************
    *   generateQuotes - message format
    *************************************************************************************************************************************************************/
    public static PMUtility.TerminationQuoteResponse generateQuotes(String leaseNumber){
        
        PMUtility.TerminationQuoteResponse qResponse = new PMUtility.TerminationQuoteResponse(); 
        PMUtility.TerminationQuoteResponse qResponse2 = new PMUtility.TerminationQuoteResponse(); 
        
        
        List<Lease_OLM_Quote__c> newQuotes = new List<Lease_OLM_Quote__c>();

        List<PMUtility.Quote> qList = new List<PMUtility.Quote>();
        String accessToken = PMUtility.getAccessToken();
        System.HttpResponse response;
        System.HttpRequest request = new System.HttpRequest();
        
        request.setTimeout(120000);
    	request.setEndpoint(System.Label.PM_Endpoint + '/americas/v2/terminationquote?messageId=' + 'newco');
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

                l.results__c = 'Success!';
            }
            else{  
                l.results__c = response.getBody();
            }
        }
        catch (Exception e) {
           l.results__c = string.valueOf(e) + '-' + e.getMessage() + '-' + e.getStackTraceString() + '-' + e.getLineNumber();
        }  
        finally{
            l.quote__c = qResponse.quotes[0].quoteNumber;
            dt2Long = DateTime.now().getTime();
            milliseconds = dt2Long - dt1Long;
            l.seconds__c = milliseconds / 1000;
             
            iList.add(l);

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
    	    request2.setEndpoint(System.Label.PM_Endpoint + '/americas/v2/terminationquote?messageId=' + 'newco');
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
            }
            else{
                l.results__c = response.getBody();
            }
        }
        catch (Exception e){
             l.results__c = string.valueOf(e) + '-' + e.getMessage() + '-' + e.getStackTraceString() + '-' + e.getLineNumber();
        } 
        finally{
            l.quote__c =  qResponse2.quotes[0].quoteNumber;
            dt2Long = DateTime.now().getTime();
            system.debug(dt2Long);
            system.debug(dt1Long);

            milliseconds = dt2Long - dt1Long;
            l.seconds__c = milliseconds / 1000;
             
            iList.add(l);

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
        //mrm remove delete
        //if (!lList.isEmpty())
        //    delete lList;
        insert iList;

        return qResponse;
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
        request.setTimeout(120000);
    	request.setEndpoint(System.Label.PM_Endpoint + '/americas/v1/contractdetail');
    	request.setHeader('Content-Type', 'application/json'); 
        request.setHeader('Authorization', 'Bearer '+ accessToken);
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
            }
            else{
                 l.results__c = response.getBody();
            }
        }
        catch (Exception e){
             l.results__c = string.valueOf(e) + '-' + e.getMessage() + '-' + e.getStackTraceString() + '-' + e.getLineNumber();
        }
        finally{
            l.lease__c = currentData.contractNumber;
            dt2Long = DateTime.now().getTime();
            system.debug(dt2Long);
            system.debug(dt1Long);

            milliseconds = dt2Long - dt1Long;
            l.seconds__c = milliseconds / 1000;
             
            iList.add(l);

        }

        /* add extra gathered data to currentdata */
        currentData.Cust_Legal_Name = contractDetail.customerLegalName;
        currentData.customerAccount = contractDetail.customerAccount;


        //find assets[i].serialNumber in data
        //then update
         system.debug('contract detail is: ' + contractDetail); 
        for (Integer i=0;i < contractDetail.assets.size(); i++){
           
            for (Integer j=0;j < currentData.assetDetail.size();j++){
               
                if (currentData.assetDetail[j].assetSerialNumber == contractDetail.assets[i].serialNumber){
                    currentData.assetDetail[j].Billing_City = contractDetail.assets[i].billingCity;
                    currentData.assetDetail[j].Billing_Location = contractDetail.assets[i].billingLocation;
                    currentData.assetDetail[j].Billing_State = contractDetail.assets[i].billingState;
                    currentData.assetDetail[j].Billing_Zip = contractDetail.assets[i].billingPostalCode;

                    currentData.assetDetail[j].Install_City = contractDetail.assets[i].installCity;
                    currentData.assetDetail[j].Install_Location = contractDetail.assets[i].installLocation;
                    currentData.assetDetail[j].Install_State = contractDetail.assets[i].installState;
                    currentData.assetDetail[j].Install_Zip = contractDetail.assets[i].installPostalCode;

                     
                    currentData.assetDetail[j].Install_County = contractDetail.assets[i].installCounty;
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

                 l.results__c = 'Success!';

            }
            else{
                  l.results__c = response.getBody();
            }
        }
        catch (Exception e){
            l.results__c = string.valueOf(e) + '-' + e.getMessage() + '-' + e.getStackTraceString() + '-' + e.getLineNumber();
        }
        finally{
            l.lease__c = currentData.contractNumber;
            dt2Long = DateTime.now().getTime();
            system.debug(dt2Long);
            system.debug(dt1Long);

            milliseconds = dt2Long - dt1Long;
            l.seconds__c = milliseconds / 1000;
             
            iList.add(l);

        }

        insert iList;
        return JSON.serialize(currentData); 

    }
}