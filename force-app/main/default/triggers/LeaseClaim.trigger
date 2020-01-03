trigger LeaseClaim on Lease_Claims__c (before insert, before update) {

    Map<String,String> leaseAccount = new Map<String,String>();
    Set<ID> leaseSet = new Set<ID>();    

     for (Lease_Claims__c c:trigger.new)
        leaseSet.add(c.lease__c);


    List<cllease__Lease_Account__c	> cList = new List<cllease__Lease_Account__c>();

    cList = [select id, cllease__account__c 
            from cllease__Lease_Account__c	 
            where id in :leaseSet
            ];

    for (cllease__Lease_Account__c	 con:cList){
        leaseAccount.put(con.id, con.cllease__account__c);

    }
    
    for (Lease_Claims__c c:trigger.new)
       c.account__c = leaseAccount.get(c.lease__c);
    
}