public without sharing class CreateServiceCharge{
    public static final String SERVICE_FEE_NAME = 'Service Fees';
    public static Decimal term = 0,EscalationFrequency = 0,c = 0,Amount = 0,EscalationValue =0,DividentValue = 100,result = 0,ProRatedValue = 0,ScaledValue = 0;
    public static list<Application_Fee__c> listApplicationFee = new list<Application_Fee__c>();
    public static list<Application_Fee__c> listApplicationFees = new list<Application_Fee__c>();
    public static list<Application_Fee__c> listProratedApplicationFees = new list<Application_Fee__c>();
    public static Date myDate;
//Invocable method to get the id from Process Builder
    @InvocableMethod
     public static void invokeCreatServiceFee(List<Application_Fee__c> feeid) {
        
        Set<Application_Fee__c> appfeeset = new set<Application_Fee__c>();
        //Checking the Application Fee is parent Record or Not allowing it to Create Child record to Escalat as per Escalation Frequency
        for(Application_Fee__c fe:feeid){
        if(fe.Parent_id__c == null || fe.Parent_id__c == '' || fe.Parent_Application_Fee__c == '' || fe.Parent_Application_Fee__c == null)
        appfeeset.add(fe);  
        }
        //Taking all the Matched values in Set and Passing the Values to ServiceChargeEscalation
        if(appfeeset.size() > 0)
        ServiceChargeEscalation(appfeeset);   
    }
    
    public static void ServiceChargeEscalation(Set<Application_Fee__c> appfeeobj)
    {
       try{
            System.debug('****the id ot th value is appFeeValues******'+appfeeobj);
            List<Application_Fee__c> childApplicationFee = new List<Application_Fee__c>();
           //putting all the parent and associated  Child Records in Map And Looping through it to update the records                                                      
            map<id,Application_Fee__c> AppfeeWithChilds = new Map<id,Application_Fee__c>([SELECT id,name,
                                                                                             Fee__c,
                                                                                             Fee__r.name,
                                                                                             Fee__r.id,
                                                                                             ProrateAmount__c,
                                                                                             Application__r.id,
                                                                                             Parent_id__c,
                                                                                             Number_of_Payments__c,
                                                                                             Frequency__c,
                                                                                             Service_Escalate__c,
                                                                                             Escalation_Value__c,
                                                                                             Escalation_Type__c,
                                                                                             Escalation_Frequency__c,
                                                                                             Escalate_Service_On__c,
                                                                                             Calculating_Frequency__c,
                                                                                             Parent_Application_Fee__c,
                                                                                             Application__r.genesis__Term__c,
                                                                                             Application__r.genesis__Expected_First_Payment_Date__c,
                                                                                             Application__r.Total_Equipment_Cost__c,
                                                                                             Equipment__r.genesis__Estimated_Selling_Price__c,
                                                                                             Application__r.Pre_Upfront_Tax_Payment_Amount__c,
                                                                                             Amount__c,
                                                                                             Start_Date__c,
                                                                                             Prorate_Per_Asset__c,
                                                                                             Application__c,
                                                                                             Number_of_Terms__c,
                                                                                             Equipment__r.id,
                                                                                        (SELECT id,
                                                                                         name,
                                                                                         Fee__c,
                                                                                         Fee__r.name,
                                                                                         Number_of_Payments__c,
                                                                                         Parent_id__c,
                                                                                         Frequency__c,
                                                                                         ProrateAmount__c,
                                                                                         Application__r.Total_Equipment_Cost__c,
                                                                                         Parent_Application_Fee__c,
                                                                                         Equipment__r.genesis__Estimated_Selling_Price__c,
                                                                                         Application__r.Pre_Upfront_Tax_Payment_Amount__c,
                                                                                         Service_Escalate__c,
                                                                                         Escalation_Value__c,
                                                                                         Prorate_Per_Asset__c,
                                                                                         Escalation_Type__c,
                                                                                         Escalation_Frequency__c,
                                                                                         Escalate_Service_On__c,
                                                                                         Application__r.genesis__Term__c,
                                                                                         Calculating_Frequency__c,
                                                                                         Amount__c,
                                                                                         Start_Date__c,
                                                                                         Number_of_Terms__c,
                                                                                         Application__c,
                                                                                         Equipment__c 
                                                                                      FROM Application_Fees__r) 
                                                                                 FROM Application_Fee__c 
                                                                                WHERE ID IN:appfeeobj Limit 200]);
         System.debug('*****KEYS*****'+AppfeeWithChilds.keyset());
         //Separating the parent and Child Records putting the Child Records in a List//
         for (ID appFees : AppfeeWithChilds.keyset())
        {
                Application_Fee__c appFeeValues = new Application_Fee__c();
                appFeeValues = AppfeeWithChilds.get(appFees);
                System.debug('****appvalues*****'+appFeeValues.Application_Fees__r);
                if(appFeeValues.Application_Fees__r.size()>0)
                {
                    childApplicationFee = appFeeValues.Application_Fees__r;
                    System.debug('*****childApplicationFee*******'+childApplicationFee);
                }
            
            System.debug('*** childApplicationFee****'+childApplicationFee.size());
            
            //Child Records size equal 0  Creating the Child Records for the Parent Fee.//          
            if((childApplicationFee.size() == 0 && appFeeValues != null && appFeeValues.Fee__r.Name == SERVICE_FEE_NAME && !appFeeValues.Prorate_Per_Asset__c) && (appFeeValues.Parent_id__c == null || appFeeValues.Parent_Application_Fee__c == null)){
            System.debug('i entered into the insert operation ******'+appFeeValues);
                    if(appFeeValues.Service_Escalate__c == 'YES' && appFeeValues.Fee__r.Name == SERVICE_FEE_NAME)
                    {
                        
                        myDate = appFeeValues.Start_Date__c;
                       
                        term = appFeeValues.Number_of_Terms__c; 
                        if(term == null) { term = 0; }
                        System.debug('*****term*****'+term);
                        Amount = appFeeValues.Amount__c; 
                        EscalationValue = appFeeValues.Escalation_Value__c;
                        EscalationFrequency = appFeeValues.Calculating_Frequency__c;
                        System.debug('****appFeeValues.Calculating_Frequency__c***'+appFeeValues.Calculating_Frequency__c);
                        result = term / EscalationFrequency;
                        c = Math.floor(result);
                        
                        System.debug('****Amount****'+Amount);
    
                        for(integer i=0;i<c-1;i++){
                            System.debug('****i****'+i);
                            
                            myDate = cllease.DateUtil.getNextCycleDate(
                                                                           myDate, 
                                                                           myDate.day(),
                                                                           cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                                           appFeeValues.Calculating_Frequency__c.intValue());
                            Application_Fee__c appfee     = new Application_Fee__c();
                            appfee.Application__c         = appFeeValues.Application__r.id;
                            appfee.Frequency__c           = appFeeValues.Frequency__c;
                            appfee.Fee__c                 = appFeeValues.Fee__r.id;
                            appfee.Service_Escalate__c    = appFeeValues.Service_Escalate__c;
                            appfee.Escalation_Value__c    = appFeeValues.Escalation_Value__c;
                            appfee.Escalation_Type__c     = appFeeValues.Escalation_Type__c;
                            appfee.Escalate_Service_On__c = appFeeValues.Escalate_Service_On__c;
                            appfee.Parent_id__c           = appFeeValues.id;
                            appfee.Parent_Application_Fee__c = appFeeValues.id;
                            appfee.Equipment__c           = appFeeValues.Equipment__r.id;
                            
                            if(appFeeValues.Escalation_Type__c == 'Percent %' && appFeeValues.Escalate_Service_On__c == 'Total Payment'){
                            
                                Amount                        = ((appFeeValues.Application__r.Pre_Upfront_Tax_Payment_Amount__c + Amount)*(1+EscalationValue/DividentValue))-appFeeValues.Application__r.Pre_Upfront_Tax_Payment_Amount__c;
                                appfee.Amount__c              = Amount;
                            }
                            else if(appFeeValues.Escalation_Type__c == 'Percent %' && appFeeValues.Escalate_Service_On__c == 'Service Only'){
                            
                                    appfee.Amount__c              = Amount += (EscalationValue/DividentValue)*Amount;
                            }
                           
                            appfee.Number_of_Payments__c  = appFeeValues.Calculating_Frequency__c;
                            appfee.Start_Date__c          = myDate;
                            appfee.Escalation_Frequency__c = appFeeValues.Escalation_Frequency__c;
    
                            listApplicationFees.add(appfee);
                            System.debug('***listApplicationFees****'+listApplicationFees.size());
                            System.debug('***listApplicationFeesfields*****'+listApplicationFees);
                            
                            System.debug('***the value is****** '+Amount.setScale(2));
                        }
                        System.debug('*****c***'+c);
                        result = term - (EscalationFrequency * c);
                        if(result > 0)
                        {
                            myDate = cllease.DateUtil.getNextCycleDate(
                                                                           myDate, 
                                                                           myDate.day(),
                                                                           cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                                           result.intValue());
                            Application_Fee__c appfee     = new Application_Fee__c();
                            appfee.Application__c         = appFeeValues.Application__r.id;
                            appfee.Frequency__c           = appFeeValues.Frequency__C;
                            appfee.Fee__c                 = appFeeValues.Fee__r.id;
                            appfee.Service_Escalate__c    = appFeeValues.Service_Escalate__c;
                            appfee.Escalation_Value__c    = appFeeValues.Escalation_Value__c;
                            appfee.Parent_id__c           = appFeeValues.id;
                            appfee.Parent_Application_Fee__c = appFeeValues.id;
                            appfee.Equipment__c           = appFeeValues.Equipment__r.id;
                            
                            if(appFeeValues.Escalation_Type__c == 'Percent %' && appFeeValues.Escalate_Service_On__c == 'Total Payment'){
                            
                            Amount                        = ((appFeeValues.Application__r.Pre_Upfront_Tax_Payment_Amount__c + Amount)*(1+EscalationValue/DividentValue))-appFeeValues.Application__r.Pre_Upfront_Tax_Payment_Amount__c;
                            appfee.Amount__c              = Amount;                       
                            
                            }
                            else if(appFeeValues.Escalation_Type__c == 'Percent %' && appFeeValues.Escalate_Service_On__c == 'Service Only'){
                            
                                    appfee.Amount__c              = Amount += (EscalationValue/DividentValue)*Amount;
                            }
                           
                            
                            appfee.Number_of_Payments__c  = result;
                            appfee.Escalation_Type__c     = appFeeValues.Escalation_Type__c;
                            appfee.Escalate_Service_On__c = appFeeValues.Escalate_Service_On__c;
                            appfee.Start_Date__c          = myDate;
                            appfee.Escalation_Frequency__c = appFeeValues.Escalation_Frequency__c;
     
    
                            listApplicationFees.add(appfee);
    
                            System.debug('***the value'+Amount.setScale(2));
                            System.debug('***listApplicationFees****'+listApplicationFees.size());
                        }
                        
                    }
            
            }
            //Creating the Child records for ProratePerAsset Parent Record if Child records Count is zero//
            else if((childApplicationFee.size() == 0 && appFeeValues != null && appFeeValues.Fee__r.Name == SERVICE_FEE_NAME && appFeeValues.Prorate_Per_Asset__c) && (appFeeValues.Parent_id__c == null || appFeeValues.Parent_Application_Fee__c == null)){
                    System.debug('****i entered into prorated Value*****');
                    System.debug('****appFeeValues*****'+appFeeValues);
                    if(appFeeValues.Service_Escalate__c == 'YES' && appFeeValues.Fee__r.Name == SERVICE_FEE_NAME)
                    {
                        
                        myDate = appFeeValues.Start_Date__c;
                        
                        term = appFeeValues.Number_of_Terms__c; 
                        if(term == null) { term = 0; }
                        System.debug('*****term*****'+term);
                        Amount = appFeeValues.ProrateAmount__c;
                        EscalationValue = appFeeValues.Escalation_Value__c;
                        EscalationFrequency = appFeeValues.Calculating_Frequency__c;
                        System.debug('****appFeeValues.Calculating_Frequency__c***'+appFeeValues.Calculating_Frequency__c);
                        result = term / EscalationFrequency;
                        c = Math.floor(result);
                       
                        
    
                        for(integer i=0;i<c-1;i++){
                            System.debug('****i****'+i);
                            
                            myDate = cllease.DateUtil.getNextCycleDate(
                                                                           myDate, 
                                                                           myDate.day(),
                                                                           cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                                           appFeeValues.Calculating_Frequency__c.intValue());
                            Application_Fee__c appfee   = new Application_Fee__c();
                            appfee.Application__c            = appFeeValues.Application__r.id;
                            appfee.Frequency__c              = appFeeValues.Frequency__c;
                            appfee.Fee__c                    = appFeeValues.Fee__r.id;
                            appfee.Service_Escalate__c       = appFeeValues.Service_Escalate__c;
                            appfee.Escalation_Value__c       = appFeeValues.Escalation_Value__c;
                            appfee.Escalation_Type__c        = appFeeValues.Escalation_Type__c;
                            appfee.Escalate_Service_On__c    = appFeeValues.Escalate_Service_On__c;
                            appfee.Parent_id__c              = appFeeValues.id;
                            appfee.Parent_Application_Fee__c = appFeeValues.id;
                            appfee.Equipment__c              = appFeeValues.Equipment__r.id;
                            
                            
                            if(appFeeValues.Escalation_Type__c == 'Percent %' && appFeeValues.Escalate_Service_On__c == 'Total Payment'){
                            
                                
                                Amount                        = ((appFeeValues.Application__r.Pre_Upfront_Tax_Payment_Amount__c + Amount)*(1+EscalationValue/DividentValue))-appFeeValues.Application__r.Pre_Upfront_Tax_Payment_Amount__c;
                                appfee.ProrateAmount__c       =  Amount;
                                appfee.Amount__c              = (Amount)*(appfeeValues.Equipment__r.genesis__Estimated_Selling_Price__c/appfeeValues.Application__r.Total_Equipment_Cost__c).setScale(4);                
                                
                            }
                            else if(appFeeValues.Escalation_Type__c == 'Percent %' && appFeeValues.Escalate_Service_On__c == 'Service Only'){
                                    
                                    Amount                        = (Amount)*(1+EscalationValue/DividentValue);
                                    appfee.ProrateAmount__c       = Amount;
                                    appfee.Amount__c              = (Amount)*(appfeeValues.Equipment__r.genesis__Estimated_Selling_Price__c/appfeeValues.Application__r.Total_Equipment_Cost__c).setScale(4);
                            }
                           
                            appfee.Number_of_Payments__c  = appFeeValues.Calculating_Frequency__c;
                            appfee.Start_Date__c          = myDate;
                            appfee.Escalation_Frequency__c = appFeeValues.Escalation_Frequency__c;
    
                            listProratedApplicationFees.add(appfee);
                            
                        }
                        System.debug('*****c***'+c);
                        result = term - (EscalationFrequency * c);
                        if(result > 0)
                        {
                            myDate = cllease.DateUtil.getNextCycleDate(
                                                                           myDate, 
                                                                           myDate.day(),
                                                                           cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                                           result.intValue());
                            Application_Fee__c appfee     = new Application_Fee__c();
                            appfee.Application__c         = appFeeValues.Application__r.id;
                            appfee.Frequency__c           = appFeeValues.Frequency__C;
                            appfee.Fee__c                 = appFeeValues.Fee__r.id;
                            appfee.Service_Escalate__c    = appFeeValues.Service_Escalate__c;
                            appfee.Escalation_Value__c    = appFeeValues.Escalation_Value__c;
                            appfee.Parent_id__c           = appFeeValues.id;
                            appfee.Parent_Application_Fee__c = appFeeValues.id;
                            appfee.Equipment__c           = appFeeValues.Equipment__r.id;
                            
                            if(appFeeValues.Escalation_Type__c == 'Percent %' && appFeeValues.Escalate_Service_On__c == 'Total Payment'){
                            
                                Amount                        = ((appFeeValues.Application__r.Pre_Upfront_Tax_Payment_Amount__c + Amount)*(1+EscalationValue/DividentValue))-appFeeValues.Application__r.Pre_Upfront_Tax_Payment_Amount__c;
                                appfee.ProrateAmount__c       =  Amount;
                                appfee.Amount__c              = (Amount)*(appfeeValues.Equipment__r.genesis__Estimated_Selling_Price__c/appfeeValues.Application__r.Total_Equipment_Cost__c).setScale(4);                
                            
                            }
                            else if(appFeeValues.Escalation_Type__c == 'Percent %' && appFeeValues.Escalate_Service_On__c == 'Service Only'){
                            
                                    Amount                        = (Amount)*(1+EscalationValue/DividentValue);
                                    appfee.ProrateAmount__c       = Amount;
                                    appfee.Amount__c              = (Amount)*(appfeeValues.Equipment__r.genesis__Estimated_Selling_Price__c/appfeeValues.Application__r.Total_Equipment_Cost__c).setScale(4);
                                                   
                             }                      
                          
                            
                            appfee.Number_of_Payments__c  = result;
                            appfee.Escalation_Type__c     = appFeeValues.Escalation_Type__c;
                            appfee.Escalate_Service_On__c = appFeeValues.Escalate_Service_On__c;
                            appfee.Start_Date__c          = myDate;
                            appfee.Escalation_Frequency__c = appFeeValues.Escalation_Frequency__c;
    
    
                            listProratedApplicationFees.add(appfee);
    
                            
                        }
                        
                    }
            
                    
                    
            
            
            }
          //Updating the Child records as per the parent Record Update//
          else if(childApplicationFee.size()>0 && !appFeeValues.Prorate_Per_Asset__c && appFeeValues.Fee__r.Name == SERVICE_FEE_NAME && appFeeValues.Service_Escalate__c == 'YES'){
              
              
              myDate = appFeeValues.Start_Date__c;                                                          
              
              term = appFeeValues.Number_of_Terms__c;
              System.debug('*****term*****'+term);
              Amount = appFeeValues.Amount__c;
              EscalationValue = appFeeValues.Escalation_Value__c;
              EscalationFrequency = appFeeValues.Calculating_Frequency__c;
              result = term / EscalationFrequency;
              c = Math.floor(result);
              result = term - (EscalationFrequency * c);
             
              for(Application_Fee__c fee : childApplicationFee){
                        System.debug('***appfee.Parent_id__c***   '+fee.id);    
                        
                                System.debug('****Amount****'+Amount);
                                Application_Fee__c appfee     = new Application_Fee__c();
                                if(fee.Calculating_Frequency__c != fee.Number_of_Payments__c){
                                myDate = cllease.DateUtil.getNextCycleDate(
                                                                           myDate, 
                                                                           myDate.day(),
                                                                           cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                                           fee.Number_of_Payments__c.intValue());
                                   
                                }
                                else{
                                    myDate = cllease.DateUtil.getNextCycleDate(
                                                                           myDate, 
                                                                           myDate.day(),
                                                                           cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                                           fee.Calculating_Frequency__c.intValue());
                                     appfee.Number_of_Payments__c  = appFeeValues.Calculating_Frequency__c;
                                }
                                
                                appfee.id                     = fee.id;
                                appfee.Frequency__c           = fee.Frequency__c;
                                appfee.Service_Escalate__c    = appFeeValues.Service_Escalate__c;
                                appfee.Escalation_Value__c    = appFeeValues.Escalation_Value__c;
                                appfee.Escalation_Type__c     = appFeeValues.Escalation_Type__c;
                                appfee.Escalate_Service_On__c = appFeeValues.Escalate_Service_On__c;
                                appfee.Equipment__c           = appFeeValues.Equipment__c;
                                
                                if(appFeeValues.Escalation_Type__c == 'Percent %' && appFeeValues.Escalate_Service_On__c == 'Total Payment'){
                                    
                                    Amount                        = ((appFeeValues.Application__r.Pre_Upfront_Tax_Payment_Amount__c + Amount)*(1+EscalationValue/DividentValue))-appFeeValues.Application__r.Pre_Upfront_Tax_Payment_Amount__c;
                                    appfee.Amount__c              = Amount;
                                
                                }
                                if(appFeeValues.Escalation_Type__c == 'Percent %' && appFeeValues.Escalate_Service_On__c == 'Service Only'){
                                
                                    appfee.Amount__c              = Amount += (EscalationValue/DividentValue)*Amount;
                                
                                }
                               
                                appfee.Escalation_Type__c     = appFeeValues.Escalation_Type__c;
                                
                                appfee.Escalation_Frequency__c = fee.Escalation_Frequency__c;
                                appfee.Start_Date__c          = myDate;
    
                                listApplicationFee.add(appfee);
                                
                                
                                
                                result = term - (EscalationFrequency * c);
                  
              
                }
                
            }
            //Updating the Child Record as per the Parent Record Update based on Prorate per Asset Value//
            else if(childApplicationFee.size()>0 && appFeeValues.Prorate_Per_Asset__c && appFeeValues.Fee__r.Name == SERVICE_FEE_NAME && appFeeValues.Service_Escalate__c == 'YES' ){
              
              System.debug('****We entered into the Prorated value Update****');
              myDate = appFeeValues.Start_Date__c;                                                          
              
              term = appFeeValues.Number_of_Terms__c;
              System.debug('*****term*****'+term);
              Amount = appFeeValues.ProrateAmount__c;
              EscalationValue = appFeeValues.Escalation_Value__c;
              EscalationFrequency = appFeeValues.Calculating_Frequency__c;
              result = term / EscalationFrequency;
              c = Math.floor(result);
              result = term - (EscalationFrequency * c);    
              for(Application_Fee__c fee : childApplicationFee){
                        System.debug('***appfee.Parent_id__c***   '+fee.id);    
                        
                                System.debug('****Amount****'+Amount);
                                Application_Fee__c appfee     = new Application_Fee__c();
                                if(fee.Calculating_Frequency__c != fee.Number_of_Payments__c){
                                myDate = cllease.DateUtil.getNextCycleDate(
                                                                           myDate, 
                                                                           myDate.day(),
                                                                           cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                                           fee.Number_of_Payments__c.intValue());
                                   
                                }
                                else{
                                    myDate = cllease.DateUtil.getNextCycleDate(
                                                                           myDate, 
                                                                           myDate.day(),
                                                                           cllease.LendingConstants.PAYMENT_FREQ_MONTHLY,
                                                                           fee.Calculating_Frequency__c.intValue());
                                     appfee.Number_of_Payments__c  = appFeeValues.Calculating_Frequency__c;
                                }
                                
               
                                appfee.id                     = fee.id;
                                appfee.Frequency__c           = fee.Frequency__c;
                                appfee.Service_Escalate__c    = appFeeValues.Service_Escalate__c;
                                appfee.Escalation_Value__c    = appFeeValues.Escalation_Value__c;
                                appfee.Escalation_Type__c     = appFeeValues.Escalation_Type__c;
                                appfee.Escalate_Service_On__c = appFeeValues.Escalate_Service_On__c;
                                appfee.Equipment__c           = appFeeValues.Equipment__c;
                                
                                if(appFeeValues.Escalation_Type__c == 'Percent %' && appFeeValues.Escalate_Service_On__c == 'Total Payment'){
                                    
                                    Amount                        = ((appFeeValues.Application__r.Pre_Upfront_Tax_Payment_Amount__c + Amount)*(1+EscalationValue/DividentValue))-appFeeValues.Application__r.Pre_Upfront_Tax_Payment_Amount__c;
                                    appfee.ProrateAmount__c       =  Amount;
                                    appfee.Amount__c              = (Amount)*(appfeeValues.Equipment__r.genesis__Estimated_Selling_Price__c/appfeeValues.Application__r.Total_Equipment_Cost__c).setScale(4);
                                }
                                if(appFeeValues.Escalation_Type__c == 'Percent %' && appFeeValues.Escalate_Service_On__c == 'Service Only'){
                                
                                    Amount                         = (Amount)*(1+EscalationValue/DividentValue);
                                    appfee.ProrateAmount__c        = Amount;
                                    appfee.Amount__c              = (Amount)*(appfeeValues.Equipment__r.genesis__Estimated_Selling_Price__c/appfeeValues.Application__r.Total_Equipment_Cost__c).setScale(4);
                                
                                }
                                
                                appfee.Escalation_Type__c     = appFeeValues.Escalation_Type__c;
                               
                                appfee.Escalation_Frequency__c = fee.Escalation_Frequency__c;
                                appfee.Start_Date__c          = myDate;
    
                                listApplicationFee.add(appfee);
                                
                                
                                
                                result = term - (EscalationFrequency * c);
                  
              
                }
                
            }
        }
        if(listProratedApplicationFees.size()>0){
           upsert listProratedApplicationFees;
        }
        if(listApplicationFees.size()>0){
            insert listApplicationFees;
            }
        if(listApplicationFee.size()>0){
            Update listApplicationFee;
            }
     }
     catch(Exception e){
     
          throw e;

     }    
  }
}