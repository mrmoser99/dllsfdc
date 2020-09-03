@isTest
public class FMZ_ApplicationEquipmentControllerTest {

    @TestSetup
    static void setupApp() {

        cllease__Office_Name__c office = new cllease__Office_Name__c (
                cllease__Office_Short_Name__c = 'HQ',
                cllease__tax_method__c = 'Exclusive',
                Name = 'sample Company'
        );
        insert office;

        clcommon__Legal_Entity__c lentity = new clcommon__Legal_Entity__c(Name = 'Corporation');
        insert lentity;

        Account acc = new Account(
                Name = 'sample Account',
                clcommon__Legal_Entity_Type__c = lentity.Id,
                EIN__c = '12-1234567',
                Email_Address__c = 'abc123@gmail.com',
                Oracle_Vendor_ID__c = 'Y795'
        );
        insert acc;

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
                genesis__Product_Type__c = 'LEASE',
                genesis__Product_Sub_Type__c = 'FINANCE LEASE',
                genesis__Term__c = 12,
                Dealer_Program__c = agreement.Id
        );
        insert app;

    }

    static testMethod void app_getEquipment_retrieved() {

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

        Test.startTest();

        appEquipment = FMZ_ApplicationEquipmentController.getEquipment(app.Id);

        System.assertEquals(3, appEquipment.size());

        Test.stopTest();

    }

    static testMethod void app_seachEquipment_found() {

        List<genesis__Equipment_Master__c> equipment = new List<genesis__Equipment_Master__c>{
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'Printer', MSRP__c = 999.99),
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'Copier', MSRP__c = 1299.99),
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'MFP', MSRP__c = 799.99)
        };
        insert equipment;

        Test.startTest();

        Test.setFixedSearchResults(new List<String>{
                equipment[0].Id, equipment[1].Id, equipment[2].Id
        });

        List<LookupSearchResult> results = FMZ_ApplicationEquipmentController.search('Printer', new List<String>());

        System.assertEquals(3, results.size());

        Test.stopTest();

    }

    static testMethod void app_addEquipment_added() {

        genesis__Applications__c app = [SELECT Id, genesis__Account__c FROM genesis__Applications__c];

        List<genesis__Equipment_Master__c> equipment = new List<genesis__Equipment_Master__c>{
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'Printer', MSRP__c = 999.99),
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'Copier', MSRP__c = 1299.99),
                new genesis__Equipment_Master__c (Manufacturer__c = 'TestCo', Product_Type__c = 'MFP', MSRP__c = 799.99)
        };
        insert equipment;

        Test.startTest();

        FMZ_ApplicationEquipmentController.addEquipment(app.Id, equipment[1].Id);

        Test.stopTest();

        genesis__Application_Equipment__c appEquipment =
            [SELECT Id, genesis__Application__c, genesis__Equipment__c, Install_Account__c, Install_Address1__c
            FROM genesis__Application_Equipment__c];

        System.assertEquals(app.Id, appEquipment.genesis__Application__c);
        System.assertEquals(equipment[1].Id, appEquipment.genesis__Equipment__c);
        System.assertEquals(app.genesis__Account__c, appEquipment.Install_Account__c);
        System.assertNotEquals(null, appEquipment.Install_Address1__c);

    }

    static testMethod void app_deleteEquipment_deleted() {

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

        Test.startTest();

        FMZ_ApplicationEquipmentController.deleteEquipment(appEquipment[2].Id);

        genesis__Application_Equipment__c deleted =
            [SELECT Id FROM genesis__Application_Equipment__c WHERE IsDeleted = TRUE ALL ROWS];

        System.assertEquals(appEquipment[2].Id, deleted.Id);

        Test.stopTest();

    }

    static testMethod void app_updateEquipment_updated() {

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

        Test.startTest();

        String equipmentString = '{"Id":"' + appEquipment[0].Id + '", "Serial_Number__c":"ABC123"}';

        FMZ_ApplicationEquipmentController.updateEquipment(equipmentString);

        genesis__Application_Equipment__c updated =
            [SELECT Id, Serial_Number__c
            FROM genesis__Application_Equipment__c
            WHERE Id = :appEquipment[0].Id];

        System.assertEquals('ABC123', updated.Serial_Number__c);

        Test.stopTest();

    }

    static testMethod void app_getInstallAddresses_retrieved() {

        genesis__Applications__c app = [SELECT Id, genesis__Account__c FROM genesis__Applications__c];

        List<Address__c> installAddresses = FMZ_ApplicationEquipmentController.getInstallationAddresses(app.Id);

        System.assertEquals(1, installAddresses.size());

    }

}