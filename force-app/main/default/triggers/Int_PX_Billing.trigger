/*********************************************************************************************
*
* INT PX BILLING 
*
* Change Log:
*
* 2/15/18 - MRM Created
* 5/21/18 - Added logic to prevent no record files from going to pnc
*
**********************************************************************************************/
trigger Int_PX_Billing on Int_PX_Billing__c (after update) {
 
 	/*
 	6|0000000419|0000000419|04/16/2018|05/11/2018|INV-0000000057||||THE EVANGELICAL 
 	*/ 
 	
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
 	
 	List<Invoice__c> uList = [select id
 							,name 
 							from Invoice__c 
 							where name in:invoiceMap.keySet()
 							];
 	for (invoice__c i:uList){
 		i.sent_to_pnc__c = true; 
 		i.sent_to_pnc_amount__c = invoiceMap.get(i.name);	
 		i.sent_to_pnc_date_time__c = system.now();
 	}
 	
 	update uList;				
}