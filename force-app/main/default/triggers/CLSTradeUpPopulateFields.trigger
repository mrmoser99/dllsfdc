trigger CLSTradeUpPopulateFields on genesis__Quick_Quotes__c (After insert, After Update) {
    Savepoint sp = Database.setSavepoint();
    genesis__Quick_Quotes__c quickQuote = trigger.new[0];
    genesis__Quick_Quotes__c oldQuickQuote;
    genesis__Quick_Quotes__c quickQuote1 = new genesis__Quick_Quotes__c();
    quickQuote1.id = quickQuote.id;
    quickQuote1.CLS_Trade_Up_Quote_Number__c = quickQuote.CLS_Trade_Up_Quote_Number__c;
    
    List<cllease__Termination_Quote_Header__c> quoteHeader;
    
    try{
        if(trigger.isUpdate){
           oldQuickQuote = Trigger.oldMap.get(quickQuote.id);
            if(quickQuote.CLS_Trade_Up_Quote_Number__c != oldQuickQuote.CLS_Trade_Up_Quote_Number__c){
                if(quickQuote.CLS_Trade_Up_Quote_Number__c !=null){
                    quoteHeader = [select id,name,cllease__Effective_To__c,cllease__Status__c,cllease__Quote_Amount__c,cllease__Contract__r.name from cllease__Termination_Quote_Header__c
                                                                               where id=:quickQuote1.CLS_Trade_Up_Quote_Number__c];
                    System.debug('quoteHeader ='+quoteHeader); 
                    if(quoteHeader[0].cllease__Effective_To__c>=cllease.SystemDateUtil.getCurrentSystemDate()){
                        if(quickQuote.Trade_Up_From__c!=null && quickQuote.Trade_Up_From__c=='CL Lease' && quoteHeader.size()>0){
                            quickQuote1.CLS_Trade_Up_Lease_Number__c = quoteHeader[0].cllease__Contract__r.name;
                            quickQuote1.CLS_Trade_Up_Quote_Amount__c = quoteHeader[0].cllease__Quote_Amount__c;
                            
                            update quickQuote1;
                        }
                    }else{
                        if(quoteHeader[0].cllease__Effective_To__c<cllease.SystemDateUtil.getCurrentSystemDate()){
                           quickQuote.addError('Outdated Effective-To Date! Can not Process.');
                        }
                    }
                }else{
                    quickQuote1.CLS_Trade_Up_Lease_Number__c ='';
                    quickQuote1.CLS_Trade_Up_Quote_Amount__c = 0.00;
                    
                    update quickQuote1;
                }
               
            }
        }else if(trigger.isInsert){
           if(quickQuote.CLS_Trade_Up_Quote_Number__c !=null){
                    quoteHeader = [select id,name,cllease__Effective_To__c,cllease__Status__c,cllease__Quote_Amount__c,cllease__Contract__r.name from cllease__Termination_Quote_Header__c
                                                                               where id=:quickQuote1.CLS_Trade_Up_Quote_Number__c];
                    System.debug('quoteHeader ='+quoteHeader); 
                    if(quoteHeader[0].cllease__Effective_To__c>=cllease.SystemDateUtil.getCurrentSystemDate()){
                        if(quickQuote.Trade_Up_From__c!=null && quickQuote.Trade_Up_From__c=='CL Lease' && quoteHeader.size()>0){
                            quickQuote1.CLS_Trade_Up_Lease_Number__c = quoteHeader[0].cllease__Contract__r.name;
                            quickQuote1.CLS_Trade_Up_Quote_Amount__c = quoteHeader[0].cllease__Quote_Amount__c;
                            
                            update quickQuote1;
                        }
                    }else{
                        if(quoteHeader[0].cllease__Effective_To__c<cllease.SystemDateUtil.getCurrentSystemDate()){
                           quickQuote.addError('Outdated Effective-To Date! Can not Process.');
                        }
                    }
                }else{
                    quickQuote1.CLS_Trade_Up_Lease_Number__c ='';
                    quickQuote1.CLS_Trade_Up_Quote_Amount__c = 0.00;
                    
                    update quickQuote1;
                }
          }
    }catch(Exception ex){
        Database.rollback(sp);
        quickQuote.addError('Error Message :' + ex.getMessage() + ' Line Number : ' + ex.getLineNumber());
    }
}