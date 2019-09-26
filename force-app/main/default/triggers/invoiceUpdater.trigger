/**
 * Owner: CLS-Q2
 * Date : 09/12/2019
 * Description: Trigger to update custom fields required by DLL on product invoice object.
 * Rent Amount Billed, Rent Tax Amount Billed, Rent Amount Total Billed, Total Rent Paid, Total Rent Tax Paid, Total Bill Paid Amount
 **/
trigger invoiceUpdater on cllease__Lease_account_Due_Details__c (before update) {
    InvoiceDetailHandler handler = new InvoiceDetailHandler(trigger.new, trigger.old);
    handler.updateInvoiceHandler();
}