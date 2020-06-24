@isTest
public with sharing class TestAutoTradeUp {

    @isTest
    public static void validateAutoTrdeup1() {
        // Creating Contract through Util
        Testhelper.getVertexCustomSettings();
        // Creating Contract using TestHelper     
        cllease__Lease_Account__c leaseContract = TestHelper.createContract();
        system.debug('Contract Created: '+leaseContract.Name);

        insert new cllease__Payment_Mode__c(Name = 'Invoice Credit');
        insert new clcommon__Payment_Mode__c(Name = 'Invoice Credit');

        Date currentSystemDate = cllease.SystemDateUtil.getCurrentSystemDate(); 

        // Creating Accounting objects and columns
        cllease__Amount_Object__c invoceCreditAO = new cllease__amount_object__c(Name = 'Invoice Credit', cllease__api_name__c = 'Invoice Credit');
        insert invoceCreditAO;

        insert new cllease__Amount_Columns__c(Name = 'Credit Amount', cllease__Amount_Object__c = invoceCreditAO.Id, cllease__Column_API_Name__c = 'cllease__Original_Credit_Amount__c');

        List<cllease__GL_Account__c> glAccountList = new List<cllease__GL_Account__c>();
        cllease__GL_Account__c creditGLAccount = new cllease__GL_Account__c(cllease__Account_Code__c = '100');
        glAccountList.add(creditGLAccount);
        cllease__GL_Account__c debitGLAccount = new cllease__GL_Account__c(cllease__Account_Code__c = '200');
        glAccountList.add(debitGLAccount);
        insert glAccountList;

        cllease__Transaction_Sub_type__c subtype = new cllease__Transaction_Sub_type__c();
        subtype.Name = 'Invoice Credit';
        insert subtype;

        cllease__Accounting_Template_Header__c accHeader = new cllease__Accounting_Template_Header__c();
        accHeader.Name                           = 'Invoice Credit';
        accHeader.cllease__Account_Status__c     = 'REGULAR';
        accHeader.cllease__Transaction_Type__c   = 'INVOICE CREDIT';
        accHeader.cllease__Company__c            = leaseContract.cllease__Branch__c;
        accHeader.cllease__Branch__c             = leaseContract.cllease__Branch__c;
        accHeader.cllease__Product__c            = leaseContract.cllease__Lease_Product_Name__c;
        accHeader.cllease__Enabled__c            = true;
        insert accHeader;

        cllease__Accounting_Template_Line__c accLine = new cllease__Accounting_Template_Line__c();
        accLine.cllease__Accounting_Template_Header__c  = accHeader.Id;
        accLine.Name                                    = 'Auto Rollover';
        accLine.cllease__Enabled__c                     = true;
        accLine.cllease__Credit_GL_Account__c           = creditGLAccount.Id; 
        accLine.cllease__Debit_GL_Account__c            = debitGLAccount.Id;
        accLine.cllease__Transaction_Sub_Type__c        = subtype.Id;
        accLine.cllease__Amount_Object__c               = 'Invoice Credit';
        accLine.cllease__Amount_Object_Column__c        = 'Credit Amount';
        insert accLine;

        // Create Termination Configuration
        cllease__Termination_Config__c config = new cllease__Termination_Config__c();
        config.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
        insert config;

        List<cllease__Termination_Config_Line__c> configLines = new List<cllease__Termination_Config_Line__c>();
        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE UNBILLED RECEIVABLES',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE UNBILLED RECEIVABLE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Receivable__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Unbilled_Receivable__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Unbilled_Receivable_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Service_and_Maintenance__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Service_and_Maintainence__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Service_and_Maintenance_TAX__c',
                                                                Do_Passthrough__c               = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Rollover_Incentive__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Rollover_Incentive_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Field_API_Name__c      = 'Booked_Residual__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Purchase_Amount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Purchase_Amount_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE FEE',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE FEE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Fee__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Fee_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ESTIMATED SALES TAX',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ESTIMATED SALES TAX',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Add_To_Quote_Amount__c = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ESTIMATED PROPERTY TAX	',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ESTIMATED PROPERTY TAX	',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Estimated_Property_Tax__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Estimated_Property_Tax__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Estimated_Property_Tax_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE DISCOUNT',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE DISCOUNT',
                                                                cllease__Field_API_Name__c      = 'Quote_Discount_Roll_over__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Discount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Discount_TAX__c'
                                                                ));
        insert configLines;
        
        // Create Termination Quote manually: Termination Quote Header , Termination QUote Lines, Termination Quote Equipments
        List<cllease__Contract_Equipment__c> eqpList = [Select Id, Install_Address__c
                                                            From cllease__Contract_Equipment__c
                                                            Where cllease__Contract__c = :leaseContract.Id LIMIT 1];

        
        cllease__Termination_Quote_Header__c quoteHeader = new cllease__Termination_Quote_Header__c();
        quoteHeader.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
        quoteHeader.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader.cllease__Status__c                      = 'GENERATED';
        quoteHeader.cllease__Contract__c                    = leaseContract.Id;
        quoteHeader.cllease__Requested_Termination_Date__c  = currentSystemDate;
        quoteHeader.cllease__Termination_Date__c            = currentSystemDate;
        quoteHeader.cllease__Effective_From__c              = currentSystemDate;
        quoteHeader.cllease__Effective_To__c                = currentSystemDate.addDays(30);
        insert quoteHeader;

        // Creating Termination Quote Lines
        List<cllease__Termination_Quote_Line__c> quoteLines = new List<cllease__Termination_Quote_Line__c>();
        for(cllease__Termination_Config_Line__c configLine : configLines) {
            quoteLines.add(new cllease__Termination_Quote_Line__c(cllease__Amount__c                    = 100, 
                                                                     cllease__Line_Type__c               = configLine.cllease__Quote_Line__c,
                                                                     cllease__Amount_Type__c             = 'LINE',
                                                                     cllease__Billable__c                = true,
                                                                     cllease__Account_Balance_Type__c    = configLine.cllease__Account_Balance_Type__c,
                                                                     cllease__Is_Account_Balancable__c   = false,
                                                                     cllease__Add_To_Quote_Amount__c     = true,
                                                                     cllease__Bill_Field_API_Name__c     = configLine.cllease__Bill_Field_API_Name__c,
                                                                     cllease__Quote_Header__c            = quoteHeader.Id));
        }
        insert quoteLines;

        // Creatign Termination QUote Equipment
        List<cllease__Termination_Quote_Equipment__c> termQuoteEqpList = new List<cllease__Termination_Quote_Equipment__c>();
        for(cllease__Contract_Equipment__c eqp : eqpList) {
            termQuoteEqpList.add(new cllease__Termination_Quote_Equipment__c(cllease__Contract_Equipment__c = eqp.Id, cllease__Termination_Quote_Header__c = quoteHeader.Id));
        }
        insert termQuoteEqpList;

        // Edit Termination Quote Line for Taxation
        quoteLines[0].cllease__Amount__c = 200;
        update quoteLines[0];

        // Validate Termination Quote Taxation

        // Termination quote Acceptance
        quoteHeader.cllease__Status__c = 'ACCEPTED';
        update quoteHeader;

        // Termination Quote Processing
        quoteHeader.cllease__Status__c = 'TERMINATION PROCESSED';
        update quoteHeader;

        leaseContract.cllease__Lease_Status__c = 'TERMINATED';
        update leaseContract;

        // Creating BIll & Charge for due to pay
        cllease__Lease_account_Due_Details__c billdue = new cllease__Lease_account_Due_Details__c();
        billdue.cllease__Lease_Account__c      =   leaseContract.Id;
        billdue.cllease__Rental_Due_Amount__c  =   1000;
        billdue.cllease__Tax_Processed__c      =   true;
        billdue.cllease__Status__c             =  'Tax Calculated';
        billdue.cllease__Total_Due_Amount__c   =   1000;
        billdue.cllease__Account__c            =   leaseContract.cllease__Account__c;
        billdue.cllease__Due_Type_Description__c = 'BILL / DUE DATE';
        system.debug('BillDetails--->'+billdue);
        insert billdue;

        cllease__Due_Detail_Lines__c CDDLDue   =   new cllease__Due_Detail_Lines__c();
        CDDLDue.cllease__Contract_Equipment__c =   eqpList[0].id;
        CDDLDue.cllease__Bill__c               =   billdue.Id;
        CDDLDue.cllease__Contract__C           =   leaseContract.Id;
        CDDLDue.cllease__Tax_Processed__c      =   false;
        CDDLDue.cllease__Total_Due_Amount__c   =   1000;
        CDDLDue.cllease__Rental_Due_Amount__c  =   1000;
        CDDLDue.Vertex_Tax_Processed__c        =   'YES';
        CDDLDue.Quote_Service_and_Maintainence__c = 100;
        insert CDDLDue;

        clcommon__Fee_Definition__c  dummyFee = [SELECT Id, Name FROM clcommon__Fee_Definition__c LIMIT 1];
        cllease__Transaction_Sub_type__c subtype2 = [SELECT Id FROM cllease__Transaction_Sub_type__c WHERE Name = :dummyFee.Name];

        cllease__Charge__c chargeTxn            = new cllease__Charge__c();
        chargeTxn.cllease__Original_Amount__c   = 100;
        chargeTxn.cllease__Fee_Definition__c    = dummyFee.Id;
        chargeTxn.cllease__Lease_Account__c     = leaseContract.Id;
        chargeTxn.cllease__Tax_Processed__c     = 'Tax Calculated';
        chargeTxn.cllease__Date__c              = currentSystemDate;
        chargeTxn.cllease__Transaction_Sub_Type__c  = subtype2.Id;
        insert chargeTxn;

        // Create Terminaton Bill and Due Detail Lines 
        // Create Bill & Charges with status
        cllease__Lease_account_Due_Details__c bill = new cllease__Lease_account_Due_Details__c();
        bill.cllease__Lease_Account__c      =   leaseContract.Id;
        bill.cllease__Rental_Due_Amount__c  =   1000;
        bill.cllease__Tax_Processed__c      =   true;
        bill.cllease__Status__c             =  'Processed';
        bill.cllease__Total_Due_Amount__c   =   1000;
        bill.cllease__Account__c            =   leaseContract.cllease__Account__c;
        bill.cllease__Due_Type_Description__c = 'TERMINATION';
        system.debug('BillDetails--->'+bill);
        insert bill;

        cllease__Due_Detail_Lines__c CDDL   =   new cllease__Due_Detail_Lines__c();
        CDDL.cllease__Contract_Equipment__c =   eqpList[0].id;
        CDDL.cllease__Bill__c               =   bill.Id;
        CDDL.cllease__Contract__C           =   leaseContract.Id;
        CDDL.cllease__Tax_Processed__c      =   false;
        CDDL.cllease__Total_Due_Amount__c   =   1000;
        CDDL.cllease__Rental_Due_Amount__c  =   1000;
        CDDL.Vertex_Tax_Processed__c        =   'NO';
        insert CDDL;

        // Call Vertex Termination taxation
        System.Test.startTest();
            VertexGetTaxonBillsJob job = new VertexGetTaxonBillsJob(new List<String>{leaseContract.Name});
            Database.executeBatch(job);
        System.Test.stopTest();

        // Creating Termination Transaction
        cllease__Other_Transaction__c termTrx = new cllease__Other_Transaction__c();
        termTrx.cllease__Equipment_Cost__c    = 1000;
        termTrx.cllease__Lease_Account__c     = leaseContract.Id;
        termTrx.cllease__Txn_Date__c          = currentSystemDate;
        termTrx.cllease__Transaction_Type__c  = 'TERMINATION';
        termTrx.cllease__Termination_Profit__c= 0;
        termTrx.cllease__To_Be_Billed_Rent__c = 1000;
        termTrx.cllease__Txn_Amt__c           = 1000;
        termTrx.cllease__GL_Transaction_Flag__c             = true;
        termTrx.cllease__Unearned_Lease_Income_Amount__c    = 1000;
        insert termTrx;

    }

    @isTest
    public static void validateAutoTrdeup2() {
        // Creating Contract through Util
        Testhelper.getVertexCustomSettings();
        // Creating Contract using TestHelper     
        cllease__Lease_Account__c leaseContract = TestHelper.createContract();
        system.debug('Contract Created: '+leaseContract.Name);

        insert new cllease__Payment_Mode__c(Name = 'Invoice Credit');
        insert new clcommon__Payment_Mode__c(Name = 'Invoice Credit');

        Date currentSystemDate = cllease.SystemDateUtil.getCurrentSystemDate(); 

        // Creating Accounting objects and columns
        cllease__Amount_Object__c invoceCreditAO = new cllease__amount_object__c(Name = 'Invoice Credit', cllease__api_name__c = 'Invoice Credit');
        insert invoceCreditAO;

        insert new cllease__Amount_Columns__c(Name = 'Credit Amount', cllease__Amount_Object__c = invoceCreditAO.Id, cllease__Column_API_Name__c = 'cllease__Original_Credit_Amount__c');

        List<cllease__GL_Account__c> glAccountList = new List<cllease__GL_Account__c>();
        cllease__GL_Account__c creditGLAccount = new cllease__GL_Account__c(cllease__Account_Code__c = '100');
        glAccountList.add(creditGLAccount);
        cllease__GL_Account__c debitGLAccount = new cllease__GL_Account__c(cllease__Account_Code__c = '200');
        glAccountList.add(debitGLAccount);
        insert glAccountList;

        cllease__Transaction_Sub_type__c subtype = new cllease__Transaction_Sub_type__c();
        subtype.Name = 'Invoice Credit';
        insert subtype;

        cllease__Accounting_Template_Header__c accHeader = new cllease__Accounting_Template_Header__c();
        accHeader.Name                           = 'Invoice Credit';
        accHeader.cllease__Account_Status__c     = 'REGULAR';
        accHeader.cllease__Transaction_Type__c   = 'INVOICE CREDIT';
        accHeader.cllease__Company__c            = leaseContract.cllease__Branch__c;
        accHeader.cllease__Branch__c             = leaseContract.cllease__Branch__c;
        accHeader.cllease__Product__c            = leaseContract.cllease__Lease_Product_Name__c;
        accHeader.cllease__Enabled__c            = true;
        insert accHeader;

        cllease__Accounting_Template_Line__c accLine = new cllease__Accounting_Template_Line__c();
        accLine.cllease__Accounting_Template_Header__c  = accHeader.Id;
        accLine.Name                                    = 'Auto Rollover';
        accLine.cllease__Enabled__c                     = true;
        accLine.cllease__Credit_GL_Account__c           = creditGLAccount.Id; 
        accLine.cllease__Debit_GL_Account__c            = debitGLAccount.Id;
        accLine.cllease__Transaction_Sub_Type__c        = subtype.Id;
        accLine.cllease__Amount_Object__c               = 'Invoice Credit';
        accLine.cllease__Amount_Object_Column__c        = 'Credit Amount';
        insert accLine;

        // Create Termination Configuration
        cllease__Termination_Config__c config = new cllease__Termination_Config__c();
        config.cllease__Lease_Product__c    = leaseContract.cllease__Lease_Product_Name__c;
        config.cllease__Quote_Reason__c     = 'ROLL-OVER';  
        config.cllease__Quote_Type__c       = 'TERMINATION WITH PURCHASE';
        insert config;

        List<cllease__Termination_Config_Line__c> configLines = new List<cllease__Termination_Config_Line__c>();
        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE UNBILLED RECEIVABLES',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE UNBILLED RECEIVABLE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Receivable__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Unbilled_Receivable__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Unbilled_Receivable_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE SERVICE AND MAINTENANCE',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Service_and_Maintenance__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Service_and_Maintainence__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Service_and_Maintenance_TAX__c',
                                                                Do_Passthrough__c               = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ROLLOVER INCENTIVE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Rollover_Incentive__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Rollover_Incentive_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE PURCHASE AMOUNT',
                                                                cllease__Field_API_Name__c      = 'Booked_Residual__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Purchase_Amount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Purchase_Amount_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE FEE',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE FEE',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Fee__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Fee_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ESTIMATED SALES TAX',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ESTIMATED SALES TAX',
                                                                cllease__Field_API_Name__c      = 'Zero_Value__c',
                                                                cllease__Add_To_Quote_Amount__c = true
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE ESTIMATED PROPERTY TAX	',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE ESTIMATED PROPERTY TAX	',
                                                                cllease__Field_API_Name__c      = 'Unbilled_Estimated_Property_Tax__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Estimated_Property_Tax__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Estimated_Property_Tax_TAX__c'
                                                                ));

        configLines.add(new cllease__Termination_Config_Line__c(Name                            = 'QUOTE DISCOUNT',
                                                                cllease__Termination_Config__c  = config.Id,
                                                                cllease__Quote_Line__c          = 'QUOTE DISCOUNT',
                                                                cllease__Field_API_Name__c      = 'Quote_Discount_Roll_over__c',
                                                                cllease__Bill_Field_API_Name__c = 'Quote_Discount__c',
                                                                Consider_for_Vertex_Tax__c      = true,
                                                                cllease__Add_To_Quote_Amount__c = true,
                                                                DDL_Quote_Line_Tax_Field_API_Name__c = 'Quote_Discount_TAX__c'
                                                                ));
        insert configLines;
        
        // Create Termination Quote manually: Termination Quote Header , Termination QUote Lines, Termination Quote Equipments
        List<cllease__Contract_Equipment__c> eqpList = [Select Id, Install_Address__c
                                                            From cllease__Contract_Equipment__c
                                                            Where cllease__Contract__c = :leaseContract.Id LIMIT 1];

        
        cllease__Termination_Quote_Header__c quoteHeader = new cllease__Termination_Quote_Header__c();
        quoteHeader.cllease__Quote_Reason__c                = 'ROLL-OVER';
        quoteHeader.cllease__Quote_Type__c                  = 'TERMINATION WITH PURCHASE';
        quoteHeader.cllease__Is_Equipment_Termination__c    = true;
        quoteHeader.cllease__Status__c                      = 'GENERATED';
        quoteHeader.cllease__Contract__c                    = leaseContract.Id;
        quoteHeader.cllease__Requested_Termination_Date__c  = currentSystemDate;
        quoteHeader.cllease__Termination_Date__c            = currentSystemDate;
        quoteHeader.cllease__Effective_From__c              = currentSystemDate;
        quoteHeader.cllease__Effective_To__c                = currentSystemDate.addDays(30);
        insert quoteHeader;

        // Creating Termination Quote Lines
        List<cllease__Termination_Quote_Line__c> quoteLines = new List<cllease__Termination_Quote_Line__c>();
        for(cllease__Termination_Config_Line__c configLine : configLines) {
            quoteLines.add(new cllease__Termination_Quote_Line__c(cllease__Amount__c                    = 100, 
                                                                     cllease__Line_Type__c               = configLine.cllease__Quote_Line__c,
                                                                     cllease__Amount_Type__c             = 'LINE',
                                                                     cllease__Billable__c                = true,
                                                                     cllease__Account_Balance_Type__c    = configLine.cllease__Account_Balance_Type__c,
                                                                     cllease__Is_Account_Balancable__c   = false,
                                                                     cllease__Add_To_Quote_Amount__c     = true,
                                                                     cllease__Bill_Field_API_Name__c     = configLine.cllease__Bill_Field_API_Name__c,
                                                                     cllease__Quote_Header__c            = quoteHeader.Id));
        }
        insert quoteLines;

        // Creatign Termination QUote Equipment
        List<cllease__Termination_Quote_Equipment__c> termQuoteEqpList = new List<cllease__Termination_Quote_Equipment__c>();
        for(cllease__Contract_Equipment__c eqp : eqpList) {
            termQuoteEqpList.add(new cllease__Termination_Quote_Equipment__c(cllease__Termination_Quote_Header__c = quoteHeader.Id));
        }
        insert termQuoteEqpList;

        // Edit Termination Quote Line for Taxation
        quoteLines[0].cllease__Amount__c = 200;
        update quoteLines[0];

        // Validate Termination Quote Taxation

        // Termination quote Acceptance
        quoteHeader.cllease__Status__c = 'ACCEPTED';
        update quoteHeader;

        // Termination Quote Processing
        quoteHeader.cllease__Status__c = 'TERMINATION PROCESSED';
        update quoteHeader;

        leaseContract.cllease__Lease_Status__c = 'TERMINATED';
        update leaseContract;

        // Creating BIll & Charge for due to pay
        cllease__Lease_account_Due_Details__c billdue = new cllease__Lease_account_Due_Details__c();
        billdue.cllease__Lease_Account__c      =   leaseContract.Id;
        billdue.cllease__Rental_Due_Amount__c  =   1000;
        billdue.cllease__Tax_Processed__c      =   true;
        billdue.cllease__Status__c             =  'Tax Calculated';
        billdue.cllease__Total_Due_Amount__c   =   1000;
        billdue.cllease__Account__c            =   leaseContract.cllease__Account__c;
        billdue.cllease__Due_Type_Description__c = 'BILL / DUE DATE';
        system.debug('BillDetails--->'+billdue);
        insert billdue;

        cllease__Due_Detail_Lines__c CDDLDue   =   new cllease__Due_Detail_Lines__c();
        CDDLDue.cllease__Contract_Equipment__c =   eqpList[0].id;
        CDDLDue.cllease__Bill__c               =   billdue.Id;
        CDDLDue.cllease__Contract__C           =   leaseContract.Id;
        CDDLDue.cllease__Tax_Processed__c      =   false;
        CDDLDue.cllease__Total_Due_Amount__c   =   1000;
        CDDLDue.cllease__Rental_Due_Amount__c  =   1000;
        CDDLDue.Vertex_Tax_Processed__c        =   'YES';
        insert CDDLDue;

        // Create Terminaton Bill and Due Detail Lines 
        // Create Bill & Charges with status
        cllease__Lease_account_Due_Details__c bill = new cllease__Lease_account_Due_Details__c();
        bill.cllease__Lease_Account__c      =   leaseContract.Id;
        bill.cllease__Rental_Due_Amount__c  =   1000;
        bill.cllease__Tax_Processed__c      =   true;
        bill.cllease__Status__c             =  'Processed';
        bill.cllease__Total_Due_Amount__c   =   1000;
        bill.cllease__Account__c            =   leaseContract.cllease__Account__c;
        bill.cllease__Due_Type_Description__c = 'TERMINATION';
        system.debug('BillDetails--->'+bill);
        insert bill;

        cllease__Due_Detail_Lines__c CDDL   =   new cllease__Due_Detail_Lines__c();
        CDDL.cllease__Contract_Equipment__c =   eqpList[0].id;
        CDDL.cllease__Bill__c               =   bill.Id;
        CDDL.cllease__Contract__C           =   leaseContract.Id;
        CDDL.cllease__Tax_Processed__c      =   false;
        CDDL.cllease__Total_Due_Amount__c   =   1000;
        CDDL.cllease__Rental_Due_Amount__c  =   1000;
        CDDL.Vertex_Tax_Processed__c        =   'NO';
        insert CDDL;

        // Call Vertex Termination taxation
        System.Test.startTest();
            VertexGetTaxonBillsJob job = new VertexGetTaxonBillsJob(new List<String>{leaseContract.Name});
            Database.executeBatch(job);
        System.Test.stopTest();

    }

    @isTest
    public static void validateAutoTrdeupUpdateContractDetails1() {
        // Creating Contract through Util
        Testhelper.getVertexCustomSettings();
        // Creating Contract using TestHelper     
        cllease__Lease_Account__c leaseContract = TestHelper.createContract();
        system.debug('Contract Created: '+leaseContract.Name);

        // Call Vertex Termination taxation
        System.Test.startTest();
            UpdateContractDetailsJob job = new UpdateContractDetailsJob(new List<String>{leaseContract.Name});
            Database.executeBatch(job);
        System.Test.stopTest();

    }

    @isTest
    public static void validateAutoTrdeupUpdateContractDetails2() {
        // Creating Contract through Util
        Testhelper.getVertexCustomSettings();
        // Creating Contract using TestHelper     
        cllease__Lease_Account__c leaseContract = TestHelper.createContract();
        system.debug('Contract Created: '+leaseContract.Name);

        // Call Vertex Termination taxation
        System.Test.startTest();
            UpdateContractDetailsJob job = new UpdateContractDetailsJob();
            Database.executeBatch(job);
        System.Test.stopTest();

    }
}