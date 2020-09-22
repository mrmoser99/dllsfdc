/*********************************************************************************************
*
* Int_OLMN_Payment_Confirmation
*
* Change Log:
*
* 2/15/18 - MRM Created
* 5/16/19 - MRM Added logic to mark a payment request as confirmed;;; guard rail effort
* 9/22/2020 MRM Added logic to update dealer funding details
*
**********************************************************************************************/
trigger Int_OLMN_Payment_Confirmation on Int_OLMN_Payment_Confirmation__c (before insert) {
	
	Set<String> invoiceSet = new Set<String>();
	Set<String> contractSet = new Set<String>();

	for (Int_OLMN_Payment_Confirmation__c r:trigger.new){
		invoiceSet.add(r.invoice_number__c);
		contractSet.add(r.contract_number__c);
	}	
	system.debug('Contract Set:' + contractSet);

	
	List<Int_OLMN_AP__c> pList = new list<Int_OLMN_AP__c>();
	pList = [select id from Int_OLMN_AP__c where invoice_number__c in :invoiceSet];

	List<cllease__Dealer_Funding_Detail__c> fundingList = new List<cllease__Dealer_Funding_Detail__c>();
	List<cllease__Dealer_Funding_Detail__c> fundingListUpdate = new List<cllease__Dealer_Funding_Detail__c>();
	fundingList = 	[Select id 
					,cllease__Dealer_Charges__c
					,cllease__Contract__r.name
					from cllease__Dealer_Funding_Detail__c 
					where cllease__Contract__r.name in :contractSet
					];
	Map<String,cllease__Dealer_Funding_Detail__c> fundingMap = new Map<String,cllease__Dealer_Funding_Detail__c>();

	for (cllease__Dealer_Funding_Detail__c f:fundingList){
		fundingMap.put(f.cllease__Contract__r.name + '-' + string.valueOf(f.cllease__Dealer_Charges__c),f);
	}

	system.debug('funding map:' + fundingMap);

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

				if (fundingMap != null && r.funding_type__c == 'ASSET')	{
					if (fundingMap.keySet().contains(r.contract_number__c + '-' + string.valueOf(r.invoice_amount__c)) ){
						cllease__Dealer_Funding_Detail__c temp = fundingMap.get(r.contract_number__c + '-' + string.valueOf(r.invoice_amount__c));
						temp.Payment_Confirmed_Date__c = date.today();
						temp.payment_reference__c = r.Payment_Reference__c;
						temp.Dealer_Invoice_Number__c = r.Invoice_Number__c;
						fundingListUpdate.add(temp);
					}
				}	
	}

	for (Int_OLMN_AP__c a:pList){
		a.ap_confirmed__c = true;
	}

	if (!pList.isEmpty())
		update pList;

	if (!fundingListUpdate.isEmpty())
		update fundingListUpdate;
    
}