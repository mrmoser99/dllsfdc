global with sharing class AP_VoidInvoice {

    @AuraEnabled
	public static String void(String recordId){

        Map<String,String> response = new Map<String,String>();

        Invoice__c i = [SELECT ID
            ,name
            ,voided_in_pnc__c
            ,sent_to_pnc__c
            FROM Invoice__c
            where id = :recordId 
            ]; 

        if (i.voided_in_pnc__c){
            response.put('Message','This invoice has been previously voided!');
            return JSON.serialize(response);
        }

         List<Int_PX_Billing__c> lineList = [Select line_data__c
                                        from Int_PX_Billing__c 
                                        where committed__c = false
                                    ];
         if (!lineList.isEmpty()) {
            response.put('Message','There is a pending PNC void transaction. Retry in a few minutes!');
            return JSON.serialize(response);
        }
        
        if (!i.sent_to_pnc__c){
            response.put('Message','This invoice was never sent to PNC! Contact system administrator!');
            return JSON.serialize(response);
        }

        /* limit to 120 days to void */

        lineList = new List<Int_PX_Billing__c>();
        Boolean invoiceFound = false;

        lineList = [Select line_data__c
                                        from Int_PX_Billing__c 
                                        where createdDate = last_n_days: 120
                                        and committed__c = true
                                    ];

       
        String origLine = '';
        for (Int_PX_Billing__c l: lineList){
            if(l.line_data__c.contains(i.name)){
                invoiceFound = true;
                origLine = l.line_data__c;
                break;
            }              
        }
        
        if (!invoiceFound){
            response.put('Message','This invoice could not be found in the pnc transaction list for the last 120 days.  Void not allowed!');
            return JSON.serialize(response);
        }
             
        PNCUtility.voidInvoice(recordId,true);
        
        return JSON.serialize(response);

    }
    
     public class resultLine{
        @AuraEnabled public String equipmentName;
        @AuraEnabled public String name;
        @AuraEnabled public String chargeId;
        @AuraEnabled public String fee;
        @AuraEnabled public String feeAmount;
        @AuraEnabled public String	taxAmount;
        @AuraEnabled public String id;
      
     }

      public class resultLine2{

        @AuraEnabled public String type;
        @AuraEnabled public String debit;
        @AuraEnabled public String credit;
        @AuraEnabled public String taxAmount;
      
      
     }
    /********************************************************************************************
   	*get charges and bills
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static List<resultLine> getCharges(String invoiceId, Integer intOffset){
        
        List<resultLine> results = new List<resultLine>();

        List<cllease__charge__c> cList = new List<cllease__Charge__c>();
        cList = [select Id
                ,name
                ,cllease__Original_Amount__c
                ,cllease__original_tax_amount__c
                ,cllease__Contract_Equipment__r.Equipment_Description1__c
                ,cllease__Fee_Definition__r.name
                from cllease__Charge__c 
                where invoiced_In__c = :invoiceId
                //and cllease__fee_definition__r.name = 'Late Charge'
                and cllease__Fee_Definition__r.name not in ('Service Fees','Estimated Property Tax')
                order by cllease__Contract_Equipment__r.Equipment_Description1__c
                
                ];
        
        for (cllease__charge__c c:cList){
            resultLine  r = new resultLine();
            r.name = c.name;
            r.id = c.id;
            r.equipmentName = c.cllease__Contract_Equipment__r.Equipment_Description1__c;
            r.chargeId = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/cllease__Charge__c/' + c.id + '/view?0.source=alohaHeader';
            r.fee =  c.cllease__Fee_Definition__r.name;
            r.feeAmount =  string.valueOf(c.cllease__Original_Amount__c);
            r.taxAmount = string.valueOf(c.cllease__original_tax_amount__c);
            system.debug('REsult is ' + r);
            results.add(r);
        }
        /*
        Map<ID,cllease__Lease_account_Due_Details__c> billMap = new Map<ID,cllease__Lease_account_Due_Details__c>();

        List<cllease__Lease_account_Due_Details__c> bList = new List<cllease__Lease_account_Due_Details__c>();
        bList = [select Id
                ,cllease__Due_Type_Description__c
                from cllease__Lease_account_Due_Details__c
                where invoiced_In__c = :invoiceId
                ];
        for (cllease__Lease_account_Due_Details__c b:blist){
            billMap.put(b.id,b);

        }

        List<cllease__Due_Detail_Lines__c> eList = new List<cllease__Due_Detail_Lines__c>();
        eList = [select Id
                ,name
                ,cllease__bill__c
                ,cllease__contract_equipment__r.equipment_description1__c
                ,cllease__Tax_Due_Amount__c
                ,cllease__Rental_Due_Amount__c
                ,cllease__total_due_amount__c
                from cllease__Due_Detail_Lines__c
                where cllease__bill__c in :billMap.keySet()
                order by cllease__Contract_Equipment__r.Equipment_Description1__c
                ];


         for (cllease__Due_Detail_Lines__c e:eList){
            resultLine  r = new resultLine();
            r.equipmentName = e.cllease__Contract_Equipment__r.Equipment_Description1__c;
            r.name = e.name;
            r.id = e.id;
            r.chargeId = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/cllease__Due_Detail_Lines__c/' + e.id + '/view?0.source=alohaHeader';
           
            r.fee = billMap.get(e.cllease__bill__c).cllease__Due_Type_Description__c;

            r.feeAmount =  string.valueOf(e.cllease__Rental_Due_Amount__c);
            r.taxAmount = string.valueOf(e.cllease__Tax_Due_Amount__c);
            system.debug('REsult is ' + r);
            results.add(r);
        }
        */

        return results;


    }
    /********************************************************************************************
   	* Approve
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static String approve(String recordId){

       
        Map<String,String> response = new Map<String,String>();
        Set<String> chargeSet = new Set<String>();

        List<adjustment__c> aList = new List<adjustment__c>();
        aList = [select Id
                ,charge__c
                from adjustment__c
                where invoice__c = :recordId
                
        ];
        for (Adjustment__c a:aList)
            chargeSet.add(a.charge__c);

        List< cllease__Charge__c> clist  = [select cllease__Paid_Amount__c
                                            ,name
                                            from 
                                            cllease__Charge__c 
                                            where id in :chargeSet
                                            ];
        for (cllease__charge__c c:clist){
            if (c.cllease__Paid_Amount__c > 0){
                response.put('Message', c.name + ' has been paid.  You cannot waive a fee that has been paid!');
                return JSON.serialize(response);
            }

        }    
        if (aList.isEmpty()){
            response.put('Message','There are no adjustment entries to approve. Please enter an adjustment and retry!');
            return JSON.serialize(response);
        }


        List<Int_PX_Billing__c> pncList = new List<Int_PX_Billing__c>();
        pncList = [ select id  
                    from Int_PX_Billing__c
                    where committed__c = false];
        if (!pncList.isEmpty()){
            response.put('Message','There is a pending transaction on its way to PNC.  Please retry in a few minutes!');
            return JSON.serialize(response);
        }

        if (PNCUtility.reverseTaxes(recordId)){ 

                
            Invoice__c i = [select id, sent_to_pnc__c from Invoice__c where id = :recordId];
            i.adjustment_status__c = 'Approved';
        
            if (i.sent_to_pnc__c){
                PNCUtility.reverseInvoice(recordId,false);   //PNCUtility.voidInvoice(recordId,true);  //void in pnc and reverse all flags
                i.void_in_pnc__c = false;
            }
            else{
                i.invoice_emailed__c = false;
            }

            update i;

        }
        else{
            response.put('Message','Vertex reversal failed!. Contact System Admin!');
            return JSON.serialize(response);
        }


        return JSON.serialize(response);
    }   

    /********************************************************************************************
   	* Get Invoice
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static String getInvoice(String recordId){

        Invoice__c i = [select adjustment_status__c from Invoice__c where id = :recordId];

        
        return i.adjustment_status__c;
    }     
        
    /********************************************************************************************
   	* Get Adjustments
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static List<adjustment__c> getAdjustments(String invoiceId, Integer intOffset){
        
        
        
        List<adjustment__c> aList = new List<adjustment__c>();
        aList = [select Id
                ,adjustment_type__c
                ,credit__c
                ,debit__c
                ,Charge__r.Name  
                ,Due_Detail_Line__r.Name  
                ,tax_amount__c
                ,equipment__c
                ,Charge_Bill_Name__c
                from adjustment__c
                where invoice__c = :invoiceId
                order by equipment__c, charge_bill_name__C
          ];
        for (adjustment__c a:aList)
            system.debug(a.charge__r.name);
        system.debug(aList);
        return aList;

    }    
    /********************************************************************************************
   	* Delete Adjustment
   	* 
   	********************************************************************************************/
    @AuraEnabled
	public static String deleteAdj(Adjustment__c toDelete){
        
        
        Map<String,String> response = new Map<String,String>(); 
        system.debug('to delete is: ' + toDelete);
        
        
        Adjustment__c a = [select invoice__c from Adjustment__c where id = :toDelete.id];
        Invoice__c i = [select id from Invoice__c where id = :a.invoice__c];

        List<Adjustment__c> aList = [select id from Adjustment__c where invoice__c = :a.invoice__c ];
        if (aList.size() == 1){
            
            i.adjustment_status__c = 'Ready';
           
        }
        else{
            i.adjustment_status__c = 'Pending Approval';
        }

        delete toDelete;
        update i;
        
        return JSON.serialize(response);

    }  

    
        

}