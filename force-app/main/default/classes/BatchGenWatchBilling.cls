/*********************************************************************************************
*	This batch program shows payment streams for the next 2 months.  
*   For each payment stream/lease it shows invoiced, emailed, paid etc...
*
* ChangeLog:
*
*	6/1/18 - MRM Created Class
* 	9/19/19 - MRM Changed invoice__c to clcommon__Consolidated_Invoice__c
*
*
************************************************************************************************/
global class BatchGenWatchBilling implements Database.Batchable<SObject>,Database.Stateful{
    /*********************************************************************************************
  	*	QUERY
  	*
  	*
  	************************************************************************************************/
    static final string QUERY = 'Select c.cllease__Date__c,cllease__contract__c, cllease__rental_amount__c ' +
    					' From cllease__Payment_Stream__c c ' +
    					'where cllease__date__c <= NEXT_N_MONTHS:1 ' +
    					'and cllease__Contract__r.cllease__Lease_Status__c !=' + '\'CANCELED\'' + 
						'order by cllease__date__c,  cllease__contract__c';
	/*********************************************************************************************
  	*	CONSTRUCTOR
  	*
  	*
  	************************************************************************************************/
	global BatchGenWatchBilling(){
    	list<Bill_Monitor__c> bList = new List<Bill_Monitor__c>();
    	blist = [select id from Bill_Monitor__c];
    	delete blist;
    }
    /*********************************************************************************************
  	*	START
  	*
  	************************************************************************************************/				
    global Database.QueryLocator start(Database.BatchableContext c) {    
        return Database.getQueryLocator(QUERY);        
    }
  	/*********************************************************************************************
  	*	EXECUTE
  	*
  	*
  	************************************************************************************************/
    global void execute(Database.BatchableContext c, List<cllease__Payment_Stream__c> scope) {
        
        Map<String,Bill_Monitor__c> bMap = new Map<String,Bill_Monitor__c>();
        
        Set<ID> contractIDSet = new Set<ID>();
        
        for (cllease__Payment_Stream__c ps : scope)  {
        	contractIdSet.add(ps.cllease__contract__c);
        }
        
        List<Bill_Monitor__c> bList = new List<Bill_Monitor__c>();
        bList = [select due_date__c, amount__c, ls_contract__c 
        		 from Bill_Monitor__c 
        		 where ls_contract__c in :contractIDSet];
        for(Bill_Monitor__c m1:bList)
        	bMap.put(string.valueOf(m1.ls_contract__c) + '-' + string.valueOf(m1.due_date__c), m1);
        	
       
        List<Bill_Monitor__c> uList = new List<Bill_Monitor__c>();
       	
       	List<clcommon__Consolidated_Invoice__c> invoiceList = new List<clcommon__Consolidated_Invoice__c>();
       	invoiceList = [ select id
       					, name
       					, Invoice_Due_Date__c
       					, billed_amount__c
       					, charged_amount__c
       					, ls_contract__c
       					, Total_Invoiced_Amount__c
       					, invoice_emailed__c
       	 				from clcommon__Consolidated_Invoice__c where ls_contract__c in:contractIdSet
       	
						];
		Map<String,List<clcommon__Consolidated_Invoice__c>> iMap = new Map<String,List<clcommon__Consolidated_Invoice__c>>();
		
		
       	for (clcommon__Consolidated_Invoice__c i:invoiceList){
       		List<clcommon__Consolidated_Invoice__c> invList = new List<clcommon__Consolidated_Invoice__c>(); 
       		
       		/* if multiple invoices, add the values */
       		if (iMap.containsKey(string.valueOf(i.ls_contract__c) + '-' + string.valueOf(i.invoice_Due_Date__c))){
       			invList = iMap.get(string.valueOf(i.ls_contract__c) + '-' + string.valueOf(i.invoice_Due_Date__c));
       			invList.add(i);
       		}
       		else{
       			invList.add(i);
       		}
   
   			iMap.put(string.valueOf(i.ls_contract__c) + '-' + string.valueOf(i.invoice_Due_Date__c),invList);
       	}
       	
       	/*********************************************************************************************
  		*	 
  		*	Setup Charge/Payment Map
  		*
  		************************************************************************************************/
       	
       	Map<ID,Decimal> invoiceChargeTaxAmountMap = new Map<ID,Decimal>();
       	Map<ID,Decimal> invoiceChargeTaxPaidAmountMap = new Map<ID,Decimal>();
       	
       	List<cllease__Charge__c> cList = [Select 
       			  c.cllease__Lease_Account__r.Name
       			, c.cllease__Lease_Account__c
       			, c.cllease__Tax_Due__c
       			, c.cllease__Consolidated_Invoice__c
       			, c.Name 
       			, c.cllease__paid_amount__c
       			From cllease__Charge__c c
       			Where cllease__lease_account__c in :contractIdSet
       			];
       	for (cllease__Charge__c ch: cList){
       		Decimal totalTax = 0;
       		Decimal totalPayment = 0;
       		
       		if (invoiceChargeTaxAmountMap.containsKey(ch.cllease__Consolidated_Invoice__c)){
       			totalTax = invoiceChargeTaxAmountMap.get(ch.cllease__Consolidated_Invoice__c);
       			totalTax = totalTax + ch.cllease__Tax_Due__c; 
       			invoiceChargeTaxAmountMap.put(ch.cllease__Consolidated_Invoice__c,totalTax);
       		}
       		else{
       			invoiceChargeTaxAmountMap.put(ch.cllease__Consolidated_Invoice__c,ch.cllease__Tax_Due__c);
       		}
       		
       		if (invoiceChargeTaxAmountMap.containsKey(ch.cllease__Consolidated_Invoice__c)){
       			totalPayment = invoiceChargeTaxPaidAmountMap.get(ch.cllease__Consolidated_Invoice__c);
       			if (totalPayment == null)
       				totalPayment = 0;
       			if (ch.cllease__paid_amount__c == null)
       				ch.cllease__paid_amount__c = 0;
       			totalPayment = totalPayment + ch.cllease__paid_amount__c; 
       			invoiceChargeTaxPaidAmountMap.put(ch.cllease__Consolidated_Invoice__c,totalPayment);
       		}
       		else{
       			invoiceChargeTaxPaidAmountMap.put(ch.cllease__Consolidated_Invoice__c,ch.cllease__paid_amount__c);
       		}
       	}
       	system.debug('charge paid map is: ' + invoiceChargeTaxPaidAmountMap);
       	
       	/* done with charge setup */
       	 
       	 
     
       	/*********************************************************************************************
  		*	 
  		*	Setup Bill/Payment Map
  		*
  		************************************************************************************************/
       	    	
       	Map<ID,Decimal> invoiceBillTaxAmountMap = new Map<ID,Decimal>();
       	Map<ID,Decimal> invoiceBillTaxPaidAmountMap = new Map<ID,Decimal>();
       	  
       	List<cllease__Lease_account_Due_Details__c> billList = [
       		Select c.cllease__Tax_Due_Amount__c
       		, c.cllease__Account__c
       		, c.Name
       		, c.cllease__Consolidated_Invoice__c 
       		, c.cllease__total_paid_amount__c
       		From cllease__Lease_account_Due_Details__c c
       		Where cllease__lease_Account__c in :contractIdSet
       		and cllease__Consolidated_Invoice__c != null
       		];
       	
       	
       	for (cllease__Lease_account_Due_Details__c b: billList){
       		Decimal totalTax = 0;
       		Decimal totalPayment = 0;
       		
       		if (invoiceBillTaxAmountMap.containsKey(b.cllease__Consolidated_Invoice__c)){
       			totalTax = invoiceBillTaxAmountMap.get(b.cllease__Consolidated_Invoice__c);
       			totalTax = totalTax + b.cllease__Tax_Due_Amount__c; 
       			invoiceBillTaxAmountMap.put(b.cllease__Consolidated_Invoice__c,totalTax);
       		}
       		else{
       			invoiceBillTaxAmountMap.put(b.cllease__Consolidated_Invoice__c,b.cllease__Tax_Due_Amount__c);
       		}
       		
       		if (invoiceBillTaxPaidAmountMap.containsKey(b.cllease__Consolidated_Invoice__c)){
       			totalPayment = invoiceBillTaxPaidAmountMap.get(b.cllease__Consolidated_Invoice__c);
       			totalPayment = totalPayment + b.cllease__total_paid_amount__c; 
       			invoiceBillTaxPaidAmountMap.put(b.cllease__Consolidated_Invoice__c,totalPayment);
       		}
       		else{
       			invoiceBillTaxPaidAmountMap.put(b.cllease__Consolidated_Invoice__c,b.cllease__total_paid_amount__c);
       		}
       	}
       	system.debug('bill map is: ' + invoiceBillTaxAmountMap);
       	
       	/* done with bill setup */
       	
       	
       	system.debug('imap is: ' + imap);
       	
       	Bill_Monitor__c m = new Bill_Monitor__c();
       	
       	system.debug('imap is: ' + imap);
       	Integer nbrEmailed = 0;
       	
       	/*********************************************************************************************
  		*	 
  		*	Core Processing 
  		*
  		************************************************************************************************/
        for (cllease__Payment_Stream__c ps : scope)  {
       
        	m = new Bill_Monitor__c();
			m.amount__c = 0;
			
        	if (bMap.containsKey(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c))) {
        		m = bMap.get(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c));
        		if (iMap.get(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c)) != null){
        			if (iMap.get(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c)).size() > 1){
        				m.multiple_invoices__c = true;
        				m.invoiced__c = true;
        				m.invoice__c = null; 
        			}
        			else{
        				m.multiple_invoices__c = false;
        				m.consolidated_invoice__c = iMap.get(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c))[0].id;
        				m.invoiced__c = true;
        			}
        			m.amount__c = m.amount__c + ps.cllease__rental_amount__c;
        			
        			/* invoice processing */
        			m.invoice_amount__c = 0;
        			nbrEmailed = 0;
        			 
        			if (iMap.get(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c)) != null){
        				for(clcommon__Consolidated_Invoice__c i2:iMap.get(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c))){
        					m.Invoice_Amount__c = m.Invoice_Amount__c + i2.Total_Invoiced_Amount__c;
        					if (i2.invoice_emailed__c == true)
        						nbrEmailed++;
        				}
        				if (iMap.get(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c)).size() == nbrEmailed)
        					m.invoice_emailed__c = true;
        				else
        					m.invoice_emailed__c = false;
        			}
        			
        		}	
        		bMap.put(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c),m);
        	}
        	else{
        		m.due_date__c = ps.cllease__date__c;
        		m.ls_contract__c = ps.cllease__contract__c;
        	 
        		if (iMap.get(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c)) != null){
        			if (iMap.get(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c)).size() > 1){
        				m.multiple_invoices__c = true;
        				m.consolidated_invoice__c = null;
        				m.invoiced__c = true;
        			}
        			else{
        				m.multiple_invoices__c = false;
        				m.invoiced__c = false;
        				m.consolidated_invoice__c = iMap.get(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c))[0].id;
        			}
        		}
        		
        		/* invoice procesing */	
     	   		m.amount__c = ps.cllease__rental_amount__c;
     	   		nbrEmailed = 0;
     
        		if (iMap.get(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c)) != null){
        			m.invoice_amount__c = 0;
        			for(clcommon__Consolidated_Invoice__c i2:iMap.get(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c))){
        				system.debug('adding amounts');
        				m.Invoice_Amount__c = m.Invoice_Amount__c + i2.Total_Invoiced_Amount__c;
        				m.invoice_emailed__c = i2.invoice_emailed__c;
        				if (i2.invoice_emailed__c == true)
        					nbrEmailed++;
        			}
        			if (iMap.get(string.valueOf(ps.cllease__contract__c) + '-' + string.valueOf(ps.cllease__date__c)).size() == nbrEmailed)
        					m.invoice_emailed__c = true;
        				else
        					m.invoice_emailed__c = false;
        		}
        		
        		bMap.put(string.valueOf(m.ls_contract__c) + '-' + string.valueOf(m.due_date__c), m);
        	}//********************** end else
        	
        	system.debug('m is: ' + m.invoice__c);
        }  
        
        system.debug(bmap);
        
        for (String key : bMap.keySet()) {
        	m = bmap.get(key);
        	
        	/*charge processing */
        	
        	m.invoice_tax__c = 0;
        	m.paid_amount__c = 0;
        	if (iMap.get(string.valueOf(m.LS_Contract__c) + '-' + string.valueOf(m.due_date__c)) != null){
        		for (clcommon__Consolidated_Invoice__c i2:iMap.get(string.valueOf(m.LS_Contract__c) + '-' + string.valueOf(m.due_date__c)) ){
        			if (invoiceChargeTaxAmountMap.containsKey(m.invoice__c)){
        				m.invoice_tax__c = m.invoice_tax__c + invoiceChargeTaxAmountMap.get(m.invoice__c);
        				m.Paid_Amount__c = m.paid_amount__c + invoiceChargeTaxPaidAmountMap.get(m.invoice__c);
        			}
        			if (invoiceBillTaxAmountMap.containsKey(m.invoice__c)){
        				m.invoice_tax__c = m.invoice_tax__c + invoiceBillTaxAmountMap.get(m.invoice__c);
        				m.Paid_Amount__c = m.paid_amount__c + invoiceBillTaxPaidAmountMap.get(m.invoice__c);
        			}
        		}
        	}
        	uList.add(m);
        }
  		   
        
        if (!uList.isEmpty())
        	upsert uList;
    }
    
    /*********************************************************************************************
  	*	FINISH
  	*
  	*
  	************************************************************************************************/
    global void finish(Database.BatchableContext c) {
    }
  
}