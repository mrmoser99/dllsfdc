@isTest
public class TestcalculateEstPropertyTax {
  
    public static testMethod void test_calculateEstPropertyTax(){
        
    cllease__Office_Name__c office = new cllease__Office_Name__c(cllease__Office_Short_Name__c='HQ',Name='sample Company',cllease__tax_method__c = 'Exclusive');
    insert office;    
    clcommon__Legal_Entity__c lentity = new clcommon__Legal_Entity__c(name='Corporation');
    insert lentity;    
    Account acc = new Account(name='sample Account',clcommon__Legal_Entity_Type__c=lentity.Id,
                              EIN__c='123456798',Email_Address__c='abc123@gmail.com',
                              Oracle_Vendor_ID__c='Y795');
    insert acc;
    clcommon__Agreement__c agreement = new clcommon__Agreement__c(name='NewCo');
    insert agreement;
 
    genesis__Applications__c app = new  genesis__Applications__c();
    app.Payment_Method__c='ADVANCE'  ;
    app.genesis__Payment_Frequency__c= 'MONTHLY'   ;
    app.genesis__Expected_Start_Date__c=date.today();
    app.genesis__Product_Type__c='LEASE'  ;
    app.genesis__Product_Sub_Type__c='FINANCE LEASE'  ;
    app.genesis__Term__c = 12;
    app.Dealer_Program__c=agreement.id;
    insert app;    
    clcommon__Fee_Definition__c fee = new clcommon__Fee_Definition__c(name='Estimated Property Tax',clcommon__Class__c='Income',clcommon__Amount__c=100);  
    insert fee;
    genesis__Application_Equipment__c appEquip = genesis.TestHelper.createApplicationEquipment(app);
    appEquip.genesis__Estimated_Selling_Price__c=100;
    appEquip.Install_State__c='CA';
    appEquip.Install_Date_Max__c=date.today()-1;    
    update appEquip;
    Application_Fee__c app_fee = new Application_Fee__c();
    app_fee.Application__c=app.id;
    app_fee.Amount__c=50;
    app_fee.Fee__c=fee.Id;
    app_fee.Equipment__c=appEquip.id;
    insert app_fee;
    
    calculateEstPropertyTax.func_calcEPT(app.Id);
   
       
    }
    
}