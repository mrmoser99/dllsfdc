@isTest 
public class FMZ_ApplicationServiceAndFeesContrTest {
    @TestSetup
    static void setupApp() {

        cllease__Office_Name__c office = new cllease__Office_Name__c (
                cllease__Office_Short_Name__c = 'HQ',
                Name = 'sample Company'
        );
        insert office;

        clcommon__Billing_Group__c billGroup = new clcommon__Billing_Group__c(Name = 'Default Bill Group');
        insert billGroup;

        clcommon__Legal_Entity__c lentity = new clcommon__Legal_Entity__c(Name = 'Corporation');
        insert lentity;

        system.debug('*************** tring to insert account');

        Account acc = new Account(
                Name = 'sample Account',
                clcommon__Legal_Entity_Type__c = lentity.Id,
                EIN__c = '12-1234567',
                Email_Address__c = 'abc123@gmail.com',
                Oracle_Vendor_ID__c = 'Y795'
        );
        insert acc;

        system.debug('*************** tring to insert account2');

        Address__c installAddress = new Address__c (
                Account__c = acc.Id,
                Install_At__c = true
        );
        insert installAddress;

        clcommon__Agreement__c agreement = new clcommon__Agreement__c(Name = 'NewCo');
        insert agreement;

        genesis__Applications__c app = new genesis__Applications__c (
                genesis__Account__c = acc.Id,
                Payment_Method__c = 'ADVANCE',
                genesis__Payment_Frequency__c = 'MONTHLY',
                genesis__Expected_Start_Date__c = Date.today(),
                genesis__Expected_First_Payment_Date__c = Date.today(),
                genesis__Product_Type__c = 'LEASE',
                genesis__Product_Sub_Type__c = 'FINANCE LEASE',
                genesis__Term__c = 12,

                Customer_Provided_Insurance__c = true,
                Dealer_Program__c = agreement.Id
        );
        insert app;

        clcommon__Fee_Definition__c f = new clcommon__fee_definition__c ( Name = 'Service Fees');
        f.clcommon__calculation_method__c = 'Fixed';
        f.clcommon__class__c = 'Income';
        f.clcommon__fee_type__c = 'Evergreen;Passthrough';
        f.clcommon__include_in_dues__c = true;
        f.clcommon__Passthrough_Event__c	= 'On Partial Payment';
        f.clcommon__type__c = 'OTHER FEES';
        f.clcommon__Withhold_Basis__c = 'Amount';
        f.clcommon__Withhold_Value__c	 = 0;
        f.clcommon__Minimum_Amount__c	 = 10;
        f.clcommon__Maximum_Amount__c = 0;
        f.clcommon__amount__c = 0;


        //insert f;

       /*  Service_Fee_Escalation_Config__c c = new Service_Fee_Escalation_Config__c();
            
            c.application__c = app.id;
            c.number_of_payments__c = 12;
            c.frequency__c = 'Monthly';
            c.start_date__c = date.today();
            c.is_service_escalate__c = 'NO';
            c.amount__c = 0;

            
           
             
            
            
          
            insert c; */

    }


    static testMethod void testGetFees() {
        genesis__Applications__c app = [SELECT Id, genesis__Account__c FROM genesis__Applications__c];

        clcommon__Fee_Definition__c feeDef = new clcommon__Fee_Definition__c(clcommon__Amount__c = 300, Name ='Test Fee', clcommon__Class__c = 'Income');
        insert feeDef;
        
        
        Application_Fee__c appFees =new Application_Fee__c (Amount__c = 100, Fee_Amount__c = 200, Application__c = app.id, Fee__c = feeDef.id);
        insert appFees;
        
        List<Application_Fee__c> result = FMZ_ApplicationServiceAndFeesController.getFees(app.id);
        
        System.assertEquals(100, result[0].Amount__c);
        
    }
    
    static testMethod void testEquipmentOptions(){
        genesis__Applications__c app = [SELECT Id, genesis__Account__c FROM genesis__Applications__c];
        
        List<genesis__Equipment_Master__c> equipment = new List<genesis__Equipment_Master__c>{
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'Printer', MSRP__c = 999.99),
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'Copier', MSRP__c = 1299.99),
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'MFP', MSRP__c = 799.99)
        };
        insert equipment;
        
        List<genesis__Application_Equipment__c> appEquipment = new List<genesis__Application_Equipment__c>{
            new genesis__Application_Equipment__c(genesis__Application__c = app.Id, genesis__Equipment__c = equipment[0].Id,
                Install_Account__c = app.genesis__Account__c),
            new genesis__Application_Equipment__c(genesis__Application__c = app.Id, genesis__Equipment__c = equipment[1].Id,
                Install_Account__c = app.genesis__Account__c),
            new genesis__Application_Equipment__c(genesis__Application__c = app.Id, genesis__Equipment__c = equipment[2].Id,
                Install_Account__c = app.genesis__Account__c)
        };
        insert appEquipment;
        
        List<FMZ_CommunityServices.PicklistOption> options = FMZ_ApplicationServiceAndFeesController.getEquipmentOptions(app.id);
        
        System.assertEquals(appEquipment[0].id, options[0].value);
        System.assertEquals(appEquipment[1].id, options[1].value);
        System.assertEquals(appEquipment[2].id, options[2].value);
    }
    
    static testMethod void testGetApp(){
        
        genesis__Applications__c app = [SELECT Id, genesis__Account__c, Customer_Provided_Insurance__c FROM genesis__Applications__c];
        
        app.Customer_Provided_Insurance__c = false;
        update app;
        
        genesis__Applications__c updateApp = FMZ_ApplicationServiceAndFeesController.getApp(app.id);
        
        System.assertEquals(false, updateApp.Customer_Provided_Insurance__c);
        
        
    }
    
    static testMethod void testGetFeeName(){
        genesis__Applications__c app = [SELECT Id, genesis__Account__c FROM genesis__Applications__c];

        clcommon__Fee_Definition__c feeDef = new clcommon__Fee_Definition__c(clcommon__Amount__c = 300, Name ='Test Fee', clcommon__Class__c = 'Income');
        insert feeDef;

        String feeDefName = FMZ_ApplicationServiceAndFeesController.getFeeName(feeDef.id);
        
        System.assertEquals('Test Fee', feeDefName);

    }
    
    static testMethod void testAddFee(){
        genesis__Applications__c app = [SELECT Id, genesis__Account__c FROM genesis__Applications__c];

        clcommon__Fee_Definition__c feeDef = new clcommon__Fee_Definition__c(clcommon__Amount__c = 300, Name ='Test Fee', clcommon__Class__c = 'Income');
        insert feeDef;

        FMZ_ApplicationServiceAndFeesController.addFees(app.id, feeDef.id);
        
        Application_Fee__c appFee = [Select Application__c, Fee__c from Application_Fee__c];

        System.assertEquals(feeDef.id, appFee.Fee__c);
        System.assertEquals(app.id, appFee.Application__c);

    }
    
    static testMethod void testAddAllFee(){
        genesis__Applications__c app = [SELECT Id, genesis__Account__c FROM genesis__Applications__c];
        
        List<genesis__Equipment_Master__c> equipment = new List<genesis__Equipment_Master__c>{
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'Printer', MSRP__c = 999.99),
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'Copier', MSRP__c = 1299.99),
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'MFP', MSRP__c = 799.99)
        };
        insert equipment;
        
        List<genesis__Application_Equipment__c> appEquipment = new List<genesis__Application_Equipment__c>{
            new genesis__Application_Equipment__c(genesis__Application__c = app.Id, genesis__Equipment__c = equipment[0].Id,
                Install_Account__c = app.genesis__Account__c),
            new genesis__Application_Equipment__c(genesis__Application__c = app.Id, genesis__Equipment__c = equipment[1].Id,
                Install_Account__c = app.genesis__Account__c),
            new genesis__Application_Equipment__c(genesis__Application__c = app.Id, genesis__Equipment__c = equipment[2].Id,
                Install_Account__c = app.genesis__Account__c)
        };
        insert appEquipment;
        
        List<String> equipmentList = new List<String>();
        for(genesis__Application_Equipment__c equip : appEquipment){
            equipmentList.add(equip.id);
        }

        clcommon__Fee_Definition__c feeDef = new clcommon__Fee_Definition__c(clcommon__Amount__c = 300, Name ='Service Fees', clcommon__Class__c = 'Income');
        insert feeDef;

        Application_Fee__c appFees =new Application_Fee__c (Amount__c = 100, Number_of_Payments__c = 12, Frequency__c = 'MONTHLY', Fee_Amount__c = 100, Application__c = app.id, Fee__c = feeDef.id);
        insert appFees;

        Application_Fee__c appFees2 =new Application_Fee__c (Amount__c = 200, Number_of_Payments__c = 12, Frequency__c = 'MONTHLY', Fee_Amount__c = 200, Application__c = app.id, Fee__c = feeDef.id);
        //FMZ_ApplicationServiceAndFeesController.addAllFees(appFees2, null);

        FMZ_ApplicationServiceAndFeesController.addAllFees(appFees, equipmentList);
        FMZ_ApplicationServiceAndFeesController.addAllFees(appFees2, equipmentList);
        
        List<Application_Fee__c> appFeeValues = [Select Application__c, Fee__c, Equipment__c from Application_Fee__c];
        
        System.assertEquals(7, appFeeValues.size());
    }
    
    static testMethod void testDeleteFee(){
        genesis__Applications__c app = [SELECT Id, genesis__Account__c FROM genesis__Applications__c];

        List<genesis__Equipment_Master__c> equipment = new List<genesis__Equipment_Master__c>{
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'Printer', MSRP__c = 999.99),
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'Copier', MSRP__c = 1299.99),
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'MFP', MSRP__c = 799.99)
        };
        insert equipment;

        List<genesis__Application_Equipment__c> appEquipment = new List<genesis__Application_Equipment__c>{
                new genesis__Application_Equipment__c(genesis__Application__c = app.Id, genesis__Equipment__c = equipment[0].Id,
                        Install_Account__c = app.genesis__Account__c),
                new genesis__Application_Equipment__c(genesis__Application__c = app.Id, genesis__Equipment__c = equipment[1].Id,
                        Install_Account__c = app.genesis__Account__c),
                new genesis__Application_Equipment__c(genesis__Application__c = app.Id, genesis__Equipment__c = equipment[2].Id,
                        Install_Account__c = app.genesis__Account__c)
        };
        insert appEquipment;

        List<String> equipmentList = new List<String>();
        for(genesis__Application_Equipment__c equip : appEquipment){
            equipmentList.add(equip.id);
        }

        clcommon__Fee_Definition__c feeDef = new clcommon__Fee_Definition__c(clcommon__Amount__c = 300, Name ='Service Fees', clcommon__Class__c = 'Income');
        insert feeDef;

        Application_Fee__c appFees =new Application_Fee__c (Amount__c = 100, Number_of_Payments__c = 12, Frequency__c = 'MONTHLY', Fee_Amount__c = 100, Application__c = app.id, Fee__c = feeDef.id);
        insert appFees;

        Application_Fee__c appFees2 =new Application_Fee__c (Amount__c = 200, Number_of_Payments__c = 12, Frequency__c = 'MONTHLY', Fee_Amount__c = 200, Application__c = app.id, Fee__c = feeDef.id);
        //FMZ_ApplicationServiceAndFeesController.addAllFees(appFees2, null);

        FMZ_ApplicationServiceAndFeesController.addAllFees(appFees, equipmentList);
        FMZ_ApplicationServiceAndFeesController.addAllFees(appFees2, equipmentList);

        List<Application_Fee__c> appFeeValues = [Select Application__c, Fee__c, Equipment__c from Application_Fee__c WHERE Equipment__c != null];
        List<Application_Fee_Payment__c> appFeePayments = new List<Application_Fee_Payment__c>();
        for(Application_Fee__c fee : appFeeValues){
            Application_Fee_Payment__c appFeePayment = new Application_Fee_Payment__c();
            appFeePayment.Application__c = app.id;
            appFeePayment.Application_Fee__c = fee.id;
            appFeePayments.add(appFeePayment);
        }
        
        insert appFeePayments;
        
        FMZ_ApplicationServiceAndFeesController.deleteFee(appFeeValues[0].id);
        
        List<Application_Fee__c> appFee = [Select Application__c, Fee__c from Application_Fee__c WHERE Id =: appFeeValues[0].Id];
        List<Application_Fee_Payment__c> appPayments = [Select Id FROM Application_Fee_Payment__c WHERE Application_Fee__c =: appFeeValues[0].Id];
        
        System.assertEquals(0, appFee.size());
        System.assertEquals(0, appPayments.size());
    }

    static testMethod void testUpdateApp(){
        genesis__Applications__c app = [SELECT Id, genesis__Account__c FROM genesis__Applications__c];

        FMZ_ApplicationServiceAndFeesController.updateApplication(app.Id, true);

        System.assertEquals(true, [SELECT Id, Customer_Provided_Insurance__c FROM genesis__Applications__c].Customer_Provided_Insurance__c);
    }
    
    static testMethod void testUpdateFee(){
        genesis__Applications__c app = [SELECT Id, genesis__Account__c FROM genesis__Applications__c];

        clcommon__Fee_Definition__c feeDef = new clcommon__Fee_Definition__c(clcommon__Amount__c = 300, Name ='Test Fee', clcommon__Class__c = 'Income');
        insert feeDef;
        
        Application_Fee__c appFees =new Application_Fee__c (Amount__c = 100, Fee_Amount__c = 200, Application__c = app.id, Fee__c = feeDef.id);
        insert appFees;
        
        List<Application_Fee__c> appFeeUpdated = [Select Application__c, Fee_Amount__c, Amount__c, Fee__c from Application_Fee__c];
        
        appFeeUpdated[0].Fee_Amount__c = 300;
        
        String jsonstr = JSON.serialize(appFeeUpdated[0]);

        System.debug('jsonstr--------------------------------'+jsonstr);
        
        FMZ_ApplicationServiceAndFeesController.updateFee(jsonstr);
        
        List<Application_Fee__c> appFeeUpdated1 = [Select Application__c, Fee_Amount__c, Amount__c, Fee__c from Application_Fee__c];
        
        System.assertEquals(300, appFeeUpdated1[0].Fee_Amount__c);
        
        
    }

    public static testMethod void searchTest(){
        clcommon__Fee_Definition__c feeDef = new clcommon__Fee_Definition__c(
                Name = 'Origination Fees',
                clcommon__Class__c = 'Expense',
                clcommon__Amount__c = 75.00);
        insert feeDef;
        clcommon__Fee_Definition__c feeDef2 = new clcommon__Fee_Definition__c(
                Name = 'Insurance Fees',
                clcommon__Class__c = 'Expense',
                clcommon__Amount__c = 75.00);
        insert feeDef2;

        List<LookupSearchResult> lsrs = FMZ_ApplicationServiceAndFeesController.search('Origination Fee', new List<String>());
        List<LookupSearchResult> lsrs2 = FMZ_ApplicationServiceAndFeesController.search('Insurance Fee', new List<String>());

        System.assertNotEquals(null, lsrs);
        System.assertNotEquals(null, lsrs2);
        System.assertEquals(0, lsrs2.size());
    }

    public static testMethod void getPicklistOptions(){
        List<FMZ_CommunityServices.PicklistOption> options = FMZ_ApplicationServiceAndFeesController.getPicklistOptions('Frequency__c');

        System.assertNotEquals(null, options);
        System.assert(options.size() > 0);
    }

}