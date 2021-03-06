/**
 * Author: Cloud Lending Solutions
 * Description: Following class helps in creating test data for testing the functionality 
 **/
public with sharing class TestHelper {


    /**
     * Following method creates the Sample Data needed  for contract creation and also creates contract.
     **/
    public static cllease__Lease_Account__c createContract() {
        cllease.TestHelper.createSeedDataForTesting();
        // Setting Current System Date in Test Context
        Date currentSystemDate = Date.newInstance(2018, 03, 31);
        // 1. Pre-Setup
        clcommon__Fee_Definition__c  dummyFee   = cllease.Testhelper.createLeaseFee();
        clcommon__Fee_Set__c  dummyFeeSet       = cllease.Testhelper.createLeaseFeeSet();
        insert new clcommon__Fee_Junction__c( clcommon__Fee__c = dummyFee.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);

        clcommon__Fee_Definition__c  dummyFee2   = cllease.Testhelper.createLeaseFee();
        dummyFee2.clcommon__Type__c              = 'NSF Fees';
        dummyFee2.clcommon__Amount__c            = 25;
        update dummyFee2;

        insert new clcommon__Fee_Junction__c(clcommon__Fee__c = dummyFee2.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);
        insert new cllease__Transaction_Sub_Type__c(Name = 'NSF Fees');

        clcommon__Fee_Definition__c  latefee   = cllease.Testhelper.createLeaseFee();
        latefee.clcommon__Type__c              = 'Late Fees';
        latefee.clcommon__Calculation_Method__c= 'AMOUNT CALCULATED AS % OF RENT DUE';
        latefee.clcommon__Amount__c            = 25;
        update latefee;

        insert new clcommon__Fee_Junction__c(clcommon__Fee__c = latefee.ID, clcommon__Fee_Set__c  = dummyFeeSet.ID);
        insert new cllease__Transaction_Sub_Type__c(Name = 'Late Fees');



        cllease__Office_Name__c dummyOffice     = cllease.TestHelper.createOffice('Test Office', true);
        dummyOffice.cllease__Current_System_Date__c = currentSystemDate;
        dummyOffice.Dll_Seg1_Company__c         = '00101';
        dummyOffice.Dll_Seg2_Business_Unit__c   = '02';
        dummyOffice.Dll_Seg3_Department__c      = '3030';
        dummyOffice.Dll_Seg6__c                 = '00000';
        dummyOffice.Dll_Seg7__c                 = '0000';
        update dummyOffice;

        TestData.createPeriodsFor2018(dummyOffice.cllease__Calendar__c);

        Account dummyAccount = new Account(Name = 'Sample Account');
        insert dummyAccount;

        // 2. Creating Sample Product with rental and Dep Streams enabled
        cllease__Lease_Product__c dummyLP    = cllease.TestHelper.createLeaseProduct(dummyOffice, dummyFeeSet);
        dummyLP.cllease__Product_Sub_Type__c = cllease.LendingConstants.PRODUCT_SUB_TYPE_FN_LEASE;
        dummyLP.cllease__Use_Open_Acct_Period__c = true;
        update dummyLP;

        clcommon__Agreement__c dealerProgram =new clcommon__Agreement__c(Name='NewCo');
        insert dealerProgram;

        // 3.Creating Contract
        Date currentDate = Date.newInstance(2018, 01, 01);
        cllease__Lease_Account__c leaseAccount      = new cllease__Lease_Account__c();
        leaseaccount.cllease__Account__c            = dummyAccount.ID;
        leaseAccount.cllease__Lease_Product_Name__c = dummyLP.ID;
        leaseAccount.cllease__Contract_Date__c      = currentDate;
        leaseaccount.cllease__Financed_Amount__c    = 10000;
        //leaseaccount.cllease__Residual_Amount__c    = 1000;
        leaseAccount.cllease__Term__c               = 12;
        leaseaccount.Dealer_Program__c              = dealerProgram.Id;

        // 3.a Adding Equipments to Contract
        List<cllease__Contract_Equipment__c> contractEquipments = new List<cllease__Contract_Equipment__c>();
        contractEquipments.add(new cllease__Contract_Equipment__c(cllease__Estimated_Selling_Price__c = 10000,
                                        Evergreen_Depreciable_Cost__c = 950,
                                        Remaining_Evergreen_Depreciable_Cost__c = 950,
                                        Salvage_Value__c = 50,
                                        cllease__life_in_months__c = 14,
                                        cllease__Status__c = 'LEASED'));
      
        // 3.b Adding Payment Schedules to Contract
        List<cllease__Payment_Schedule__c> paymentDetails =  new List<cllease__Payment_Schedule__c>();
        paymentDetails.add(new cllease__Payment_Schedule__c(cllease__Sequence__c = 1, cllease__Number_Of_Payments__c = 12,
                           cllease__Frequency__c = cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                           cllease__Payment_Amount__c = 1200, cllease__Payment_Date__c = currentDate,
                           cllease__Total_Payment__c = 1200));

        // 4. Calling ContractBuilder for Contract Creation
        cllease.ContractBuilder builder = new cllease.ContractBuilder(leaseAccount);
        builder.addChildObjects(contractEquipments);
        builder.addChildObjects(paymentDetails);
        String response = builder.createContract(cllease.LendingConstants.ContractCreateOption.ACTIVATECONTRACT);
        System.debug(LoggingLevel.ERROR, ' Response from Contract Creation: '+response);
        // Validating Contract Activation
        System.assert(response.containsIgnoreCase('Contract Creation Successful'));
        return builder.getContract();
    }

    /**
     * Following method helps in creating DAG for specific jobs
     * Note: Following method creates DAG with all jobs in chain mode, No Parallelism
     **/
    public static void createDAGSpecificJobs(List<String> listOfJobs, String dagName) {
        
        Map<String, List<Object>> jobs = new Map<String, List<Object>>(), jobs2 = new Map<String, List<Object>>(); 
        Map<String, Set<String>> dependencies = new Map<String, Set<String>>(); 
    
        clcommon.DynamicJobAPI3 apiHandle = clcommon.APIFactory.getDynamicJobAPI3();         
        String prevJob;
        for (String job : listOfJobs) {
            jobs.put(job, new List<Object>{job, 1, null, 'Logging', 10});
            dependencies.put(job, (String.isEmpty(prevJob) ? new Set<String>() : new Set<String>{prevJob}));
            prevJob = job;
        }    
        apiHandle.addDagThroughPostInstallScript(dagName, jobs, dependencies);
    }   

    /**
     * Following method helps in Creating DAG for Production with custom jobs in Parallelism.
     **/
    /*public static void createDAGForAllDLLJobsForProduction(String dagName, Boolean skipEODJob) {
        // Preparing to Create DAG for DLL Production Use
        clcommon.DynamicJobAPI3 apiHandle = clcommon.APIFactory.getDynamicJobAPI3();
        Map<String, List<Object>> jobs = new Map<String, List<Object>>(); 
        Map<String, Set<String>> dependencies = new Map<String, Set<String>>(); 
        String prevJob;
        Integer batchSize = 100;
        // Following are the list of jobs from CL Lease 
        List<String> listOfCLLeaseJobs = new List<String> {
                                'cllease.EndAndStartOfDayJob',
                                'cllease.EvergreenProcessorJob',
                                'cllease.DealerFunderJob',
                                'cllease.ExcessAllocatorJob',
                                'cllease.LateChargeGeneratorJob',
                                'cllease.PeriodicChargeGeneratorJob',
                                'cllease.BillGeneratorJob',
                                'cllease.BillDetailGeneratorJob',
                                'VertexGetTaxonBillsJob',
                                'VertexGetTaxonChargesJob',
                                'cllease.DelinquencyProcessorJob',
                                'cllease.NPAReversalAndCatchupJob',
                                'cllease.AccrualTranscationGeneratorJob',
                                'cllease.PassthroughDisburseTxnGeneratorJob',
                                'GLTxnGeneratorJob',
                                'cllease.GLReversalJob'
                            };
        // Remove "cllease.EndAndStartOfDayJob" job incase of skupEODJob = true
        if(skipEODJob) {
            listOfCLLeaseJobs.remove(0);
        }
                
        for (String job : listOfCLLeaseJobs) {
            jobs.put(job, new List<Object>{job, 1, null, 'Logging', batchSize});
            dependencies.put(job, (String.isEmpty(prevJob) ? new Set<String>() : new Set<String>{prevJob}));
            prevJob = job;
        }

        //  Adding Custom Jobs to CL Lease Jobs with parallel paths
        String parentJob, childJob;

        // 1. Parallel jobs path-1
        parentJob = prevJob; 
        childJob = 'APInterfaceRecordsGeneratorJob';
        jobs.put(childJob, new List<Object>{childJob, 1, null, 'Logging', batchSize});
        dependencies.put(childJob, new Set<String>{parentJob});

        // 2. Parallel jobs path-2
        parentJob = prevJob;
        childJob = 'GLSubledgerEntriesBatch';
        jobs.put(childJob, new List<Object>{childJob, 1, null, 'Logging', batchSize});
        dependencies.put(childJob, new Set<String>{parentJob});
        parentJob = childJob;
        childJob = 'GLConsolidatedEntriesBatch';
        jobs.put(childJob, new List<Object>{childJob, 1, null, 'Logging', batchSize});
        dependencies.put(childJob, new Set<String>{parentJob});

        // 3. Parallel jobs path-3
        parentJob = prevJob; 
        childJob = 'BillsandChargesConsolidationJob';
        jobs.put(childJob, new List<Object>{childJob, 1, null, 'Logging', batchSize});
        dependencies.put(childJob, new Set<String>{parentJob});
        parentJob = childJob;
        childJob = 'PNCFileCreationJob';
        jobs.put(childJob, new List<Object>{childJob, 1, null, 'Logging', batchSize});
        dependencies.put(childJob, new Set<String>{parentJob});

        apiHandle.addDagThroughPostInstallScript(dagName, jobs, dependencies);
    }*/

    /**
     * Following method helps in Running the DAG
     **/
    public static void runDAG(String dagName) {
        clcommon.DynamicJobAPI2 apiHandle = clcommon.APIFactory.getDynamicJobAPI2();
        apiHandle.runOnce(dagName);
    }

    /**
     * Following method gives default values for vertex for test cases for validations
     **/
    public static VertexAPI__c getVertexCustomSettings() {
        // Creating Vertex API Custom Settings for Apex Tests validations
        VertexAPI__c customset=new VertexAPI__c();
        customset.Username__c='devuser07';
        customset.Password__c='Dllgroup2018';
        customset.End_point__c='https://dllgroup.ondemand.vertexinc.com/vertex-ws/services/CalculateTax80';
        customset.soapNS__c='http://schemas.xmlsoap.org/soap/envelope/';
        customset.TrustedID__c='9nh6TynIaLCo';
        customset.XSI__c='urn:vertexinc:o-series:tps:8:0';
        customset.Company__c='DLLOS';
 	    customset.Division__c='DLLFS';
        customset.serviceNS__c='https://dllgroup.ondemand.vertexinc.com/vertex-ws/services/CalculateTaxString';
        insert customset; 
        return customset;
    }    
}