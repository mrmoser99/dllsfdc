global with sharing class AP_ManualPayment {

    public Static boolean manualPayment = false;

    @AuraEnabled
	public static String addPayment(String recordId, String checkNumber, Decimal checkAmount, Date paymentDate){
		
        Map<String,String> response = new Map<String,String>();

        /* grab the account number */
        Invoice__c i = [SELECT name, balance_due_amount__c, LS_Contract__r.cllease__Account__r.account_number__c
                      FROM Invoice__c
                      where id = :recordId
                      ];

        List<Int_PX_Remit__c> paymentsPending = new List<Int_PX_Remit__c>();

        paymentsPending = [select id 
                            from Int_PX_Remit__c 
                            where Invoice_number__c = :i.name
                            ];

        if (paymentsPending.size() > 0){
             response.put('Message','There is already a payment pending for this invoice!');
            return JSON.serialize(response);
        }

        if (i.balance_due_amount__c < checkAmount){
            response.put('Message','Check amount must be less than or equal to the balance due!');
            return JSON.serialize(response);
        }
            

        Int_PX_Remit__c r = new Int_PX_Remit__c();
 
        r.account_num__c = i.LS_Contract__r.cllease__Account__r.account_number__c;
        r.check__c = 'CHK' + checkNumber;
        r.committed__c = false;
        r.date__c = paymentDate;
        r.invoice__c = recordId;
        r.invoice_number__c = i.name;
        r.invoice_amount_paid__c = checkAmount;
        r.invoice_amount__c = checkAmount;
        r.payment_batch_date__c = paymentDate;
        r.payment_Batch_total_amount__c = checkAmount;
        r.record_number__c = 1;
        r.transaction_amount__c = checkAmount;
        r.transaction_type__C = checkNumber;
        r.trans_source__c = 'PX';
        r.remark__c = 'Manual Payment Recorded';
        r.trans_UID__c = string.valueOf(paymentDate.year()) + string.valueOf(paymentDate.month()) + string.valueOf(paymentDate.day());

        manualPayment = true;

        insert r;

        Int_Batch_Status__c b = new Int_Batch_Status__c();
        b.status__c = 'Ready';
        b.Name = 'PX Remit';
        insert b;


        return JSON.serialize(response);


	}

}