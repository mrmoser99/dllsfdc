trigger TerminationTrigger on Cllease__Lease_Account__c (after update) {
    class myException extends Exception{}
    SavePoint sp = Database.setSavePoint();
    try{
        if(trigger.isUpdate){
            cllease__Lease_Trx_Header__c header = new cllease__Lease_Trx_Header__c();
            List<cllease__Lease_Trx_Lines__c> accrualLines = new List<cllease__Lease_Trx_Lines__c>();
            Date systemDate = cllease.SystemDateUtil.getCurrentSystemDate();
            System.debug(LoggingLevel.ERROR, '^^^ sysDate : ' + systemDate);
            List<Cllease__Lease_Account__c> leaseAccount = trigger.new;
            List<Cllease__Lease_Account__c> leaseOldAccount = trigger.old;
            if(leaseOldAccount[0].cllease__Lease_Status__c != 'TERMINATED' && leaseAccount[0].cllease__Lease_Status__c == 'TERMINATED'){
                System.debug(LoggingLevel.ERROR, '^^^ LeaseAccount : ' + leaseAccount);
                List<cllease__Contract_Fees__c> contractFees = [Select id, 
                                                               cllease__Fee_Definition__c, 
                                                               cllease__Fee_Definition__r.Name, 
                                                               cllease__Fee_Definition__r.clcommon__Amortization_Method__c 
                                                               from cllease__Contract_Fees__c 
                                                               where cllease__Contract__c = : leaseAccount[0].Id
                                                               and cllease__Fee_Definition__r.clcommon__Amortization_Method__c != null];
                Set<Id> feeDefinitionId = new Set<Id>();
                for(cllease__Contract_Fees__c contractFee : contractFees){
                    feeDefinitionId.add(contractFee.cllease__Fee_Definition__c);
                }
                
                System.debug(LoggingLevel.ERROR, '^^^ set of fee definition : ' + feeDefinitionId);
                System.debug(LoggingLevel.ERROR, '^^^ streams : ' + [Select Id, 
                                                                   cllease__Fee_Amount__c, cllease__Date__c, 
                                                                   cllease__Fee_Definition__r.Name,
                                                                   cllease__Transaction_Sub_Type__c
                                                                   from cllease__Fee_Stream__c 
                                                                   where cllease__Contract__c = : leaseAccount[0].Id ]);
                
                List<cllease__Fee_Stream__c> contractFeeStreams = [Select Id, 
                                                                   cllease__Fee_Amount__c, 
                                                                   cllease__Fee_Definition__c,
                                                                   cllease__Transaction_Sub_Type__c
                                                                   from cllease__Fee_Stream__c 
                                                                   where cllease__Contract__c = : leaseAccount[0].Id 
                                                                   and cllease__Fee_Definition__c in :feeDefinitionId
                                                                   and cllease__Date__c > :systemDate];
                Map<Id, Decimal> feeUnaccruedAmount = new Map<Id, Decimal>();
                Map<Id, Id> feeTransactionSubTypeMap = new Map<Id, Id>();
                for(cllease__Fee_Stream__c feeStream : contractFeeStreams){
                    feeTransactionSubTypeMap.put(feeStream.cllease__Fee_Definition__c, feeStream.cllease__Transaction_Sub_Type__c);
                    if(feeUnaccruedAmount.containsKey(feeStream.cllease__Fee_Definition__c)){
                        feeUnaccruedAmount.put(feeStream.cllease__Fee_Definition__c, feeUnaccruedAmount.get(feeStream.cllease__Fee_Definition__c) + feeStream.cllease__Fee_Amount__c);
                    }
                    else{
                        feeUnaccruedAmount.put(feeStream.cllease__Fee_Definition__c, feeStream.cllease__Fee_Amount__c);
                    }
                }
                
                System.debug(LoggingLevel.ERROR, '^^^ FeeAmountMap : ' + feeUnaccruedAmount);
                if(feeUnaccruedAmount.size() > 0){
                   	header.cllease__Contract__c = leaseAccount[0].Id;
                    header.cllease__GL_Posted_Flag__c = FALSE;
                    header.cllease__GL_Transaction_Flag__c = TRUE;
                    header.cllease__Transaction_Type__c = 'ACCRUAL';
                    header.cllease__Transaction_Date__c = cllease.SystemDateUtil.getCurrentSystemDate();
                    header.cllease__Amount__c = 0;
                    Insert header;
                    for(ID feeDefinition : feeUnaccruedAmount.keySet()){
                         header.cllease__Amount__c += feeUnaccruedAmount.get(feeDefinition);
                        //create line
                        cllease__Lease_Trx_Lines__c line = new cllease__Lease_Trx_Lines__c();
                        line.cllease__Trx_Header__c = header.Id;
                        line.cllease__Contract__c = leaseAccount[0].Id;
                        line.cllease__Transaction_Sub_Type__c = feeTransactionSubTypeMap.get(feeDefinition);
                        line.cllease__Transaction_Date__c = cllease.SystemDateUtil.getCurrentSystemDate();
                        line.cllease__Amount__c = feeUnaccruedAmount.get(feeDefinition);
                        accrualLines.add(line);
                    }
                }
                System.debug(LoggingLevel.ERROR, '^^^ AccrualHeader : ' + header);
                System.debug(LoggingLevel.ERROR, '^^^ AccuralLines : ' + accrualLines);
                if(header.Id != null)
                	Update header;
                if(accrualLines.size() > 0)
                	Insert accrualLines;
            }
            
            /* else if(leaseAccount[0].cllease__Yield__c !=Null && leaseOldAccount[0].cllease__Yield__c !=Null && leaseOldAccount[0].cllease__Yield__c !=leaseAccount[0].cllease__Yield__c){
               cllease__Lease_Account__c la =[select id, Gross_Yield__c, Net_Yield__c from cllease__Lease_Account__c where id=: leaseAccount[0].Id];
                decimal y1 = leaseAccount[0].cllease__Yield__c.setScale(2, RoundingMode.HALF_UP);
                decimal y2 =  leaseOldAccount[0].cllease__Yield__c.setScale(2, RoundingMode.HALF_UP); 
                system.debug('yeild1--->' +y1);
                system.debug('yeild2--->' +y2);
                if(y1 != y2){
                    string a = leaseAccount[0].Id;
                    Id leaseAccountID =Id.valueof(a);
                	CustomIRRComputation.computeAllIRR(leaseAccountID);
                }
			} */
        }
    }
    catch(Exception e){
        Database.rollback(sp);
        System.debug(LoggingLevel.ERROR, 'Exception: '+e.getMessage());    
        System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getStackTraceString());
        System.debug(LoggingLevel.ERROR, 'Exception Stack: '+e.getLineNumber());   
        //insert batch process log for exceptions
        insert new cllease__Batch_Process_Log__c(Name = 'TerminationTrigger Creating: ', cllease__Date__c = System.today(),
        cllease__Message__c = 'Error is '+e.getMessage() +' in line number: '+ e.getLineNumber());
        throw new myException('Test');
    }
}