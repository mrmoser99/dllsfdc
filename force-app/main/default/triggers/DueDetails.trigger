/* 9/19/19 - MRM - change ref of invoiced_in__c to cllease__Consolidated_Invoice__c */
/* 10/4/19 - MRM - change to add service fees for special dll rent calc of rent + servic for invoicing */


trigger DueDetails on cllease__Due_Detail_Lines__c (before insert, before update) {
    
    Set<ID> billIdSet = new Set<ID>();
    Set<ID> ceSet = new Set<ID>();
    Set<ID> invSet = new Set<ID>();

    for (cllease__Due_Detail_Lines__c d:trigger.new){
        billIdSet.add(d.cllease__Bill__c);
        ceSet.add(d.cllease__Contract_Equipment__c);
        invSet.add(d.consolidated_invoice__c);
    }

    List <cllease__Charge__c> chargeList = new List<cllease__Charge__c>
    (
        [select cllease__Original_Amount__c
               ,Original_Tax_Amount__c
               ,cllease__Contract_Equipment__c
               ,cllease__Consolidated_Invoice__c
        from cllease__charge__c
        where (cllease__Contract_Equipment__c in :ceSet
        or cllease__Consolidated_Invoice__c in :invSet)
        and cllease__Fee_Definition__r.name = 'Service Fees'
        ]
    );


    List<cllease__Lease_account_Due_Details__c> bList = [select id
                                    ,cllease__Consolidated_Invoice__c
                                    from
                                    cllease__Lease_account_Due_Details__c
                                    where id in :billIdSet
                                    ];

    for (cllease__Due_Detail_Lines__c d:trigger.new){
        system.debug('*** calculating service fees');
        Decimal serviceFees = 0.0;
        Decimal serviceTax = 0.0;
        for (cllease__charge__c ch:chargeList){
            if  (d.cllease__Contract_Equipment__c == ch.cllease__Contract_Equipment__c &&
            d.Consolidated_Invoice__c == ch.cllease__Consolidated_Invoice__c){
                serviceFees = serviceFees + ch.cllease__Original_Amount__c;
                serviceTax = serviceTax + ch.Original_Tax_Amount__c;
                system.debug('adding service fee: ' + serviceFees);
            }
        }
        d.dll_service__c = serviceFees;
        d.dll_service_tax__c = serviceTax;
    }

    Map<ID,ID> billIdInvoiceMap = new Map<ID,ID>();
    for (cllease__Lease_account_Due_Details__c b:blist)
        billidInvoiceMap.put(b.id,b.cllease__Consolidated_Invoice__c);

    for (cllease__Due_Detail_Lines__c d:trigger.new){
        d.consolidated_invoice__c = billIdInvoiceMap.get(d.cllease__bill__c);
    }

}