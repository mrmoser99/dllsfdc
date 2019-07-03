trigger PNCReconDetail on PNC_Recon_Detail__c (before insert) {


    Set<String> invoiceSet = new Set<String>();

    for (PNC_Recon_Detail__c d:trigger.new)
        invoiceSet.add(d.invoice_number__c);


    Map<String,Int_Px_Remit__c> remitMap = new Map<String,Int_Px_Remit__c>();

    List<Int_Px_Remit__c> remitList = new List<Int_Px_Remit__c>();
    remitList = [select invoice_number__c
            ,transaction_type__c
            ,transaction_amount__c
            from Int_Px_Remit__c
            where invoice_number__c in :invoiceSet
            ];
    for (Int_Px_Remit__c r:remitList){
        remitMap.put(r.invoice_number__c,r);
    }       

    for (PNC_Recon_Detail__c d:trigger.new){
        Int_Px_Remit__c r = remitMap.get(d.invoice_number__c);
         
        boolean error = false;
        if (r == null){
            d.status__c = 'Invoice missing from remit files';
            error=true;
        }
        else{
            d.int_px_remit__c = r.id;
            if (d.invoice_payment__c != r.transaction_amount__c){
                d.status__c = 'Payment amount does not match';
            }
            if (d.confirmation_number__c != r.transaction_type__c){
                d.status__c += '; Confirmation numbers do not match';
            }
        }
        if (!error)
            d.status__c = 'OK';
            

    }
}