/****************************************************************************
* Contract Trigger
*
* Log:
*
*   5/4/18 - MRM Created
*   10/1/18 - MRM Added line to call icv booking flow
*   5/8/19 - MRM fix send welcome packet error when processing payment
* This trigger sends off a welcome packet when the contract is booked
*   05/11/19 - CLS modified to support canceled contract as part new inovice changes
*   2/4/2020 - modify welcome packet send
*   7/9/2020 - MRM made our system work again after Q2 hacked and did not test
*
******************************************************************************/
trigger clleaseLeaseAccount on cllease__Lease_Account__c (before update) {
    
    // Updating invoiced flag on bills and charges Codes Starts here
    Set<Id> canceledContractsIds = new Set<Id>();
    
    for(cllease__Lease_Account__c contract : trigger.new){
        System.debug('-----------------contract created in clleaseLeaseAccount : '+contract.cllease__Lease_Status__c);
        if(contract.cllease__Lease_Status__c == 'CANCELED'
            || contract.cllease__Lease_Status__c == 'CHARGED OFF'){
                canceledContractsIds.add(contract.Id);
           }
    }
    
    if(canceledContractsIds.size() > 0) {
        updateInvoiceDetails(canceledContractsIds);
    }
    // Updating invoiced flag on bills and charges Codes end 
   
    //only send welcome packet if this is a single lease update
    if (trigger.new.size() == 1){
        system.debug('evaluate welcome flag');
        Map<ID,String> leaseMap = new Map<ID,String>(); 
         if  (
             (!trigger.old[0].cllease__Lease_Status__c.contains('ACTIVE') 
             && trigger.new[0].cllease__Lease_Status__c.contains('ACTIVE') ) 
        
        || (trigger.old[0].welcome_package_requested__c == false &&
            trigger.new[0].welcome_package_requested__c == true)
            )
        { 
            if(trigger.old[0].welcome_package_requested__c == false 
            &&  trigger.new[0].welcome_package_requested__c == true){
               system.debug('welcome packet on the way');
                trigger.new[0].welcome_package_requested__c = false;
                leaseMap.put(trigger.new[0].id,'Welcome');
                NewCoUtility.sendWelcomePacket(leaseMap);
            }
        }
        
        if  (!trigger.old[0].cllease__Lease_Status__c.contains('ACTIVE') 
            && trigger.new[0].cllease__Lease_Status__c.contains('ACTIVE')){
                Map<ID,String> leaseMap2 = new Map<ID,String>();
                leaseMap2.put(trigger.new[0].id,'Hello');
                //superTrumpUtil.sendRequest(leaseMap2);
                if (!Test.isRunningTest()){
                    ICVAsyncBookLease job = new ICVAsyncBookLease(trigger.new[0].id);  
                    System.enqueueJob(job);
                } 
        } 
        
    }
    
    public void updateInvoiceDetails(Set<Id> canceledContractsIds){
        List<cllease__Charge__c> charges = [SELECT ID, 
                                                    cllease__Invoiced__c 
                                                FROM cllease__Charge__c 
                                                WHERE cllease__Lease_Account__c IN : canceledContractsIds
                                                AND cllease__Invoiced__c = false];
        for(cllease__Charge__c charge : charges){
            charge.cllease__Invoiced__c =true;
        }
        update charges;
        
        List<cllease__Lease_account_Due_Details__c> dues = [SELECT ID, 
                                                                    cllease__Invoiced__c 
                                                                FROM cllease__Lease_account_Due_Details__c 
                                                                WHERE cllease__Lease_Account__c IN : canceledContractsIds
                                                                AND cllease__Invoiced__c = false];
        for(cllease__Lease_account_Due_Details__c due : dues){
            due.cllease__Invoiced__c = true;
        }
        update dues;
    }
}