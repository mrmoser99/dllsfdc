public class TerminationTriggerHandler {
    
    class myException extends Exception{}
    
    class proRationRate{
        Decimal equipCostRate, residualRate, subsidyRate, subventionRate;
        
        public proRationRate(){
            this.equipCostRate = 1;
            this.residualRate = 1;
            this.subsidyRate = 1;
            this.subventionRate = 1;
        }
    }
    
    public List<cllease__Lease_Account__c> returnContract(Set<Id> contractIds){
        List<cllease__Lease_Account__c> contractList = [SELECT ID,
                                                            cllease__Pre_Bill_Days__c,
                                                            (SELECT Id, 
                                                                cllease__Rental_Amount__c,
                                                                cllease__Date__c,
                                                                cllease__Active__c
                                                             FROM cllease__Payment_Streams__r 
                                                             WHERE cllease__Active__c = True), //Payment stream
                                                            (SELECT Id, 
                                                             	cllease__Payment_Amount__c,
                                                             	cllease__Beginning_Net_Investment__c,
                                                             	cllease__Ending_Net_Investment__c,
                                                                cllease__Lease_Income__c,
                                                                cllease__Date__c,
                                                                cllease__Accrued_Flag__c
                                                             FROM cllease__Rental_Streams__r
                                                             WHERE cllease__Active__c = True), //Income Stream
                                                            (SELECT Id,
                                                                cllease__Residual_Income__c,
                                                             	cllease__Beginning_Lease_Residual__c,
                                                             	cllease__Beginning_Unearned_Residual_Income__c,
                                                             	cllease__Ending_Lease_Residual__c,
                                                                cllease__Date__c,
                                                                cllease__Accrued_Flag__c
                                                             FROM cllease__Residual_Streams__r
                                                             WHERE cllease__Active__c = True), //Residual Stream
                                                            (SELECT Id,
                                                                cllease__Expense_Initial_Direct_Cost__c,
                                                             	cllease__Beginning_Initial_Direct_Cost__c,
                                                             	cllease__Ending_Initial_Direct_Cost__c,
                                                                cllease__Date__c,
                                                                cllease__Accrued_Flag__c
                                                             FROM cllease__IDC_Stream__r
                                                             WHERE cllease__Active__c = True), //IDC Stream
                                                            (SELECT Id,
                                                                cllease__Accrued_Amount__c,
                                                             	cllease__Beginning_Balance__c,
                                                             	cllease__Ending_Balance__c,
                                                                cllease__Date__c,
                                                                cllease__Transaction_Sub_Type__r.Name,
                                                                cllease__Accrued__c
                                                             FROM cllease__Subsidy_Streams__r
                                                             WHERE cllease__Active__c = True), // Subsidy/Subvention Stream
                                                            (SELECT Id,
                                                                Rent_Balance__c,
                                                                cllease__Due_Type_Description__c 
                                                             FROM cllease__Dues_Details__r
                                                             WHERE cllease__Payment_Satisfied__c = False), // Bill transaction
                                                            (SELECT Id,
                                                                cllease__Principal_Due__c
                                                             FROM cllease__Charges__r
                                                             WHERE cllease__Paid__c = False), // Charge transaction
                                                            (SELECT Id,
                                                                cllease__Estimated_Selling_Price__c,
                                                                cllease__Residual_Amount__c,
                                                                cllease__Subsidy__c,
                                                                cllease__Subvention__c 
                                                                FROM cllease__Contract_Equipments__r
                                                                WHERE cllease__status1__c = 'LEASED') // Equipment required for pro-ration
                                                        FROM cllease__Lease_Account__c
                                                        WHERE Id IN : contractIds];
        return contractList;
    }
    
    List<cllease__Termination_Quote_Header__c> terminationHeader = new List<cllease__Termination_Quote_Header__c>();
    Map<Id, cllease__Termination_Quote_Header__c> contractToHeader = new Map<Id, cllease__Termination_Quote_Header__c>();
    Map<Id, Set<Id>> headerToEquipment = new Map<Id, Set<Id>>();
    Set<Id> terminationHeaderIds = new Set<Id>();
    List<cllease__Other_Transaction__c> terminationTxns = new List<cllease__Other_Transaction__c>();
    
    Public void setRateForTermiantion(proRationRate rate, cllease__Lease_Account__c leaseAccount){
		Decimal totalTerminationEquipCost = 0, totalEquipCost = 0;
        Decimal totalTerminationEquipResidual = 0, totalResidual = 0;
        Decimal totalTerminationEquipSubsidy = 0, totalSubsidy = 0;
        Decimal totalTerminationEquipSubvention = 0, totalSubvention = 0;
        Id terminationId;
        System.debug(LoggingLevel.ERROR, '^^^^ Equipments : ' + leaseAccount.cllease__Contract_Equipments__r);
        for(cllease__Contract_Equipment__c equipment : leaseAccount.cllease__Contract_Equipments__r){
            System.debug(LoggingLevel.ERROR, '^^^^ equip Id : ' + equipment.Id);
            totalEquipCost += equipment.cllease__Estimated_Selling_Price__c == null ? 0 : equipment.cllease__Estimated_Selling_Price__c;
            totalResidual += equipment.cllease__Residual_Amount__c == null ? 0 : equipment.cllease__Residual_Amount__c;
            totalSubsidy += equipment.cllease__Subsidy__c == null ? 0 : equipment.cllease__Subsidy__c;
            totalSubvention += equipment.cllease__Subvention__c == null ? 0 : equipment.cllease__Subvention__c;
            terminationId = contractToHeader.get(leaseAccount.Id).Id;
            if(headerToEquipment.get(terminationId).contains(equipment.Id)){
                System.debug(LoggingLevel.ERROR, '^^^^ Term equip Id : ' + equipment.Id);
                totalTerminationEquipCost += equipment.cllease__Estimated_Selling_Price__c == null ? 0 : equipment.cllease__Estimated_Selling_Price__c;
                totalTerminationEquipResidual += equipment.cllease__Residual_Amount__c == null ? 0 : equipment.cllease__Residual_Amount__c;
                totalTerminationEquipSubsidy += equipment.cllease__Subsidy__c == null ? 0 : equipment.cllease__Subsidy__c;
                totalTerminationEquipSubvention += equipment.cllease__Subvention__c == null ? 0 : equipment.cllease__Subvention__c;
            }
        }
        if(totalEquipCost > 0){
            if(totalTerminationEquipCost == 0)
                rate.equipCostRate = 0;
            else
            	rate.equipCostRate = totalTerminationEquipCost/totalEquipCost;
        }
        if(totalResidual > 0){
            if(totalTerminationEquipResidual == 0)
                rate.residualRate = 0;
            else
            	rate.residualRate = totalTerminationEquipResidual/totalResidual;
        }
        if(totalSubsidy > 0){
            if(totalTerminationEquipSubsidy == 0)
                rate.subsidyRate = 0;
            else
            	rate.subsidyRate = totalTerminationEquipSubsidy/totalSubsidy;
        }
        if(totalSubvention > 0){
            if(totalTerminationEquipSubvention == 0)
                rate.subventionRate = 0;
            else
            	rate.subventionRate = totalTerminationEquipSubvention/totalSubvention;
        }
    }
    
    public TerminationTriggerHandler(List<cllease__Termination_Quote_Header__c> terminationHeader){
        this.terminationHeader = terminationHeader;
        this.terminationHeaderIds = new Map<Id, cllease__Termination_Quote_Header__c>(terminationHeader).keySet();
    }
    
    public TerminationTriggerHandler(List<cllease__Other_Transaction__c> terminationTxns){
        this.terminationTxns = terminationTxns;
    }
    
    public void processTerminationAccounting(){
        List<cllease__Lease_Account__c> contractList = new List<cllease__Lease_Account__c>();
        for(cllease__Termination_Quote_Header__c header : terminationHeader) {
            contractToHeader.put(header.cllease__Contract__c, header);
        }
        
        // get equipment list from termintion header
        List<cllease__Termination_Quote_Equipment__c> termiantionEquipmentList = [SELECT ID, 
                                                                                 		cllease__Contract_Equipment__c,
                                                                                 		cllease__Termination_Quote_Header__c 
                                                                                 		FROM cllease__Termination_Quote_Equipment__c
                                                                                 		WHERE cllease__Termination_Quote_Header__c IN : terminationHeaderIds];
        for(cllease__Termination_Quote_Equipment__c equipment : termiantionEquipmentList){
            Set<Id> equipmentIds = new Set<Id>();
            if(headerToEquipment.containsKey(equipment.cllease__Termination_Quote_Header__c)){
                equipmentIds = headerToEquipment.get(equipment.cllease__Termination_Quote_Header__c);
            }
            equipmentIds.add(equipment.cllease__Contract_Equipment__c);
            headerToEquipment.put(equipment.cllease__Termination_Quote_Header__c, equipmentIds);
        }
        System.debug(LoggingLevel.ERROR, '^^^^ headerToEquipment : ' + headerToEquipment);
        // Quering contract details ,stream and bills related information
        if(contractToHeader.keySet().size() > 0){
            contractList = returnContract(contractToHeader.keySet());
            computeAndCommit(contractList);
        }
        
    }
    
    public void computeAndCommit(List<cllease__Lease_Account__c> contractList){
        List<Termination_Detail__c> terminationDetails = new List<Termination_Detail__c>();
        for(cllease__Lease_Account__c leaseAccount : contractList){
            Decimal unbilledRent = 0, unearnedLeaseIncome = 0, billNotPaid = 0, unearnedIDCIncome = 0;
        	Decimal unearnedResidualIncome = 0,unearnedSubsidyIncome = 0, unearnedSubventionIncome = 0;
            proRationRate rate = new proRationRate();
            setRateForTermiantion(rate, leaseAccount);
            Termination_Detail__c terminationDetail = new Termination_Detail__c();
            terminationDetail.Equipment_Cost_Rate__c = rate.equipCostRate;
            terminationDetail.Residual_Rate__c = rate.residualRate;
            terminationDetail.Subsidy_Rate__c = rate.subsidyRate;
            terminationDetail.Subvention_Rate__c = rate.subventionRate;
            System.debug(LoggingLevel.ERROR, '^^^^ equipmentRate : ' + rate.equipCostRate);
            System.debug(LoggingLevel.ERROR, '^^^^ residualRate : ' + rate.residualRate);
            System.debug(LoggingLevel.ERROR, '^^^^ subsidyRate : ' + rate.subsidyRate);
            System.debug(LoggingLevel.ERROR, '^^^^ subventionRate : ' + rate.subventionRate);
            Date terminationDate = contractToHeader.get(leaseAccount.id).cllease__Requested_Termination_Date__c;
            Date effectiveDate = terminationDate.addDays(Integer.valueof(leaseAccount.cllease__Pre_Bill_Days__c));
            for(cllease__Payment_Stream__c pmt : leaseAccount.cllease__payment_streams__r){
                if(pmt.cllease__Date__c > effectiveDate)
                	unbilledRent += pmt.cllease__Rental_Amount__c;
            }
            unbilledRent = unbilledRent * rate.equipCostRate;
       		terminationDetail.Termination_Future_Rent__c = unbilledRent;
            System.debug(LoggingLevel.ERROR, '^^^^ unbilledRent : ' + unbilledRent);
            
            for(cllease__Rental_Stream__c income : leaseAccount.cllease__Rental_Streams__r){
                if(income.cllease__Date__c > terminationDate)
                	unearnedLeaseIncome += income.cllease__Lease_Income__c;
            }
            unearnedLeaseIncome = unearnedLeaseIncome * rate.equipCostRate;
            terminationDetail.Termination_Unearned_Income__c = unearnedLeaseIncome;
            System.debug(LoggingLevel.ERROR, '^^^^ unearnedLeaseIncome : ' + unearnedLeaseIncome);
            
            for(cllease__Residual_Stream__c residual : leaseAccount.cllease__Residual_Streams__r){
                if(residual.cllease__Date__c > terminationDate)
                	unearnedResidualIncome += residual.cllease__Residual_Income__c;
            }
            unearnedResidualIncome = unearnedResidualIncome * rate.residualRate;
            terminationDetail.Termination_Residual_Income__c = unearnedResidualIncome;
            System.debug(LoggingLevel.ERROR, '^^^^ unearnedResidualIncome : ' + unearnedResidualIncome);
            
            for(cllease__Initial_Direct_Cost_Stream__c idc : leaseAccount.cllease__IDC_Stream__r){
                if(idc.cllease__Date__c > terminationDate)
                	unearnedIDCIncome += idc.cllease__Expense_Initial_Direct_Cost__c;
            }
            unearnedIDCIncome = unearnedIDCIncome * rate.equipCostRate;
            terminationDetail.Termination_IDC_Expense__c = unearnedIDCIncome;
            System.debug(LoggingLevel.ERROR, '^^^^ unearnedIDCIncome : ' + unearnedIDCIncome);
            
            for(cllease__Subsidy_Stream__c subsidy : leaseAccount.cllease__Subsidy_Streams__r){
                if(subsidy.cllease__Date__c > terminationDate){
                    if(subsidy.cllease__Transaction_Sub_Type__r.Name == 'SUBSIDY ACCRUAL')
                		unearnedSubsidyIncome += subsidy.cllease__Accrued_Amount__c;
                    if(subsidy.cllease__Transaction_Sub_Type__r.Name == 'SUBVENTION ACCRUAL')
                		unearnedSubventionIncome += subsidy.cllease__Accrued_Amount__c;
                }
            }
            unearnedSubsidyIncome = unearnedSubsidyIncome * rate.subsidyRate;
            unearnedSubventionIncome = unearnedSubventionIncome * rate.subventionRate;
            terminationDetail.Termination_Subsidy_Income__c = unearnedSubsidyIncome;
            terminationDetail.Termination_Subvention_Income__c = unearnedSubventionIncome;
            System.debug(LoggingLevel.ERROR, '^^^^ unearnedSubsidyIncome : ' + unearnedSubsidyIncome);
            System.debug(LoggingLevel.ERROR, '^^^^ unearnedSubventionIncome : ' + unearnedSubventionIncome);
            
            for(cllease__Lease_account_Due_Details__c bill : leaseAccount.cllease__Dues_Details__r){
                System.debug(LoggingLevel.ERROR, '^^^^ bill : ' + bill);
                if(bill.cllease__Due_Type_Description__c != 'TERMINATION')
                	billNotPaid += bill.Rent_Balance__c;
            }
           	billNotPaid = billNotPaid * rate.equipCostRate;
            System.debug(LoggingLevel.ERROR, '^^^^ billNotPaid : ' + billNotPaid);
            terminationDetail.Termination_Bill_Unpaid__c = billNotPaid;

            Decimal feeNotPaid = 0;
            for(cllease__Charge__c charge : leaseAccount.cllease__Charges__r){
                System.debug(LoggingLevel.ERROR, '^^^^ Charge : ' + charge);
                feeNotPaid += charge.cllease__Principal_Due__c;
            }
           	feeNotPaid = feeNotPaid * rate.equipCostRate;
            System.debug(LoggingLevel.ERROR, '^^^^ feeNotPaid : ' + feeNotPaid);
            terminationDetail.Termination_Fee_Unpaid__c = feeNotPaid;

            terminationDetail.Termination_Quote__c = contractToHeader.get(leaseAccount.Id).Id;
            terminationDetails.add(terminationDetail);
        }
        System.debug(LoggingLevel.ERROR, '^^^^ terminationDetails : ' + terminationDetails);
       	insert terminationDetails;
    }
    
    public void populateAccountingValuesOnOLT(){
        List<cllease__Lease_Account__c> contracts = new List<cllease__Lease_Account__c>();
        Map<Id, cllease__Lease_Account__c> contractList;
        List<cllease__other_transaction__c> otherTxnToBeInserted = new List<cllease__other_transaction__c>();
        Map<Id, Id> headerToContract = new Map<Id,Id>();
        Map<Id, Termination_Detail__c> terminationDetails = new Map<Id, Termination_Detail__c>();
        List<Termination_Detail__c> accountingInfo = new List<Termination_Detail__c>();
        Map<Id, cllease__Termination_Quote_Header__c> contractToHeader = new Map<Id, cllease__Termination_Quote_Header__c>();
        
        // List of streams to be updated
        //List<cllease__Payment_Stream__c> pmtStreams = new List<cllease__Payment_Stream__c>();
        List<cllease__Rental_Stream__c> incomeStreams = new List<cllease__Rental_Stream__c>();
        List<cllease__Residual_Stream__c> residualStreams = new List<cllease__Residual_Stream__c>();
        List<cllease__Initial_Direct_Cost_Stream__c> idcStreams = new List<cllease__Initial_Direct_Cost_Stream__c>();
        List<cllease__Subsidy_Stream__c> subsidyStreams = new List<cllease__Subsidy_Stream__c>();
        //List<cllease__Subsidy_Stream__c> subventionStreams = new List<cllease__Subsidy_Stream__c>();
        
        for(cllease__Termination_Quote_Header__c header : terminationHeader) {
            headerToContract.put(header.Id, header.cllease__Contract__c);
            contractToHeader.put(header.cllease__Contract__c, header);
        }
        contractList = new Map<Id, cllease__Lease_Account__c>([SELECT ID
                                                                    ,(SELECT ID,
                                                                          Equipment_Cost_Rate__c,
                                                                          Residual_Rate__c,
                                                                          Subsidy_Rate__c,
                                                                          Subvention_Rate__c ,
                                                                          Termination_Bill_Unpaid__c,
                                                                          Termination_Future_Rent__c,
                                                                          Termination_IDC_Expense__c,
                                                                          Termination_Residual_Income__c,
                                                                          Termination_Subsidy_Income__c,
                                                                          Termination_Subvention_Income__c,
                                                                      	  Termination_Unearned_Income__c,
                                                                      	  cllease__Txn_Date__c,
                                                                      	  Termination_Quote__c,
                                                                          Termination_Fee_Unpaid__c
                                                                      FROM cllease__Other_Lease_Transactions__r
                                                                      ORDER BY createdDate Desc Limit 1)
                                                                FROM cllease__Lease_Account__c
                                                                WHERE Id IN : headerToContract.values()]);
        accountingInfo = [SELECT Id, 
                              Equipment_Cost_Rate__c,
                              Residual_Rate__c,
                              Subsidy_Rate__c,
                              Subvention_Rate__c ,
                              Termination_Bill_Unpaid__c,
                              Termination_Future_Rent__c,
                              Termination_IDC_Expense__c,
                              Termination_Quote__c,
                              Termination_Residual_Income__c,
                              Termination_Subsidy_Income__c,
                              Termination_Subvention_Income__c,
                              Termination_Unearned_Income__c,
                              Termination_Fee_Unpaid__c
                          FROM Termination_Detail__c
                          WHERE Termination_Quote__c IN: headerToContract.keySet()];
        
        for(Termination_Detail__c detail : accountingInfo){
            terminationDetails.put(detail.Termination_Quote__c, detail);
        }
        
        System.debug(LoggingLevel.ERROR, '^^^^ otherTxn : ' + contractList);
        System.debug(LoggingLevel.ERROR, '^^^^ accountingInfo : ' + terminationDetails);
        
        for(Id header : headerToContract.keySet()){
            cllease__Other_Transaction__c otherTxn = contractList.get(headerToContract.get(header)).cllease__Other_Lease_Transactions__r;
            cllease__Other_Transaction__c newTxn = new cllease__Other_Transaction__c(Id = otherTxn.Id);
            Termination_Detail__c txnDetail = terminationDetails.get(header);
            newTxn.Equipment_Cost_Rate__c = txnDetail.Equipment_Cost_Rate__c;
            newTxn.Residual_Rate__c = txnDetail.Residual_Rate__c;
            newTxn.Subsidy_Rate__c = txnDetail.Subsidy_Rate__c;
            newTxn.Subvention_Rate__c = txnDetail.Subvention_Rate__c;
            newTxn.Termination_Bill_Unpaid__c = txnDetail.Termination_Bill_Unpaid__c;
            newTxn.Termination_Future_Rent__c = txnDetail.Termination_Future_Rent__c;
            newTxn.Termination_IDC_Expense__c = txnDetail.Termination_IDC_Expense__c;
            newTxn.Termination_Residual_Income__c = txnDetail.Termination_Residual_Income__c;
            newTxn.Termination_Subsidy_Income__c = txnDetail.Termination_Subsidy_Income__c;
            newTxn.Termination_Subvention_Income__c = txnDetail.Termination_Subvention_Income__c;
            newTxn.Termination_Unearned_Income__c = txnDetail.Termination_Unearned_Income__c;
            newTxn.Termination_Fee_Unpaid__c  = txnDetail.Termination_Fee_Unpaid__c;
            newTxn.Termination_Quote__c = header;
            otherTxnToBeInserted.add(newTxn);
        }
        System.debug(LoggingLevel.ERROR, '^^^^ otherTxnToBeInserted : ' + otherTxnToBeInserted);
        update otherTxnToBeInserted;
        contracts = returnContract(contractList.keySet());
        for(cllease__Lease_Account__c contract : contracts){
            cllease__Other_Transaction__c otherTxn = contractList.get(contract.Id).cllease__Other_Lease_Transactions__r;
            Date effectiveDate = otherTxn.cllease__Txn_Date__c;
            Date monthEndDate = effectiveDate.addMonths(1).toStartofMonth().addDays(-1);
            cllease__Termination_Quote_Header__c header = contractToHeader.get(contract.Id);
            Termination_Detail__c detail = terminationDetails.get(header.Id);
            // Update Income Streams
            for(cllease__Rental_Stream__c income : contract.cllease__Rental_Streams__r){
                Decimal rate = detail.Equipment_Cost_Rate__c == 1 ? 1 : 1 - detail.Equipment_Cost_Rate__c;
                if(header.cllease__Full_Termination__c){
                    if(income.cllease__Date__c >= monthEndDate){
                        income.cllease__Accrued_Flag__c = True;
                    	incomeStreams.add(income);
                    }
                } else{
                    if(income.cllease__Date__c == monthEndDate){
                    	income.cllease__Payment_Amount__c = income.cllease__Payment_Amount__c * rate;
                        income.cllease__Beginning_Net_Investment__c = income.cllease__Beginning_Net_Investment__c * rate;
                        income.cllease__Lease_Income__c = income.cllease__Lease_Income__c * rate;
                        income.cllease__Ending_Net_Investment__c = income.cllease__Ending_Net_Investment__c * rate;
                        incomeStreams.add(income);
                    }
                }
            }
            
            for(cllease__Residual_Stream__c residual : contract.cllease__Residual_Streams__r){
                Decimal rate = detail.Residual_Rate__c == 1 ? 1 : 1 - detail.Residual_Rate__c;
                if(header.cllease__Full_Termination__c){
                    if(residual.cllease__Date__c >= monthEndDate){
                        residual.cllease__Accrued_Flag__c = True;
                        residualStreams.add(residual);
                    }
                } else{
                    if(residual.cllease__Date__c == monthEndDate){
                    	residual.cllease__Beginning_Lease_Residual__c = residual.cllease__Beginning_Lease_Residual__c * rate;
                        residual.cllease__Beginning_Unearned_Residual_Income__c = residual.cllease__Beginning_Unearned_Residual_Income__c * rate;
                        residual.cllease__Residual_Income__c = residual.cllease__Residual_Income__c * rate;
                        residual.cllease__Ending_Lease_Residual__c = residual.cllease__Ending_Lease_Residual__c * rate;
                        residualStreams.add(residual);
                    }
                }
            }
            
            for(cllease__Initial_Direct_Cost_Stream__c idc : contract.cllease__IDC_Stream__r){
                Decimal rate = detail.Equipment_Cost_Rate__c == 1 ? 1 : 1 - detail.Equipment_Cost_Rate__c;
                if(header.cllease__Full_Termination__c){
                    if(idc.cllease__Date__c >= monthEndDate){
                        idc.cllease__Accrued_Flag__c = True;
                    	idcStreams.add(idc);
                    }
                } else{
                    if(idc.cllease__Date__c == monthEndDate){
                    	idc.cllease__Beginning_Initial_Direct_Cost__c = idc.cllease__Beginning_Initial_Direct_Cost__c * rate;
                        idc.cllease__Expense_Initial_Direct_Cost__c = idc.cllease__Expense_Initial_Direct_Cost__c * rate;
                        idc.cllease__Ending_Initial_Direct_Cost__c = idc.cllease__Ending_Initial_Direct_Cost__c * rate;
                        idcStreams.add(idc);
                    }
                }
            }
            
            for(cllease__Subsidy_Stream__c subsidy : contract.cllease__Subsidy_Streams__r){
                Decimal subRate = detail.Subsidy_Rate__c == 1 ? 1 : 1 - detail.Subsidy_Rate__c;
                Decimal subvenRate = detail.Subvention_Rate__c == 1 ? 1 : 1 - detail.Subvention_Rate__c;
                if(header.cllease__Full_Termination__c){
                    if(subsidy.cllease__Date__c >= monthEndDate){
                        if(subsidy.cllease__Transaction_Sub_Type__r.Name == 'SUBSIDY ACCRUAL'){
                            subsidy.cllease__Accrued__c = True;
                            subsidyStreams.add(subsidy);
                        }
                        if(subsidy.cllease__Transaction_Sub_Type__r.Name == 'SUBVENTION ACCRUAL'){
                            subsidy.cllease__Accrued__c = True;
                            subsidyStreams.add(subsidy);
                        }
                    }
                } else{
                    if(subsidy.cllease__Date__c == monthEndDate){
                        if(subsidy.cllease__Transaction_Sub_Type__r.Name == 'SUBSIDY ACCRUAL'){
                            subsidy.cllease__Beginning_Balance__c = subsidy.cllease__Beginning_Balance__c * subRate;
                            subsidy.cllease__Accrued_Amount__c = subsidy.cllease__Accrued_Amount__c * subRate;
                            subsidy.cllease__Ending_Balance__c = subsidy.cllease__Ending_Balance__c * subRate;
                            subsidyStreams.add(subsidy);
                        }
                        if(subsidy.cllease__Transaction_Sub_Type__r.Name == 'SUBVENTION ACCRUAL'){
                            subsidy.cllease__Beginning_Balance__c = subsidy.cllease__Beginning_Balance__c * subvenRate;
                            subsidy.cllease__Accrued_Amount__c = subsidy.cllease__Accrued_Amount__c * subvenRate;
                            subsidy.cllease__Ending_Balance__c = subsidy.cllease__Ending_Balance__c * subvenRate;
                            subsidyStreams.add(subsidy);
                        }
                    }
                }
            }
        }
        
        if(incomeStreams.size() > 0)
            update incomeStreams;
        if(residualStreams.size() > 0)
            update residualStreams;
        if(idcStreams.size() > 0)
            update idcStreams;
        if(subsidyStreams.size() > 0)
            update subsidyStreams;
        System.debug(LoggingLevel.ERROR, '^^^ incomeStreams : ' + incomeStreams);
        System.debug(LoggingLevel.ERROR, '^^^ residualStreams : ' + residualStreams);
        System.debug(LoggingLevel.ERROR, '^^^ idcStreams : ' + idcStreams);
        System.debug(LoggingLevel.ERROR, '^^^ subsidyStreams : ' + subsidyStreams);
        //throw new myException('TEST');
    }
    
    public void processOLT(){
        System.debug(LoggingLevel.ERROR, '^^^^ termiantionTxns : ' + terminationTxns); 
    }
}