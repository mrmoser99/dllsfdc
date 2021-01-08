trigger VendorPointsAccumulatedPointsAmount on cllease__Lease_Account__c (after Update) {
  Savepoint sp = database.setsavepoint();
  try{
     Decimal totalFeeAmount = 0.00;
     if(Trigger.isUpdate){
        if(Trigger.new[0].cllease__Lease_Status__c=='TERMINATED' && Trigger.new[0].Termination_Date__c!=null){
             cllease__Other_Transaction__c othorTrans = [select id,name,cllease__Lease_Account__c,Accumulated_Points_Amount__c,cllease__Transaction_Type__c  from 
                                                                  cllease__Other_Transaction__c where cllease__Lease_Account__c=:trigger.new[0].id and cllease__Transaction_Type__c='TERMINATION'];
             System.debug('othorTrans =' +othorTrans);                                            
             if(othorTrans!=null){
                Date modifyTerminationDate = Trigger.new[0].Termination_Date__c.addMonths(-1);//system.today().addmonths(6)-1;////system.today().addmonths(6);//
                System.debug('modifyTerminationDate =' +modifyTerminationDate);
                modifyTerminationDate = Date.newInstance(modifyTerminationDate.year(),modifyTerminationDate.month(),date.daysInMonth(modifyTerminationDate.year(),modifyTerminationDate.month()));
        
                List<cllease__Fee_Stream__c> feeStreamList = [select id,name,cllease__Accrued__c,cllease__Contract__c,cllease__Date__c,cllease__Fee_Amount__c from 
                                                         cllease__Fee_Stream__c where cllease__Contract__c=:trigger.new[0].id and cllease__Accrued__c=true
                                                         and cllease__Date__c <=:modifyTerminationDate];
               System.debug('feeStreamList =' +feeStreamList);                                          
               for(integer i=0;i<feeStreamList.size();i++){     
                   totalFeeAmount = totalFeeAmount + feeStreamList[i].cllease__Fee_Amount__c;     
               }
               
                othorTrans.Accumulated_Points_Amount__c = totalFeeAmount;
                System.debug('othorTrans.Accumulated_Points_Amount__c=' +othorTrans.Accumulated_Points_Amount__c);
                
                Update othorTrans;                   
             }
        }
     }
   }catch(Exception ex){
      database.rollback(sp);
      System.debug('Exception : ' + ex + ' Error Message  :' +ex.getMessage());
      Trigger.new[0].addError('Exception :'+ ex.getMessage() + ' LineNumber :' +ex.getLineNumber());
   }
}