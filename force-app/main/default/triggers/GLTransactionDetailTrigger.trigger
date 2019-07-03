/*  
    a. Transaction Type
        - Check for Transcation Type and check for Movement Code
        - Store Bill and charges if Tax Type
    b. Tax Type
        - For Bill, Charge, Payment Tax, Assign Contract__r.State__c as Movement Code
*/
trigger GLTransactionDetailTrigger on cllease__GL_Transaction_Detail__c (before insert, before update) {
    
    public class MyException extends Exception{}

    System.debug(LoggingLevel.ERROR, 'Starting GL Account Entry Processing Completed for Movement Code update...');

    List<cllease__GL_Transaction_Detail__c> glEntriesList = trigger.new;
    System.debug(LoggingLevel.ERROR, '^^^^ glEntriesList : ' + glEntriesList);
    
    Set<Id> glAccountToRetrieve = new Set<Id>();
    Set<Id> contractsToRetrieve = new Set<Id>();
    Set<Id> companysToRetrieve  = new Set<Id>();
    set<Id> chargeIds = new Set<Id>();
    Integer count = 0;

    for(cllease__GL_Transaction_Detail__c glEntry : glEntriesList) {
        System.debug(LoggingLevel.ERROR, ' Processing GL Entry:'+glEntry);
        if(glEntry != null) {
            glAccountToRetrieve.add(glEntry.cllease__Credit_GL_Account__c);
            glAccountToRetrieve.add(glEntry.cllease__Debit_GL_Account__c);
            contractsToRetrieve.add(glEntry.cllease__Contract__c);
            companysToRetrieve.add(glEntry.cllease__Company__c);
            chargeIds.add(glEntry.cllease__Charge__c);
            // Process only Record if Movement Segment Code null or empty
            if((glEntry.Movement_Code_DR_Segment__c == null || glEntry.Movement_Code_DR_Segment__c == '')
                && (glEntry.Movement_Code_CR_Segment__c == null || glEntry.Movement_Code_CR_Segment__c == '')) {
                count++;
            }
        }
    }

    // Process if there are any GL Accounting Entries Records
    if(count > 0) { 
        System.debug(LoggingLevel.ERROR, '---count: '+count);
        // a. Retrieving Company Details
        Map<Id, cllease__Office_Name__c> companiesMap 
            = new Map<Id, cllease__Office_Name__c>(
                                        [SELECT Id, Name,
                                            Dll_Seg1_Company__c,
                                            Dll_Seg2_Business_Unit__c,
                                            Dll_Seg3_Department__c,
                                            Dll_Seg6__c,
                                            Dll_Seg7__c
                                        FROM cllease__Office_Name__c
                                        WHERE Id IN :companysToRetrieve]);

        // b. Retrieve Contract Details
        Map<Id, cllease__GL_Account__c>  glAccountsMap 
            = new Map<Id, cllease__GL_Account__c>(
                                        [SELECT Id, Name, 
                                            Is_Movement_Code_Eligible__c
                                        FROM cllease__GL_Account__c
                                        WHERE Id IN :glAccountToRetrieve]);

        // c. Retrieve GL Account Details
        Map<Id, cllease__Lease_Account__c> contractsMap
            = new Map<Id, cllease__Lease_Account__c>(
                                        [SELECT Id, Name, 
                                            State__c
                                        FROM cllease__Lease_Account__c
                                        WHERE Id IN :contractsToRetrieve]);

        // d .Retrieve Movement Codes for Transactions and Taxes.
        Map<String, Movement_Code__c> txnMovementCodesMap = new Map<String, Movement_Code__c>();
        Map<String, Movement_Code__c> taxMovementCodesMap = new Map<String, Movement_Code__c>();
        List<Movement_Code__c> movementCodesList = [SELECT Id, Name, 
                                                    CL_Lease_Transaction_Type__c,
                                                    Movement_Code__c,
                                                    Contract_Install_State_Location__c,
                                                    Transaction_Eligible_GL_Account_Codes__c,
                                                    Billing_Tax_Eligible_GL_Account_Codes__c,
                                                    Payment_Tax_Eligible_GL_Account_Codes__c
                                                FROM Movement_Code__c
                                                    LIMIT 1000];
        
        // e. get fee Id and Name as this is required 
        Map<Id, cllease__Charge__c> chargeIdAndNameMap = new Map<Id, cllease__Charge__c>([SELECT ID, 
                                                                                          Name,
                                                                                          cllease__Fee_Definition__r.Name
                                                                                          FROM cllease__Charge__c
                                                                                          WHERE Id in : chargeIds]);

        // 3. Creating Map for Transction & Tax records
        for(Movement_Code__c movementCode : movementCodesList) {
            String txnType = movementCode.CL_Lease_Transaction_Type__c;
            if(txnType == 'TAX') {
                taxMovementCodesMap.put(movementCode.Movement_Code__c, movementCode);
            } else {
                txnMovementCodesMap.put(txnType, movementCode);
            }
        }

        System.debug(LoggingLevel.ERROR, 'taxMovementCodesMap: '+taxMovementCodesMap);
        System.debug(LoggingLevel.ERROR, 'txnMovementCodesMap: '+txnMovementCodesMap);

        // 4. Updating Movement Code for Transactions and Tax
        // Note: Currently Not Checking GL Account Code for Transactions due to uneven matches
        //       For Tax, Checking GL Account Code with String Contains method
        for(cllease__GL_Transaction_Detail__c glEntry : glEntriesList) {
            // Assigning default values
            glEntry.Movement_Code_Cr__c = '00';
            glEntry.Movement_Code_Dr__c = '00';
            System.debug(LoggingLevel.ERROR, '^^^ glEntry : ' + glEntry.cllease__Transaction_Description__c);
            String clleaseTxnType       = glEntry.CL_Lease_Transaction_Type__c;
            String clleaseTxnSubType    = glEntry.Transaction_Sub_Type__c;
            String remark = 'Updated Default Movement Codes...';
            
            if(glEntry.cllease__Charge__c != null && clleaseTxnSubType == null){
                system.debug(LoggingLevel.ERROR, '^^^ chargeIdAndNameMap : ' + chargeIdAndNameMap);
                Cllease__Charge__c chargeTxn = chargeIdAndNameMap.get(glEntry.cllease__Charge__c);
                system.debug(LoggingLevel.ERROR, '^^^ chargeTxn : ' + chargeTxn);
                System.debug(LoggingLevel.ERROR, '^^^ glEntry.cllease__Charge__r : ' + glEntry.cllease__Charge__r);
                clleaseTxnSubType = chargeTxn.cllease__Fee_Definition__r.Name;
                glEntry.cllease__Transaction_Description__c = chargeTxn.Name + ' - ' + clleaseTxnSubType + ' -  Waive';
                if(glEntry.Id == null){
                    glEntry.Charge_Waived__c = true;
                }
            }
            
            System.debug(LoggingLevel.ERROR, '^^^ clleaseTxnType : ' + clleaseTxnType);
            System.debug(LoggingLevel.ERROR, '^^^ clleaseTxnSubType : ' + clleaseTxnSubType);
            
            // throw new MyException('Test');
            
            // Skip the process incase Transaction Type is null or Empty
            if(clleaseTxnType == null || clleaseTxnType == '') {
                remark = 'Movement Codes are not valid for Transaction Type = null...';
                continue;
            } 

            // Incase of Charge chagne it to BILLING as 
            if(clleaseTxnType == 'CHARGE') {
                clleaseTxnType = 'BILLING';
            }

            System.debug(LoggingLevel.ERROR, 'State: '+contractsMap.get(glEntry.cllease__Contract__c).State__c);
            // Retrieve Movement Record for
            Movement_Code__c movementCode;
            System.debug(Logginglevel.ERROR, '^^^ clleaseTxnSubType : ' + clleaseTxnSubType);
            if(clleaseTxnSubType == null)
                clleaseTxnSubType = glEntry.CL_Lease_Transaction_Type__c;
            if(!clleaseTxnSubType.containsIgnoreCase('TAX')) {
                movementCode = txnMovementCodesMap.get(clleaseTxnType);

            } else if(clleaseTxnSubType.containsIgnoreCase('TAX')
                && contractsMap.get(glEntry.cllease__Contract__c) !=null
                && contractsMap.get(glEntry.cllease__Contract__c).State__c != null){
                movementCode = taxMovementCodesMap.get(contractsMap.get(glEntry.cllease__Contract__c).State__c);
            
            }

            System.debug(LoggingLevel.ERROR, 'movementCode: '+movementCode);
            //Skip the process incase of movement code is null for given transaction
            if(movementCode != null) {
                String glPmtAccountString = movementCode.Payment_Tax_Eligible_GL_Account_Codes__c;
                String glBillAccountString = movementCode.Billing_Tax_Eligible_GL_Account_Codes__c;

                System.debug(LoggingLevel.ERROR, 'glPmtAccountString: '+glPmtAccountString);
                System.debug(LoggingLevel.ERROR, 'glBillAccountString: '+glBillAccountString);

                // a. Processing for GL Debit Account 
                if(glAccountsMap.get(glEntry.cllease__Debit_GL_Account__c) != null
                    && glAccountsMap.get(glEntry.cllease__Debit_GL_Account__c).Is_Movement_Code_Eligible__c) {
                    
                    String glDebitAccountCodeString = glEntry.cllease__Debit_GL_Account_Code__c;
                    System.debug(LoggingLevel.ERROR, 'glDebitAccountCodeString: '+glDebitAccountCodeString);
                    // Assinging Movement Code for 
                    if(clLeaseTxnType == 'BOOKING'
                        || clLeaseTxnType == 'ACCRUAL'
                        || clLeaseTxnType == 'TERMINATION'
                        || clLeaseTxnType == 'RESTRUCTURE') {               
                        glEntry.Movement_Code_Dr__c = movementCode.Movement_Code__c;

                    } else if(clLeaseTxnType == 'PAYMENT') {
                        if(glEntry.cllease__Transaction_type1__c == 'REVERSAL'){
                            glEntry.cllease__Transaction_Description__c  += '- Reversal';
                        }
                        if(clleaseTxnSubType.containsIgnoreCase('tax')
                            && glPmtAccountString !=null 
                            && glDebitAccountCodeString !=null
                            && glPmtAccountString.containsIgnoreCase(glDebitAccountCodeString)) {
                            glEntry.Movement_Code_Dr__c = contractsMap.get(glEntry.cllease__Contract__c).State__c;

                        } else if(!clleaseTxnSubType.containsIgnoreCase('tax')){
                            glEntry.Movement_Code_Dr__c = movementCode.Movement_Code__c;

                        }

                    } else if(clLeaseTxnType == 'BILLING'
                        || clLeaseTxnType == 'CHARGE') {
                        if(clleaseTxnSubType.containsIgnoreCase('tax')
                            && glBillAccountString !=null 
                            && glDebitAccountCodeString !=null
                            && glBillAccountString.containsIgnoreCase(glDebitAccountCodeString)) {
                            glEntry.Movement_Code_Dr__c = contractsMap.get(glEntry.cllease__Contract__c).State__c;

                        } else if(!clleaseTxnSubType.containsIgnoreCase('tax')) {
                            glEntry.Movement_Code_Dr__c = movementCode.Movement_Code__c;

                        }
                    }
                    remark = 'Successfully Updated Movement Codes...';  

                }

                // b. Processing for GL Credit Account 
                if(glAccountsMap.get(glEntry.cllease__Credit_GL_Account__c) != null
                    && glAccountsMap.get(glEntry.cllease__Credit_GL_Account__c).Is_Movement_Code_Eligible__c) {

                    String glCreditAccountCodeString = glEntry.cllease__Credit_GL_Account_Code__c;
                    System.debug(LoggingLevel.ERROR, 'glCreditAccountCodeString: '+glCreditAccountCodeString);
                    // Assinging Movement Code for 
                    if(clLeaseTxnType == 'BOOKING'
                        || clLeaseTxnType == 'ACCRUAL'
                        || clLeaseTxnType == 'TERMINATION'
                        || clLeaseTxnType == 'RESTRUCTURE') {               
                        glEntry.Movement_Code_Cr__c = movementCode.Movement_Code__c;

                    } else if(clLeaseTxnType == 'PAYMENT') {
                        if(glEntry.cllease__Transaction_type1__c == 'REVERSAL'){
                            glEntry.cllease__Transaction_Description__c  += ' - Reversal';
                        }
                        if(clleaseTxnSubType.containsIgnoreCase('tax')
                            && glPmtAccountString !=null 
                            && glCreditAccountCodeString !=null
                            && glPmtAccountString.containsIgnoreCase(glCreditAccountCodeString)) {
                            glEntry.Movement_Code_Cr__c = contractsMap.get(glEntry.cllease__Contract__c).State__c;

                        } else if(!clleaseTxnSubType.containsIgnoreCase('tax')){
                            glEntry.Movement_Code_Cr__c = movementCode.Movement_Code__c;

                        }

                    } else if(clLeaseTxnType == 'BILLING'
                        || clLeaseTxnType == 'CHARGE') {
                        if(clleaseTxnSubType.containsIgnoreCase('tax')
                            && glBillAccountString !=null 
                            && glCreditAccountCodeString !=null
                            && glBillAccountString.containsIgnoreCase(glCreditAccountCodeString)) {
                            glEntry.Movement_Code_Cr__c = contractsMap.get(glEntry.cllease__Contract__c).State__c;

                        } else if(!clleaseTxnSubType.containsIgnoreCase('tax')) {
                            glEntry.Movement_Code_Cr__c = movementCode.Movement_Code__c;

                        }
                    }
                }
                remark = 'Successfully Updated Movement Codes...';  
            }

            // Company details
            cllease__Office_Name__c currentCompany = companiesMap.get(glEntry.cllease__Company__c);

            // Updating 7 segment code 
            glEntry.Movement_Code_DR_Segment__c = currentCompany.Dll_Seg1_Company__c +'.'+
                                                currentCompany.Dll_Seg2_Business_Unit__c +'.'+
                                                currentCompany.Dll_Seg3_Department__c +'.'+
                                                glEntry.cllease__Debit_GL_Account_Code__c +'.'+
                                                glEntry.Movement_Code_Dr__c +'.'+
                                                currentCompany.Dll_Seg6__c +'.'+
                                                currentCompany.Dll_Seg7__c; 

            glEntry.Movement_Code_CR_Segment__c = currentCompany.Dll_Seg1_Company__c +'.'+
                                                currentCompany.Dll_Seg2_Business_Unit__c +'.'+
                                                currentCompany.Dll_Seg3_Department__c +'.'+
                                                glEntry.cllease__Credit_GL_Account_Code__c +'.'+
                                                glEntry.Movement_Code_Cr__c +'.'+
                                                currentCompany.Dll_Seg6__c +'.'+
                                                currentCompany.Dll_Seg7__c;
            
            glEntry.Remark__c = remark;
            // ENd of single GL processing
        }
    }
    System.debug(LoggingLevel.ERROR, 'Ending GL Account Entry Processing Completed for Movement Code update...');
    // End of all GL Processings 
}