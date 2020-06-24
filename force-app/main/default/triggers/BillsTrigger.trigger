trigger BillsTrigger on cllease__Lease_account_Due_Details__c (before update, after insert, after update) {
  Set<Id> clAccIds = new Set<Id>();
  Set<Id> billIds = new Set<Id>();
  for (cllease__Lease_account_Due_Details__c childObj : Trigger.new) {
      clAccIds.add(childObj.cllease__Lease_Account__c);
      billIds.add(childObj.Id);
  }
  
  Map<Id, cllease__Lease_account_Due_Details__c> billMap = new Map<Id, cllease__Lease_account_Due_Details__c> 
                                    ([SELECT Id, VertexTax_Computed_DDL_Count__c, cllease__Status__c
                                                                   FROM cllease__Lease_account_Due_Details__c
                                                                    WHERE Id IN :billIds]);
  if(billMap.size() > 0 && Trigger.IsBefore && Trigger.isUpdate) {
      // update the Bill's status as Processed incase of new bill creation # LD-3376	
      for (cllease__Lease_account_Due_Details__c childObj : Trigger.new) {
          Id billId = childObj.Id;
          cllease__Lease_account_Due_Details__c retBill = billMap.get(billId);
          if(retBill.VertexTax_Computed_DDL_Count__c == 0 && retBill.cllease__Status__c != 'In Process') {
              childObj.cllease__Status__c = 'Processed';
          }
      }
      
  }
  
  try{
      BillAndChargeTriggerHandler.afterinsertAndUpdate(clAccIds);
  } catch(exception e){ }

}