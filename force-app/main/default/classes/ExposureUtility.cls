/*******************************************************************************************************************
*   EXPOSURE UTILITY
*
* 
*	Change Log: 
*	2/26/19 - MRM Created
    9/5/19 - MRM Changed residual to use residual amount instead of bill residual amount from equipment
    9/19/19 - MRM changed ref to invoiced_in__c tov cllease__Consolidated_Invoice__c 
*
*   This is use to calculate exposure for one or more leases; it can handle up to 10 lease at a time....maybe less.

*   To Test:

*       Set<String> leaseSet = new Set<String>();
*       leaseSet.add('a6J1I000000ozee');
*       leaseSet.add('a6J1I000000ozT7');
*       Exposureutility.getExposure(leaseset);

    * 
    Set<String> leaseSet = new Set<String>();
    List<cllease__lease_account__c> lList = new List<cllease__lease_account__c>();
    lList = [select id from cllease__lease_account__c];
    for (cllease__lease_account__c l:lList)
	    leaseSet.add(string.valueOf(l.id));


    Exposureutility.getExposure(leaseset);

    Rent - this the total amount of rent from payment streams
    
    Estimated Property Tax - starts with the total estimate property tax from payment streams less + sales tax on estimated property taxes
    
    Total Amount Paid - sum of total amount paid from bills 
    Evergreen Rent Billed Not Paid - tax due amount from bill page
    Rent Billed Not Paid - tax due amount from bill page
    Charges: 
      Late Fees - total amount due including taxes if applicable from charge page
      Insurance Fees - total amount due including taxes if applicable from charge page
      Finance Fees - total amount due including taxes if applicable from charge page
        
      Origination Fees - total amount due including taxes if applicable from charge page
      Service Fees - total amount due including taxes if applicable from charge page
      TERMINATION QUOTE FEES - total amount due including taxes if applicable from charge page
      Estimated Property Tax - sales tax due - sales tax paid = sales tax outstanding; this gets added to estimated property tax
      ASSET SALE - total amount due including taxes if applicable from charge page
      NSF Fees - total amount due including taxes if applicable from charge page

    Non Cash

        Unearned Income
        Unearned Residual
        Rent Accrual

********************************************************************************************************************/
public with sharing class ExposureUtility {
    public static Boolean exposureCalcRunning = false;
    /********************************************************************************************
   	* Get Exposure
   	* 
   	********************************************************************************************/
   	@Future
    public static void getExposureFuture(Set<String> leaseSet){   
        
        exposureCalcRunning = true;
        getExposure(leaseSet);
    }

   	public static Map<ID,Map<String,Decimal>> getExposure(Set<String> leaseSet){

            exposureCalcRunning = true;

            String calcDetails = '';
            Map<ID,Map<String,Decimal>> returnMap = new Map<ID,Map<String,Decimal>>();

            
            Map<String,Decimal> leaseBuckets = new Map<String,Decimal>();
            Map<String,List<Map<String,Decimal>>> exposureComponentsListMap = new Map<String,List<Map<String,Decimal>>>();
            Map<ID,Map<String,Decimal>> leaseSetRent = new Map<ID,Map<String,Decimal>>();
             Map<ID,Map<String,Decimal>> leaseSetEstimatedPropertyTax = new Map<ID,Map<String,Decimal>>();
            Map<ID,Map<String,Decimal>> leaseSetBillBuckets = new Map<ID,Map<String,Decimal>>();
            Map<ID,Map<String,Decimal>> leaseSetChargeBuckets = new Map<ID,Map<String,Decimal>>();
            Map<ID,Map<String,Decimal>> leaseSetResidual = new  Map<ID,Map<String,Decimal>>();
            Map<ID,Map<String,Decimal>> leaseSetNonCash = new  Map<ID,Map<String,Decimal>>();
            Map<ID,cllease__Lease_Account__c> leaseMap = new Map<ID,cllease__Lease_Account__c>([SELECT cllease__Lease_Status__c
                                                                                                    ,cllease__NPA_Status__c 
                                                                                                    ,name
                                                                                                    FROM cllease__Lease_Account__c
                                                                                                    where id in :leaseSet]);
          
            Map<String,Decimal> exposureMap = new Map<String,Decimal>();

            //leaseSetEstimatedPropertyTax = getTotalEstimatedPropertyTax(leaseSet);
            leaseSetBillBuckets = getBillBuckets(leaseSet);
            leaseSetChargeBuckets = getChargeBuckets(leaseSet);
            leaseSetResidual = getResidual(leaseSet);
            leaseSetNonCash = getNonCash(leaseSet);


            for (ID id:leaseSet){
                Map<ID,Decimal> rentMap = ExposureUtility.getTotalRent(leaseSet);  //get the total rent for the leases
                Map<ID,Decimal> propertyTaxMap = ExposureUtility.getTotalEstimatedPropertyTax(leaseSet);  //get the total property tax for the leases
                Map<String,Decimal> componentMapforLease = new Map<String,Decimal>();
                componentMapForLease.put('RENT',rentMap.get(id));
                componentMapForLease.put('Estimated Property Tax',propertyTaxMap.get(id)); 
                leaseSetRent.put(id, componentMapForLease);
            }
            Map<ID,Lease_Exposure__c> exMap = new Map<ID,Lease_Exposure__c>();

            List<Lease_Exposure__c> exList = new List<Lease_Exposure__c>();
            exList = [
                  SELECT Asset_Sale__c
                  ,Estimated_Property_Tax__c
                  ,Evergreen_Billed_Not_Paid__c
                  ,Evergreen_Billed__c
                  ,Exposure__c
                  ,Finance_Fees__c
                  ,Id,Insurance_Fees__c
                  ,Late_Fees__c
                  ,LS_Contract__c
                  ,Name
                  ,NSF_Fees__c
                  ,Origination_Fees__c
                  ,Rent_Accrual__c
                  ,Rent_Billed_Not_Paid__c
                  ,Rent_Billed__c
                  ,Rent__c
                  ,Residual_Amount__c
                  ,Service_Fees__c
                  ,Termination_Quote_Fees__c
                  ,Unearned_Income__c
                  ,Unearned_Residual__c 
                  
                  FROM Lease_Exposure__c
                  where ls_contract__c in :leaseset
            ];
            for (Lease_Exposure__c ex:exList){
                exMap.put(ex.LS_contract__c,ex);
            }

            List<Lease_Exposure__c> updateList= new List<Lease_Exposure__c>();
            List<Lease_Exposure__c> insertList = new List<Lease_Exposure__c>();
            List<cllease__lease_account__c> uLeases = new List<cllease__lease_account__c>();
            
            for (String id:leaseSet){
                cllease__lease_account__c lease = leaseMap.get(id);

            Lease_Exposure__c ex = new Lease_Exposure__c();
            Boolean newEx = true;   
            if (exmap.get(id) != null){
                ex = exMap.get(id);
                newEx = false;
            }
            

               


                Decimal exposure = 0;
                if (!leaseMap.get(id).cllease__Lease_Status__c.contains('ACTIVE')){
                   
                    ex.LS_Contract__c = id;
                    ex.name = leaseMap.get(id).name;
                    exposure = 0;
                    ex.exposure__c = exposure;
                    exposureMap.put('Exposure',exposure);
                    calcDetails = 'Exposure = 0.00 for Terminated Contracts' + '\n';
                    ex.formula__c = calcDetails;
                    lease.exposure__c = exposure;
                    if (newEx)
                        insertList.add(ex); 
                    else
                        updateList.add(ex);
                    

                    uLeases.add(lease);
                }
                else{
                    system.debug(' ');
                    system.debug(' ');
                    system.debug(' ');
                    system.debug('********************* start debug exposure components *******************************');
                    system.debug('Lease: ' + leaseMap.get(id).name + '------------------> Id: ' + id);
                    system.debug(leaseSetRent.get(id));
                  
                    system.debug(leaseSetBillBuckets.get(id));
                    system.debug(leaseSetChargeBuckets.get(id));
                    system.debug(leaseSetResidual.get(id));
                  
                    if (leaseSetNonCash.get(id) != null){
                        for (String s:leaseSetNonCash.get(id).keySet()){
                            system.debug(s + ' : ' + leaseSetNonCash.get(id).get(s));
                        }
                    }

                    exposure = 0;
                    ex.LS_Contract__c = id;
                    ex.name = leaseMap.get(id).name;
                    ex.Rent__c = leaseSetRent.get(id).get('RENT');
                    //ex.estimated_property_tax__c = leaseSetRent.get(id).get('Estimated Property Tax');

                    ex.Evergreen_Billed__c = leaseSetBillBuckets.get(id).get('Evergreen Billed');

                    ex.total_amount_paid__c = leaseSetBillBuckets.get(id).get('Total Amount Paid');

                    if (leaseSetRent.get(id).get('RENT') != null)
                        exposure +=  leaseSetRent.get(id).get('RENT');
                    system.debug('+ Rent ' + exposure);
                    calcDetails = '';
                    calcDetails += 'Exposure = Rent of ' + ex.Rent__c + '\n'; 
                    
                    ex.rent_billed__c = leaseSetBillBuckets.get(id).get('Normal Rent Billed');
                    
                    if (exposure == null)
                        exposure = 0;
                    if (leaseSetBillBuckets.get(id) != null)
                        if (leaseSetBillBuckets.get(id).get('Total Amount Paid') != null)
                            exposure = exposure - leaseSetBillBuckets.get(id).get('Total Amount Paid');
 
                    system.debug('- Total Amount Paid =' + exposure);
                    calcDetails += '- Total Amount Paid  (incl taxes) of ' + leaseSetBillBuckets.get(id).get('Total Amount Paid')  + ' = ' + exposure + '\n'; 
                    
                    ex.Evergreen_Billed_not_paid__c = leaseSetBillBuckets.get(id).get('Evergreen Billed Not Paid');
                    if (leaseSetBillBuckets.get(id).get('Evergreen Rent Billed Not Paid') != null)
                        exposure += leaseSetBillBuckets.get(id).get('Evergreen Rent Billed Not Paid');
                    
                    ex.Tax_On_Evergreen_Billed_not_paid__c = leaseSetBillBuckets.get(id).get('Tax on Evergreen Billed Not Paid');
                    if (leaseSetBillBuckets.get(id).get('Tax on Evergreen Billed Not Paid') != null)
                        exposure += leaseSetBillBuckets.get(id).get('Tax on Evergreen Billed Not Paid');
                    calcDetails += '+ Tax on Evergreen Rent Billed Not Paid of '  + ex.tax_on_Evergreen_Billed_not_paid__c + ' = ' + exposure + '\n';
                    
                   
                    //ex.Rent_Billed_Not_Paid__c = leaseSetBillBuckets.get(id).get('Normal Rent Billed Not Paid');
                    //if (leaseSetBillBuckets.get(id).get('Normal Rent Billed Not Paid') != null)
                    //        exposure += leaseSetBillBuckets.get(id).get('Normal Rent Billed Not Paid');
                    //system.debug('+ Normal Rent Billed Not Paid =' + exposure);
                    //calcDetails += '+ Tax on Rent Billed Not Paid of ' +   ex.Rent_Billed_Not_Paid__c  + ' = ' + exposure + '\n';
                   
                   
                    system.debug(leaseSetBillBuckets.get(id));
                    system.debug(leaseSetBillBuckets.get(id).get('Tax on Rent Billed Not Paid'));
                    ex.tax_on_rent_billed_not_paid__c = leaseSetBillBuckets.get(id).get('Tax on Rent Billed Not Paid');
                    if (leaseSetBillBuckets.get(id).get('Tax on Rent Billed Not Paid') != null)
                        exposure += leaseSetBillBuckets.get(id).get('Tax on Rent Billed Not Paid');
                    calcDetails += '+ Tax on Rent Billed Not Paid of ' +   ex.tax_on_rent_billed_not_paid__c  + ' = ' + exposure + '\n';
                    
                    //system.debug('+ Evergreen Rent Billed Not Paid =' + exposure);
                    
                    
                    if (leaseSetChargeBuckets.get(id) != null){
                        ex.Late_Fees__c = leaseSetChargeBuckets.get(id).get('Late Fees'); 
                        if (leaseSetChargeBuckets.get(id).get('Late Fees') != null)
                            exposure += leaseSetChargeBuckets.get(id).get('Late Fees');
                        system.debug('+ Late Fees =' + exposure);
                        calcDetails += '+ Late Fees of ' + ex.Late_Fees__c  + ' = ' + exposure + '\n';
                        
                        
                        ex.Insurance_Fees__c = leaseSetChargeBuckets.get(id).get('Insurance Fees');
                        if (leaseSetChargeBuckets.get(id).get('Insurance Fees') != null)
                            exposure += leaseSetChargeBuckets.get(id).get('Insurance Fees');
                        system.debug('+ Insurance Fees =' + exposure);
                        calcDetails += '+ Insurance Fees of ' + ex.Insurance_Fees__c + ' = ' + exposure + '\n';
                        
                        
                        ex.Finance_Fees__c = leaseSetChargeBuckets.get(id).get('Finance Fees');
                        if (leaseSetChargeBuckets.get(id).get('Finance Fees') != null)
                            exposure += leaseSetChargeBuckets.get(id).get('Finance Fees');
                        system.debug('+ Finance Fees =' + exposure);
                        calcDetails +='+ Finance Fees of ' + ex.Finance_Fees__c + '  = ' + exposure + '\n';
                        
                        
                        ex.Origination_Fees__c = leaseSetChargeBuckets.get(id).get('Origination Fees');
                        if (leaseSetChargeBuckets.get(id).get('Origination Fees') != null)
                            exposure += leaseSetChargeBuckets.get(id).get('Origination Fees');
                        system.debug('+ Origination Fees =' + exposure);
                        calcDetails +='+ Origination Fees of ' + ex.Origination_Fees__c  + ' = ' + exposure + '\n';
                        
                        
                        ex.Service_Fees__c = leaseSetChargeBuckets.get(id).get('Service Fees');
                        if (leaseSetChargeBuckets.get(id).get('Service Fees') != null)
                            exposure += leaseSetChargeBuckets.get(id).get('Service Fees');
                        system.debug('+ Service Fees =' + exposure);
                        calcDetails +='+ Service Fees of ' +   ex.Service_Fees__c + ' = ' + exposure + '\n';
                        
                        
                        ex.Termination_Quote_Fees__c = leaseSetChargeBuckets.get(id).get('TERMINATION QUOTE FEES');
                        if (leaseSetChargeBuckets.get(id).get('TERMINATION QUOTE FEES') != null)
                            exposure += leaseSetChargeBuckets.get(id).get('TERMINATION QUOTE FEES');
                        system.debug('+ Termination Quote Fees =' + exposure);
                        calcDetails +='+ Termination Quote Fees of ' +  ex.Termination_Quote_Fees__c + ' = ' + exposure + '\n';
                        
                        exposure += ex.Estimated_Property_Tax__c;
                        calcDetails +='+ Estimated Property Tax of ' + ex.Estimated_Property_Tax__c.setScale(2)  + ' = '  + exposure + '\n'; 

                        Decimal salesTax = 0;
                        if (leaseSetChargeBuckets.get(id).get('Estimated Property Tax') != null){
                            salesTax = leaseSetChargeBuckets.get(id).get('Estimated Property Tax');
                            ex.sales_tax_on_property_tax__c = salesTax.setScale(2);
                            exposure += salesTax ;
                        }
                        system.debug('+ Sales Tax on Property Tax =' + exposure);
                        calcDetails +='+ Sales Tax on Property Tax of ' + salesTax.setScale(2) + ' = '  + exposure + '\n';
                        
                        
                        ex.Asset_Sale__c = leaseSetChargeBuckets.get(id).get('ASSET SALE');
                        if (leaseSetChargeBuckets.get(id).get('ASSET SALE') != null)
                            exposure += leaseSetChargeBuckets.get(id).get('ASSET SALE');
                        system.debug('+ Asset Sale =' + exposure);
                        calcDetails +='+ Asset Sale of ' + ex.Asset_Sale__c  + ' = '   + exposure + '\n';

                        ex.NSF_Fees__c = leaseSetChargeBuckets.get(id).get('NSF Fees');
                        if (leaseSetChargeBuckets.get(id).get('NSF Fees') != null)
                            exposure += leaseSetChargeBuckets.get(id).get('NSF Fees');
                        system.debug('+ NSF Fees =' + exposure);
                        calcDetails +='+ NSF Fees of ' + ex.NSF_Fees__c + ' = ' + exposure + '\n';
                    }

                    if (leaseSetResidual.get(id) != null){
                        ex.Residual_Amount__c = leaseSetResidual.get(id).get('Residual Amount');
                        if (leaseSetResidual.get(id).get('Residual Amount') != null)
                            exposure += leaseSetResidual.get(id).get('Residual Amount');
                        system.debug('+ Residual Amount =' + exposure);
                        calcDetails +='+ Residual Amount of ' + ex.Residual_Amount__c  + ' = ' + exposure + '\n';
                    }

                    if (leaseSetNonCash.get(id) != null){
                        ex.Unearned_Income__c = leaseSetNonCash.get(id).get('UNEARNED INCOME');
                        if (leaseSetNonCash.get(id).get('UNEARNED INCOME') != null)
                            exposure -= leaseSetNonCash.get(id).get('UNEARNED INCOME');
                        system.debug('- Unearned Income =' + exposure);
                        calcDetails += '- Unearned Income of ' + ex.Unearned_Income__c + ' = ' + exposure + '\n';

                        ex.Unearned_Residual__c = leaseSetNonCash.get(id).get('UNEARNED RESIDUAL');
                        if (leaseSetNonCash.get(id).get('UNEARNED RESIDUAL') != null)
                            exposure -= leaseSetNonCash.get(id).get('UNEARNED RESIDUAL');
                        system.debug('- Unearned Residual =' + exposure);
                        calcDetails += '- Unearned Residual of ' + ex.Unearned_Residual__c +  ' = ' + exposure + '\n';

                        //ex.Rent_Accrual__c = leaseSetNonCash.get(id).get('RENTAL ACCRUAL');
                        //if (leaseSetNonCash.get(id).get('RENTAL ACCRUAL') != null)
                        //    exposure += leaseSetNonCash.get(id).get('RENTAL ACCRUAL');
                        //system.debug('+ Rental Accrual =' + exposure);
                        //calcDetails +='+ Rental Accrual of ' + ex.Rent_Accrual__c  + ' = ' + '\n';
                    }
                    system.debug('=  Total Exposure =' + exposure);
                    exposureMap.put('Exposure',exposure);
                    ex.exposure__c = exposure;
                    calcDetails = calcDetails.replace('null','0.00');
                    ex.formula__c = calcDetails;
                    lease.exposure__c = exposure;
                    uLeases.add(lease);
                    system.debug(exposureMap);
                    if (newEx)
                        insertList.add(ex); 
                    else
                        updateList.add(ex);
                   
                    system.debug('********************* end debug exposure components *******************************');
                }
                 
                returnMap.put(id,exposureMap);
            }  
            if (!updateList.isEmpty())
                update updateList;
            if (!insertList.isEmpty())
                insert insertList;

            update uLeases;

            return returnMap;  
    }       
    /********************************************************************************************
   	* Obtain Payment Streams for Contracts
   	* 
   	********************************************************************************************/
   	public static Map<ID,Decimal> getTotalRent(Set<String> leaseSet){

           Map<ID,Decimal> rentMap = new Map<ID,Decimal>();

           Map<ID,List<cllease__Payment_Stream__c>> paymentStreamMap = ExposureUtility.getPaymentStreams(leaseSet);

           for (ID l :paymentStreamMap.keySet()){
               for (cllease__Payment_Stream__c s:paymentStreamMap.get(l)){
                   Decimal rentAmount;
                   if (s.cllease__payment_type__c == 'RENT'){
                        if (rentMap.containsKey(l)){
                           rentAmount = rentMap.get(l);
                        }
                        else{
                           rentAmount = 0;
                        }
                        rentAmount += s.cllease__Rental_Amount__c;
                        rentMap.put(l,rentAmount);
                   }
               }
           }

           return rentMap; 

    }
    /********************************************************************************************
   	* Obtain Estimated Propery Tax
   	* 
   	********************************************************************************************/
   	public static Map<ID,Decimal> getTotalEstimatedPropertyTax(Set<String> leaseSet){

           Map<ID,Decimal> estTaxMap = new Map<ID,Decimal>();

           Map<ID,List<cllease__Payment_Stream__c>> paymentStreamMap = ExposureUtility.getPaymentStreams(leaseSet);

           for (ID l :paymentStreamMap.keySet()){
               for (cllease__Payment_Stream__c s:paymentStreamMap.get(l)){
                   Decimal estimatedPropertyTax;
                    if (s.cllease__Transaction_Sub_Type__r.name == 'Estimated Property Tax'){
                        if (estTaxMap.containsKey(l)){
                            estimatedPropertyTax = estTaxMap.get(l);
                        }
                        else{
                            estimatedPropertyTax = 0;
                        }
                        estimatedPropertyTax += s.cllease__Rental_Amount__c;
                        estTaxMap.put(l,estimatedPropertyTax);
                    }
               }
           }

           return estTaxMap;

    }

    /********************************************************************************************
   	* Obtain Payment Streams for Contracts
   	* 
   	********************************************************************************************/
   	public static Map<ID,List<cllease__Payment_Stream__c>> getPaymentStreams(Set<String> leaseSet){
 
        Map<ID,List<cllease__Payment_Stream__c>> returnMap = new Map<ID,List<cllease__Payment_Stream__c>>();

        List<cllease__Payment_Stream__c> sList = new List<cllease__Payment_Stream__c>();
        sList = [SELECT cllease__Active__c,cllease__Billed__c,cllease__Contract_Fee__r.name
                 ,cllease__Date_Billed__c,cllease__Payment_Date__c,cllease__Payment_Type__c, cllease__Contract__c
                 ,cllease__Period_End_Date__c,cllease__Rental_Amount__c,cllease__Tax__c,cllease__Transaction_Sub_Type__r.name
                 FROM cllease__Payment_Stream__c
                 where cllease__Contract__c in :leaseSet
                ];

        
        for (cllease__Payment_Stream__c s:sList){
            List <cllease__Payment_Stream__c> tempList = new List<cllease__Payment_Stream__c>();
            if (returnMap.containsKey(s.cllease__Contract__c )){
                tempList = returnMap.get(s.cllease__Contract__c);
                tempList.add(s);
            }
            else{
                tempList.add(s);
            }
            returnMap.put(s.cllease__Contract__c,tempList);
        }
  

        return returnMap;
    }

    /********************************************************************************************
   	* Bucket the due details  - returns a list of all the different buckets
   	* 
    * Bucket List
        Normal Rent Billed
        Normal Billed Not Paid  
        Evergreen Rent Billed
        Evergreen Billed Not Paid

        maybe use cllease__Total_Due_Amount__c instead of cllease__rental_due_amount__c
       
   	********************************************************************************************/
   	public static Map<ID,Map<String,Decimal>> getBillBuckets(Set<String> leaseSet){

        Map<ID,Map<String,Decimal>> returnMap = new  Map<ID,Map<String,Decimal>>();

        Map<ID,List<cllease__Lease_account_Due_Details__c>> billMap = ExposureUtility.getAccountDueDetails(leaseSet);

        Decimal amount;
        for (ID lID:leaseSet){  //for each lease
                Map<String,Decimal> bucketMap = new Map<String,Decimal>();
                if (billMap.get(lID) != null){
                for (cllease__Lease_account_Due_Details__c d:billMap.get(lID)){  //go the the list for the lease
                   amount = 0;
                   
                   if (d.cllease__Evergreen_Rent_Flag__c){  //evergreen processing
                        if (d.cllease__Payment_Satisfied__c){
                            if (bucketMap.containsKey('Evergreen Billed')){
                                amount = bucketMap.get('Evergreen Billed');
                                amount += d.cllease__Total_Due_Amount__c;
                            }
                            else{
                                amount = d.cllease__Total_Due_Amount__c;
                            }
                            bucketMap.put('Evergreen Billed',amount);
                            
                        }
                        else{
                            if (bucketMap.containsKey('Evergreen Billed Not Paid')){
                                amount = bucketMap.get('Evergreen Billed Not Paid');
                                amount += d.cllease__Balance_Amount__c;
                            }
                            else{
                                amount = d.cllease__Balance_Amount__c;
                            }
                            bucketMap.put('Evergreen Billed Not Paid',amount);

                            if (bucketMap.containsKey('Tax on Evergreen Rent Billed Not Paid')){
                                amount = bucketMap.get('Tax on Evergreen Rent Billed Not Paid');
                                amount += d.Tax_Due__c;
                            }
                            else{
                                amount = d.tax_due__c;
                            }
                            bucketMap.put('Tax on Evergreen Rent Billed Not Paid',amount);
                        }
                        
                   }
                   else{ //normal rent processing
                        amount = 0;
                        if (d.cllease__Payment_Satisfied__c){
                            if (bucketMap.containsKey('Normal Rent Billed')){
                                amount = bucketMap.get('Normal Rent Billed');
                                amount += d.cllease__Total_Due_Amount__c;
                            }
                            else{
                                amount = d.cllease__Total_Due_Amount__c;
                            }
                            bucketMap.put('Normal Rent Billed',amount);
                            
                        }
                        else{
                            if (bucketMap.containsKey('Normal Rent Billed Not Paid')){
                                amount = bucketMap.get('Normal Rent Billed Not Paid');
                                amount += d.cllease__Balance_Amount__c;
                            }
                            else{
                                amount = d.cllease__Balance_Amount__c;
                            }
                            bucketMap.put('Normal Rent Billed Not Paid',amount);

                            if (bucketMap.containsKey('Tax on Rent Billed Not Paid')){
                                amount = bucketMap.get('Tax on Rent Billed Not Paid');
                                amount += d.tax_due__c;
                            }
                            else{
                                 amount = d.tax_due__c;
                            }
                            bucketMap.put('Tax on Rent Billed Not Paid',amount);
                        }
                        
                   }
                   amount = 0;
                   if (bucketMap.containsKey('Total Amount Paid')){
                       amount = bucketMap.get('Total Amount Paid');
                       amount += d.cllease__total_paid_amount__c;
                   }
                   else{
                       amount += d.cllease__total_paid_amount__c;
                   }
                    bucketMap.put('Total Amount Paid',amount);
                }
                }
                returnMap.put(lID,bucketMap);
           }
        
        return returnMap;

    }
    
    /********************************************************************************************
   	* Obtain Bill List - cllease__Lease_account_Due_Details__c
   	* 
   	********************************************************************************************/
   	public static Map<ID,List<cllease__Lease_account_Due_Details__c>> getAccountDueDetails(Set<String> leaseSet){

           Map<ID,List<cllease__Lease_account_Due_Details__c>> returnMap = new Map<ID,List<cllease__Lease_account_Due_Details__c>>(); 
           
           List<cllease__Lease_account_Due_Details__c> dList = new List<cllease__Lease_account_Due_Details__c>();

           dList = [SELECT Aging_Bucket__c
                ,cllease__Account__c
                ,cllease__Balance_Amount__c
                ,cllease__Contract_Status__c
                ,cllease__Customer__c
                ,cllease__Due_Date__c
                ,cllease__Due_Type_Description__c
                ,cllease__Evergreen_Rent_Flag__c
                ,cllease__GL_Posted_Flag__c
                ,cllease__GL_Processing_Message__c
                ,cllease__GL_Process_Date__c
                ,cllease__GL_Reversal_Posted_Flag__c
                ,cllease__GL_Reversal_Process_Date__c
                ,cllease__GL_Transaction_Flag__c
                ,cllease__Id__c
                ,cllease__Late_Charge_Applied__c
                ,cllease__LeaseApplicationNumber__c
                ,cllease__Lease_Account__c
                ,cllease__Maturity_Date__c
                ,cllease__Other_Due_Amount__c
                ,cllease__Other_Paid_Amount__c
                ,cllease__Payment_Date__c
                ,cllease__Payment_Satisfied__c
                ,cllease__Period_End_Date__c
                ,cllease__Period_Start_Date__c
                ,cllease__Primary_Flag__c
                ,cllease__Purchase_Amount__c     
                ,cllease__Quote_Header__c
                ,cllease__Quote_Tax__c
                ,cllease__Remarks__c
                ,cllease__Rental_Due_Amount__c
                ,cllease__Rental_Paid_Amount__c
                ,cllease__Reversed_Flag__c
                ,cllease__Start_Date__c
                ,cllease__Status__c
                ,cllease__Tax_Due_Amount__c
                ,cllease__Tax_Paid_Amount__c
                ,cllease__Tax_Processed__c
                ,cllease__Termination_Quote__c
                ,cllease__Tolerance__c
                ,cllease__Total_Bill_Amount__c
                ,cllease__Total_Due_Amount__c
                ,cllease__Total_Paid_Amount__c
                ,cllease__Total_Tax_Rate__c
                ,cllease__Transaction_Date__c
                ,cllease__Unbilled_Receivable__c
                ,Days_Past_Due__c
                ,Gain_Loss__c
                ,Id
                ,cllease__Consolidated_Invoice__c
                ,Name
                ,Premium_Purchase_Amount__c
                ,tax_due__c
                ,Report_Date_Time__c
                ,Unbilled_Service_and_Maintenance__c
                ,VertexTax_Computed_DDL_Count__c 
                FROM cllease__Lease_account_Due_Details__c 
                where cllease__Lease_Account__c in :leaseSet
                ];

        for (cllease__Lease_account_Due_Details__c d:dList){
            List <cllease__Lease_account_Due_Details__c> tempList = new List<cllease__Lease_account_Due_Details__c>();
            if (returnMap.containsKey(d.cllease__Lease_Account__c )){
                tempList = returnMap.get(d.cllease__Lease_Account__c);
                tempList.add(d);
            }
            else{
                tempList.add(d);
            }
            returnMap.put(d.cllease__Lease_Account__c,tempList);
        }
        

        return returnMap;
    } 

    /********************************************************************************************
   	* Bucket the charges
   	* 
    * Bucket List
        Late Fees
        Insurance Fees
        Finance Fees
        
        Origination Fees
        Service Fees
        TERMINATION QUOTE FEES -
        Estimated Property Tax
        ASSET SALE
        NSF Fees
       
   	********************************************************************************************/	
     public static Map<ID,Map<String,Decimal>> getChargeBuckets(Set<String> leaseSet){

        Map<ID,Map<String,Decimal>> returnMap = new Map<ID,Map<String,Decimal>>();

        Map<ID,List<cllease__Charge__c>> chargeMap = ExposureUtility.getCharges(leaseSet);

        for (ID lID:leaseSet){  //for each lease
            
            Map<String,Decimal> bucketMap = new Map<String,Decimal>();
            if (chargeMap.get(lID) != null){
            for (cllease__Charge__c c:chargeMap.get(lID)){ 
                Decimal amount;
                if (c.cllease__tax_paid_amount__c == null)
                     c.cllease__tax_paid_amount__c = 0;
                if (bucketMap.containsKey(c.cllease__Fee_Definition__r.name)){
                    amount = bucketMap.get(c.cllease__Fee_Definition__r.name);
                    
                    if (c.cllease__Fee_Definition__r.name == 'Estimated Property Tax')
                        amount += c.cllease__Tax_Due__c;
                    else
                        amount += c.cllease__Total_Due_Amount__c;
                }
                else{
                    if (c.cllease__Fee_Definition__r.name == 'Estimated Property Tax')
                        amount = c.cllease__Tax_Due__c;
                    else
                        amount = c.cllease__Total_Due_Amount__c;
                }
                bucketMap.put(c.cllease__Fee_Definition__r.name,amount.setScale(2));
            }
            returnMap.put(lID,bucketMap);
            }
         } 

         return returnMap;   

     }    
    /********************************************************************************************
   	* Obtain Charge List  
   	* 
   	********************************************************************************************/
    public static Map<ID,List<cllease__Charge__c>> getCharges(Set<String> leaseSet){

         Map<ID,List<cllease__Charge__c>> returnMap = new Map<ID,List<cllease__Charge__c>>();
         
        List<cllease__Charge__c> cList = new List<cllease__Charge__c>();

        clist = [SELECT cllease__Fee_Definition__r.name
                ,cllease__Total_Due_Amount__c
                ,cllease__Lease_Account__c
                ,cllease__Tax_Due__c
                ,cllease__paid_amount__c
                ,cllease__Tax_Paid_Amount__c 
                FROM cllease__Charge__c
                where cllease__Lease_Account__c in :leaseSet
                ];

        for (cllease__Charge__c c:cList){
            List <cllease__Charge__c> tempList = new List<cllease__Charge__c>();
            if (returnMap.containsKey(c.cllease__Lease_Account__c )){
                tempList = returnMap.get(c.cllease__Lease_Account__c);
                tempList.add(c);
            }
            else{
                tempList.add(c);
            }
            returnMap.put(c.cllease__Lease_Account__c,tempList);
        }
   

        return returnMap;
    }    
   /********************************************************************************************
   	* Obtain Residual Value cllease__Contract_Equipment__c
   	* 
   	********************************************************************************************/
    public static Map<ID,Map<String,Decimal>> getResidual(Set<String> leaseSet){
        
        Map<ID,Map<String,Decimal>> returnMap = new Map<ID,Map<String,Decimal>>();
        Map<ID,List<cllease__Contract_Equipment__c>> leaseMap = new Map<ID,List<cllease__Contract_Equipment__c>>();

        List<cllease__Contract_Equipment__c> eList = [SELECT cllease__Residual_Amount__c
                                                    ,cllease__contract__c
                                                    FROM cllease__Contract_Equipment__c
                                                    where cllease__contract__c in :leaseSet
                                                   ];

        for (cllease__Contract_Equipment__c e:eList){
            List<cllease__Contract_Equipment__c> tempList = new List<cllease__Contract_Equipment__c>();
            if (leaseMap.containsKey(e.cllease__contract__c)){
                tempList = leaseMap.get(e.cllease__contract__c);
                tempList.add(e);
            }
            else{
                tempList.add(e);
            }
            leaseMap.put(e.cllease__contract__c,tempList);
        }


        
        for (ID lID:leaseSet){ 
            Map<String,Decimal> bucketMap = new Map<String,Decimal>();
            if (leaseMap.get(lID) != null){
            for (cllease__Contract_Equipment__c e:leaseMap.get(lID)){
                Decimal amount;
                if (bucketMap.containsKey('Residual Amount')){
                    amount = bucketMap.get('Residual Amount');
                    amount += e.cllease__Residual_Amount__c;
                }
                else{
                    amount = e.cllease__Residual_Amount__c;
                }
                bucketMap.put('Residual Amount',amount);
            }
            returnMap.put(lID,bucketMap);
            }
         } 

         return returnMap;

    }

    /********************************************************************************************
   	* Obtain Non Cash Balances
   	* 
   	********************************************************************************************/
    public static Map<ID,Map<String,Decimal>> getNonCash(Set<String> leaseSet){
    
        Map<ID,Map<String,Decimal>> returnMap = new Map<ID,Map<String,Decimal>>();
        Map<ID,List<cllease__Non_Cash_Account_Balance__c>> leaseMap = new Map<ID,List<cllease__Non_Cash_Account_Balance__c>>();

        List<cllease__Non_Cash_Account_Balance__c> nList = [ SELECT cllease__Balance_Type__c
                                                    ,cllease__Closing_Balance_Amount__c 
                                                    ,cllease__contract__c
                                                    FROM cllease__Non_Cash_Account_Balance__c
                                                    where cllease__contract__c in :leaseSet
                                                   ];

        for (cllease__Non_Cash_Account_Balance__c n:nList){
            List<cllease__Non_Cash_Account_Balance__c> tempList = new List<cllease__Non_Cash_Account_Balance__c>();
            if (leaseMap.containsKey(n.cllease__contract__c)){
                tempList = leaseMap.get(n.cllease__contract__c);
                tempList.add(n);
            }
            else{
                tempList.add(n);
            }
            leaseMap.put(n.cllease__contract__c,tempList);
        }

        for (ID lID:leaseSet){ 
            Map<String,Decimal> bucketMap = new Map<String,Decimal>();
            if (leaseMap.get(lID) != null){
            for (cllease__Non_Cash_Account_Balance__c n:leaseMap.get(lID)){
                Decimal amount;
                if (bucketMap.containsKey(n.cllease__Balance_Type__c)){
                    amount = bucketMap.get(n.cllease__Balance_Type__c);
                    amount += n.cllease__Closing_Balance_Amount__c;
                }
                else{
                    amount = n.cllease__Closing_Balance_Amount__c;
                }
                bucketMap.put(n.cllease__Balance_Type__c,amount.setScale(2));
            }
            returnMap.put(lID,bucketMap);
            }
         } 

         return returnMap;


    }
}