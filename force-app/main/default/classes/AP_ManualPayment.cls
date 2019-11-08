/*************************************************************************************************
 Change Log:

 9/5/19 MRM - removed edits so that over payment can occur.
 9/18/19 - MRM - Ursa change - use clcommon_consolidated_invoice__c instead of invoice__c

 *********************************************************************************************************************/

global with sharing class AP_ManualPayment {

    public Static boolean manualPayment = false;

    @AuraEnabled
	public static String addPayment(String recordId, String checkNumber, Decimal checkAmount, Date paymentDate, String voidPNC, String notes){
		
        Map<String,String> response = new Map<String,String>();

        List<Int_PX_Billing__c> lineList = [Select line_data__c
                                        from Int_PX_Billing__c 
                                        where committed__c = false]; 
       
         
        /*
        if (!lineList.isEmpty()) {
            response.put('Message','There is a pending PNC void transaction. Retry in a few minutes!');
            return JSON.serialize(response);
        }
        */

        /* grab the account number */
        clcommon__Consolidated_Invoice__c i = [SELECT name, balance_due_amount__c, sent_to_pnc__c ,LS_Contract__r.cllease__Account__r.account_number__c, paid_invoice_amount__c
                      FROM clcommon__Consolidated_Invoice__c
                      where id = :recordId
                      ];

        if (!i.sent_to_pnc__c){
            response.put('Message','This invoice was never sent to PNC! Contact system administrator!');
            return JSON.serialize(response);
        } 


        List<Int_PX_Remit__c> paymentsPending = new List<Int_PX_Remit__c>();
       

        paymentsPending = [select id 
                            from Int_PX_Remit__c 
                            where Invoice_number__c = :i.name
                            //and committed__c = false
                            ];
        
        if (i.balance_due_amount__c == 0)   {
            response.put('Message','This invoice has been paid, cannot make an additional payment on this invoice!');
            return JSON.serialize(response);
        } 
 
        //if (checkAmount > i.balance_due_amount__c)   {
        //    response.put('Message','Payment cannot be greater than the balance due!');
        //    return JSON.serialize(response);
        //} 

        if (paymentsPending.size() > 0){
            response.put('Message','There is already a payment pending for this invoice!');
            return JSON.serialize(response);
        }

        system.debug('checkamount: ' + checkAmount);
        system.debug('other' + i.balance_due_amount__c) ;
        //if (checkAmount > i.balance_due_amount__c){
        //    response.put('Message','Check amount must be less than or equal to the balance due!');
        //    return JSON.serialize(response);
        //}
             

        Int_PX_Remit__c r = new Int_PX_Remit__c();
 
        r.account_num__c = i.LS_Contract__r.cllease__Account__r.account_number__c;
        r.check__c = 'CHK' + checkNumber;
        r.committed__c = false;
        r.date__c = paymentDate;
        r.consolidated_invoice__c = recordId;
        r.invoice_number__c = i.name;
        r.invoice_amount_paid__c = checkAmount;
        r.invoice_amount__c = checkAmount;
        r.payment_batch_date__c = paymentDate;
        r.payment_Batch_total_amount__c = checkAmount;
        r.record_number__c = 1;
        r.transaction_amount__c = checkAmount;
        r.transaction_type__C = checkNumber;
        r.trans_source__c = 'PX';
        r.remark__c = 'Manual Payment Recorded - see notes';
        r.notes__c = notes;
        r.check_number__c = checkNumber;
         if (voidPNC == 'true'){
             r.void_in_pnc__c = true;
         }
        
        r.trans_UID__c = string.valueOf(paymentDate.year()) + string.valueOf(paymentDate.month()) + string.valueOf(paymentDate.day());

        manualPayment = true;

        insert r;

        Int_Batch_Status__c b = new Int_Batch_Status__c();
        b.status__c = 'Ready';
        b.Name = 'PX Remit';
        if (!test.isRunningTest())
            insert b;

        if (voidPNC == 'true'){
            PNCUtility.voidInvoice(recordId,true);
        }
        
            
        
        return JSON.serialize(response); 


	}

    @AuraEnabled
	public static String addAdjustment(String recordId, String aType,  Decimal credit, String chargeId, String dueId, Decimal taxAmount){
        
        cllease__Charge__c c;
        cllease__Due_Detail_Lines__c d;
        String equipment;
        Map<String,String> response = new Map<String,String>(); 

        if (taxAmount == null)
            taxAmount = 0;
            
        //taxAmount = 0 - taxAmount;
        //credit = 0 - credit;

        List<Adjustment__c> aList = new List<Adjustment__c>();
        aList = [select id 
                 from Adjustment__c
                 where charge__c = :chargeId
                 and consolidated_invoice__c = :recordid
                 ];

        if (!aList.isEmpty()){
            response.put('Message','This charge has already been adjusted, press cancel to continue!');
             return JSON.serialize(response);
        }
      
        if (chargeId != Null){
            c = [select cllease__Contract_Equipment__r.Equipment_Description1__c 
                from 
                cllease__Charge__c 
                where id = :chargeId
                ];
            equipment = c.cllease__Contract_Equipment__r.Equipment_Description1__c;
        }

        if (dueId != Null){
            d = [select cllease__Contract_Equipment__r.Equipment_Description1__c 
                from 
                cllease__Due_Detail_Lines__c 
                where id = :dueId
                ];
            equipment = d.cllease__Contract_Equipment__r.Equipment_Description1__c;
        }
        Adjustment__c a = new Adjustment__c(consolidated_invoice__c = recordId, Adjustment_Type__c = aType, credit__c = credit, equipment__c = equipment, charge__c = chargeId, due_detail_line__c = dueId
            ,tax_amount__c = taxAmount); 
        
        clcommon__Consolidated_Invoice__c i = [select id from clcommon__Consolidated_Invoice__c where id = :recordId];
        i.adjustment_status__c = 'Pending Approval';
        
        update i;
        
        insert a;
        

        return JSON.serialize(response);

    }

   
   
		
}