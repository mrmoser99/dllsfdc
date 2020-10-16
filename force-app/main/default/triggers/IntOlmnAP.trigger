/*********************************************************************************************
*
* INT OLMN AP Trigger
*
* Change Log:
*
* 9/23/2020 - MRM Created cls creates duplicates in the ap file.. this prevents them
* 10/9/2020 - MRM Removed Delete
*
**********************************************************************************************/
trigger IntOlmnAP on Int_OLMN_AP__c (after insert) {

    Set<String> duplicateLeaseSet = new Set<String>();
    for (Int_OLMN_AP__c a:trigger.new)
        duplicateLeaseSet.add(a.contract_number__c);
    
    //find dups in database for contract
    List<Int_OLMN_AP__c> dupList = new List<Int_OLMN_AP__c>();
    dupList = [select contract_number__c
                ,invoice_number__c
                ,invoice_amount__c
                from Int_OLMN_AP__c
                where contract_number__c in :duplicateLeaseSet
                and id not in :trigger.newMap.keySet()  
                ];
    system.debug('dup list: ' + dupList);
     
    Set<String> duplicateCompositeKeySet = new Set<String>();
    //add a composit key set
    for (Int_OLMN_AP__c d: dupList){
        duplicateCompositeKeyset.add(d.Contract_Number__c + '-' + d.Invoice_Number__c + '-' + string.valueOf(d.Invoice_Amount__c));
    }
    system.debug('dup composite:' + duplicateCompositeKeySet);
        
    Map<ID,String> apMap = new Map<ID,String>();
    
    //for each new record see if it is in composite set...if so delete it
    for (Int_OLMN_AP__c a:trigger.new){
         
            if (duplicateCompositeKeySet.contains(a.Contract_Number__c + '-' + a.Invoice_Number__c + '-' + string.valueOf(a.Invoice_Amount__c)) ){
                apMap.put(a.id,'Delete');
            }
        
    }    

    //if (!apMap.isEmpty())
    //    NewCoUtility.deleteAP(apMap);

}