public with sharing class InvoiceCreditHandler {
    private List<Cllease__Invoice_Credit__c> invoiceCreditList;
    private Map<Id, Cllease__Invoice_Credit__c> invoiceCreditOldMap;
    Set<Id> contractIds = new Set<Id>();
    Set<Id> productIds = new Set<Id>();
   	Set<Id> pmtIds = new Set<Id>();
    Map<Id, Id> leaseAccountProductMap = new Map<Id, Id>();
    Map<Id, Boolean> pmtMap = new Map<Id, Boolean>();
    Map<Id, List<Cllease__Accounting_Template_Line__c>> productAccountTemplateListMap = new Map<Id, List<Cllease__Accounting_Template_Line__c>>();
    List<Cllease__Accounting_Template_Header__c> accountingTemplatesHdrList = new List<Cllease__Accounting_Template_Header__c> ();
    List<Cllease__GL_Transaction_Detail__c> glTxnListToInsert = new List<Cllease__GL_Transaction_Detail__c>();
    List<Cllease__GL_Transaction_Detail__c> glReversalTxnListToInsert = new List<Cllease__GL_Transaction_Detail__c>();
    List<cllease__Lease_Payment_Transaction__c> pmtTransactions = new List<cllease__Lease_Payment_Transaction__c>();
    Map<String, String> objectColumnMap = new Map<String, String>();
    Map<Id, Id> contractBranchMap = new Map<Id, Id>();
    
    public class TransactionException extends Exception{}

    public InvoiceCreditHandler(List<Cllease__Invoice_Credit__c> newList, 
                                    Map<Id, Cllease__Invoice_Credit__c> oldMap) {
        this.invoiceCreditList = newList;
        this.invoiceCreditOldMap = oldMap;
    }

    public void initialize(){
        // Collecting all contract from the invoice credit which are being created and list of payments from Invoice.
        for(Cllease__Invoice_Credit__c credit : invoiceCreditList){
            contractIds.add(credit.Cllease__Contract__c);
            pmtIds.add(credit.Payment_Transaction__c);
        }
        
        List<cllease__Lease_Payment_Transaction__c > pmtList = [SELECT ID,
                                                                	cllease__Reversed__c
                                                                    FROM cllease__Lease_Payment_Transaction__c
                                                                    WHERE ID IN : pmtIds];
        // Get status of payment from Invoice so that if it is a reversed payment then we should not be creating accounting for invoice credit.
        for(cllease__Lease_Payment_Transaction__c lpt : pmtList){
            pmtMap.put(lpt.Id, lpt.cllease__Reversed__c);
        }

        // Query product id where ids contractIds.
        // in order to get the template header and template line for accounting from the contract.
        List<Cllease__Lease_Account__c> leaseAccountList = [SELECT Cllease__Lease_Product_Name__c, Cllease__Branch__c FROM Cllease__Lease_Account__c WHERE Id IN : contractIds];
        for(Cllease__Lease_Account__c leaseAccount : leaseAccountList){
            productIds.add(leaseAccount.Cllease__Lease_Product_Name__c);
            leaseAccountProductMap.put(leaseAccount.Id, leaseAccount.Cllease__Lease_Product_Name__c);
            contractBranchMap.put(leaseAccount.Id, leaseAccount.Cllease__Branch__c);
        }
        
        accountingTemplatesHdrList =[SELECT ID,
                                            Cllease__Product__c,
                                            Cllease__Securitization_Flag__c,
                                            Cllease__Transaction_Type__c,
                                            (SELECT Id,
                                                Name,
                                                Cllease__Accounting_Template_Header__c,
                                                Cllease__Credit_GL_Account__c,
                                                Cllease__Debit_GL_Account__c,
                                                Cllease__Description__c,
                                                Cllease__Enabled__c,
                                                Cllease__Amount_Object__c,
                                                Cllease__Amount_Object_Column__c,
                                                Cllease__Transaction_Sub_Type__c,
                                                Cllease__Transaction_Sub_Type__r.name,
                                                Cllease__Transaction_Type__c,
                                                Cllease__Bill_As_Invoice__c,
                                                Cllease__Item_Id__c,
                                                Cllease__Item_Name__c
                                            FROM Cllease__Accounting_Template_Lines__r
                                            WHERE Cllease__Enabled__c = true)
                                        FROM Cllease__Accounting_Template_Header__c
                                        WHERE Cllease__Enabled__c = true
                                            AND (Cllease__Product__c in :productIds)
                                            AND Cllease__Transaction_Type__c = 'INVOICE CREDIT'
                                            ORDER BY Cllease__Product__c, Cllease__Transaction_Type__c];
        for(Cllease__Accounting_Template_Header__c header : accountingTemplatesHdrList){
            productAccountTemplateListMap.put(header.Cllease__Product__c, header.Cllease__Accounting_Template_Lines__r);
        }

        List<Cllease__Amount_Columns__c> amountObjectColumns = [SELECT Name,
                                                Cllease__Amount_Object__r.Name,
                                                Cllease__Amount_Object__r.Cllease__Api_Name__c,
                                                Cllease__Column_Api_Name__c
                                            FROM Cllease__Amount_Columns__c
                                            WHERE Cllease__Amount_Object__r.Cllease__Active__c = TRUE];

        if(amountObjectColumns.size() == 0) {
           throw new TransactionException('Please setup accounting object.');
        }

        for(Cllease__Amount_Columns__c cols : amountObjectColumns) {
            String colkey = cols.Cllease__Amount_Object__r.Name + '|' + cols.Name;
            String valkey = cols.Cllease__Amount_Object__r.Cllease__Api_Name__c + '|' + cols.Cllease__Column_API_Name__c;
            objectColumnMap.put(colkey, valkey);
        }

    }
    
    
    public void beforeInsertHandler(){
        Set<String> lptNames = new Set<String>();
        Map<String, Id> lptNameAndIdMap = new Map<String, Id>();
        for(cllease__Invoice_Credit__c invoice : invoiceCreditList){
            if(invoice.cllease__Comments__c != null && invoice.cllease__Comments__c.length() > 0){
                lptNames.add(invoice.cllease__Comments__c);
            }
        }
        
        //Query all the lpt with above set of name and form a map between string and id to get the lpt id.
        List<cllease__Lease_Payment_Transaction__c > pmtList = [SELECT ID,
                                                                    NAME, 
                                                                	cllease__Reversed__c
                                                                    FROM cllease__Lease_Payment_Transaction__c
                                                                    WHERE Name IN : lptNames];
        for(cllease__Lease_Payment_Transaction__c lpt : pmtList){
            lptNameAndIdMap.put(lpt.Name, lpt.Id);
            pmtMap.put(lpt.Id, lpt.cllease__Reversed__c);
        }
        
        System.debug(LoggingLevel.ERROR, '^^^^ lptNameAndIdMap : ' + lptNameAndIdMap);
        System.debug(LoggingLevel.ERROR, '^^^^ pmtMap : ' + pmtMap);
        
        for(cllease__Invoice_Credit__c invoice : invoiceCreditList){
            System.debug(LoggingLevel.ERROR, '^^^^ invoice : ' + invoice);
            if(invoice.Payment_Transaction__c == null && invoice.cllease__Comments__c != null && invoice.cllease__Comments__c.length() > 0){
                if(lptNameAndIdMap.containsKey(invoice.cllease__Comments__c)){
                    invoice.Payment_Transaction__c = lptNameAndIdMap.get(invoice.cllease__Comments__c);
                }      
            }
        }
    }
    
    public void beforeUpdateHandler() {
        Set<Id> invoiceIds = new Set<Id>();
        Map<Id, List<Cllease__GL_Transaction_Detail__c>> invoiceGlListMap = new Map<Id, List<Cllease__GL_Transaction_Detail__c>>();

        for(Cllease__Invoice_Credit__c invoice : invoiceCreditList){
            Cllease__Invoice_Credit__c oldInvoice = invoiceCreditOldMap.get(invoice.Id);
            if(invoice.Cllease__Status__c == 'Cancelled' && oldInvoice.Cllease__Status__c != 'Cancelled'){
                invoice.cllease__Credit_Balance__c = 0;
                invoiceIds.add(invoice.id);
            }
        }

        List<Cllease__GL_Transaction_Detail__c> existingGlTxn = [SELECT Id, 
                                                            Cllease__Transaction_Type__c,
                                                            Cllease__Charge__c,
                                                            Cllease__Company__c,
                                                            Cllease__Contract__c,
                                                            Cllease__Credit_Amount__c,
                                                            Cllease__Credit_GL_Account__c,
                                                            Cllease__Credit_GL_Account_Code__c,
                                                            Cllease__Debit_Amount__c,
                                                            Cllease__Debit_GL_Account__c,
                                                            Cllease__Debit_GL_Account_Code__c,
                                                            Cllease__Exported_Flag__c,
                                                            Cllease__Exported_Date__c,
                                                            Cllease__GL_Batch_Post_Date__c,
                                                            Cllease__GL_Date__c,
                                                            Cllease__Item_Id__c,
                                                            Cllease__Item_Name__c,
                                                            Invoice_Credit__c,
                                                            cllease__Transaction_Description__c,
                                                            Cllease__LeaseApplicationNumber__c
                                                            FROM Cllease__GL_Transaction_Detail__c WHERE Invoice_Credit__c IN : invoiceIds];

        for(Cllease__GL_Transaction_Detail__c gl : existingGlTxn){
            List<Cllease__GL_Transaction_Detail__c> glList = new List<Cllease__GL_Transaction_Detail__c>();
            if(invoiceGlListMap.containsKey(gl.Invoice_Credit__c)){
                glList = invoiceGlListMap.get(gl.Invoice_Credit__c);
                glList.add(gl);
            } else{
                glList.add(gl);
            }
            invoiceGlListMap.put(gl.Invoice_Credit__c, glList);
        }

        for(Id invoice : invoiceIds){
            if(invoiceGlListMap.containsKey(invoice)){
                for(Cllease__GL_Transaction_Detail__c glEntry : invoiceGlListMap.get(invoice)){
                    Cllease__GL_Transaction_Detail__c reversalEntry = new Cllease__GL_Transaction_Detail__c();
                    reversalEntry = glEntry.clone();
                    reversalEntry.Cllease__Debit_GL_Account__c = glEntry.Cllease__Credit_GL_Account__c;
                    reversalEntry.Cllease__Credit_GL_Account__c = glEntry.Cllease__Debit_GL_Account__c;
                    reversalEntry.Cllease__Exported_Date__c = null;
                    reversalEntry.Cllease__Exported_Flag__c = false;
                    reversalEntry.Cllease__GL_Date__c = cllease.SystemDateUtil.getCurrentSystemDate();
                    reversalEntry.cllease__Transaction_Description__c += ' - REVERSAL';
                    glReversalTxnListToInsert.add(reversalEntry);
                }
            }
        }
        System.debug(LoggingLevel.ERROR, '^^^^ glReversalTxnListToInsert : ' + glReversalTxnListToInsert);
        insert glReversalTxnListToInsert;
    }
    
    public void afterInsertHandler() {
        initialize();
        Boolean pmtReversed;
        for(Cllease__Invoice_Credit__c invoice : invoiceCreditList){
            if(pmtMap.containsKey(invoice.Payment_Transaction__c)){
                pmtReversed = pmtMap.get(invoice.Payment_Transaction__c);
            }
            else{
                pmtReversed = False;
            }
            System.debug(LoggingLevel.ERROR, '^^^^ pmtReversed : ' + pmtReversed);
            if(!pmtReversed){
                Id contractId = invoice.Cllease__Contract__c;
                Id productId = leaseAccountProductMap.get(contractId);
                for(Cllease__Accounting_Template_Line__c line : productAccountTemplateListMap.get(productId)){
                    String columnKey = line.Cllease__Amount_Object__c + '|' + line.Cllease__Amount_Object_Column__c;
                    String fieldApi = objectColumnMap.get(columnKey).split('\\|')[1];
                    System.debug(LoggingLevel.ERROR, '^^^ fieldApi : ' + fieldApi);
                    Decimal amount = (Decimal) invoice.get(fieldApi);
                    Cllease__GL_Transaction_Detail__c glEntry = new Cllease__GL_Transaction_Detail__c();
                    glEntry.Cllease__Contract__c = invoice.Cllease__Contract__c;
                    glEntry.Cllease__Credit_Amount__c = amount;
                    glEntry.Cllease__Debit_Amount__c =  amount;
                    glEntry.Cllease__GL_Date__c = cllease.systemDateutil.getCurrentSystemDate();
                    glEntry.Cllease__Credit_GL_Account__c = line.Cllease__Credit_GL_Account__c;
                    glEntry.Cllease__Debit_GL_Account__c = line.Cllease__Debit_GL_Account__c;
                    glEntry.Cllease__Transaction_Type__c = line.Cllease__Transaction_Sub_Type__c;
                    glEntry.Cllease__Company__c = contractBranchMap.get(invoice.Cllease__Contract__c);
                    glEntry.Cllease__Transaction_Description__c = line.get('Name') + ' - ' + line.name;
                    glEntry.Invoice_Credit__c = invoice.id;
                    glTxnListToInsert.add(glEntry);
                }
            }
        }
        System.debug(LoggingLevel.ERROR, '^^^ glTxnListToInsert : ' + glTxnListToInsert);
        insert glTxnListToInsert;
    }
}