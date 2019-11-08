/*******************************************************************************************************************
*   SUPERTRUMP UTILITY
*
*
*	Change Log:
*	7/24/18 - MRM Created
*
*   execute anonomys script - 
*
* 	  
/*	
Map<ID,String> leaseMap = new Map<ID,String>();
leasemap.put('a6J1I000000ozT7','hello');
supertrumputil.sendRequest(leaseMap);

List<cllease__lease_account__c> cList = new List<cllease__lease_account__c>();

cList = [select id from cllease__lease_account__c
		 where 	cllease__Lease_Status__c in ('ACTIVE - GOOD STANDING','ACTIVE - BAD STANDING') and ST_Derived_Product_Name__c = null
		limit 50
];

for (cllease__lease_account__c c:cList){
	system.debug('Calling...');
	Map<ID,String> leaseMap = new Map<ID,String>();
	leasemap.put(c.id,'hello');
	supertrumputil.sendRequest(leaseMap);

}
* 
*
*
********************************************************************************************************************/
public with sharing class SupertrumpUtil {
	
	public DOM.XMLNode myExceptionsNode;
	
    /********************************************************************************************
    * write key pair - assists in writing xml
    *
    ********************************************************************************************/
    public static void writeKeyPair(String tagName, String tagContents, XmlStreamWriter w){
		w.writeStartElement(null, tagName, null); 
		w.writeCharacters(tagContents); 
	    w.writeEndElement();  
    }
    /********************************************************************************************
    * write key pair - assists in writing xml
    *
    ********************************************************************************************/
    public static void writeHeaderAndFeatures(XmlStreamWriter w, cllease__Lease_Account__c l){
		system.debug('************** bldg hdr and features ************************'); 
		w.writeStartElement(null, 'SuperTRUMP', null); //Super Trump
		w.writeAttribute('', '','viewoutput', 'true');
	  	w.writeStartElement(null, 'Transaction', null); //Transaction
	   	w.writeStartElement(null, 'Mode', null); //this will start with <accounts> in XML
	 	w.writeCharacters('Lessor'); 
		w.writeEndElement();  //end Mode
		
		w.writeStartElement(null, 'Features', null); 
					 
		supertrumputil.writekeyPair('AllowAccounting','false',w);
		supertrumputil.writekeyPair('AllowAMT','false',w);
		supertrumputil.writekeyPair('AllowAssetAssociation','true',w);
		supertrumputil.writekeyPair('AllowEBOSpecifiedTV','true',w);
		supertrumputil.writekeyPair('AllowFederalTaxes','true',w);
		supertrumputil.writekeyPair('AllowITC','false',w);
		supertrumputil.writekeyPair('AllowPassiveLoss','false',w);	
        supertrumputil.writekeyPair('AllowPeriodicIncomeExpense','true',w);
     	supertrumputil.writekeyPair('AllowSecurityDeposits','true',w);
	 	supertrumputil.writekeyPair('AllowSkipMonths','true',w);
 		supertrumputil.writekeyPair('AllowStateTaxes','false',w);
 		supertrumputil.writekeyPair('AllowSubsidies','true',w);
 		
 		w.writeEndElement();  //features
 		 
 		supertrumputil.writekeyPair('LeaseID',l.name,w);  //
		supertrumputil.writekeyPair('Periodicity','Monthly',w);
		supertrumputil.writekeyPair('TransactionStartDate',string.valueOf(l.cllease__Commencement_Date__c),w);
		supertrumputil.writekeyPair('CommencementDate',string.valueOf(l.cllease__Commencement_Date__c),w);
		supertrumputil.writekeyPair('TermInMonths',string.valueOf(l.cllease__Term__c),w);
		supertrumputil.writekeyPair('PaymentTiming','Arrears',w);
		supertrumputil.writekeyPair('EconomicCOF','0',w);
		supertrumputil.writekeyPair('TaxClass','Determined by IRS tests',w);
		supertrumputil.writekeyPair('FASBclass','Determined by FASB tests',w);
 		
		
    }
    /********************************************************************************************
    * write assets
    *
    ********************************************************************************************/
    public static void writeAssets(XmlStreamWriter w,cllease__Lease_Account__c l){
    	system.debug('************** bldg assests ************************');
    	w.writeStartElement(null, 'Assets', null); //Assets
		
		
		List<cllease__Contract_Equipment__c> eList = [select cllease__Residual_Amount__c
												, cllease__Equipment_Description__c
												, Equipment_Description1__c 
												, Residual_Percentage__c
												, Name
												, Dealer_Charges__c
												, Install_Date__c 
												From cllease__Contract_Equipment__c 
												where cllease__Contract__c = :l.id
												]; 
		
												
		Integer i=0; 
		for (cllease__Contract_Equipment__c e:eList){	
			w.writeStartElement(null, 'Asset', null); //Asset
			w.writeAttribute('', '','index', string.valueOf(i));	
			supertrumputil.writekeyPair('ExternalID',e.name,w);		
			supertrumputil.writekeyPair('Description',e.Equipment_Description1__c ,w);		
			supertrumputil.writekeyPair('DeliveryDate',string.valueOf(e.Install_Date__c),w);		
			supertrumputil.writekeyPair('ResidualKeptAsAPercent','false',w);		
			supertrumputil.writekeyPair('Residual',string.valueOf(e.cllease__Residual_Amount__c),w);		
			supertrumputil.writekeyPair('Tradein','0',w);		
			supertrumputil.writekeyPair('Lien','0',w);	
			supertrumputil.writekeyPair('BookLife','5',w);	
			supertrumputil.writekeyPair('TaxLife','5',w);	
			
			if (l.Purchase_Option__c == 'Fair Market Value'){
				supertrumputil.writekeyPair('SpecifyFMV','true',w);			
				supertrumputil.writekeyPair('FMV',string.valueOf(e.cllease__Residual_Amount__c),w);		
			}
			else{
				supertrumputil.writekeyPair('SpecifyFMV','false',w);			
			}
			
			supertrumputil.writekeyPair('TrueLeaseMinimumResidual','0.1',w);	
			
			w.writeStartElement(null, 'Fundings', null); //Fundings
			w.writeAttribute('', '','count', '1');
			w.writeStartElement(null, 'Funding', null); //Funding
			w.writeAttribute('', '','index', '0');
			supertrumputil.writekeyPair('KeepAsPercent','false',w);
					
			if (l.booking_date__c == null)
				supertrumputil.writekeyPair('FundingDate',string.valueOf(l.cllease__Contract_Date__c) ,w);
			else
				supertrumputil.writekeyPair('FundingDate',string.valueOf(l.booking_Date__c) ,w);
			 				
			supertrumputil.writekeyPair('Amount',string.valueOf(e.Dealer_Charges__c),w);
			w.writeEndElement();  //Funding
			w.writeEndElement();  //Fundings
			w.writeEndElement();  //Asset
			i++;
		}

		w.writeEndElement(); //Assets		
		system.debug('************** done bldg assests ************************');
    	
    }
    /********************************************************************************************
    * write rents
    *
    ********************************************************************************************/
    public static void writeRents(XmlStreamWriter w,cllease__Lease_Account__c l){
    	system.debug('************** bldg rents ************************');
    	w.writeStartElement(null, 'Rents', null); //Rents
    	
    	List<cllease__Contract_Equipment__c> eList = [select cllease__Residual_Amount__c
												, cllease__Equipment_Description__c
												, Equipment_Description1__c 
												, Residual_Percentage__c
												, Name
												, Dealer_Charges__c
												, Install_Date__c 
												, rent_amount__c
												
												From cllease__Contract_Equipment__c 
												where cllease__Contract__c = :l.id
												]; 
    	Integer i = 0;
		for (cllease__Contract_Equipment__c e:eList){
			
			w.writeStartElement(null, 'Rent', null); //Rent
				w.writeAttribute('', '','index', string.valueOf(i));
				supertrumputil.writekeyPair('UseFundingsAndRate','true',w);
				supertrumputil.writekeyPair('AssociationMethod','Asset',w);		
				supertrumputil.writekeyPair('AssociationIndex',string.valueOf(i),w);		
				supertrumputil.writekeyPair('DisableCompounding','false',w);		
				supertrumputil.writekeyPair('AutoFunding','Amount to finance',w);		
				supertrumputil.writekeyPair('AdvancePayment','0',w);		
				supertrumputil.writekeyPair('ResidualAsFunding','Yes',w);		
				//supertrumputil.writekeyPair('FirstStartAccrual','2018-05-18',w);		
	
 
	 			w.writeStartElement(null, 'CashflowSteps', null); //CashFlowSteps
	 				w.writeStartElement(null, 'Delete', null); //CashFlowStep
	 				w.writeAttribute('', '','index', '*');
 					w.writeEndElement();//Delete
 				
 					w.writeStartElement(null, 'CashflowStep', null); //CashFlowStep
					w.writeAttribute('', '','index', string.valueOf(0));
					supertrumputil.writekeyPair('Type','Payment',w);		
					supertrumputil.writekeyPair('Periodicity','Stub',w);		
					supertrumputil.writekeyPair('NumberOfPayments',string.valueOf(1),w);		
					supertrumputil.writekeyPair('Amount',string.valueOf(e.rent_amount__c),w);		
					supertrumputil.writekeyPair('AmountLocked','true',w);		
					supertrumputil.writekeyPair('RateLocked','false',w);	
					supertrumputil.writekeyPair('EndAccrual',string.valueOf(l.cllease__First_Payment_Date__c),w);		
					w.writeEndElement();  //CashFlowStep
					
					w.writeStartElement(null, 'CashflowStep', null); //CashFlowStep
					w.writeAttribute('', '','index', string.valueOf(1));
					supertrumputil.writekeyPair('Type','Payment',w);		
					supertrumputil.writekeyPair('Periodicity','Monthly',w);		
					supertrumputil.writekeyPair('NumberOfPayments',string.valueOf(l.cllease__Term__c-1),w);		
					supertrumputil.writekeyPair('Amount',string.valueOf(e.rent_amount__c),w);		
					supertrumputil.writekeyPair('AmountLocked','true',w);		
					supertrumputil.writekeyPair('RateLocked','false',w);		
					w.writeEndElement();  //CashFlowStep
			
				w.writeEndElement();  //CashFlowSteps
				supertrumputil.writekeyPair('BalanceRate','',w);		
			
			w.writeEndElement();  //Rent
			 
			i++;
		}
		
		w.writeEndElement();  //Rents
		
		
		//supertrumputil.writekeyPair('BalanceRate','',w);		
		//w.writeEndElement(); 
		//w.writeEndElement(); 
		
		w.writeStartElement(null, 'Fees', null); //Fees
		
		List<cllease__Contract_Fees__c> fList = new List<cllease__Contract_Fees__c>();
		flist = [Select c.cllease__Frequency__c
				, cllease__number_of_periods__c
				, c.cllease__Fee_Type__c
				, c.cllease__Amount__c
				, c.Name
				, c.Contract_Fee_Name__c 
				, c.cllease__Fee_Definition__r.clcommon__Class__c
				From cllease__Contract_Fees__c c  where cllease__contract__c = :l.id
				and cllease__number_of_periods__c = 1
				];
		i=0;
		
		for (cllease__Contract_Fees__c f:fList){
			w.writeStartElement(null, 'Fee', null); //Fee
			w.writeAttribute('', '','index', string.valueOf(i));
	
			supertrumputil.writekeyPair('AssociationMethod','Asset',w);		
			supertrumputil.writekeyPair('AssociationIndex','0',w);		
			supertrumputil.writekeyPair('ExternalID',f.name,w);		
			supertrumputil.writekeyPair('Description',f.contract_fee_name__c,w);
			
			if (f.cllease__Fee_Definition__r.clcommon__Class__c == 'Income')		
				supertrumputil.writekeyPair('IsAnExpense','false',w);
			else		
				supertrumputil.writekeyPair('IsAnExpense','true',w);
				
			supertrumputil.writekeyPair('KeptAsAPercent','false',w);		
			supertrumputil.writekeyPair('Amount',string.valueOf(f.cllease__Amount__c),w);		
			//supertrumputil.writekeyPair('IsFinanced','true',w);		
			supertrumputil.writekeyPair('IsLesseeObligation','true',w);		
			supertrumputil.writekeyPair('IsEquity','false',w);		
	
			w.writeEndElement();  //Fee
			i++;
		}
		
		w.writeEndElement();  //Fees

		supertrumputil.writekeyPair('SecurityDeposit','0',w);
		
		system.debug('************** done bldg rents ************************');
    		
    }
    
    /********************************************************************************************
    * write results 
    *
    ********************************************************************************************/
    public static void writeResults(XmlStreamWriter w){
    	/**********************
		* Results
		***********************/
		system.debug('************** bldg results ************************');
		w.writeStartElement(null, 'Results', null); //Fee	
		w.writeStartElement(null, 'TaxClassification', null); //Fee	
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement();  //Tax Classification
		
		w.writeStartElement(null, 'AccountingResults', null); //Fee	
		w.writeStartElement(null, 'LessorAccountingMethod', null); //Fee	
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement();  // 
		w.writeStartElement(null, 'LesseeAccountingMethod', null); //Fee	
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement();  // 
		
		w.writeEndElement();  //Accounting Results
		
		w.writeStartElement(null, 'Stream', null); //Fee	
		w.writeAttribute('', '','name', 'Rent');
		w.writeAttribute('', '','query', 'true');
		
		w.writeEndElement();  //Stream
		w.writeEndElement();  //Results
		
		
		w.writeStartElement(null, 'Assets', null); //Assets
		w.writeStartElement(null, 'Asset', null); //Asset
		w.writeAttribute('', '','index', '*');
		w.writeStartElement(null, 'ExternalID', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement();  
		w.writeStartElement(null, 'Description', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement(); 
		w.writeStartElement(null, 'Cost', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement(); 
		
		w.writeStartElement(null, 'Residual', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement(); 
		
		w.writeStartElement(null, 'Fundings', null); //Fundings
		w.writeStartElement(null, 'Funding', null); //Funding
		w.writeAttribute('', '','index', '*');
		w.writeStartElement(null, 'FundingDate', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement(); 
		w.writeStartElement(null, 'Amount', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement(); 
		
		w.writeEndElement();  //Funding
		w.writeEndElement();  //Fundings

		w.writeEndElement();  //Asset
		w.writeEndElement();  //Assets
		
		w.writeStartElement(null, 'Rents', null); //Rents
		w.writeStartElement(null, 'Rent', null); //Rent
		w.writeAttribute('', '','index', '*');
		w.writeStartElement(null, 'AmortSchedule', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement();  //AmortSchedule
		w.writeEndElement();  //Rent
		w.writeEndElement();  //Rents
		
		w.writeStartElement(null, 'Fees', null); //Fees
		w.writeStartElement(null, 'Fee', null); //Fee
		w.writeAttribute('', '','index', '*');
		w.writeStartElement(null, 'ExternalID', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement(); 
		w.writeStartElement(null, 'Description', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement(); 
		
		w.writeStartElement(null, 'IsAnExpense', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement(); 
		
		w.writeStartElement(null, 'Amount', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement(); 
		
		w.writeStartElement(null, 'IsFinanced', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement(); 
		
		w.writeStartElement(null, 'IsLesseeObligation', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement(); 
		
		w.writeStartElement(null, 'IsEquity', null);  
		w.writeAttribute('', '','query', 'true');
		w.writeEndElement(); 
		
		w.writeEndElement();  //Fee
		w.writeEndElement();  //Fees
		w.writeEndElement();  //Transaction
		/* end */
		
		w.writeStartElement(null, 'AppData', null);  
		w.writeStartElement(null, 'Version', null);
		w.writeAttribute('', '','query', 'true'); 
		w.writeEndElement(); 
		w.writeStartElement(null, 'CustomVersionNumber', null);
		w.writeAttribute('', '','query', 'true'); 
		w.writeEndElement(); 
		w.writeStartElement(null, 'CodeLine', null);
		w.writeAttribute('', '','query', 'true'); 
		w.writeEndElement(); 
		
		w.writeStartElement(null, 'BuildNumber', null);
		w.writeAttribute('', '','query', 'true'); 
		w.writeEndElement(); 
		w.writeStartElement(null, 'ModulePath', null);
		w.writeAttribute('', '','query', 'true'); 
		w.writeEndElement(); 
		
		w.writeEndElement(); //appdata
		w.writeEndDocument();
		system.debug('************** done bldg results ************************');
    	
  
    }
    	
    /********************************************************************************************
    * write xml - create the xml for st call
    *
    ********************************************************************************************/
    public static string writeXML(cllease__Lease_Account__c l){
    	// Start preparing the XML
		String xmlOutput;
		
		xmlOutput = '';
		
		XmlStreamWriter w = new XmlStreamWriter();
    	w.writeStartDocument(null, '1.0'); //Start the XML document
    	
    	supertrumputil.writeHeaderAndFeatures(w,l);
		supertrumputil.writeAssets(w,l);
		supertrumputil.writeRents(w,l);
		supertrumputil.writeResults(w);
			
       	xmlOutput = w.getXmlString();
		
		system.debug('Generated this: ' + xmlOutput);

    	w.close();
    	
    	return xmlOutput; 
	    	
   	} 
   	
   	/********************************************************************************************
   	* derive name
   	*
   	********************************************************************************************/
   	public static String deriveProductName(String taxClass,String lessor, String lessee) {
   		
   		Boolean tax = false;
   		Boolean capital = false;
   		Boolean operating = false;
   		Boolean loan = false;
   		
   		if (taxClass == 'True Tax Lease')
   			tax = true;
   		else
   			tax = false;
   			
   		if (lessor.contains('Capital'))
   			capital = true;
   			
   		if (lessor.contains('Operating')){
   			capital = false;
   			operating = true;
   		}
   		if (lessor.contains('Loan')){
   			capital = false;
   			operating = false;
   			loan = true;
   		}
   		
   		if (loan)
   			return 'Loan';
   			
   		String dllResult = 'DLL_US_';
   		if (operating)
   			dllResult += 'OPL';
   		if (capital)
   			dllResult += 'DFL';
   			
   		if (tax)
   			dllResult += '_TAX';
   		else
   			dllResult += '_NON_TAX';
   			
   		return dllResult;
   	}
    
   	/********************************************************************************************
   	* Send Request to ST
   	*
   	********************************************************************************************/
   	@future(callout=true)
   	public static void sendRequest(Map<ID,String> leaseMap) {
     
    	String xmlOutput;
		Supertrump_Log__c log = new Supertrump_Log__c();
		System.HttpResponse response;
		cllease__Lease_Account__c l;
		 
		try{
			l = new cllease__Lease_Account__c();
    		l = [Select c.cllease__Term__c
	    		, c.cllease__Contract_Date__c
    			, c.cllease__Commencement_Date__c
		   		, c.Trade_Up_Amount__c
   	 			, c.Net_Trade_Up_Amount__c
   	 			, c.Net_Dealer_Funding__c
    			, c.Name
    			, c.booking_Date__c 
    			, c.Purchase_Option__c
    			,cllease__First_Payment_Date__c
    			From cllease__Lease_Account__c c
    			where id in :leaseMap.keySet()
    		];
    	
			xmlOutput = SupertrumpUtil.writeXml(l);
			
   	 		System.HttpRequest request = new System.HttpRequest();
    		//request.setEndpoint('https://pilots.x-trump.com/multiserver/stserver.aspx'); 
    		request.setEndpoint('https://pilots.x-trump.com/generic/stserver.aspx'); 
    	
    		request.setHeader('Content-Type', 'application/xml'); 
    		request.setMethod('POST');
    		
    		request.setBody(xmlOutput); 
    		response = new System.Http().send(request); 
    	
   		 	system.debug('Got result :' + response.getBody());
    	
    		Dom.Document doc = response.getBodyDocument();
       	 	Dom.XMLNode superTrump = doc.getRootElement();
        
        	//system.debug(superTrumpUtil.walkThrough(superTrump,l)); 
        	superTrumpUtil.walkThrough(superTrump,l);
        	
			//Get Exceptions
			
			List<superTrumpUtil.Result> results = new List<superTrumpUtil.Result>();
			results = supertrumputil.parse(doc);
			
			if (results != null){  //exceptions
				log.xml__c = xmloutput;
				log.xml_result__c = response.getBody();
				log.ls_contract__c = l.id;
				l.st_Derived_Product_Name__c = 'Callout Failure';
				update l;
				log.status__c = 'Callout Exceptions';
				log.ls_contract__c = l.id;
				log.exception__c = '';
				for (superTrumpUtil.Result r:results){
					log.exception__c += '======>' + r + '\n';
				}
				insert log;
			}
			else{ //all ok
		 		log.xml__c = xmloutput;
				log.xml_result__c = response.getBody();
				log.ls_contract__c = l.id;
				l = [select st_derived_Product_Name__c from cllease__Lease_Account__c where id = :l.id];
				log.Derived_Product_Name__c = l.st_Derived_Product_Name__c;
				log.status__c = 'OK';
				insert log;
			}			
		}
		catch (Exception e){
			 
			log.xml__c = xmloutput;
			log.xml_result__c = string.valueOf(e);
			l.st_Derived_Product_Name__c = 'Callout Failure';
			update l;
			log.status__c = 'Callout Failure';
			log.ls_contract__c = l.id;
			insert log;
		}
		finally{
			
		}
   	}
	/********************************************************************************************
   	* walkthrough results
   	*
   	********************************************************************************************/
    
	private static String walkThrough(DOM.XMLNode node,cllease__Lease_Account__c l) {
  		
  		String result = '\n';
  		if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {
    		return 'Comment (' +  node.getText() + ')';
  		}
  		if (node.getNodeType() == DOM.XMLNodeType.TEXT) {
    		return 'Text (' + node.getText() + ')';
  		}
  		if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {  
    		result += 'Element: ' + node.getName();
    		if (node.getName() == 'TaxClassification'){
				l.ST_Tax_Classification__c = node.getText().trim();
				system.debug('*** Tax Class *** ' + l.st_tax_classification__c);
			}  
			else{
				if (node.getName() == 'LessorAccountingMethod'){
					l.st_lessor_accounting_method__c = node.getText().trim();
					system.debug('*** Lessor *** ' + l.st_lessor_accounting_method__c);
				}
				else{
					if (node.getName() == 'LesseeAccountingMethod'){
						l.st_lessee_accounting_method__c = node.getText().trim();
						system.debug('*** Lessee *** ' + l.st_lessee_accounting_method__c);
						l.st_derived_product_name__c = deriveProductName(l.ST_Tax_Classification__c
																		,l.st_lessor_accounting_method__c
																		,l.st_lessee_accounting_method__c);
						update l;
					}
				} 
			}
			
			if (node.getText().trim() != '') {
      			result += ', text=' + node.getText().trim();
    		}
    		if (node.getAttributeCount() > 0) { 
      			for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
        			result += ', attribute #' + i + ':' + node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
      			}  
    		}
    	
    		for (Dom.XMLNode child: node.getChildElements()) {
    			
      			result += walkThrough(child,l);
      			
      			
    		}
    		
    		return result;
  		}
  		
  		return '';  //should never reach here 
	}
	
	/********************************************************************************************
   	* result class
   	*
   	********************************************************************************************/
    public class result {
	        String nbr;
	        String description;
	        String comment;
	        String xpath;
	        String sourceOffset;
	        String sourceLine;
	}
	
	/********************************************************************************************
   	* parse results
   	*
   	********************************************************************************************/
    public static List<superTrumpUtil.Result> parse(Dom.Document response) {
    	List<superTrumpUtil.Result> results = new List<superTrumpUtil.Result>();
        system.debug('**************************** bld exception list ************************************');
		
        Dom.XMLNode exceptions = response
                .getRootElement()
                .getChildElement('Transaction', null)
                .getChildElement('Exceptions', null);
          
        if (exceptions == null){
        	system.debug('no exceptions'); 
        	return null;
        }
        for (Dom.XMLNode child1 : exceptions.getChildElements()) {
            if (matches(child1, 'Exception', null)) {
             	Result r = new Result();  
                for (Dom.XMLNode child2 : child1.getChildElements()) {
                    if (matches(child2, 'Number', null)) { 
  						r.nbr = child2.getText();
	                } 
               		if (matches(child2, 'Description', null)) {
                        r.description = child2.getText();
                    }
               		if (matches(child2, 'Comment', null)) {
                        r.comment = child2.getText();
                	}
               		if (matches(child2, 'XPath', null)) {
                        r.xpath = child2.getText();
                	}
               		if (matches(child2, 'SourceOffset', null)) {
                        r.sourceoffset = child2.getText();
                	}
               		if (matches(child2, 'SourceLine', null)) {
                       r.sourceline = child2.getText();
                	}
               	}
             	results.add(r);
            }
        }
        system.debug('**************************** end bld exception list ************************************');
        return results;
    }
    
    /********************************************************************************************
   	* check matches
   	*
   	********************************************************************************************/
    private static Boolean matches(Dom.XMLNode node, String name, String namespace) {
        return node.getName() == name && node.getNamespace() == namespace;
    }
}