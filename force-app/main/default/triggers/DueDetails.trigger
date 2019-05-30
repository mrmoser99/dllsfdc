trigger DueDetails on cllease__Due_Detail_Lines__c (before insert, before update) {
    
    Set<ID> billIdSet = new Set<ID>();

    for (cllease__Due_Detail_Lines__c d:trigger.new){
        billIdSet.add(d.cllease__Bill__c);
    }

    List<cllease__Lease_account_Due_Details__c> bList = [select id
                                    ,Invoiced_In__c
                                    from
                                    cllease__Lease_account_Due_Details__c
                                    where id in :billIdSet
                                    ];

    Map<ID,ID> billIdInvoiceMap = new Map<ID,ID>();
    for (cllease__Lease_account_Due_Details__c b:blist)
        billidInvoiceMap.put(b.id,b.Invoiced_In__c);

    for (cllease__Due_Detail_Lines__c d:trigger.new){
        d.invoice__c = billIdInvoiceMap.get(d.cllease__bill__c);
    }
    
}