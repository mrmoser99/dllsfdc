/********************************************************************************************************************
 *   AP INVOICE SIMULATOR

 ChangeLog:

 9/18/19 - MRM - Ursa change - use clcommon_consolidated_invoice__c instead of invoice__c



 *********************************************************************************************************************/
 global with sharing class AP_InvoiceSimulator {

   
     public class resultLine{
        @AuraEnabled public String equipmentName; 
        @AuraEnabled public String recordName; 
        @AuraEnabled public String fee;
        @AuraEnabled public String feeAmount;
        @AuraEnabled public String taxAmount;
        @AuraEnabled public String totalAmount;
        @AuraEnabled public String className;
      
     }
    /********************************************************************************************
   	* get adjustments
   	* 
   	********************************************************************************************/
    @AuraEnabled 
    public static List<resultLine> getAdjustments(String recordId){
        
        List<resultLIne> results= new List<resultLine>();

        List<adjustment__c> aList = new List<adjustment__c>();
        aList = [select Id
                ,adjustment_type__c
                ,credit__c
                ,debit__c
                ,charge__c
                ,Charge__r.Name  
                ,Due_Detail_Line__r.Name   
                ,Due_Detail_Line__c
                ,tax_amount__c
                ,equipment__c 
                from adjustment__c 
                where invoice__c = :recordId
                order by equipment__c, charge_bill_name__C
          ];
        
        Decimal feeTotal = 0;
        Decimal taxTotal =  0;
        Decimal totalTotal = 0;
        resultLine r = new resultLine();

        for (Adjustment__c a:aList){
            r = new resultLine();

            r.equipmentName = a.equipment__c;

            if (a.charge__c != null)
                r.recordName = a.charge__r.name;

            if (a.due_detail_line__c != null)
                r.recordName = a.due_detail_line__r.name;
           
            r.fee = a.adjustment_type__c;
            if (a.tax_amount__c == null)
                a.tax_amount__c = 0.00;

            r.feeAmount =  string.valueOf(0 - a.credit__c);
            feeTotal = feeTotal + (0 - a.credit__c);
            taxTotal = taxTotal + ( 0 - a.tax_amount__c);
            totalTotal = totalTotal + (0 - a.credit__c) + (0 - a.tax_amount__c);
            r.taxAmount = string.valueOf(0 - a.tax_amount__c);
            r.totalAmount = string.valueOf((0 - a.credit__c) + (0 - a.tax_amount__c));
            results.add(r);
        }

        r = new resultLine();
        r.equipmentName = 'Totals';
        r.fee = '';
        r.feeAmount = string.valueOf(feeTotal);
        r.taxAmount = string.valueOf(taxTotal);
        r.totalAmount = string.valueOf(totalTotal);
        r.className = 'makeBold';
        results.add(r);
        
        return results;
    }

     
    /********************************************************************************************
   	* get charges and bills
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static List<resultLine> getCharges(String recordId){
        
        List<resultLine> results = new List<resultLine>();

        List<cllease__charge__c> cList = new List<cllease__Charge__c>();
        cList = [select Id
                ,name
                ,cllease__Original_Amount__c
                ,original_tax_amount__c
                ,cllease__Fee_Definition__r.name
                ,cllease__Contract_Equipment__r.Equipment_Description1__c
                from cllease__Charge__c
                where cllease__Consolidated_Invoice__c = :recordId
                and cllease__Fee_Definition__r.name not in ('Service Fees','Estimated Property Tax')
                order by cllease__Contract_Equipment__r.Equipment_Description1__c
                ];
        
        Decimal feeTotal = 0;
        Decimal taxTotal =  0;
        Decimal totalTotal = 0;

        
        resultLine  r = new resultLine();
        /*
        r.recordName = 'Charge/Bill Id';
        r.fee = 'Description';
        r.feeAmount = 'Amount';
        r.taxAmount = 'Tax';
        r.totalAmount = 'Total';
        r.className = 'makeBold';
        
        results.add(r);  
        */
        clcommon__Consolidated_Invoice__c	 i = [select Payment_Amount__c
                                ,Previous_Balance_Due__c
                                ,Payment_Sales_Tax__c
                                ,Payment_Amount_Total__c	
                        from clcommon__Consolidated_Invoice__c	 
                        where id = :recordId];
         
        r = new resultLine();
        r.equipmentName = ''; 
        r.recordName = '';
            
        r.fee = 'PAYMENT';

        r.feeAmount =  string.valueOf(i.Payment_Amount__c);
        if (i.payment_amount__c != null)
            feeTotal = feeTotal + i.Payment_Amount__c;
        r.taxAmount = string.valueOf(i.Payment_Sales_Tax__c);
        if (i.payment_sales_tax__c != null)
            taxTotal = taxTotal + i.Payment_Sales_Tax__c;
        if (i.payment_amount_total__c == null)    
            r.totalAmount = '';
        else
            r.totalAmount = string.valueOf(i.Payment_Amount_Total__c);
        if (i.payment_amount_total__c != null)
            totalTotal = totalTotal +i.Payment_Amount_Total__c;
        results.add(r);

        for (cllease__charge__c c:cList){
            
                 
            r = new resultLine();
            r.equipmentName  = c.cllease__Contract_Equipment__r.Equipment_Description1__c;
            r.recordName = c.name;
            r.fee =  c.cllease__Fee_Definition__r.name;
            feeTotal = feeTotal + c.cllease__Original_Amount__c;
            if (c.original_tax_amount__c == null)
                continue;
            else
                taxtotal = taxTotal  + c.original_tax_amount__c;

            if (c.original_tax_amount__c == null)    
                totalTotal = totalTotal + c.cllease__Original_Amount__c;
            else
                 totalTotal = totalTotal + c.cllease__Original_Amount__c +  c.original_tax_amount__c;
                 
            r.className = 'rightJustify';
            r.feeAmount =  string.valueOf(c.cllease__Original_Amount__c);
            if (c.original_tax_amount__c == null)
                r.taxAmount = '0.00';
            else
                r.taxAmount = string.valueOf(c.original_tax_amount__c);
            
            Decimal total;
            if (c.original_tax_amount__c == null)
                total = c.cllease__Original_Amount__c;
            else
                total = c.cllease__Original_Amount__c + c.original_tax_amount__c;

            r.totalAmount = string.valueOf(total);
            results.add(r);
        }

        Map<ID,cllease__Lease_account_Due_Details__c> billMap = new Map<ID,cllease__Lease_account_Due_Details__c>();

        List<cllease__Lease_account_Due_Details__c> bList = new List<cllease__Lease_account_Due_Details__c>();
        bList = [select Id
                ,cllease__Due_Type_Description__c
                from cllease__Lease_account_Due_Details__c
                where cllease__Consolidated_Invoice__c = :recordId
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
        
        /*
         for (cllease__Due_Detail_Lines__c e:eList){
            r = new resultLine();
            r.equipmentName = e.cllease__Contract_Equipment__r.Equipment_Description1__c;
            r.recordName = e.name;
            
            r.fee = billMap.get(e.cllease__bill__c).cllease__Due_Type_Description__c;

            r.feeAmount =  string.valueOf(e.cllease__Rental_Due_Amount__c);
            feeTotal = feeTotal + e.cllease__Rental_Due_Amount__c;
            r.taxAmount = string.valueOf(e.cllease__Tax_Due_Amount__c);
            taxTotal = taxTotal + e.cllease__Tax_Due_Amount__c;
            r.totalAmount = string.valueOf(e.cllease__total_due_amount__c);
            totalTotal = totalTotal + e.cllease__total_due_amount__c;
            system.debug('REsult is ' + r);
            results.add(r);
        }   
        */

        //Invoice__c i = [select Previous_Balance_Due__c from Invoice__c where id = :recordId];
        r = new resultLine();
        r.fee = 'PREVIOUS BALANCE';
        if (i.previous_balance_due__c == null)
            i.previous_balance_due__c = 0.0;

        r.totalAmount = string.valueOf(i.Previous_Balance_Due__c);
        totalTotal = totalTotal + i.Previous_Balance_Due__c;
        results.add(r);

        r = new resultLine();
        r.equipmentName = 'Totals';
        r.fee = '';
        r.feeAmount = string.valueOf(feeTotal);
        r.taxAmount = string.valueOf(taxTotal);
        r.totalAmount = string.valueOf(totalTotal);
        r.className = 'makeBold';
        results.add(r);
        
        return results;
    }

    /********************************************************************************************
   	* get new bills and charges
   	* 
   	********************************************************************************************/
    @AuraEnabled
    public static List<resultLine> getNewBillsAndCharges(String recordId){
        List<resultLine> results = new List<resultLine>();
        Decimal feeTotal = 0;
        Decimal taxTotal =  0;
        Decimal totalTotal = 0;

        clcommon__Consolidated_Invoice__c	 i = [select Payment_Amount__c
                                ,Previous_Balance_Due__c
                                ,Payment_Sales_Tax__c
                                ,Payment_Amount_Total__c	
                        from clcommon__Consolidated_Invoice__c	 
                        where id = :recordId];
         
        resultLine r = new resultLine();
        r.equipmentName = '';
        r.recordName = '';
            
        r.fee = 'PAYMENT';

        r.feeAmount =  string.valueOf(i.Payment_Amount__c);
        if (i.payment_amount__c != null)
            feeTotal = feeTotal + i.Payment_Amount__c;
        r.taxAmount = string.valueOf(i.Payment_Sales_Tax__c);
        if (i.payment_sales_tax__c != null)
            taxTotal = taxTotal + i.Payment_Sales_Tax__c;
        r.totalAmount = string.valueOf(i.Payment_Amount_Total__c);
        if (i.payment_amount_total__c != null)
            totalTotal = totalTotal +i.Payment_Amount_Total__c;
        results.add(r);


         /* get original charges */

         List<cllease__charge__c> cList = new List<cllease__Charge__c>();
         cList = [select Id
                ,name
                ,cllease__Original_Amount__c
                ,original_tax_amount__c
                ,cllease__Fee_Definition__r.name
                ,cllease__Contract_Equipment__r.Equipment_Description1__c
                from cllease__Charge__c
                where cllease__Consolidated_Invoice__c = :recordId
                and cllease__Fee_Definition__r.name not in ('Service Fees','Estimated Property Tax')
                order by cllease__Contract_Equipment__r.Equipment_Description1__c
                ];

        /* get billd */
        Map<ID,cllease__Lease_account_Due_Details__c> billMap = new Map<ID,cllease__Lease_account_Due_Details__c>();

        List<cllease__Lease_account_Due_Details__c> bList = new List<cllease__Lease_account_Due_Details__c>();
        bList = [select Id
                ,cllease__Due_Type_Description__c
                from cllease__Lease_account_Due_Details__c
                where cllease__Consolidated_Invoice__c = :recordId
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

        
        /* get adjustments */
        List<adjustment__c> aList = new List<adjustment__c>();
        aList = [select Id
                ,adjustment_type__c
                ,credit__c
                ,debit__c
                ,charge__c
                ,Charge__r.Name  
                ,Due_Detail_Line__r.Name  
                ,Due_Detail_Line__c
                ,tax_amount__c
                ,equipment__c
                from adjustment__c
                where invoice__c = :recordId
                 order by equipment__c, charge_bill_name__C
          ];
        
        Map<String,List<Adjustment__c>> adjMap = new Map<String,List<Adjustment__c>>();
        for (Adjustment__c a:aList){
            system.debug( 'in loop a is:' + a);
            if (a.charge__c != null){
                List<Adjustment__c> tempList = new List<Adjustment__c>();

                if (adjMap.get(a.charge__c) == null){
                    templist.add(a);
                }
                else{
                    tempList = adjMap.get(a.charge__c);
                    tempList.add(a);
                }
                adjMap.put(a.charge__c,tempList);
            }
            if (a.due_detail_line__c != null){
                List<Adjustment__c> tempList = new List<Adjustment__c>();

                if (adjMap.get(a.due_detail_line__c) == null){
                    templist.add(a);
                }
                else{
                    tempList = adjMap.get(a.due_detail_line__c);
                    templist.add(a);
                }
                adjMap.put(a.due_detail_line__c,tempList);
            }
        }

        /* now we have a map with all adjustments */

        r = new resultLine();

        

         /* go through charges and adjust */

          
        for (cllease__charge__c c:clist){
            system.debug('map is: ' + adjMap.get(c.id));
            List<Adjustment__c> adjList = adjMap.get(c.id);  //list of adjustments to this bill
            Decimal amount = c.cllease__Original_Amount__c;
            Decimal tax = c.original_tax_amount__c;
            if (tax == null)
                tax = 0;
            Decimal total = amount + tax;

            if (adjList != Null){
                for (Adjustment__c adj:adjList){
                    if (adj.tax_amount__c == null)
                        adj.tax_amount__c = 0.00;
                   
                    amount = amount - adj.credit__c;
                    tax = tax - adj.tax_amount__c;
                    total = amount + tax;
                }
            }
            if (total <> 0 ){
                r = new resultLine();
                r.equipmentName = c.cllease__contract_equipment__r.equipment_description1__c;
                system.debug(c);
                r.fee = c.cllease__Fee_Definition__r.name;
                r.recordName = c.name;
                r.feeAmount = string.valueOf(amount);
                r.taxAmount = string.valueOf(tax);
                r.totalAmount = string.valueOf(total);
                results.add(r);
                
                feeTotal = feeTotal + amount;
                taxTotal = taxTotal + tax;
                totalTotal = totalTotal + total;
            }
        
        }


        /* go through bills and adjust 
        for (cllease__Due_Detail_Lines__c e:elist){

            List<Adjustment__c> adjList = adjMap.get(e.id);  //list of adjustments to this bill
            Decimal amount = e.cllease__Rental_Due_Amount__c;
            Decimal tax = e.cllease__Tax_Due_Amount__c;
            Decimal total = e.cllease__total_due_amount__c;
            if (adjList != null) {
                for (Adjustment__c adj:adjList){
                    system.debug('adj  ' + adj);
                    if (adj.tax_amount__c == null)
                        adj.tax_amount__c = 0.00;
                    amount = amount - adj.credit__c;
                    tax = tax - adj.tax_amount__c;
                    total = amount + tax;
                }
            }
            if (total <> 0 ){
                r = new resultLine();
                r.equipmentName = e.cllease__contract_equipment__r.equipment_description1__c;
                r.fee = billMap.get(e.cllease__bill__c).cllease__Due_Type_Description__c;
                r.recordName = e.name;
                r.feeAmount = string.valueOf(amount);
                r.taxAmount = string.valueOf(tax);
                r.totalAmount = string.valueOf(total);
                results.add(r);
                
                feeTotal = feeTotal + amount;
                taxTotal = taxTotal + tax;
                totalTotal = totalTotal + total;
            }
        
        }

        */ 

         r = new resultLine();

        r.fee = 'PREVIOUS BALANCE';
        if (i.Previous_Balance_Due__c == null)
            i.Previous_Balance_Due__c = 0.0;
        r.totalAmount = string.valueOf(i.Previous_Balance_Due__c);
        totalTotal = totalTotal + i.Previous_Balance_Due__c;
        results.add(r);
        
        r = new resultLine();
        r.equipmentName = 'Totals';
        r.fee = '';
        r.feeAmount = string.valueOf(feeTotal);
        r.taxAmount = string.valueOf(taxTotal);
        r.totalAmount = string.valueOf(totalTotal);
        r.className = 'makeBold';
        results.add(r);

      
        system.debug('results are: ' + results); 
        return results;
    }    

}