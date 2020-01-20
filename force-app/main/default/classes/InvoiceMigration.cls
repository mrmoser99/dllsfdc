/**
 * Owner: CLS-Q2
 * Date : 10/31/2019
 * Description: Invoice migration job to migrate data from old invoice object to new invoice object.
 **/
global class InvoiceMigration implements Database.Batchable<sObject>{
    public List<String> invoiceName;
    public Map<String, Account> accountNameToId;
    global InvoiceMigration(List<String> invoiceName){
        this.invoiceName = invoiceName;
        setAccountMap();
    }
    
    global InvoiceMigration(){
        this.invoiceName = null;
        setAccountMap();
    }
    
    public void setAccountMap(){
        List<Account> accounts = [SELECT ID, NAME, clcommon__Default_Billing_Group__c FROM Account];
        accountNameToId = new Map<String, Account>();
        for(Account acc : accounts){
            accountNameToId.put(acc.Name, acc);
        }
    }
    
    public String getJobQuery(List<String> invoiceName){
        String query = 'SELECT ID,NAME,Previous_Balance_Due__c,Adjusted_in_PNC__c,Adjusted_in_PNC_Date_Time__c,Customer_Name__c,';
        query += 'Adjustment_Status__c,Conga_URL__c,End_Date__c,File_Generated__c,File_Generated_On__c,Total_Amount_Due__c,';
        query += 'Invoice_Due_Date__c,Invoice_Emailed__c,Invoice_Period_End_Date__c,Invoice_Period_Start_Date__c,Number_of_Charges__c,';
        query += 'Paid_Invoice_Amount__c,Payment_Amount__c,Payment_Amount_Total__c,Payment_Sales_Tax__c,Sent_To_PNC__c,';
        query += 'Sent_To_PNC_Amount__c,Sent_To_PNC_Date_Time__c,Billed_Amount__c,Total_of_Charge_Waived__c,Voided_In_PNC__c,';
        query += 'Voided_In_PNC_Date_Time__c,Void_In_PNC__c,Migrated__c,';
        query += '(SELECT ID, cllease__Consolidated_Invoice__c, Invoiced_In__c FROM Invoice_Bills__r),';
        query += '(SELECT ID, cllease__Consolidated_Invoice__c, Invoiced_In__c FROM Invoice_Charges__r),';
        query += '(SELECT ID, Consolidated_Invoice__c, Invoice__c FROM Due_Detail_Lines__r)';
        query += ' FROM Invoice__c';
        if(invoiceName != null){
            String invoiceNumbers = '';
            for (String invocie : invoiceName) {
              invoiceNumbers = invoiceNumbers + '\'' + String.escapeSingleQuotes(invocie) + '\'' + ',';
            }
            invoiceNumbers = invoiceNumbers.substring(0, invoiceNumbers.length() - 1);
            query += ' WHERE NAME IN (' + invoiceNumbers + ')' + ' AND Migrated__c = false';
        }
        else{
            query += ' WHERE Migrated__c = false';
        }
        return query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug(LoggingLevel.ERROR, '^^^^ invoiceName : ' + this.invoiceName);
        String query = getJobQuery(this.invoiceName);
        System.debug(LoggingLevel.ERROR, '^^^ query : ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        System.debug(LoggingLevel.ERROR, '^^^ scope : ' + scope);
        List<Invoice__c> invoiceList = (List<Invoice__c>) scope;
        List<Invoice__c> invoiceToUpdate = new List<Invoice__c>();
        List<clcommon__Consolidated_Invoice__c> newMigratedInvoice = new List<clcommon__Consolidated_Invoice__c>();
        List<cllease__Lease_account_Due_Details__c> billsToUpdate = new List<cllease__Lease_account_Due_Details__c>();
        List<cllease__Charge__c> chargesToUpdate = new List<cllease__Charge__c>();
        List<cllease__Due_Detail_Lines__c> dueDetailsToUpdate = new list<cllease__Due_Detail_Lines__c>();
        
        Savepoint sp = Database.setSavepoint();
        
        try{
            for(Invoice__c invoiceOld : invoiceList){
                clcommon__Consolidated_Invoice__c newInvoice = new clcommon__Consolidated_Invoice__c();
                newInvoice.Previous_Balance_Due__c = invoiceOld.Previous_Balance_Due__c;
                newInvoice.Adjusted_in_PNC__c = invoiceOld.Adjusted_in_PNC__c;
                newInvoice.Adjusted_in_PNC_Date_Time__c = invoiceOld.Adjusted_in_PNC_Date_Time__c;
                newInvoice.Adjustment_Status__c = invoiceOld.Adjustment_Status__c;
                newInvoice.Conga_URL__c = invoiceOld.Conga_URL__c;
                //newInvoice.End_Date__c = invoiceOld.End_Date__c;
                newInvoice.File_Generated__c = invoiceOld.File_Generated__c;
                newInvoice.File_Generated_On__c = invoiceOld.File_Generated_On__c;
                newInvoice.Invoice_Due_Date__c = invoiceOld.Invoice_Due_Date__c;
                newInvoice.Invoice_Emailed__c = invoiceOld.Invoice_Emailed__c;
                newInvoice.Invoice_Period_End_Date__c = invoiceOld.Invoice_Period_End_Date__c;
                newInvoice.Invoice_Period_Start_Date__c = invoiceOld.Invoice_Period_Start_Date__c;
                newInvoice.Number_of_Charges__c = invoiceOld.Number_of_Charges__c;
                //newInvoice.Paid_Invoice_Amount__c = invoiceOld.Paid_Invoice_Amount__c;
                //newInvoice.Payment_Amount__c = invocieOld.Payment_Amount__c;
                //newInvoice.Payment_Amount_Total__c = invocieOld.Payment_Amount_Total__c;
                //newInvoice.Payment_Sales_Tax__c = invoiceOld.Payment_Sales_Tax__c;
                newInvoice.Sent_To_PNC__c = invoiceOld.Sent_To_PNC__c;
                newInvoice.Sent_To_PNC_Amount__c = invoiceOld.Sent_To_PNC_Amount__c;
                newInvoice.Sent_To_PNC_Date_Time__c = invoiceOld.Sent_To_PNC_Date_Time__c;
                newInvoice.Billed_Amount__c = invoiceOld.Billed_Amount__c;
                newInvoice.Total_of_Charge_Waived__c = invoiceOld.Total_of_Charge_Waived__c;
                newInvoice.Voided_In_PNC__c = invoiceOld.Voided_In_PNC__c;
                newInvoice.Voided_In_PNC_Date_Time__c = invoiceOld.Voided_In_PNC_Date_Time__c;
                newInvoice.Void_In_PNC__c = invoiceOld.Void_In_PNC__c;
                newInvoice.InvoiceOLD__c = invoiceOld.Id;
                newInvoice.clcommon__Account__c = accountNameToId.get(invoiceOld.Customer_Name__c).Id;
                newInvoice.clcommon__Balance_Amount__c = invoiceOld.Total_Amount_Due__c;
                newInvoice.clcommon__Original_Amount__c = invoiceOld.Total_Amount_Due__c;
                newInvoice.clcommon__Status__c = 'Active';
                newInvoice.clcommon__Billing_Group__c = accountNameToId.get(invoiceOld.Customer_Name__c).clcommon__Default_Billing_Group__c;
                newInvoice.clcommon__Due_Date__c = invoiceOld.Invoice_Due_Date__c;
                invoiceOld.Migrated__c = true;
                newMigratedInvoice.add(newInvoice);
                invoiceToUpdate.add(invoiceOld);
            }
            // Insert new migrated invoice.
            Insert newMigratedInvoice;
            
            // Create a Map to link bills, charges and dues of old with new invoice
            Map<Id, Id> newInvoiceToOldInvoice = new Map<Id,Id>();
            for(clcommon__Consolidated_Invoice__c newInvoice : newMigratedInvoice)
                newInvoiceToOldInvoice.put(newInvoice.InvoiceOLD__c, newInvoice.Id);
            
            // Stamping reference of new invoice on bill
            for(Invoice__c invoiceOld : invoiceList){
                for(cllease__Lease_account_Due_Details__c bill : invoiceOld.Invoice_Bills__r){
                    bill.cllease__Consolidated_Invoice__c = newInvoiceToOldInvoice.get(bill.Invoiced_In__c);
                    bill.cllease__Invoiced__c = true;
                    billsToUpdate.add(bill);
                }
            }
            // Stamping reference of new invoice on charge
            for(Invoice__c invoiceOld : invoiceList){
                for(cllease__Charge__c charge : invoiceOld.Invoice_Charges__r){
                    charge.cllease__Consolidated_Invoice__c = newInvoiceToOldInvoice.get(charge.Invoiced_In__c);
                    charge.cllease__Invoiced__c = true;
                    chargesToUpdate.add(charge);
                }
            }
            // Stamping reference of new invoice on due details
            for(Invoice__c invoiceOld : invoiceList){
                for(cllease__Due_Detail_Lines__c dueDetail : invoiceOld.Due_Detail_Lines__r){
                    dueDetail.Consolidated_Invoice__c = newInvoiceToOldInvoice.get(dueDetail.Invoice__c);
                    dueDetailsToUpdate.add(dueDetail);
                }
            }
            
            // Comitting all bills, charges and due details
            Update billsToUpdate;
            Update chargesToUpdate;
            Update dueDetailsToUpdate;
            update invoiceToUpdate;
            
        } Catch(exception e){
            Database.rollback(sp);
            System.debug(LoggingLevel.ERROR, '^^^ Exception : ' + e.getMessage());
            System.debug(LoggingLevel.ERROR, '^^^ Stack Trace : ' + e.getStackTraceString());
            System.debug(LoggingLevel.ERROR, '^^^ Line : ' + e.getLineNumber());
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
}