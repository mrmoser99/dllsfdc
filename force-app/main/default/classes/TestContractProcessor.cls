@isTest
public class TestContractProcessor {
    static Account borrower;
    static cllease__Lease_Product__c dummyLP;

    static cllease__Payment_Mode__c anyPaymentMode;

    @testSetup
    static void setup() {
        cllease.TestHelper.createSeedDataForTesting();
        cllease.TestHelper.integrateWithSFCRM();

        //Create a Fee Set
        clcommon__Fee_Definition__c  dummyFee = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet = cllease.Testhelper.createLeaseFeeSet();
        clcommon__Fee_Junction__c dummyFeeJunction = createLeaseFeeJunction(dummyFee,dummyFeeSet);

        cllease__Office_Name__c dummyOffice = cllease.TestHelper.createOffice();

        //Create a dummy Lease Product
        cllease__Lease_Product__c dummyLeaseProduct = cllease.TestHelper.createLeaseProduct(
                            dummyOffice,
                            dummyFeeSet);
        
        // Creating Default bill group
        clcommon__Billing_Group__c billGroup = new clcommon__Billing_Group__c(Name = 'Default Bill Group');
        insert billGroup;
        
        //Create payment clcommon payment spread
        clcommon__Payment_Spread__c paymentSpread = new clcommon__Payment_Spread__c(clcommon__Spread_Description__c = 'Default Spread', clcommon__Enabled__c = 'Yes', clcommon__Tax_Configuration__c = 'DISTRIBUTE');
        insert paymentSpread; 
        
        // Create GL Account
        cllease__GL_Account__c account = new cllease__GL_Account__c(Name = 'On Account', cllease__Account_Code__c = '5007');
        insert account;
        
        List<clcommon__Payment_Spread_Detail__c> spreadList = new List<clcommon__Payment_Spread_Detail__c>();
        spreadList.add(new clcommon__Payment_Spread_Detail__c(clcommon__Contract_Management_System__c = 'CL-Lease', clcommon__Sequence_Number__c = 1,
                                                              clcommon__Balance_Type__c = 'LEASE RECEIVABLE', clcommon__Enabled__c = 'Yes',
                                                              clcommon__Payment_Spread__c = paymentSpread.Id));
        spreadList.add(new clcommon__Payment_Spread_Detail__c(clcommon__Contract_Management_System__c = 'CL-Lease', clcommon__Sequence_Number__c = 2,
                                                              clcommon__Balance_Type__c = 'FEES', clcommon__Enabled__c = 'Yes',
                                                              clcommon__Payment_Spread__c = paymentSpread.Id));
        insert spreadList;
        
        Account borrowerAccount = new Account(Name = 'Borrower');
        insert borrowerAccount;

    }
    private static void querySetupData() {
        dummyLP = [SELECT Id, Name, cllease__Maturity_Calculation_Base__c
                            FROM cllease__Lease_Product__c
                            WHERE cllease__Lease_Product_Type__c = :cllease.LeaseConstants.LEASE];
        dummyLP.cllease__Maturity_Calculation_Base__c = False;
        update dummyLP;
        borrower = [SELECT Id, Name
                            FROM Account];

    }
    
    public static  clcommon__Fee_Junction__c createLeaseFeeJunction(clcommon__Fee_Definition__c  fee, clcommon__Fee_Set__c  feeSet) {
         clcommon__Fee_Junction__c dummyFeeJunction = new clcommon__Fee_Junction__c(clcommon__Fee__c = fee.ID,
                clcommon__Fee_Set__c  = feeSet.ID);
        if (Schema.sObjectType.clcommon__Fee_Junction__c.isCreateable()) {
            insert dummyFeeJunction;
            return dummyFeeJunction;
        }
        return null;
    }
    
    @isTest
    public static void createContractsInPartialApplication() {
        querySetupData();
        clcommon__Fee_Definition__c fee = [Select Id from clcommon__Fee_Definition__c Limit 1];
        cllease__Lease_Account__c leaseAccount = new cllease__Lease_Account__c(cllease__Financed_Amount__c = 10000,
                                                            cllease__Product_Type__c = cllease.LeaseConstants.LEASE,
                                                            cllease__Account__c = borrower.Id,
                                                            cllease__Lease_Product_Name__c = dummyLP.Id,
                                                            cllease__Term__c = 12,
                                                            cllease__Contract_Date__c = Date.parse('07/01/2016'),
                                                            cllease__First_Payment_Date__c = Date.parse('07/01/2016'),
                                                            cllease__Maturity_Date__c = Date.parse('06/30/2017')); //Other values should be defaulted
        cllease__Contract_Parties__c party = new cllease__Contract_Parties__c(cllease__Party_Type__c='LESSEE',cllease__Party_Account_Name__c=borrower.id);
        List<SObject> parties = new List<cllease__Contract_Parties__c> {party};
        /**
         * Creating Contract Equipments
         */
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 10000));
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 20000));

        /**
         * Creating Payment Schedule
         */
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c=cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Payment_Amount__c=3000,cllease__Total_Payment__c=3000,
                                                cllease__Payment_Date__c=Date.parse('07/01/2016')));
        
        List<cllease__Contract_Fees__c> contractFee = new List<cllease__Contract_Fees__c>();
        contractFee.add(new cllease__Contract_Fees__c(cllease__VAT__c = 0.00, cllease__Total_Payment_Amount__c = 100, cllease__Fee_Definition__c = fee.Id,
                        cllease__Fee_Type__c = 'OTHER FEES', cllease__Number_of_Periods__c = 12, cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                        cllease__Amount__c = 100, cllease__start_date__c = Date.parse('07/01/2016')));
        
        //we will a pass a dummy object instead of CL O application
        Map<String, List<SObject>> childObjects = new Map<String, List<SObject>>();
        childObjects.put('cllease__Contract_Parties__c',parties);
        childObjects.put('cllease__Contract_Equipment__c',contractEquipments);
        childObjects.put('cllease__Payment_Schedule__c',paymentDetails);
        childObjects.put('cllease__Contract_Fees__c',contractFee);

        //we will a pass a dummy object instead of CL O application
        clcommon.ApplicationContractBO appContract = new clcommon.ApplicationContractBO();
        appContract.setProduct(dummyLP);
        genesis__Applications__c app = new genesis__Applications__c(genesis__Status__c = 'CAMS APPROVED');
        appContract.setApplication(app);
        appContract.setContract(leaseAccount);
        appContract.setChildObjects(childObjects);

        ContractProcessor processor = new ContractProcessor();
        Map<Id, SObject> res = processor.createContracts(new List<clcommon.ApplicationContractBO>{appContract});
        List<cllease__Lease_Account__c> leaseAccounts = [SELECT Id, Name,
                                                cllease__Account__c,
                                                cllease__Lease_Product_Name__c,
                                                cllease__Lease_Status__c,
                                                cllease__Financed_Amount__c,
                                                cllease__Term__c
                                            FROM cllease__Lease_Account__c];

        System.debug(LoggingLevel.ERROR, ' Contract: '+leaseAccounts);
        System.assert(leaseAccounts.size() == 1);
        System.assert(leaseAccounts.get(0).cllease__Lease_Status__c.equalsIgnoreCase(cllease.LeaseConstants.LEASE_STATUS_ACTIVE_GOOD_STANDING));
        System.assert(leaseAccounts.get(0).cllease__Financed_Amount__c == 10000);
        System.assert(leaseAccounts.get(0).cllease__Account__c == borrower.Id);

    }
    
    @isTest
    public static void createContractsWithChildObjects() {
        querySetupData();
        cllease__Lease_Account__c leaseAccount = new cllease__Lease_Account__c(cllease__Financed_Amount__c = 10000,
                                                            cllease__Product_Type__c = cllease.LeaseConstants.LEASE,
                                                            cllease__Account__c = borrower.Id,
                                                            cllease__Lease_Product_Name__c = dummyLP.Id,
                                                            cllease__Term__c = 12,
                                                            cllease__Contract_Date__c = Date.parse('07/01/2016'),
                                                            cllease__First_Payment_Date__c = Date.parse('07/01/2016'),
                                                            cllease__Maturity_Date__c = Date.parse('06/30/2017')); //Other values should be defaulted

        cllease__Contract_Parties__c party = new cllease__Contract_Parties__c(cllease__Party_Type__c='LESSEE',cllease__Party_Account_Name__c=borrower.id);
        List<SObject> parties = new List<cllease__Contract_Parties__c> {party};
        /**
         * Creating Contract Equipments
         */
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 10000));
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 20000));

        /**
         * Creating Payment Schedule
         */
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c=cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Payment_Amount__c=3000,cllease__Total_Payment__c=3000,
                                                cllease__Payment_Date__c=Date.parse('07/01/2016')));
        //we will a pass a dummy object instead of CL O application
        Map<String, List<SObject>> childObjects = new Map<String, List<SObject>>();
        childObjects.put('cllease__Contract_Parties__c',parties);
        childObjects.put('cllease__Contract_Equipment__c',contractEquipments);
        childObjects.put('cllease__Payment_Schedule__c',paymentDetails);

        clcommon.ApplicationContractBO appContract = new clcommon.ApplicationContractBO();
        //appContract.setProduct(dummyLP);
        appContract.setApplication(dummyLP);
        appContract.setContract(leaseAccount);
        appContract.setChildObjects(childObjects);
        ContractProcessor processor = new ContractProcessor();
        Map<Id, SObject> res = processor.createContracts(new List<clcommon.ApplicationContractBO>{appContract});
        List<cllease__Lease_Account__c> leaseAccounts = [SELECT Id, Name,
                                                cllease__Account__c,
                                                cllease__Lease_Product_Name__c,
                                                cllease__Lease_Status__c,
                                                cllease__Financed_Amount__c,
                                                cllease__Term__c
                                            FROM cllease__Lease_Account__c];
        System.assert(leaseAccounts.size() == 1);
        System.assert(leaseAccounts.get(0).cllease__Lease_Status__c.equalsIgnoreCase(cllease.LeaseConstants.LEASE_STATUS_PARTIAL_APPLICATION));
        System.assert(leaseAccounts.get(0).cllease__Financed_Amount__c == 10000);
        System.assert(leaseAccounts.get(0).cllease__Account__c == borrower.Id);

    }

    @isTest
    public static void invalidContracts() {
        querySetupData();
        cllease__Lease_Account__c leaseAccount = new cllease__Lease_Account__c(cllease__Financed_Amount__c = 10000,
                                                            cllease__Product_Type__c = cllease.LeaseConstants.LEASE,
                                                            cllease__Account__c = borrower.Id,
                                                            cllease__Lease_Product_Name__c = dummyLP.Id,
                                                            cllease__Term__c = 12,
                                                            cllease__Contract_Date__c = Date.parse('07/01/2016'),
                                                            cllease__First_Payment_Date__c = Date.parse('07/01/2016'),
                                                            cllease__Maturity_Date__c = Date.parse('06/30/2017')); //Other values should be defaulted
        /**
         * Creating Contract Equipments
         */
        List<cllease__Contract_Equipment__C> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 10000));
        contractEquipments.add(new cllease__Contract_Equipment__C(cllease__Estimated_Selling_Price__c = 20000));

        /**
         * Creating Payment Schedule
         */
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c=1, cllease__Number_Of_Payments__c=12,
                                                cllease__Frequency__c=cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                cllease__Payment_Amount__c=3000,cllease__Total_Payment__c=3000,
                                                cllease__Payment_Date__c=Date.parse('07/01/2016')));
        //we will a pass a dummy object instead of CL O application
        Map<String, List<SObject>> childObjects = new Map<String, List<SObject>>();
        childObjects.put('cllease__Contract_Equipment__c',contractEquipments);
        childObjects.put('cllease__Payment_Schedule__c',paymentDetails);

        clcommon.ApplicationContractBO appContract1 = new clcommon.ApplicationContractBO();
        appContract1.setProduct(dummyLP);
        appContract1.setApplication(dummyLP);
        appContract1.setContract(leaseAccount);
        appContract1.setChildObjects(childObjects);

        List<clcommon.ApplicationContractBO> appContracts = new List<clcommon.ApplicationContractBO>();
        appContracts.add(appContract1);

        ContractProcessor processor = new ContractProcessor();
        Map<Id, SObject> res = processor.createContracts(appContracts);
        List<cllease__Lease_Account__c> leaseAccounts = [SELECT Id, Name,
                                                cllease__Account__c,
                                                cllease__Lease_Product_Name__c,
                                                cllease__Lease_Status__c,
                                                cllease__Financed_Amount__c,
                                                cllease__Term__c
                                            FROM cllease__Lease_Account__c];
        system.debug(leaseAccounts.size());
        System.assert(leaseAccounts.size() == 1);

    }

    @isTest
    public static void convertMultipleContracts() {
        querySetupData();
        cllease__Lease_Account__c leaseAccount = new cllease__Lease_Account__c(cllease__Financed_Amount__c = 10000,
                                                            cllease__Product_Type__c = cllease.LeaseConstants.LEASE,
                                                            cllease__Account__c = borrower.Id,
                                                            cllease__Term__c = 12
                                                           ); //Other values should be defaulted


        List<clcommon.ApplicationContractBO> appContracts = new List<clcommon.ApplicationContractBO>();

        ContractProcessor processor = new ContractProcessor();
        Map<Id, SObject> res = processor.createContracts(appContracts);
        system.assertEquals(res,null);

    }

}