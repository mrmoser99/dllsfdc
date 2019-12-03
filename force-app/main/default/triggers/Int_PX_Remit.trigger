/*********************************************************************************************
*
* Int_PX_Remit
*
* Change Log:
*
* 2/15/18 - MRM Created
  3/26/19 - added logic to skip trigger processing for manual payments.
  3/26/19 - changed the code to fix a produciton problem.  this line  r.record_number__c == 0 
  			was changed to say == 0 instead of > 0
  4/12/19 - problems persisted.  changed delete logic to use invoice number = 'Delete Record'
  12/2/19 - MRM - cls forgot to check for old invoices coming from pnc.  need to translate the invoice from old to new
*
**********************************************************************************************/
trigger Int_PX_Remit on Int_PX_Remit__c (before insert, after insert) {
	
	public class CommonException extends Exception {}

	if (AP_ManualPayment.manualPayment == true)  
		return;

	List<Int_Batch_Status__c> bList = [	select id
										from Int_Batch_Status__c
										where name = 'Px Remit' and status__c = 'Ready' and Completed__c = false];
	if (bList.size() > 0)
		throw new CommonException('Cannot load more than 1 remit file at a time!');
						
	if (trigger.isBefore){
		
		List<clcommon__Consolidated_Invoice__c> oldInvList = [select invoiceold__r.name, name 
														from clcommon__Consolidated_Invoice__c where
														invoiceold__c != null];
		Map<String,String> oldToNewInvoice = new Map<String,String>();
		
		for (clcommon__Consolidated_Invoice__c i:oldInvList)
			oldToNewInvoice.put(i.invoiceold__r.name, i.name);
			
		system.debug('old to new map: ' + oldToNewInvoice);
	
		for (Int_PX_Remit__c r:trigger.new){
			if (r.line_data__c == null){
				if (oldToNewInvoice.get(r.invoice_number__c) != null){
					r.old_invoice_number__c = r.invoice_number__c;
					r.invoice_number__c = oldToNewInvoice.get(r.invoice_number__c);
				}
				continue;
			}

			List<String> columnList = new List<String>();
			String line = r.line_data__c;
			columnList = line.split('\\|');
			if (columnList[0].isNumeric()){
				/*
				﻿RECORD NUMBER
				ACCOUNT NUM
				TRANSACTION TYPE
				TRANS UID
				DATE|
				TRANS SOURCE (Future place holder)
				TRANSACTION AMOUNT
				INVOICE NUMBER
				INVOICE AMOUNT PAID
				*/
				r.record_number__c = decimal.valueOf(columnList[0]); 
				r.account_num__c = columnList[1];
				r.transaction_type__c = columnList[2];
				r.trans_uid__c = columnList[3]; 
				Integer year, month, day;
				year = integer.valueOf(columnList[4].mid(0,4));
				month = integer.valueOf(columnList[4].mid(4,2));
				day = integer.valueOf(columnList[4].mid(6,2));
				r.date__c = Date.newInstance(year,month,day);
				 
				r.trans_source__c = columnList[5];
				r.transaction_amount__c = decimal.valueOf(columnList[6])/100;
				r.invoice_number__c = columnList[7];
				system.debug(r.invoice_number__c); 
				system.debug('found:' + oldToNewInvoice.get(r.invoice_number__c));
				if (oldToNewInvoice.get(r.invoice_number__c) != NULL){
					system.debug('found one');
					r.old_invoice_number__c = r.invoice_number__c;
					r.invoice_number__c = oldToNewInvoice.get(r.invoice_number__c);
				}
				
				r.invoice_amount_paid__c = decimal.valueOf(columnList[8])/100;
				r.line_data__c = null;
			}
			else{
				r.committed__C = true;
				r.invoice_number__c = 'Delete Record';
			}
		}
	}
	else{
		 
		List<Int_PX_Remit__c> dList = new List<Int_PX_Remit__c>();
		
		for (Int_PX_Remit__c r:trigger.new){
			Int_PX_Remit__c d = new Int_PX_Remit__c();
			d.id = r.id;
			if (r.invoice_number__c == 'Delete Record')
				dList.add(d);
		}
		if (!dList.isEmpty())
			delete dList;

		
	
	}    
}