/**
 * Owner: Cloud Lending Solutions
 * Usage: Following job helps in Consolidating Bills and charges based on periods from bills and charges
 *         For bills which doesn't have period start date and period end date falls into 
 *              a. existing groups with 
 **/
global with sharing class BillsandChargesConsolidationJob extends clcommon.DynamicJob {
/*    // List of Fee Types to include for charges during consolidate
    private static String feeListStr =  '\'Late Fees\', \'Estimated Property Tax\', \'Service Fees\', '
                                + '\'Insurance Fees\', \'Finance Fees\', \'Interim Rent\', '        
                                + '\'Origination Fees\'';   

    
    // List of Contracts with statuses to consider for consolidation
    private static String contractStatusStr =  '\'ACTIVE - GOOD STANDING\', \'ACTIVE - BAD STANDING\'';

    */
    private static String query; 
    private static final String JOB_NAME = 'Invoice Consolidation Generator Job';
    

    private static List<String> allowedFees = new List<String> {'Late Fees',
                                                                 'Estimated Property Tax',
                                                                 'Service Fees',
                                                                 'Insurance Fees',
                                                                 'Finance Fees',
                                                                 'Interim Rent',
                                                                 'Origination Fees'
                                                                }; 
    // List of Bill Due Types to include for charges during consolidate
    private static List<String> billTypes =  new List<String> { 'BILL / DUE DATE' };
    private static List<String> allowedContractStatus = new List<String> {'ACTIVE - GOOD STANDING',
                                                                          'ACTIVE - BAD STANDING'
                                                                         };


    global BillsandChargesConsolidationJob() {
        super(JOB_NAME, initialize1(null));
    }
    
    global BillsandChargesConsolidationJob(List<String> contractNames) {
        super(JOB_NAME, initialize1(contractNames));
    }
    
    global virtual override String getRuntimeQuery() {
        System.debug(LoggingLevel.ERROR, 'BillsandChargesConsolidationJob query in getRuntimeQuery : ' + query);
        return query; 
    }

    public static String initialize1(List<String> contractNames) {


        mfiflexUtil.ExecutionContext ec = mfiflexUtil.ExecutionContext.getExecContext();
        mfiflexUtil.ObjectCache leaseContractOC = ec.getObject('LeaseContract');
        if(leaseContractOC != null) {
           ec.deleteObject('LeaseContract');      
        }
        
        leaseContractOC = ec.createObject('LeaseContract', 'cllease__Lease_Account__c');


        
        String fields;
        fields =   ''
                 + 'cllease__Net_Balance_Amount__c, '  //ahr added
                 + 'cllease__Net_Fee_Balance__c, '     //ahr added
                 + 'Bill_Not_Paid_Rent__c, '
                 + 'Bill_Not_Paid_Estimated_Property_Tax__c, '
                 + 'Bill_Not_Paid_Service_Pass_Through__c ';

        leaseContractOC.addFields(fields);
        leaseContractOC.addNamedParameter('allowedContractStatus', allowedContractStatus);

        String whereClause = 'cllease__Lease_Status__c IN :allowedContractStatus';
        if(contractNames != null && contractNames.size() > 0) {
            leaseContractOC.addNamedParameter('contractNames', contractNames);
            whereClause += ' AND Name IN :contractNames ';
        }

        leaseContractOC.setWhereClause(whereClause);
        leaseContractOC.setOrderClause('Name');

        mfiflexUtil.ObjectCache chargeOC = ec.createRelationship('cllease__Charges__r');
        leaseContractOC.addRelationship(chargeOC);

        String chargeFields;
        chargeFields =   ''
                       + 'cllease__Original_Amount__c, '
                       + 'cllease__Tax_Due__c, '
                       + 'cllease__Total_Due_Amount__c, '
                       + 'cllease__Lease_Account__c, '
                       + 'cllease__Date__c, '
                       + 'Invoiced_In__c, '
                       + 'cllease__Remarks__c, '
                       + 'cllease__Fee_Definition__c, '
                       + 'cllease__Fee_Definition__r.Name, '
                       + 'cllease__Tax_Processed__c, '
                       + 'cllease__Contract_Equipment__c ';

        chargeOC.addFields(chargeFields);
        chargeOC.addNamedParameter('allowedFees', allowedFees);
        
        String whereClause1 = ' cllease__Waive__c = false ' ;
        whereClause1 += ' AND Invoiced_In__c = null ';
        whereClause1 += ' AND cllease__Fee_Definition__r.Name IN :allowedFees';
        chargeOC.setWhereClause(whereClause1);
        chargeOC.setOrderClause(' Name asc');

        mfiflexUtil.ObjectCache billOC = ec.createRelationship('cllease__Dues_Details__r');
        leaseContractOC.addRelationship(billOC);

        String billFields;
        billFields =   ''
                     + 'cllease__Due_Date__c, '
                     + 'cllease__Period_Start_Date__c, '
                     + 'cllease__Period_End_Date__c, '
                     + 'cllease__Lease_Account__c, '
                     + 'cllease__Total_Due_Amount__c, '
                     + 'cllease__Rental_Due_Amount__c, '
                     + 'Invoiced_In__c, '
                     + 'cllease__Tax_Due_Amount__c, '
                     + 'cllease__Remarks__c, '
                     + 'cllease__Tax_Processed__c ,'
                     + 'cllease__Status__c ';

        billOC.addFields(billFields);
        billOC.addNamedParameter('billTypes', billTypes);
        
        String whereClause2 = ' Invoiced_In__c = null ' ;
        whereClause2 += ' AND cllease__Due_Type_Description__c IN :billTypes ';
        billOC.setWhereClause(whereClause2);
        billOC.setOrderClause(' Name asc');

        query = leaseContractOC.buildQuery().getQuery();
        

        System.debug(LoggingLevel.ERROR, 'BillsandChargesConsolidationJob Query: '+query);
        return query;
    }

    /**
     * Following execute method groups the bills and charges per period per contract
     **/
    public override void doExecute(Database.BatchableContext bc, List<sObject> scope) {
        List<cllease__Lease_Account__c> contractList = (List<cllease__Lease_Account__c>)scope;
        // Map< periodStartDate&periodEndDate&ContractID, list of groups within contract>
        Map<String, List<cllease__Lease_account_Due_Details__c>> billsPeriodMap
            = new Map<String, List<cllease__Lease_account_Due_Details__c>>();
        Map<String, List<cllease__Charge__c>> chargesPeriodMap = new Map<String, List<cllease__Charge__c>>();

        Map<Id, cllease__Lease_Account__c> contractIdMap = new Map<Id, cllease__Lease_Account__c>();
        
        Savepoint sp = database.setsavepoint();        
        try {
            
            // Looping through contracts to group by Bill's period start date and period end date
            for(cllease__Lease_Account__c contract : contractList) {
                System.debug(LoggingLevel.ERROR, 'Processing Contract: '+contract.Name);
                contractIdMap.put(contract.Id, contract);
                // a. process bills for grouping
                for(cllease__Lease_account_Due_Details__c bill : contract.cllease__Dues_Details__r) {
                    String groupKey;
                    // Creating grouping criteria with period start date and period end date for normal bills
                    // in case of evergreen , upfront and termination bills use Due Date as 
                    // those bills will not have period start date and period end date
                    if(bill.cllease__Period_Start_Date__c !=null && bill.cllease__Period_End_Date__c !=null) {
                        groupKey = convertToKey(bill.cllease__Period_Start_Date__c, bill.cllease__Period_End_Date__c, contract.Id);
                    } else {
                        groupKey = convertToKey(bill.cllease__Due_Date__c, null, contract.Id);
                    }
                    
                    List<cllease__Lease_account_Due_Details__c> tempGroup = billsPeriodMap.get(groupKey);
                    tempGroup = (tempGroup == null ? new List<cllease__Lease_account_Due_Details__c>() : tempGroup);
                    tempGroup.add(bill);
                    billsPeriodMap.put(groupKey, tempGroup);
                }

                // b. process charges for grouping
                for(cllease__Charge__c charge : contract.cllease__Charges__r) {
                    String groupKey;
                    // Looping through bills to check for any charges to consolidate with 
                    if(billsPeriodMap.size() > 0) {
                        for(String billGroupKey : billsPeriodMap.keySet()) {
                            String[] dateStr = billGroupKey.split('&');
                            Date periodStartDate = (dateStr[0] != '-' ? Date.valueOf(dateStr[0]) : null);
                            Date periodEndDate   = (dateStr[1] != '-' ? Date.valueOf(dateStr[1]) : null);
                            if( periodStartDate != null
                                && periodEndDate != null
                                && periodStartDate <= charge.cllease__Date__c
                                && periodEndDate >= charge.cllease__Date__c) {
                                groupKey = billGroupKey;
                                break;
                            } else if(periodStartDate != null
                                && periodStartDate == charge.cllease__Date__c) {
                                groupKey = billGroupKey;
                                break;
                            }
                        }
                    }

                    // If no grouping found from Bills for current charge
                    if(groupKey == null) {
                        groupKey = convertToKey(charge.cllease__Date__c, null, contract.Id);
                    }                   
                    
                    List<cllease__Charge__c> tempGroup = chargesPeriodMap.get(groupKey);
                    tempGroup = (tempGroup == null ? new List<cllease__Charge__c>() : tempGroup);
                    tempGroup.add(charge);
                    chargesPeriodMap.put(groupKey, tempGroup);
                }
            }

            // Creating Master list of all  grouping Keys to consolidate Bills and Charges
            Set<String> allGroupKeys = new Set<String>();
            if(billsPeriodMap.size() > 0) {
                allGroupKeys.addAll(billsPeriodMap.keySet());
            }
            if(chargesPeriodMap.size() > 0) {
                allGroupKeys.addAll(chargesPeriodMap.keySet());
            }

            // Looping through Master List of group keys to consolidate Bills and Charges
            Map<String, Invoice__c> invoicePeriodStrMap =  new Map<String, Invoice__c>();

            List<cllease__Lease_account_Due_Details__c> billsToUpdateForRemark
                                = new List<cllease__Lease_account_Due_Details__c>();
            List<cllease__Charge__c> chargesToUpdateForRemark = new List<cllease__Charge__c>();

            System.debug(LoggingLevel.ERROR, '--allGroupKeys: '+allGroupKeys);

            for(String groupKey : allGroupKeys) {
                // Extracting Period Start Date And Period End Date from Group key
                String[] dateStr = groupKey.split('&');
                Date periodStartDate = (dateStr[0] != '-' ? Date.valueOf(dateStr[0]) : null);
                Date periodEndDate   = (dateStr[1] != '-' ? Date.valueOf(dateStr[1]) : null);
                String contractID    = dateStr[2];

                System.debug(LoggingLevel.ERROR, '--processing groupkey: '+groupKey);

                String remarkInGroup = '';
                // This field helps in tracking all bills and charges from Invoices has tax calculated
                Boolean taxComputedForAllBillsAndCharges = true;

                Decimal billRentDue = 0, billTaxDue= 0, billTotalDue= 0;
                Decimal chargeFeeDue= 0, chargeFeeTax= 0, chargeTotalDue= 0;
                Date dueDate; 
                Integer chargesCount = 0;

                Decimal serviceFeeAmount = 0, serviceFeeTaxAmount = 0;
                Decimal estimatedPropertyTaxFeeAmount =0, estimatedPropertyTaxFeeTaxAmount = 0;

                // Loop through Charges for groupkey to find total charges from charges
                if(chargesPeriodMap.containsKey(groupKey)) {
                    System.debug(LoggingLevel.ERROR, '--no of charges from group: : '+chargesPeriodMap.get(groupKey).size());
                    for(cllease__Charge__c charge : chargesPeriodMap.get(groupKey)) {
                        if(charge.cllease__Tax_Processed__c == DLLNewCoConstants.CHARGE_TAX_PROCESSED) {
                            charge.cllease__Original_Amount__c   = charge.cllease__Original_Amount__c!=null ? charge.cllease__Original_Amount__c :0;
                            charge.cllease__Tax_Due__c           = charge.cllease__Tax_Due__c!=null ? charge.cllease__Tax_Due__c :0;
                            chargeFeeDue        += charge.cllease__Original_Amount__c;
                            chargeFeeTax        += charge.cllease__Tax_Due__c;
                            chargeTotalDue      += charge.cllease__Total_Due_Amount__c!=null ? charge.cllease__Total_Due_Amount__c :0;
                            dueDate              = charge.cllease__Date__c;
                            if(charge.cllease__Fee_Definition__c != null) {
                                String feeName = charge.cllease__Fee_Definition__r.Name;
                                if(feeName == DLLNewCoConstants.FEE_SERVICE_FEE) {
                                    serviceFeeAmount    += charge.cllease__Original_Amount__c;
                                    serviceFeeTaxAmount += charge.cllease__Tax_Due__c;
                                } else if(feeName == DLLNewCoConstants.FEE_ESTIMATED_PROPERTY_TAX) {
                                    estimatedPropertyTaxFeeAmount    += charge.cllease__Original_Amount__c;
                                    estimatedPropertyTaxFeeTaxAmount += charge.cllease__Tax_Due__c;
                                }
                            }
                        } else {
                            remarkInGroup       += '  '+ charge.Name;
                            taxComputedForAllBillsAndCharges = false;
                        }
                    }
                    chargesCount = chargesPeriodMap.get(groupKey).size();
                }

                // Loop through Bills for groupKey to find total Dues from Bills
                if(billsPeriodMap.containsKey(groupKey)) {
                    System.debug(LoggingLevel.ERROR, '--no of bills from group: : '+billsPeriodMap.get(groupKey).size());
                    for(cllease__Lease_account_Due_Details__c bill : billsPeriodMap.get(groupKey)) {
                        if(bill.cllease__Tax_Processed__c == true) {
                            bill.cllease__Rental_Due_Amount__c  = bill.cllease__Rental_Due_Amount__c!=null ? bill.cllease__Rental_Due_Amount__c :0;
                            bill.cllease__Tax_Due_Amount__c     = bill.cllease__Tax_Due_Amount__c!=null ? bill.cllease__Tax_Due_Amount__c :0;
                            bill.cllease__Total_Due_Amount__c   = bill.cllease__Total_Due_Amount__c!=null ? bill.cllease__Total_Due_Amount__c :0;
                            billRentDue     += bill.cllease__Rental_Due_Amount__c;
                            billTaxDue      += bill.cllease__Tax_Due_Amount__c;
                            billTotalDue    += bill.cllease__Total_Due_Amount__c;
                            dueDate          = bill.cllease__Due_Date__c;
                        } else {
                            remarkInGroup   += '  '+ bill.Name;
                            taxComputedForAllBillsAndCharges = false;
                        }
                    }
                }


                System.debug(LoggingLevel.ERROR, 'taxComputedForAllBillsAndCharges: '+taxComputedForAllBillsAndCharges);
                /**
                 * proceeding to create Invoice only if all bills and charges from invoice group are tax computed
                 **/
                if(taxComputedForAllBillsAndCharges) {
                    
                    Invoice__c  tempInvoice = new Invoice__c();
                    tempInvoice.Invoice_Due_Date__c             = dueDate;
                    tempInvoice.Invoice_Period_Start_Date__c    = periodStartDate;
                    tempInvoice.Invoice_Period_End_Date__c      = periodEndDate;
                    tempInvoice.LS_Contract__c                  = contractID;
                    tempInvoice.Billed_Amount__c                = billTotalDue;
                    tempInvoice.Charged_Amount__c               = chargeTotalDue;                        
                    tempInvoice.Number_of_Charges__c            = chargesCount;

                    tempInvoice.Payment_Amount__c       = billRentDue + serviceFeeAmount    + estimatedPropertyTaxFeeAmount;
                    tempInvoice.Payment_Sales_Tax__c    = billTaxDue  + serviceFeeTaxAmount + estimatedPropertyTaxFeeTaxAmount;
                    tempInvoice.Payment_Amount_Total__c = tempInvoice.Payment_Amount__c + tempInvoice.Payment_Sales_Tax__c;
                    
                    cllease__Lease_Account__c contract  = contractIdMap.get(contractID);
                    /*
                    Decimal totalUnpaidBillAmount = 0, totalUnpaidEPTAmount = 0, totalUnpaidServiceFeeAmount = 0;
                    totalUnpaidBillAmount       = (contract.Bill_Not_Paid_Rent__c != null ? contract.Bill_Not_Paid_Rent__c : 0);
                    totalUnpaidEPTAmount        = (contract.Bill_Not_Paid_Estimated_Property_Tax__c != null ? contract.Bill_Not_Paid_Estimated_Property_Tax__c : 0);
                    totalUnpaidServiceFeeAmount = (contract.Bill_Not_Paid_Service_Pass_Through__c !=null ? contract.Bill_Not_Paid_Service_Pass_Through__c : 0);
                    */
                   
                   /* 
                    // Previous balance calcualtion = (total bills and charges due) - (current Invoice Due);
                    tempInvoice.Previous_Balance_Due__c = ( totalUnpaidBillAmount + totalUnpaidEPTAmount + totalUnpaidServiceFeeAmount )
                                                         - ( billTotalDue + chargeTotalDue );
                    */
                    
                    //AHR BEgin
                    
                    Decimal totalOutstandingFees = contract.cllease__Net_Fee_Balance__c;
                    if(totalOutstandingFees == null) {
                       totalOutstandingFees = 0.0;
                    }
                    
                    Decimal totalOutstandingBills = contract.cllease__Net_Balance_Amount__c;
                    if(totalOutstandingBills == null) {
                        totalOutstandingBills = 0.0;
                    }
                    
                    tempInvoice.Previous_Balance_Due__c = totalOutstandingBills + totalOutstandingFees
                                                           - billTotalDue - chargeTotalDue;
                    //AHR End
                        
                    remarkInGroup = 'Successfully Processed Bills & Charges to Invoice...';
                    
                    invoicePeriodStrMap.put(groupKey, tempInvoice);
                } else {
                    remarkInGroup += ' not processed for Tax. Please process Tax before running Invoice Consolidation.'; 
                    // Update All bills and charges about remark
                    if(chargesPeriodMap.containsKey(groupKey)) {
                        for(cllease__Charge__c charge : chargesPeriodMap.get(groupKey)) {
                            charge.cllease__Remarks__c = remarkInGroup;
                            chargesToUpdateForRemark.add(charge);
                        }
                    }

                    if(billsPeriodMap.containsKey(groupKey)) {
                        for(cllease__Lease_account_Due_Details__c bill : billsPeriodMap.get(groupKey)) {
                            bill.cllease__Remarks__c = remarkInGroup;
                            billsToUpdateForRemark.add(bill);
                        }
                    }
                }                
            }

            if(invoicePeriodStrMap.size() > 0) {
                // DO DML Operation in Invoices to update
                Database.insert(invoicePeriodStrMap.values(), false);            
                
                List<cllease__Lease_account_Due_Details__c> billsToUpdate = new List<cllease__Lease_account_Due_Details__c>();
                List<cllease__Charge__c> chargesToUpdate = new List<cllease__Charge__c>();
                // Looping through sucessful invoices to update Invoice in Bills and charges
                for(String invoiceGroupKey : invoicePeriodStrMap.keySet()) {
                    Invoice__c invoice = invoicePeriodStrMap.get(invoiceGroupKey);
                    if(invoice.Id != null) {
                        if(billsPeriodMap.get(invoiceGroupKey) != null) {
                            for(cllease__Lease_account_Due_Details__c bill : billsPeriodMap.get(invoiceGroupKey)) {
                                bill.Invoiced_In__c = invoice.Id;
                                bill.cllease__Remarks__c = 'Successfully Processed Bill to Invoice Consolidation';
                            }
                            billsToUpdate.addAll(billsPeriodMap.get(invoiceGroupKey));
                        }                    
                        
                        if(chargesPeriodMap.get(invoiceGroupKey) != null) {
                            for(cllease__Charge__c charge : chargesPeriodMap.get(invoiceGroupKey)) {
                                charge.Invoiced_In__c = invoice.Id;
                                charge.cllease__Remarks__c = 'Successfully Processed Charge to Invoice Consolidation';
                            }
                            chargesToUpdate.addAll(chargesPeriodMap.get(invoiceGroupKey));
                        }                    
                    }
                }

                // Grouping all charges and bills before update
                Map<Id, List<cllease__Lease_account_Due_Details__c>> billsUpdateMap
                            = new Map<Id, List<cllease__Lease_account_Due_Details__c>>();
                Map<Id, List<cllease__Charge__c>> chargesUpdateMap = new Map<Id, List<cllease__Charge__c>>();

                if(chargesToUpdateForRemark.size() > 0) {
                    chargesToUpdate.addAll(chargesToUpdateForRemark);
                }

                if(billsToUpdateForRemark.size() > 0) {
                    billsToUpdate.addAll(billsToUpdateForRemark);
                }

                // update bills and charges
                if(chargesToUpdate.size() > 0) {
                    update chargesToUpdate;
                }

                if(billsToUpdate.size() > 0) {
                    update billsToUpdate;
                }

                if(billsToUpdate.size() > 0 && chargesToUpdate.size() > 0) {
                    calculateFeeAmountsInDueDetails(billsToUpdate, chargesToUpdate);
                }
            }                                                                              

        } catch(Exception e) {
            Database.rollback(sp);   
            System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
            System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());    
            //insert batch process log for exceptions
            insert new cllease__Batch_Process_Log__c(Name='BillsandChargesConsolidationJob:',
            cllease__Date__c=system.today(), cllease__Message__c='Error is '+e.getmessage()
            +' in line number: '+ e.getlinenumber());
        }
    }

    private void calculateFeeAmountsInDueDetails(List<cllease__Lease_account_Due_Details__c> billsToUpdate, List<cllease__Charge__c> chargesToUpdate) {
        // Following not Related to Invoice Consolidation but its related for required fields on 
        // Conga: Invoice PDF Generation
        // Service Fee & Estimated Property Tax Updates in Due Detail Lines for Invoice Updates
        // Group Due Detail Lines & Charges with Key: <<InvoiceId-Equipment>>
        Map<String, List<cllease__Charge__c>> invoiceChargeEquipmentMap = new Map<String, List<cllease__Charge__c>>();
        
        for(cllease__Charge__c charge : chargesToUpdate) {
            if(charge.cllease__Contract_Equipment__c != null && charge.Invoiced_In__c != null) {
                String invoiceEqpKey = charge.Invoiced_In__c +'-'+charge.cllease__Contract_Equipment__c;
                List<cllease__Charge__c> tempGroup = invoiceChargeEquipmentMap.get(invoiceEqpKey);
                tempGroup = (tempGroup == null ? new List<cllease__Charge__c>() : tempGroup);
                tempGroup.add(charge);
                invoiceChargeEquipmentMap.put(invoiceEqpKey, tempGroup);
            }               
        }

        // Getting Bill Ids in to query Due Detials lines
        Set<Id> billIds = new Set<Id>();
        for(cllease__Lease_account_Due_Details__c bill : billsToUpdate) {
            if(bill.Invoiced_In__c != null) {
                billIds.add(bill.Id);
            }
        }

        // Querying Due Detail Lines to create Map.
        List<cllease__Due_Detail_Lines__c> dueDetailLines = [SELECT Id, Name,
                                                                Service_Fee_Fee_Amount__c,
                                                                Service_Fee_Tax_Amount__c,
                                                                Estimated_Property_Tax_Fee_Amount__c,
                                                                Estimated_Property_Tax_Tax_Amount__c,
                                                                cllease__Contract_Equipment__c,
                                                                cllease__Bill__c,
                                                                cllease__Bill__r.Invoiced_In__c,
                                                                cllease__Remarks__c
                                                            FROM cllease__Due_Detail_Lines__c
                                                            WHERE cllease__Contract_Equipment__c != null
                                                                AND cllease__Bill__c IN :billIds];

        List<cllease__Due_Detail_Lines__c> dueDetailLineToUpdate = new List<cllease__Due_Detail_Lines__c>();
        // Creating Map with Key: InvoiceId-Equipment
        for(cllease__Due_Detail_Lines__c dueDetailLine : dueDetailLines) {
            if(dueDetailLine.cllease__Contract_Equipment__c != null
                && dueDetailLine.cllease__Bill__r.Invoiced_In__c != null) {
                String invoiceEqpKey = dueDetailLine.cllease__Bill__r.Invoiced_In__c +'-' + dueDetailLine.cllease__Contract_Equipment__c;
                Decimal serviceFeeAmount = 0, serviceFeeTaxAmount = 0;
                Decimal estimatedPropertyTaxFeeAmount =0, estimatedPropertyTaxFeeTaxAmount = 0; 
                
                List<cllease__Charge__c> charges = invoiceChargeEquipmentMap.get(invoiceEqpKey);
                if(charges != null) {
                    for(cllease__Charge__c charge : charges) {
                        String feeName = charge.cllease__Fee_Definition__r.Name;
                        charge.cllease__Original_Amount__c = (charge.cllease__Original_Amount__c != null ? charge.cllease__Original_Amount__c : 0);
                        charge.cllease__Tax_Due__c = (charge.cllease__Tax_Due__c !=null ? charge.cllease__Tax_Due__c: 0);
                        if(feeName == DLLNewCoConstants.FEE_SERVICE_FEE) {
                            serviceFeeAmount    += charge.cllease__Original_Amount__c;
                            serviceFeeTaxAmount += charge.cllease__Tax_Due__c;
                        } else if(feeName == DLLNewCoConstants.FEE_ESTIMATED_PROPERTY_TAX) {
                            estimatedPropertyTaxFeeAmount    += charge.cllease__Original_Amount__c;
                            estimatedPropertyTaxFeeTaxAmount += charge.cllease__Tax_Due__c;
                        }
                    }

                    dueDetailLine.Service_Fee_Fee_Amount__c = serviceFeeAmount;
                    dueDetailLine.Service_Fee_Tax_Amount__c = serviceFeeTaxAmount;
                    dueDetailLine.Estimated_Property_Tax_Fee_Amount__c = estimatedPropertyTaxFeeAmount;
                    dueDetailLine.Estimated_Property_Tax_Tax_Amount__c = estimatedPropertyTaxFeeTaxAmount;
                    dueDetailLine.cllease__Remarks__c = 'Charge Fee and Tax Amounts Updated in Due Detail Line.';
                    dueDetailLineToUpdate.add(dueDetailLine);
                }
            }
        }

        // Doing Exception handling in method  invocation level
        if(dueDetailLineToUpdate.size() > 0) {
            update dueDetailLineToUpdate;
        }
    }

    // Following helps in creating Key from Dates and ContractName
    private String convertToKey(Date startDate, Date endDate, String contractName) {
        String key = '';
        key += (startDate!=null ? String.valueOf(startDate): '-') +'&';
        key += (endDate!=null ? String.valueOf(endDate): '-') +'&';
        key += contractName;
        return key;
    }

    public override void doInitialize() { }
    public override void doStart(Database.BatchableContext bc) { }   
    public override void doFinish(Database.BatchableContext bc) { }
}