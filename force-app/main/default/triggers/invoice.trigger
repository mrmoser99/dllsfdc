/****************************************************************************
* Invoice Trigger
*
* Log:
*
* 	5/4/18 - MRM Created
*
* This trigger places udpates the conga url to be used by Conductor
*
******************************************************************************/

trigger invoice on Invoice__c (after update, after insert) {
    
    if (newCoUtility2.hasAlreadyUpdated()){
    	system.debug('getting out....');
    	return;
    }
    		
    /* get settins from custom settings */
    String DueDetailsLines = CongaURL_Settings__c.getInstance().DueDetailsLines__c;
    String FinanceFee      = CongaURL_Settings__c.getInstance().FinanceFee__c;
    String INSFEE          = CongaURL_Settings__c.getInstance().INSFEE__c;
    String InterimRent     = CongaURL_Settings__c.getInstance().InterimRent__c;
    String Invo             = CongaURL_Settings__c.getInstance().INV__c;
    String LateFee         = CongaURL_Settings__c.getInstance().LateFee__c;
    String OrigFee         = CongaURL_Settings__c.getInstance().OrigFee__c;
    String AD              = CongaURL_Settings__c.getInstance().AD__c;
    String Equipment       = CongaURL_Settings__c.getInstance().Equipment_contact__c;
    String InvTempId       = CongaURL_Settings__c.getInstance().InvTempId__c;
  
 	Set<ID> idSet = new Set<ID>();
 	for (Invoice__c i:trigger.new)
 		idSet.add(i.id);
 		
 	list<Invoice__c> invList =  [select id
 							, name
 							, LS_Contract__r.id
 							, bill_to_Account__c
 							, LS_Contract__r.cllease__Account__c
 							, LS_Contract__r.cllease__Account__r.id
 							, LS_Contract__r.cllease__Account__r.bill_to_contact_id__c
 							,(select id, name from Invoice_Bills__r) 
                              from Invoice__c where id in :idSet];
 	
 	Map<ID,Invoice__c> invoiceMap = new Map<ID,Invoice__c>();
 
 	for (Invoice__c i:invList){
 		if (invoiceMap.get(i.LS_Contract__r.id) == null){
 			invoiceMap.put(i.LS_Contract__r.id,i);
 		}
 	}

 	
 	Map<ID,String> updateInvoiceMap = new Map<ID,String>();
 	
 	List<Invoice__c> uList = new List<Invoice__c>();
 	
 	/* conga parms */
 	for (invoice__c i:trigger.new){
 		 
 		
 		Invoice__c temp = invoiceMap.get(i.LS_Contract__c);
 		system.debug('temp:' + temp);
 		if (temp != null){
 			String BillId;
 			if (temp.Invoice_Bills__r.size() > 0)
        		BillId = temp.Invoice_Bills__r[0].Id;
 			
 			String part1 =  
     				'&id=' + i.id  + '&QueryId=[INV]'+Invo+',[DueDetailsLines]';
     		String part2 = 
             		DueDetailsLines+'?pv0='+BillId+',[AD]'+AD+'?pv0='+i.LS_Contract__c+',[INSFEE]'+INSFEE+'?pv0='+ i.id +',[OrigFee]';
            String part3 =
              		OrigFee+'?pv0='+i.id +',[InterimRent]'+InterimRent+'?pv0='+i.id+',[LateFee]'+LateFee+'?pv0=';
            String part4 = 
              		i.id+',[FinanceFee]'+FinanceFee+',[EC]'+Equipment+'?pv0=' +  i.LS_Contract__c +'&TemplateId='
              		+InvTempId+'&OFN=' + i.name +'&DefaultPDF=1&MFTS0=invoice_emailed__c&MFTSValue0=true&UF0=1';
               	
            system.debug('i is: ' + i);  	
            String part5 = '&AttachmentParentID=' + i.bill_to_Account__c;
            if (string.valueOf(system.label.environment).equalsIgnoreCase('PROD'))
             	part5 += '&EmailToId=' + temp.LS_Contract__r.cllease__Account__r.bill_to_contact_id__c;
            else
            	part5 += '&EmailToId=' + system.label.Invoice_Test_Contact_Id;  //no accidental invoices to customers please
              	 
            String part6 = 
              			'&EmailTemplateId=' + system.label.Invoice_Email_Template_Id 
              			+ '&EmailFromId=' + system.Label.Welcome_Email  
              			+ '&EmailRelatedToId=' +   temp.LS_Contract__r.cllease__Account__c + '&Qmode=SendEmail';
            String part7 = system.label.invoice_conga_parms;  
            String congaURL  = part1+part2+part3+part4+part5+part6+part7;
            updateInvoiceMap.put(i.id,congaURL);
       }
 	}
 	
 	if (!updateInvoiceMap.isEmpty()){
 		newCoUtility.updateInvoice(updateInvoiceMap);
 	}
}