@isTest
public with sharing class TestGLIntegration {   

    public static testMethod void testGLConsolidation() {
        // A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // B. Adding accounting configuration to Product and Creating other setup
        cllease__Lease_Product__c product = [SELECT Id, Name From cllease__Lease_Product__c Limit 1];
        cllease__Office_Name__c company = [SELECT Id, Name From cllease__Office_Name__c Where Name = 'Test Office'];

        TestData.doPreSetup();
        TestData.createAccountingTemplateSetup(product.Id, company.Id);

        // Changing the current System Date
        Date currentSystemDate = Date.newInstance(2018, 04, 24);
        List<cllease__Office_Name__c> companies = [Select Id, Name, cllease__Current_System_Date__c
                                                    From cllease__Office_Name__c];
        for(cllease__Office_Name__c company1 : companies) {
            company1.cllease__Current_System_Date__c = currentSystemDate;
        }
        update companies;
                                        
        // Creating and runnning the Batch jobs for General Entries Creation.
        System.Test.startTest();
            // Creating DAG
            String dagName = 'CLLease-BatchTestDAG';
            List<String> listOfJobs = new List<String>{ 'cllease.BillGeneratorJob',  'cllease.BillDetailGeneratorJob',
                                        'cllease.GLTransactionGeneratorJob', 'GLConsolidatedEntriesBatch' };
            TestHelper.createDAGSpecificJobs(listOfJobs, dagName);
            // Running DAG
            TestHelper.runDAG(dagName);
        System.Test.stopTest();


        // Validating the GL Consolidate Interface Records
        List<Int_OLMN_GL__c> glInterfaceRecs = [Select Id
                                                    , JOURNAL_ENTRY_NUMBER__C     
                                                    , JOURNAL_ENTRY_LINE_NUMBER__C
                                                    , ACCOUNTING_YEAR__C      
                                                    , ACCOUNTING_MONTH__C     
                                                    , FOREIGN_SUBSYSTEM_ID__C 
                                                    , JOURNAL_DESCRIPTION__C  
                                                    , JOURNAL_DATE__C         
                                                    , JOURNAL_SOURCE_CODE__C  
                                                    , JOURNAL_CATEGORY__c     
                                                    , JOURNAL_REFERENCE__C    
                                                    , JOURNAL_CURRENCY__C     
                                                    , TRANSACTION_DESCRIPTION__C
                                                    , AMOUNT__C       
                                                    , Movement_Code__c
                                                    , ACCOUNT__C      
                                                    , SIGN__C
                                                From Int_OLMN_GL__c
                                                Order by JOURNAL_ENTRY_LINE_NUMBER__C];

        // Expected Records
        List<List<String>> glInterfaceRecordsExpected = new List<List<String>>();
        glInterfaceRecordsExpected.add(new List<String>{'1', '1', '2018', '12', 'NEWCO', 'NEWCO20180323', '20180323', 'NEWCO', 'NEWCO', '20171231', 'USD','BOOKING', '14400.00', '00101.02.3030.342020.00.00000.0000', '00101.02.3030.342020.00.00000.0000', '-'});
        glInterfaceRecordsExpected.add(new List<String>{'1', '2', '2018', '12', 'NEWCO', 'NEWCO20180323', '20180323', 'NEWCO', 'NEWCO', '20171231', 'USD','BOOKING', '4400.00', '00101.02.3030.163020.01.00000.0000', '00101.02.3030.163020.01.00000.0000', '-'});
        glInterfaceRecordsExpected.add(new List<String>{'1', '3', '2018', '12', 'NEWCO', 'NEWCO20180323', '20180323', 'NEWCO', 'NEWCO', '20180228', 'USD', 'BILLING', '504.00', '00101.02.3030.346021.06.00000.0000', '00101.02.3030.346021.06.00000.0000', '-'});
        glInterfaceRecordsExpected.add(new List<String>{'1', '4', '2018', '12', 'NEWCO', 'NEWCO20180323', '20180323', 'NEWCO', 'NEWCO', '20180228', 'USD', 'BILLING', '3600.00', '00101.02.3030.161020.06.00000.0000', '00101.02.3030.161020.06.00000.0000', '-'});
        glInterfaceRecordsExpected.add(new List<String>{'1', '5', '2018', '12', 'NEWCO', 'NEWCO20180323', '20180323', 'NEWCO', 'NEWCO', '20171231', 'USD', 'BOOKING', '14400.00', '00101.02.3030.161020.01.00000.0000', '00101.02.3030.161020.01.00000.0000', '+'});
        glInterfaceRecordsExpected.add(new List<String>{'1', '6', '2018', '12', 'NEWCO', 'NEWCO20180323', '20180323', 'NEWCO', 'NEWCO', '20171231', 'USD', 'BOOKING', '4400.00', '00101.02.3030.342020.00.00000.0000', '00101.02.3030.342020.00.00000.0000', '+'});
        glInterfaceRecordsExpected.add(new List<String>{'1', '7', '2018', '12', 'NEWCO', 'NEWCO20180323', '20180323', 'NEWCO', 'NEWCO', '20180228', 'USD', 'BILLING', '504.00', '00101.02.3030.142022.06.00000.0000', '00101.02.3030.142022.06.00000.0000', '+'});
        glInterfaceRecordsExpected.add(new List<String>{'1', '8', '2018', '12', 'NEWCO', 'NEWCO20180323', '20180323', 'NEWCO', 'NEWCO', '20180228', 'USD', 'BILLING', '3600.00', '00101.02.3030.142020.06.00000.0000', '00101.02.3030.142020.06.00000.0000', '+'});

        //System.assertEquals(glInterfaceRecordsExpected.size(),glInterfaceRecs.size(),'Mismatch in No Of Generated GL Consolidation Interface Records...');

        /*for(Integer i=0; i<glInterfaceRecs.size(); i++) {
            System.debug(LoggingLevel.ERROR, 'General Entry: '+glInterfaceRecs[i]);
            System.assertEquals(Integer.valueOf(glInterfaceRecordsExpected[i][0]), ((Integer)glInterfaceRecs[i].JOURNAL_ENTRY_NUMBER__C), 'Mismatch in JOURNAL_ENTRY_NUMBER__C at row: '+i);
            System.assertEquals(Integer.valueOf(glInterfaceRecordsExpected[i][1]), ((Integer)glInterfaceRecs[i].JOURNAL_ENTRY_LINE_NUMBER__C), 'Mismatch in JOURNAL_ENTRY_LINE_NUMBER__C at row: '+i);
            System.assertEquals(glInterfaceRecordsExpected[i][2], glInterfaceRecs[i].ACCOUNTING_YEAR__c, 'Mismatch in ACCOUNTING_YEAR__c at row: '+i);
            System.assertEquals(glInterfaceRecordsExpected[i][3], glInterfaceRecs[i].ACCOUNTING_MONTH__c, 'Mismatch in ACCOUNTING_MONTH__c at row: '+i);
            System.assertEquals(glInterfaceRecordsExpected[i][4], glInterfaceRecs[i].FOREIGN_SUBSYSTEM_ID__c, 'Mismatch in FOREIGN_SUBSYSTEM_ID__c at row: '+i);
            //System.assertEquals(glInterfaceRecordsExpected[i][5], glInterfaceRecs[i].JOURNAL_DESCRIPTION__c, 'Mismatch in JOURNAL_DESCRIPTION__c at row: '+i);
            System.assertEquals(glInterfaceRecordsExpected[i][6], glInterfaceRecs[i].JOURNAL_DATE__c, 'Mismatch in JOURNAL_DATE__c at row: '+i);
            System.assertEquals(glInterfaceRecordsExpected[i][7], glInterfaceRecs[i].JOURNAL_SOURCE_CODE__c, 'Mismatch in JOURNAL_SOURCE_CODE__c at row: '+i);
            System.assertEquals(glInterfaceRecordsExpected[i][8], glInterfaceRecs[i].JOURNAL_CATEGORY__c, 'Mismatch in JOURNAL_CATEGORY__c at row: '+i);
            System.assertEquals(glInterfaceRecordsExpected[i][9], glInterfaceRecs[i].JOURNAL_REFERENCE__c, 'Mismatch in JOURNAL_REFERENCE__c at row: '+i);
            System.assertEquals(glInterfaceRecordsExpected[i][10], glInterfaceRecs[i].JOURNAL_CURRENCY__c, 'Mismatch in JOURNAL_CURRENCY__c at row: '+i);
            System.assertEquals(glInterfaceRecordsExpected[i][11], glInterfaceRecs[i].TRANSACTION_DESCRIPTION__c, 'Mismatch in TRANSACTION_DESCRIPTION__c at row: '+i);
            System.assertEquals(Decimal.valueOf(glInterfaceRecordsExpected[i][12]), ((Decimal)glInterfaceRecs[i].AMOUNT__c).setScale(2), 'Mismatch in AMOUNT__c at row: '+i);
            System.assertEquals(glInterfaceRecordsExpected[i][13], glInterfaceRecs[i].Movement_Code__c, 'Mismatch in Movement_Code__c at row: '+i);
            System.assertEquals(glInterfaceRecordsExpected[i][14], glInterfaceRecs[i].ACCOUNT__c, 'Mismatch in ACCOUNT__c at row: '+i);
            System.assertEquals(glInterfaceRecordsExpected[i][15], glInterfaceRecs[i].SIGN__c, 'Mismatch in SIGN__c at row: '+i);   
        }*/
    }

    public static testMethod void testGLConsolidationNegative() {
        // A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // B. Adding accounting configuration to Product and Creating other setup
        cllease__Lease_Product__c product = [SELECT Id, Name From cllease__Lease_Product__c Limit 1];
        cllease__Office_Name__c company = [SELECT Id, Name From cllease__Office_Name__c Where Name = 'Test Office'];

        TestData.doPreSetup();
        TestData.createAccountingTemplateSetup(product.Id, company.Id);
                
        Int_OLMN_GL__c glInterfaceRec = new Int_OLMN_GL__c(Committed__c = false);                        
        // Creating and runnning the Batch jobs for General Entries Creation.
        System.Test.startTest();
            // Running batch job
            GLConsolidatedEntriesBatch job = new GLConsolidatedEntriesBatch(new List<String>{contract.Name});
            Database.executeBatch(job);
        System.Test.stopTest();

        // Check no of records after batch job
        List<Int_OLMN_GL__c> glInterfaceRecs = [Select Id From Int_OLMN_GL__c];
        System.assertEquals(0, glInterfaceRecs.size(),'Mismatch in No Of Generated GL Consolidation Interface Records...');

    }

    public static testMethod void testGLAccountingEntries() {
        // A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // B. Adding accounting configuration to Product and Creating other setup
        cllease__Lease_Product__c product = [SELECT Id, Name From cllease__Lease_Product__c Limit 1];
        cllease__Office_Name__c company = [SELECT Id, Name From cllease__Office_Name__c Where Name = 'Test Office'];

        TestData.doPreSetup();
        TestData.createAccountingTemplateSetup(product.Id, company.Id);

        // Changing the current System Date
        Date currentSystemDate = Date.newInstance(2018, 06, 24);
        List<cllease__Office_Name__c> companies = [Select Id, Name, cllease__Current_System_Date__c
                                                    From cllease__Office_Name__c];
        for(cllease__Office_Name__c company1 : companies) {
            company1.cllease__Current_System_Date__c = currentSystemDate;
        }
        update companies;
                                        
        // Creating and runnning the Batch jobs for General Entries Creation.
        System.Test.startTest();
            // Creating DAG
            String dagName = 'CLLease-BatchTestDAG';
            List<String> listOfJobs = new List<String>{ 'cllease.BillGeneratorJob', 'cllease.BillDetailGeneratorJob',
                                        'cllease.GLTransactionGeneratorJob', 'GLConsolidatedEntriesBatch', 'GLSubledgerEntriesBatch' };
            TestHelper.createDAGSpecificJobs(listOfJobs, dagName);
            // Running DAG
            TestHelper.runDAG(dagName);
        System.Test.stopTest();

        List<Int_OLMN_Accounting_Entry__c> glSubLedgers 
                            = [Select Id, Name
                                ,Contract_Number__c       
                                ,Journal_Category__c      
                                ,Journal_Category_Desc__c 
                                ,Journal_Source__c        
                                ,Batch_Name__c            
                                ,Batch_Description__c     
                                ,Foreign_SubSystem_Id__c  
                                ,Period_Name__c           
                                ,Accounted_Cr__c 
                                ,Accounted_Dr__c         
                                ,Concatenated_Segments__c 
                                ,Accounting_Date__c     
                                ,Vendor_Program__c      
                                ,Transaction_Number__c  
                                ,Fin_Product__c         
                                ,Posting_Date__c        
                                ,GL_Entry_Id__c         
                                ,Transaction_Sub_Type__c
                                ,Asset_Number__c        
                                ,Journal_Entry_Number__c
                            From Int_OLMN_Accounting_Entry__c
                            Order by Name];

        List<List<String>> accEntriesInfRecsExpected = new List<List<String>>();
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BOOKING', 'BOOKING', 'NEWCO', '20171231-NEWCO-20180323', 'NEWCO', '201812', '14400.00', '00101.02.3030.342020.00.00000.0000', '20171231', 'NewCo', 'GXD-0000012967', 'TestLeaseProductXXX', '20180323', 'GROSS RENT', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BOOKING', 'BOOKING', 'NEWCO', '20171231-NEWCO-20180323', 'NEWCO', '201812', '14400.00', '00101.02.3030.161020.01.00000.0000', '20171231', 'NewCo', 'GXD-0000012967', 'TestLeaseProductXXX', '20180323', 'GROSS RENT', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BOOKING', 'BOOKING', 'NEWCO', '20171231-NEWCO-20180323', 'NEWCO', '201812', '4400.00', '00101.02.3030.163020.01.00000.0000', '20171231', 'NewCo', 'GXD-0000012968', 'TestLeaseProductXXX', '20180323', 'UNEARNED LEASE INCOME', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BOOKING', 'BOOKING', 'NEWCO', '20171231-NEWCO-20180323', 'NEWCO', '201812', '4400.00', '00101.02.3030.342020.00.00000.0000', '20171231', 'NewCo', 'GXD-0000012968', 'TestLeaseProductXXX', '20180323', 'UNEARNED LEASE INCOME', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BILLING', 'BILLING', 'NEWCO', '20180228-NEWCO-20180323', 'NEWCO', '201812', '168.00', '00101.02.3030.346021.06.00000.0000', '20180228', 'NewCo', 'GXD-0000012969', 'TestLeaseProductXXX', '20180323', 'TAX BILLING', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BILLING', 'BILLING', 'NEWCO', '20180228-NEWCO-20180323', 'NEWCO', '201812', '168.00', '00101.02.3030.142022.06.00000.0000', '20180228', 'NewCo', 'GXD-0000012969', 'TestLeaseProductXXX', '20180323', 'TAX BILLING', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BILLING', 'BILLING', 'NEWCO', '20180228-NEWCO-20180323', 'NEWCO', '201812', '1200.00', '00101.02.3030.161020.06.00000.0000', '20180228', 'NewCo', 'GXD-0000012970', 'TestLeaseProductXXX', '20180323', 'PERIODIC RENT', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BILLING', 'BILLING', 'NEWCO', '20180228-NEWCO-20180323', 'NEWCO', '201812', '1200.00', '00101.02.3030.142020.06.00000.0000', '20180228', 'NewCo', 'GXD-0000012970', 'TestLeaseProductXXX', '20180323', 'PERIODIC RENT', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BILLING', 'BILLING', 'NEWCO', '20180228-NEWCO-20180323', 'NEWCO', '201812', '168.00', '00101.02.3030.346021.06.00000.0000', '20180228', 'NewCo', 'GXD-0000012971', 'TestLeaseProductXXX', '20180323', 'TAX BILLING', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BILLING', 'BILLING', 'NEWCO', '20180228-NEWCO-20180323', 'NEWCO', '201812', '168.00', '00101.02.3030.142022.06.00000.0000', '20180228', 'NewCo', 'GXD-0000012971', 'TestLeaseProductXXX', '20180323', 'TAX BILLING', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BILLING', 'BILLING', 'NEWCO', '20180228-NEWCO-20180323', 'NEWCO', '201812', '1200.00', '00101.02.3030.161020.06.00000.0000', '20180228', 'NewCo', 'GXD-0000012972', 'TestLeaseProductXXX', '20180323', 'PERIODIC RENT', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BILLING', 'BILLING', 'NEWCO', '20180228-NEWCO-20180323', 'NEWCO', '201812', '1200.00', '00101.02.3030.142020.06.00000.0000', '20180228', 'NewCo', 'GXD-0000012972', 'TestLeaseProductXXX', '20180323', 'PERIODIC RENT', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BILLING', 'BILLING', 'NEWCO', '20180228-NEWCO-20180323', 'NEWCO', '201812', '168.00', '00101.02.3030.346021.06.00000.0000', '20180228', 'NewCo', 'GXD-0000012973', 'TestLeaseProductXXX', '20180323', 'TAX BILLING', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BILLING', 'BILLING', 'NEWCO', '20180228-NEWCO-20180323', 'NEWCO', '201812', '168.00', '00101.02.3030.142022.06.00000.0000', '20180228', 'NewCo', 'GXD-0000012973', 'TestLeaseProductXXX', '20180323', 'TAX BILLING', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BILLING', 'BILLING', 'NEWCO', '20180228-NEWCO-20180323', 'NEWCO', '201812', '1200.00', '00101.02.3030.161020.06.00000.0000', '20180228', 'NewCo', 'GXD-0000012974', 'TestLeaseProductXXX', '20180323', 'PERIODIC RENT', '1'});
        accEntriesInfRecsExpected.add(new List<String>{'LES-0000001366', 'BILLING', 'BILLING', 'NEWCO', '20180228-NEWCO-20180323', 'NEWCO', '201812', '1200.00', '00101.02.3030.142020.06.00000.0000', '20180228', 'NewCo', 'GXD-0000012974', 'TestLeaseProductXXX', '20180323', 'PERIODIC RENT', '1'});

        //System.assertEquals(accEntriesInfRecsExpected.size(), glSubLedgers.size(),'Mismatch in No Of Generated GL Accounting Entries Interface Records...');

        /*for(Integer i=0; i<glSubLedgers.size(); i++) {
            //System.assertEquals(accEntriesInfRecsExpected[i][0], glSubLedgers[i].Contract_Number__c, 'Mismatch in Contract_Number__c at row: '+i);
            System.assertEquals(accEntriesInfRecsExpected[i][1], glSubLedgers[i].Journal_Category__c, 'Mismatch in Journal_Category__c at row: '+i);
            System.assertEquals(accEntriesInfRecsExpected[i][2], glSubLedgers[i].Journal_Category_Desc__c, 'Mismatch in Journal_Category_Desc__c at row: '+i);
            System.assertEquals(accEntriesInfRecsExpected[i][3], glSubLedgers[i].Journal_Source__c, 'Mismatch in Journal_Source__c at row: '+i);
            //System.assertEquals(accEntriesInfRecsExpected[i][4], glSubLedgers[i].Batch_Description__c, 'Mismatch in Batch_Description__c at row: '+i);
            System.assertEquals(accEntriesInfRecsExpected[i][5], glSubLedgers[i].Foreign_SubSystem_Id__c, 'Mismatch in Foreign_SubSystem_Id__c at row: '+i);
            System.assertEquals(accEntriesInfRecsExpected[i][6], glSubLedgers[i].Period_Name__c, 'Mismatch in Period_Name__c at row: '+i);
            if(glSubLedgers[i].Accounted_Cr__c != null) {
                System.assertEquals(Decimal.valueOf(accEntriesInfRecsExpected[i][7]), ((Decimal)glSubLedgers[i].Accounted_Cr__c).setScale(2), 'Mismatch in Accounted_Cr__c at row: '+i);
            } else {
                System.assertEquals(Decimal.valueOf(accEntriesInfRecsExpected[i][7]), ((Decimal)glSubLedgers[i].Accounted_Dr__c).setScale(2), 'Mismatch in Accounted_Dr__c at row: '+i);
            }
            
            System.assertEquals(accEntriesInfRecsExpected[i][8], glSubLedgers[i].Concatenated_Segments__c, 'Mismatch in Concatenated_Segments__c at row: '+i);
            System.assertEquals(accEntriesInfRecsExpected[i][9], glSubLedgers[i].Accounting_Date__c, 'Mismatch in Accounting_Date__c at row: '+i);
            System.assertEquals(accEntriesInfRecsExpected[i][10], glSubLedgers[i].Vendor_Program__c, 'Mismatch in Vendor_Program__c at row: '+i);
            System.assertEquals(accEntriesInfRecsExpected[i][12], glSubLedgers[i].Fin_Product__c, 'Mismatch in Fin_Product__c at row: '+i);
            System.assertEquals(accEntriesInfRecsExpected[i][13], glSubLedgers[i].Posting_Date__c, 'Mismatch in Posting_Date__c at row: '+i);
            System.assertEquals(accEntriesInfRecsExpected[i][14], glSubLedgers[i].Transaction_Sub_Type__c, 'Mismatch in Transaction_Sub_Type__c at row: '+i);
            System.assertEquals(Integer.valueOf(accEntriesInfRecsExpected[i][15]), ((Integer)glSubLedgers[i].Journal_Entry_Number__c), 'Mismatch in Journal_Entry_Number__c at row: '+i);   
        }*/
    }

    public static testMethod void testGLAccountingEntriesNegative() {
        // A. Creating Contract Using TestHelper
        cllease__Lease_Account__c contract = TestHelper.createContract();
        String contractStatus = 'ACTIVE - GOOD STANDING';
        System.assert(contractStatus.containsIgnoreCase(contract.cllease__Lease_Status__c));

        // B. Adding accounting configuration to Product and Creating other setup
        cllease__Lease_Product__c product = [SELECT Id, Name From cllease__Lease_Product__c Limit 1];
        cllease__Office_Name__c company = [SELECT Id, Name From cllease__Office_Name__c Where Name = 'Test Office'];

        TestData.doPreSetup();
        TestData.createAccountingTemplateSetup(product.Id, company.Id);
                
        Int_OLMN_GL__c glInterfaceRec = new Int_OLMN_GL__c(Committed__c = false);                        
        // Creating and runnning the Batch jobs for General Entries Creation.
        System.Test.startTest();
            // Running batch job
            GLSubledgerEntriesBatch job = new GLSubledgerEntriesBatch(new List<String>{contract.Name});
            Database.executeBatch(job);
        System.Test.stopTest();

        // Check no of records after batch job
        List<Int_OLMN_Accounting_Entry__c> glSubLedgers =  [Select Id From Int_OLMN_Accounting_Entry__c];
        System.assertEquals(0, glSubLedgers.size(),'Mismatch in No Of Generated GL SubLedgers Interface Records...');

    }    
}