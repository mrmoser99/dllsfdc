/**
 * Author: Cloud Lending Solutions
 * Description: Following trigger helps in copying the details from Termination Quote lines to Due Details lines 
 * 				on Contract Termination Quote Accepted
 **/
trigger CopyTerminationDetailsToDDLTrigger on cllease__Other_Transaction__c (after insert) {
	// 1. Check for Transaction of type "Termination" and store the contract ID details to list to retrive detailse
	Set<Id> terminatedeContactIdSet = new Set<Id>();
	String infoMessage = '';
	Savepoint sp = database.setsavepoint();
	try {
		// Extracting the Contract IDs to retrieve details
		for(cllease__Other_Transaction__c txn: Trigger.new) {
			if(txn.cllease__Transaction_Type__c == 'TERMINATION' && txn.cllease__Lease_Account__c != null) {
				terminatedeContactIdSet.add(txn.cllease__Lease_Account__c);
			}
		}

		// 2. Retrieve the Termination Quote Header details for Contract only if any Termination Transations found in step-1
		if(terminatedeContactIdSet.size() > 0) {
			// 2.1 Query Termination Equipment Quote Details
			List<cllease__Termination_Quote_Header__c> terminationQuotes = [SELECT Id, Name,
																				(SELECT Id, Name, Amount__c,
																						Termination_Quote_Equipment__c, 
																						Termination_Quote_Equipment__r.cllease__Contract_Equipment__c,
																						Termination_Quote_Line__c,
																						Termination_Quote_Line__r.cllease__Line_Type__c
																				 FROM Termination_Equipment_Quotes__r)
																			FROM cllease__Termination_Quote_Header__c
																			WHERE cllease__Contract__c IN :terminatedeContactIdSet
																				AND ( (cllease__Contract__r.cllease__Lease_Product_Name__r.cllease__wait_for_cash__c = true
																						AND cllease__Status__c = 'PROCESSED'
																					  )
																					  OR 
																					  ( cllease__Contract__r.cllease__Lease_Product_Name__r.cllease__wait_for_cash__c = false
																					  	AND cllease__Status__c = 'TERMINATION PROCESSED'
																					  )
																					) ];

			// Process above results and create map of details with Equipments
			Map<Id, List<Termination_Equipment_Quote__c>> eqpTermEqpQuoteMap = new Map<Id, List<Termination_Equipment_Quote__c>>();
			for(cllease__Termination_Quote_Header__c terminationQuote : terminationQuotes) {
				for(Termination_Equipment_Quote__c termEqpQuote : terminationQuote.Termination_Equipment_Quotes__r) {
					if(termEqpQuote.Termination_Quote_Equipment__c != null && termEqpQuote.Termination_Quote_Equipment__r.cllease__Contract_Equipment__c !=null ) {
						Id eqpId = termEqpQuote.Termination_Quote_Equipment__r.cllease__Contract_Equipment__c;
						List<Termination_Equipment_Quote__c> tempMap = eqpTermEqpQuoteMap.get(eqpId);
						if(tempMap == null) {
							tempMap = new List<Termination_Equipment_Quote__c>();
						}
						tempMap.add(termEqpQuote);
						eqpTermEqpQuoteMap.put(eqpId, tempMap);
					}
				}
			}

			Map<String, String> terminationDueDetailLineFieldAPIMap = VertexUtil2.terminationDueDetailLineFieldAPIMap;

			// Retrieve the Bill & Due Detail lines only if Termination has Map created with above.
			if(eqpTermEqpQuoteMap.size() > 0) {
				List<cllease__Due_Detail_Lines__c> dueDetailsLinesToUpdate = new List<cllease__Due_Detail_Lines__c>();
				// Query Bill &  Due Detail lines w.r.t Contract and Termination type
				List<cllease__Lease_account_Due_Details__c> terminatedBills = [Select Id, Name, 
							                                                        (Select Id, Name, Quote_Discount__c, Quote_Purchase_Amount__c, 
							                                                        	Quote_Purchase_Premium_Amount__c, Quote_Rollover_Incentive__c,
							                                                        	Quote_Service_and_Maintainence__c, Quote_Unbilled_Receivable__c,
							                                                        	cllease__Contract_Equipment__c 
							                                                        From cllease__Due_Detail_Lines__r)
							                                                    From cllease__Lease_account_Due_Details__c 
							                                                    Where cllease__Lease_Account__c IN :terminatedeContactIdSet
							                                                     	AND cllease__Due_Type_Description__c= 'TERMINATION'];


				Map<Id, cllease__Due_Detail_Lines__c> eqpDueDetailLineMap = new Map<Id, cllease__Due_Detail_Lines__c>();
				// Creating the Map<Eqp, DueDetail line map for terminated bill
				for(cllease__Lease_account_Due_Details__c terminatedBill : terminatedBills) {
					for(cllease__Due_Detail_Lines__c ddl : terminatedBill.cllease__Due_Detail_Lines__r) {
						eqpDueDetailLineMap.put(ddl.cllease__Contract_Equipment__c, ddl);
					}
				}

				// Loop through all Termination Quote lines for updating the Due Detail lines
				for(Id eqpId : eqpDueDetailLineMap.keySet()) {
					cllease__Due_Detail_Lines__c ddl = eqpDueDetailLineMap.get(eqpId);
					if(ddl != null) {
						List<Termination_Equipment_Quote__c> termEqpQuotes = eqpTermEqpQuoteMap.get(eqpId);
						for(Termination_Equipment_Quote__c termEqpQuote : termEqpQuotes) {
							String quoteLineType = termEqpQuote.Termination_Quote_Line__r.cllease__Line_Type__c;
							Decimal amount = termEqpQuote.Amount__c;
							String fieldAPIName = terminationDueDetailLineFieldAPIMap.get(quoteLineType);
							

							System.debug(LoggingLevel.ERROR, ' quoteLineType: '+ quoteLineType);
							System.debug(LoggingLevel.ERROR, ' amount: '+ amount);
							System.debug(LoggingLevel.ERROR, ' fieldAPIName: '+ fieldAPIName);

							// Setting the value to Due detail line from Termination Quote line.
							if(fieldAPIName != null) {
								ddl.put(fieldAPIName, amount);
							}
						}
						dueDetailsLinesToUpdate.add(ddl);
					}
				}

				if(dueDetailsLinesToUpdate.size() > 0) {
					update dueDetailsLinesToUpdate;
				}
			}
		}

	} catch(exception e){           
       	database.rollback(sp);   
       	infoMessage = 'Error :' + e.getmessage();
       	System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
       	System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());      
       	//insert batch process log for exceptions
       	insert new cllease__Batch_Process_Log__c(Name='CopyTerminationDetailsToDDLTrigger: ', cllease__Date__c=system.today(), 
       	cllease__Message__c='Error is '+e.getmessage() +' in line number: '+ e.getlinenumber());
    }
}