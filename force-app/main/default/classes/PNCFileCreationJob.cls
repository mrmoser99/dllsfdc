/**
 * Author: Cloud Lending Solutions
 * Usage: Followinb job helps in creating PNC File from Invoices
 * Script to Run Job:
 *      
 **/
global with sharing class PNCFileCreationJob extends clcommon.DynamicJob {
      
    private String linesheader;
    private Integer publicCount = 0;
    private Decimal publicSum = 0.0;
    private static String query;
    private static final String JOB_NAME = 'PNC File Creation Job';

    global PNCFileCreationJob() {
        super(JOB_NAME, initialize(null));
    }
    
    global PNCFileCreationJob(List<String> InvoiceNames) {
        super(JOB_NAME, initialize(InvoiceNames));
    }
    
    global virtual override String getRuntimeQuery() {
        System.debug(LoggingLevel.ERROR, 'PNCFileCreationJob query in getRuntimeQuery : ' + query);
        return query; 
    }

    public static String initialize(List<String> InvoiceNames) {

        query = ' SELECT  Id, Name,                                 '
              + '        Invoice_Period_End_Date__c,                '
              + '        void_in_pnc__c,                '
              + '        adjustment_status__c,                '
              + '        sent_to_pnc_amount__c, '
              + '        Createddate,                               '
              + '        LS_Contract__r.cllease__Account__r.name,   '
              + '        LS_Contract__r.cllease__Account__r.phone,  '
              + '        Total_Invoiced_Amount__c,                  '
              + '        Balance_Due_Amount__c,                     '
              + '        LS_Contract__r.Billing_Email__c,           '
              + '        LS_Contract__r.Customer__c,                '
              + '        LS_Contract__r.Name,                       '
              + '        LS_Contract__r.Account_Number__c,          '
              + '        LS_Contract__r.cllease__Contact__c,        '
              + '        LS_Contract__r.cllease__Account__c,        '
              + '        LS_Contract__r.Billing_Address_Line_1__c,  '
              + '        LS_Contract__r.Billing_Address_Line_2__c,  '
              + '        LS_Contract__r.City__c,                    '
              + '        LS_Contract__r.State__c,                   '
              + '        LS_Contract__r.Zip_Code__c,                '
              + '        LS_Contract__r.Customer_Primary_Phone__c,  '
              + '        Invoice_Due_Date__c,                       '
              + '        clcommon__Consolidated_Invoice__c,         '
              + '        (SELECT Id,                                '
              + '                Name,                              '
              + '                cllease__Transaction_Date__c       '
              + '         FROM cllease_Bills__r)                    '
              + ' FROM clcommon__Consolidated_Invoice__c                                   '
              + ' WHERE File_Generated__c = \'No\'                  '
              + ' or Adjustment_Status__c = \'Approved\'            '
              + ' or void_in_pnc__c = true';

        if(InvoiceNames!=null && InvoiceNames.size() > 0) {
            String InvoiceNamesStr = '';
            for (String InvoiceName : InvoiceNames) {
                InvoiceNamesStr = InvoiceNamesStr + '\'' + String.escapeSingleQuotes(InvoiceName) + '\'' + ',';
            }
            InvoiceNamesStr = InvoiceNamesStr.substring(0, InvoiceNamesStr.length() - 1);
            query += ' AND Name in ('+ InvoiceNamesStr + ')';
        }

        query += ' ORDER BY Name ';
        
        System.debug(LoggingLevel.ERROR, 'PNCFileCreationJob Query: '+query);
        return query;                                
    }

    public override void doStart(Database.BatchableContext bc) {
        
       
        //0. Checking for unfinished transactions in interface table.
        //   Incase of any unfinished transactions, job should not run till all txns commited to DLL
        //Throw exception and skip the job run in case of any unfinished transactions
        //    uncommittedInterfaceRecordsExist = true for all interface records not processed
        //                               = false for all interface records  processed
        Boolean uncommittedInterfaceRecordsExist = InterfaceTablesUnfinishedTxnsCheck.checkUnfinishedTxnsForPNCIntegration();
        System.debug('uncommittedInterfaceRecordsExist = ' + uncommittedInterfaceRecordsExist);
        /*if(uncommittedInterfaceRecordsExist) {
            throw new CLSCustomException('PNC Interface table(Int_PX_Billing__c) has unfinished transactions. '+
                                      'Please commit all transactions from Interface table and run Job again...');
        }*/
        
        
        //AHR
        List<Int_PX_Billing__c> headerRecordList = new List<Int_PX_Billing__c>();
        String Ti = Datetime.now().format('hhmmss');
        Datetime currentDate = Datetime.now();
        String dt = currentDate.format('MMddyyyy');
        System.debug('Date...'+dt );

        linesheader = '';
        linesheader = '1|BILLDATA|PNC|3517|SUM|'+dt+'|'+Ti;
        
        Int_PX_Billing__c header = new Int_PX_Billing__c();
        header.Line_Data__c = linesheader;
        headerRecordList.add(header);
             
        //Added by AHR.       
        Int_PX_Billing__c headerLine = new Int_PX_Billing__c();
        headerLine.Line_Data__c = '';
        headerLine.Line_Data__c += 'RecordType|ReferenceNumber|OtherData|dtStatement|';
        headerLine.Line_Data__c += 'dtDue|BillerInvoiceNo|NameFirst|MiddleName|NameLast|'; 
        headerLine.Line_Data__c += 'CompanyName|Address|Address2|City|State|Zip|Phone|Fax|';
        headerLine.Line_Data__c += 'PreviousBalance|PaymentReceived|CurrentCharges|AmountDue|';
        headerLine.Line_Data__c += 'EmailAddress|FDICode|PmtTypeAllowed|BillStatus|MasterNumber|'; 
        headerLine.Line_Data__c += 'OpenField1|OpenField2|Message|CustomerCode|SalesTax|PurchaseID|'; 
        headerLine.Line_Data__c += 'DeliveryZip|Discount Amount|FreightShippingAmt|DutyAmt|'; 
        headerLine.Line_Data__c += 'ItemCommodityCode|ProductName|ProductCode|Quantity|UnitofMeasure|';
        headerLine.Line_Data__c += 'UnitCost|DiscPerLineItem|LineItemTotal|DisplayField1';
        headerRecordList.add(headerLine);
        
        try {
            insert headerRecordList;
        } catch (Exception ex) {
             System.debug(LoggingLevel.ERROR, 'Could not save headerRecords in PNC Billing file. Exception = ' + ex.getmessage());
        }    
    }

    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {
  
		System.debug(LoggingLevel.ERROR, 'TTTTTT');
        Savepoint sp = database.setsavepoint();
        try {
            String linesbody='';  
            List<clcommon__Consolidated_Invoice__c> invoiceList = (List<clcommon__Consolidated_Invoice__c>)scope;  
            List<Int_PX_Billing__c> linesRecords= new List<Int_PX_Billing__c>();
            integer localcount =0;
            Decimal localsum = 0.0;
                
            User userRec = [Select Id, cllease__Current_Branch_s_System_Date__c from user WHERE id =: UserInfo.getUserId()];
            Date TodaysDate = userRec.cllease__Current_Branch_s_System_Date__c;
            Date SystemDate = Date.newinstance(TodaysDate.year(),TodaysDate.month(),TodaysDate.day());
            List<clcommon__Consolidated_Invoice__c> invoiceLi = new List<clcommon__Consolidated_Invoice__c>();
            for(clcommon__Consolidated_Invoice__c record: invoiceList) {
                linesbody = '';
                string InvoiceDuedate = DateTime.newInstance(record.Invoice_Due_Date__c.year(),
                                                             record.Invoice_Due_Date__c.month(),
                                                             record.Invoice_Due_Date__c.day()).format('MM/dd/yyyy');
                     
                System.debug('Invoice_Due_Date...'+InvoiceDuedate);
                String invoiceStmtDate;
                if(record.cllease__Bills__r.size() > 0 ) {
                    cllease__Lease_account_Due_Details__c bill = record.cllease__Bills__r.get(0);
                    //invoiceStmtDate = bill.cllease__Transaction_Date__c.format('MM/dd/yyyy');
                    invoiceStmtDate = DateTime.newInstance(bill.cllease__Transaction_Date__c.year(),
                                                           bill.cllease__Transaction_Date__c.month(),
                                                           bill.cllease__Transaction_Date__c.day()).format('MM/dd/yyyy');
                } else {
                    invoiceStmtDate = record.Createddate.format('MM/dd/yyyy');
                }

                String nameFirst = '';
                String middleName = '';
                String nameLast = '';
                String companyName = record.LS_Contract__r.Customer__c;
                if(companyName == null) {
                    companyName = '';
                }

                String address = record.LS_Contract__r.Billing_Address_Line_1__c;
                if(address == null) {
                    address = '';
                }

                String address2 = record.LS_Contract__r.Billing_Address_Line_2__c;
                if(address2 == null) {
                    address2 = '';
                }

                String city = record.LS_Contract__r.City__c;
                if(city == null) {
                    city = '';
                }

                String state = record.LS_Contract__r.State__c;
                if(state == null) {
                    state = '';
                }
              
                String zipCode = record.LS_Contract__r.Zip_Code__c;
                if(zipCode == null) {
                    zipCode = '';
                }

                String phoneNumber = record.LS_Contract__r.Customer_Primary_Phone__c;
                if(phoneNumber == null) {
                    phoneNumber = '';
                }

                String accountNumber = record.LS_Contract__r.Account_Number__c;
                if(accountNumber == null) {
                    accountNumber = '';
                }

                String fax = '';

                String prevBalance = '';
                String pmtReceived = '';
                String currentCharges = '';

                String emailAddr = record.LS_Contract__r.Billing_Email__c;
                if(emailAddr == null) {
                    emailAddr = '';
                }

                String fdiCode = '';
                String pmtType = 'CC;DEBIT;CREDIT';
                String billStatus = '';
                if (record.void_in_pnc__c == true)
                    billStatus = 'Expired';
                String masterNumber = '';
                String openField1 = '';
                String openField2 = '';
                String message = '';
                String customerCode = '';
                String salesTax = '';
                String purchaseId = '';
                String deliveryZip = '';
                String discountAmt = '';
                String freightShippingAmt = '';
                String dutyAmt ='';
                String itemCommodityCode = '';
                String productName = '';
                String productCode = '';
                String quantity = '';
                String unitOfMeasure = '';
                String unitCost = '';
                String discPerLineItem = '';
                String lineItemTotal = '';
                String displayField1 = record.LS_Contract__r.Name;
                        
                linesbody += '6';                                           //RecordType
                linesbody += '|' + accountNumber;                           //ReferenceNumber
                linesbody += '|' + accountNumber;                           //OtherData
                linesbody += '|' + invoiceStmtDate;                         //dtStatement 
                linesbody += '|' + invoiceDuedate;                          //dtDue
                linesbody += '|' + record.Name;                             //BillerInvoiceNo
                linesbody += '|' + nameFirst;                               //NameFirst
                linesbody += '|' + middleName;                              //MiddleName
                linesbody += '|' + nameLast;                                //NameLast
                linesbody += '|' + companyName;                             //CompanyName
                linesbody += '|' + address;                                 //Address
                linesbody += '|' + address2;                                //Address2
                linesbody += '|' + city;                                    //City
                linesbody += '|' + state;                                   //State
                linesbody += '|' + zipCode;                                 //Zip
                linesbody += '|' + phoneNumber;                             //Phone
                linesbody += '|' + fax;                                     //Fax
                linesbody += '|' + prevBalance;                             //PreviousBalance
                linesbody += '|' + pmtReceived;                             //PaymentReceived
                linesbody += '|' + currentCharges;                          //CurrentCharges
                if (record.void_in_pnc__c == true){
                     linesbody += '|' + record.sent_to_pnc_amount__c;            //AmountDue
                     localsum += record.sent_to_pnc_amount__c; 
                }
                else{
                    linesbody += '|' + record.Balance_Due_Amount__c;            //AmountDue
                    localsum += record.Balance_Due_Amount__c;
                }

                
                linesbody += '|' + emailAddr;                               //EmailAddress
                linesbody += '|' + fdiCode;                                 //FDICode
                linesbody += '|' + pmtType;                                 //PmtTypeAllowed
                linesbody += '|' + billStatus;                              //BillStatus
                linesbody += '|' + masterNumber;                            //MasterNumber
                linesbody += '|' + openField1;                              //OpenField1
                linesbody += '|' + openField2;                              //OpenField2
                linesbody += '|' + message;                                 //Message
                linesbody += '|' + customerCode;                            //CustomerCode
                linesbody += '|' + salesTax;                                //SalesTax
                linesbody += '|' + purchaseId;                              //PurchaseID
                linesbody += '|' + deliveryZip;                             //DeliveryZip
                linesbody += '|' + discountAmt;                             //Discount Amount
                linesbody += '|' + freightShippingAmt;                      //FreightShippingAmt
                linesbody += '|' + dutyAmt;                                 //DutyAmt
                linesbody += '|' + itemCommodityCode;                       //ItemCommodityCode
                linesbody += '|' + productName;                             //ProductName
                linesbody += '|' + productCode;                             //ProductCode
                linesbody += '|' + quantity;                                //Quantity
                linesbody += '|' + unitOfMeasure;                           //UnitofMeasure
                linesbody += '|' + unitCost;                                //UnitCost
                linesbody += '|' + discPerLineItem;                         //DiscPerLineItem
                linesbody += '|' + lineItemTotal;                           //LineItemTotal
                linesbody += '|' + displayField1;                           //DisplayField1

                Int_PX_Billing__c aline = new Int_PX_Billing__c();
                aline.Line_Data__c = linesbody;
                aline.Committed__c = false;
                linesRecords.add(aline);
                
                localcount ++;
                
                record.File_Generated__c = 'Yes'; 
                record.File_Generated_On__c = SystemDate;
                if (record.void_in_pnc__c == true){
                    record.voided_in_pnc__c = true;
                    record.voided_in_pnc_date_time__c = datetime.now();
                    record.void_in_pnc__c = false;
                }
                if (record.adjustment_status__c == 'Approved'){
                    record.adjustment_status__c = 'Posted to PNC';
                    record.adjusted_in_pnc__c = true;
                    record.adjusted_in_pnc_date_time__c = datetime.now();
                }

                invoiceLi.add(record);
            }
                  
            if(linesRecords.size() > 0) {
                insert linesRecords;
            }
            
            if(invoiceLi.size() > 0) {
                update invoiceLi;
            }
        
            publicCount += localcount;
            publicSum += localsum;                 
                 
        } catch(Exception e) {
            database.rollback(sp);   
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());            
            //insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name='PNCFileCreationJob',
                                                    cllease__Date__c=system.today(),
                                                    cllease__Message__c='Error is '+e.getmessage()
                                                            +' in line number: '+ e.getlinenumber());
        }
    }

    public override void doFinish(Database.BatchableContext bc) {
        // Footer creation
        String linesfoter = '9|'+publicCount+'|'+publicSum+'|0|0';
        system.debug('lines!!!'+linesfoter);
        insert new Int_PX_Billing__c(Line_Data__c = linesfoter);
        
        if (publicCount == 0)	
        	NewCoUtility.markBillingCommitted();
    }

    public override void doInitialize() { }

}