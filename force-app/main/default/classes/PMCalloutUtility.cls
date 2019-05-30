/*******************************************************************************************************************
*   PM CALLOUT UTILITY
*
* 
*	Change Log: 
*	5/14/19 - Created
*
*   Implements callouts for tradeups,false,false) ;
 
* 
********************************************************************************************************************/
public with sharing class PMCalloutUtility {

   	/********************************************************************************************
   	* Send Request to ICS
   	* 
   	********************************************************************************************/
   	public static  PMUtility.ServiceContractData searchPortfolio(String customerName
                                    , String customerNumber
                                    , String assetSerialNumber
                                    , Integer size
                                    , String sortOrder
                                    , Boolean assetDetail
                                    , Integer page){
        
        PMUtility.ServiceContractData myResponse = new PMUtility.ServiceContractData();

        System.HttpResponse response;
        System.HttpRequest request = new System.HttpRequest();
        
        request.setTimeout(120000);
    	
  
        String requestParms = '?assetDetail=TRUE';
        
        customerName = customerName.trim();
        customerNumber = customerNumber.trim();
        assetSerialNumber = assetSerialNumber.trim();
        sortOrder = sortOrder.trim();

        if (customerName != null && customerName != ''){
            customerName = '*' + customerName + '*';
            customerName = customerName.replace(' ','*');
            requestParms +=  '&customerName=' +  customerName;
        }
        
        if (customerNumber != null && customerNumber != '')
            requestParms +='&customerNumber=' + customerNumber;                  
        

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
    	
    	response = new System.Http().send(request); 
    
        if (response.getStatusCode() == 200){ 

            myResponse = (PMUtility.ServiceContractData) System.JSON.deserialize(response.getBody(),PMUtility.ServiceContractData.class);
            
            for (PMUtility.Data d:myResponse.data){
                d.newCoReady = 'true';

                if (d.assetDetail.size() == 1)
                    d.equipmentDescription = d.assetDetail.size() + ' Line of Equipment';
                else
                    d.equipmentDescription = d.assetDetail.size() + ' Lines of Equipment';
            }
        }   
       
	    system.debug(System.Label.PM_Endpoint + '/americas/v1/partnerportfolio' + requestParms);
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

        System.HttpResponse response;
        System.HttpRequest request = new System.HttpRequest();
        
        request.setTimeout(120000);
    	request.setEndpoint(System.Label.PM_Endpoint + '/americas/v2/terminationquote?messageId=' + 'newco');
    	request.setHeader('Content-Type', 'application/json'); 
        request.setHeader('Authorization', 'Bearer '+ PMUtility.getAccessToken());
    	request.setMethod('POST');
    	
    	
        JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartObject();
        
        Datetime dt = system.now();
       	gen.writeStringField('transmissionDate', dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
	  	gen.writeStringField('partnerOrderId', '22684111');
	  	gen.writeStringField('contractNumber', leaseNumber);
        gen.writeStringField('terminationQuoteType', 'TRADEUP_WITHOUT_PURCHASE');
        
        List<String> sList = new List<String>();
        sList.add('PAST_DUE');

        gen.writeObjectField('quoteCalculationOption', sList);
		gen.writeEndObject();
        	
		request.setBody(gen.getAsString());  
        response = new System.Http().send(request); 
        
        if (response.getStatusCode() == 200){ 

            qResponse = (PMUtility.TerminationQuoteResponse) System.JSON.deserialize(response.getBody(),PMUtility.TerminationQuoteResponse.class);
            system.debug('qresponse is:    ' + qResponse);
            qResponse.quotes[0].quoteNumber =  qResponse.quoteNumber;
            qResponse.quotes[0].quoteCalculationDescription = 'Trade Up w/Equipment Return';
            qResponse.quotes[0].terminationQuoteType = qResponse.quotes[0].quoteCalculationDescription;
            qResponse.quotes[0].quoteValidityDate = qResponse.quoteValidityDate;
            qResponse.quotes[0].quoteMessage = qResponse.quoteMessage;
            qResponse.quoteMessage = null;
            qResponse.quoteNumber = null;
            qResponse.quoteValidityDate = null;
            qResponse.terminationQuoteType = null; 
        
            System.HttpResponse response2;
            System.HttpRequest request2 = new System.HttpRequest();
            JSONGenerator gen2 = JSON.createGenerator(true);
		    gen2.writeStartObject();
            gen2.writeStringField('transmissionDate', dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
	  	    gen2.writeStringField('partnerOrderId', '22684111');
	  	    gen2.writeStringField('contractNumber', leaseNumber);
            gen2.writeStringField('terminationQuoteType', 'TRADEUP_WITH_PURCHASE');
            gen2.writeObjectField('quoteCalculationOption', sList);
		    gen2.writeEndObject();
        	
		    request2.setBody(gen2.getAsString()); 
            request2.setTimeout(120000);
    	    request2.setEndpoint(System.Label.PM_Endpoint + '/americas/v2/terminationquote?messageId=' + 'newco');
    	    request2.setHeader('Content-Type', 'application/json'); 
            request2.setHeader('Authorization', 'Bearer '+ PMUtility.getAccessToken());
    	    request2.setMethod('POST');
    	
            response2 = new System.Http().send(request2); 

            if (response2.getStatusCode() == 200){ 

                qResponse2 = (PMUtility.TerminationQuoteResponse) System.JSON.deserialize(response2.getBody(),PMUtility.TerminationQuoteResponse.class);
                system.debug('qresponse2 is:    ' + qResponse2);
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
        newQuotes.add(lq);

        insert newQuotes;

        if (!lList.isEmpty())
            delete lList;

        return qResponse;
    }

    /************************************************************************************************************************************************************
    *   getLeaseDetails
    *************************************************************************************************************************************************************/

    public static String getLeaseDetails(String leaseInfo){
        
        system.debug(leaseInfo); 
  
        PMUtility.Data currentData = (PMUtility.Data) System.JSON.deserialize(leaseInfo,PMUtility.Data.class);

        system.debug(currentData);
        system.debug('searching for contract nbr:  ' + currentdata.contractNumber);
        
        
        System.HttpResponse response;
        System.HttpRequest request = new System.HttpRequest();
        
        request.setTimeout(120000);
    	request.setEndpoint(System.Label.PM_Endpoint + '/americas/v1/contractdetail');
    	request.setHeader('Content-Type', 'application/json'); 
        request.setHeader('Authorization', 'Bearer '+ PMUtility.getAccessToken());
        request.setHeader('dllContractNumber', currentData.contractNumber);
    	request.setMethod('GET');
    	
        response = new System.Http().send(request); 
        
        PMUtility.contractDetail contractDetail;

        if (response.getStatusCode() == 200){ 
            system.debug(response.getBody());
            contractDetail = (PMUtility.contractDetail) System.JSON.deserialize(response.getBody(),PMUtility.ContractDetail.class);
            system.debug(contractDetail);
            system.debug(contractDetail.assets); 
        }

        /* add extra gathered data to currentdata */
        currentData.Cust_Legal_Name = contractDetail.customerLegalName;

        //find assets[i].serialNumber in data
        //then update
       
        for (Integer i=0;i < contractDetail.assets.size(); i++){
           
            for (Integer j=0;j < currentData.assetDetail.size();j++){
               
                if (currentData.assetDetail[j].assetSerialNumber == contractDetail.assets[i].serialNumber){
                    system.debug('Before:' + currentData.assetDetail[j]);
                    currentData.assetDetail[j].Billing_City = contractDetail.assets[i].billingCity;
                    currentData.assetDetail[j].Billing_Location = contractDetail.assets[i].billingLocation;
                    currentData.assetDetail[j].Billing_State = contractDetail.assets[i].billingState;
                    currentData.assetDetail[j].Billing_Zip = contractDetail.assets[i].billingPostalCode;

                    currentData.assetDetail[j].Install_City = contractDetail.assets[i].installCity;
                    currentData.assetDetail[j].Install_Location = contractDetail.assets[i].installLocation;
                    currentData.assetDetail[j].Install_State = contractDetail.assets[i].installState;
                    currentData.assetDetail[j].Install_Zip = contractDetail.assets[i].installPostalCode;
                    system.debug('After:' + currentData.assetDetail[j]);
                    continue;
                }
            }
        } 
        


        System.HttpResponse response2;
        System.HttpRequest request2 = new System.HttpRequest();
        
        request2.setTimeout(120000);
    	request2.setEndpoint(System.Label.PM_Endpoint + '/americas/v1/contractsummary');
    	request2.setHeader('Content-Type', 'application/json'); 
        request2.setHeader('Authorization', 'Bearer '+ PMUtility.getAccessToken());
        request2.setHeader('dllContractNumber', currentData.contractNumber);
    	request2.setMethod('GET');
    	
        response2 = new System.Http().send(request2); 
        
        if (response2.getStatusCode() == 200){ 
            system.debug(response2.getBody());
            PMUtility.contractSummary contractSummary = (PMUtility.contractSummary) System.JSON.deserialize(response2.getBody(),PMUtility.ContractSummary.class);
            system.debug('Before: '  + currentData);

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

            system.debug('After: '  + currentData);

        }

        return JSON.serialize(currentData); 

    }
}