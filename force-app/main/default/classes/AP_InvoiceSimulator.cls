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
                ,cllease__Tax_Due__c
                ,cllease__Fee_Definition__r.name
                ,cllease__Contract_Equipment__r.Equipment_Description1__c
                from cllease__Charge__c
                where invoiced_In__c = :recordId
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

        for (cllease__charge__c c:cList){
            r = new resultLine();
            r.equipmentName  = c.cllease__Contract_Equipment__r.Equipment_Description1__c;
            r.recordName = c.name;
            r.fee =  c.cllease__Fee_Definition__r.name;
            feeTotal = feeTotal + c.cllease__Original_Amount__c;
            taxtotal = taxTotal  + c.cllease__Tax_Due__c;
            totalTotal = totalTotal + c.cllease__Original_Amount__c +  c.cllease__Tax_Due__c;
            r.className = 'rightJustify';
            r.feeAmount =  string.valueOf(c.cllease__Original_Amount__c);
            r.taxAmount = string.valueOf(c.cllease__Tax_Due__c);
            Decimal total = c.cllease__Original_Amount__c + c.cllease__Tax_Due__c;
            r.totalAmount = string.valueOf(total);
            results.add(r);
        }

        Map<ID,cllease__Lease_account_Due_Details__c> billMap = new Map<ID,cllease__Lease_account_Due_Details__c>();

        List<cllease__Lease_account_Due_Details__c> bList = new List<cllease__Lease_account_Due_Details__c>();
        bList = [select Id
                ,cllease__Due_Type_Description__c
                from cllease__Lease_account_Due_Details__c
                where invoiced_In__c = :recordId
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

        Invoice__c i = [select Previous_Balance_Due__c from Invoice__c where id = :recordId];
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
        
        Decimal feeTotal = 0;
        Decimal taxTotal =  0;
        Decimal totalTotal = 0;

         /* get original charges */

         List<cllease__charge__c> cList = new List<cllease__Charge__c>();
         cList = [select Id
                ,name
                ,cllease__Original_Amount__c
                ,cllease__Tax_Due__c
                ,cllease__Fee_Definition__r.name
                ,cllease__Contract_Equipment__r.Equipment_Description1__c
                from cllease__Charge__c
                where invoiced_In__c = :recordId
                order by cllease__Contract_Equipment__r.Equipment_Description1__c
                ];

        /* get billd */
        Map<ID,cllease__Lease_account_Due_Details__c> billMap = new Map<ID,cllease__Lease_account_Due_Details__c>();

        List<cllease__Lease_account_Due_Details__c> bList = new List<cllease__Lease_account_Due_Details__c>();
        bList = [select Id
                ,cllease__Due_Type_Description__c
                from cllease__Lease_account_Due_Details__c
                where invoiced_In__c = :recordId
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

        resultLine  r = new resultLine();

        List<resultLine> results = new List<resultLine>();

         /* go through charges and adjust */

          
        for (cllease__charge__c c:clist){
            system.debug('map is: ' + adjMap.get(c.id));
            List<Adjustment__c> adjList = adjMap.get(c.id);  //list of adjustments to this bill
            Decimal amount = c.cllease__Original_Amount__c;
            Decimal tax = c.cllease__Tax_Due__c;
            Decimal total = amount + tax;

            if (adjList != Null){
                for (Adjustment__c adj:adjList){
                    if (adj.tax_amount__c == null)
                        adj.tax_amount__c = 0.00;
                    system.debug('amount is: ' + amount);
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


        /* go through bills and adjust */
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

         

         r = new resultLine();

        Invoice__c i = [select Previous_Balance_Due__c from Invoice__c where id = :recordId];
        
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