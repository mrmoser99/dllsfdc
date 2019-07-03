/**
 * Author: Cloud Lending Solutions
 * Description: Following class helps in updating Paid Invoice Amount in Invoice object  
 **/
public class InvoiceSummaryUtil {
    // Following method update the invoices from Bills and charges after paid.
    public static void InvoiceSummary(Set<Id> invIds) {
        System.debug(' Starting the InvoiceSummary method ');
        Savepoint sp = database.setsavepoint();
        try {
            // getting the List of charges and bill from invoice object 
            List<Invoice__c> invoices = [SELECT Id, Name,
                                            Paid_Invoice_Amount__c, 
                                            Billed_Amount__c, 
                                            Charged_Amount__c, 
                                         	Total_of_Charge_Waived__c,
                                            (SELECT Id, Name,
                                                cllease__Rental_Due_Amount__c, 
                                                cllease__Tax_Due_Amount__c, 
                                                Invoiced_In__c, 
                                                cllease__Rental_Paid_Amount__c, 
                                                cllease__Total_Paid_Amount__c
                                            FROM Invoice_Bills__r), 
                                            (SELECT Id, Name,  
                                                cllease__Original_Amount__c, 
                                                cllease__Paid_Amount__c, 
                                                Invoiced_In__c,
                                             	cllease__Waive__c,
                                             	Total_Original_Amount__c 
                                            FROM Invoice_Charges__r)
                                        FROM Invoice__c
                                        WHERE Id in: invIds];

            Decimal totalchargeAmount, totalBillPaidAmount, totalChargeWaivedAmount; 
            // Looping through Invoices for updates
            for(Invoice__c invoice: invoices) {
                totalchargeAmount =0;
                totalBillPaidAmount =0;
                totalChargeWaivedAmount =0;
                // a. Looping through charges
                for(cllease__Charge__c charge: invoice.Invoice_Charges__r) {
                    totalchargeAmount += (charge.cllease__Paid_Amount__c != null ? charge.cllease__Paid_Amount__c : 0);
                    if(charge.cllease__Waive__c)
                        totalChargeWaivedAmount += charge.Total_Original_Amount__c != null ? charge.Total_Original_Amount__c : 0;
                }

                // b. Looping through Bills
                for(cllease__Lease_account_Due_Details__c bill : invoice.Invoice_Bills__r) {
                    totalBillPaidAmount += (bill.cllease__Total_Paid_Amount__c !=null ? bill.cllease__Total_Paid_Amount__c : 0);
                }

                // Update Invoice Paid Amounts
                invoice.Paid_Invoice_Amount__c = totalBillPaidAmount + totalchargeAmount ;
                // Updating total charge waived amount
                invoice.Total_of_Charge_Waived__c = totalChargeWaivedAmount;
                // Avoiding resending Invoices to PNC again for remaining amounts. TIcket: 13061
                //invoice.File_Generated__c = 'No'; 
            }

            if(invoices.size() > 0) {
                update invoices;
            }
        } catch(Exception e) {
            Database.rollback(sp);
            System.debug(LoggingLevel.ERROR, ' Exception: '+e.getMessage());
            System.debug(LoggingLevel.ERROR, ' Exception Stack Trace: '+e.getStackTraceString());
            insert new cllease__Batch_Process_Log__c(Name='InvoiceSummary: ',
                                                    cllease__Date__c=system.today(),
                                                    cllease__Message__c=' Error: '+e.getMessage()
                                                    +' StackTrace: '+ e.getStackTraceString());  
        }
        System.debug(' Ending the InvoiceSummary method ');       
    }
}