trigger VendorPointsPayTo on clcommon__Party__c (After insert) {
  
  Savepoint sp = database.setsavepoint();
  List<clcommon__Party__c> pList = new List<clcommon__Party__c>(); 
  clcommon__Party__c pList1 = new clcommon__Party__c();
  pList1 = trigger.new[0];
  
  try{
    
    List<Application_Fee_Payment__c> insertFeePaymentList = new List<Application_Fee_Payment__c>(); 
       
    pList = [select id 
                ,genesis__application__c,clcommon__Account__c,genesis__application__r.genesis__Vendor__c 
                from  clcommon__Party__c
                where party_type_name__c = 'DEALER'
                and genesis__application__c =:pList1.genesis__application__c];
                                     
    List<Application_Fee__c> aeList = new List<Application_Fee__c>();
    aeList = [Select  Application__c
                    ,   Application__r.genesis__account__c
                    ,   fee__r.name 
                    ,   fee_name__c
                    ,   total_payment_amount__c
                    ,   Fee__c 
                From Application_Fee__c  
                where Application__c=:pList1.genesis__application__c and fee__r.name='Vendor Points'];
    
                           
    Map<ID,ID> VendorMap = new Map<ID,ID>();           
    for ( clcommon__Party__c p:pList){
        if(p.clcommon__Account__c==p.genesis__application__r.genesis__Vendor__c){
            VendorMap.put(p.genesis__application__c,p.id);
        }
    }
    
    insertFeePaymentList.clear();
    if(aeList.size()>0){
      for (integer i=0;i<aeList.size();i++){
       
       if(!VendorMap.isEmpty()){
            Application_Fee_Payment__c afp1 = new Application_Fee_Payment__c();
            afp1.application__c = aeList[i].application__c;
            afp1.Payment_Percentage__c = 100.00;
            afp1.pay_to__c = VendorMap.get(aeList[i].application__c);
            afp1.application_fee__c = aeList[i].id;
            insertFeePaymentList.add(afp1);
       }
            
      }
      
      if (!insertFeePaymentList.isEmpty()){
         insert insertFeePaymentList; 
         
      }
        
    }
    
   }catch(Exception ex){
       database.rollback(sp);
       System.debug('Exception : ' + ex + ' Error Message  :' +ex.getMessage());       
       pList1.addError('Exception :'+ ex.getMessage() + ' LineNumber :' +ex.getLineNumber());
       
   }
    

}