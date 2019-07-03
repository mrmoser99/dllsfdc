/**
 * Usage: 
 * 	List<String> contractNames = new List<String>{'a6u0t0000000GNg'};
 * 	NetInvestmentReportGeneratorJob job 
 *   		= new NetInvestmentReportGeneratorJob(contractNames, DateToRun);
 * 	Database.executeBatch(job, 1);
 *
 **/
global with sharing class NetInvestmentReportGeneratorJob extends clcommon.DynamicJob {
	private static String query;
    private String openPeriodEndDate;
    private Date currentSystemDate;
    private Date yearStartDate;
    private Date monthStartDate;
    private String currentSystemDateStr;
    private cllease__Period_Status__c openPeriod;
    private Map<Id, cllease__Office_Name__c> companiesMap;

    private static final String JOB_NAME = 'Net Investment Report Generator Job';

    global NetInvestmentReportGeneratorJob() {
        super(JOB_NAME, initialize(null));
    }
    
    global NetInvestmentReportGeneratorJob(List<String> contractNames, Date dateToRun) {
        super(JOB_NAME, initialize(contractNames));
        currentSystemDate 	= dateToRun;
        //openPeriod   		= periodToRun;
    }
    
    global virtual override String getRuntimeQuery() {
        System.debug(LoggingLevel.ERROR, 'NetInvestmentReportGeneratorJob query in getRuntimeQuery : ' + query);
        return query; 
    }

    public static String initialize(List<String> contractNames) {                                                   
       
        // Creating Dynamic Query on Contract Object 
        query = ' SELECT Id, Name, cllease__Lease_Status__c, cllease__Term__c, cllease__Contract_Date__c, cllease__Maturity_Date__c,  '+  
				' 		cllease__Lease_Product_Name__r.Name, cllease__Product_Sub_Type__c, cllease__Branch__c, cllease__Excess__c,	  '+
				'		cllease__Account__r.Oracle_Vendor_ID__c , cllease__Yield__c, Billed_Not_Paid__c, cllease__Residual_Amount__c, '+
				' 		cllease__Lease_Receivable_Amount__c , cllease__Payment_Frequency__c, cllease__Account__r.Name,                '+
				'		cllease__Financed_Amount__c, Unbilled_Receivable__c, Unbilled_Rent__c, cllease__Payment_Method__c,   		  '+
                '       Oracle_Trade_Up_Quote_Amount__c,                                                                              '+
                '       (SELECT Id, Name, cllease__Date__c, cllease__Rental_Amount__c, cllease__Tax__c,                               '+
                '               cllease__Active__c, cllease__Billed__c                                                                '+
                '           FROM cllease__Payment_Streams__r                                                                          '+
                '           WHERE cllease__Active__c = true AND cllease__Payment_Type__c = \'RENT\' ),                                '+
				' 		(SELECT Id, Name, cllease__Date__c, cllease__Rental_Accrual__c,cllease__Accrued__c, cllease__Active__c        '+
				' 			FROM cllease__Rental_Accrual_Streams__r                                                                   '+
				' 			WHERE cllease__Active__c = true ),                                                                        '+
				' 		(SELECT Id, Name, cllease__Date__c, cllease__Lease_Income__c, cllease__Capital_Recovery__c,                   '+
				' 				cllease__Accrued_Flag__c, cllease__Active__c                                                  '+
				' 			FROM cllease__Rental_Streams__r                                                                           '+
				' 			WHERE cllease__Active__c = true ),                                                                        '+
				' 		(SELECT Id, Name, cllease__Date__c, cllease__Residual_Income__c, cllease__Accrued_Flag__c, cllease__Active__c '+
				' 			FROM cllease__Residual_Streams__r                                                                         '+
				' 			WHERE cllease__Active__c = true ),                                                                        '+
				' 		(SELECT Id, Name, cllease__Transaction_Type__c, cllease__Unearned_Lease_Income_Amount__c, cllease__Unearned_Income_Residual_Amount__c '+
				' 			FROM cllease__Other_Lease_Transactions__r                                                                 '+
				' 			WHERE cllease__Transaction_Type__c IN (\'RESTRUCTURE\', \'TERMINATION\', \'BOOKING\')),                                '+
				' 		(SELECT Id, Name, cllease__Party_Account_Name__r.Name, cllease__Party_Account_Name__r.Oracle_Vendor_ID__c     '+
				' 			FROM cllease__Contract_Parties__r                                                                         '+
				' 			WHERE cllease__Party_Type__c = \'DEALER\'),                                                               '+
                '       (SELECT Id, Name, cllease__Estimated_Selling_Price__c, cllease__Dealer_Name__c,                               '+
                '               cllease__Dealer_Name__r.Oracle_Vendor_ID__c                                                           '+
                '           FROM cllease__Contract_Equipments__r )                                                                    '+
				' FROM cllease__Lease_Account__c	                                                                                  '+
				' WHERE cllease__Lease_Status__c in (\'ACTIVE - GOOD STANDING\',\'ACTIVE - BAD STANDING\', \'EVERGREEN\')             ';

        if(contractNames!=null && contractNames.size() > 0) {
            String contractNamesStr = '';
            for (String contractName : contractNames) {
              contractNamesStr = contractNamesStr + '\'' + String.escapeSingleQuotes(contractName) + '\'' + ',';
            }
            contractNamesStr = contractNamesStr.substring(0, contractNamesStr.length() - 1);
            query += ' AND Name in ('+ contractNamesStr + ') ';
        }

        query += ' ORDER BY Name';
        
        System.debug(LoggingLevel.ERROR, 'NetInvestmentReportGeneratorJob query in initialize : ' + query);
        return query;
    }

    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {
    	List<cllease__Lease_Account__c> contracts = (List<cllease__Lease_Account__c>)scope;
    	List<Int_OLMN_Net_Investment__c> reportsToInsert = new List<Int_OLMN_Net_Investment__c>();
    	
    	Savepoint sp = database.setsavepoint();        
        try {

			// Retrieving company details
			companiesMap = new Map<Id, cllease__Office_Name__c>(
									[SELECT Id, Name,
										Dll_Seg1_Company__c,
										Dll_Seg2_Business_Unit__c
									FROM cllease__Office_Name__c
									LIMIT 100]);

	    	if(currentSystemDate == null) {
	    		currentSystemDate 	= cllease.SystemDateUtil.getCurrentSystemDate();
	    	}

            // Retrieving Period for which date report runs
            List<cllease__Period_Status__c> openPeriods = [SELECT Id, Name,
                                                            cllease__Start_Date__c,
                                                            cllease__End_Date__c,
                                                            cllease__Period_Year__c
                                                        FROM cllease__Period_Status__c
                                                        WHERE cllease__Status__c = 'Open'
                                                        ORDER BY cllease__End_Date__c DESC];

            // Taking the last open period for which needed to run Net Investment Report
            if(openPeriods.size() > 0) {
                openPeriod = openPeriods[0];
            }
            if(openPeriod == null) {
                throw new CLSCustomException('No Open Period available, Open period to proceed...');
            }

	    	System.debug(LoggingLevel.ERROR, ' currentSystemDate: '+currentSystemDate);

            // Issue: While converting DateTime to String format, it always giving 1 day less so adding up 1 day to cover up.
            Datetime periodEndDate      = openPeriod.cllease__End_Date__c;
            Datetime currentSystemNow   = System.now();

            periodEndDate = periodEndDate.addHours(currentSystemNow.hour());
            periodEndDate = periodEndDate.addMinutes(currentSystemNow.minute());
            periodEndDate = periodEndDate.addSeconds(currentSystemNow.second());

	        openPeriodEndDate    	= periodEndDate.format('yyyyMMdd'); 
	        //currentSystemDateStr    = ((Datetime)currentSystemDate).format('yyyyMMdd');
	    	yearStartDate 			= Date.newInstance(currentSystemDate.year(), 1, 1);
	    	monthStartDate			= Date.newInstance(currentSystemDate.year(), currentSystemDate.month(), 1);
        	
        	System.debug(LoggingLevel.ERROR, ' Starting the Process: ');

            Set<String> contractNamesToDelete = new Set<String>();
            // Looping through contracts to gather contractNames for cleanup
            for(cllease__Lease_Account__c contract : contracts)  {
                contractNamesToDelete.add(contract.Name);
            }   

            cleanUpDuplicateReport(contractNamesToDelete, openPeriodEndDate);

            // process Contract for report generation
        	for(cllease__Lease_Account__c contract : contracts) {
        		System.debug(LoggingLevel.ERROR, ' Starting the Report Processing on Contract: '+contract.Name);
        		Int_OLMN_Net_Investment__c report = getReportForContract(contract);
        		if(report != null) {
        			reportsToInsert.add(report);
        		}        		    		
        	}

        	if(reportsToInsert.size() > 0) {
        		insert reportsToInsert;
        	}

        } catch(exception e){           
            database.rollback(sp);           
            System.debug(LoggingLevel.ERROR, 'Exception while processing NetInvestmentReportGeneratorJob: '+e.getMessage());
            System.debug(LoggingLevel.ERROR, 'Exception StackTrace: '+e.getStackTraceString());
            //insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name='NetInvestmentReportGeneratorJob ',
            cllease__Date__c=system.today(), cllease__Message__c='Error is '+e.getmessage()
            +' in line number: '+ e.getlinenumber());
       }

    }

    private Int_OLMN_Net_Investment__c getReportForContract(cllease__Lease_Account__c contract) {
    	Int_OLMN_Net_Investment__c report = new Int_OLMN_Net_Investment__c();
    	try {

            // ---------------------------------Starting Preprocessing on the Contract for details------------------------------------//
            cllease__Office_Name__c company = companiesMap.get(contract.cllease__Branch__c);

            Decimal totalUnEarnedIncome = 0, mtdLeaseIncome = 0, unEarnedIncome = 0, ytdLeaseIncome = 0;
            Decimal totalUnEarnedResidual = 0, mtdResidual = 0, unEarnedResidual = 0, ytdLeaseResidual = 0; 

            System.debug(LoggingLevel.ERROR, 'yearStartDate: '+yearStartDate);
            System.debug(LoggingLevel.ERROR, 'monthStartDate: '+monthStartDate);
            System.debug(LoggingLevel.ERROR, 'currentSystemDate: '+currentSystemDate);
            if(contract.cllease__Product_Sub_Type__c == 'FINANCE LEASE') {
                for(cllease__Rental_Stream__c rentalStream : contract.cllease__Rental_Streams__r) {
                    rentalStream.cllease__Lease_Income__c = (rentalStream.cllease__Lease_Income__c !=null ? rentalStream.cllease__Lease_Income__c : 0);
                    //totalUnEarnedIncome += rentalStream.cllease__Lease_Income__c;
                    if(rentalStream.cllease__Date__c >= yearStartDate 
                        && rentalStream.cllease__Date__c <= currentSystemDate
                        && rentalStream.cllease__Accrued_Flag__c == true) {
                        ytdLeaseIncome += rentalStream.cllease__Lease_Income__c;
                    }
                    if(rentalStream.cllease__Date__c >= monthStartDate 
                        && rentalStream.cllease__Date__c <= currentSystemDate
                        && rentalStream.cllease__Accrued_Flag__c == true) {
                        mtdLeaseIncome += rentalStream.cllease__Lease_Income__c;
                    }
                    if(rentalStream.cllease__Accrued_Flag__c == false) {
                        unEarnedIncome += rentalStream.cllease__Lease_Income__c;
                    }
                }
            }

            for(cllease__Residual_Stream__c residualStream : contract.cllease__Residual_Streams__r) {
                residualStream.cllease__Residual_Income__c = (residualStream.cllease__Residual_Income__c !=null ? residualStream.cllease__Residual_Income__c : 0);
                //totalUnEarnedResidual += residualStream.cllease__Residual_Income__c;
                if(residualStream.cllease__Date__c >= yearStartDate 
                    && residualStream.cllease__Date__c <= currentSystemDate
                    && residualStream.cllease__Accrued_Flag__c == true) {
                    ytdLeaseResidual += residualStream.cllease__Residual_Income__c;
                }
                if(residualStream.cllease__Date__c >= monthStartDate 
                    && residualStream.cllease__Date__c <= currentSystemDate
                    && residualStream.cllease__Accrued_Flag__c == true) {
                    mtdResidual += residualStream.cllease__Residual_Income__c;
                }
                if(residualStream.cllease__Accrued_Flag__c == false) {
                    unEarnedResidual += residualStream.cllease__Residual_Income__c;
                }
            }

            Decimal unbilledReceivable = 0;
            Integer unbilledRentCount  = 0;
            for(cllease__Payment_Stream__c paymentStream : contract.cllease__Payment_Streams__r) {
                if(paymentStream.cllease__Billed__c == false) {
                    paymentStream.cllease__Rental_Amount__c = (paymentStream.cllease__Rental_Amount__c !=null ? paymentStream.cllease__Rental_Amount__c : 0);
                    unbilledReceivable += paymentStream.cllease__Rental_Amount__c;
                    unbilledRentCount++;

                }
            }

            String isLeaseRebooked = 'N';
            String isLeasePartialTerminated = 'N';
            for(cllease__Other_Transaction__c otherTxn : contract.cllease__Other_Lease_Transactions__r) {
                if(otherTxn.cllease__Transaction_Type__c == 'RESTRUCTURE') {
                    isLeaseRebooked = 'Y';
                } else if(otherTxn.cllease__Transaction_Type__c == 'TERMINATION'){
                    isLeasePartialTerminated = 'Y';
                } else if(otherTxn.cllease__Transaction_Type__c == 'BOOKING') {
                    totalUnEarnedIncome   = otherTxn.cllease__Unearned_Lease_Income_Amount__c;
                    totalUnEarnedResidual = otherTxn.cllease__Unearned_Income_Residual_Amount__c;
                }
            }

            // ---------------------------------Ending Preprocessing on the Contract for details------------------------------------//

            // Updating Records
    		report.CONTRACT_NUMBER__C 		= contract.Name;
        		
    		if(contract.cllease__Lease_Status__c == 'ACTIVE - GOOD STANDING' 
    			|| contract.cllease__Lease_Status__c == 'ACTIVE - BAD STANDING') {
    			if(currentSystemDate <= contract.cllease__Maturity_Date__c) {
    				report.CONTRACT_STATUS__C = 'BOOKED';
    			} else {
    				report.CONTRACT_STATUS__C = 'EXPIRED';
    			}
    		} else if(contract.cllease__Lease_Status__c == 'EVERGREEN') {
    			report.CONTRACT_STATUS__C 	= 'EVERGREEN';
    		}

            Datetime currentSystemNow = System.now();

            // Contract start date string format conversion
            DateTime contractStartDate = contract.cllease__Contract_Date__c;

            contractStartDate = contractStartDate.addHours(currentSystemNow.hour());
            contractStartDate = contractStartDate.addMinutes(currentSystemNow.minute());
            contractStartDate = contractStartDate.addSeconds(currentSystemNow.second());

            String contractStartDateStr = contractStartDate.format('yyyyMMdd');

            // Contract maturity date string format conversion
            DateTime contractMaturityDate = contract.cllease__Maturity_Date__c;

            contractMaturityDate = contractMaturityDate.addHours(currentSystemNow.hour());
            contractMaturityDate = contractMaturityDate.addMinutes(currentSystemNow.minute());
            contractMaturityDate = contractMaturityDate.addSeconds(currentSystemNow.second());

            String contractEndDateStr = contractMaturityDate.format('yyyyMMdd');


    		report.CONTRACT_TERM__C 		= contract.cllease__Term__c;
    		report.CONTRACT_START_DATE__C  	= contractStartDateStr;
    		report.CONTRACT_END_DATE__C   	= contractEndDateStr;
    		report.FIN_PRODUCT__C 			= contract.cllease__Lease_Product_Name__r.Name;


            if(contract.cllease__Payment_Method__c == 'ARREARS') {
                report.ARREARS_YN__c = 'Y';
            } else {
                report.ARREARS_YN__c = 'N';
            }

    		if(contract.cllease__Product_Sub_Type__c == 'FINANCE LEASE') {
    			report.LEASE_TYPE__C 		= 'FL';
    		} 
            // Currently DLLNewCo doesn't support Operating Lease
            /*else if(contract.cllease__Product_Sub_Type__c == 'OPERATING LEASE') {
    			report.LEASE_TYPE__C 		= 'OL';
    		}*/

    		report.LESSEE_NAME__C 		= contract.cllease__Account__r.Name;
    		report.LESSEE_NUMBER__C  	= contract.cllease__Account__r.Oracle_Vendor_ID__c;
    		report.PERIOD_DATE__C 		= openPeriodEndDate;

    		report.REPORTING_ENTITY__C  = company.Dll_Seg1_Company__c;
    		report.SBU__C 				= company.Dll_Seg2_Business_Unit__c;

    		report.ACCOUNTING_YIELD__C  = cllease.ValueUtil.round(contract.cllease__Yield__c, 4, 'Nearest');
    		report.BILLED_UNPAID_REC__C = contract.Billed_Not_Paid__c;
    		report.BOOKED_RESIDUAL__C  	= contract.cllease__Residual_Amount__c;
            report.CAP_ROLLOVER_FEE_AMOUNT__c = contract.Oracle_Trade_Up_Quote_Amount__c; // it should be 8th field report extraction.

    		// 	report.CAP_BROKER_FEE_AMOUNT__C = 
    		// 	report.CAP_OTHER_FEE_AMOUNT__C  = 

    		report.EQUIPMENT_COST_CORP__C = contract.cllease__Financed_Amount__c;
    		report.EQUIPMENT_COST_FED__C  = contract.cllease__Financed_Amount__c;

    		// 	report.FROZEN_LEASE_INCOME__C    = 
    		// 	report.FROZEN_RESIDUAL_INCOME__C = 

    		report.GROSS_RECEIVABLES__C   = contract.cllease__Lease_Receivable_Amount__c;
    		
    		report.HARD_COST__C = contract.cllease__Financed_Amount__c; // Total Equipment Cost
    		report.SOFT_COST__C = 0; // add on cost which currently CL Lease doesn't support
    		report.MONEY_ON_ACCOUNT__C = cllease.ValueUtil.round(contract.cllease__Excess__c, 2, 'Nearest');

    		report.TOT_UNEARNED_LEASE_INCOME__C 	= cllease.ValueUtil.round(totalUnEarnedIncome, 2, 'Nearest');
			report.TOT_UNEARNED_RESIDUAL_INCOME__C 	= cllease.ValueUtil.round(totalUnEarnedResidual, 2, 'Nearest');
            // Marking fields to negative value as DLLNewCo-OLMN system expecting these values as negative amounts
			report.MTD_LEASE_INCOME__C 				= -1 * cllease.ValueUtil.round(mtdLeaseIncome, 2, 'Nearest');
			report.MTD_RESIDUAL_INCOME__C 			= -1 * cllease.ValueUtil.round(mtdResidual, 2, 'Nearest');

			report.UNEARNED_LEASE_INCOME__C 		= cllease.ValueUtil.round(unEarnedIncome, 2, 'Nearest');
			report.UNEARNED_RESIDUAL_INCOME__C   	= cllease.ValueUtil.round(unEarnedResidual, 2, 'Nearest');

			report.UNBILLED_RECEIVABLE__C 	= cllease.ValueUtil.round(unbilledReceivable, 2, 'Nearest');

			if(contract.cllease__Payment_Frequency__c == 'MONTHLY') {
				report.PAYMENT_FREQUENCY__C = 'M';
			} else if(contract.cllease__Payment_Frequency__c == 'ANNUAL') {
				report.PAYMENT_FREQUENCY__C = 'A';
			} else if(contract.cllease__Payment_Frequency__c == 'SEMI-ANNUAL') {
				report.PAYMENT_FREQUENCY__C = 'S';
			}

			// 	report.PRIVATE_LABEL__C 
            if(contract.cllease__Contract_Parties__r != null
                && contract.cllease__Contract_Parties__r.size() > 0
                && contract.cllease__Contract_Parties__r.get(0).cllease__Party_Account_Name__c != null) {
                report.VENDOR_NUMBER__C = contract.cllease__Contract_Parties__r.get(0).cllease__Party_Account_Name__r.Oracle_Vendor_ID__c;
            }
			
			//	report.VENDOR_PROGRAM__C

			report.REBOOKED_YN__C 		 = isLeaseRebooked;
			report.REMAINING_PAYMENTS__C = unbilledRentCount;
			// report.UPFRONT_TAX_AMOUNT__C = 
			
            // Marking fields to negative value as DLLNewCo-OLMN system expecting these values as negative amounts
			report.YTD_LEASE_INCOME__C   = -1 * cllease.ValueUtil.round(ytdLeaseIncome, 2, 'Nearest');
			report.YTD_RESIDUAL_INCOME__C= -1 * cllease.ValueUtil.round(ytdLeaseResidual, 2, 'Nearest');

			report.PARTIAL_TERMINATION_YN__C = isLeasePartialTerminated;

    	} catch(Exception e) {
    		System.debug(LoggingLevel.ERROR, 'Exception while processing contract Number: '+contract.Name);
    		System.debug(LoggingLevel.ERROR, 'Exception : '+e.getMessage());
           	System.debug(LoggingLevel.ERROR, 'Exception StackTrace: '+e.getStackTraceString());
            insert new cllease__Batch_Process_Log__c(Name='NetInvestmentReportGeneratorJob ',
            cllease__Date__c=system.today(), cllease__Message__c='Error is '+e.getmessage()
            +' in line number: '+ e.getlinenumber());
    		return null; // return null in case any exception during the contract processing for report
    	}
    	return report;
    }

    private void cleanUpDuplicateReport(Set<String> contractNames, String periodDate) {
        // Cleaning up report objects if contract report available for on specific period and which is not commited
        List<Int_OLMN_Net_Investment__c> duplicateReports = [SELECT Id, Name
                                                             FROM Int_OLMN_Net_Investment__c
                                                             WHERE CONTRACT_NUMBER__C IN :contractNames
                                                                AND PERIOD_DATE__C = :periodDate
                                                                AND Committed__c = false];
        if(duplicateReports.size() > 0) {
            delete duplicateReports;
        } 
    }

    public override void doInitialize() { }
    public override void doStart(Database.BatchableContext bc) {
        //0. Checking for unfinished transactions in interface table.
        //   Incase of any unfinished transactions, job should not run till all txns commited to DLL
        //Throw exception and skip the job run in case of any unfinished transactions
        //    uncommittedInterfaceRecordsExist = true for all interface records not processed
        //                               = false for all interface records  processed 
        Boolean uncommittedInterfaceRecordsExist 
            = InterfaceTablesUnfinishedTxnsCheck.checkUnfinishedTxnsForNetInvestmentReport();
        
        if(uncommittedInterfaceRecordsExist) {
            throw new CLSCustomException('Net Investment Interface table(Int_OLMN_Net_Investment__c) has unfinished transactions. '+
                    'Please commit all transactions from Interface table and run Job again...');
        }
    }   
    public override void doFinish(Database.BatchableContext bc) { }
}