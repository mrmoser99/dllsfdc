/*********************************************************************************************
*
* Int_OLMN_Payment_Confirmation
*
* Change Log:
*
* 2/15/18 - MRM Created
* 5/16/19 - MRM Added logic to mark a payment request as confirmed;;; guard rail effort
*
**********************************************************************************************/
trigger Int_OLMN_Payment_Confirmation on Int_OLMN_Payment_Confirmation__c (before insert) {
	
	Set<String> invoiceSet = new Set<String>();
	for (Int_OLMN_Payment_Confirmation__c r:trigger.new){
		invoiceSet.add(r.invoice_number__c);
	}	 

	List<Int_OLMN_AP__c> pList = new list<Int_OLMN_AP__c>();
	pList = [select id from Int_OLMN_AP__c where invoice_number__c in :invoiceSet];

	for (Int_OLMN_Payment_Confirmation__c r:trigger.new){
				/*
				0Contract number
				1Vendor
				2Payment reference
				3Payment date
				4Void date
				5Payment amount
				6Payment method
				7Status
				8Invoice number
				9Invoice date
				10Invoice amount
				11Last update date
				12Run date

				*/
				Integer year, month, day;
				
				if (r.text_payment_date__c != null){
				
					year = integer.valueOf(r.text_payment_date__c.mid(0,4));
					month = integer.valueOf(r.text_payment_date__c.mid(4,2));
					day = integer.valueOf(r.text_payment_date__c.mid(6,2));
					r.payment_date__c = Date.newInstance(year,month,day);
				}
				
				if (r.text_void_date__c != null){
					year = integer.valueOf(r.text_void_date__c.mid(0,4));
					month = integer.valueOf(r.text_void_date__c.mid(4,2));
					day = integer.valueOf(r.text_void_date__c.mid(6,2));
					r.void_date__c = Date.newInstance(year,month,day);
				}
				
				if (r.text_invoice_date__c != null){
					year = integer.valueOf(r.text_invoice_date__c.mid(0,4));
					month = integer.valueOf(r.text_invoice_date__c.mid(4,2));
					day = integer.valueOf(r.text_invoice_date__c.mid(6,2));
					r.invoice_date__c = Date.newInstance(year,month,day);
				}
				
			
	}

	for (Int_OLMN_AP__c a:pList){
		a.ap_confirmed__c = true;
	}

	if (!pList.isEmpty())
		update pList;
    
}