/*********************************************************************************************
*
* INT PX BILLING 
*
* Change Log:
*
* 2/15/18 - MRM Created
* 5/21/18 - Added logic to prevent no record files from going to pnc
* 2/20/2020 - MRM Added logic to consolidate invoice to parent billing account
*
**********************************************************************************************/
trigger Int_PX_Billing on Int_PX_Billing__c (after update, before insert) {
 
 	/*
 	6|0000000419|0000000419|04/16/2018|05/11/2018|INV-0000000057||||THE EVANGELICAL 
 	*/ 
 	if (trigger.isUpdate){
 		Map<String,Decimal> invoiceMap = new Map<String,Decimal>();
 	
 		for (Int_PX_Billing__c b:trigger.new){
 		
 			if (b.committed__c == true){
 				List<String> line = new List<String>();
 				line = b.line_data__c.split('\\|');
 				if (line != null)
 					if (line[0] == '6')
	 					if (line[5] != null)
	 						invoiceMap.put(line[5],decimal.valueOf(line[20]));
 			
 			}
 			system.debug(invoiceMap);
 		}
 	
 		List<clcommon__Consolidated_Invoice__c> uList = [select id
 							,name 
 							from clcommon__Consolidated_Invoice__c 
 							where name in:invoiceMap.keySet()
 							];
 		for (clcommon__Consolidated_Invoice__c i:uList){
 			i.sent_to_pnc__c = true; 
 			i.sent_to_pnc_amount__c = invoiceMap.get(i.name);	
 			i.sent_to_pnc_date_time__c = system.now();
 		}
 	
		 update uList;		
	 }

	 if (trigger.isInsert){

		Map<String,String> accountMap = new Map<String,String>();
		
		for (Int_PX_Billing__c b:trigger.new){
			List<String> line = new List<String>();
 			line = b.line_data__c.split('\\|');
 			if (line != null)
 				if (line[0] == '6')
	 				accountMap.put(line[1],null);
		}

		List<Account> aList = new List<Account>();
		alist = [select account_number__c, Billing_Account_Number__c from Account where account_number__c in :accountMap.keySet()];
		for (Account a:aList){
			accountMap.put(a.account_number__c,a.billing_account_number__c);
		}

		system.debug('account map: ' + accountMap);
		for (Int_PX_Billing__c b:trigger.new){
			List<String> line = new List<String>();
 			line = b.line_data__c.split('\\|');
 			if (line != null)
 				if (line[0] == '6'){
					system.debug('before:' + b.line_data__c);
					system.debug('map ' + accountMap.get(line[1]));
					if (accountMap.get(line[1]) != null)
						b.line_data__c = b.line_data__c.replaceAll(line[1],accountMap.get(line[1]));
					 
				}
			
		}



	 }
}