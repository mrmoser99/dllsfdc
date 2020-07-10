@isTest
public class TestGetTaxonChargesJob {

    // Failed Response  with response : 200
    public static testMethod void testVertexOnCharge() {

        Testhelper.getVertexCustomSettings();

        // Creating Contract using TestHelper     
        cllease__Lease_Account__c leaseContract = TestHelper.createContract();
        system.debug('a idddd'+leaseContract.id);

        // Creating New Address
        Account dummyAccount = [SELECT Id, Name From Account WHERE Name = 'Sample Account'];
        Address__c address = new Address__c();
        address.Country__c = 'USA';
        address.Account__c = dummyAccount.Id;
        address.Bill_To_Usage__c = true;
        address.Install_At__c = true;
        address.Validation_Status__c = DLLNewCoConstants.EXPERIAN_VALIDATION_STATUS;
        insert address;

        // Updating address in contract as billing address
        cllease__Lease_Account__c retrievedContract = [Select Id, Billing_Address__c
                                                        From cllease__Lease_Account__c
                                                        Where Id =: leaseContract.Id];
        retrievedContract.Billing_Address__c = address.Id;
        update retrievedContract;
     
        // Retrieving Attached Equipment for Charge Creation
        cllease__Contract_Equipment__c contractEquipment = [Select Id, Install_Address__c
                                                            From cllease__Contract_Equipment__c
                                                            Where cllease__Contract__c = :leaseContract.Id
                                                            LIMIT 1];
        contractEquipment.Install_Address__c = address.Id;
        contractEquipment.Install_Account__c = dummyAccount.Id;
        update contractEquipment;

        // Creating  Charge with Equipment Linked
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        cllease__Charge__c charge1 = cllease.TestHelper.createUnpaidCharge(leaseContract, dummyFee, 100);
        charge1.cllease__Tax_Processed__c = 'Tax Not Calculated';
        charge1.cllease__Contract_Equipment__c = contractEquipment.id;
        charge1.Tax_Processed__c=false;
        charge1.Tax_Component__c='';
        update charge1;

        // Creating  Charge without Equipment Attached
        cllease__Charge__c charge2 = cllease.TestHelper.createUnpaidCharge(leaseContract, dummyFee, 100);
        charge2.cllease__Tax_Processed__c = 'Tax Not Calculated';
        charge2.Tax_Processed__c=false;
        charge2.Tax_Component__c='';
        update charge2;

        // Running VertexGetTaxonChargesJob job
        System.Test.startTest();
            List<String> contractNames = new List<String>{leaseContract.Name};
            VertexGetTaxonChargesJob job = new VertexGetTaxonChargesJob(contractNames);
            Database.executeBatch(job);
        System.Test.stopTest();

        List<cllease__Charge__c> retrievedCharges = [Select Id, Name, 
                                                    cllease__Tax_Processed__c,
                                                    cllease__Tax_Due__c,
                                                    Tax_CITY__c, Tax_STATE__c, Tax_TRANSIT_DISTRICT__c, Tax_SPECIAL_PURPOSE_DISTRICT__c,
                                                    Tax_Rate_CITY__c, Tax_Rate_STATE__c, Tax_Rate_TRANSIT_DISTRICT__c, Tax_Rate_SPECIAL_PURPOSE_DISTRICT__c
                                            From cllease__Charge__c];

        for(cllease__Charge__c charge : retrievedCharges) {
            //System.assertEquals('Tax Calculated', charge.cllease__Tax_Processed__c, 'Vertex Tax Should processed for the charge...');
            //System.assertEquals(6.18, charge.cllease__Tax_Due__c, 'Vertex Tax Should be 6.18 as it is hardcoded in response...');
            // Validating Tax Values
            /*System.assertEquals(, charge.cllease__Tax_Processed__c, '');
            System.assertEquals(, charge.cllease__Tax_Processed__c, '');
            System.assertEquals(, charge.cllease__Tax_Processed__c, '');
            System.assertEquals(, charge.cllease__Tax_Processed__c, '');*/
            // Validating Tax Rates
            /*System.assertEquals(, charge.cllease__Tax_Processed__c, '');
            System.assertEquals(, charge.cllease__Tax_Processed__c, '');
            System.assertEquals(, charge.cllease__Tax_Processed__c, '');
            System.assertEquals(, charge.cllease__Tax_Processed__c, '');*/
        }    
    }  

    // Failed Response  with response : 500
    public static testMethod void testVertexOnChargeForNegative() {
        Testhelper.getVertexCustomSettings();

        // Creating Contract using TestHelper     
        cllease__Lease_Account__c leaseContract = TestHelper.createContract();
        system.debug('a idddd'+leaseContract.id);

        // Creating New Address
        Account dummyAccount = [SELECT Id, Name From Account WHERE Name = 'Sample Account'];
        Address__c address = new Address__c();
        address.Country__c = 'USA';
        address.Account__c = dummyAccount.Id;
        address.Bill_To_Usage__c = true;
        address.Install_At__c = true;
        address.Validation_Status__c = DLLNewCoConstants.EXPERIAN_VALIDATION_STATUS;
        insert address;

        // Updating address in contract as billing address
        cllease__Lease_Account__c retrievedContract = [Select Id, Billing_Address__c
                                                        From cllease__Lease_Account__c
                                                        Where Id =: leaseContract.Id];
        retrievedContract.Billing_Address__c = address.Id;
        update retrievedContract;
     
        // Retrieving Attached Equipment for Charge Creation
        cllease__Contract_Equipment__c contractEquipment = [Select Id, Install_Address__c
                                                            From cllease__Contract_Equipment__c
                                                            Where cllease__Contract__c = :leaseContract.Id
                                                            LIMIT 1];
        contractEquipment.Install_Address__c = address.Id;
        contractEquipment.Install_Account__c = dummyAccount.Id;
        update contractEquipment;

        // Creating  Charge with Equipment Linked
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        cllease__Charge__c charge1 = cllease.TestHelper.createUnpaidCharge(leaseContract, dummyFee, 100);
        charge1.cllease__Tax_Processed__c = 'Tax Not Calculated';
        charge1.cllease__Contract_Equipment__c = contractEquipment.id;
        charge1.Tax_Processed__c=false;
        charge1.Tax_Component__c='';
        update charge1;

        // Creating  Charge without Equipment Attached
        cllease__Charge__c charge2 = cllease.TestHelper.createUnpaidCharge(leaseContract, dummyFee, 100);
        charge2.cllease__Tax_Processed__c = 'Tax Not Calculated';
        charge2.Tax_Processed__c=false;
        charge2.Tax_Component__c='';
        update charge2;

        // Creating  Charge without Equipment Attached
        cllease__Charge__c charge3 = cllease.TestHelper.createUnpaidCharge(leaseContract, dummyFee, 100);
        charge3.cllease__Tax_Processed__c = 'Tax Not Calculated';
        charge3.Tax_Processed__c=false;
        charge3.Tax_Component__c='';
        update charge3;

        // Running VertexGetTaxonChargesJob job
        System.Test.startTest();
            List<String> contractNames = new List<String>{leaseContract.Name};
            VertexGetTaxonChargesJob job = new VertexGetTaxonChargesJob(contractNames);
            Database.executeBatch(job);
        System.Test.stopTest();

        List<cllease__Charge__c> retrievedCharges = [Select Id, Name, cllease__Remarks__c From cllease__Charge__c];

        System.debug(LoggingLevel.ERROR, ' RetrievedCharges: '+retrievedCharges);
        for(cllease__Charge__c charge : retrievedCharges) {
            System.assert(charge.cllease__Remarks__c.contains('Vertex Tax Batch failed'), 'Charge remarks field should update incase of any failure.');
        }
    } 

    // Validating Vertex API Details and throwing exception
    public static testMethod void testVertexOnChargeAddressValidation() {

        // Creating Contract using TestHelper     
        cllease__Lease_Account__c leaseContract = TestHelper.createContract();
        system.debug('a idddd'+leaseContract.id);
     
        // Retrieving Attached Equipment for Charge Creation
        cllease__Contract_Equipment__c contractEquipment = [Select Id, Install_Address__c
                                                            From cllease__Contract_Equipment__c
                                                            Where cllease__Contract__c = :leaseContract.Id
                                                            LIMIT 1];
        
        // Creating  Charge with Equipment Linked
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        cllease__Charge__c charge1 = cllease.TestHelper.createUnpaidCharge(leaseContract, dummyFee, 100);
        charge1.cllease__Tax_Processed__c = 'Tax Not Calculated';
        charge1.cllease__Contract_Equipment__c = contractEquipment.id;
        charge1.Tax_Processed__c=false;
        charge1.Tax_Component__c='';
        update charge1;

        // Running VertexGetTaxonChargesJob job
        System.Test.startTest();
            List<String> contractNames = new List<String>{leaseContract.Name};
            VertexGetTaxonChargesJob job = new VertexGetTaxonChargesJob(contractNames);
            Database.executeBatch(job);
        System.Test.stopTest();

        List<cllease__Charge__c> retrievedCharges = [Select Id, Name, cllease__Remarks__c From cllease__Charge__c];

        for(cllease__Charge__c charge : retrievedCharges) {
            System.assert(charge.cllease__Remarks__c.contains('Vertex Tax Batch failed'), 'Charge remarks field should update incase of any failure.');
        }
    }
}