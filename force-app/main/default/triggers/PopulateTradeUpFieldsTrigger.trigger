trigger PopulateTradeUpFieldsTrigger on genesis__Applications__c (before update) {
  genesis__Applications__c app = trigger.new[0];
  try{
    List<cllease__Termination_Quote_Header__c> quoteHeader = [select id,name,cllease__Quote_Amount__c,cllease__Contract__r.name from cllease__Termination_Quote_Header__c
                                                               where name=:app.Oracle_Trade_up_Quote_Number__c];
    System.debug('quoteHeader ='+quoteHeader);                                                   
    if(trigger.isUpdate){
       if(app.Oracle_Trade_up_Quote_Number__c!=null && app.Oracle_Trade_up_Quote_Number__c==quoteHeader[0].name){
          app.Oracle_Trade_up_Lease_Number__c = quoteHeader[0].cllease__Contract__r.name;
          app.Oracle_Trade_Up_Amount__c = quoteHeader[0].cllease__Quote_Amount__c;
          System.debug('Oracle_Trade_up_Lease_Number__c=' + app.Oracle_Trade_up_Lease_Number__c);
       }
       
     }
  }catch(Exception ex){
     app.addError('Please enter the correct Quote Number??');
  }
   
}