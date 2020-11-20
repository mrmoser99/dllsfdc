/****************************************************************************
* Application Fee
*
* Log:
*
*   4/24/18 - MRM Created
*
* This will automatically create the application fee payment record
*
******************************************************************************/
trigger ApplicationFee on Application_Fee__c (after insert) {
    
  
    List<Application_Fee__c> aeList = new List<Application_Fee__c>();
    aeList = [  Select  Application__c
                    ,   Application__r.genesis__account__c
                    ,   fee__r.name 
                    ,   fee_name__c
                    ,   total_payment_amount__c
                    ,   Fee__c 
                From Application_Fee__c  
                where id in :trigger.newmap.keyset() ];
    List<Application_Fee_Payment__c> insertFeePaymentList = new List<Application_Fee_Payment__c>();
    Set<ID> appIds = new Set<ID>();
    
    Map<ID,ID> dealerMap = new Map<ID,ID>();
    
    for (Application_Fee__c a:trigger.new)
        appIds.add(a.application__c);
    
    List<clcommon__Party__c> pList = new List<clcommon__Party__c>();    
    pList = [select id 
                , genesis__application__c 
                from  clcommon__Party__c
                where party_type_name__c = 'DEALER'
                and genesis__application__c in :appIds];
    for ( clcommon__Party__c p:pList)
        dealerMap.put(p.genesis__application__c,p.id);  
    
            
    for (Application_Fee__c f:aeList){
        if (f.fee__r.name == 'Service Fees'){
            Application_Fee_Payment__c afp = new Application_Fee_Payment__c();
            afp.application__c = f.application__c;
            afp.Payment_Percentage__c = 100.00;
            afp.pay_to__c = dealerMap.get(f.application__c);
            afp.application_fee__c = f.id;
            insertFeePaymentList.add(afp);
        }
    }
    
    if (!insertFeePaymentList.isEmpty())
        insert insertFeePaymentList; 
}