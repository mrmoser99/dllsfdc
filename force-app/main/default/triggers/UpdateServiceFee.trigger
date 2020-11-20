trigger UpdateServiceFee on Application_Fee__c (after insert, after update, after delete) {
       if(trigger.isinsert || trigger.isupdate){
          UpdateServiceFeeHandler.func_USF(trigger.new, 'ins-upd');
       }
    
      if(trigger.isdelete){
          UpdateServiceFeeHandler.func_USF(trigger.old,'del');
      }
    
    

}