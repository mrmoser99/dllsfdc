public with sharing class ChargeTriggerHandler{
    Map<Id, cllease__Lease_Account__c> leaseAccounts;
    Set<Id> leaseIds = new Set<Id>();
    List<cllease__Charge__c> chargeList = new List<cllease__Charge__c>();
    public ChargeTriggerHandler(List<cllease__Charge__c> charges){
        for(cllease__Charge__c charge : charges){
            leaseIds.add(charge.cllease__Lease_Account__c);
        }
        leaseAccounts = new Map<Id, cllease__Lease_Account__c>([SELECT ID,
                                                                    cllease__Next_Due_Date__c 
                                                                FROM cllease__Lease_Account__c
                                                                WHERE Id IN : leaseIds]);
        chargeList = charges;
    }
    
    public void process(){
        for(cllease__Charge__c charge : chargeList){
            if(charge.Transaction_SubType_Name__c == 'Late Fees'){
                charge.cllease__Date__c = leaseAccounts.get(charge.cllease__Lease_Account__c).cllease__Next_Due_Date__c ;
            }
        }
    }
}