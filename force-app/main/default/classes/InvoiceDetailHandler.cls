/**
 * Owner: CLS-Q2
 * Date : 09/12/2019
 * Description: Has the api/business logic for the invoice update trigger to updated custom fields required.
 * All the values which are to be updated on the invoice object by any any of below action is handled here
 * 1. Adding bill to an invoice
 * 2. Addinf charge to an invoice
 * 3. Removal of bills/Charges from an invoice
 * 4. Payment related field changes in bills and charges which are to be copied back to invoice.
 **/
 
public with sharing class InvoiceDetailHandler{
    private List<cllease__Lease_account_Due_Details__c > newBills = new List<cllease__Lease_account_Due_Details__c >();
	private Map<Id, cllease__Lease_account_Due_Details__c > oldBills;
    private Map<Id, cllease__Charge__c> oldCharges;
    private List< cllease__Charge__c> newCharges = new List< cllease__Charge__c>();
    private Map<Id, Id> invoiceToContract = new Map<Id, Id>();
    private Map<Id, InvoiceDetail> invoiceFlag = new Map<Id, InvoiceDetail>();
    private Map<Id, cllease__Lease_account_Due_Details__c> invoiceDates = new Map<Id, cllease__Lease_account_Due_Details__c>();
    
    class InvoiceDetail{
        Boolean flag;
        Decimal amount;
        
        InvoiceDetail(Boolean flag, Decimal amount){
            this.flag = flag == null ? True : flag;
            this.amount = amount == null ? 0 : amount;
        }
    }

    public InvoiceDetailHandler(List<cllease__Lease_account_Due_Details__c> newBills, List<cllease__Lease_account_Due_Details__c> oldBills){
        this.newBills = newBills;
        this.oldBills = new Map<Id, cllease__Lease_account_Due_Details__c >(oldBills);
    }
    
    public InvoiceDetailHandler(List<cllease__Charge__c > newCharges, List<cllease__Charge__c > oldCharges){
        this.oldCharges = new Map<Id, cllease__Charge__c>(oldCharges);
        this.newCharges = newCharges;
    }
    
    // To update bill related values on the invoice record.
    public void updateInvoiceHandler(){
        try{
            Set<Id> invoiceIds = new Set<Id>();
            Set<Id> triggerBillIds = new Set<Id>();
            Map<Id, List<cllease__Lease_account_Due_Details__c>> billInvoiceGrouping = new Map<Id, List<cllease__Lease_account_Due_Details__c>>();
            List<clcommon__Consolidated_Invoice__c> invoices = new List<clcommon__Consolidated_Invoice__c>();
            // Get Ids of all the invoice to query bills and charges related to invoices
            // Forming a map of invoice id and list of bills which are passed through the trigger.
            for(cllease__Lease_account_Due_Details__c bill : newBills){
                if(bill.cllease__Consolidated_Invoice__c != null){
                    invoiceIds.add(bill.cllease__Consolidated_Invoice__c);
                    invoiceToContract.put(bill.cllease__Consolidated_Invoice__c, bill.cllease__Lease_Account__c);
                } else if(oldBills.get(bill.Id).cllease__Consolidated_Invoice__c != null){
                    invoiceIds.add(oldBills.get(bill.Id).cllease__Consolidated_Invoice__c);
                }
            }
            
            System.debug(LoggingLevel.ERROR, '^^^^ invoiceIds : ' + invoiceIds);
            if(invoiceIds.size() > 0){
                Map<Id, Cllease__Lease_Account__c> contractList = new Map<Id, Cllease__Lease_Account__c> ([SELECT Id,
                                                                                                               cllease__First_Payment_Date__c,
                                                                                                               cllease__Amount_to_Current__c 
                                                                                                               FROM Cllease__Lease_Account__c 
                                                                                                               WHERE Id IN : invoiceToContract.values()]);
                for(cllease__Lease_account_Due_Details__c bill : newBills){
                    List<cllease__Lease_account_Due_Details__c> billList = new List<cllease__Lease_account_Due_Details__c>();
                    triggerBillIds.add(bill.Id);
                    if(bill.cllease__Consolidated_Invoice__c != null){
                        if(billInvoiceGrouping.containsKey(bill.cllease__Consolidated_Invoice__c))
                            billList = billInvoiceGrouping.get(bill.cllease__Consolidated_Invoice__c);
                        billList.add(bill);
                        billInvoiceGrouping.put(bill.cllease__Consolidated_Invoice__c, billList);
                    } else if(oldBills.get(bill.Id).cllease__Consolidated_Invoice__c != null){
                        Id invoiceId = oldBills.get(bill.Id).cllease__Consolidated_Invoice__c;
                        if(billInvoiceGrouping.containsKey(invoiceId))
                            billList = billInvoiceGrouping.get(invoiceId);
                        billInvoiceGrouping.put(invoiceId, billList);
                    }
                    if(invoiceDates.containsKey(bill.cllease__Consolidated_Invoice__c)){
                        if(invoiceDates.get(bill.cllease__Consolidated_Invoice__c).cllease__Due_Date__c < bill.cllease__Due_Date__c)
                            invoiceDates.put(bill.cllease__Consolidated_Invoice__c, bill);
                    } else{
                        invoiceDates.put(bill.cllease__Consolidated_Invoice__c, bill);
                    }
                }
                // Need info from Invoice object which needs to be queried only for trigger.new
                List<clcommon__Consolidated_Invoice__c> invoiceDetails = [SELECT Id, 
                                                                            Update_Bill_Balance__c,
                                                                            Fee_Billed_Total_Amount__c
                                                                            FROM clcommon__Consolidated_Invoice__c
                                                                            WHERE Id IN : billInvoiceGrouping.keySet()];
                for(clcommon__Consolidated_Invoice__c invoice : invoiceDetails){
                    if(!invoiceFlag.containsKey(invoice.Id)){
                        InvoiceDetail invoiceinfo = new InvoiceDetail(invoice.Update_Bill_Balance__c, invoice.Fee_Billed_Total_Amount__c);
                        invoiceFlag.put(invoice.Id, invoiceinfo);
                    }
                }
                System.debug(LoggingLevel.ERROR, '^^^^ billInvoiceGrouping : ' + billInvoiceGrouping);
                // Query all bills and charges which are part of invoice
                List<cllease__Lease_account_Due_Details__c> allBills = [SELECT ID,
                                                                            cllease__Lease_Account__r.cllease__First_Payment_Date__c,
                                                                            cllease__Due_Date__c,
                                                                            cllease__Rental_Due_Amount__c ,
                                                                            cllease__Tax_Due_Amount__c,
                                                                            cllease__Total_Due_Amount__c,
                                                                            cllease__Total_Paid_Amount__c,
                                                                            cllease__Consolidated_Invoice__c,
                                                                            cllease__Rental_Paid_Amount__c,
                                                                            cllease__Tax_Paid_Amount__c,
                                                                        	cllease__Period_Start_Date__c,
                                                                        	cllease__Period_End_Date__c,
                                                                            cllease__Consolidated_Invoice__r.Update_Bill_Balance__c,
                                                                            cllease__Consolidated_Invoice__r.Fee_Billed_Total_Amount__c,
                                                                            cllease__Payment_Stream__r.cllease__Period_Start_Date__c,
                                                                            cllease__Payment_Stream__r.cllease__Period_End_Date__c
                                                                        FROM cllease__Lease_account_Due_Details__c
                                                                        WHERE cllease__Consolidated_Invoice__c IN : invoiceIds
                                                                        ORDER BY cllease__Due_Date__c ASC];
                
                // Geting the bill from which we need to take the period start date and end date for an invoice
                for(cllease__Lease_account_Due_Details__c bill: allBills){                
                    if(invoiceDates.containsKey(bill.cllease__Consolidated_Invoice__c)){
                        if(invoiceDates.get(bill.cllease__Consolidated_Invoice__c).cllease__Due_Date__c < bill.cllease__Due_Date__c)
                            invoiceDates.put(bill.cllease__Consolidated_Invoice__c, bill);
                    } else{
                        invoiceDates.put(bill.cllease__Consolidated_Invoice__c, bill);
                    }
                }
                System.debug(LoggingLevel.ERROR, '^^^^ invoiceDates : ' + invoiceDates);
                // Add other bills which are not modified but it belong to same invoice
                for(cllease__Lease_account_Due_Details__c bill : allBills){
                    List<cllease__Lease_account_Due_Details__c> billList = new List<cllease__Lease_account_Due_Details__c>();
                    if(!triggerBillIds.contains(bill.Id) && bill.cllease__Consolidated_Invoice__c != null){
                        if(billInvoiceGrouping.containsKey(bill.cllease__Consolidated_Invoice__c))
                            billList = billInvoiceGrouping.get(bill.cllease__Consolidated_Invoice__c);
                        billList.add(bill);
                        billInvoiceGrouping.put(bill.cllease__Consolidated_Invoice__c, billList);
                    }
                }
                
                // Looping through all invoice and calculated DLL required values.
                System.debug(LoggingLevel.ERROR, '^^^^ invoiceToContract : ' + invoiceToContract);
                System.debug(LoggingLevel.ERROR, '^^^^ contractList : ' + contractList);
                for(Id key : billInvoiceGrouping.keySet()){
                    Cllease__Lease_Account__c contract = contractList.get(invoiceToContract.get(key));
                    Decimal previousBalance = 0;
                    Decimal totalBillAmount = 0, totalTaxAmount = 0;
                    Decimal totalRentPaid = 0 , totalTaxPaid = 0;
                    clcommon__Consolidated_Invoice__c invoice = new clcommon__Consolidated_Invoice__c(Id = key);
                    if(contractList.containsKey(invoiceToContract.get(key)))
                        previousBalance = contractList.get(invoiceToContract.get(key)).cllease__Amount_to_Current__c;
                    if(billInvoiceGrouping.get(key).size() > 0){
                        for(cllease__Lease_account_Due_Details__c bill : billInvoiceGrouping.get(key)){
                            totalBillAmount += bill.cllease__Rental_Due_Amount__c;
                            totalTaxAmount  += bill.cllease__Tax_Due_Amount__c;
                            totalRentPaid += bill.cllease__Rental_Paid_Amount__c;
                            totalTaxPaid += bill.cllease__Tax_Paid_Amount__c;
                            if(!invoiceFlag.containsKey(key)){
                                InvoiceDetail invoiceinfo = new InvoiceDetail(bill.cllease__Consolidated_Invoice__r.Update_Bill_Balance__c,
                                                                             bill.cllease__Consolidated_Invoice__r.Fee_Billed_Total_Amount__c);
                                invoiceFlag.put(key, invoiceinfo);
                            }
                        }
                    }
                    if(invoiceDates.containsKey(key)){
                        cllease__Lease_account_Due_Details__c bill = invoiceDates.get(key);
                        System.debug(LoggingLevel.ERROR, '^^^^ bill : ' + bill);
                        System.debug(LoggingLevel.ERROR, '^^^^ payment Spread : ' + bill.cllease__Period_Start_Date__c);
                        System.debug(LoggingLevel.ERROR, '^^^^ payment Spread : ' + bill.cllease__Period_End_Date__c);
                        invoice.Invoice_Period_Start_Date__c = bill.cllease__Period_Start_Date__c;
                        invoice.Invoice_Period_End_Date__c = bill.cllease__Period_End_Date__c;
                    }
                    invoice.Billed_Amount__c = totalBillAmount + totalTaxAmount;
                    invoice.Rent_Billed__c = totalBillAmount;
                    invoice.Rent_Tax_Billed__c = totalTaxAmount;
                    invoice.Rent_Billed_Total__c = totalBillAmount + totalTaxAmount;
                    invoice.Total_Rent_Paid__c  = totalRentPaid;
                    invoice.Total_Rent_Tax_Paid__c = totalTaxPaid;
                    invoice.Total_Bill_Paid_Amount__c = totalRentPaid + totalTaxPaid;
                    if(invoiceToContract.get(key) != null)
                        invoice.LS_Contract__c = invoiceToContract.get(key);
                    System.debug(LoggingLevel.ERROR, '^^^^ invoiceFlag.get(key) : ' + invoiceFlag.get(key));
                    if(!invoiceFlag.get(key).flag){
                        cllease__Lease_account_Due_Details__c bill = invoiceDates.get(key);
                        if(bill.cllease__Due_Date__c > contract.cllease__First_Payment_Date__c)
                            invoice.Previous_Balance_Due__c = previousBalance - invoice.Billed_Amount__c - invoiceFlag.get(key).amount;
                        else{
                            invoice.Previous_Balance_Due__c = 0;
                            invoice.Update_Charge_Balance__c = true;
                        }
                        invoice.Update_Bill_Balance__c = true;
                    }
                    System.debug(LoggingLevel.ERROR, '^^^^ invoice : ' + invoice);
                    invoices.add(invoice);
                }
                update invoices;
            }
        } catch(Exception e){
            System.debug(LoggingLevel.ERROR, '^^^^ e : ' + e.getStackTraceString());
            System.debug(LoggingLevel.ERROR, '^^^^ e : ' + e.getMessage());
            System.debug(LoggingLevel.ERROR, '^^^^ e : ' + e.getCause());
            System.debug(LoggingLevel.ERROR, '^^^^ e : ' + e.getLineNumber());
        }
    }
    
    // To update charge related values on the invoice record.
    public void updateInvoiceHandlerForCharges(){
        try{
            Set<Id> invoiceIds = new Set<Id>();
            Set<Id> triggerChargeIds = new Set<Id>();
            Map<Id, List<Cllease__Charge__c>> chargeInvoiceGrouping = new Map<Id, List<Cllease__Charge__c>>();
            List<clcommon__Consolidated_Invoice__c> invoices = new List<clcommon__Consolidated_Invoice__c>();
            // Get Ids of all the invoice to query bills and charges related to invoices
            // Forming a map of invoice id and list of bills which are passed through the trigger.
            for(Cllease__Charge__c charge : newCharges){
                if(charge.cllease__Consolidated_Invoice__c != null){
                    invoiceIds.add(charge.cllease__Consolidated_Invoice__c);
                    invoiceToContract.put(charge.cllease__Consolidated_Invoice__c, charge.cllease__Lease_Account__c);
                } else if(oldCharges.get(charge.Id).cllease__Consolidated_Invoice__c != null){
                    invoiceIds.add(oldCharges.get(charge.Id).cllease__Consolidated_Invoice__c);
                }
            }
            System.debug(LoggingLevel.ERROR, '^^^^ invoiceIds : ' + invoiceIds);
            if(invoiceIds.size() > 0){
                Map<Id, Cllease__Lease_Account__c> contractList = new Map<Id, Cllease__Lease_Account__c> ([SELECT Id,
                                                                                                               cllease__Amount_to_Current__c 
                                                                                                               FROM Cllease__Lease_Account__c 
                                                                                                               WHERE Id IN : invoiceToContract.values()]);
                
                for(Cllease__Charge__c charge : newCharges){
                    List<Cllease__Charge__c> chargeList = new List<Cllease__Charge__c>();
                    triggerChargeIds.add(charge.Id);
                    if(charge.cllease__Consolidated_Invoice__c != null){
                        if(chargeInvoiceGrouping.containsKey(charge.cllease__Consolidated_Invoice__c))
                            chargeList = chargeInvoiceGrouping.get(charge.cllease__Consolidated_Invoice__c);
                        chargeList.add(charge);
                        chargeInvoiceGrouping.put(charge.cllease__Consolidated_Invoice__c, chargeList);
                    } else if(oldCharges.get(charge.Id).cllease__Consolidated_Invoice__c != null){
                        Id invoiceId = oldCharges.get(charge.Id).cllease__Consolidated_Invoice__c;
                        if(chargeInvoiceGrouping.containsKey(invoiceId))
                            chargeList = chargeInvoiceGrouping.get(invoiceId);
                        chargeInvoiceGrouping.put(invoiceId, chargeList);
                    }
                }
                System.debug(LoggingLevel.ERROR, '^^^^ triggerChargeIds : ' + triggerChargeIds);
                // Need info from Invoice object which needs to be queried only for trigger.new
                List<clcommon__Consolidated_Invoice__c> invoiceDetails = [SELECT Id, 
                                                                            Update_Charge_Balance__c,
                                                                            Rent_Billed_Total__c 
                                                                            FROM clcommon__Consolidated_Invoice__c
                                                                            WHERE Id IN : chargeInvoiceGrouping.keySet()];
                for(clcommon__Consolidated_Invoice__c invoice : invoiceDetails){
                    if(!invoiceFlag.containsKey(invoice.Id)){
                        InvoiceDetail invoiceinfo = new InvoiceDetail(invoice.Update_Charge_Balance__c, invoice.Rent_Billed_Total__c);
                        invoiceFlag.put(invoice.Id, invoiceinfo);
                    }
                }
                System.debug(LoggingLevel.ERROR, '^^^^ chargeInvoiceGrouping : ' + chargeInvoiceGrouping);
                // Query all charges which are part of invoice
                List<Cllease__Charge__c> allCharges = [SELECT ID,
                                                         cllease__Date__c,
                                                         cllease__Original_Amount__c,
                                                         Original_Tax_Amount__c,
                                                         Total_Original_Amount__c,
                                                         cllease__Waive__c,
                                                         Fee_Paid__c,
                                                         Tax_Paid__c,
                                                         cllease__Paid_Amount__c,
                                                         cllease__Consolidated_Invoice__c,
                                                         cllease__Consolidated_Invoice__r.Update_Charge_Balance__c,
                                                         cllease__Consolidated_Invoice__r.Rent_Billed_Total__c,
                                                         Transaction_SubType_Name__c 
                                                         FROM Cllease__Charge__c
                                                         WHERE cllease__Consolidated_Invoice__c IN : invoiceIds
                                                         AND Id NOT IN : triggerChargeIds ORDER BY cllease__Date__c ASC];
                // Add other charges which are not modified but it belong to same invoice
                for(Cllease__Charge__c charge : allCharges){
                    List<Cllease__Charge__c> chargeList = new List<Cllease__Charge__c>();
                    if(charge.cllease__Consolidated_Invoice__c != null){
                        if(chargeInvoiceGrouping.containsKey(charge.cllease__Consolidated_Invoice__c))
                            chargeList = chargeInvoiceGrouping.get(charge.cllease__Consolidated_Invoice__c);
                        chargeList.add(charge);
                        chargeInvoiceGrouping.put(charge.cllease__Consolidated_Invoice__c, chargeList);
                    }
                }
                
                System.debug(LoggingLevel.ERROR, '^^^^ invoiceToContract : ' + invoiceToContract);
                System.debug(LoggingLevel.ERROR, '^^^^ contractList : ' + contractList);
                // Looping through all invoice and calculated DLL required values.
                for(Id key : chargeInvoiceGrouping.keySet()){
                    Decimal previousBalance = 0;
                    Decimal totalFeeBilled = 0, totalFeeTaxBilled = 0, totalWaivedAmount = 0;
                    Decimal totalFeeTaxPaidAmount = 0, totalPaidChargeAmount = 0;
                    Decimal serviceFeeAmount = 0, serviceFeeTaxAmount = 0;
                    Integer chargeCount = 0;
                    clcommon__Consolidated_Invoice__c invoice = new clcommon__Consolidated_Invoice__c(Id = key);
                    if(contractList.containsKey(invoiceToContract.get(key)))
                        previousBalance = contractList.get(invoiceToContract.get(key)).cllease__Amount_to_Current__c;
                    if(chargeInvoiceGrouping.get(key).size() > 0){
                        for(cllease__Charge__c charge : chargeInvoiceGrouping.get(key)){
                            System.debug(LoggingLevel.ERROR, '^^^^ charge : ' + charge);
                            if(charge.Transaction_SubType_Name__c == 'Service Fees'){
                                serviceFeeAmount += charge.cllease__Original_Amount__c;
                                serviceFeeTaxAmount += charge.Original_Tax_Amount__c;
                            }
                            if(charge.cllease__Waive__c)
                                totalWaivedAmount += charge.Total_Original_Amount__c;
                            
                            totalFeeBilled += charge.cllease__Original_Amount__c;
                            totalFeeTaxBilled += charge.Total_Original_Amount__c - charge.cllease__Original_Amount__c;
                            totalFeeTaxPaidAmount += charge.Tax_Paid__c  == null ? 0 : charge.Tax_Paid__c ;
                            totalPaidChargeAmount += charge.Fee_Paid__c  == null ? 0 : charge.Fee_Paid__c;
                            chargeCount ++;
                            if(!invoiceFlag.containsKey(key)){
                                InvoiceDetail invoiceinfo = new InvoiceDetail(charge.cllease__Consolidated_Invoice__r.Update_Charge_Balance__c,
                                                                             charge.cllease__Consolidated_Invoice__r.Rent_Billed_Total__c);
                                invoiceFlag.put(key, invoiceinfo);
                            }
                        }
                    }
                    invoice.Service_Fee_Billed__c = serviceFeeAmount;
                    invoice.Service_Tax_Billed__c = serviceFeeTaxAmount;
                    invoice.Fee_Amount_Billed__c = totalFeeBilled;
                    invoice.Fee_Tax_Amount_Billed__c = totalFeeTaxBilled;
                    invoice.Fee_Billed_Total_Amount__c = totalFeeBilled + totalFeeTaxBilled; 
                    invoice.Charged_Amount__c = totalFeeBilled + totalFeeTaxBilled;
                    invoice.Total_of_Charge_Waived__c  = totalWaivedAmount;
                    invoice.Number_of_Charges__c = chargeCount;
                    invoice.Total_Fee_Paid__c = totalPaidChargeAmount;
                    invoice.Total_Fee_Tax_Paid__c = totalFeeTaxPaidAmount;
                    invoice.Total_Charge_Paid_Amount__c = totalFeeTaxPaidAmount + totalPaidChargeAmount;
                    if(invoiceToContract.get(key) != null)
                        invoice.LS_Contract__c = invoiceToContract.get(key);
                    if(!invoiceFlag.get(key).flag){
                        invoice.Previous_Balance_Due__c = previousBalance - invoice.Fee_Billed_Total_Amount__c - invoiceFlag.get(key).amount;
                        invoice.Update_Charge_Balance__c = true;
                    }
                    invoices.add(invoice);
                }
                update invoices;
            }
        }
    	catch(Exception e){
            System.debug(LoggingLevel.ERROR, '^^^^ e : ' + e.getStackTraceString());
            System.debug(LoggingLevel.ERROR, '^^^^ e : ' + e.getMessage());
            System.debug(LoggingLevel.ERROR, '^^^^ e : ' + e.getCause());
            System.debug(LoggingLevel.ERROR, '^^^^ e : ' + e.getLineNumber());
    	}
    }
}